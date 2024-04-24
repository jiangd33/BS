
function [DeCRC_Flag,DeCRCcheckoutdata]= DeCRC(Decodeoutdata,DeCRC_Type,C)

if C>1
    decrcoutdata=[];
    for r=1:C
%        DeCRC_CB(r,:)=Check_CRC(Decodeoutdata(r,:),5);
       [DeCRC_Flag(r,:),TB(r,:)] = Check_CRC(Decodeoutdata(r,:),5);%CRC24B(D)
       decrcoutdata = [decrcoutdata TB(r,:)];
    end
else
    [DeCRC_Flag,decrcoutdata] = Check_CRC(Decodeoutdata,DeCRC_Type);
end

  DeCRCcheckoutdata  = decrcoutdata;

% if C>1
%     TB=[];
%     for r=1:C
%        DeCRC_CB(r,:)=Check_CRC(Decodeoutdata(r,:),5);
%        TB=[TB DeCRC_CB(r,:)];
%     end
% else
%     [DeCRC_Flag,decrcoutdata]=Check_CRC(Decodeoutdata,DeCRC_Type);
% end
% 
%   DeCRCcheckoutdata  = decrcoutdata;
    