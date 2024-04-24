function [sttStr, arrayPtrLLR, arrayPtrC] = contPathsUnfrozenBit(sttStr, ...
    arrayPtrLLR, arrayPtrC, phase)
    % Input:
    %   phase: phase phi, 1-based, 1:2^m, or 1:N
    %
    % Revised metric update to use approximation:
    %   log(1+exp(x)) = 0 for x < 0,
    %                 = x for x >= 0.

    % Populate probForks
    probForks = -realmax*ones(sttStr.L,2);
    i = 0;
    mplus1 = sttStr.m+1;
    for pathIdx = 1:sttStr.L
        if sttStr.activePath(pathIdx)
            [sp, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrP(sttStr, ...
                arrayPtrLLR, arrayPtrC, mplus1, pathIdx);

            % Exact metric use
            % probForks(pathIdx,1) = - (sttStr.llrPathMetric(pathIdx) ...
            %     + log(1+exp(-(arrayPtrLLR{mplus1,sp}(1,1)))));
            % probForks(pathIdx,2) = - (sttStr.llrPathMetric(pathIdx) ...
            %     + log(1+exp((arrayPtrLLR{mplus1,sp}(1,1)))));
            % Revised approximation use
            tmp = arrayPtrLLR{mplus1,sp}(1,1);
            if tmp > 0
                probForks(pathIdx,1) = - sttStr.llrPathMetric(pathIdx);
                probForks(pathIdx,2) = -(sttStr.llrPathMetric(pathIdx) ...
                    + tmp);
            else
                probForks(pathIdx,1) = - (sttStr.llrPathMetric(pathIdx) ...
                    + abs(tmp));
                probForks(pathIdx,2) = - sttStr.llrPathMetric(pathIdx);
            end
            i = i+1;
        end
    end

    rho = min(2*i,sttStr.L);
    contForks = zeros(sttStr.L,2);
    % Populate contForks such that contForks(l,b) is true iff
    % probForks(l,b) is one of rho largest entries in probForks.
    prob = sort(probForks(:), 'descend');
    if rho>0
        threshold = prob(rho);
    else
        threshold = prob(1); % Largest
    end
    numPop = 0;
    for pathIdx = 1:sttStr.L
        for bIdx = 1:2
            if numPop==rho
                break;
            end
            if probForks(pathIdx,bIdx)>threshold
                contForks(pathIdx,bIdx) = 1;
                numPop = numPop+1;
            end
        end
    end

    if numPop<rho
        for pathIdx = 1:sttStr.L
            for bIdx = 1:2
                if numPop==rho
                    break;
                end
                if probForks(pathIdx,bIdx)==threshold
                    contForks(pathIdx,bIdx) = 1;
                    numPop = numPop+1;
                end
            end
        end
    end

    % First, kill-off non-continuing paths
    for pathIdx = 1:sttStr.L
        if ~sttStr.activePath(pathIdx)
            continue;
        end
        if contForks(pathIdx,1)==0 && contForks(pathIdx,2)==0
            sttStr = killPath(sttStr, pathIdx);
        end
    end

    % Continue relevant paths, duplicating if necessary
    pm2 = mod(phase-1,2);
    for pathIdx = 1:sttStr.L
        if contForks(pathIdx,1)==0 && contForks(pathIdx,2)==0
            % Both forks are bad
            continue;
        end

        [sc, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
            arrayPtrLLR, arrayPtrC, mplus1, pathIdx);
        if contForks(pathIdx,1)==1 && contForks(pathIdx,2)==1
            % Both forks are good
            arrayPtrC{mplus1,sc}(1,pm2+1) = 0;
            sttStr.savedCWs(phase,sc) = 0;

            [pathIdx1, sttStr] = clonePath(sttStr, pathIdx);
            [sc2, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
                arrayPtrLLR, arrayPtrC, mplus1, pathIdx1);
            sttStr.savedCWs(1:phase-1,sc2) = sttStr.savedCWs(1:phase-1,sc);

            arrayPtrC{mplus1,sc2}(1,pm2+1) = 1;
            sttStr.savedCWs(phase,sc2) = 1;
            % Exact metric update
            % sttStr.llrPathMetric(pathIdx) = sttStr.llrPathMetric(pathIdx) ...
            %   + log(1 + exp(-arrayPtrLLR{mplus1,sc}(1,1)));
            % Revised approximation metric update
            tmp = arrayPtrLLR{mplus1,sc}(1,1);
            if tmp < 0
                sttStr.llrPathMetric(pathIdx) = ...
                    sttStr.llrPathMetric(pathIdx) + abs(tmp);
                % Else branch doesnt need an update
            end
            % Exact metric update
            % sttStr.llrPathMetric(pathIdx1) = sttStr.llrPathMetric(pathIdx1) ...
            %   + log(1 + exp(arrayPtrLLR{mplus1,sc2}(1,1)));
            % Revised approximation metric update
            tmp2 = arrayPtrLLR{mplus1,sc2}(1,1);
            if tmp2 > 0
                sttStr.llrPathMetric(pathIdx1) = ...
                    sttStr.llrPathMetric(pathIdx1) + tmp2;
                % Else branch doesnt need an update
            end
        else
            % Exactly one fork is good
            tmp = arrayPtrLLR{mplus1,sc}(1,1);
            if contForks(pathIdx,1)==1
                arrayPtrC{mplus1,sc}(1,pm2+1) = 0;
                sttStr.savedCWs(phase,sc) = 0;
                % Exact metric update
                % sttStr.llrPathMetric(pathIdx) = sttStr.llrPathMetric(pathIdx) ...
                %   + log(1 + exp(-arrayPtrLLR{mplus1,sc}(1,1)));
                % Revised approximation metric update
                if tmp < 0
                    sttStr.llrPathMetric(pathIdx) = ...
                        sttStr.llrPathMetric(pathIdx) + abs(tmp);
                    % Else branch doesnt need an update
                end
            else
                arrayPtrC{mplus1,sc}(1,pm2+1) = 1;
                sttStr.savedCWs(phase,sc) = 1;
                % Exact metric update
                % sttStr.llrPathMetric(pathIdx) = sttStr.llrPathMetric(pathIdx) ...
                %   + log(1 + exp(arrayPtrLLR{mplus1,sc}(1,1)));
                % Revised approximation metric update
                if tmp > 0
                    sttStr.llrPathMetric(pathIdx) = ...
                        sttStr.llrPathMetric(pathIdx) + tmp;
                    % Else branch doesnt need an update
                end
            end
        end
    end

end

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