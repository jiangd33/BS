function br = polarBitReverse(b,n)


b = rem(floor(b*pow2(1-n:0)),2);
br = bi2deRightMSB(b,2);