function Jn = get_Jn(N) 
Jn=zeros(1,N);
P=[0 1 2 4 3 5 6 7 8 16 9 17 10 18 11 19 12 20 13 21 14 22 15 23 24 25 26 28 27 29 30 31];
for n=0:N-1
    i=floor((32*n)/N)+1;
    Jn(n+1)=P(i)*(N/32)+mod(n,N/32);
end

