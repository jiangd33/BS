function d = bi2deRightMSB(b, p)

pow2vector = p.^(0 : (size(b,2)-1))';    
    d = b * pow2vector;