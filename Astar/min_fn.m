function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget)
% ·µ»Ø×îÐ¡fn

temp_array=[];
k=1;
flag=0;
goal_index=0;
for j=1:OPEN_COUNT
    if (OPEN(j,1)==1)
        temp_array(k,:)=[OPEN(j,:) j];
        if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
            flag=1;
            goal_index=j;
        end
        k=k+1;
    end
end
if flag == 1
    i_min=goal_index;
end

if size(temp_array ~= 0)
    [min_fn,temp_min]=min(temp_array(:,10));
    i_min=temp_array(temp_min,11);
else
    i_min=-1;
end