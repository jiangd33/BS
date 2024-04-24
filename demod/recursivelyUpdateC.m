function [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyUpdateC(sttStr, ...
    arrayPtrLLR, arrayPtrC, layer, phase)
    % Input:
    %   layer: layer lambda, 1-based, 1:m+1
    %   phase: phase phi, 1-based, 1:2^layer or 1:N, must be odd

    psi = floor((phase-1)/2);
    pm2 = mod(psi,2);
    expm = 2^(sttStr.m-layer+1);
    for pathIdx = 1:sttStr.L
        if ~sttStr.activePath(pathIdx)
            continue;
        end
        [sc, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
            arrayPtrLLR, arrayPtrC, layer, pathIdx);
        [scminus1, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC( ...
            sttStr, arrayPtrLLR, arrayPtrC, layer-1, pathIdx);
        for beta = 0:expm-1
            arrayPtrC{layer-1,scminus1}(2*beta+1,pm2+1) = ...
                xor(arrayPtrC{layer,sc}(beta+1,1), ...
                arrayPtrC{layer,sc}(beta+1,2));
            arrayPtrC{layer-1,scminus1}(2*beta+2,pm2+1) = ...
                arrayPtrC{layer,sc}(beta+1,2);
        end
    end

    if pm2==1
        [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyUpdateC(sttStr, ...
            arrayPtrLLR, arrayPtrC, layer-1, psi+1);
    end

end