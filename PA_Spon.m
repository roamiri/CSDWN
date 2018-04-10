%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Simulation of Power Allocation in dense mmWave network using 
%   Spontaneous power allocation
%   Every BS uses maximum power
%
function PA_Spon(Npower, bs_count, BS_Max, bs_permutation, NumRealization, saveNum, CL)
%% Initialization
clc;
total = tic;
%% Parameters
Pmin = -10;                                                                                                                                                                                                                                                                                                                                                                           %dBm
Pmax = 35; %dBm
SINR_th = 2.83;%10^(2/10); % I am not sure if it is 2 or 20!!!!!
%gamma_th = log2(1+sinr_th);

%% Minimum Rate Requirements for users
q_ue = log2(SINR_th);

%% Q-Learning variables
% Actios
actions = linspace(Pmin, Pmax, Npower);

%%
BS_list = cell(1,bs_count);

for i=1:bs_count
    BS_list{i} = BS_Max{bs_permutation(i)};
end
%% Calc channel coefficients
    G = zeros(bs_count, bs_count); % Matrix Containing small scale fading coefficients
    L = zeros(bs_count, bs_count); % Matrix Containing large scale fading coefficients
    [G, L] = measure_channel(BS_list,NumRealization);
    %% Main Loop
%      textprogressbar(sprintf('calculating outputs:'));
    
    for j=1:bs_count
        fbs = BS_list{j};
        fbs.P = Pmax;
        BS_list{j} = fbs;
    end
    % calc FUEs and MUEs capacity
    SINR_UE_Vec = SINR_UE(G, L, BS_list,-120);
    for j=1:bs_count
            fbs = BS_list{j};
%             fbs = fbs.setCapacity(log2(1+SINR_FUE_Vec(j)));
            fbs.C_FUE = log2(1+SINR_UE_Vec(j));
            fbs.SINR = SINR_UE_Vec(j);
            BS_list{j}=fbs;
    end
    
    answer.FBS = BS_list;
    for j=1:size(BS_list,2)
        c_fue(1,j) = BS_list{1,j}.C_FUE;
        p_fue(1,j) = BS_list{1,j}.P;
        sinr_fue(1,j) = BS_list{1,j}.SINR;
    end
    sum_CFUE = 0.0;
    for i=1:size(BS_list,2)
        sum_CFUE = sum_CFUE + BS_list{i}.C_FUE;
    end
    answer.C_FUE = c_fue;
    answer.P_FUE = p_fue;
    answer.sinr = sinr_fue;
    answer.sum_CFUE = sum_CFUE;
    answer.threshold = SINR_th;
    QFinal = answer;
    save(sprintf('DATA/Apr10/spon/pro_%d_%d_%d.mat',Npower, bs_count, saveNum),'QFinal');
end
