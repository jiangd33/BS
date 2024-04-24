%**************************************************************************
%Copyright (C), 2013, CQUPT
%FileName:    linear_inter
%Description:  frequency domain interpolation and time domain interpolation for port0 or port1 
%Author:       Algorithm_GROUP
%Input:        1.Hp:data after Cell-specific reference signal(CSRS) generation 
%              2.shift1:the value of v ,0 or 3 
%              3.shift2:the value of v ,0 or 3 
%Output:       Hdata:data after interpolation for port0 or port1 
%History:
%      <time>      <version >
%      2013/1/24     1.0
%**************************************************************************

function Hdata = linear_inter(CORESET_RB,H,shift_up,shift_down)
%interpolation of Rx_port1 

N_RB_sc = 12;
CORESET_symb = 1;

M=CORESET_RB*N_RB_sc;
N=CORESET_symb;
cnt = 1;
for n=0:CORESET_RB*CORESET_symb-1
   l=mod(n,CORESET_symb);
   for k=0:2
      alfa = floor(n/CORESET_symb);
      Hp(alfa*3+k+1,l+1) = H(cnt);
      cnt=cnt+1;
   end
end


Hp = flipud(Hp);      %没有必要进行倒序的20130724   还是有必要的20170620，翻转后数据排布就为协议中的图形一样
[R,S]=size(Hp);
Hdata = zeros(M,N);

%-------START------
for k = 1:S
   mm = shift_up+1:4:M-shift_down;  
   ii = shift_up+1:M-shift_down;
   Hdata(ii,k) = interp1(mm,Hp(:,k),ii);       %data between two pilots
   for L = 1:shift_up          %最上面有2个RE需要用邻近插值；
      Hdata(L,k)=Hp(1,k);        
   end
   L = M;                      %最下面有1个RE需要用邻近插值；
   Hdata(L,k)=Hp(R,k);     %data at the edge of RB 
end                            %frequency domain interpolation

Hdata = flipud(Hdata);%没有必要进行倒序的20130724
end


% % % % function Hdata = linear_inter(H,shift_up,shift_down)
% % % % %interpolation of Rx_port1 
% % % % 
% % % % global N_RB_sc;
% % % % global CORESET_RB;
% % % % global CORESET_symb;
% % % % 
% % % % M=CORESET_RB*N_RB_sc;
% % % % N=CORESET_symb;
% % % % cnt = 1;
% % % % for n=0:CORESET_RB*CORESET_symb-1
% % % %    l=mod(n,CORESET_symb);
% % % %    for k=0:2
% % % %       alfa = floor(n/CORESET_symb);
% % % %       Hp(alfa*3+k+1,l+1) = H(cnt);
% % % %       cnt=cnt+1;
% % % %    end
% % % % end
% % % % 
% % % % 
% % % % Hp = flipud(Hp);      %没有必要进行倒序的20130724   还是有必要的20170620，翻转后数据排布就为协议中的图形一样
% % % % [R,S]=size(Hp);
% % % % Hdata = zeros(M,N);
% % % % 
% % % % %-------START------
% % % % for k = 1:S
% % % %    mm = shift_up+1:4:M-shift_down;  
% % % %    ii = shift_up+1:M-shift_down;
% % % %    Hdata(ii,k) = interp1(mm,Hp(:,k),ii);       %data between two pilots
% % % %    for L = 1:shift_up          %最上面有2个RE需要用邻近插值；
% % % %       Hdata(L,k)=Hp(1,k);        
% % % %    end
% % % %    L = M;                      %最下面有1个RE需要用邻近插值；
% % % %    Hdata(L,k)=Hp(R,k);     %data at the edge of RB 
% % % % end                            %frequency domain interpolation
% % % % 
% % % % Hdata = flipud(Hdata);%没有必要进行倒序的20130724
% % % % end
%=================END================