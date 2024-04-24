function RxdeScrambDataOut = RxBCHdeScramb1(RxPBCH_demodQPSK_out,PBCH_i,N_cell_ID,Rx_pbch_L_max)
% global PBCH_v;
cinit = N_cell_ID;
M=length(RxPBCH_demodQPSK_out);
if (Rx_pbch_L_max==4)
    Rx_SSB_v =mod(PBCH_i-1,4);
else
    Rx_SSB_v =mod(PBCH_i-1,8);
end
% for i1 = 1:length(Rx_SSB_v)
c = pseudo(Rx_SSB_v*M+M,cinit);
c1 = zeros(1,M);
for j1 = 1:M
   c1(j1) = c(j1+Rx_SSB_v*M);
end

% % % % % % for i=1:M
% % % % % %     if c1(i)==1
% % % % % %         b(i)=1;
% % % % % %     else
% % % % % %         b(i)=-1;
% % % % % %     end
% % % % % % end
% % % % % % RxdeScrambDataOut = b.*RxPBCH_demodQPSK_out;
c1 = 2.*c1 - 1;    
% Descramble
RxdeScrambDataOut = RxPBCH_demodQPSK_out.*c1;