function Recover_data = Detectsignal_PBCH(H,RxResMapPointer)

% global N_RB_sc;
% global SSB_RB;
% global SSB_L;

SSB_L = 4;
SSB_RB = 20;
N_RB_sc = 12;

% global PDCCH_monitor_symbol;
% global PDCCH_monitor_freq;
% global TxAntenna_Num;
% global RxAntenna_Num;

k0 = 0;
l0 = 0;
data = RxResMapPointer(k0+1:k0+SSB_RB*N_RB_sc,l0+1:l0+SSB_L);
Recover_data1=zeros(SSB_RB*N_RB_sc,SSB_L);
Recover_data1(:,1)=data(:,1)./H(:,1);

for n = 1:SSB_L-1
    for ii = 1:N_RB_sc*SSB_RB
        if H(ii,n) == 0               %分母不能为0
            Recover_data1(ii,n+1) = data(ii,n+1);
        else
            Recover_data1(ii,n+1) = data(ii,n+1)/H(ii,n);
        end
    end
end
% figure;plot(Recover_data1(:,end),'.')
  
% % for n = 1:SSB_L-1
% % %     Wmmse = inv(H(:,1)*H(:,1)'+0)*H(:,1);
% %     Rhh = H(:,1)*H(:,1)'; 
% %     W = Rhh/(Rhh+4.8*eye(240)); 
% %     HhatLMMSE = W*H(:,1); 
% %     Recover_data1(:,n+1) = data(:,n+1)./HhatLMMSE;
% % end
% % figure;plot(Recover_data1(:,end),'.')

% %   Recover_data1(57:183,3) = data(57:183,3)./H(57:183,3);
  Recover_data = Recover_data1;
% end
%==================END=======================