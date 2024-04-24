function TxPBCH_DMRS_local=TxPBCH_DMRS_local(Rx_pbch_L_max,N_cell_ID)
% global N_cell_ID;
% global BW_cqrrier_f;
% global Rx_pbch_L_max;

% Rx_pbch_L_max = NR_Params.SSB.PBCH_L_max;
% N_cell_ID = NR_Params.Cell.N_cell_ID;
% BW_cqrrier_f = NR_Params.Cell.BW_cqrrier_f;

% if(RxDL_mu==0)
%     if(BW_cqrrier_f<3*10^9||BW_cqrrier_f==3*10^9)
%         Rx_pbch_L_max = 4;%2*2
%     elseif(BW_cqrrier_f>3*10^9||BW_cqrrier_f<6*10^9)
%         Rx_pbch_L_max = 8;%2*4
%     end
% elseif(RxDL_mu==1)%CASE2
%     if(BW_cqrrier_f<3*10^9||BW_cqrrier_f==3*10^9)
%         Rx_pbch_L_max = 4;%4*1
%     elseif(BW_cqrrier_f>3*10^9||BW_cqrrier_f<6*10^9)
%         Rx_pbch_L_max = 8;%4*2
%     end
% elseif(RxDL_mu==3)
%     if(BW_cqrrier_f>6*10^9)
%         Rx_pbch_L_max = 64;
%     end
% elseif(RxDL_mu==3)
%     if(BW_cqrrier_f>6*10^9)
%         Rx_pbch_L_max = 64;
%     end
% end

if(Rx_pbch_L_max==4)
    n_hf_max = 1;
else
    n_hf_max = 0;
end
lenc = 144*2;%211 Table 7.4.3.1-1

n_hf=0:n_hf_max;
i_SSB = 0:mod(Rx_pbch_L_max-1,8);
% if PBCH_L_max==4
%     n_hf=0;%the number of the half-frame in which the PBCH is transmitted in  frame 
%     i_SSB=mod(PBCH_L,4);%低2位
% else
%     n_hf=0;%n_hf=0
%     i_SSB=mod(PBCH_L,8);%低三位
% end
k=1;
for i1=1:length(n_hf)
    for i2 = 1:length(i_SSB)
        i_SSB_bar(k) = i_SSB(i2) + 4*n_hf(i1);
        k=k+1;
    end
end
%===============c序列生成==================
c_init=2^11*(i_SSB_bar+1)*(floor(N_cell_ID/4)+1)+2^6*(i_SSB_bar+1)+mod(N_cell_ID,4);
for i=1:8
    c(i,:) = pseudo(lenc,c_init(i));
end
%==============r序列生成====================
for j1=1:8
    for m=1:lenc/2
        r(j1,m)=1/sqrt(2)*(1-2*c(j1,2*m-1))+1j*1/sqrt(2)*(1-2*c(j1,2*m));
    end
end
TxPBCH_DMRS_local = r;
end