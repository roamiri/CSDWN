%%
mue(1) = UE(204, 207);
fbsCount = 16;
FBS = cell(1,fbsCount);
BS = BaseStation(0 , 0 , 50);    
    for i=1:3
        if i<= fbsCount
            FBS{i} = FemtoStation(180+(i-1)*35,150, BS, mue, 10);
        end
    end

    for i=1:3
        if i+3<= fbsCount
            FBS{i+3} = FemtoStation(165+(i-1)*30,180, BS, mue, 10);
        end
    end

    for i=1:4
        if i+6<= fbsCount
            FBS{i+6} = FemtoStation(150+(i-1)*35,200, BS, mue, 10);
        end
    end

    for i=1:3
        if i+10<= fbsCount
            FBS{i+10} = FemtoStation(160+(i-1)*35,240, BS, mue, 10);
        end
    end

    for i=1:3
        if i+13<= fbsCount
            FBS{i+13} = FemtoStation(150+(i-1)*35,280, BS, mue, 10);
        end
    end
%%
figure;
hold on;
grid on;

dM1 = 15; dM2 = 50; dM3 = 125; 

dB1 = 50; dB2 = 150; dB3 = 400;

BS = BaseStation(0 , 0 , 50);

fbs = FBS{1};
p1 = plot(fbs.X, fbs.Y, 'r');
p1.Marker = '*';
p2 = plot(fbs.X, fbs.Y+10, 'k');
p2.Marker = 'x';
for i=2:16
    fbs = FBS{i};
    p = plot(fbs.X, fbs.Y, 'r','LineWidth',0.75,'MarkerSize',8);
    p.Marker = '*';
    p = plot(fbs.X, fbs.Y+10, 'k','LineWidth',0.75,'MarkerSize',8);
    p.Marker = 'x'; 
end
axis([-300,350,-100,350]);

circle(selectedMUE.X,selectedMUE.Y,dM1, 'r');
circle(selectedMUE.X,selectedMUE.Y,dM2, 'r');
circle(selectedMUE.X,selectedMUE.Y,dM3, 'r');

title('System Model','FontSize',14, 'FontWeight','bold');
xlabel('x position','FontSize',14, 'FontWeight','bold');
ylabel('y position','FontSize',14, 'FontWeight','bold');
legend([p3 p1 p2 p4],{'BS','FBS', 'FUE', 'MUE'});
box on;
set(gca,'fontsize',14, 'FontWeight','bold');


function h = circle(x,y,r, color)
hold on
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
h = plot(xunit, yunit, color,'LineWidth',1.5,'MarkerSize',10);
end