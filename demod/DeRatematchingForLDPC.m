
function  DeRatematchingoutdata = DeRatematchingForLDPC(DeScramblingoutdata,C,NL,Qm,G,N,K,K1,k0,Z_c,N_cb)

C1=C;%%与CBGTI有关系，有待补充，暂时先按照与发送端相同的代码
%-------------------------------%
j=1;
for r=1:C
    if j<=C1-mod(G/(NL*Qm),C1)
        E(r)=NL*Qm*floor(G/(NL*Qm*C1));
        f=DeScramblingoutdata(1:E(r));
        DeScramblingoutdata(1:E(r))=[];
    else
        E(r)=NL*Qm*ceil(G/(NL*Qm*C1));
        f=DeScramblingoutdata(1:E(r));
        DeScramblingoutdata(1:E(r))=[];
    end
    j=j+1;
end
%%%%de_interleaving%%%%%%%%%
% E = 5760;

Q=Qm;
for j=0:E(r)/Q-1
    for i=0:Q-1
        e(i*E(r)/Q+j+1)=f(i+j*Q+1);
    end
end
%----------解速率匹配(11.13修改)-------------%
%     NULL 位置  K1-2*Z_c+1~K-2*Z_c
for r = 1:C
    len1=N_cb-(K-K1);   %  Not included NULL %K1到K是空的  ，N是编码后长度
    if len1 > E(r) %数据没有放完的情况
        if k0(r) < K1-2*Z_c
            if E(r)<K1-2*Z_c-k0(r)
                d(1:k0(r))=0;
                d(k0(r)+1:k0(r)+E(r))=e;
                d(k0(r)+E(r):N_cb)=0;
            else
                if E(r)<(K1-2*Z_c-k0(r))+(N_cb+2*Z_c-K)
                    d(1:k0(r))=0;
                    d(k0(r)+1:K1-2*Z_c)=e(1:K1-2*Z_c-k0(r));
                    d(K1-2*Z_c+1:K-2*Z_c)=0;
                    d(K-2*Z_c+1:K-2*Z_c+E(r)-(K1-2*Z_c-k0(r)))=e(K1-2*Z_c-k0(r)+1:E(r));
                    d(K-2*Z_c+E(r)-(K1-2*Z_c-k0(r))+1:N_cb)=0;
                else
                    d(1:E(r)-(K1-2*Z_c-k0(r))-(N_cb+2*Z_c-K))=e((K1-2*Z_c-k0(r))+(N_cb+2*Z_c-K)+1:E(r));
                    d(E(r)-(K1-2*Z_c-k0(r))-(N_cb+2*Z_c-K)+1:k0(r))=0; %多余部分置零
                    d(k0(r)+1:K1-2*Z_c)=e(1:K1-2*Z_c-k0(r));
                    d(K1-2*Z_c+1:K-2*Z_c)=0;
                    d(K-2*Z_c+1:N_cb)=e(K1-2*Z_c-k0(r)+1:K1-2*Z_c-k0(r)+(N_cb+2*Z_c-K));
                end
            end
        else
            if k0(r) < K-2*Z_c
                if E(r)<N_cb+2*Z_c-K
                    d(1:K-2*Z_c)=0;
                    d(K-2*Z_c+1:K-2*Z_c+E(r))=e(1:E(r));
                    d(K-2*Z_c+E(r)+1:N_cb)=0;
                else
                    d(1:E(r)-(N_cb+2*Z_c-K))=e(N_cb+2*Z_c-K+1:E(r));
                    d(E(r)-(N_cb+2*Z_c-K)+1:K-2*Z_c)=0;
                    d(K-2*Z_c+1:N_cb)=e(1:N_cb+2*Z_c-K);
                end
            else
                if k0(r) < N_cb
                    if E(r)<N_cb-k0(r)
                        d(1:K-2*Z_c)=0;
                        d(K-2*Z_c+1:k0(r))=0;
                        d(k0(r)+1:k0(r)+E(r))=e;
                        d(k0(r)+E(r)+1:N_cb)=0;
                    else
                        if E(r)<=N_cb-k0(r)+(K1-2*Z_c)
                            d(1:E(r)-(N_cb-k0(r)))=e(N_cb-k0(r)+1:E(r));
                            d(E(r)-(N_cb-k0(r))+1:K1-2*Z_c)=0;
                            d(K1-2*Z_c+1:K-2*Z_c)=0;
                            d(K-2*Z_c+1:k0(r)) = 0;
                            d(k0(r)+1:N_cb)=e(1:N_cb-k0(r));
                        else
                            d(1:K1-2*Z_c)=e(N_cb-k0(r)+1:N_cb-k0(r)+(K1-2*Z_c));
                            d(K1-2*Z_c+1:K-2*Z_c)=0;
                            d(K-2*Z_c+1:E(r)-(N_cb-k0(r))-(K1-2*Z_c)+K-2*Z_c)=e(E(r)-(N_cb-k0(r))+(K1-2*Z_c)+1:E(r));
                            d(E(r)-(N_cb-k0(r))-(K1-2*Z_c)+K-2*Z_c+1:k0(r))=0;
                            d(k0(r)+1:N_cb)=e(1:N_cb-k0(r));
                        end
                    end
                end
            end
        end
    else  %len1<E(r) 需要数据循环填充
        if k0(r) < K1-2*Z_c
            d(1:k0(r))=e(len1-k0(r)+1:len1);
            d(k0(r)+1:K1-2*Z_c)= e(1:K1-2*Z_c-k0(r));
            d(K1-2*Z_c+1:K-2*Z_c)=0;
            d(K-2*Z_c+1:N_cb)=e(K1-2*Z_c-k0(r)+1:K1-2*Z_c-k0(r)+(N_cb+2*Z_c-K));
        else
            if k0(r)< K-2*Z_c
                d(1:K1-2*Z_c)=e(N_cb+2*Z_c-K+1:len1);
                d(K1-2*Z_c+1:K-2*Z_c)=0;
                d(K-2*Z_c+1:N_cb)=e(1:N_cb+2*Z_c-K);
            else
                if k0(r) < N_cb
                    d(1:K1-2*Z_c)=e(N_cb-k0(r)+1:N_cb-k0(r)+(K1-2*Z_c));
                    d(K1-2*Z_c+1:K-2*Z_c)=0;
                    d(K-2*Z_c+1:k0(r))=e(N_cb-k0(r)+(K1-2*Z_c)+1:len1);
                    d(k0(r)+1:N_cb)=e(1:N_cb-k0(r));
                end
            end
        end
    end
    len_flag=N-N_cb;
    d=[d zeros(1,len_flag)];
    DeRatematchingoutdata(r,:)=d;
