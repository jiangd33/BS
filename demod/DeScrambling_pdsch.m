%

function DeScramblingoutdata = DeScrambling_pdsch(DeModulationoutdata,c_init,Qm)

M_PN = length(DeModulationoutdata);
c = pseudo(M_PN,c_init);
% seq2 = 1-2.*seq2;   
if(Qm==2)
    for i=1:M_PN
        if c(i)==1
            b(i)=1;
        else
            b(i)=-1;
        end
    end
    DeScramblingoutdata = b.*DeModulationoutdata;
else
    for i=1:M_PN
        if c(i) == 0
            DeScramblingoutdata(i) = DeModulationoutdata(i);
        else
            DeScramblingoutdata(i) = 1-DeModulationoutdata(i);
        end
    end
end



% for i=1:M_PN
%     if(DeScramblingoutdata(i)<0)
%         DeScramblingoutdata(i) = 1;
%     else
%         DeScramblingoutdata(i) = 0;
%     end
% end
