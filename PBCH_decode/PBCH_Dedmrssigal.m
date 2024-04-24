function [Y] = PBCH_Dedmrssigal(input,N_cell_ID)

% N_cell_ID = NR_Params.Cell.N_cell_ID;
SSB_k0 = 0;

v1 = mod(N_cell_ID,4);
%Ã·»°DMRS
k=1;
for i = 1:4:237
    Rx_PBCH_DMRS(k) = input(SSB_k0+i+v1,2);
%     input(SSB_k0+i+v1,2)=0;
    k=k+1;
end
for j=1:4:45
    Rx_PBCH_DMRS(k) = input(SSB_k0+j+v1,3);
%     input(SSB_k0+j+v1,3)=0;
    k=k+1;
end
for j2=193:4:237
    Rx_PBCH_DMRS(k) = input(SSB_k0+j2+v1,3);
%     input(SSB_k0+j2+v1,3) = 0;
    k=k+1;
end
for j1=1:4:237
    Rx_PBCH_DMRS(k) = input(SSB_k0+j1+v1,4);
%     input(SSB_k0+j1+v1,4)= 0;
    k=k+1;
end
Y=Rx_PBCH_DMRS;
% TxPBCH_SSB_out_temp = input;