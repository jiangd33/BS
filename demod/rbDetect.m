function [RB_num,RB_start] = rbDetect(powerRB)
% % % len = N_RB+2;
% % % powerRB = zeros(1,len);
% % % for i = 1:len
% % %     start = (4096 - len*12)/2 + (i-1)*12;
% % %     for j = start:start+11
% % %         powerRB(i) = powerRB(i) + abs(symb_fft_reshape(j)*symb_fft_reshape(j));
% % %     end
% % % end

powerRB_ds = powerRB(1:300:end);

len = length(powerRB_ds);
v = mean(abs(powerRB_ds));
powerThreshold = 2*v;
maxDelta = 1;
minDelta = 1;
upIndex = 1;
downIndex = 1;
for k = 1:len-1
    tmp = powerRB_ds(k+1)/powerRB_ds(k);
    if(tmp>maxDelta&&powerRB_ds(k+1)>powerThreshold)
        maxDelta = tmp;
        upIndex = k;
    elseif(tmp<minDelta&&powerRB_ds(k)>powerThreshold)
        minDelta = tmp;
        downIndex = k;
    end
end
RB_num = downIndex - upIndex;
RB_start = upIndex;