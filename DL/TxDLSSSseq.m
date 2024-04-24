%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     TxDLSSSseq
%Description:  TxDL SSS sequence generate
%Reference:    TS38211 clause 7.4.2.3
%Author:       DSP_GROUP
%Input:        N_1_ID  N_2_ID
%Output:       TxDLSSS_out
%History:
%      <time>      <version >
%      2018/5/15      1.0
%**************************************************************************
function TxDLSSS_out = TxDLSSSseq(N_1_ID,N_2_ID)
% global N_1_ID;
% global N_2_ID;
x0 = zeros(1,127);
x0(1:7) = fliplr([0 0 0 0 0 0 1]);
x1 = x0;

for i=1:127-7
    x0(i+7) = mod(x0(i+4)+x0(i),2);
    x1(i+7) = mod(x1(i+1)+x1(i),2);
end

m1 = mod(N_1_ID,112);
m0 = 15*floor(N_1_ID/112)+5*N_2_ID;
d_sss = zeros(1,127);
for n=0:126%%´Ó0¿ªÊ¼£¿
    d_sss(n+1) = (1-2*x0(mod((n+m0),127)+1))*(1-2*x1(mod((n+m1),127)+1));
end
TxDLSSS_out = d_sss;