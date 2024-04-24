%==========================================================================
%Copyright (C), 2018, CQUPT
%FileName:     frame_Syn_caculate
%Description:
%Author:       DSP_GROUP
%Input:        1.Syn_point: the synchronization point
%              2.ofdm_cpout_delay: the receive data
%              3.N_2_ID: cell ID 2
%              4.CP_flag:CP type
%Output:       1.N_1_ID: cell ID 1
%              2.half_frame:frame type
%History:
%      <time>      <version >
%      2018/4/1      1.0
%==========================================================================
function [N_1_ID,syncSuccess]=frame_Syn_caculate(sr,N_RB,Syn_point,ofdm_cpout_delay,N_2_ID,CP_flag,mu,RB_Offset,SC_Offset,N,N_cp1)

k_0_mu = 0;
N_RB_sc = 12;
% N_RB = 273;

kappa = 2^(mu+1);
kappa = 2;
% N=2048*kappa*2^(-mu);
% N = 4096/sr;
% N = 4096;
T_pss1 = TxDLPSSseq(N_2_ID);                              %本地频域PSS计算N

r_pss0=ofdm_cpout_delay(1,Syn_point:Syn_point+N-1);           %接收时域PSS
table = zeros(1,N);
for n = 1:N
   table(n) = exp(-1i * 2 * pi /N* (k_0_mu - floor(N_RB_sc * N_RB / 2)) * (n-1));%上行基带信号生成
end
r_pss11=fft(table.*r_pss0,N)/N;
% r_pss1=r_pss11(1:N_RB_sc * 20);
% R_pss=r_pss11(57:183);

% R_pss=r_pss11(1239:1365);                %得到接收端频域PSS
R_pss=r_pss11(RB_Offset*12+SC_Offset+57:RB_Offset*12+SC_Offset+183);
H_pss= R_pss./T_pss1;                                            %PSS的信道频域冲击响应
%******************************************
%**********普通CP**************************
% % % % if CP_flag==0
% % % %     if Syn_point+N*3+2*144*kappa*2^(-mu)-1<=length(ofdm_cpout_delay)
% % % %         r_sss0 = ofdm_cpout_delay(1,Syn_point+N*2+2*144*kappa*2^(-mu):Syn_point+N*3+2*144*kappa*2^(-mu)-1);%接收时域SSS(普通CP)
% % % %     else
% % % %         lenend = zeros(1,Syn_point+N*3+2*144*kappa*2^(-mu)-1-length(ofdm_cpout_delay));
% % % %         ofdm_cpout_delay = [ofdm_cpout_delay lenend];
% % % %         r_sss0 = ofdm_cpout_delay(1,Syn_point+N*2+2*144*kappa*2^(-mu):Syn_point+N*3+2*144*kappa*2^(-mu)-1);%接收时域SSS(普通CP)
% % % %     end
% % % % else
% % % %     r_sss0 = ofdm_cpout_delay(1,Syn_point+N*2+2*512*kappa*2^(-mu):Syn_point+N*3+2*512*kappa*2^(-mu)-1);%接收时域SSS(扩展CP)
% % % % end
r_sss0 = ofdm_cpout_delay(1,Syn_point+N*2+2*N_cp1:Syn_point+N*3+2*N_cp1-1);%接收时域SSS(普通CP)

% r_sss0 = ofdm_cpout_delay(1,Syn_point+N*2+2*352:Syn_point+N*3+2*352-1);
%*****************************
R_sss0=fft(table.*r_sss0,N)/N;
% r_sss=R_sss0(1:N_RB_sc * 20);
% R_sss=R_sss0(57:183);

% R_sss=R_sss0(1239:1365);
R_sss=R_sss0(RB_Offset*12+SC_Offset+57:RB_Offset*12+SC_Offset+183);
% % % % RR_SSS=R_sss./H_pss;                                           %普通CP信道补偿后的SSS序列
RR_SSS=R_sss;
%***生成本地SSS序列336个****
for i=0:335
    SSS_Fre_out=TxDLSSSseq(i,N_2_ID);
    a(i+1)=sum(RR_SSS.*SSS_Fre_out);
end
a1 = abs(a);
% figure;plot(a1);
[am,index]=max(abs(a));
% % a1(index) = 0;
% % if(am>5*mean(a1))
% %     syncSuccess = 1;
% % else
% %     syncSuccess = 0;
% % end
syncSuccess = 1;
N_1_ID = index-1;
% figure;plot(abs(a))
