% Low-level fcns
function [sttStr, arrayPtrLLR, arrayPtrC] = initializeDataStructures(N,L,m)
    % Indices are all 1-based MATLAB indices.

    sttStr.L = L;
    sttStr.m = m;                   % log2(N)

    maxMplus1 = 11;                 % for N=1024
    % Limited for now to the input L value only. Can be parameterized to be
    % the maximum value of L, similar to maxMplus1.
    coder.varsize('parrayPtrLLR',[maxMplus1 L], [1 0]);
    coder.varsize('parrayPtrC',[maxMplus1 L], [1 0]);

    mplus1 = m+1;
    parrayPtrLLR = cell(mplus1,L);  % store arrays
    parrayPtrC = cell(mplus1,L);    % store arrays
    coder.unroll(false);            % Allows maxMplus1, mplus1 to differ
    for layer = 1:mplus1
        expm = 2^(mplus1-layer);
        coder.unroll(false);
        for s = 1:L
            parrayPtrLLR{layer,s} = zeros(expm,1);
            parrayPtrC{layer,s} = zeros(expm,2); % binary-valued: 0,1
        end
    end
    % An extra layer of in-direction is needed for codegen
    arrayPtrLLR = parrayPtrLLR;           % (m+1)-by-L
    arrayPtrC = parrayPtrC;               % (m+1)-by-L

    sttStr.llrPathMetric = zeros(L,1);

    sttStr.pathIdxToArrayIdx = ones(mplus1,L);   % (m+1)-by-L

    sttStr.inactiveArrayIndices = zeros(mplus1,L);
    sttStr.inactiveArrayIndicesLen = zeros(mplus1,1);
    for layer = 1:mplus1
        sttStr.inactiveArrayIndices(layer,:) = 1:L;
        sttStr.inactiveArrayIndicesLen(layer,1) = L;
    end
    sttStr.arrayReferenceCount = zeros(mplus1,L);

    sttStr.inactivePathIndices = (1:L).';     % all paths are inactive
    sttStr.inactivePathIndicesLen = L;        % 1-by-1, stack depth
    sttStr.activePath = zeros(L,1,'logical'); % no paths are active

    sttStr.savedCWs = zeros(N,L);             % saved codewords

end
