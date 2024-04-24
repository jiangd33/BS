%Sets of LDPC lifting size  Z for chioce Z_c
%**************************************************************************
%Copyright (C), 2018, CQUPT
%FileName:     liftingsizes
%Description:  Sets of LDPC lifting size Z
%Reference:    [7,38212] clause 5.3.2
%Author:       DSP_GROUP
%Input:        i_LS
%              
%Output:       Z_c
%History:
%      <time>      <version >
%      2018/8/20      1.0
%**************************************************************************
function [Z_c,i_LS] = liftingsizes(K1,K_b)

Z = [2, 4,  8, 16, 32,  64, 128, 256;
    3,  6, 12, 24, 48,  96, 192, 384;
    5, 10, 20, 40, 80, 160, 320, 0;
    7, 14, 28, 56, 112, 224, 0, 0;
    9, 18, 36, 72, 144, 288, 0, 0;
    11, 22, 44, 88, 176, 352,0, 0;
    13, 26, 52, 104, 208, 0, 0, 0;
    15, 30, 60, 120, 240, 0, 0, 0
    ];
temp=K1/K_b;
[l,k]=find(Z==min(Z(find(Z>=temp))));
i_LS = l;
Z_c = Z(l,k);
