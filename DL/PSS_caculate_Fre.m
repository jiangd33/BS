function PSS_Fre=PSS_caculate_Fre()


N_2_ID=[0 1 2];
for j=0:2
    %******����Ƶ��PSS*******
    x=zeros(1,127);%0<=n<127���������±�+1
    x(1:7)=fliplr([1 1 1 0 1 1 0]);
    d_pss = zeros(1,127);
    for i=1:127-7
        x(i+7)=mod(x(i+4)+x(i),2);
    end
    for n=0:126%��ΪҪ����m
        m=mod((n+43*N_2_ID(j+1)),127);
        d_pss(n+1)=1-2*x(m+1);
    end
    PSS_Fre(j+1,:)=d_pss;
end
