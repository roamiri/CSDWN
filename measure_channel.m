function [G, L] = measure_channel(FBS,NumRealization)
    fbsNum = size(FBS,2);
    G = zeros(fbsNum, fbsNum);
    L = zeros(fbsNum, fbsNum);
    c = 3e8; f=28e9;
    lambda = c/f;
    %lognormal shadowing
    sigma = 8.7; %dB
%     NumRealization = 1e1;
    X = sigma * randn(fbsNum, fbsNum, 1e1);
    Y = zeros(fbsNum,fbsNum);
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
    end
        
    Hij = abs((1/sqrt(2)) * (randn(fbsNum, fbsNum, NumRealization)+1i*randn(fbsNum, fbsNum, NumRealization)));
    hij = Hij.^2;
    for i=1:fbsNum
        for j=1:fbsNum
            G(i,j)=(sum(hij(i,j,:))/NumRealization);
        end
    end
end