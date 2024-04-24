%**************************************************************************
%Copyright (C), 2018, CQUPT
%FileName:     TxPBCH_main
%Description:  Rate_matching 
%Reference:    [7,38212] clause 5.4
%Author:       DSP_GROUP
%Input:        TxPDCCH_channel_code_out
%              
%Output:       Rate_matching_out
%History:
%      <time>      <version >
%      2018/8/20      1.0
%**************************************************************************
function Rate_matching_out = Rate_matching(TxPDCCH_channel_code_out,E,I_BIL,K)
d = TxPDCCH_channel_code_out;
Jn = get_Jn(length(d)); %Sub-block interleaving
y=d(Jn+1);
%-----------速率匹配：比特选择------------------
% E=864;
N=length(y);
e=ones(1,E)*100;
if E>=N
    for k=0:E-1
        e(k+1)=y(mod(k,N)+1);
    end
elseif K/E<=7/16
    for k=0:E-1
        e(k+1)=y(k+N-E+1);
    end
else
    for k=0:E-1
        e(k+1)=y(k+1);
    end
end
%-----------速率匹配：比特交织------------------5.4.1.3
% I_BIL=0;
f=ones(1,E)*100;
T=42;%[T*(T+1)]/2>=E的最小整数为T；
if I_BIL==1
   k=0;
   for i=0:T-1
       for j=0:T-1-i
           if k<E
               v(i+1,j+1)=e(k+1);
           else
               v(i+1,j+1)=200;%200代表NULL
           end
           k=k+1;
       end
   end
   k1=0;
   for j=0:T-1
       for i=0:T-1-j
           if v(i+1,j+1)~=200
               f(k+1)=v(i+1,j+1);
               k=k+1;
           end
       end
   end         
else
    for i=0:E-1
        f(i+1)=e(i+1);
    end
end
Rate_matching_out=f;
        
        