end


end


% % % % % %
% % % % % % function  DeRatematchingoutdata = DeRatematching(DeScramblingoutdata,C,CBGTI,NL,Qm,G,N,K,K1,k0,Z_c)
% % % % % %
% % % % % % if isempty(CBGTI)
% % % % % %     C1=C;
% % % % % % else
% % % % % %     C1=length(find(CBGTI));
% % % % % % end
% % % % % % j=1;
% % % % % % for r=1:C
% % % % % %     if CBGTI(r)==0
% % % % % %         E(r)=0;
% % % % % %         f=DeScramblingoutdata(1:E(r));
% % % % % %         DeScramblingoutdata(1:E(r))=[];
% % % % % %     else
% % % % % %         if j<=C1-mod(G/(NL*Qm),C1)
% % % % % %             E(r)=NL*Qm*floor(G/(NL*Qm*C1));
% % % % % %             f=DeScramblingoutdata(1:E(r));
% % % % % %             DeScramblingoutdata(1:E(r))=[];
% % % % % %         else
% % % % % %             E(r)=NL*Qm*ceil(G/(NL*Qm*C1));
% % % % % %             f=DeScramblingoutdata(1:E(r));
% % % % % %             DeScramblingoutdata(1:E(r))=[];
% % % % % %         end
% % % % % %         j=j+1;
% % % % % %     end
% % % % % %     %%%%de_interleaving%%%%%%%%%
% % % % % %     Q=Qm;
% % % % % %     for j=0:E(r)/Q-1
% % % % % %         for i=0:Q-1
% % % % % %             e(i*E(r)/Q+j+1)=f(i+j*Q+1);
% % % % % %         end
% % % % % %     end
% % % % % %     %%%%%%%%%%%%%%%%%%%%%%
% % % % % % %     NULL 位置  K1-2*Z_c+1~K-2*Z_c
% % % % % %     len1=N-(K-K1);   %Not included NULL
% % % % % %
% % % % % %     if len1 <= E(r)
% % % % % %         d0=e(1:len1);
% % % % % %     else
% % % % % %         d0=e(1:E(r));
% % % % % %         d0(E(r)+1:len1)=zeros(1,len1-E(r));
% % % % % %     end
% % % % % %
% % % % % % %     if k0(r)>K1-2*Z_c&&k0(r)<K-2*Z_c
% % % % % % %         len2=k0(r)-(K1-2*Z_c+1);
% % % % % % %     else if k0(r)>=K-2*Z_c
% % % % % % %             len2=K-K1;
% % % % % % %         else
% % % % % % %             len2=k0(r)+1;
% % % % % % %         end
% % % % % % %     end
% % % % % %     if k0(r)>K1-2*Z_c&&k0(r)<K-2*Z_c
% % % % % %         len2=k0(r)-(K1-2*Z_c+1);
% % % % % %     else
% % % % % %         if k0(r)>=K-2*Z_c
% % % % % %             len2 = k0(r)-(K-K1);
% % % % % %             %len2=K-K1;
% % % % % %         else
% % % % % %             len2=k0(r);
% % % % % %         end
% % % % % %     end
% % % % % %
% % % % % %     if k0(r)==0
% % % % % %         d1=d0;
% % % % % %     else
% % % % % %        d1(1:len2)=d0(len1-len2+1:len1);        %起始位置为k0
% % % % % %        d1(len2+1:len1)=d0(1:len1-len2);
% % % % % %     end
% % % % % %
% % % % % %     d2(1:K1-2*Z_c)=d1(1:K1-2*Z_c);
% % % % % %     d2(K1-2*Z_c+1:K-2*Z_c)=zeros(1,K-K1);   %filling "NULL"
% % % % % %     d2(K-2*Z_c+1:len1+(K-K1))=d1(K1-2*Z_c+1:len1);
% % % % % %     DeRatematchingoutdata(r,:)=d2;
% % % % % % end
% % % % % %
% % % % % %