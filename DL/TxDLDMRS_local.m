%=======================================================
% Filename: TxDLDMRSSeqOut_local.m
% Function: PDCCH DMRS local generation for one CORESET
% Author:   LiAnyi
% Data:     2018/01/29
%=======================================================
function TxDLDMRSSeqOut_local = TxDLDMRS_local(PDCCH_RB_Num,PDCCH_RB_Offset,N_cell_ID,n_u_sf)
% % % % CORESET_symb = 1;
% % % % 
% % % % % REG_DMRSnum = 3*(CORESET_RB+30);
% % % % REG_DMRSnum = 3*(PDCCH_RB_Num+PDCCH_RB_Offset);
% % % % r = zeros(CORESET_symb,REG_DMRSnum);
% % % % 
% % % % n_u_sf = 0;
% % % % N_ID = N_cell_ID;
% % % % % N_ID = 1;
% % % % 
% % % % % for l = 0:CORESET_symb-1
% % % % l = 0;
% % % %     cinit = mod((2^17*(14*n_u_sf+l+1)*(2*N_ID+1)+2*N_ID),2^31);
% % % % 
% % % %     lenc = 2*REG_DMRSnum;
% % % %     c = pseudo(lenc,cinit);
% % % %     for m = 1:REG_DMRSnum
% % % %        r(l+1,m) = 1/sqrt(2)*(1-2*c(2*m-1))+1j*1/sqrt(2)*(1-2*c(2*m));
% % % %     end                                              
% % % % TxDLDMRSSeqOut_local = r(PDCCH_RB_Offset*3+1:(PDCCH_RB_Offset+PDCCH_RB_Num)*3);

CORESET_symb = 1;

% REG_DMRSnum = 3*(CORESET_RB+30);
REG_DMRSnum = 3*(PDCCH_RB_Num);
r = zeros(CORESET_symb,REG_DMRSnum);

% n_u_sf = 10;
N_ID = N_cell_ID;

l = 0;
    cinit = mod((2^17*(14*n_u_sf+l+1)*(2*N_ID+1)+2*N_ID),2^31);

    lenc = 2*REG_DMRSnum;
    c = pseudo(lenc,cinit);
    for m = 1:REG_DMRSnum
       r(l+1,m) = 1/sqrt(2)*(1-2*c(2*m-1))+1j*1/sqrt(2)*(1-2*c(2*m));
    end                                              
TxDLDMRSSeqOut_local = r(1:(PDCCH_RB_Num)*3);
end