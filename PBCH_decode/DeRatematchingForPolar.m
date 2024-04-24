function RxRatematchOut = DeRatematchingForPolar(input,K)
I_BIL=0;
n_max=9;
E=length(input);
f=input;
if E<(9/8)*2^(ceil(log2(E))-1) && K/E<9/16
    n1=ceil(log2(E))-1;
else
    n1=ceil(log2(E));
end
Rmin=1/8;
n2=ceil(log2(K/Rmin));
temp=[n1,n2,n_max];
n_min=5;
n=max(min(temp),n_min);
N=2^n;%d1,d2,...,dN-1;
% e=ones(1,E)*100;
%-----------解速率匹配--------------------------------------
%-----------比特交织------------------
T=42;%[T*(T+1)]/2>=E的最小整数为T；
if I_BIL==1
   k=0;
   for i=0:T-1
       for j=0:T-1-i
           if k<E
               v(i+1,j+1)=f(k+1);
           else
               v(i+1,j+1)=200;%200代表NULL
           end
           k=k+1;
       end
   end
   k1=0;
   for j=0:T-1
       for i=0:T-1-j
           if v(i+1,j+1)~=200
               e(k+1)=v(i+1,j+1);
               k=k+1;
           end
       end
   end         
else
    for i=0:E-1
        e(i+1)=f(i+1);
    end
end

%-----------比特选择------------------
if E>=N
    for k=0:N-1
        y(mod(k,N)+1)=e(k+1);
    end
elseif K/E<=7/16
    for k=0:E-1
        y(k+N-E+1)=e(k+1);
    end
else
    for k=0:E-1
        y(k+1)=e(k+1);
    end
end
%----------子块交织--------------------
Jn = get_Jn(N); 
d(Jn+1)=y;
RxRatematchOut=d;
