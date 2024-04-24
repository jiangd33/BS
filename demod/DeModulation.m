
function DeModulationoutdata = DeModulation(Delayermappingoutdata,Qm)

    switch (Qm)
        case 2
            DeModulationoutdata = qpsk_demod(1,Delayermappingoutdata);
        case 4
            DeModulationoutdata = qam16_demod(1,Delayermappingoutdata);
        case 6
            DeModulationoutdata = qam64_demod(1,Delayermappingoutdata);
        case 8
            DeModulationoutdata = qam256_demod(Delayermappingoutdata);
    end