function PSS = PSS_caculate(N_RB,PSS_Fre,RB_Offset,SC_Offset,N)

% global N_slot_symb
k_0_mu = 0;
% global DL_mu
kappa = 4;
% global DL_RB;
% global N_RB_sc;
% global N_SSB_RB
% N_RB = 273;
% N = 4096/sr;
% N = 4096;
    N_2_ID=[0 1 2];
    for j=0:2
        %******资源映射***********
        a = zeros(1,20*12);
        b = zeros(1,N);
        a(1,57:183)=PSS_Fre(j+1,:);
        % a = [zeros(1,RB_Offset*12+SC_Offset) a];
        b(RB_Offset*12+SC_Offset+1:RB_Offset*12+SC_Offset+20*12) = a;
        %*****生成时域数据*********
%         N = 4096 ; 
        for n = 1:N
           table(n) = exp(1i * 2 * pi /N* (k_0_mu - floor(12 *N_RB / 2)) * (n-1));%上行基带信号生成
        end
        %newinput0=[a(121:240) zeros(1,N-240) a(1:120)];
        output(j+1,:) = table.*ifft(b,N);   
        %output(j+1,:) = N* ifft(a,N);
        %output(j+1,:) =d_pss;
    end
    PSS=output;
end