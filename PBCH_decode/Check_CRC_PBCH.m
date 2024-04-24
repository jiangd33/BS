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
        CrcPoly =[1 1 0 0 0 0 1 1 0 0 1 0 0 1 1 0 0 1 1 1 1 1 0 1 1];  %��У�����ʽΪCRC24A
    case 5
        CrcPoly =[1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 1];  %��У�����ʽΪCRC24B  
    case 6 
        CrcPoly =[1 1 0 1 1 0 0 1 0 1 0 1 1 0 0 0 1 0 0 0 1 0 1 1 1];  %��У�����ʽΪCRC24C 
    otherwise
        disp('Please Check Your Number');
end


 
%�������������ص����16���غ�NPBCH_CRC_mask��ֵ������
 lengthdecoder=size(decoder_output,2);       %����������ĳ���
 lengthgen=size(CrcPoly,2); 
% 
% i=1;
% while(i<=(lengthdecoder-lengthgen+1))                    %����������س���
%     for m=1:lengthgen                 %m=1:lengthgen    ���һ��
%         if decoder_output(1,i)==CrcPoly(1,m)
%             decoder_output(1,i)=0;
%         else decoder_output(1,i)=1;
%         end                            
%         i=i+1;m=m+1;
%     end
%     i=i-1;
%     for j=i-(lengthgen-1):i            %���¶�λ����Ӧ��ʼλ��
%         if decoder_output(1,j)==0
%             j=j+1;
%         else break;
%         end
%     end
%     i=j;
% end
% 
% %ȡ���lengthgen-1λΪCRC
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