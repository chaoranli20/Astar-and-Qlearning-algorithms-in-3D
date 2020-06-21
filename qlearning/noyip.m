function [Q, routelength] = noyip(arena, alpha, gamma, solar3dim, Q, Display_Data)

[arSizeR, arSizeC, arSizeZ] = size(arena.arena_m);
alreadyacc = zeros(arSizeR*arSizeC*arSizeZ, 1);
currstatesub = [arena.src(1), arena.src(2), arena.src(3)];
qwaypoints = [arena.src(1), arena.src(2), arena.src(3)];

while true
    currstateind = sub2ind([arSizeR arSizeC arSizeZ], currstatesub(1), currstatesub(2), currstatesub(3));
    [a, b, c] = ind2sub([arSizeR arSizeC arSizeZ], currstateind);
    neighbor = [];
    for i = -1:1:1
        for j = -1:1:1
            for k = -1:1:1
                neighbor(size(neighbor, 1)+1, :) = [a+i, b+j, c+k];
            end
        end
    end
    
    % 检查有无元素溢出规定矩阵
    outRangetest = [];
    for i = 1:size(neighbor, 1)
        outRangetest(i) = (neighbor(i,1)<1) || (neighbor(i,1)>100) || (neighbor(i,2)<1) || (neighbor(i,2)>100) || (neighbor(i,3)<1) || (neighbor(i,3)>10+Display_Data(neighbor(i,1), neighbor(i,2)));
    end
    locate = find(outRangetest>0);
    neighbor(locate,:)=[];
    
    % 判断地形是否不可达
    terr = [];
    for i = 1:size(neighbor, 1)
        terr(i) = arena.arena_m(neighbor(i, 1), neighbor(i, 2), neighbor(i, 3));
    end
    locate = find(terr == -1);
    neighbor(locate,:)=[];
    
    % 不走重复点
    alreadyacc(currstateind, 1)=1; %判断是否走了重复点
    neighborIndex = sub2ind([arSizeR arSizeC arSizeZ],neighbor(:,1),neighbor(:,2),neighbor(:,3));
    locate = find(alreadyacc(neighborIndex(:, 1), 1) == 1);
    neighbor(locate,:)=[];
    
    % 进入死胡同的处理
    if isempty(neighbor)==1%走入死胡同退出
        alreadyacc=zeros(arSizeR*arSizeC*arSizeZ, 1);
        routelength = 0;
        break;
    end
    
    % R值的计算
    for x=1:size(neighbor, 1)
        distancelast = sqrt((a-arena.des(1))^2 + (b-arena.des(2))^2 + (c-arena.des(3))^2);
        distancenext = sqrt((neighbor(x,1)-arena.des(1))^2 + (neighbor(x,2)-arena.des(2))^2 + (neighbor(x,3)-arena.des(3))^2);
        detah = abs(neighbor(x, 3) - c);
        %distancebetween = sqrt((neighbor(x,1)-a)^2 + (neighbor(x,2)-b)^2 + (neighbor(x,3)-c)^2);
        R(x)=solar3dim(neighbor(x,1), neighbor(x,2), neighbor(x,3)) + 15*(distancelast - distancenext) - 5*detah; % R是获得的能量减去这一步的成本
        if neighbor(x, 1)==arena.des(1) && neighbor(x,2)==arena.des(2) && neighbor(x,3)==arena.des(3)
            R(x)=150;
        end
    end
    
    % 随机选择下一个状态
    randnum = randi(size(neighbor, 1));
    nextstatesub = neighbor(randnum, :);
    qwaypoints(size(qwaypoints, 1)+1, :) = [nextstatesub(1),nextstatesub(2),nextstatesub(3)];
    nextstateind = sub2ind([arSizeR arSizeC arSizeZ],nextstatesub(1),nextstatesub(2),nextstatesub(3));
    r = R(randnum);
    
    % 找出下一个状态的相应action
    x = nextstatesub(1) - a;
    y = nextstatesub(2) - b;
    z = nextstatesub(3) - c;
    actionind = sub2ind([3 3 3], x+2, y+2, z+2);
    
    % 更新Q表
    maxQ=max(Q(nextstateind, :));
    Q(currstateind, actionind)=Q(currstateind, actionind)+alpha*(r+gamma*maxQ-Q(currstateind, actionind));
    currstatesub = nextstatesub;
    R=[];
    if currstatesub(1)==arena.des(1) && currstatesub(2)==arena.des(2) && currstatesub(3)==arena.des(3)
        alreadyacc=zeros(arSizeR*arSizeC*arSizeZ, 1);
        routelength = 0;
        for i = 1:size(qwaypoints, 1)-1
            routelength = routelength + sqrt((qwaypoints(i+1,1)-qwaypoints(i,1))^2 + (qwaypoints(i+1,2)-qwaypoints(i,2))^2 + (qwaypoints(i+1,3)-qwaypoints(i,3))^2);
        end
        break;
    end
end
end