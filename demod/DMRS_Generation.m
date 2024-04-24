%**************************************************************************
%Copyright (C), 2018, CQUPT
%FileName:     DMRS_Generation
%Description:  DMRS for PDSCH
%Reference:    [7,38211] clause 7.4.1.1
%Author:       DSP_GROUP
%Input:        S,L,n_PRB,ns,PDCCH_monitor_symbol,CORESET_symb
%              
%Output:       TxDMRSoutdata,DMRSREnum,l,N_DMRS_PRB,delta_p,CDM_group_p,pdsch_freqposition
%History:
%      <time>      <version >
%      2018/8/20      1.0
%**************************************************************************
function [TxDMRSoutdata,DMRSREnum,l,N_DMRS_PRB] = DMRS_Generation(N_cell_ID,S,L,n_PRB,ns,PDCCH_monitor_symbol,CORESET_symb,SSB_firstsym,SSB_L,FD_start,SSB_k0,SSB_RB,resourceallocationtype,type0_RB_number,NR_Params)
% global DL_DMRS_config_type
% global pdsch_symbolAllocationDMRS
% global DL_DMRS_typeA_pos
% global DL_DMRS_add_pos
% global doublesymbolenable
% global DL_DMRS_max_len
% global DL_DMRS_Scrambling_ID
% global N_ID_cell
% global antennaports_p

DL_DMRS_config_type = NR_Params.PDSCH.DL_DMRS_config_type;
pdsch_symbolAllocationDMRS = NR_Params.PDSCH.pdsch_symbolAllocationDMRS;
DL_DMRS_typeA_pos = NR_Params.PDSCH.DL_DMRS_typeA_pos;
DL_DMRS_add_pos = NR_Params.PDSCH.DL_DMRS_add_pos;
doublesymbolenable = NR_Params.PDSCH.doublesymbolenable;
DL_DMRS_max_len = NR_Params.PDSCH.DL_DMRS_max_len;
DL_DMRS_Scrambling_ID = NR_Params.PDSCH.DL_DMRS_Scrambling_ID;
% N_ID_cell = NR_Params.Cell.N_cell_ID;
antennaports_p = NR_Params.PDSCH.antennaports_p;

beta_PDSCHDMRS = NR_Params.PDSCH.beta_PDSCHDMRS;

if pdsch_symbolAllocationDMRS==0   %mapping type A
    if DL_DMRS_typeA_pos==3
        l0=3;     %Relative to the starting symbol of the a slot, 0 denote as the first one
    else
        l0=2;
    end
else
    if pdsch_symbolAllocationDMRS==1  %mapping type B
        l0=S;  %Relative to the starting symbol of the PDSCH
    end
end
%%%%%%%%%%% l1 %%%%%%%%%%
if DL_DMRS_max_len==1
    l1=0;
else
    if L==2||L==4     
        l1=0;
    else
        if DL_DMRS_max_len==2
            if doublesymbolenable==0       %single symbol
                l1=0;
            else
                if doublesymbolenable==1   %double symbol
                    l1=[0 1];
                end
            end
        end
    end
end
%%%%%%%%%%%l_bar%Table7.4.1.1.2-3/4%%%%%%%
l_bar = DMRS_l_bar(doublesymbolenable,pdsch_symbolAllocationDMRS,L,DL_DMRS_add_pos,l0);
%%%%%%%%%%%%%%%%%%%%%%%%
l=[];
for i=1:length(l_bar)
    for j=1:length(l1)
        temp=l_bar(i)+l1(j);
        l=[l temp];
    end
end

if L==2||L==4||L==7      %DMRS conflicts with CORESET 
    symboloffset=1;
    for i=1:length(l)
        if l(i)<=PDCCH_monitor_symbol+CORESET_symb&&l(i)>=PDCCH_monitor_symbol;
            l(i)=PDCCH_monitor_symbol+CORESET_symb-1+symboloffset;
            if l(i)>S+L
                l(i)=S+L;
            end
            symboloffset=symboloffset+1;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%


n=1;
for i=1:length(l)
    l_now=l(i);  
    if DL_DMRS_config_type==0
           M_PN(i)= 2*6*n_PRB;  % 2*RE number within one symbol, for type 1   
    else
           M_PN(i)= 2*4*n_PRB;   %Corresponding type 2
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%conflict with SSB%%%%%%%%%%%%%
    DMRS_symbolposition=l_now;
    ssb_symbolposition=[];
    for j=1:length(SSB_firstsym)
        temp=SSB_firstsym(j):SSB_firstsym(j)+SSB_L-1;
        ssb_symbolposition=[ssb_symbolposition temp];
    end
    if resourceallocationtype==0
        pdsch_freqposition = FD_start+type0_RB_number-1;
    else
        pdsch_freqposition = FD_start:FD_start+n_PRB-1;  
    end

    ssb_freqposition=SSB_k0:SSB_k0+SSB_RB-1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    overlappingsymbol_ssb=intersect(DMRS_symbolposition,ssb_symbolposition);
    overlappingfreq_ssb=intersect(pdsch_freqposition,ssb_freqposition);
    subtract_RPB=0;
    if ~isempty(overlappingsymbol_ssb)
        for j=1:length(overlappingsymbol_ssb)
            if ~isempty(overlappingfreq_ssb)
                subtract_RPB=subtract_RPB+length(overlappingfreq_ssb);
            end
        end
    end
    if DL_DMRS_config_type==0
           M_PN(i)= M_PN(i)-2*6*subtract_RPB;  % 2*RE number within one symbol, for type 1   
    else
           M_PN(i)= M_PN(i)-2*4*subtract_RPB;   %Corresponding type 2
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if isempty(DL_DMRS_Scrambling_ID)
        n_SCID = 0;
        N_ID_nSCID = N_cell_ID;
    else
        n_SCID=DL_DMRS_Scrambling_ID(1);
        N_ID_nSCID=DL_DMRS_Scrambling_ID(2);
    end
    
    c_init = mod((2^17)*(14*ns+l_now+1)*(2*N_ID_nSCID+1)+2*N_ID_nSCID+n_SCID,2^31);
    c = pseudo(M_PN(i),c_init);
    for m = 1:M_PN(i)/2
        r(n,m) = (1/sqrt(2))*(1-2*c(2*m-1))+(1i/sqrt(2))*(1-2*c(2*m));
    end
    n = n + 1;   % n denote as symbol number for DMRS; 0,1,2,``````
end
for antenna=1:length(antennaports_p)   %i denote as DMRS for different Antena port
    [a,delta,CDM_group] = DMRS_ResMapForPDSCH(r,l1,l_bar,DL_DMRS_config_type,antennaports_p(antenna),M_PN,beta_PDSCHDMRS);%CH7.4.1.1.2
    a_p(antenna,:) = a;   %a_p's every row denote as total DMRS RE for each antena port 
    delta_p(antenna,:) = delta;
    CDM_group_p(antenna,:) = CDM_group;
end

TxDMRSoutdata = a_p;
DMRSREnum = 0;
N_DMRS_PRB = 0;
for t=1:length(M_PN)
    DMRSREnum = DMRSREnum + M_PN(t)/2;    %Total REs of DMRS       
end                    
N_DMRS_PRB = N_DMRS_PRB + M_PN(t)/2/n_PRB;  % is the REs of DM-RS within a PRB                      
if DL_DMRS_config_type==0
    N_DMRS_PRB = 6*length(l);  % 2*RE number within one symbol, for type 1   
else
    N_DMRS_PRB = 4*length(l);   %Corresponding type 2
end 

                
                      
                     