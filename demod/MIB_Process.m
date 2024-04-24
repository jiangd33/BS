function MIB = MIB_Process(RxPBCH_out)
MIB.SystemFrameNumber = RxPBCH_out(2:7);
% MIB.SubCarrierSpacingCommon = RxPBCH_out(8);

MIB.DMRS_TypeA_Position = RxPBCH_out(13);
MIB.PDCCH_ConfigSIB1 = RxPBCH_out(14:21);%Ts38.213 ch13
MIB.CellBarred = RxPBCH_out(22);
MIB.intraFreqReselection = RxPBCH_out(23);
MIB.Spare = RxPBCH_out(24);
MIB.SSB_index = RxPBCH_out(25:27);%FR2
MIB.HalfFrameIndex = RxPBCH_out(28);

% if(RxPBCH_out(8)==0) %% RxPBCH_out(8) == 0: 15K, RxPBCH_out(8)==1:30KHz
% 根据频段来划分 RxPBCH_out(8) == 0: 60K, RxPBCH_out(8)==1:120K
%     MIB.SSB_SubCarrierOffset = [RxPBCH_out(30) RxPBCH_out(9:12)];
% else
%     MIB.SSB_SubCarrierOffset = RxPBCH_out(9:12);
% end
MIB.SSB_SubCarrierOffset = [RxPBCH_out(30) RxPBCH_out(9:12)];

bit1 = MIB.SSB_SubCarrierOffset(1);
bit2 = MIB.SSB_SubCarrierOffset(2);
bit3 = MIB.SSB_SubCarrierOffset(3);
bit4 = MIB.SSB_SubCarrierOffset(4);
bit5 = MIB.SSB_SubCarrierOffset(5);

MIB.k_ssb = bit1*2^4+bit2*2^3+bit3*2^2+bit4*2^1+bit5;

