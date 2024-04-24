% % % % function [G,overlappingsymbol_pdcch,overlappingfreq_pdcch,overlappingsymbol_ssb,overlappingfreq_ssb] = Calculate_G(NR_Params,S,L,n_PRB,DMRSREnum,Qm,NL,N_sc_RB,PDCCH_monitor_symbol,CORESET_symb,PDCCH_monitor_freq,CORESET_RB,SSB_firstsym,pdsch_freqposition)
% % % % 
% % % % % paramter "DMRSREnum" denote as the Total REs in allocation Resources
% % % % SSB_L = NR_Params.SSB.SSB_L;
% % % % SSB_k0 = NR_Params.SSB.SSB_k0;
% % % % SSB_RB = NR_Params.SSB.SSB_RB;
% % % % %需要增加假设条件不存在SSB和PDCCH的情况
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % pdsch_symbolposition = S:S+L-1;
% % % % pdcch_symbolposition = PDCCH_monitor_symbol:PDCCH_monitor_symbol + CORESET_symb - 1;
% % % % ssb_symbolposition=[];
% % % % for i=1:length(SSB_firstsym)
% % % %     temp=SSB_firstsym(i):SSB_firstsym(i)+SSB_L-1;
% % % %     ssb_symbolposition=[ssb_symbolposition temp];
% % % % end
% % % % % pdsch_freqposition=FD_start:FD_start+n_PRB-1;  
% % % % pdcch_freqposition=PDCCH_monitor_freq:PDCCH_monitor_freq+CORESET_RB-1;
% % % % ssb_freqposition=SSB_k0:SSB_k0+SSB_RB-1;
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % overlappingsymbol_ssb=intersect(pdsch_symbolposition,ssb_symbolposition);
% % % % overlappingsymbol_pdcch=intersect(pdsch_symbolposition,pdcch_symbolposition);
% % % % overlappingfreq_pdcch=intersect(pdsch_freqposition,pdcch_freqposition);
% % % % overlappingfreq_ssb=intersect(pdsch_freqposition,ssb_freqposition);
% % % % if isempty(overlappingsymbol_pdcch)&&isempty(overlappingsymbol_ssb)
% % % %     G=(N_sc_RB*L*n_PRB-DMRSREnum)*Qm;
% % % % else
% % % %     if ~isempty(overlappingsymbol_pdcch)&&isempty(overlappingsymbol_ssb)
% % % %         %         overlapcommon=intersect(overlappingfreq_pdcch,overlappingfreq_ssb);
% % % %         overlappingprbs=length(overlappingfreq_pdcch);
% % % %         overlappingsymbolnum=length(overlappingsymbol_pdcch);
% % % %         n_RE_overlapping=overlappingprbs*overlappingsymbolnum*N_sc_RB;
% % % %         G=(N_sc_RB*L*n_PRB-DMRSREnum-n_RE_overlapping)*Qm;
% % % %     else
% % % %         if isempty(overlappingsymbol_pdcch)&&~isempty(overlappingsymbol_ssb)
% % % %             overlappingprbs=length(overlappingfreq_ssb);
% % % %             overlappingsymbolnum=length(overlappingsymbol_ssb);
% % % %             n_RE_overlapping=overlappingprbs*overlappingsymbolnum*N_sc_RB;
% % % %             G=(N_sc_RB*L*n_PRB-DMRSREnum-n_RE_overlapping)*Qm;
% % % %         else
% % % %             subtractRB=0;
% % % %              addRE=0;
% % % %             for i=S:S+L-1
% % % %                 if ~isempty(intersect(i,overlappingsymbol_pdcch))&&isempty(intersect(i,overlappingsymbol_ssb))
% % % %                     subtractRB=subtractRB+length(overlappingfreq_pdcch);
% % % %                 else
% % % %                     if isempty(intersect(i,overlappingsymbol_pdcch))&&~isempty(intersect(i,overlappingsymbol_ssb))
% % % %                         subtractRB=subtractRB+length(overlappingfreq_ssb);
% % % %                     else if ~isempty(intersect(i,overlappingsymbol_pdcch))&&~isempty(intersect(i,overlappingsymbol_ssb))
% % % %                             subtractRB=subtractRB+length(union(overlappingfreq_ssb,overlappingfreq_pdcch));
% % % %                         end
% % % %                     end
% % % %                 end
% % % % %                 if ~isempty(intersect(i,SSB_firstsym))    %3RE for first symbol of SSB 
% % % % %                     if ~isempty(overlappingfreq_ssb)
% % % % %                         addRE=addRE+3;
% % % % %                     end
% % % % %                 end                             
% % % %             end
% % % %             G=(N_sc_RB*L*n_PRB-DMRSREnum-subtractRB*N_sc_RB)*Qm;
% % % %         end
% % % %     end
% % % % end
% % % % G = G*NL;  
% NL   is the number of transmission layers that the transport block is mapped onto



