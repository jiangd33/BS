function [pathIdx, sttStr] = assignInitialPath(sttStr)
    % Output:
    %   pathIdx: initial path index l, 1-based, 1:L

    pathIdx = sttStr.inactivePathIndices(sttStr.inactivePathIndicesLen,1);
    sttStr.inactivePathIndicesLen = sttStr.inactivePathIndicesLen-1;
    sttStr.activePath(pathIdx) = true;

    % Associate arrays with path index
    for layer = 1:sttStr.m+1
        s = sttStr.inactiveArrayIndices(layer, ...
            sttStr.inactiveArrayIndicesLen(layer));
        sttStr.inactiveArrayIndicesLen(layer) = ...
            sttStr.inactiveArrayIndicesLen(layer)-1;

        sttStr.pathIdxToArrayIdx(layer,pathIdx) = s;
        sttStr.arrayReferenceCount(layer,pathIdx) = 1;
    end

end