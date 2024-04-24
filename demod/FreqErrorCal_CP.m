function Delta_f = FreqErrorCal_CP(Frame_data,beamper,sampleRate,N_FFT,N_CP1)
% Function:
%     Frequency Error Calculate
% Inputs:
%     Frame_data = OFDM BaseBand Signal
%     Syn_point = Syn Point
% output:
%     Delta_f = Frequency Error


I0_0 = beamper;


mean_correlat = zeros(1,4);
  
for j = 1:4
    T1 = Frame_data(I0_0-N_CP1+(j-1)*(N_FFT+N_CP1)+1:I0_0+(j-1)*(N_FFT+N_CP1));
    T2 = Frame_data(I0_0-N_CP1+(j-1)*(N_FFT+N_CP1)+N_FFT+1:I0_0+(j-1)*(N_FFT+N_CP1)+N_FFT);
    cp_correlat = T2.*conj(T1);
    mean_correlat(j) = mean(cp_correlat(50:N_CP1-50));
end

mean_mean_correlat = mean(mean_correlat);
deta_theta = atan2(imag(mean_mean_correlat),real(mean_mean_correlat));

% if(deta_theta<0)
%     deta_theta = deta_theta + 2*pi;
% end
Delta_f = mean(deta_theta)*sampleRate/(2*pi*N_FFT);


