%determine TBS for PDSCH

function TBS=TBS_table(N_info,R)
TBStable=[24,32,40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,208,224,240,256,272,288,304,320,336,352,368,384,408,432,456,480,504,528,552,576,608,640,672,704,736,768,808,848,888,928,984,1032,1064,1128,1160,1192,1224,1256,1288,1320,1352,1416,1480,1544,1608,1672,1736,1800,1864,1928,2024,2088,2152,2216,2280,2408,2472,2536,2600,2664,2728,2792,2856,2976,3104,3240,3368,3496,3624,3752,3824];

if N_info<=3824
    n=max(3,(floor(log2(N_info))-6));
    N_info1=max(24,(2^n)*floor(N_info/(2^n)));
    temp=TBStable-N_info1;
    [~,k]=find(temp==min(temp(find(temp>=0))));
    TBS=TBStable(k);
else 
    n=floor(log2(N_info-24))-5;
%     N_info1=(2^n)*round((N_info-24)/(2^n));
    N_info1 = max(3840,(2^n)*round((N_info-24)/(2^n)));
    if R<=1/4
        C=ceil((N_info1+24)/3816);
        TBS=8*C*ceil((N_info1+24)/(8*C))-24;
    else
        if N_info1>8424
           C=ceil((N_info1+24)/8424); 
           TBS=8*C*ceil((N_info1+24)/(8*C))-24;
        else
            TBS=8*ceil((N_info1+24)/8)-24;
        end
    end
end

