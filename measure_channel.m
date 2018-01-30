function [G, L] = measure_channel(FBS,MBS,MUE,NumRealization)
    fbsNum = size(FBS,2);
    G = zeros(fbsNum+1, fbsNum+1);
    L = zeros(fbsNum+1, fbsNum+1);
    c = 3e8; f=28e9;
    lambda = c/f;
    %lognormal shadowing
    sigma = 8.7; %dB
%     NumRealization = 1e1;
    X = sigma * randn(fbsNum, fbsNum, 1e1);

    for i=1:fbsNum
        for j=1:fbsNum
            Y(i,j)=(sum(X(i,j,:))/1e1);
        end
    end
    
    for i=1:fbsNum
        xAgent = FBS{i}.X;
        yAgent = FBS{i}.Y;
        for j=1:fbsNum
            d = sqrt((xAgent-FBS{j}.FUEX)^2+(yAgent-FBS{j}.FUEY)^2);
            if i==j
                PL0 = -20 * log10(lambda./(4*pi*d))+Y(i,j);
            else
                PL0 = 72.0 +29.2*log10(d)+Y(i,j); % PL = alpha + 10*beta*log10(d)+X(N(0,zeta^2))
            end
            L(i,j) = 10^((PL0)/10);
        end
        d = sqrt((xAgent-MUE.X)^2+(yAgent-MUE.Y)^2);
        PL0 = 62.3+32.*log10(d/5);
        L(i,fbsNum+1) = 10.^((PL0 )/10);
        
        d = sqrt((MBS.X-FBS{i}.FUEX)^2+(MBS.Y-FBS{i}.FUEY)^2);
        PL_BS = 62.3+32*log10(d/5);
        L(fbsNum+1,i) = 10^((PL_BS)/10);
    end
    d = sqrt((MBS.X-MUE.X).^2+(MBS.Y-MUE.Y).^2);
    PL_BS = 62.3+40*log10(d/5);
    L(fbsNum+1,fbsNum+1) = 10.^((PL_BS)/10);
    
    Hij = abs((1/sqrt(2)) * (randn(fbsNum+1, fbsNum+1, NumRealization)+1i*randn(fbsNum+1, fbsNum+1, NumRealization)));
    hij = Hij.^2;
    for i=1:fbsNum+1
        for j=1:fbsNum+1
            G(i,j)=(sum(hij(i,j,:))/NumRealization);
        end
    end
end