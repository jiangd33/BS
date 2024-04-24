function dec = lclPolarDecode(in,F,L,iIL,crcLen,padCRC,rnti,qPC)

    % References:
    % [1] Tal, I, and Vardy, A., "List decoding of Polar Codes", IEEE
    % Transactions on Information Theory, vol. 61, No. 5, pp. 2213-2226,
    % May 2015.
    % [2] Stimming, A. B., Parizi, M. B., and Burg, A., "LLR-Based
    % Successive Cancellation List Decoding of Polar Codes", IEEE
    % Transaction on Signal Processing, vol. 63, No. 19, pp.5165-5179,
    % 2015.

    % Setup
    N = length(F);
    m = log2(N);
    K = sum(F==0);      % includes nPC bits as well

    % CRCs as per TS 38.212, Section 5.1
    if crcLen == 24         % '24C', downlink
        polyStr = '24C';
    elseif crcLen == 11     % '11', uplink
        polyStr = '11';
    else % crcLen == 6      % '6', uplink
        polyStr = '6';
    end

    br = zeros(N,1);
    for idxBit = 0:N-1
        % 0-based indexing
        br(idxBit+1) = polarBitReverse(idxBit,m);
    end

    if iIL
        piInterl = interleaveMap(K);
    else
        piInterl = (0:K-1).';
    end

    % Initialize core
    [sttStr, arrayPtrLLR, arrayPtrC] = initializeDataStructures(N,L,m);
    [iniPathIdx, sttStr] = assignInitialPath(sttStr);
    [sp, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrP(sttStr, ...
        arrayPtrLLR, arrayPtrC, 1, iniPathIdx);
    arrayPtrLLR{1,sp}(:,1) = in(br+1);  % LLRs
    mplus1 = m+1;

    % Main loop
    for phase = 1:N
        [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyCalcP(sttStr, ...
            arrayPtrLLR, arrayPtrC, mplus1, phase);

        pm2 = mod(phase-1,2);
        if F(phase)==1
            % Path for frozen (and punctured) bits
            for pathIdx = 1:L
                if ~sttStr.activePath(pathIdx)
                    continue;
                end
                [sc, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
                    arrayPtrLLR, arrayPtrC, mplus1, pathIdx);
                arrayPtrC{mplus1,sc}(1,pm2+1) = 0; % set to 0

                % Exact metric update
                %  sttStr.llrPathMetric(pathIdx) = ...
                %      sttStr.llrPathMetric(pathIdx) + ...
                %      log(1 + exp(-arrayPtrLLR{mplus1,sc}(1,1)));
                % Revised approximation metric update
                tmp = arrayPtrLLR{mplus1,sc}(1,1);
                if tmp < 0
                    sttStr.llrPathMetric(pathIdx) = ...
                        sttStr.llrPathMetric(pathIdx) + abs(tmp);
                    % Else branch doesnt need an update
                end
            end
        else % Path for info bits
            [sttStr, arrayPtrLLR, arrayPtrC] = contPathsUnfrozenBit(sttStr, ...
                arrayPtrLLR, arrayPtrC, phase);
        end

        if pm2==1
            [sttStr, arrayPtrLLR, arrayPtrC] = recursivelyUpdateC(sttStr, ...
                arrayPtrLLR, arrayPtrC, mplus1, phase);
        end
    end

    % Return the best codeword in the list. Use CRC checks, if enabled
    pathIdx1 = 1;
    p1 = realmax;
    crcCW = false;
    for pathIdx = 1:L
        if ~sttStr.activePath(pathIdx)
            continue;
        end

        [sc, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
            arrayPtrLLR, arrayPtrC, mplus1, pathIdx);
        if crcLen>0
            canCW = sttStr.savedCWs(:,sc);  % N, with frozen bits
            canMsg = canCW(F==0,1);         % K bits only (with nPC)
            canMsg(piInterl+1) = canMsg;    % deinterleave (for k+nPC)

            if ~isempty(qPC)
                % Extract the info only bits, minus the PC ones
                qI = find(F==0)-1;
                k = 1;
                out = zeros(length(canMsg)-length(qPC),1);
                for idx = 1:length(qI)
                    if ~any(qI(idx)==qPC)
                        out(k) = canMsg(idx);
                        k = k+1;
                    end
                end
            else
                out = canMsg;
            end

            % Check CRC: errFlag is 1 for error, 0 for no errors
            if padCRC  % prepad with ones
                padCRCMsg = [ones(crcLen,1); out];
            else
                padCRCMsg = out;
            end
            [~, errFlag] = nr5gCRCDecode(padCRCMsg,polyStr,rnti);
            if errFlag      % ~0 => fail
                continue;   % move to next path
            end
        end
        crcCW = true;
        if p1 > sttStr.llrPathMetric(pathIdx)
            p1 = sttStr.llrPathMetric(pathIdx);
            pathIdx1 = pathIdx;
        end
    end

    if ~crcCW   % no codeword found which passes crcCheck
        pathIdx1 = 1;
        p1 = realmax;
        for pathIdx = 1:L
            if ~sttStr.activePath(pathIdx)
                continue;
            end

            if p1 > sttStr.llrPathMetric(pathIdx)
                p1 = sttStr.llrPathMetric(pathIdx);
                pathIdx1 = pathIdx;
            end
        end
    end

    % Get decoded bits
    [sc, sttStr] = getArrayPtrC(sttStr,arrayPtrLLR,arrayPtrC,mplus1,pathIdx1);
    decCW = sttStr.savedCWs(:,sc);      % N, with frozen bits
    dec = decCW(F==0,1);                % K, info + nPC bits only
    dec(piInterl+1) = dec;              % Deinterleave output, K+nPC

end
