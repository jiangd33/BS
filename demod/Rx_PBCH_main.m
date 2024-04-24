function [response,ThetaComp] = Rx_PBCH_main(request,ResMapPointer_PBCH,Rx_pbch_L_max)
% RB_Offset = request.RB_Offset;
% SC_Offset = request.SC_Offset;
N_cell_ID = request.N_cell_ID;
% N_FFT = request.N_FFT;
% SCS = request.SCS;
% sampleRate = request.sampleRate;


% N_RB_sc = 12;
BeamId = request.BeamId;
% % % % load('EXP.mat');

% Offset_high = 50;
% EXP = EXP_Cal(N_FFT,133,30,Offset_high,0,20,RB_Offset*12+SC_Offset);
% ResMapPointer_PBCH = ResMapPointer_PBCH.*repmat(EXP(RB_Offset*12+SC_Offset+1:RB_Offset*12+SC_Offset+240),1,4);
%%
% % freq_offset = PBCH_freqErrorCal(ResMapPointer_PBCH);
%% 信号检测
Y = PBCH_Dedmrssigal(ResMapPointer_PBCH,N_cell_ID);
%% 生成本地参考信号
TxPBCH_DMRS_local_out = TxPBCH_DMRS_local(Rx_pbch_L_max,N_cell_ID);


%% 信道估计、Polar解码和CRC校验
% % % % load('REF_PSS.mat');load('REF_SSS.mat');
for SSB_i = BeamId:BeamId%求行数
    %信道估计
    [H,~,ThetaComp] = Channel_estimation_LS_linear_PBCH(N_cell_ID,TxPBCH_DMRS_local_out(SSB_i+1,:),Y);  %LS+线性差值求所有RE的H值
    %信号检测
    Recover_Data = Detectsignal_PBCH(H,ResMapPointer_PBCH);
    %拆分信号
    [Rx_PSS,Rx_SSS,Rx_PBCH] = Rx_PBCH_seq(Recover_Data,N_cell_ID);%H1 = ResMapPointer_PBCH(57:57+126,1)./REF_PSS.';H2 = ResMapPointer_PBCH(57:57+126,3)./REF_SSS.';
    
    %Decode 
    figure;plot(Rx_PBCH,'r.');hold on;
    plot(Rx_PSS,'g.');hold on;
    plot(Rx_SSS,'b.');axis([-1.5,1.5,-1.5,1.5]);
    [de_crc_flag,RxPBCH_out] = RxPBCH_bit(Rx_PBCH,SSB_i+1,N_cell_ID,Rx_pbch_L_max);
end

response.RxPBCH_out = RxPBCH_out;
response.de_crc_flag = de_crc_flag;


REF_PBCH = Channel_by_qpsk(Rx_PBCH);

Rx_PSS1 = [Rx_PSS(1:64) Rx_PSS(66:end)];
REF_PSS = Channel_by_pss_sss(Rx_PSS1);
REF_SSS = Channel_by_pss_sss(Rx_SSS);

[EVM_PBCH,EVM_peak_PBCH] = RS_EVM_Cal(Rx_PBCH,REF_PBCH);
EVM_PBCH
[EVM_PSS,EVM_peak_PSS] = RS_EVM_Cal(Rx_PSS1,REF_PSS);
[EVM_SSS,EVM_peak_SSS] = RS_EVM_Cal(Rx_SSS,REF_SSS);


