function [] = TruncateLabelCreatinineMeas()

% Truncates the creatinine data to only include measurements between
% icustay in and 48 hours after (if no AKI).
%If AKI truncate till after the measurement with AKI before 48 hours.
% Then labels each measurements


global icuintimes data creatinine;
%
% load('icuintimes.mat');
% load('DataSetAllFirstCrMaxWeightNoReptCommonHeightWeightsCathsBoth.mat');
% load('creatinine.mat');

% Create a copy of creatinine and only modify that
creatinineTruncLabel = creatinine;
% Adding new field "Label"
creatinineTruncLabel.Label = NaN*ones(size(creatinineTruncLabel,1),1);

ICUSTAY_ID_COL = data.ICUSTAY_ID;



for k = 1: length(ICUSTAY_ID_COL)
    if mod(k,10000) ==0  % Just to know how much more time is left
        k
    end
    
    IcuID = ICUSTAY_ID_COL(k);
    
    FoundICUIdxs = find(creatinineTruncLabel.ICUSTAY_ID == IcuID ) ;
    INDX_inTime = find(icuintimes.ICUSTAY_ID == IcuID);
    
    if(( ~isempty(FoundICUIdxs))&&(~isempty(INDX_inTime))) % has both urine data and in time
        
        % Get the ICU in time in proper format
        
        IN_Time = icuintimes.ICUSTAY_INTIME(INDX_inTime);
        IN_Time_FORM = datevec(IN_Time,1915);
        
        % Get creatinine measurement times
        Subdata = creatinineTruncLabel(FoundICUIdxs,:);
        
        timeUnformated = Subdata(:,3);
        timeUnformatedCell = dataset2cell(timeUnformated);
        timeUnformatedCell = timeUnformatedCell(2:end);
        DateVectsCr= datevec(timeUnformatedCell,1915);
        
        % convert DateVectsCr to be relative to IN_Time_FORM
        
        relTimesCr = zeros(size(DateVectsCr,1),1); % from admittance to ICU in seconds
        
        
        for i = 1:size(DateVectsCr,1)
            relTimesCr(i,1) = etime(DateVectsCr(i,:),IN_Time_FORM); % seconds integer numbers indices of times
        end
        
        
        
        % maybe put if statement here if data.AKICrNew(n) = NaN
        if isnan(data.AKICrNew(k)) && isempty(DateVectsCr)
            continue;
            % don't do anything
            
            % what if  isnan(data.AKICrNew(n)) == 1, but
            % isempty(DateVectsCr)==0? check later
            %elseif relTimesCr(1)<0% if first cr measurement was before ICU stay in remove all data
            %creatinineTruncLabel(FoundICUIdxs,:) = [];
            
            % for the ones with first creatinine measurement before admission,
            % just remove the part that is before.
            
        elseif data.AKICrNew(k)== 0 % No AKI based on first 48 hours
            % Label all as AKI = 0;
            
            creatinineTruncLabel.Label(FoundICUIdxs) = zeros(length(FoundICUIdxs),1);
            
            % truncate after the first 48 hours
            
            ToKeepCrindices = find((0 <= relTimesCr )&( relTimesCr<= 48*3600));
            ToRemoveCrindices = setdiff(1:length(FoundICUIdxs),ToKeepCrindices);
            ToRemoveCrOriginalIndices = FoundICUIdxs(ToRemoveCrindices);
            
            % removing from creatinineTruncLabel
            creatinineTruncLabel(ToRemoveCrOriginalIndices,:) = [];
            
        elseif data.AKICrNew(k)== 1 % Has AKI based on first 48 hours
            
            
            % truncate after AKICrTruncTime
            TruncTimeStr = data.AKICrTruncTime(k);
            if iscell(TruncTimeStr)
                TruncTimeStr = TruncTimeStr{1};
            end
            
            
            
            DateTruncTime= datevec(TruncTimeStr,1915);
            % TruncTime relative to in time in seconds
            relTruncTime = etime(DateTruncTime,IN_Time_FORM);
            
            %             if relTruncTime <0
            %                 Count = Count+1;
            %
            %             else
            
            ToKeepCrindices = find((0 <= relTimesCr )&( relTimesCr<= relTruncTime)); % should keep the measurement with AKI= 1
            
            % Label the ToKeepCrindices
            dummy = FoundICUIdxs(ToKeepCrindices);
            creatinineTruncLabel.Label(dummy) = zeros(length(dummy),1);
            
            if ~isempty(dummy)
                creatinineTruncLabel.Label(dummy(end)) = 1; % One with AKI
            end
            
            % remove unwanted
            ToRemoveCrindices = setdiff(1:length(FoundICUIdxs),ToKeepCrindices);
            ToRemoveCrOriginalIndices = FoundICUIdxs(ToRemoveCrindices);
            
            % removing from creatinineTruncLabel
            creatinineTruncLabel(ToRemoveCrOriginalIndices,:) = [];
        end
    end
    
end




% Removing anything with label = NaN
toRemoveIndx = find(isnan(creatinineTruncLabel.Label));
creatinineTruncLabel(toRemoveIndx,:) = [];

save('matData\creatinineTruncLabel.mat','creatinineTruncLabel');


end

