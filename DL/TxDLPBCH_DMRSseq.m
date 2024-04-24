%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     TxDLPBCH_DMRSseq
%Description:  TxDLPBCH_DMRSseq
%Reference:    TS38211 clause 7.4.1.4
%Author:       DSP_GROUP
%Input:        PBCH_L
%Output:       TxDLPBCH_DMRS_out
%History:
%      <time>      <version >
%      2018/8/16      1.0
%**************************************************************************
function TxDLPBCH_DMRS_out = TxDLPBCH_DMRSseq(NR_Params,PBCH_L)
    % global PBCH_L_max;
    % global PBCH_L;
    % global N_cell_ID;

    PBCH_L_max = NR_Params.SSB.PBCH_L_max;
    N_cell_ID = NR_Params.Cell.N_cell_ID;
    lenc = 144*2;                %TS38211 Table 7.4.3.1-1

    if PBCH_L_max==4             %%TS38211 7.4.1.4.1
        n_hf=0;                  %the number of the half-frame in which the PBCH is transmitted in  frame 
        i_SSB = mod(PBCH_L,4);   %低2位
    else
        n_hf = 0;                %n_hf=0
        i_SSB = mod(PBCH_L,8);   %低三位
    end
    
    i_SSB_bar = 4*i_SSB + n_hf;
    %===============c序列生成==================
    c_init = 2^11*(i_SSB_bar+1)*(floor(N_cell_ID/4)+1)+2^6*(i_SSB_bar+1)+mod(N_cell_ID,4);
    c = pseudo(lenc,c_init);
    %==============r序列生成====================
    for m=1:lenc/2
        r(m) = 1/sqrt(2)*(1-2*c(2*m-1)) + 1j*1/sqrt(2)*(1-2*c(2*m));
    end
    
    TxDLPBCH_DMRS_out = r;
end