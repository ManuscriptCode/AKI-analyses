function [ urinedataNonNaNCommonTrunc ] = TruncatingUOData()
% For patients with AKI: truncate after the time they had it.
% For patients without AKI: truncate after the first 48 hours.(To not have
% any bias towards non-AKI patients)
global data icuintimes urinedataNonNaNCommon;

% Create copy of urinedataNonNaNCommon.
urinedataNonNaNCommonTrunc = urinedataNonNaNCommon;
AllRows = 1: size(data,1);
ICUSTAY_ID_COL = cell2mat(ConvertToCell(data, 2,AllRows)); %% all ICU IDs not only good ones


n = 1;
for IcuID = ICUSTAY_ID_COL'
    
    FoundICUIdxs = find(urinedataNonNaNCommonTrunc.ICUSTAY_ID == IcuID ) ;% it is updated with truncations
    INDX_inTime = find(icuintimes.ICUSTAY_ID == IcuID);
    
    if(( ~isempty(FoundICUIdxs))&&(~isempty(INDX_inTime))) % has both urine data and in time
        
        % Get the ICU in time in proper format
        
        IN_Time = icuintimes.ICUSTAY_INTIME(INDX_inTime);
        IN_Time_FORM = datevec(IN_Time,1915);
        
        
        % Get ICU stay times
        Subdata = urinedataNonNaNCommonTrunc(FoundICUIdxs,:);
        
        timeUnformated = Subdata(:,3);
        timeUnformatedCell = dataset2cell(timeUnformated);
        timeUnformatedCell = timeUnformatedCell(2:end);
        DateVectsUO= datevec(timeUnformatedCell,1915);
        
        % convert DateVectsUO to be relative to IN_Time_FORM
        
        relTimesUO = zeros(size(DateVectsUO,1),1); % from admittance to ICU in seconds
        
        
        for i = 1:size(DateVectsUO,1)
            relTimesUO(i,1) = etime(DateVectsUO(i,:),IN_Time_FORM); % seconds integer numbers indices of times
        end
        
        if isnan(data.AKICrNew(n))
        
            'NaN'
        elseif data.AKICrNew(n)== 0 % No AKI based on first 48 hours
            % truncate after the first 48 hours
            
            ToKeepUOindices = find((0 <= relTimesUO )&( relTimesUO<= 48*3600));
            ToRemoveUOindices = setdiff(1:length(FoundICUIdxs),ToKeepUOindices);
            ToRemoveUOOriginalIndices = FoundICUIdxs(ToRemoveUOindices);
            
            % removing from urinedataNonNaNCommonTrunc
            urinedataNonNaNCommonTrunc(ToRemoveUOOriginalIndices,:) = [];
            
        elseif data.AKICrNew(n)== 1 % Has AKI based on first 48 hours
            % truncate after AKICrTruncTime
            TruncTimeStr = data.AKICrTruncTime(n);
            if iscell(TruncTimeStr)
                TruncTimeStr = TruncTimeStr{1};
            end
            
            DateTruncTime= datevec(TruncTimeStr,1915);
            % TruncTime relative to in time in seconds
            relTruncTime = etime(DateTruncTime,IN_Time_FORM);
            
            ToKeepUOindices = find((0 <= relTimesUO )&( relTimesUO<= relTruncTime));
            ToRemoveUOindices = setdiff(1:length(FoundICUIdxs),ToKeepUOindices);
            ToRemoveUOOriginalIndices = FoundICUIdxs(ToRemoveUOindices);
            
            % removing from urinedataNonNaNCommonTrunc
            urinedataNonNaNCommonTrunc(ToRemoveUOOriginalIndices,:) = [];
            
        end
        
    end
    n = n+1;
end


end

