function PBCH_Data = PBCH_demapping(request,TX_OFDM,Syn_point,f0)
% cplen = 288;
% Len = 4096;
Len = request.N_FFT;
cplen = request.N_cp1;
% Syn_point = Syn_point - 30;
% % % % RB_Offset = request.RB_Offset;
% % % % SC_Offset = request.SC_Offset;
% % % % N_cell_ID = request.N_cell_ID;

TX_OFDM = DL_upconversion_phase_slot(TX_OFDM,f0,Len,Syn_point);
    
Symbol1 = TX_OFDM(Syn_point:Syn_point+Len-1);
Symbol2 = TX_OFDM(Syn_point+Len+cplen:Syn_point+Len+cplen+Len-1);
Symbol3 = TX_OFDM(Syn_point+2*Len+2*cplen:Syn_point+2*Len+2*cplen+Len-1);
Symbol4 = TX_OFDM(Syn_point+3*Len+3*cplen:Syn_point+3*Len+3*cplen+Len-1);          %?CP

PBCH_Data = [Symbol1.' Symbol2.' Symbol3.' Symbol4.'];



