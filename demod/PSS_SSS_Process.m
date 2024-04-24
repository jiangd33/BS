function [Rx_PSS,Rx_SSS] = PSS_SSS_Process(Rx_PSS,Rx_SSS,N_cell_ID)

N_1_ID = floor(N_cell_ID/3);
N_2_ID = mod(N_cell_ID,3);
T_pss1 = TxDLPSSseq(N_2_ID);
T_sss1=TxDLSSSseq(N_1_ID,N_2_ID);

% % % % for k = 1:127
% % % %     if(real(Rx_PSS(k))>0)
% % % %         T_pss1(k) = 1;
% % % %     else
% % % %         T_pss1(k) = -1;
% % % %     end
% % % %     if(real(Rx_SSS(k))>0)
% % % %         T_sss1(k) = 1;
% % % %     else
% % % %         T_sss1(k) = -1;
% % % %     end
% % % % end

% % % % cont = 0;
% % % % ph = 0;
% % % % for i=1:length(Rx_PSS)
% % % %     T1= atan2(imag(Rx_PSS(i)),real(Rx_PSS(i)));    %参考符号点与测量符号点的误差向量
% % % %     T2 = atan2(0,real(T_pss1(i))); 
% % % %     if(abs(T1 - T2) < pi/2)
% % % %         cont = cont+1;
% % % %         ph = ph + T1 - T2;
% % % %     end
% % % % end
H1 = Rx_PSS./T_pss1;
H2 = Rx_SSS./T_sss1;
ph = -mean(atan2(imag(H1.*H2),real(H1.*H2)))/2;

% ph = -pi/2;
% ph = ph/cont - pi/4;
for i=1:length(Rx_PSS)
    T1 = real(Rx_PSS(i))*cos(ph) - imag(Rx_PSS(i))*sin(ph);    % 参考符号点与测量符号点的误差向量
    T2 = real(Rx_PSS(i))*sin(ph) + imag(Rx_PSS(i))*cos(ph); 
    Rx_PSS(i) = T1 + 1j*T2; 
    T1 = real(Rx_SSS(i))*cos(ph) - imag(Rx_SSS(i))*sin(ph);    % 参考符号点与测量符号点的误差向量
    T2 = real(Rx_SSS(i))*sin(ph) + imag(Rx_SSS(i))*cos(ph); 
    Rx_SSS(i) = T1 + 1j*T2; 
end


figure;plot(Rx_PSS,'.'),hold on,plot(Rx_SSS,'.'),axis([-1,1,-1,1]);