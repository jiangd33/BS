% Mid-level fcns
function [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyCalcP(sttStr, ...
    arrayPtrLLR, arrayPtrC, layer, phase)
    % Input:
    %   layer: layer lambda, 1-based, 1:m+1
    %   phase: phase phi, 1-based, 1:2^layer or 1:N

    if layer==1
        return;
    end
    psi = floor((phase-1)/2)+1;
    pm2 = mod(phase-1,2);
    if pm2==0
        [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyCalcP(sttStr, ...
            arrayPtrLLR, arrayPtrC, layer-1, psi);
    end

    expm = 2^(sttStr.m-layer+1);
    for pathIdx = 1:sttStr.L
        if ~sttStr.activePath(pathIdx)
            continue;
        end

        [sp, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrP(sttStr, ...
            arrayPtrLLR, arrayPtrC, layer, pathIdx);
        [spminus1, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrP( ...
            sttStr, arrayPtrLLR, arrayPtrC, layer-1, pathIdx);
        [sc, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
            arrayPtrLLR, arrayPtrC, layer, pathIdx);
        for beta = 0:expm-1
            % LLR
            aa = arrayPtrLLR{layer-1,spminus1}( 2*beta+1,1 );
            bb = arrayPtrLLR{layer-1,spminus1}( 2*beta+2,1 );
            if pm2==0
                % Equation 9, Stimming
                arrayPtrLLR{layer,sp}(beta+1,1) = ...
                    sign(aa)*sign(bb)*min(abs(aa),abs(bb));
            else
                u1 = arrayPtrC{layer,sc}(beta+1,1);
                % Equation 8b, Stimming
                arrayPtrLLR{layer,sp}(beta+1,1) = (-1)^u1 * aa + bb;
            end
        end
    end
end
