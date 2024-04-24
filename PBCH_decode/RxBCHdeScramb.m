function RxdeScrambDataOut1 = RxBCHdeScramb(RxPBCH_demodQPSK_out,N_cell_ID,PBCH_L_max)
% global N_cell_ID;
% global PBCH_v;
% global PBCH_L_max;

% N_cell_ID = NR_Params.Cell.N_cell_ID;
% PBCH_L_max = NR_Params.SSB.PBCH_L_max;

for PBCH_v=0:3
    cinit = N_cell_ID;
    A=length(RxPBCH_demodQPSK_out);
    if PBCH_L_max==4||PBCH_L_max==8
        M=A-3;
        a=[6 24 0];
        c = pseudo(PBCH_v*M+29,cinit);
    elseif PBCH_L_max==64
        M=A-6;
        a=[6 24 0 5 3 2];
        c = pseudo(PBCH_v*M+26,cinit);
    end
    a=a+1;
    j=1;
    %s序列的生成
    for i=1:A
       if find(i==a)
           s(i)=0;
       else
           s(i)=c(j+PBCH_v*M);
           j=j+1;
       end
    end
    for i1 = 1:A
        if RxPBCH_demodQPSK_out(i1)== s(i1)
            a1(i1) = 0;  
        else
            a1(i1) = 1;
        end
    end
    RxdeScrambDataOut1(PBCH_v+1,:) = a1;
end
