function LLR = likelihood_rate(N,i,uu,LLR_matrix)
%�ú����Ĺ����Ǽ��������Ȼ��
%���룺N�����ڵ�ǰ�ݹ�����е��ŵ�������i��������N�������ŵ��еĵ�i�����ŵ�(i<=N)��
%      uu����ǰi-1����֪�Ĺ��ƣ��ǳ���Ϊi-1��������LLR_matrix����������Ȼ�Ⱦ���N�������ŵ��еĵ�1�����ŵ��Ķ�����Ȼ��
%�����LLR����������Ȼ�Ⱦ���



if N ==1
%         if i == 1                %i=1
%             LLR = LLR_matrix(2*N-1);
%         elseif i ==2             %i=2
%             LLR = (-1)^uu(i-1)*LLR_matrix(2*N-3)+LLR_matrix(2*N-2);
    LLR=LLR_matrix(1);
else
    if mod(i,2)==1    %iΪ����
        uoe = mod(uu(1:2:i-1)+uu(2:2:i-1),2); %������������ż�������
        ue = uu(2:2:i-1);%����ż����
        L1 = likelihood_rate(N/2,(i+1)/2,uoe,LLR_matrix(1,1:N/2));
        L2 = likelihood_rate(N/2,(i+1)/2,ue,LLR_matrix(1,N/2+1:N));
        LLR = sign(L1.*L2).*min(abs(L1),abs(L2));
    else    %iΪż��
        uoe = mod(uu(1:2:i-2)+uu(2:2:i-2),2); %������������ż�������
        ue = uu(2:2:i-2);%����ż����
        L1 = likelihood_rate(N/2,i/2,uoe,LLR_matrix(1,1:N/2));
        L2 = likelihood_rate(N/2,i/2,ue,LLR_matrix(1,N/2+1:N));
        LLR = (-1)^uu(i-1).*L1+L2;
    end
    
end
end

