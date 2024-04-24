%R15 Normalized BP-Based decode for LDPC
%Copyright (C), 2018
%FileName:     Normalized_BP_Based
%Description:  Sub-file program for LDPC decode
%                    Need to further reduce the computing time
%Author:        Liuyifan
%Input:         DeRatematchingoutdata, check matrix H
%Output:        Decodeoutdata
%History:
%      <time>      <version >
%      2018/2/3      1.0
%**************************************************************************

function Decodeoutdata = Normalized_BP_Based(DeRatematchingoutdata,H,K,N,Z_c,EbNo,C)

de_code = zeros(1,length(DeRatematchingoutdata(1,:))+ 2*Z_c);
Decodeoutdata = zeros(C,K);
for r=1:C
    re_code = [zeros(1,2*Z_c) DeRatematchingoutdata(r,:)];
    rate=K/N;
    sigma=1/sqrt(2*rate*EbNo);
    [rows,cols] = size(H);
    max_iter = 10;
    %     L_inihtial=2.*re_code./(sigma^2);
    L_initial = 2.*re_code./(sigma^2);
    v2c = zeros(rows,cols);
    v2c = sparse(v2c);
    alfa=zeros(rows,cols);
    beta=zeros(rows,cols);
    alfa=sparse(alfa);
    beta=sparse(beta);
    c2v=zeros(rows,cols);
    c2v=sparse(c2v);
    L=zeros(1,cols);
    [i,j]=find(H==1);
    for t=1:cols
        tt=find(j==t);
        v2c(i(tt),t)=L_initial(t);
    end
    %%%%%%%%%%%%%迭代开始%%%%%%%%%%%
    for inter_iter=1:max_iter
        t=find(L_initial>0|L_initial==0);
        de_code(t)=0;
        tt=find(L_initial<0);
        de_code(tt)=1;
        if mod(H*de_code.',2)==0
            disp('1')
            break
        end
        alfa=sign(v2c);
        beta=abs(v2c);
        %%%%%%%%%%%%%%(校验节点更新)%%%%%%%%%%%%%%
        for j=1:rows
            t=find(H(j,:)==1);
            vnum=length(t);
            vnindex=1:vnum;
            for i=1: vnum
                vntemp=vnindex;
                vntemp(i) = [];
                part=prod(alfa(j,t(vntemp)));   %求符号
                part_a=min(beta(j,t(vntemp)));  %大小
                c2v(j,t(i))=0.55*part*part_a;   %c->v的值
            end
        end
        %%%%%%%%%%%%%(信息节点更新)%%%%%%%%%%%
        for i=1:cols
            t=find(H(:,i)==1);
            cnum=length(t);
            cnindex=1:cnum;
            for j=1:cnum
                cntemp=cnindex;
                cntemp(j)=[];
                part0=sum(c2v(t(cntemp),i));   %m'n求和
                v2c(t(j),i)=L_initial(i)+part0;
            end
            part_1=sum(c2v(t(cnindex),i));
            L(i)=L_initial(i)+part_1;        %L是P值   2014论文中的min-sum 硬判决值
        end
        
        t = find(L>0|L==0);
        de_code(t)=0;
        tt = find(L<0);
        de_code(tt)=1;
        if mod(H*de_code.',2)==0
            break
        end
        inter_iter
    end
    Decodeoutdata(r,:) = de_code(1:K);
end