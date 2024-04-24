function TX_OFDM = DL_upconversion_phase_slot(TX_OFDM,f0,Len,Syn_point,SCS)

Ncp = 288;
% Tc = 1/(30000*Len);
% Tc = 1/(30000*4096);
Tc = 1/(SCS*1000*4096);
% TX_OFDM_upconversion_phase = TX_OFDM;

SynNew = Syn_point;
for i = 0:0
    for j = 0:13
        T = j*(4096 + 288)*Tc;
        Fai = 2*pi*f0*(288*Tc+T);
        for k = 1:(Len)
            TX_OFDM_upconversion_phase(j+1,k) = TX_OFDM(SynNew+i*61440+j*(Len+Ncp)+k)*(cos(Fai)+1j*sin(Fai));
        end
    end
end

TX_OFDM = TX_OFDM_upconversion_phase;