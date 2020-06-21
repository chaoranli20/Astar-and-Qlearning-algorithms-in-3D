%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Qlearning·���滮�㷨������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all;
close all;

begintime = tic;
fprintf('���������У����Ժ�\n');
load ('MapData.mat');
% ���ص�arena���ݽṹ�������������ֱ���MAX_X,MAX_Y,MAX_Z,arena_m,src,des
arena = importArena(MAP, MAX_X, MAX_Y, MAX_Z);
alpha = 0.9;
gamma = 0.7;
goalstateind = sub2ind(size(arena.arena_m), arena.des(1), arena.des(2), arena.des(3));

[Q, docroutelength, qwaypoints, times, maplength, qnumber] = learnQMatrix(arena, alpha, gamma, solar3dim, Display_Data);
figure(4)
a = docroutelength(:, 1);
b = docroutelength(:, 2);
plot(a, b, '-');
save('qMatrix.mat', 'Q');
%load('qMatrix');

figure(5)
a = qnumber(:, 1);
b = qnumber(:, 2);
plot(a, b, '-');

runtime=toc(begintime);
fprintf('greedy qlearning results\n');
fprintf('����ʱ��: %.2f s\n', runtime);
fprintf('����������%d��\n',times);
fprintf('�滮·���������%d��\n', size(qwaypoints, 1));
fprintf('�滮·�����ȣ�%.2f m\n', 100*docroutelength(times-1, 2));
fprintf('�滮·������ͶӰ���ȣ�%.2f m\n', maplength*100);

% ��ͼ
fprintf('���ڻ�ͼ\n');
angle = {[0,90],[60,70]};
ttl = {'Qlearning�㷨��ά·���滮����ͼ','Qlearning�㷨��ά·���滮ͼ'};
for i = 1:2
    figure(i)
    axis([1 MAX_X 1 MAX_Y 1 MAX_Z]); % ���������᷶ΧΪ1��MAX_X,1��MAX_Y,1��MAX_Z
    plot3(qwaypoints(:,1),qwaypoints(:,2),qwaypoints(:,3),'b','linewidth',2);
    hold on
    plot3(20,20,7,'+k','LineWidth',8);
    hold on
    plot3(90,70,5,'*r','LineWidth',8);
    hold on
    legend(['\fontname{����}�켣'],['\fontname{����}���'],['\fontname{����}�յ�']);
    legend('AutoUpdate','off');
    surf(Display_Data(1:100,1:100)','linestyle','none'); % ����һ������ͼ������ Z ��Ԫ�ص������������������� x ����� y ����
    set(gca,'xticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
    set(gca,'yticklabel',{'0','10','20','30','40','50','60','70','80','90','100'});
    set(gca,'zticklabel',{'2000','4000','6000','4000','5000','6000','7000','8000','9000','10000'});
    xlabel(['\fontname{Times new roman}x\fontname{����}����ڵ�']);
    ylabel(['\fontname{Times new roman}y\fontname{����}����ڵ�']);
    zlabel(['\fontname{����}�߶�\fontname{Times new roman}(m)']);
    set(gca,'fontsize',12,'fontname','Times new roman');
    %%%%%%%%%%%%%%%%�����쳣����������ɫΪ�쳣������
    figure(i)
    [a,z]=ndgrid((0:.05:1)*2*pi,0:.05:20);
    x=7.5*cos(a)+60;
    y=7.5*sin(a)+70;
    surf(x,y,z,x*0,'linestyle','none','Facealpha',0.7,'FaceColor','g')
    hold on
    % ���쳣����ⶥ
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

% ֤���켣���ϵͿ�Ҫ�󼰵���Ҫ��
% ע��map�е�50�ǵ�����͵���֮�ϵ�50
Terrain_Data = Final_Data(301:400,101:200);
num = size(qwaypoints, 1);
figset = [];
MIN_Final_Data = min(min(Final_Data(301:400,101:200)));
for i = 1:num
    figset(i, 1) = i;
    figset(i, 2) = Terrain_Data(qwaypoints(i, 1), qwaypoints(i, 2));
    figset(i, 3) = qwaypoints(i, 3) * 100 + MIN_Final_Data;
    figset(i, 4) = Terrain_Data(qwaypoints(i, 1), qwaypoints(i, 2)) + 1000;
end
figure(3)
h1 = plot(figset(:, 1), figset(:, 2), ':k', 'linewidth',1);
hold on
h2 = plot(figset(:, 1), figset(:, 3), '-k', 'linewidth',1);
hold on
h3 = plot(figset(:, 1), figset(:, 4), '--k','linewidth',1);
set(gca,'xtick',0:10:110)
legend(['\fontname{����}������Ӧ���θ߶�'],['\fontname{����}�滮�����߶�'],['\fontname{����}������Ӧ�Ϳ����Ƹ߶�']);
legend('AutoUpdate','off');
title('Qlearning�㷨��ά·���滮��������ͼ','FontSize',13,'FontWeight', 'bold');
xlabel(['\fontname{����}·����']);
ylabel(['\fontname{����}�߶�\fontname{Times new roman}(m)']);
set(gca,'fontsize',12,'fontname','Times new roman');
hold off
fprintf('�滮���\n');
