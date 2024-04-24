% function RxPBCH_out = RxPBCH(RxdeScrambDataOut1)
% a=ones(1,32)*100;%还原后的数据的初始化
% G=[16 23 18 17 8 30 10 6 24 7 0 5 3 2 1 4 9 11 12 13 14 15 19 20 21 22 25 26 27 28 29 31];%212 Table 7.1.1-1
% G=G+1;%下标不为0
% %全部比协议上多1，因为下标不可为0
% for i=1:32
%     a(i)=RxdeScrambDataOut1(G(i));
% end
% RxPBCH_out = a;

function RxPBCH_out = RxPBCH(RxdeScrambDataOut1)
a=ones(4,length(RxdeScrambDataOut1(1,:)))*100;%还原后的数据的初始化
G=[16 23 18 17 8 30 10 6 24 7 0 5 3 2 1 4 9 11 12 13 14 15 19 20 21 22 25 26 27 28 29 31];%212 Table 7.1.1-1
G=G+1;%下标不为0
%全部比协议上多1，因为下标不可为0
% j_HRF=11;
% j_SSB=12;
% j_other=15;
% d=7;
for u=1:4
j_SFN = 1;
j_HRF = 11;
j_SSB = 12;
j_Reserved = 12;
j_other = 15;

for i=1:length(RxdeScrambDataOut1(1,:))
    if((i>=2&&i<=7)||(i>=25&&i<=28))
        a(u,i)=RxdeScrambDataOut1(u,G(j_SFN));
        j_SFN=j_SFN+1;
    elseif i==29
        a(u,i)=RxdeScrambDataOut1(u,G(j_HRF));
    elseif (i>=30&&i<=32)
        a(u,i)=RxdeScrambDataOut1(u,G(j_SSB));
        j_SSB=j_SSB+1;
    else
        a(u,i)=RxdeScrambDataOut1(u,G(j_other));
        j_other=j_other+1;
    end
end

SFN=[a(u,26) a(u,27)];
PBCH_v=SFN(2)*2^0+SFN(1)*2^1+1;
if PBCH_v==u
    RxPBCH_out= a(u,:);
    break;
end
end


