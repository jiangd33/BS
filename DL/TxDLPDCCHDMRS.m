%**************************************************************************
% Filename: TxDLPDCCHDMRS.m
% Function: PDCCH DMRS generation for one CORESET
% Author:   LiAnyi
% Input:    PDCCH_DMRS_Scrambling_ID CORESET_RB CORESET_symb
%              
% Output:   TxDLPDCCHDMRSSeqOut
% Data:     2018/01/29
%**************************************************************************
function TxDLPDCCHDMRSSeqOut = TxDLPDCCHDMRS(NR_Params)

% global PDCCH_DMRS_Scrambling_ID;
% global CORESET_RB;
% global CORESET_symb;

PDCCH_DMRS_Scrambling_ID = NR_Params.PDCCH.PDCCH_DMRS_Scrambling_ID;
CORESET_RB = NR_Params.PDCCH.CORESET_RB;
CORESET_symb = NR_Params.PDCCH.CORESET_symb;

REG_DMRSnum = 3*CORESET_symb*CORESET_RB;

cinit = PDCCH_DMRS_Scrambling_ID;
lenc = 2*REG_DMRSnum;
c = pseudo(lenc,cinit);

for m = 1:REG_DMRSnum
   if c(2*m-1) == 0 && c(2*m) == 0
     r(m) = 1/sqrt(2)+1j*1/sqrt(2);
   elseif  c(2*m-1) == 0 && c(2*m) == 1
     r(m) = 1/sqrt(2)-1j*1/sqrt(2);
   elseif  c(2*m-1) == 1 && c(2*m) == 0
     r(m) = -1/sqrt(2)+1j*1/sqrt(2);
   else
     r(m) = -1/sqrt(2)-1j*1/sqrt(2);
   end               
end

%extract DMRS used in one subframe from local generation                              
TxDLPDCCHDMRSSeqOut = reshape(r,1,[]);
%==================END====================