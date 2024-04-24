function sttStr = killPath(sttStr, pathIdx)
    % Input:
    %   pathIdx: path index to kill, l, 1-based, 1:L

    % Mark path pathIdx as inactive
    sttStr.activePath(pathIdx) = false;
    sttStr.inactivePathIndicesLen = sttStr.inactivePathIndicesLen+1;
    sttStr.inactivePathIndices(sttStr.inactivePathIndicesLen,1) = pathIdx;
    sttStr.llrPathMetric(pathIdx) = 0;

    % Disassociate arrays with path Idx
    for layer = 1:sttStr.m+1
        s = sttStr.pathIdxToArrayIdx(layer,pathIdx);
        sttStr.arrayReferenceCount(layer,s) = ...
            sttStr.arrayReferenceCount(layer,s)-1;

        if sttStr.arrayReferenceCount(layer,s)==0
            if sttStr.inactiveArrayIndicesLen(layer,1) < sttStr.L
                sttStr.inactiveArrayIndicesLen(layer,1) = ...
                    sttStr.inactiveArrayIndicesLen(layer,1)+1;
            end
            sttStr.inactiveArrayIndices(layer, ...
                sttStr.inactiveArrayIndicesLen(layer,1)) = s;
        end
    end

end
