function T = TxPDSCH_DMRS_local(DL_DMRS_Scrambling_ID,N_ID_cell,ConfigType,PDSCH_RB_Num,PDSCH_RB_Offset,SlotIndex,l_now)
% l_now = 2;
ns = SlotIndex;
if isempty(DL_DMRS_Scrambling_ID)
    n_SCID = 0;
    N_ID_nSCID = N_ID_cell;
%         N_ID_nSCID = 1;
else
    n_SCID = DL_DMRS_Scrambling_ID(1);
    N_ID_nSCID = DL_DMRS_Scrambling_ID(2);
end

if(ConfigType==1)
    num1 = PDSCH_RB_Num*6;
    num2 = PDSCH_RB_Offset*6;
    N = num1 + num2;
else
    num1 = PDSCH_RB_Num*4;
    num2 = PDSCH_RB_Offset*4;
    N = num1 + num2;
end

c_init = mod((2^17)*(14*ns+l_now+1)*(2*N_ID_nSCID+1)+2*N_ID_nSCID+n_SCID,2^31);
c = pseudo(N*2,c_init);
r = zeros(1,N);
for m = 1:N
    r(m) = (1/sqrt(2))*(1-2*c(2*m-1))+(1i/sqrt(2))*(1-2*c(2*m));
end

T = r(num2+1:num2+num1);
    
%     n=n+1;   % n denote as symbol number for DMRS; 0,1,2,````