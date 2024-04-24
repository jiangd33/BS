%==========================================================================  
%Description:  Cell research and decode
%Input:        IQ baseband signal
%Output:       CellId/evm/freqoffset
%Author：      Jiangdan
%History:
%              <time>      <version >
%              2018/10/28      1.0
%              2020/05/21      2.0
%              2021/08/31      3.0
%==========================================================================

clear;
close all;
addpath('DL');
addpath('data')
addpath('PBCH_decode');
addpath('demod')
%%
fid = fopen('data/7-28-14-2-57.iqw','rb'); 
data = fread(fid,'float');
fclose(fid);
I_data = data(2:2:end);
Q_data = data(1:2:end);
rxWaveform = I_data +1j*Q_data;
% Read the collected 5G base station signals with the central frequency of China Unicom's 3.5G.


%%
rxWaveform = rxWaveform *10000; 
% The actual base station signal power is relatively low. For visualization convenience, both I and Q signals are amplified by a factor of 10,000, without affecting signal detection and demodulation.

%%
N     = 200;   % Order
Fpass = 0.2;  % Passband Frequency
Fstop = 0.3;   % Stopband Frequency
Wpass = 1;     % Passband Weight
Wstop = 1;     % Stopband Weight
dens  = 20;    % Density Factor
% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fpass Fstop 1], [1 1 0 0], [Wpass Wstop], {dens});
rxWaveform = conv(rxWaveform,b,'same');
% Fir filter, Filter out-of-band signals.

%%
rxWaveform = rxWaveform(1:end).';
figure;plot(20*log10(abs(rxWaveform)));
figure;plot(20*log10(abs(fftshift(fft(rxWaveform(1:end))))));

%%
BandWidth = 100;
SCS = 30;

SSB_RB_Offset = 126;%126;%SSB RB偏移
SSB_SC_Offset = 6;%6;  %SSB 子载波偏移
% f0 = 0;
f0 = 3.545e9;
%%
[N_RB,mu,N_SLOT,N_FFT,~,N_cp0,N_cp1] = N_RB_Cal(BandWidth,SCS);
sampleRate =122.88e6;

%% multi beam search
Rx_pbch_L_max = 8;
[beamIndex,Cell_ID] = multiBeamSearch(rxWaveform(1:614400),N_FFT,N_RB,SSB_RB_Offset,SSB_SC_Offset,N_cp1);

%%
n = 1:N_FFT;
table(n) = exp(-1i * 2 * pi /N_FFT* (0 - floor(12 *N_RB/ 2)) * (n-1));%上行基带信号生成
table = [table;table;table;table];
table = table.';
N_RB_sc = 12;
SSB_index = [2,8,16,22,30,36,44];%case C symbol index in OFDM 

SIB1_decode_cnt = 0;
for inx = 1:length(beamIndex)
    TimeDataTmp = zeros(N_FFT,4);
    beamper = beamIndex(inx)+0;% - 50; %process for per beam
    
    Delta_f = 0;
    rxWaveform = rxWaveform.*exp(-2*pi*1j*Delta_f*(1:length(rxWaveform))/sampleRate);
    
    % remove CP
    RxDataTime(:,1) = rxWaveform(beamper:beamper+N_FFT-1);
    RxDataTime(:,2) = rxWaveform(beamper+N_FFT+N_cp1:beamper+N_FFT+N_cp1+N_FFT-1);
    RxDataTime(:,3) = rxWaveform(beamper+2*(N_FFT+N_cp1):beamper+2*(N_FFT+N_cp1)+N_FFT-1);
    RxDataTime(:,4) = rxWaveform(beamper+3*(N_FFT+N_cp1):beamper+3*(N_FFT+N_cp1)+N_FFT-1);
    
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
    response = Rx_PBCH_main(request,ResMapPointer_PBCH,Rx_pbch_L_max);
    toc;
    
end
SIB1_decode_cnt
% end


