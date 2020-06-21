function exp_array=expand_array(nodef_x,nodef_y,nodef_z,node_x,node_y,node_z,gn,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z,Display_Data,solar3dim)

exp_array=[];
exp_count=1;
c2=size(CLOSED,1);
k_x = node_x - nodef_x;
k_y = node_y - nodef_y;

%%%%%%%%状况1
if (k_x == 1 && k_y == 0) || (k_x == 0 && k_y == 0) % 投影到水平面，当前节点在其父节点的右侧或与其父节点位置相同
    for k= 1 % x上的偏移量
        for j= 1:-1:-1 % y上的偏移量
            for z=1:-1:-1 % z上的偏移量
                if (k~=j || k~=0)  %排除直升可能
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况2
if (k_x == 1&&k_y == -1)
    for k= 1:-1:0
        for j= 0:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况3
if (k_x == 1&&k_y == 1)
    for k= 1:-1:0
        for j= 1:-1:0
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end

%%%%%%%%状况4
if (k_x == 0&&k_y == 1)
    for k= 1:-1:-1
        for j= 1
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况5
if (k_x == 0&&k_y == -1)
    for k= 1:-1:-1
        for j= -1
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况6
if (k_x == -1&&k_y == 1)
    for k= 0:-1:-1
        for j= 1:-1:0
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况7
if (k_x == -1&&k_y == 0)
    for k= -1
        for j= 1:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end
%%%%%%%%状况8
if (k_x == -1&&k_y == -1)
    for k= 0:-1:-1
        for j= 0:-1:-1
            for z=1:-1:-1
                if (k~=j || k~=0)
                    s_x = node_x+k; % 与当前点相邻的点的立方体周围坐标
                    s_y = node_y+j;
                    s_z = node_z+z;
                    if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >Display_Data(s_x, s_y) && s_z <=10+Display_Data(s_x, s_y)))
                        flag=1; %不在CLOSED列表标识位flag=1
                        for c1=1:c2 % c2是CLOSED中元素的个数
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                                flag=0; % 与当前点相邻的在边界范围内的点若已在CLOSED中则标记为flag=0
                            end
                        end
                        if (flag == 1)
                            exp_array(exp_count,1) = s_x;
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            % 计算气象威胁
                            Distance_TW = sqrt((s_x-60)^2 + (s_y-70)^2);
                            if Distance_TW >= 7.5
                                h_ThreatenW = 0;
                            else
                                h_ThreatenW = 1/Distance_TW^4;
                            end
                            % 倾向于太阳辐射多、高度变化不明显、涡流影响因子小的短路径
                            h_value = abs(z);
                            exp_array(exp_count,4) = 1 * gn + 1 * distanced(node_x,node_y,node_z,s_x,s_y,s_z) + h_ThreatenW + h_value - solar3dim(s_x,s_y,s_z);
                            exp_array(exp_count,5) = distanced(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                            exp_count=exp_count+1;
                        end
                    end
                end
            end
        end
    end
end