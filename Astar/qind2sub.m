function nextsub = qind2sub(nextState, currState)
% 给出27个nextState中选出的一个，以及当前状态的sub,返回对应变化的m,j,k以及对应sub

[m, j, k] = ind2sub([3 3 3], nextState);
m = m - 2;
j = j - 2;
k = k - 2;
        

nextsub = currState + 100*100*k + 100* j + m;

end