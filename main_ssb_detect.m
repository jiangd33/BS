%==========================================================================
%Description:  Cell research and decode
%Input:        IQ baseband signal
%Output:       CellId/evm/freqoffset
%Author£º      Jiangdan
%History:
%              <time>      <version >
%              2018/10/28      1.0
%              2020/05/21      2.0
%              2021/08/31      3.0
%==========================================================================
%
clear all;
close all;clear;
addpath('DL');addpath('PBCH_decode');addpath('data');addpath('demod')
%%

load('./data/txWaveform_SSB.mat');
rxWaveform_ideal = txWaveform(1:end);
figure;plot(20*log10(abs(rxWaveform_ideal)));
figure;plot(20*log10(abs(fftshift(fft(rxWaveform_ideal(1:end))))));

%%
N_RB_sc = 12;
f0 = 3.50976e9;
% f0 = 773e6;
para = parameterSetting(f0);
f0 = 0;
BandWidth = para.BandWidth;
SCS = para.SCS;

% SSB_RB_Offset = para.SSB_RB_Offset;
% SSB_SC_Offset = para.SSB_SC_Offset;
SSB_RB_Offset = 125;
SSB_SC_Offset = 0;
SSB_index = [2,8,16,22,30,36,44];%case C symbol index in OFDM
%%
[N_RB,mu,N_SLOT,N_FFT,~,N_cp0,N_cp1] = N_RB_Cal(BandWidth,SCS);
sampleRate = 61440000*2^((SCS/15)-1);

n = 1:N_FFT;
table = zeros(N_FFT,1);
table(n) = exp(-1i * 2 * pi /N_FFT* (0 - floor(12 *N_RB/ 2)) * (n-1));
table = repmat(table,1,4);
    
for snr_i = 5:10
    snr = snr_i*5-15;

    rxWaveform_1frame = rxWaveform_ideal(1:614400);
    rxWaveform = awgn(rxWaveform_1frame,snr,'measured');
   
    %% multi beam search
    Rx_pbch_L_max = 8;
    [beamIndex,Cell_ID] = multiBeamSearch(rxWaveform,N_FFT,N_RB,SSB_RB_Offset,SSB_SC_Offset,N_cp1);
    %%
    
    SIB1_decode_cnt = 0;
    for inx = 1:length(beamIndex)
        TimeDataTmp = zeros(N_FFT,4);
        beamper = beamIndex(inx)+0;% - 50; %process for per beam

        % Delta_f = FreqErrorCal_CP(rxWaveform,beamper,sampleRate,N_FFT,N_cp1);
        Delta_f = 0;
        rxWaveform = rxWaveform.*exp(-2*pi*1j*Delta_f*(1:length(rxWaveform))/sampleRate);

        % remove CP
        Tc = 1/(SCS*1000*N_FFT);
        T = 1*(N_FFT + N_cp1)*Tc;
        Fai = 2*pi*f0*(N_cp1*Tc+T);
        RxDataTime(:,1) = rxWaveform(beamper:beamper+N_FFT-1)*(cos(Fai)+1j*sin(Fai));

        T = 2*(N_FFT + N_cp1)*Tc;
        Fai = 2*pi*f0*(N_cp1*Tc+T);
        RxDataTime(:,2) = rxWaveform(beamper+N_FFT+N_cp1:beamper+N_FFT+N_cp1+N_FFT-1)*(cos(Fai)+1j*sin(Fai));
        T = 1*(N_FFT + N_cp1)*Tc;
        Fai = 3*pi*f0*(N_cp1*Tc+T);
        RxDataTime(:,3) = rxWaveform(beamper+2*(N_FFT+N_cp1):beamper+2*(N_FFT+N_cp1)+N_FFT-1)*(cos(Fai)+1j*sin(Fai));
        T = 1*(N_FFT + N_cp1)*Tc;
        Fai = 4*pi*f0*(N_cp1*Tc+T);
        RxDataTime(:,4) = rxWaveform(beamper+3*(N_FFT+N_cp1):beamper+3*(N_FFT+N_cp1)+N_FFT-1)*(cos(Fai)+1j*sin(Fai));

        % FFT and shift
        input = table.*RxDataTime;
        SSB_freq = fft(input,N_FFT);

        % SINR cal
        SINR = SINR_cal(SSB_freq,SSB_RB_Offset,SSB_SC_Offset);

        % beamID detection
        ResMapPointer_PBCH = SSB_freq(SSB_RB_Offset*N_RB_sc+SSB_SC_Offset+1:SSB_RB_Offset*N_RB_sc+SSB_SC_Offset+240,:);
        BeamId = BeamId_detectiom(ResMapPointer_PBCH,Cell_ID(inx),Rx_pbch_L_max);
        %     BeamId = 0;
        %% PBCH demod and MIB decode
        request.N_cell_ID = Cell_ID(inx);
        request.RB_Offset = SSB_RB_Offset;
        request.SC_Offset = SSB_SC_Offset;
        request.N_FFT = N_FFT;
        request.N_cp1 = N_cp1;
        request.SCS = SCS;
        request.BeamId = BeamId;
        request.sampleRate = sampleRate;

        tic;
        [response,ThetaComp] = Rx_PBCH_main(request,ResMapPointer_PBCH,Rx_pbch_L_max);
        toc;
    end
end
SIB1_decode_cnt
% end


