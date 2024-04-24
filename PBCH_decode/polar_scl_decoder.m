function u1_N = polar_scl_decoder(L,y,Z,delta)
%�ú����Ĺ�������ɽ������еļ�������
%���룺L����·��������ȣ�y����������������������ΪN��Z����λ�þ���ָʾ��Ϣ���غ͹̶����ص�λ�ã�delta�����ŵ���˹�����ı�׼��
%�����u1_N��������õ�����Ϣ���غ͹̶����صĻ������
N = length(y);
Flag = log2(L);          %Flag����ָʾL��·����ѡȡ�������л�
u_matrix = zeros(L,N+1);  %�þ�����һ����L*(N+1)���Ķ�ά����u_matrix��ÿһ�е�ǰN�д��һ������·����Ӧ�����֣���u_matrix(:,N+1)���Ӧ�ź�ѡ·���Ķ���ֵ

matrix_init = 2.*y./delta^2;
reserve_all = path_matrix(L);
flag = 0;                            %%��ʾ��ǰ��û��������һ����Ϣλ
% free_position = find(Z==1);        %%����������������Ϣλ��λ������
% free_length = length(free_position);%%��Ϣλ�ĳ���

PM_temp = zeros(2*L,2);             %���2Lo�����ִ����ж�λ�ã�����ѡ��Lo�����ִ�����ʱ����
PM_temp(1:2:2*L,1) = ones(L,1);     %�ѵ�һ�������е�ֵ��Ϊ1

LLR_matrix = zeros(1,2*N-1);
LLR_matrix(1,1:N) = 2.*y./delta^2;
step_all = 0;
for j = 0:log2(N)-1
    step = N/2^j;
    LLR_temp = LLR_matrix(1,step_all+1:step_all+step);
    step_all = step_all + step;
    for jj = 1:N/2^(j+1)
        LLR_matrix(step_all+jj) = sign( LLR_temp(2*jj-1).*LLR_temp(2*jj) ).*min( abs(LLR_temp(2*jj-1)),abs(LLR_temp(2*jj)) );
    end
end

for i = 1:N
    if Z(i)==0
        if i==1
            uu = [];
            u_matrix(:,i) = zeros(L,1);
            u = 0;
            LLR_matrix = matrix_init;
            LLR = likelihood_rate(N,i,uu,LLR_matrix); %hhhhhh
            PM_former = 0;
            for j = 1:L
                u_matrix(j,N+1) = path_metric( i,u,PM_former,LLR,Z );
            end
        else
            u_matrix(:,i) = zeros(L,1);
            u = 0;
            for j = 1:L
                uu = u_matrix(j,1:i-1);
                LLR_matrix = matrix_init;
                LLR = likelihood_rate(N,i,uu,LLR_matrix);
                PM_former = u_matrix(j,N+1);
                u_matrix(j,N+1) = path_metric( i,u,PM_former,LLR,Z );
            end
        end
    else
        flag = flag+1;
        if flag<=Flag                   %%��ʱҪ��������·�� �������
             u_matrix(:,i) = reserve_all(:,flag);
             for j = 1:L
                 uu = u_matrix(j,1:i-1);
                 u = u_matrix(j,i);
                 LLR_matrix = matrix_init;
                 LLR = likelihood_rate(N,i,uu,LLR_matrix);
                 PM_former = u_matrix(j,N+1);
                 u_matrix(j,N+1) = path_metric( i,u,PM_former,LLR,Z );
             end
        else
            for j = 1:L
                uu = u_matrix(j,1:i-1);
                LLR_matrix = matrix_init;
                LLR = likelihood_rate(N,i,uu,LLR_matrix);
                PM_former = u_matrix(j,N+1);
                PM_temp(2*j-1,2) = path_metric(i,1,PM_former,LLR,Z);   %PM_temp���������д��ж�����Ϊ1��·������ֵ
                PM_temp(2*j,2) = path_metric(i,0,PM_former,LLR,Z);     %PM_temp����ż���д��ж�����Ϊ0��·������ֵ
                [vals,inds]    = sort(PM_temp(:,2),'descend');
                temp=[];
                for k=1:L                                                                                           %%%���ѭ�����ڴ�2Lo������ֵ��ѡȡ����
                    if  mod(inds(k),2)==1                                                                            %%��������ֵ��ʾ���һλ��1��tempcode���һλ�Ǹ�·���ĸ���
                        tempcode=[u_matrix((inds(k)+1)/2,1:i-1),1,vals(k)];
                        temp=[temp;tempcode];
                    else                                                                                             %%ż��������ʾ���һλ��0 ��tempcode���һλ�Ǹ�·���ĸ���
                        tempcode=[u_matrix(inds(k)/2,1:i-1),0,vals(k)];
                        temp=[temp;tempcode];
                    end   
                end                       %%end of k_cycle
            end                           %%end of j_cycle
            u_matrix(:,1:i)=temp(:,1:i);
            u_matrix(:,N+1)=temp(:,i+1);
        end   
    end
end
[~,index] = sort(u_matrix(:,N+1),'descend');
u_matrix(1,1:N) = u_matrix(index(1),1:N);
u1_N = u_matrix(1,1:N);
end
