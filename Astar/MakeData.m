function  MakeData()
%%%%%%%%制作地形数据
load ('TerrainData.mat');
MAX_X = 100;
MAX_Y = 100;
MAX_Z = 50;
Cut_Data = Final_Data(301:400,101:200);
mesh(double(Cut_Data));
MAX_Final_Data = max(max(Cut_Data));
MIN_Final_Data = min(min(Cut_Data));
for i=1:100
    for j=1:100
        New_Data(i,j) = ceil((Cut_Data(i,j)-MIN_Final_Data)/100); % 朝正无穷大四舍五入，减去最小值可以减少搜索结点
        Display_Data(i,j) = (Cut_Data(i,j)-MIN_Final_Data)/100;
    end
end
%%%%%%%%% Map初始化
% 可以走的区域为2，目标为0，障碍为-1
MAP=2*(ones(MAX_X,MAX_Y,MAX_Z));
for i=1:MAX_X
    for j=1:MAX_Y
        Z_UpData = New_Data(i,j);
        for z = 1:Z_UpData
            MAP(i,j,z) = -1;
        end
    end
end
%%%%%%%%输入异常气象区域信息
CLOSED = [];
k = 1;
c2 = size(CLOSED,1);
for i_z=1:50
    for i_x=1:100
        for i_y=1:100
            flag = 1;
            Length = (i_x-60)^2 + (i_y-70)^2;            
            for c1=1:c2
                if (i_x == CLOSED(c1,1) && i_y == CLOSED(c1,2) && i_z == CLOSED(c1,3))
                    flag = 0;
                end
            end
            if Length <= 56.25 && flag == 1
                Threaten_Weather(k,1)=i_x;
                Threaten_Weather(k,2)=i_y;
                Threaten_Weather(k,3)=i_z;
                k = k+1;
            end
        end
    end
end
%%%%%%%%%%生成太阳辐射数据
solar2dim = 3.491 + (4.491-3.491) * rand(100,100);
surf(solar2dim(1:100,1:100)','linestyle','none');
xlabel('X Points','FontWeight', 'bold');
ylabel('Y Points','FontWeight', 'bold');
title('kwh/kwp/day','FontWeight', 'bold');
set(gca,'fontsize',9,'fontname','Times New Roman');

view(0, 90);
solar2dim = solar2dim./4.491;
solar3dim = [];
for i = 1:50
    solar3dim(:, :, i) = solar2dim;
end
save('MapData.mat','MAX_X','MAX_Y','MAX_Z','MAP','CLOSED','Final_Data','Display_Data','Threaten_Weather','solar3dim');

end
