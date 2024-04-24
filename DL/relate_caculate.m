%==========================================================================
%Copyright (C), 2018, CQUPT
%FileName:     relate_caculate
%Description:
%Author:       DSP_GROUP
%Input:       PSS_after_decimate: PSS after decimation
%             ofdm_cpout_delay: received data after decimation
%Output:      Rude_Syn_point: sync location
%             N_2_ID: cell ID 2
%History:
%      <time>      <version >
%      2018/3/27      1.0
%==========================================================================
function [beamIndex,N_2_ID] = relate_caculate(PSS_after_decimate,ofdm_cpout_delay,downSampleRate)
%**************************************
L=length(ofdm_cpout_delay);
L1=length(PSS_after_decimate(1,:));
P=zeros(3,L+L1-1);
% P=zeros(3,L);
for i=1:3
    pss_ifft = (PSS_after_decimate(i,:));
    coff1 = pss_ifft(end:-1:1);
    P(i,:) = conv(ofdm_cpout_delay,coff1);
    [a(i),b(i)]=max(abs(P(i,:)));
end
% figure;subplot(3,1,1),plot(abs(P(1,:)));subplot(3,1,2),plot(abs(P(2,:)));subplot(3,1,3),plot(abs(P(3,:)))
% figure;plot(abs(P(1,:)));hold on;plot(abs(P(2,:)));hold on;plot(abs(P(3,:)));hold on;
% % % % [c d]=max(abs(a));
% % % % N_2_ID=d-1;
%%
% AnlysisData = abs(P);
coorPeakValue = abs(P);
CorrLen = length(coorPeakValue);
BlockLen = (4096+288)*2/downSampleRate;%(4096+288)*2;%1024;
BlockNum = floor(CorrLen/BlockLen);

PssFactor1 = 4;
PssFactor2 = 1.5;
% [MaxValueAll,~] = max(coorPeakValue);
InforPSS =zeros(BlockNum,3);
for idx = 1:BlockNum
% %     if(idx==182)
% %         idx = idx;
% %     end
    ValidFlag = 0;
    AnlysisData = (coorPeakValue(:,(idx-1)*BlockLen+[1:BlockLen]));
    XcorrPower = mean(AnlysisData.');
    SignalPower = max(AnlysisData.');
    NoisePower = min(XcorrPower);
    threshHold = max([NoisePower*PssFactor1  min(SignalPower)*PssFactor2]);%threshHold = NoisePower*PssFactor1;%    
%     threshHold = NoisePower*PssFactor1;

    SignalPeak = max(AnlysisData.');
    [~,maxPos] = max(SignalPeak); % 选择PSS的三个序列中，找到最大峰值所在序列
    [maxValue,maxPos2] = max(AnlysisData(maxPos,:)); % 在选择的PSS的序列上搜索同步位置
    
    if (maxValue >= threshHold)% &&maxValue >0.5*MaxValueAll)
        ValidFlag = 1;
    end
    InforPSS(idx,:) = [maxPos-1 ValidFlag maxPos2+(idx-1)*BlockLen];
end



beam_cnt = 1;
for idx = 1:BlockNum
    if(InforPSS(idx,2)==1)
        beamIndex(beam_cnt) = InforPSS(idx,3);
        N_2_ID(beam_cnt) = InforPSS(idx,1);
        beam_cnt = beam_cnt + 1;
    end
end
% beamIndex

%%
xlab = 0:5/length(P(1,:)):5-5/length(P(1,:));
figure;p(1) = subplot(3,1,1);plot(xlab,abs(P(1,:)));axis([0 5 0 200]);
xlabel('Time/ms','fontname','Times New Roman','FontSize',12);
ylabel('T({\bf{x}})','fontname','Times New Roman','FontSize',12);
pos = beamIndex*(5/length(P(1,:)));


p(2) = subplot(3,1,2);plot(xlab,abs(P(2,:)));axis([0 5 0 200]);
xlabel('Time/ms','fontname','Times New Roman','FontSize',12);
ylabel('T({\bf{x}})','fontname','Times New Roman','FontSize',12);

p(3) = subplot(3,1,3);plot(xlab,abs(P(3,:)));hold on;axis([0 5 0 200]);
xlabel('Time/ms','fontname','Times New Roman','FontSize',12);
ylabel('T({\bf{x}})','fontname','Times New Roman','FontSize',12);

for k = 1:length(beamIndex)
    value1 = abs(P(N_2_ID(k)+1,beamIndex(k)));
    rectangle(p(N_2_ID(k)+1),'Position',[pos(k)-0.05,value1-60,0.1,80],'EdgeColor','r','LineWidth',1)
    if(k==1)
        % annotation('textarrow',[pos(1)/5+0.16 pos(1)/5+0.12],[value1/200+0.13 value1/200+0.12],'String','Detection','fontname','Times New Roman')
    end
end

dim = [.75 .94 .011 .05];
a = annotation('textbox',dim,'String','Detection','fontname','Times New Roman','EdgeColor','Red','LineWidth',1);

legend(p(1),'T({\bf{x}})','fontname','Times New Roman','FontSize',12,'Location','NorthOutside');legend(p(1),'boxoff')
