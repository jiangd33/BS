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

function Hdata = linear_inter_PBCH(H,v1)
%interpolation of Rx_port1 

% global N_RB_sc;
% global SSB_RB;
SSB_L = 4;

sym1 = H(1:60);%·ûºÅ1
sym2_1 = H(61:72);%·ûºÅ2
sym2_2 = H(73:84);
sym3 = H(85:end);%·ûºÅ3

% for k = 1:S
   mm1 = 0+v1+1:4:236+v1+1;
   mm2_1 = 0+v1+1:4:44+v1+1;
   mm2_2 = 192+v1+1:4:236+v1+1;
   ii = v1+1:236+v1+1;
   ii2_1 = v1+1:44+v1+1;
   ii2_2 = 192+v1+1:236+v1+1;
   Hdata1(ii,1) = interp1(mm1,sym1,ii);       %data between two pilots
   Hdata2_1(ii2_1,1) = interp1(mm2_1,sym2_1,ii2_1);
   Hdata2(ii2_2,1) = interp1(mm2_2,sym2_2,ii2_2);
   Hdata3(ii,1) = interp1(mm1,sym3,ii);
   Hdata2(1:length(Hdata2_1)) = Hdata2_1;
   Hdata = zeros(240,3);
   Hdata(1:length(Hdata1),1) = Hdata1;
   Hdata(1:length(Hdata2),2) = Hdata2;
   Hdata(1:length(Hdata3),3) = Hdata3;
   
   if v1==0
       for l=1:SSB_L-1
           if l==2
                for k=46:48
                     Hdata(k,l)=Hdata(45,l);
                end
           end
           for k=238:240
               Hdata(k,l)=Hdata(237,l);
           end           
       end
   elseif v1==1
       Hdata(1,:)=Hdata(2,:);
       for l=1:SSB_L-1
           if l==2
                for k=47:48
                    Hdata(k,l)=Hdata(46,l);
                end
                Hdata(193,l)=Hdata(194,l);
           end
           for k=238:240
               Hdata(k,l)=Hdata(237,l);
           end           
       end
   elseif v1==2
      for l=1:SSB_L-1
         for k=1:2
            Hdata(k,l)=Hdata(3,l);
          end
          if l==2
             Hdata(48,l)=Hdata(47,l);
             for k=193:194
                 Hdata(k,l)=Hdata(195,l);
              end
          end
      end
      Hdata(240,:)=Hdata(239,:); 
   else
       for l=1:SSB_L-1
          for k=1:3
             Hdata(k,l)=Hdata(4,l);
          end
          if l==2
             for k=193:195
                Hdata(k,l)=Hdata(196,l);
             end
          end 
       end
   end
       
end
%=================END================