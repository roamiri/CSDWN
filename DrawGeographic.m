%%


function DrawGeographic(BS_list,centerX, centerY, Radius)

figure;
hold on;
grid on;

BS_cnt = size(BS_list,2);

minx = inf; maxx = -inf;
miny = inf; maxy = -inf;

bs = BS_list{1};
color = rand(1,3);
p1 = plot(bs.X, bs.Y, '^', 'MarkerFaceColor','k','MarkerEdgeColor','k', 'MarkerSize', 6, 'linewidth', 2);
% p1.Marker = '*';
p2 = plot(bs.X, bs.Y+15, 's', 'color', 'r', 'MarkerSize', 4, 'linewidth', 2);
% p2.Marker = 'x';

for i=2:BS_cnt
    bs = BS_list{i};
    bsX = bs.X; bsY=bs.Y;
    if bs.X<minx; minx=bsX;end
    if bs.X>maxx; maxx=bsX;end
    if bs.Y<miny; miny=bsY;end
    if bs.Y>miny; maxy=bsY;end
    
    p = plot(bsX, bsY, '^', 'MarkerFaceColor','k','MarkerEdgeColor','k', 'MarkerSize', 6, 'linewidth', 2);
%     p.Marker = '*';
    p = plot(bsX, bsY+15, 's', 'color', 'r', 'MarkerSize', 4, 'linewidth', 2);
%     p.Marker = 'x'; 
end
% axis([-300,350,-100,350]);
circleX = (minx+maxx)/2;
circleY = (miny+maxy)/2;
circle(centerX, centerY, Radius, 'r');

lambda = (BS_cnt)/(pi*(Radius/1000)^2);
title(sprintf('System Model,numBS=%d, \x03bb = %g',BS_cnt,lambda),'FontSize',8);
xlabel('x position','FontSize',14, 'FontWeight','bold');
ylabel('y position','FontSize',14, 'FontWeight','bold');
legend([p1 p2 ],{'mmWaveBS', 'UE'},'Location','northeast');
box on;
set(gca,'fontsize',14, 'FontWeight','bold');
axis equal
end

function h = circle(x,y,r, color)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, color,'LineWidth',1.5,'MarkerSize',10);
end