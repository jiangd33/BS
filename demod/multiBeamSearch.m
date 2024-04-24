function [beamIndex,Cell_ID] = multiBeamSearch(TX_OFDM,N_fft_Point,N_RB,RB_Offset,SC_Offset,N_cp1)

PSS_Fre = PSS_caculate_Fre();

% % PSS_Fre(1,:) = TxDLSSSseq(0,0);
% % PSS_Fre(2,:) = TxDLSSSseq(0,1);
% % PSS_Fre(3,:) = TxDLSSSseq(0,2);
PSS = PSS_caculate(N_RB,PSS_Fre,RB_Offset,SC_Offset,N_fft_Point);
downSampleRate = 1;


PSS_after_decimate = conj(PSS(:,1:downSampleRate:end));

Rxofdm_after_decimate = TX_OFDM(1:downSampleRate:end);
% [beamIndex_temp,N_2_ID] = relate_caculate_de(PSS_after_decimate,Rxofdm_after_decimate,downSampleRate);
[beamIndex_temp,N_2_ID] = relate_caculate(PSS_after_decimate,Rxofdm_after_decimate,downSampleRate);

beamIndex_temp = beamIndex_temp * downSampleRate - N_fft_Point;
% beamIndex_temp = beamIndex_temp - 1;
%%
% N_2_ID_out = N_2_ID;
cnt = 1;
for k = 1:length(beamIndex_temp)
    De_Point = beamIndex_temp(k);
    if(De_Point<0)
        continue;
    end
    N_2_ID_per = N_2_ID(k);
    PSS = PSS_caculate(N_RB,PSS_Fre,RB_Offset,SC_Offset,N_fft_Point);
    % %*************************精同步点的计算**********************************
    [Syn_point,syncSuccess] = Syn_point_caculate(PSS(N_2_ID_per+1,:),TX_OFDM,De_Point,N_fft_Point);
    %****************************判断CP的类型***********************************
    DeCP_flag = 0;  
%     syncSuccess = 1;
    if(syncSuccess==1)
        [N_1_ID_out,syncSuccess] = frame_Syn_caculate(1,N_RB,Syn_point,TX_OFDM,N_2_ID_per,DeCP_flag,1,RB_Offset,SC_Offset,N_fft_Point,N_cp1);
    end
    if(syncSuccess==1)
%         N_2_ID_per = 2;
        beamIndex(cnt) = Syn_point;
        %**************************帧同步和N_1_ID计算*******************************
        
        DeN_cell_ID = 3*N_1_ID_out+N_2_ID_per;
        Cell_ID(cnt) = DeN_cell_ID;
        cnt = cnt + 1;
    end
end