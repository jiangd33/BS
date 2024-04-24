function BeamId = BeamId_detectiom(ResMapPointer_PBCH,N_cell_ID,Rx_pbch_L_max)


Y = PBCH_Dedmrssigal(ResMapPointer_PBCH,N_cell_ID);

TxPBCH_DMRS_local_out = TxPBCH_DMRS_local(Rx_pbch_L_max,N_cell_ID);

valueBuf = zeros(1,Rx_pbch_L_max);
for k = 1:Rx_pbch_L_max
    DMRSxcorr = abs(sum((Y(1:60).*conj(TxPBCH_DMRS_local_out(k,1:60)))));
    valueBuf(k) = abs(real(DMRSxcorr)) + abs(imag(DMRSxcorr));
end
[~,BeamId] = max(valueBuf);
BeamId = BeamId - 1;

