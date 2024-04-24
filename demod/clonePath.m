function [clPathIdx, sttStr] = clonePath(sttStr, pathIdx)
    % Input:
    %   pathIdx: path index to clone, l, 1-based, 1:L
    % Output:
    %   clPathIdx: cloned path index, l', 1-based

    clPathIdx = sttStr.inactivePathIndices(sttStr.inactivePathIndicesLen,1);
    sttStr.inactivePathIndicesLen = sttStr.inactivePathIndicesLen-1;
    sttStr.activePath(clPathIdx) = true;
    sttStr.llrPathMetric(clPathIdx) = sttStr.llrPathMetric(pathIdx);

    % Make clPathIdx (l') reference same arrays as pathIdx (l)
    for layer = 1:sttStr.m+1
        s = sttStr.pathIdxToArrayIdx(layer,pathIdx);

        sttStr.pathIdxToArrayIdx(layer,clPathIdx) = s;
        sttStr.arrayReferenceCount(layer,s) = ...
            sttStr.arrayReferenceCount(layer,s)+1;
    end

end

