function nextsub = qind2sub(nextState, currState)
% ����27��nextState��ѡ����һ�����Լ���ǰ״̬��sub,���ض�Ӧ�仯��m,j,k�Լ���Ӧsub

[m, j, k] = ind2sub([3 3 3], nextState);
m = m - 2;
j = j - 2;
k = k - 2;
        

nextsub = currState + 100*100*k + 100* j + m;

end