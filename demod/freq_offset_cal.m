function f = freq_offset_cal(H,sampleRate)

H_theta = H(:,3).*conj(H(:,1));
H_theta_sum = sum(H_theta);
deta_theta = atan2(imag(H_theta_sum),real(H_theta_sum));
f = deta_theta*sampleRate/(2*pi*4096*2*1);

