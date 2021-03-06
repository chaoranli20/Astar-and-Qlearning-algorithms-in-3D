%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A*路径规划算法主函数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all;
close all;

begintime = tic;
fprintf('程序运行中，请稍后\n');
load ('MapData.mat');
% 起点(20,20,7)终点(90,70,5)

[waypoints, routelength] = A_star(MAX_X,MAX_Y,MAX_Z,20,20,7,90,70,5,CLOSED,Display_Data,solar3dim);
maplength = 0;
for i = 1:size(waypoints, 1)-1
    maplength = maplength + sqrt((waypoints(i+1,1)-waypoints(i,1))^2 + (waypoints(i+1,2)-waypoints(i,2))^2);
end
maplength = maplength * 100;

runtime=toc(begintime);
fprintf('astar results\n');
fprintf('运行时间: %.2f s\n', runtime);
fprintf('规划路径点个数：%d个\n', size(waypoints, 1));
fprintf('规划路径长度：%.2f m\n', 100*routelength);
fprintf('规划路径地面投影长度：%.2f m\n', maplength);

% 作图
fprintf('正在绘图\n');
angle = {[0,90],[240,70]};
ttl = {'A*算法三维路径规划俯视图','A*算法三维路径规划图'};
for i = 1:2
    figure(i)
    axis([1 MAX_X 1 MAX_Y 1 MAX_Z]); % 设置坐标轴范围为1到MAX_X,1到MAX_Y,1到MAX_Z
    plot3(waypoints(:,1),waypoints(:,2),waypoints(:,3),'b','linewidth',2);
    hold on
    plot3(20,20,7,'+k','LineWidth',8);
    hold on
    plot3(90,70,5,'*r','LineWidth',8);
    hold on
    legend(['\fontname{宋体}轨迹'],['\fontname{宋体}起点'],['\fontname{宋体}终点']);
    legend('AutoUpdate','off');
    surf(Display_Data(1:100,1:100)','linestyle','none'); % 创建一个曲面图，并将 Z 中元素的列索引和行索引用作 x 坐标和 y 坐标
    set(gca,'xticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
    set(gca,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
    set(gca,'zticklabel',{'2000','4000','6000','4000','5000','6000','7000','8000','9000','10000'});
    xlabel(['\fontname{Times new roman}x\fontname{宋体}方向节点']);
    ylabel(['\fontname{Times new roman}y\fontname{宋体}方向节点']);
    zlabel(['\fontname{宋体}高度\fontname{Times new roman}(m)']);
    set(gca,'fontsize',12,'fontname','Times new roman');
    %%%%%%%%%%%%%%%%绘制异常天气区，绿色为异常天气区
    figure(i)
    [a,z]=ndgrid((0:.05:1)*2*pi,0:.05:20);
    x=7.5*cos(a)+60;
    y=7.5*sin(a)+70;
    surf(x,y,z,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
    hold on
    % 对异常区域封顶
    [a,r]=ndgrid((0:.05:1)*2*pi,[0 1]);
    x=7.5*cos(a).*r+60;
    y=7.5*sin(a).*r+70;
    surf(x,y,x*0,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
    surf(x,y,x*0+20,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
    hold off
    grid on
    set(gca, 'XTick', 0:10:100);
    set(gca, 'YTick', 0:10:100);
    set(gca, 'GridLineStyle', 'none');
    set(gca, 'GridAlpha', 0);
    view(angle{i});
    title(ttl{i},'FontSize',13,'FontWeight', 'bold');
end

% 证明轨迹符合低空要求及地形要求,注意map中的50是地形最低点起之上的50
Terrain_Data = Final_Data(301:400,101:200);
num = size(waypoints, 1);
figset = [];
MIN_Final_Data = min(min(Final_Data(301:400,101:200)));
for i = 1:num
    figset(i, 1) = i;
    figset(i, 2) = Terrain_Data(waypoints(i, 1), waypoints(i, 2));
    figset(i, 3) = waypoints(i, 3) * 100 + MIN_Final_Data;
    figset(i, 4) = Terrain_Data(waypoints(i, 1), waypoints(i, 2)) + 1000;
end
figure(3)
h1 = plot(figset(:, 1), figset(:, 2), ':k', 'linewidth',1);
hold on
h2 = plot(figset(:, 1), figset(:, 3), '-k', 'linewidth',1);
hold on
h3 = plot(figset(:, 1), figset(:, 4), '--k','linewidth',1);
set(gca,'xtick',0:10:110)
legend(['\fontname{宋体}航迹对应地形高度'],['\fontname{宋体}规划航迹高度'],['\fontname{宋体}航迹对应低空限制高度']);
legend('AutoUpdate','off');
title('A*算法三维路径规划航迹剖面图','FontSize',13,'FontWeight', 'bold');
xlabel(['\fontname{宋体}路径点']);
ylabel(['\fontname{宋体}高度\fontname{Times new roman}(m)']);
set(gca,'fontsize',12,'fontname','Times new roman');
hold off
fprintf('规划完毕\n');





