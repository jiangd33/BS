function rsrp_dbm = nr_rsrp_cal(rxSym,refSym)
% rsrpPerAntPerRes(rxAntIdx,resIdx) = abs(mean(rxSym.*conj(refSym))*ports)^2;
% rssiPerAntPerRes(rxAntIdx,resIdx) = sum(rssiSym.*conj(rssiSym))/numCSIRSSym;
% rsrqPerAntPerRes(rxAntIdx,resIdx) = N*rsrpPerAntPerRes(rxAntIdx,resIdx)/rssiPerAntPerRes(rxAntIdx,resIdx);
                
                
rsrp_dbm = 10*log10(abs(mean(rxSym.*conj(refSym)))^2);% dBm