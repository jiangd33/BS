function candidates = pdcch_getAllCCEIndexes(numCCEs,rnti,slotNum)
% For all candidates, return the CCE indexes (L-sized).
% Slot based, not per monitored occasion in a slot (assume only one per SS)

    nCI = 0;   % Assumes nCI = 0 (carrier indicator field)
%     numCCEs = double(crstCfg.Duration)*sum(crstCfg.FrequencyResources);

    
    SearchSpaceType = 'ue';
    CORESETID = 1;
    Yp = pdcch_getYp(SearchSpaceType,CORESETID,rnti,slotNum);

    % Determine candidates for each aggregation level
    aggLvls = [1 2 4 8 16];
    NumCandidates = [8 8 4 2 1];
    candidates = cell(5,1);
    for i = 1:5 % for AL {1,2,4,8,16}
        MsAL = NumCandidates(i);
        L = aggLvls(i);

        % Store column-wise CCEIndices for each candidate
        cceIdx = zeros(L,MsAL);
        for ms = 0:MsAL-1
            for idx = 0:L-1
                cceIdx(idx+1,ms+1) = L*( mod(Yp + floor(double(ms*numCCEs)/double(L*MsAL)) + nCI, ...
                    floor(numCCEs/L)) ) + idx;
            end
        end
        candidates{i} = cceIdx;
    end
end
