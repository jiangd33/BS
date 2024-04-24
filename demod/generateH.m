%Generate check matrix H

function [H]=generateH(Z_c,H_BG,V,LDPC_base_graph)
zero_matrix=zeros(Z_c,Z_c);
I=eye(Z_c);
% Column=length(H_BG);
if LDPC_base_graph==1
    H1=cell(46,68);
    for i=1:46
        for j=1:68
            if H_BG(i,j)==0
                H1{i,j}=zero_matrix;
            else
                p=mod(V(i,j),Z_c);
                shift_matrix=circshift(I,-p);   %Right circular shift
                H1{i,j}=shift_matrix;
            end
        end
    end
    H=cell2mat(H1);
else
    H2=cell(42,52);
    for i=1:42
        for j=1:52
            if H_BG(i,j)==0
                H2{i,j}=zero_matrix;
            else
                p(i,j)=mod(V(i,j),Z_c);
                shift_matrix=circshift(I,-p(i,j));   %Right circular shift
                H2{i,j}=shift_matrix;
            end
        end
    end
    H=cell2mat(H2);
end
