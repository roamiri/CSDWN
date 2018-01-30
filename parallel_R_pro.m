%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     Main Loop Runner in parallel:
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function parallel_R_pro(pref_poolSize)
% parpool(pref_poolSize)
BS_list = generate_network(40, 200, 200, 200,'mmWave',true);
BS_list_size = size(BS_list,2);
permutationsMat = zeros(30,BS_list_size);

for i=1:30
    permutationsMat(i,:) = randperm(BS_list_size,BS_list_size);
end

% parfor_progress(30);
 for i=1:30
    runForAll(BS_list,permutationsMat(i,:),i);
%     pause(rand);
%     parfor_progress;
 end
%  parfor_progress(0); % Clean up
end
