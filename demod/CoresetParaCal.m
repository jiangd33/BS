function CoresetPara = CoresetParaCal(MIB,SSB_i,SCS)
bit1 = MIB.PDCCH_ConfigSIB1(1);
bit2 = MIB.PDCCH_ConfigSIB1(2);
bit3 = MIB.PDCCH_ConfigSIB1(3);
bit4 = MIB.PDCCH_ConfigSIB1(4);
bit5 = MIB.PDCCH_ConfigSIB1(5);
bit6 = MIB.PDCCH_ConfigSIB1(6);
bit7 = MIB.PDCCH_ConfigSIB1(7);
bit8 = MIB.PDCCH_ConfigSIB1(8);

H4bit = bit1*2^3+bit2*2^2+bit3*2^1+bit4*2^0+1;
L4bit = bit5*2^3+bit6*2^2+bit7*2^1+bit8*2^0+1;

Table1_1 = [1,24,2,0;
            1,24,2,2;
            1,24,2,4;
            1,24,3,0;
            1,24,3,2;
            1,24,3,4;
            1,48,1,12;
            1,48,1,16;
            1,48,2,12;
            1,48,2,16;
            1,48,3,12;
            1,48,3,16;
            1,96,1,38;
            1,96,2,38;
            1,96,3,38;
            0,0,0,0];


Table1_4 = [1,24,2,0;1,24,2,1;1,24,2,2;1,24,2,3;
            1,24,2,4;1,24,3,0;1,24,3,1;1,24,3,2;
            1,24,3,3;1,24,3,4;1,48,1,12;1,48,1,14;
            1,48,1,16;1,48,2,12;1,48,2,14;1,48,2,16];
Table1_6 = [1,24,2,0;1,24,2,4;1,24,3,0;1,24,3,4;1,48,1,0;
            1,48,1,28;1,48,2,0;1,48,2,28;1,48,3,0;1,48,3,28];% Table 13-6 Ts38.213

if(SCS==15)
    CoresetPara.Coreset_RB_Num = Table1_1(H4bit,2);
    CoresetPara.Coreset_Symb_Num = Table1_1(H4bit,3);
    CoresetPara.Coreset_RB_Offset2SSB = Table1_1(H4bit,4);
else
    CoresetPara.Coreset_RB_Num = Table1_4(H4bit,2);
    CoresetPara.Coreset_Symb_Num = Table1_4(H4bit,3);
    CoresetPara.Coreset_RB_Offset2SSB = Table1_4(H4bit,4);
end



N = CoresetPara.Coreset_Symb_Num;

Table_13_11_1 = [0,1,1,0; 0,2,1/2,0; 2,1,1,0; 2,2,1/2,0;
                 5,1,1,0; 5,2,1/2,0; 7,1,1,0; 7,2,1/2,0;
                 0,1,2,0; 5,1,2  ,0; 0,1,1,1; 0,1,1  ,2;
                 2,1,1,1; 2,1,1  ,2; 5,1,1,1; 5,1,1  ,2;];
Table_13_11_2 = [0,1,1,0; 0,2,1/2,N; 2,1,1,0; 2,2,1/2,N;
                 5,1,1,0; 5,2,1/2,N; 7,1,1,0; 7,2,1/2,N;
                 0,1,2,0; 5,1,2  ,0; 0,1,1,1; 0,1,1  ,2;
                 2,1,1,1; 2,1,1  ,2; 5,1,1,1; 5,1,1  ,2;];
if(mod(SSB_i,2)==0)
    CoresetPara.O = Table_13_11_1(L4bit,1);
    CoresetPara.M = Table_13_11_1(L4bit,3);
    CoresetPara.Coreset_FirstIndex = Table_13_11_1(L4bit,4);
else
    CoresetPara.O = Table_13_11_2(L4bit,1);
    CoresetPara.M = Table_13_11_2(L4bit,3);
    CoresetPara.Coreset_FirstIndex = Table_13_11_2(L4bit,4);
end
% CoresetPara.M = 1;

% % 
% % FirstSymbolIndex = 0;
n0 = mod((CoresetPara.O*2^1+floor((SSB_i)*CoresetPara.M)),20);
CoresetPara.SSB_Monitor_Slot  = n0;
% CoresetPara.Coreset_RB_Num = Table1(1,2);
% CoresetPara.RB_Start = 126*12 - CoresetPara.Coreset_RB_Offset2SSB*12;

% SSB_SubCarrierOffset = 