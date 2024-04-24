%==========================================================================
%Copyright (C), 2018, CQUPT
%FileName:     frame_Syn_caculate
%Description:
%Author:       DSP_GROUP
%Input:        1.signal: PSS(N_2_ID+1,:)
%              2.ofdm_cpout_delay: the receive data
%              3.Rude_Syn_point: the rude synchronization point
%Output:       Syn_point:the synchronization point
%History:
%      <time>      <version >
%      2018/4/28      1.0
%==========================================================================
function Syn_point=Syn_point_caculate_Fre(ofdm_cpout_delay,Rude_Syn_point,mu,PSSFre,NR_Params)
% global k_0_mu
% global N_RB_sc
k_0_mu = NR_Params.PDSCH.k_0_mu;
N_RB_sc = NR_Params.Cell.N_RB_sc;

% N = 2048*64*2^(-mu) ;
% D1 = (64*2^(-mu));  %取这个还是D还需要在考虑
N = 2048*2*2^(-mu) ;
D1 = (2*2^(-mu));  %取这个还是D还需要在考虑

D = N/D1;
for n = 1:N
    table(n) = exp(-1i * 2 * pi /N* (k_0_mu - floor(N_RB_sc *20 / 2)) * (n-1));%上行基带信号生成
end
PSS = [zeros(1,56) PSSFre zeros(1,N-56-length(PSSFre))]  ;

seg_RXofdm = ofdm_cpout_delay(Rude_Syn_point-D1:Rude_Syn_point+D1+N-1);

for i = 1:2*D1+1
    if i==5
        i=5;
    end
    temp=(fft(table.*seg_RXofdm(i:(i-1)+N),N)/N);
    output(i) = sum(PSS.*temp);
end
[a,b]=max(abs(output));


Syn_point = Rude_Syn_point-D1+b-1; 

