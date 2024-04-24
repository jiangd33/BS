function [N,K,K1,k0,Z_c,C,H,CRC_Type,CBGTI,N_cb,H_BG] = ParaCal(PDSCH_Params,TBnumber,S,L,n_PRB,dmrs_symb_len,Qm,R)

N_RB_sc = 12;
% % % % Xoh_PDSCH = NR_Params.PDSCH.Xoh_PDSCH;
% % % % % i_LS = NR_Params.PDSCH.i_LS;
% % % % NL = NR_Params.PDSCH.NL;
% % % % N_RB_sc = NR_Params.Cell.N_RB_sc;
% % % % rv_id = NR_Params.PDSCH.rv_id;
rv_id = PDSCH_Params.rv_id;
Xoh_PDSCH = 0;
NL = 1;


% [Qm,R,~] = MCS_index_table(NR_Params.PDSCH.I_MCS,0); 
N_symb_sh = L;                % is the number of scheduled OFDM symbols in a slot                 
N_oh_PRB = Xoh_PDSCH; 
% N_RE1 = N_RB_sc*N_symb_sh-N_DMRS_PRB-N_oh_PRB;
N_RE1 = N_RB_sc*(N_symb_sh - dmrs_symb_len)-N_oh_PRB;%at 2019.10.15

% N_RE1_bar = Quantized_N_RE1(N_RE1);
N_RE1_bar = min(156,N_RE1);
N_RE = N_RE1_bar*n_PRB;
N_info = N_RE*R(TBnumber)*Qm(TBnumber)*NL(TBnumber);

TBS = TBS_table(N_info,R(TBnumber));
% TBS = 1144 - 16;
%%%%%%%%%%%%%%%
if TBS>3824
   B = TBS + 24;    %24A
   CRC_Type = 4;
else
   B = TBS + 16;
   CRC_Type = 3;
end
A = TBS;
% B = 1144;
%%%%%%%%%%%%%%%%
if A<=292||(A<=3824&&R(TBnumber)<=0.67)||R(TBnumber)<=0.25
    LDPC_base_graph = 2;
else
    LDPC_base_graph = 1;
end
%%%%%%%%%%%%%%%%%%
if LDPC_base_graph==1
    K_cb = 8448;
    K_b = 22;
else
    K_cb = 3840;
    if B>640
        K_b = 10;
    else if B>560
            K_b = 9;
        else if B>192
                K_b = 8;
            else
                K_b = 6;
            end
        end
    end
end

if B<=K_cb
    L = 0;
    C = 1;
    B1 = B;
else
    L = 24;
    C = ceil(B/(K_cb-L));
    B1 = B+C*L;
end
K1 = B1/C;%K1为每�?��码块的bit�?
%%%Determine the length of each code block K%%%%%%%%
[Z_c,i_LS] = liftingsizes(K1,K_b);

if LDPC_base_graph==1
    K = 22*Z_c;
    N = 66*Z_c;
    V = V1_I_LS(i_LS);
else
    K = 10*Z_c;
    N = 50*Z_c;  
    V = V2_I_LS(i_LS);
end
H_BG = H_BGgraph(LDPC_base_graph);
H = generateH(Z_c,H_BG,V,LDPC_base_graph);
CBGTI = ones(1,C);    %is the number of scheduled code blocks by DCI, assume "1" denote as  scheduled 
LBRM = zeros(1,C);    %is higher layer parameter,for each code block
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% I_LBRM = 1;
for r=1:C
    %%%%%TBS_LBRM%%%
%     TBS_LBRM = TBS_LBRMcount(R);
    TBS_LBRM = TBS;
    %%%%%%%%%%%%%%
%     if LBRM(r)==1    %LBRM is higher layer parameter
%         I_LBRM=1;
%     else
%         I_LBRM=0;
%     end
    I_LBRM = 0;%UE接收情况下强制设�?
    %%%%%%%%%%%%%%%%
    R_LBRM = 2/3;
    N_ref = floor(TBS_LBRM/(C*R_LBRM));
    if I_LBRM==0
        N_cb = N;
    else
        N_cb = min(N,N_ref);
    end

    rv_idtable = [0                                           0
        floor(17*N_cb/(66*Z_c))*Z_c   floor(13*N_cb/(50*Z_c))*Z_c
        floor(33*N_cb/(66*Z_c))*Z_c   floor(25*N_cb/(50*Z_c))*Z_c
        floor(56*N_cb/(66*Z_c))*Z_c   floor(43*N_cb/(50*Z_c))*Z_c];
   k01 = rv_idtable(rv_id(TBnumber)+1,LDPC_base_graph);    %from table 5.4.2.1-2
   k0(r) =  k01;
end
