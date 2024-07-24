function [de_crc_flag,RxPBCH_out]= RxPBCH_bit(Rx_PBCH,PBCH_i,N_cell_ID,Rx_pbch_L_max)
PBCH_CRC_len = 56;I_IL=1;  
%% DeMod
RxPBCH_demodQPSK_out = qpsk_demod(1,Rx_PBCH);
%% De Scrambing
RxdeScrambDataOut = RxBCHdeScramb1(RxPBCH_demodQPSK_out,PBCH_i,N_cell_ID,Rx_pbch_L_max);
%% De RateMatching
de_rate_matching_out = DeRatematchingForPolar(RxdeScrambDataOut,512);
%% Bit Reorder and Decode
% % index = bit_re_order(512);
% % de_rate_matching_out = de_rate_matching_out(index);
% % polar_decoding_out = Polar_decoding(de_rate_matching_out,2,PBCH_CRC_len,I_IL);%polar_decoding%»Ö¸´Õý³£
polar_decoding_out = PolarDecode_matlab(de_rate_matching_out,56,I_IL,0)';
%% CRC
de_crc_flag = Check_CRC_PBCH(polar_decoding_out,6);
if(de_crc_flag==1)
    de_crc_out = Get_check_crc_out(polar_decoding_out,6);
    %212½âÈÅ
    RxdeScrambDataOut1 = RxBCHdeScramb(de_crc_out,N_cell_ID,Rx_pbch_L_max);
    RxPBCH_out = RxPBCH(RxdeScrambDataOut1);
else
    RxPBCH_out = 0;
end

end