function rateMatchDeout = cbsRateRecover(datain,C,NL,G,K,Kd,N,Zc,k0,Ncb,Qm)
C1 = C;%%与CBGTI有关系，有待补充，暂时先按照与发送端相同的代码
%-------------------------------%
j=1;
for r = 1:C
    if j<=C1-mod(G/(NL*Qm),C1)
        E(r)=NL*Qm*floor(G/(NL*Qm*C1));
        f=datain(1:E(r));
        datain(1:E(r))=[];
    else
        E(r)=NL*Qm*ceil(G/(NL*Qm*C1));
        f=datain(1:E(r));
        datain(1:E(r))=[];
    end
    j=j+1;
end
%%%%de_interleaving%%%%%%%%%
Q=Qm;
for j=0:E(r)/Q-1
    for i=0:Q-1
        e(i*E(r)/Q+j+1)=f(i+j*Q+1);
    end
end

% Puncture systematic bits
K = K - 2*Zc;
Kd = Kd - 2*Zc;
%     Kd = K - cbsinfo.F;     % exclude fillers

for r = 1:C
    % Perform reverse of bit selection according to TS 38.212 5.4.2.1
    k = 0;
    j = 0;
    indices = zeros(E(r),1);
    
    while k < E(r)
        idx = mod(k0+j,Ncb);
        if ~(idx >= Kd && idx < K)  % Avoid filler bits
            indices(k+1) = idx+1;
            k = k+1;
        end
        j = j+1;
    end
    
    out = zeros(N,1);
    out(Kd+1:K) = Inf;
    
    for n = 1:E(r)
        out(indices(n)) = out(indices(n)) + e(n);
    end
    len_flag = N-Ncb;
    out = [out' zeros(1,len_flag)];
    rateMatchDeout(r,:) = out;
end

end


% % % % function out = cbsRateRecover(datain,K,Kd,N,Zc,k0,Ncb,Qm)
% % % % % Rate recovery for a single code block segment
% % % %
% % % %     % Perform bit de-interleaving according to TS 38.212 5.4.2.2
% % % %     E = length(datain);
% % % %     in = reshape(datain,Qm,E/Qm);
% % % %     in = in.';
% % % %     in = in(:);
% % % %
% % % %     % Puncture systematic bits
% % % %     K = K - 2*Zc;
% % % %     Kd = Kd - 2*Zc;
% % % % %     Kd = K - cbsinfo.F;     % exclude fillers
% % % %
% % % %     % Perform reverse of bit selection according to TS 38.212 5.4.2.1
% % % %     k = 0;
% % % %     j = 0;
% % % %     indices = zeros(E,1);
% % % %
% % % %     while k < E
% % % %         idx = mod(k0+j,Ncb);
% % % %         if ~(idx >= Kd && idx < K)  % Avoid filler bits
% % % %             indices(k+1) = idx+1;
% % % %             k = k+1;
% % % %         end
% % % %         j = j+1;
% % % %     end
% % % %
% % % %     % Recover circular buffer
% % % %     out = zeros(N,1,class(in));
% % % %
% % % %     % Filler bits are treated as 0 bits when encoding, 0 bits correspond to
% % % %     % Inf in received soft bits, this step improves error-correction
% % % %     % performance in the LDPC decoder
% % % %     out(Kd+1:K) = Inf;
% % % %
% % % %     for n = 1:E
% % % %         out(indices(n)) = out(indices(n)) + in(n);
% % % %     end
% % % %
% % % % end