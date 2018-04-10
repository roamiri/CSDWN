%% 
%   Function to construct wirelss network's access points based on
%   different frequency bands
%   band can be 'LTE' or 'mmWave'
%%

function [BS_list] = generate_network(max_num_BS, centerX, centerY, Radius, band, graphics)
    
    if band=='mmWave'
        %Generate fbsCount=16 FBSs, FemtoStation is the agent of RL algorithm
        mmWaveBS_list = cell(1,1);
        cnt = 1;
        finish = false;
        for j=1:6
            for i=1:20
                X = centerX-(j-1)*35;
                Y = centerY-(i-1)*30;
                if distance(centerX, centerY, X, Y) <= Radius
                    mmWaveBS_list{cnt} = mmWaveBS(X,Y,10, centerX, centerY);
                    cnt = cnt+1;
                end
                X = centerX+(j-1)*35;
                Y = centerY+(i-1)*30;
                if distance(centerX, centerY, X, Y) <= Radius
                    mmWaveBS_list{cnt} = mmWaveBS(X,Y,10, centerX, centerY);
                    cnt = cnt+1;
                end
                X = centerX-(j-1)*35;
                Y = centerY+(i-1)*30;
                if distance(centerX, centerY, X, Y) <= Radius
                    mmWaveBS_list{cnt} = mmWaveBS(X,Y,10, centerX, centerY);
                    cnt = cnt+1;
                end
                X = centerX+(j-1)*35;
                Y = centerY-(i-1)*30;
                if distance(centerX, centerY, X, Y) <= Radius
                    mmWaveBS_list{cnt} = mmWaveBS(X,Y,10, centerX, centerY);
                    cnt = cnt+1;
                end
                if cnt > max_num_BS 
                    finish = true;
                    break;
                end
            end
            if finish
                break;
            end
        end
    end
    
    BS_list = mmWaveBS_list;    
    if graphics
        DrawGeographic(BS_list, centerX, centerY, Radius);
    end
end

function d = distance(centerx, centery, X, Y)
    d = sqrt((centerx-X)^2 + (centery-Y)^2);
end