function outkpc = PolarDecode_matlab(in,K,iIL,rnti)

nMax = 9;

L = 8;
crcLen = 24;
padCRC = 1;

E = length(in);
[F,qPC] = PolarConstruct(K,E,nMax);

% CA-SCL decode
outkpc = lclPolarDecode(in,F,L,iIL,crcLen,padCRC,rnti,qPC);