function dshou = Channel_by_qpsk(dsymb)

% [N,M] = size(dsymb);
M = length(dsymb);

for i = 1:M
    if real(dsymb(i))>0
        Re_RefSym(i,1) = sqrt(2)/2;
    else
        Re_RefSym(i,1) = -sqrt(2)/2;
    end
    if imag(dsymb(i))>0
        Im_RefSym(i,1) = sqrt(2)/2;
    else
        Im_RefSym(i,1) = -sqrt(2)/2;
    end
end
dshou = Re_RefSym + 1j*Im_RefSym;