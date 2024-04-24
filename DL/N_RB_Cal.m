function [N_RB,mu,N_SLOT,N_FFT,sampleRate,N_cp0,N_cp1] = N_RB_Cal(BandWidth,SCS)
if(SCS==15)
    if(BandWidth==5)
        N_RB = 25;
    elseif(BandWidth==10)
        N_RB = 52;
    elseif(BandWidth==15)
        N_RB = 79;
    elseif(BandWidth==20)
        N_RB = 106;
    elseif(BandWidth==25)
        N_RB = 133;
    elseif(BandWidth==30)
        N_RB = 160;
    elseif(BandWidth==40)
        N_RB = 216;
    else
        N_RB = 270;
    end
    
    mu = 0;
    N_SLOT = 10;
    N_FFT = 4096;
    N_cp1 = 288;
    N_cp0 = 320;
    sampleRate = 122880000/2;
elseif(SCS==30)
    if(BandWidth==5)
        N_RB = 11;
    elseif(BandWidth==10)
        N_RB = 24;
    elseif(BandWidth==15)
        N_RB = 38;
    elseif(BandWidth==20)
        N_RB = 51;
    elseif(BandWidth==25)
        N_RB = 65;
    elseif(BandWidth==30)
        N_RB = 78;
    elseif(BandWidth==40)
        N_RB = 106;
    elseif(BandWidth==50)
        N_RB = 133;
    elseif(BandWidth==100)
        N_RB = 273;
    end
    mu = 1;
    N_SLOT = 20;
    N_FFT = 4096;
    N_cp1 = 288;
    N_cp0 = 352;
    sampleRate = 122880000;
elseif(SCS==60)
    if(BandWidth==50)
        N_RB = 66;
        N_FFT = 1024;
        sampleRate = 61440000;
    elseif(BandWidth==100)
        N_RB = 132;
        N_FFT = 2048;
        sampleRate = 122880000;
    else
        N_RB = 264;
        N_FFT = 4096;
        sampleRate = 245760000;
    end
    mu = 2;
    N_SLOT = 40;
elseif(SCS==120)
    if(BandWidth==50)
        N_RB = 32;
        N_FFT = 512;
        sampleRate = 61440000;
    elseif(BandWidth==100)
        N_RB = 66;
        N_FFT = 1024;
        sampleRate = 122880000;
    elseif(BandWidth==200)
        N_RB = 132;
        N_FFT = 2048;
        sampleRate = 245760000;
    else
        N_RB = 264;
        N_FFT = 4096;
        sampleRate = 491520000;
    end
    mu = 3;
    N_SLOT = 80;
end