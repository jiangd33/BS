function u1_N = polar_scl_decoder(L,y,Z,delta)
%该函数的功能是完成接收序列的极化译码
%输入：L——路径搜索宽度；y——接收序列向量，长度为N；Z——位置矩阵，指示信息比特和固定比特的位置；delta——信道高斯噪声的标准差
%输出：u1_N——译码得到的信息比特和固定比特的混合序列
N = length(y);
Flag = log2(L);          %Flag用于指示L条路径的选取方法的切换
u_matrix = zeros(L,N+1);  %该矩阵是一个（L*(N+1)）的二维矩阵，u_matrix的每一行的前N列存放一串保留路径对应的码字，而u_matrix(:,N+1)则对应着候选路径的度量值

matrix_init = 2.*y./delta^2;
reserve_all = path_matrix(L);
flag = 0;                            %%表示当前还没有遇到第一个信息位
% free_position = find(Z==1);        %%这个矩阵用来存放信息位的位置索引
% free_length = length(free_position);%%信息位的长度

PM_temp = zeros(2*L,2);             %存放2Lo个码字串的判断位置，用于选出Lo个码字串的临时矩阵
PM_temp(1:2:2*L,1) = ones(L,1);     %把第一列奇数行的值设为1

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
        if flag<=Flag                   %%此时要保留所有路径 并算概率
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
                PM_temp(2*j-1,2) = path_metric(i,1,PM_former,LLR,Z);   %PM_temp矩阵奇数行存判定比特为1的路径测量值
                PM_temp(2*j,2) = path_metric(i,0,PM_former,LLR,Z);     %PM_temp矩阵偶数行存判定比特为0的路径测量值
                [vals,inds]    = sort(PM_temp(:,2),'descend');
                temp=[];
                for k=1:L                                                                                           %%%这个循坏用于从2Lo个概率值中选取最优
                    if  mod(inds(k),2)==1                                                                            %%奇数索引值表示最后一位是1，tempcode最后一位是该路径的概率
                        tempcode=[u_matrix((inds(k)+1)/2,1:i-1),1,vals(k)];
                        temp=[temp;tempcode];
                    else                                                                                             %%偶数索引表示最后一位是0 ，tempcode最后一位是该路径的概率
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
