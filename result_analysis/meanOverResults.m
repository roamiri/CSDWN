
clear;
clc;

%%    
sum_FUE = [];
C_FUE_Mat = cell(1,40);
for i=1:40
    fprintf('FBS num = %d\t', i);
    sumfue = 0.;
    c_fue_vec = zeros(1,i);
    Cnt = 0;

    for j=1:200
        s = sprintf('DATA/Apr10/R_4_CL_Dense/pro_32_%d_%d.mat',i,j);
        filename = strcat(s);
        if exist(s)
            load(filename);
                sumfue = sumfue + QFinal.sum_CFUE;
                c_fue_vec = c_fue_vec + QFinal.C_FUE;
                Cnt = Cnt+1;
        end
    end
    fprintf('Total Cnt = %d\n',Cnt);
    sum_FUE = [sum_FUE sumfue/Cnt];
    C_FUE_Mat{i} = c_fue_vec./Cnt;
end
%%    
sum_FUE_IL = [];
C_FUE_Mat_IL = cell(1,120);
for i=1:40
    fprintf('FBS num = %d\t', i);
    sumfue = 0.;
    c_fue_vec = zeros(1,i);
    Cnt = 0;

    for j=1:200
        s = sprintf('DATA/Apr10/R_4_IL/pro_32_%d_%d.mat',i,j);
        filename = strcat(s);
        if exist(s)
            load(filename);
                sumfue = sumfue + QFinal.sum_CFUE;
                c_fue_vec = c_fue_vec + QFinal.C_FUE;
                Cnt = Cnt+1;
        end
    end
    fprintf('Total Cnt = %d\n',Cnt);
    sum_FUE_IL = [sum_FUE_IL sumfue/Cnt];
    C_FUE_Mat_IL{i} = c_fue_vec./Cnt;
end
%%
figure;
hold on;
grid on;
box on;
% plot( ones(1,14)*log2(2.83), '--b', 'LineWidth',1);
for i=1:40
    vec = C_FUE_Mat{i};
%     vec_ref = C_FUE_Mat_ref{i};
    for j=1:size(vec,2)
        plot(i,vec(j), 'sr', 'LineWidth',1.5,'MarkerSize',10, 'MarkerFaceColor','r', 'MarkerEdgeColor','b');
%         plot(i,vec_ref(j), '*b', 'LineWidth',1,'MarkerSize',10);
    end
end
% plot(min_FUE, '--r', 'LineWidth',1,'MarkerSize',10);
% plot(min_FUE_ref, '--b', 'LineWidth',1,'MarkerSize',10);
% title('Capacity of all members of a cluster','FontSize',14, 'FontWeight','bold');
xlabel('Cluster size','FontSize',14, 'FontWeight','bold');
ylabel('Capacity(b/s/HZ)','FontSize',14, 'FontWeight','bold');
% xlim([2 14]);
% ylim([0 16]);
% legend({'required QoS ($log_2(q_k)$)','CDP-Q'},'FontSize',14, 'FontWeight','bold','Interpreter','latex');
%%
figure;
hold on;
grid on;
box on;
% plot( ones(1,14)*log2(2.83), '--b', 'LineWidth',1);
for i=1:40
    vec = C_FUE_Mat_IL{i};
    for j=1:size(vec,2)
        plot(i,vec(j), 'sr', 'LineWidth',1.5,'MarkerSize',10, 'MarkerFaceColor','r', 'MarkerEdgeColor','b');
    end
end
% plot(min_FUE, '--r', 'LineWidth',1,'MarkerSize',10);
% plot(min_FUE_ref, '--b', 'LineWidth',1,'MarkerSize',10);
% title('Capacity of all members of a cluster','FontSize',14, 'FontWeight','bold');
xlabel('Cluster size','FontSize',14, 'FontWeight','bold');
ylabel('Capacity(b/s/HZ)','FontSize',14, 'FontWeight','bold');
% xlim([2 14]);
% ylim([0 16]);
% legend({'required QoS ($log_2(q_k)$)','CDP-Q'},'FontSize',14, 'FontWeight','bold','Interpreter','latex');
%%
figure;
hold on;
grid on;
box on;
% plot( ones(1,16)*2.0, '--k', 'LineWidth',1 );
plot(sum_FUE, '--sr', 'LineWidth',1.5,'MarkerSize',10, 'MarkerFaceColor','r', 'MarkerEdgeColor','b');
plot(sum_FUE_IL, '--*b', 'LineWidth',1,'MarkerSize',10);
% title('SUM capacity of cluster members','FontSize',14, 'FontWeight','bold');
xlabel('Cluster size','FontSize',14, 'FontWeight','bold');
ylabel('Capacity(b/s/HZ)','FontSize',14, 'FontWeight','bold');
% xlim([1 36]);
% ylim([0 100]);
% legend({'CDP-Q'},'FontSize',14, 'FontWeight','bold');
