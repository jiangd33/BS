function SINR = SINR_cal(SSB_freq,RB_Offset,SC_Offset)
N_RB_sc = 12;

TotalPower = (sum(abs(SSB_freq(:,2))));

SignalPower = (mean(abs(SSB_freq(RB_Offset*N_RB_sc+SC_Offset+1:RB_Offset*N_RB_sc+SC_Offset+240,2))));

NoisePower = (mean(abs(SSB_freq(133*12+1:2048,2))));

SINR = 20*log10(SignalPower/NoisePower);