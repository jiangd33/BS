function [H,freq_offset,ThetaComp] = Channel_estimation_LS_linear_PBCH(N_cell_ID,TxDLDMRSSeqOut_local,Y)

SSB_L = 4;
SSB_RB = 20;
N_RB_sc = 12;

v1 = mod(N_cell_ID,4);
H = zeros(SSB_RB*N_RB_sc,SSB_L-1);                       
L = length(TxDLDMRSSeqOut_local);

Hp = Hp_LS(TxDLDMRSSeqOut_local,Y);
% shift_up = 4-v1;
% shift_down = v1;
Hd = linear_inter_PBCH(Hp,v1); 

freq_offset = freq_offset_cal(Hd,122880000);

deltaH1 = Hd(:,3)./Hd(:,1);theta1 = atan2(imag(deltaH1),real(deltaH1));
dmrs_distance = 2;
ThetaComp = (mean(theta1)-0*pi)/dmrs_distance;


H(:,1) = smooth(Hd(:,1),19);
H(:,2) = [smooth(Hd(1:48,2),19);Hd(49:192,2);smooth(Hd(193:240,2),19)];
H(:,3) = smooth(Hd(:,3),19);

% % H(:,1) = (Hd(:,1)+Hd(:,1))/2;
H(:,2) = (H(:,1)+H(:,3))/2;
% % H(:,3) = (Hd(:,3)+Hd(:,3))/2;

% % H(:,2) = [smooth(Hd(1:48,2),19);Hd(49:192,2);smooth(Hd(193:240,2),19)];
% % H(:,3) = smooth(Hd(:,3),19);




