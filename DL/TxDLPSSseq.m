%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     TxDLPSSseq
%Description:  TxDL PSS sequence generate
%Reference:    TS38211 clause 7.4.2.2
%Author:       DSP_GROUP
%Input:        N_2_ID
%Output:       TxDLPSS_out
%History:
%      <time>      <version >
%      2018/5/15      1.0
%**************************************************************************
function TxDLPSS_out = TxDLPSSseq(N_2_ID)
% global N_2_ID;
    x = zeros(1,127);      %0<=n<127，代码中下标+1
    x(1:7) = fliplr([1 1 1 0 1 1 0]);
    d_pss = zeros(1,127);
    for i=1:127-7
        x(i+7) = mod(x(i+4)+x(i),2);
    end
    for n=0:126            %因为要计算m
        m = mod((n+43*N_2_ID),127);
        d_pss(n+1) = 1 - 2*x(m+1);
    end
    TxDLPSS_out = d_pss;   %与协议上的顺序相反
end