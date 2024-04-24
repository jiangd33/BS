function de_crc_out= Get_check_crc_out(decoder_output,DeCRC_Type)
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
    otherwise disp('Please Check Your Number'); 
end
for i=1:length(decoder_output)-length(CrcPoly)+1
    de_crc_out(i)=decoder_output(i);
end
end
    