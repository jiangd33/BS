function [s2, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrP(sttStr, ...
    arrayPtrLLR, arrayPtrC, layer, pathIdx)
    % Input:
    %   layer:   layer lambda, 1-based, 1:m+1
    %   pathIdx: path index l, 1-based, 1:L
    % Output:
    %   s2: corresponding pathIdx for same layer

    s = sttStr.pathIdxToArrayIdx(layer,pathIdx);
    if sttStr.arrayReferenceCount(layer,s)==1
        s2 = s;
    else
        s2 = sttStr.inactiveArrayIndices(layer, ...
            sttStr.inactiveArrayIndicesLen(layer,1));
        if sttStr.inactiveArrayIndicesLen(layer,1) > 1
            sttStr.inactiveArrayIndicesLen(layer,1) = ...
                sttStr.inactiveArrayIndicesLen(layer,1)-1;
        end

        % deep copy
        arrayPtrLLR{layer,s2} = arrayPtrLLR{layer,s};
        arrayPtrC{layer,s2} = arrayPtrC{layer,s};

        sttStr.arrayReferenceCount(layer,s) = ...
            sttStr.arrayReferenceCount(layer,s)-1;
        sttStr.arrayReferenceCount(layer,s2) = 1;
        sttStr.pathIdxToArrayIdx(layer,pathIdx) = s2;
    end

end

function [s2, sttStr, arrayPtrLLR, arrayPtrC] = getArrayPtrC(sttStr, ...
    arrayPtrLLR, arrayPtrC, layer, pathIdx)
    % Input:
    %   layer:   layer lambda, 1-based, 1:m+1
    %   pathIdx: path index l, 1-based, 1:L
    % Output:
    %   ptrC: corresponding pathIdx for same layer

    s = sttStr.pathIdxToArrayIdx(layer,pathIdx);
    if sttStr.arrayReferenceCount(layer,s)==1
        s2 = s;
    else
        s2 = sttStr.inactiveArrayIndices(layer, ...
            sttStr.inactiveArrayIndicesLen(layer,1));
        if sttStr.inactiveArrayIndicesLen(layer,1) > 1
            sttStr.inactiveArrayIndicesLen(layer,1) = ...
                sttStr.inactiveArrayIndicesLen(layer,1)-1;
        end

        % deep copy
        arrayPtrC{layer,s2} = arrayPtrC{layer,s};
        arrayPtrLLR{layer,s2} = arrayPtrLLR{layer,s};

        sttStr.arrayReferenceCount(layer,s) = ...
            sttStr.arrayReferenceCount(layer,s)-1;
        sttStr.arrayReferenceCount(layer,s2) = 1;
        sttStr.pathIdxToArrayIdx(layer,pathIdx) = s2;
    end

end