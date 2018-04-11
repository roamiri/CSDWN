%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           function for running PA_CL from 1 to 16 femtocells
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function runForAll(BS_list,bs_Permutation,saveNum)
ss = min(40,size(BS_list,2));
for i=1:size(BS_list,2)
    PA_Spon( 32, i, BS_list, bs_Permutation,1e3, saveNum, 0);
end
end
