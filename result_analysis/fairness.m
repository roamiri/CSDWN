
clear;
clc;
%%
s = sprintf('oct10/FUE_R_18_time.mat');
filename = strcat(s);
load(filename);

s = sprintf('oct10/FUE_Rref_noshare.mat');
filename = strcat(s);
load(filename);

%%
figure;
hold on;
grid on;
box on;

net_size = size(C_FUE_Mat,2);
fariness = zeros(1,net_size);
% fariness_ref = zeros(1,net_size);
for i=1:net_size
vec = C_FUE_Mat{i};
vec_ref = C_FUE_Mat_IL{i};
num = 0.0;
num_ref = 0.0;
denom = 0.0;
denom_ref = 0.0;
n = size(vec,2);
for j=1:n
    num = num + vec(j);
    num_ref = num_ref + vec_ref(j);
    denom = denom + vec(j)^2;
    denom_ref = denom_ref + vec_ref(j)^2;
end
    fariness(i) = (num^2)/(n*denom);
    fairness_ref(i) = (num_ref^2)/(n*denom_ref);
end
plot(fariness, '--sr', 'LineWidth',1.5,'MarkerSize',10, 'MarkerFaceColor','r', 'MarkerEdgeColor','b');
plot(fairness_ref, 'b--.', 'LineWidth',1,'MarkerSize',10);
xlim([1 net_size]);
ylim([0 1.3]);
% title('Fairness index','FontSize',14, 'FontWeight','bold');
xlabel('Cluster size','FontSize',14, 'FontWeight','bold');
ylabel('Jain''s Index For Fairness','FontSize',14, 'FontWeight','bold');
legend({'CDP-Q fairness in each cluster'},'FontSize',14, 'FontWeight','bold');
