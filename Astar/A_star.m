function [waypoints, routelength] = A_star(MAX_X,MAX_Y,MAX_Z,xval,yval,zval,xTarget,yTarget,zTarget,CLOSED,Display_Data,solar3dim)

xStart = xval;
yStart = yval;
zStart = zval;
waypoints = [];
% open�����ݽṹ
% IS ON LIST 1/0 | X val | Y val | Z val | Parent X val | Parent Y val | Parent Z val | g(n) | h(n) ��������| f(n)|
OPEN=[];
% closed�����ݽṹ
% X val | Y val | Z val |
CLOSED_COUNT=size(CLOSED,1); % closed���Ĵ�С
% �������Ϊ��һ���㣬NodeΪ��ǰ�㣬FNodeΪ���ڵ�
xNode=xval;
yNode=yval;
zNode=zval;
xFNode = xval;
yFNode = yval;
zFNode = zval;
OPEN_COUNT=1; % open����С
path_cost=0; % gn����㵽ָ������
goal_distance=distanced(xNode,yNode,zNode,xTarget,yTarget,zTarget); % hn��ָ�������յ�
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance); % insert_open����open_list�ṹ��һ�����飬��������OPEN��
OPEN(OPEN_COUNT,1)=0; % �������Ϊ����OPEN���У�����Close��
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
HavePath=1; % �Ƿ���·����1�У�0��

while((xNode ~= xTarget || yNode ~= yTarget || zNode ~= zTarget) && HavePath == 1)
    
    % �ѵ�ǰ����Χ�Ŀ��е����open��
    exp_array=expand_array(xFNode,yFNode,zFNode,xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z,Display_Data,solar3dim);
    exp_count=size(exp_array,1);
    %OPEN�ṹ
    %--------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Z val |Parent X val |Parent Y val |Parent Z val |g(n) |h(n)|f(n)|
    %--------------------------------------------------------------------------
    %EXPANDED�ṹ
    %--------------------------------
    %|X val |Y val |Z val |g(n) |h(n)|f(n)|
    %--------------------------------
    for i=1:exp_count
        flag=0; % �ж�exp_array�нڵ��ڲ���OPEN�б��У�0���ڣ�1��
        for j=1:OPEN_COUNT
            if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) && exp_array(i,3) == OPEN(j,4) && OPEN(j,1)==1) % �����չ�����OPEN���У�����OPEN��
                OPEN(j,10)=min(OPEN(j,10),exp_array(i,6));
                if OPEN(j,10)== exp_array(i,6)
                    OPEN(j,5)=xNode;
                    OPEN(j,6)=yNode;
                    OPEN(j,7)=zNode;
                    OPEN(j,8)=exp_array(i,4);
                    OPEN(j,9)=exp_array(i,5);
                end
                flag=1;
            end
        end
        if flag == 0
            OPEN_COUNT = OPEN_COUNT+1;
            OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
        end
    end
    
    index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget); % ��Сfn�����open���е����������û�о���û·���ˣ�ֵΪ-1
    if (index_min_node ~= -1)
        xNode=OPEN(index_min_node,2);
        yNode=OPEN(index_min_node,3);
        zNode=OPEN(index_min_node,4);
        xFNode=OPEN(index_min_node,5);
        yFNode=OPEN(index_min_node,6);
        zFNode=OPEN(index_min_node,7);
        path_cost=OPEN(index_min_node,8);
        CLOSED_COUNT=CLOSED_COUNT+1;
        CLOSED(CLOSED_COUNT,1)=xNode;
        CLOSED(CLOSED_COUNT,2)=yNode;
        CLOSED(CLOSED_COUNT,3)=zNode;
        OPEN(index_min_node,1)=0;
    else
        HavePath=0;
    end
end

i=size(CLOSED,1);
Optimal_path=[];
xval=CLOSED(i,1);
yval=CLOSED(i,2);
zval=CLOSED(i,3);
i=1;
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
Optimal_path(i,3)=zval;
i=i+1;

if ( (xval == xTarget) && (yval == yTarget) && (zval == zTarget))
    parent_x=OPEN(node_index(OPEN,xval,yval,zval),5);
    parent_y=OPEN(node_index(OPEN,xval,yval,zval),6);
    parent_z=OPEN(node_index(OPEN,xval,yval,zval),7);
    
    while( parent_x ~= xStart || parent_y ~= yStart || parent_z ~= zStart)
        Optimal_path(i,1) = parent_x;
        Optimal_path(i,2) = parent_y;
        Optimal_path(i,3) = parent_z;
        inode=node_index(OPEN,parent_x,parent_y,parent_z);
        parent_x=OPEN(inode,5);
        parent_y=OPEN(inode,6);
        parent_z=OPEN(inode,7);
        i=i+1;
    end
    
    if( parent_x == xStart && parent_y == yStart && parent_z == zStart)
        Optimal_path(i,1) = parent_x;
        Optimal_path(i,2) = parent_y;
        Optimal_path(i,3) = parent_z;
    end
    
    waypoints = Optimal_path;
    routelength = 0;
    for i = 1:size(waypoints, 1)-1
        routelength = routelength + sqrt((waypoints(i+1,1)-waypoints(i,1))^2 + (waypoints(i+1,2)-waypoints(i,2))^2 + (waypoints(i+1,3)-waypoints(i,3))^2);
    end
else
    fprintf('��·��')
end