%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Simulation of Power Allocation in dense mmWave network using 
%   Reinforcement Learning; Cooperative Learning (CL) 
%   And it takes the number of Npower as the number of columns of Q-Table
%
function PA_CL(Npower, bs_count, BS_Max, bs_permutation, NumRealization, saveNum, CL)

%% Initialization
clc;
total = tic;
%% Parameters
Pmin = -30;                                                                                                                                                                                                                                                                                                                                                                           %dBm
Pmax = 35; %dBm
SINR_th = 2.82;%10^(2/10); % I am not sure if it is 2 or 20!!!!!
%gamma_th = log2(1+sinr_th);

%% Minimum Rate Requirements for users
q_ue = 10.0;

%% Q-Learning variables
% Actios
actions = linspace(Pmin, Pmax, Npower);

% States
states = allcomb(0:3); % states = (ring relative to cluster head (CH))

% Q-Table
Q_init = ones(size(states,1) , Npower) * 0.0;
Q1 = ones(size(states,1) , Npower) * inf;
sumQ = ones(size(states,1) , Npower) * 0.0;

alpha = 0.5; gamma = 0.9; epsilon = 0.1 ; Iterations = 50*size(actions,2)*size(states,1)*bs_count;
%%
BS_list = cell(1,bs_count);

for i=1:bs_count
    BS_list{i} = BS_Max{bs_permutation(i)};
end

    %% Initialize Agents (FBSs)
    bs_count = size(BS_list,2);
    for j=1:bs_count
        fbs = BS_list{j};
%         fbs = fbs.setPower(actions(permutedPowers(j)));
        fbs = fbs.getDistanceStatus();
        fbs = fbs.setQTable(Q_init);
        BS_list{j} = fbs;
    end
%% Calc channel coefficients
    G = zeros(bs_count, bs_count); % Matrix Containing small scale fading coefficients
    L = zeros(bs_count, bs_count); % Matrix Containing large scale fading coefficients
    [G, L] = measure_channel(BS_list,NumRealization);
    %% Main Loop
%      textprogressbar(sprintf('calculating outputs:'));
    count = 0;
    errorVector = zeros(1,Iterations);

    extra_time = 0.0;
    for episode = 1:Iterations
%          textprogressbar((episode/Iterations)*100);
        sumQ = sumQ * 0.0;
        for j=1:bs_count
            fbs = BS_list{j};
            sumQ = sumQ + fbs.Q; 
        end
        
        if (episode/Iterations)*100 < 80
            % Action selection with epsilon=0.1
            for j=1:bs_count
                fbs = BS_list{j};
                if rand<epsilon
%                     fbs = fbs.setPower(actions(floor(rand*Npower+1)));
                      fbs.P_index = floor(rand*Npower+1);
                      fbs.P = actions(fbs.P_index);
                else
                    kk = fbs.S_index;
                    if CL == 1 
                        [M, index] = max(sumQ(kk,:));     % CL method
                    else                                    
                        [M, index] = max(fbs.Q(kk,:));   %IL method
                    end
%                     fbs = fbs.setPower(actions(index));
                      fbs.P_index = index;
                      fbs.P = actions(index);
                end
                BS_list{j} = fbs;
            end
        else
            for j=1:bs_count
                fbs = BS_list{j};
                kk = fbs.S_index;
                if CL == 1 
                    [M, index] = max(sumQ(kk,:));     % CL method
                else                                    
                    [M, index] = max(fbs.Q(kk,:));   %IL method
                end
%                 fbs = fbs.setPower(actions(index));
                fbs.P_index = index;
                fbs.P = actions(index);
                BS_list{j} = fbs;
            end
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
        for j=1:bs_count
            fbs = BS_list{j};
%             qMax=max(fbs.Q,[],2);
            jjj = fbs.P_index;
            kk = fbs.S_index;
            % CALCULATING NEXT STATE AND REWARD
            R = R_1(fbs.C_FUE, fbs.SINR, SINR_th);
            fbs.Q(kk,jjj) = fbs.Q(kk,jjj) + alpha*(R-fbs.Q(kk,jjj));
%             fbs.Q(kk,jjj) = fbs.Q(kk,jjj) + alpha*(R+gamma*qMax(kk)-fbs.Q(kk,jjj));
            BS_list{j}=fbs;
        end

        % break if convergence: small deviation on q for 1000 consecutive
        errorVector(episode) =  sum(sum(abs(Q1-sumQ)));
        if sum(sum(abs(Q1-sumQ)))<0.001 && sum(sum(sumQ >0))
            if count>1000
%                 episode;  % report last episode
                break % for
            else
                count=count+1; % set counter if deviation of q is small
            end
        else
            Q1=sumQ;
            count=0;  % reset counter when deviation of q from previous q is large
        end
    end
%     Q = sumQ;
    answer.Q = sumQ;
    answer.Error = errorVector;
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
    answer.episode = episode;
    tt = toc(total);
    answer.time = tt - extra_time;
    answer.threshold = SINR_th;
    QFinal = answer;
    save(sprintf('DATA/Feb6/R_1/pro_%d_%d_%d.mat',Npower, bs_count, saveNum),'QFinal');
end
