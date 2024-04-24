%==========================================================================
%Copyright (C), 2018, CQUPT
%FileName:     frame_Syn_caculate
%Description:
%Author:       DSP_GROUP
%Input:        1.signal: PSS(N_2_ID+1,:)
%              2.ofdm_cpout_delay: the receive data
%              3.Rude_Syn_point: the rude synchronization point
%Output:       Syn_point:the synchronization point
%History:
%      <time>      <version >
%      2018/3/28      1.0
%==========================================================================
function [Syn_point,syncSuccess] = Syn_point_caculate(signal,ofdm_cpout_delay,Rude_Syn_point,N)

D = N;

if(Rude_Syn_point-D/2<0)
    syncSuccess = 0;
    Syn_point = 0;
    return;
end

y(1:N+D) = ofdm_cpout_delay(Rude_Syn_point-D/2+1:Rude_Syn_point+D/2+N);
% % MT = zeros(1,D);
% % for d=1:D
% %     MT(d)= MT(d)+sum(y(d:d-1+N).*conj(signal(1:N)));
% % end
MT = conv(y,conj(signal(end:-1:1)));

output = MT(N:2*N-1);
% figure;plot(abs(MT),'Color',[0 0.6 0])
output1 = abs(output);
% figure;plot(output1);
% % % % subplot(4,1,4),plot(output1);hold on;
[a,b] = max(abs(output));
Syn_point = Rude_Syn_point-D/2+b;

% standard = std(output1);
% if(b>N/2-200&&b<N/2+200)
%     output1(b-100:b+100) = mean(output1);
%     standard1 = std(output1);
%     if(standard>2*standard1)
%         syncSuccess = 1;
%     else
%         syncSuccess = 0;
%     end
% else
%     syncSuccess = 0;
% end




if(b>N/2-200&&b<N/2+200)
    output(b-100:b+100) = 0;
    if(a>5*mean(abs(output)))
%         figure;plot(abs(output))
        syncSuccess = 1;
    else
        syncSuccess = 0;
    end
else
    syncSuccess = 0;
end
% syncSuccess = 1;
