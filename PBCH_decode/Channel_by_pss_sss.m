function ref = Channel_by_pss_sss(rec)

I = real(rec);

I(I>0) = 1;
I(I<0) = -1;
ref = I;