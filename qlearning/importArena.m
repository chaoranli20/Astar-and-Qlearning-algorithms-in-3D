function arena = importArena(map, MAX_X, MAX_Y, MAX_Z)

% arena���ݽṹ�������������ֱ���MAX_X,MAX_Y,MAX_Z,arena_m,src,des
% ����ֱ��ǻ����Χx,y,z,��ͼ��Ǿ����������λ�ã��յ�����λ��
arena.MAX_X = MAX_X;
arena.MAX_Y = MAX_Y;
arena.MAX_Z = MAX_Z;
arena.arena_m = map; 

arena.src = [20, 20, 7];
arena.des = [90, 70, 5];

end
