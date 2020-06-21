function [Q, docroutelength, returnpoints, times, maplength, qnumber] = learnQMatrix(arena, alpha, gamma, solar3dim, Display_Data)

[arSizeR, arSizeC, arSizeZ] = size(arena.arena_m);
Q = zeros(arSizeR*arSizeC*arSizeZ, 27);
times = 0;
docroutelength = [];
qnumber = [];

while true
    times = times + 1;
    if length(find(Q~=0)) < 500000
        fprintf('Q����ϡ�裬no greedy qlearning�����У���������%d��\n', times);
        [Q, routelength] = noyip(arena, alpha, gamma, solar3dim, Q, Display_Data);
        qnumber(size(qnumber,1)+1, :) = [times, length(find(Q~=0))];
    else
        fprintf('greedy qlearning�����У���������%d��\n', times) 
        yip = 0.9;
        [qwaypoints, routelength] = haveyip(yip, arena, alpha, gamma, solar3dim, Q, Display_Data);
        if routelength~=0 && size(qwaypoints, 1) <100 && abs(routelength - docroutelength(size(docroutelength, 1), 2)) < 5
            yip = 1;
            [qwaypoints, routelength] = haveyip(yip, arena, alpha, gamma, solar3dim, Q, Display_Data);
            returnpoints = qwaypoints;
            maplength = 0;
            for i = 1:size(qwaypoints, 1)-1
                maplength = maplength + sqrt((qwaypoints(i+1,1)-qwaypoints(i,1))^2 + (qwaypoints(i+1,2)-qwaypoints(i,2))^2);
            end
            break;
        end
    end
    docroutelength(size(docroutelength, 1)+1, :) = [times, routelength];
end