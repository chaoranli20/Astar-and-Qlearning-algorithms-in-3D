function [qwaypoints, routelength] = haveyip(yip, arena, alpha, gamma, solar3dim, Q, Display_Data)

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
    
    % �������Ԫ������涨����
    outRangetest = [];
    for i = 1:size(neighbor, 1)
        outRangetest(i) = (neighbor(i,1)<1) || (neighbor(i,1)>100) || (neighbor(i,2)<1) || (neighbor(i,2)>100) || (neighbor(i,3)<1) || (neighbor(i,3)>10+Display_Data(neighbor(i,1), neighbor(i,2)));
    end
    locate = find(outRangetest>0);
    neighbor(locate,:)=[];
    
    % �жϵ����Ƿ񲻿ɴ�
    terr = [];
    for i = 1:size(neighbor, 1)
        terr(i) = arena.arena_m(neighbor(i, 1), neighbor(i, 2), neighbor(i, 3));
    end
    locate = find(terr == -1);
    neighbor(locate,:)=[];
    
    % �����ظ���
    alreadyacc(currstateind, 1)=1; %distance��־λ�ж��Ƿ������ظ���
    neighborIndex = sub2ind([arSizeR arSizeC arSizeZ],neighbor(:,1),neighbor(:,2),neighbor(:,3));
    locate = find(alreadyacc(neighborIndex(:, 1), 1) == 1);
    neighbor(locate,:)=[];
    
    % ��������ͬ�Ĵ���
    if isempty(neighbor)==1%��������ͬ�˳�
        alreadyacc=zeros(arSizeR*arSizeC*arSizeZ, 1);
        routelength = 0;
        break;
    end
    
    % Rֵ�ļ���
    for x=1:size(neighbor, 1)
        distancelast = sqrt((a-arena.des(1))^2 + (b-arena.des(2))^2 + (c-arena.des(3))^2);
        distancenext = sqrt((neighbor(x,1)-arena.des(1))^2 + (neighbor(x,2)-arena.des(2))^2 + (neighbor(x,3)-arena.des(3))^2);
        detah = abs(neighbor(x, 3) - c);
        %distancebetween = sqrt((neighbor(x,1)-a)^2 + (neighbor(x,2)-b)^2 + (neighbor(x,3)-c)^2);
        R(x)=solar3dim(neighbor(x,1), neighbor(x,2), neighbor(x,3)) + 15*(distancelast- distancenext) - 5*detah; % R�ǻ�õ�������ȥ��һ���ĳɱ�
        if neighbor(x, 1)==arena.des(1) && neighbor(x,2)==arena.des(2) && neighbor(x,3)==arena.des(3)
            R(x)=150;
        end
    end
    
    % ����greedyѡ����һ״̬
    if rand < yip
        nextstateset = find(Q(currstateind, :) == max(Q(currstateind, :))); % �����Ƿ�Ӧ��ʹ�������ĵ�һ��ֵ
        nextstate = nextstateset(randi(size(nextstateset,2)));
        nextstateind = qind2sub(nextstate, currstateind);
        [nxtR, nxtC, nxtZ] = ind2sub(size(arena.arena_m), nextstateind);
        x = nxtR - a;
        y = nxtC - b;
        z = nxtZ - c;
        while(arena.arena_m(nxtR, nxtC, nxtZ) == -1 || nextstateind < 1 || nextstateind > 500000 || nxtZ>10+Display_Data(nxtR, nxtC) || x+2>3 ||x+2<1 ||y+2>3 ||y+2<1 ||z+2>3 ||z+2<1)
            num = randi(size(nextstateset,2));
            nextstate = nextstateset(num);
            nextstateind = qind2sub(nextstate, currstateind);
            [nxtR, nxtC, nxtZ] = ind2sub(size(arena.arena_m), nextstateind);
            x = nxtR - a;
            y = nxtC - b;
            z = nxtZ - c;
            nextstateset(num) = [];
            if size(nextstateset, 2)==0 && (arena.arena_m(nxtR, nxtC, nxtZ)==-1 || nextstateind < 1 || nextstateind > 500000 || nxtZ>10+Display_Data(nxtR, nxtC) || x+2>3 ||x+2<1 ||y+2>3 ||y+2<1 ||z+2>3 ||z+2<1)
                break;
            end
        end
        
        if size(nextstateset, 2)==0 && (arena.arena_m(nxtR, nxtC, nxtZ)==-1 || nextstateind < 1 || nextstateind > 500000 || nxtZ>10+Display_Data(nxtR, nxtC) || x+2>3 ||x+2<1 ||y+2>3 ||y+2<1 ||z+2>3 ||z+2<1)
            routelength = 0;
            break;
        end
        
        actionind = sub2ind([3 3 3], x+2, y+2, z+2);
        Q(currstateind, actionind) = -inf;
        qwaypoints(size(qwaypoints, 1)+1,:) = [nxtR, nxtC, nxtZ];
        currstatesub = [nxtR, nxtC, nxtZ];
        R = [];
        
    else
        % ���ѡ����һ��״̬
        randnum = randi(size(neighbor, 1));
        nextstatesub = neighbor(randnum, :);
        qwaypoints(size(qwaypoints, 1)+1, :) = [nextstatesub(1),nextstatesub(2),nextstatesub(3)];
        nextstateind = sub2ind([arSizeR arSizeC arSizeZ],nextstatesub(1),nextstatesub(2),nextstatesub(3));
        r = R(randnum);
        
        % �ҳ���һ��״̬����Ӧaction
        x = nextstatesub(1) - a;
        y = nextstatesub(2) - b;
        z = nextstatesub(3) - c;
        actionind = sub2ind([3 3 3], x+2, y+2, z+2);
        
        % ����Q��
        maxQ=max(Q(nextstateind, :));
        Q(currstateind, actionind)=Q(currstateind, actionind)+alpha*(r+gamma*maxQ-Q(currstateind, actionind));
        currstatesub = nextstatesub;
        R=[];
    end
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