function out = cbsRateRecover1(datain,K,Kd,N,Zc,k0,Ncb,Qm)
% Rate recovery for a single code block segment

    % Perform bit de-interleaving according to TS 38.212 5.4.2.2
    E = length(datain);
    in = reshape(datain,Qm,E/Qm);
    in = in.';
    in = in(:);

    % Puncture systematic bits
    K = K - 2*Zc;
    Kd = Kd - 2*Zc;
%     Kd = K - cbsinfo.F;     % exclude fillers
    
    % Perform reverse of bit selection according to TS 38.212 5.4.2.1
    k = 0;
    j = 0;
    indices = zeros(E,1);
 
    while k < E
        idx = mod(k0+j,Ncb);
        if ~(idx >= Kd && idx < K)  % Avoid filler bits
            indices(k+1) = idx+1;
            k = k+1;
        end
        j = j+1;
    end
    
    % Recover circular buffer
    out = zeros(N,1,class(in));
    
    % Filler bits are treated as 0 bits when encoding, 0 bits correspond to
    % Inf in received soft bits, this step improves error-correction
    % performance in the LDPC decoder
    out(Kd+1:K) = Inf;
    
    for n = 1:E
        out(indices(n)) = out(indices(n)) + in(n);
    end
    
end