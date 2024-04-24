function [Rx_PDCCH_DCI,PDCCH_CRC_Flag] = PDCCH_decode(RB_num,initialBWP_size,CORESET_res,N_cell_ID,n_RNTI)
% for i = 0:4
%      AL = 2^i;
%      CCEstart = candidate_start(AL,NR_Params);
%      for n = 1:length(CCEstart)              
         RxNPDCCHSeqOut = RxPDCCHDeResMap(RB_num,CORESET_res);%解PDCCH资源映射
         %解PDCCH
         [PDCCH_CRC_Flag,Rx_PDCCH_DCI,Polar_Output] = RxPDCCH_bit(initialBWP_size,RxNPDCCHSeqOut,N_cell_ID,n_RNTI);    
%      end
%      if PDCCH_CRC_Flag==1
%          break;
%      else
%          continue;
%      end
% end