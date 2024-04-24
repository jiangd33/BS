function [Rx_PSS,Rx_SSS,Rx_PBCH] = Rx_PBCH_seq(input,N_cell_ID)
% global SSB_k0;
% global N_cell_ID;
SSB_k0 = 0;
% N_cell_ID = Cell_ID;
v1 = mod(N_cell_ID,4);
Rx_PSS = input(SSB_k0+57:SSB_k0+183,1).';
Rx_SSS = input(SSB_k0+57:SSB_k0+183,3).';
k1=1;
for i2=2:4
    if i2==3
        for i3=0:47
            if mod(i3-v1,4)==0
                continue
            else
                Rx_PBCH(k1) = input(i3+1,i2);
                k1=k1+1;
            end
        end
        for i3=192:239
            if mod(i3-v1,4)==0
                continue
            else
                Rx_PBCH(k1) = input(i3+1,i2);
                k1=k1+1;
            end
        end
    else
        for i3=0:239
            if mod(i3-v1,4)==0
                continue
            else
                Rx_PBCH(k1) = input(i3+1,i2);
                k1=k1+1;
            end  
        end
    end
end


