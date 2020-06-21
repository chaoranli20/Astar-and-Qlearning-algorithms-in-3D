function arena = importArena(map, MAX_X, MAX_Y, MAX_Z)

% arena数据结构有六个参数，分别是MAX_X,MAX_Y,MAX_Z,arena_m,src,des
% 意义分别是活动区域范围x,y,z,地图标记矩阵，起点所在位置，终点所在位置
arena.MAX_X = MAX_X;
arena.MAX_Y = MAX_Y;
arena.MAX_Z = MAX_Z;
arena.arena_m = map; 

arena.src = [20, 20, 7];
arena.des = [90, 70, 5];

end
