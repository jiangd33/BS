% function [Cos_Modify,RS_EVM_subframe,RS_EVM_peak_subframe]=RS_EVM_Cal(Rec_CSRS,REF_CSRS)
function [RS_EVM_subframe,RS_EVM_peak_subframe]=RS_EVM_Cal(Rec_CSRS,REF_CSRS)
%%%%%%%%%%%%% 
    [M,N] = size(Rec_CSRS);

    Rec_CSRS_Rec_CSRS = reshape(Rec_CSRS,1,[]);
    REF_CSRS_REF_CSRS = reshape(REF_CSRS,1,[]);
    error = Rec_CSRS_Rec_CSRS - REF_CSRS_REF_CSRS;
    t = size(error,2);
% %     Preal_error = 0; Nreal_error = 0; Pimag_error = 0 ; Nimag_error = 0;
% %     Preal_num   = 0; Nreal_num   = 0; Pimag_num   = 0 ; Nimag_num   = 0;
% %     for k = 1 : t
% %         if real(error(k)) > 0
% %             Preal_error = Preal_error + real(error(k));
% %             Preal_num = Preal_num + 1;
% %         else
% %             Nreal_error = Nreal_error + real(error(k));
% %             Nreal_num = Nreal_num + 1;
% %         end
% %         if imag(error(k)) > 0
% %             Pimag_error = Pimag_error + imag(error(k));
% %             Pimag_num = Pimag_num + 1;
% %         else
% %             Nimag_error = Nimag_error + imag(error(k));
% %             Nimag_num = Nimag_num + 1;
% %         end
% %     end
% %     Preal_error = Preal_error/Preal_num;
% %     Nreal_error = Nreal_error/Nreal_num;
% %     Pimag_error = Pimag_error/Pimag_num; 
% %     Nimag_error = Nimag_error/Nimag_num;
%%

% % % % for k = 1 : t 
% % % %     if(real(error(k))>0)
% % % %         Data_I = real(Rec_CSRS(k)) - Preal_error;
% % % %         error_I(k) = real(error(k)) - Preal_error;
% % % %     else
% % % %         Data_I = real(Rec_CSRS(k)) + Preal_error;
% % % %         error_I(k) = real(error(k)) - Nreal_error;
% % % %     end
% % % %     if(imag(error(k))>0)
% % % %         Data_Q = imag(Rec_CSRS(k)) - Pimag_error;
% % % %         error_Q(k) = imag(error(k)) - Pimag_error;
% % % %     else
% % % %         Data_Q = imag(Rec_CSRS(k)) + Nimag_error;
% % % %         error_Q(k) = imag(error(k)) - Nimag_error;
% % % %     end
% % % %     
% % % % %         Error(k) = (abs(error(k)))^2;
% % % %         Error(k) = (error_I(k)*error_I(k)+error_Q(k)*error_Q(k));
% % % %         REF_Power(k) = (abs(REF_CSRS_REF_CSRS(k)))^2;
% % % %         EVM_data(k)=sqrt(Error(k)/REF_Power(k));
% % % %         
% % % %         Cos_Modify(k) = Data_I+1j*Data_Q;
% % % %         
% % % % end
% % % %     RS_EVM_subframe=sqrt(sum(Error)/sum(REF_Power));
% % % %     [C I]=max(EVM_data);
% % % %     RS_EVM_peak_subframe=EVM_data(I);
    
    for k = 1 : t 
        Error(k) = (abs(error(k)))^2;
        REF_Power(k) = (abs(REF_CSRS_REF_CSRS(k)))^2;
        EVM_data(k)=sqrt(Error(k)/REF_Power(k));
    end
    RS_EVM_subframe=sqrt(sum(Error)/sum(REF_Power));
    [C I]=max(EVM_data);
    RS_EVM_peak_subframe=EVM_data(I);
    
