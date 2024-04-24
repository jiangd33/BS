function EXP = EXP_Cal(N_FFT,N_RB,SCS,Offset_high,Offset,PDSCH_RB_Num,PDSCH_RB_offset)
f = zeros((PDSCH_RB_Num+PDSCH_RB_offset)*12,1);
for k = 0:(PDSCH_RB_Num+PDSCH_RB_offset)*12-1
    f(k+1) = SCS*1000*(k + (N_FFT-N_RB*12)/2);
end

mu = log2(SCS/15);
% sampleRate = 61440000*(mu+1);
sampleRate = 61440000;
EXP = exp(2*pi*(Offset_high-Offset)*f*1i/sampleRate);
