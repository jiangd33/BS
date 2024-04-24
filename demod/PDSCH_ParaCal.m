function [K0,S,L,L_RBs,RB_start] = PDSCH_ParaCal(MIB,DCI,N_DL_BWP)
% K0 = DCI.TimeDomainResAssign;
% Table 5.1.2.1.1-2 in Ts38.214 V15.4.0
Table1 = [0,2,12;0,2,10;0,2,9;0,2,7;
          0,2,5;0,9,4;0,4,4;0,5,7;
          0,5,2;0,9,2;0,12,2;0,1,13;
          0,1,6;0,2,4;0,4,7;0,8,4];
Table2 = [0,3,11;0,3,9;0,3,8;0,3,6;
          0,3,4;0,10,4;0,6,4;0,5,7;
          0,5,2;0,9,2;0,12,2;0,1,13;
          0,1,6;0,2,4;0,4,7;0,8,4;];

if(MIB.DMRS_TypeA_Position==0)
    K0 = Table1(DCI.TimeDomainResAssign+1,1);
    S = Table1(DCI.TimeDomainResAssign+1,2);
    L = Table1(DCI.TimeDomainResAssign+1,3);
else
    K0 = Table2(DCI.TimeDomainResAssign+1,1);
    S = Table2(DCI.TimeDomainResAssign+1,2);
    L = Table2(DCI.TimeDomainResAssign+1,3);
end
% 参考Ts38.214 5.1.2.2.2 由DCI1_0调度的PDSCH，其资源映射类型满足type1
RIV = DCI.FreqDomainResAssign;
L_RBs = floor(RIV/N_DL_BWP)+1;
RB_start = RIV - (L_RBs-1)*N_DL_BWP;
% % % % if(((L_RBs-1)>floor(N_DL_BWP/2))||(L_RBs+RB_start)~=N_DL_BWP)
% % % %     L_RBs = N_DL_BWP + 1 - floor(RIV/N_DL_BWP);
% % % %     RB_start = N_DL_BWP - (RIV - N_DL_BWP*floor(RIV/N_DL_BWP)) - 1;
% % % % end
if(((L_RBs-1)>floor(N_DL_BWP/2))||L_RBs>(N_DL_BWP-RB_start))
    L_RBs = N_DL_BWP + 1 - floor(RIV/N_DL_BWP);
    RB_start = N_DL_BWP - (RIV - N_DL_BWP*floor(RIV/N_DL_BWP)) - 1;
end


