%%


function DrawGeographic(BS_list,centerX, centerY, Radius)

figure;
hold on;
grid on;

BS_cnt = size(BS_list,2);

minx = inf; maxx = -inf;
miny = inf; maxy = -inf;

for i=1:BS_cnt
    bs = BS_list{i};
    bsX = bs.X; bsY=bs.Y;
    if bs.X<minx; minx=bsX;end
    if bs.X>maxx; maxx=bsX;end
    if bs.Y<miny; miny=bsY;end
    if bs.Y>miny; maxy=bsY;end
    
    p = plot(bsX, bsY, 'r','LineWidth',0.75,'MarkerSize',8);
    p.Marker = '*';
    p = plot(bsX, bsY+10, 'k','LineWidth',0.75,'MarkerSize',8);
    p.Marker = 'x'; 
end
% axis([-300,350,-100,350]);
circleX = (minx+maxx)/2;
circleY = (miny+maxy)/2;
circle(centerX, centerY, Radius, 'r');

lambda = (BS_cnt)/(pi*(Radius/1000)^2);
title(sprintf('System Model,numBS=%d, \x03bb = %g',BS_cnt,lambda),'FontSize',12);
xlabel('x position','FontSize',14, 'FontWeight','bold');
ylabel('y position','FontSize',14, 'FontWeight','bold');
% legend([p3 p1 p2 p4],{'BS','FBS', 'FUE', 'MUE'});
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