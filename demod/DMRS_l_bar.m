%**************************************************************************
%Copyright (C), 2018, CQUPT
%FileName:     DMRS_l_bar
%Description:  Conpute l_bar
%Reference:    [7,38211] Table 7.4.1.1.2-3
%Author:       DSP_GROUP
%Input:        doublesymbolenable pdsch_symbolAllocationDMRS
%              
%Output:       l_bar
%History:
%      <time>      <version >
%      2018/8/20      1.0
%**************************************************************************
function l_bar = DMRS_l_bar(doublesymbolenable,pdsch_symbolAllocationDMRS,S,L,DL_DMRS_add_pos,l0,l1)
if doublesymbolenable==0
    if  pdsch_symbolAllocationDMRS==0  %A
        if (S+L)<=7
            l_bar=l0;
        else if ((S+L)==8||(S+L)==9)
                if DL_DMRS_add_pos==0
                    l_bar=l0;
                else 
                    l_bar=[l0 7];
                end
            else if ((S+L)==10||(S+L)==11)
                    if DL_DMRS_add_pos==0
                        l_bar=l0;
                    else if DL_DMRS_add_pos==1
                            l_bar=[l0 9];
                        else if (DL_DMRS_add_pos==2||DL_DMRS_add_pos==3)
                                l_bar=[l0 6 9];
                            end
                        end
                    end
                else if (S+L)==12
                        if DL_DMRS_add_pos==0
                            l_bar=l0;
                        else if DL_DMRS_add_pos==1
                                l_bar=[l0 9];
                            else if DL_DMRS_add_pos==2
                                    l_bar=[l0 6 9];
                                else if DL_DMRS_add_pos==3
                                        l_bar=[l0 5 8 11];
                                    end
                                end
                            end
                        end
                    else if ((S+L)==13||(S+L)==14)
                            if DL_DMRS_add_pos==0
                                l_bar=l0;
                            else if DL_DMRS_add_pos==1
                                    l_bar=[l0 l1];
                                else if DL_DMRS_add_pos==2
                                        l_bar=[l0 7 11];
                                    else if DL_DMRS_add_pos==3
                                            l_bar=[l0 5 8 11];
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    else if pdsch_symbolAllocationDMRS==1   %B
            if L<=6
                l_bar=l0;
            else
                if L==7
                    if DL_DMRS_add_pos==0
                        l_bar=l0;
                    else if DL_DMRS_add_pos==1
                            l_bar=[l0 4];
                        end
                    end
                else
                    if L==8
                        l_bar=l0;
                    else
                        if L==9
                            l_bar=l0;
                        else
                            if L>=10
                                l_bar=l0;
                            end
                        end
                    end
                end
            end
        end
    end
else
    if doublesymbolenable==1  % double symbol
        if  pdsch_symbolAllocationDMRS==0  %A
            if L<=8
                l_bar=l0;
            else
                if L==9
                    l_bar=l0;
                else
                    if L==10
                        if DL_DMRS_add_pos==0
                            l_bar=l0;
                        else if DL_DMRS_add_pos==1
                                l_bar=[l0 8];
                            end
                        end
                    else
                        if L==11
                            if DL_DMRS_add_pos==0
                                l_bar=l0;
                            else if DL_DMRS_add_pos==1
                                    l_bar=[l0 8];
                                end
                            end
                        else
                            if L==12
                                if DL_DMRS_add_pos==0
                                    l_bar=l0;
                                else if DL_DMRS_add_pos==1
                                        l_bar=[l0 8];
                                    end
                                end
                            else
                                if L==13||L==14
                                    if DL_DMRS_add_pos==0
                                        l_bar=l0;
                                    else if DL_DMRS_add_pos==1
                                            l_bar=[l0 10];
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else if pdsch_symbolAllocationDMRS==1   %B
                l_bar=l0;
            end
        end
    end
end