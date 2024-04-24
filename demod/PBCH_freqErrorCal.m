
function freq_offset = PBCH_freqErrorCal(ResMapPointer_PBCH)
load('REF_PSS.mat');load('REF_SSS.mat');
H = zeros(127,3);
H(:,1) = ResMapPointer_PBCH(57:183,1)./REF_PSS.';
H(:,3) = ResMapPointer_PBCH(57:183,3)./REF_SSS.';
freq_offset = freq_offset_cal(H,122880000);
