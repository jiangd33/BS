function para = parameterSetting(f0)

if(f0==3.50976e9)
    para.BandWidth = 100;                                            %2.565G: BandWidth = 100, 2.14455G: BandWidth = 50
    para.SCS = 30;%15K
    
    para.SSB_RB_Offset = 126;                                        %2.565G: SSB_RB_Offset = 15, 2.14455G: SSB_RB_Offset = 125 ,3.50976G: SSB_RB_Offset = 126
    para.SSB_SC_Offset = 6;                                          %2.565G: SSB_SC_Offset = 3 , 2.14455G: SSB_SC_Offset = 0 ,  3.50976G: SSB_SC_Offset = 6
elseif(f0==3.40896e9)
    para.BandWidth = 100;                                            %2.565G: BandWidth = 100, 2.14455G: BandWidth = 50
    para.SCS = 30;%15K
    
    para.SSB_RB_Offset = 126;                                        %2.565G: SSB_RB_Offset = 15, 2.14455G: SSB_RB_Offset = 125 ,3.50976G: SSB_RB_Offset = 126
    para.SSB_SC_Offset = 6;   
elseif(f0==2.52495e9)
    para.BandWidth = 100;                                            %2.565G: BandWidth = 100, 2.14455G: BandWidth = 50
    para.SCS = 30;%15K
    
    para.SSB_RB_Offset = 126;                                        %2.565G: SSB_RB_Offset = 15, 2.14455G: SSB_RB_Offset = 125 ,3.50976G: SSB_RB_Offset = 126
    para.SSB_SC_Offset = 6;                                          %2.565G: SSB_SC_Offset = 3 , 2.14455G: SSB_SC_Offset = 0 ,  3.50976G: SSB_SC_Offset = 6
elseif(f0==2.14455e9)
    para.BandWidth = 50;                                            %2.565G: BandWidth = 100, 2.14455G: BandWidth = 50
    para.SCS = 15;%15K
    
    para.SSB_RB_Offset = 125;                                        %2.565G: SSB_RB_Offset = 15, 2.14455G: SSB_RB_Offset = 125 ,3.50976G: SSB_RB_Offset = 126
    para.SSB_SC_Offset = 0;
elseif(f0==773e6)
    para.BandWidth = 50;                                            %2.565G: BandWidth = 100, 2.14455G: BandWidth = 50
    para.SCS = 15;%15K
    
    para.SSB_RB_Offset = 70;                                        %2.565G: SSB_RB_Offset = 15, 2.14455G: SSB_RB_Offset = 125 ,3.50976G: SSB_RB_Offset = 126
    para.SSB_SC_Offset = 10;
end

% f0 = 2.565e9;
% f0 = 2.14455e9;
% f0 = 3.50976e9;
