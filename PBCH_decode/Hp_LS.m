%**************************************************************************
%Copyright (C), 2013, CQUPT
%FileName:     Hp_LS
%Description:  LS estimation to get the CIR of RS
%Author:       Algorithm_GROUP
%Input:        1.TxDLcell_speRSSeqOut:extract data for one channel after Cell-specific reference signal(CSRS)
%              2.Y:extract data for one channel after resource demapping of Cell-specific reference signal
%Output:       Hp:CIR of RS for one channel
%History:
%      <time>      <version >
%      2013/1/24     1.0
%**************************************************************************

function Hp = Hp_LS(TxDLNRSSeqOut,y)
%LS estimation to get the CIR of RS

Hp = y./TxDLNRSSeqOut;