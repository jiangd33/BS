function DeCRC_Flag= Check_CRC_PBCH(decoder_output,DeCRC_Type)
 
% NPBCH_CRC_mask=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
%                 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
switch(DeCRC_Type)
    case 1
        CrcPoly =[1 1 0 0 0 0 1];  %% CRC length L=6
    case 2
        CrcPoly =[1 1 1 0 0 0 1 0 0 0 0 1]; % CRC length L=11
    case 3
        CrcPoly =[1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1];  % CRC length L=16
    case 4
        CrcPoly =[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];  %此校验多项式为CRC24A
    case 5
        CrcPoly =[1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1];  %此校验多项式为CRC24B  
    case 6 
        CrcPoly =[1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];  %此校验多项式为CRC24C 
    otherwise
        disp('Please Check Your Number');
end


 
%用译码的输出比特的最后16比特和NPBCH_CRC_mask的值异或操作
 lengthdecoder=size(decoder_output,2);       %输入比特流的长度
 lengthgen=size(CrcPoly,2); 
% 
% i=1;
% while(i<=(lengthdecoder-lengthgen+1))                    %做到输入比特长度
%     for m=1:lengthgen                 %m=1:lengthgen    异或一次
%         if decoder_output(1,i)==CrcPoly(1,m)
%             decoder_output(1,i)=0;
%         else decoder_output(1,i)=1;
%         end                            
%         i=i+1;m=m+1;
%     end
%     i=i-1;
%     for j=i-(lengthgen-1):i            %重新定位异或对应初始位置
%         if decoder_output(1,j)==0
%             j=j+1;
%         else break;
%         end
%     end
%     i=j;
% end
% 
% %取最后lengthgen-1位为CRC
% CRCout=zeros(1,lengthgen-1);   
% 
% for i=1:lengthgen-1
%     CRCout(1,i)=decoder_output(1,(lengthdecoder-lengthgen+1)+i);     
% end

for i= 1:(lengthdecoder-lengthgen+1)
    if decoder_output(i)==1
        for j=(1:length(CrcPoly))
            decoder_output(i+j-1)=xor(decoder_output(i+j-1),CrcPoly(j));
        end
    end
end

if(decoder_output==0)
   DeCRC_Flag = 1;
   return;
else
   DeCRC_Flag = 0;
end

%=====================================END=====================================