% function [G,overlappingsymbol_pdcch,overlappingfreq_pdcch,overlappingsymbol_ssb,overlappingfreq_ssb] = Calculate_G(NR_Params,S,L,n_PRB,DMRSREnum,Qm,NL,N_sc_RB,PDCCH_monitor_symbol,CORESET_symb,PDCCH_monitor_freq,CORESET_RB,SSB_firstsym,pdsch_freqposition)
function G = Calculate_G(NR_Params,S,L,n_PRB,DMRSREnum,Qm,NL,N_sc_RB)
% paramter "DMRSREnum" denote as the Total REs in allocation Resources
% SSB_L = NR_Params.SSB.SSB_L;
% SSB_k0 = NR_Params.SSB.SSB_k0;
% SSB_RB = NR_Params.SSB.SSB_RB;
% %需要增加假设条件不存在SSB和PDCCH的情况
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pdsch_symbolposition = S:S+L-1;
% pdcch_symbolposition = PDCCH_monitor_symbol:PDCCH_monitor_symbol + CORESET_symb - 1;
% ssb_symbolposition=[];
% for i=1:length(SSB_firstsym)
%     temp=SSB_firstsym(i):SSB_firstsym(i)+SSB_L-1;
%     ssb_symbolposition=[ssb_symbolposition temp];
% end
% % pdsch_freqposition=FD_start:FD_start+n_PRB-1;  
% pdcch_freqposition=PDCCH_monitor_freq:PDCCH_monitor_freq+CORESET_RB-1;
% ssb_freqposition=SSB_k0:SSB_k0+SSB_RB-1;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% overlappingsymbol_ssb=intersect(pdsch_symbolposition,ssb_symbolposition);
% overlappingsymbol_pdcch=intersect(pdsch_symbolposition,pdcch_symbolposition);
% overlappingfreq_pdcch=intersect(pdsch_freqposition,pdcch_freqposition);
% overlappingfreq_ssb=intersect(pdsch_freqposition,ssb_freqposition);
% if isempty(overlappingsymbol_pdcch)&&isempty(overlappingsymbol_ssb)
% %     G=(N_sc_RB*L*n_PRB-DMRSREnum)*Qm;
%     G=(N_sc_RB*(L-2)*n_PRB)*Qm;
% else
%     if ~isempty(overlappingsymbol_pdcch)&&isempty(overlappingsymbol_ssb)
%         %         overlapcommon=intersect(overlappingfreq_pdcch,overlappingfreq_ssb);
%         overlappingprbs=length(overlappingfreq_pdcch);
%         overlappingsymbolnum=length(overlappingsymbol_pdcch);
%         n_RE_overlapping=overlappingprbs*overlappingsymbolnum*N_sc_RB;
%         G=(N_sc_RB*L*n_PRB-DMRSREnum-n_RE_overlapping)*Qm;
%     else
%         if isempty(overlappingsymbol_pdcch)&&~isempty(overlappingsymbol_ssb)
%             overlappingprbs=length(overlappingfreq_ssb);
%             overlappingsymbolnum=length(overlappingsymbol_ssb);
%             n_RE_overlapping=overlappingprbs*overlappingsymbolnum*N_sc_RB;
%             G=(N_sc_RB*L*n_PRB-DMRSREnum-n_RE_overlapping)*Qm;
%         else
%             subtractRB=0;
%              addRE=0;
%             for i=S:S+L-1
%                 if ~isempty(intersect(i,overlappingsymbol_pdcch))&&isempty(intersect(i,overlappingsymbol_ssb))
%                     subtractRB=subtractRB+length(overlappingfreq_pdcch);
%                 else
%                     if isempty(intersect(i,overlappingsymbol_pdcch))&&~isempty(intersect(i,overlappingsymbol_ssb))
%                         subtractRB=subtractRB+length(overlappingfreq_ssb);
%                     else if ~isempty(intersect(i,overlappingsymbol_pdcch))&&~isempty(intersect(i,overlappingsymbol_ssb))
%                             subtractRB=subtractRB+length(union(overlappingfreq_ssb,overlappingfreq_pdcch));
%                         end
%                     end
%                 end
% %                 if ~isempty(intersect(i,SSB_firstsym))    %3RE for first symbol of SSB 
% %                     if ~isempty(overlappingfreq_ssb)
% %                         addRE=addRE+3;
% %                     end
% %                 end                             
%             end
%             G=(N_sc_RB*L*n_PRB-DMRSREnum-subtractRB*N_sc_RB)*Qm;
%         end
%     end
% end
G = (N_sc_RB*(L-2)*n_PRB)*Qm;
G = G*NL;  
% NL   is the number of transmission layers that the transport block is mapped onto
