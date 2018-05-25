function [changes,IDGEE,GoldGEE,TimesGEE,XGEE ] = FilteringCrossWindAndLabeling(IDGEEOrig,GoldGEEOrig, TimesGEEOrig, XGEEOrig )
% removing the windows that cross the creatinine measurements
% Labels each window based on the next nearest creatinine measurement
% Fixing timeGEE to be from admission not first UO meas.


%% Loading data, 
global icuintimes data urineDataChosen;
load('matData\creatinineTruncLabel.mat');

TimeThresholdRange = [2,4,6,8,10,12,14,16,18,20,22,24]; % remove this when connect to main function; and make global
% Make a copy of GEE variables
IDGEE = IDGEEOrig;
GoldGEE = GoldGEEOrig;
TimesGEE = TimesGEEOrig;
XGEE = XGEEOrig;

for windowLenIndx = 1:12
    % Remove NaNs: They were there to initialize the cell arrays, but
    % overshot.
    indxToRemove = find(isnan(IDGEE{windowLenIndx}));
    IDGEE{windowLenIndx}(indxToRemove,:) = [];
    GoldGEE{windowLenIndx}(indxToRemove,:) = [];
    TimesGEE{windowLenIndx}(indxToRemove,:) = [];
    XGEE{windowLenIndx}(indxToRemove,:) = [];
    
    % Get unique ICU IDs from windows to not take more time than needed
    ICUIDsUniqueFromIDGEE =  unique(IDGEE{windowLenIndx});
    
    WindowLength = TimeThresholdRange(windowLenIndx);
    
    for k = 1: length(ICUIDsUniqueFromIDGEE);
        if mod(k,1000) ==0
            k
        end
        % ICU ID
        IcuID = ICUIDsUniqueFromIDGEE(k);
        
        % Get icuin time: proper format
        INDX_inTime = find(icuintimes.ICUSTAY_ID == IcuID);
        IN_Time = icuintimes.ICUSTAY_INTIME(INDX_inTime);
        IN_Time_FORM = datevec(IN_Time,1915);
        
        % get the first UO measurement.
        FoundICUIdxs = find(urineDataChosen.ICUSTAY_ID == IcuID ) ;% it is updated with truncations
        Subdata = urineDataChosen(FoundICUIdxs,:);
        
        timeUnformated = Subdata(:,3);
        timeUnformatedCell = dataset2cell(timeUnformated);
        timeUnformatedCell = timeUnformatedCell(2:end);
        firstUOForm = datevec(timeUnformatedCell(1),1915);
        
        % Get time difference between first UO measurement and ICU in
        % time
        
        timeDiff = etime(firstUOForm,IN_Time_FORM);
        
        % Find indices for ICU ID
        
        GEEIndx  = find(IDGEE{windowLenIndx} == IcuID);
        
        % Change timesGEE from being from first UO to ICUstay in time.
        
        timeGEE_ICUID = TimesGEE{windowLenIndx}(GEEIndx);
        timeGEE_ICUID_fixed = timeGEE_ICUID + timeDiff; % timeNow = timeR - first;
        % timeFixed = timeNow + first - icu = timeNow+ time diff
        TimesGEE{windowLenIndx}(GEEIndx)= timeGEE_ICUID_fixed;
        
        
        % Find the creatinine measurements in creatinineTruncLabel and
        % format the dates
        
        FoundICUIdxsCr = find(creatinineTruncLabel.ICUSTAY_ID == IcuID ) ;
        SubdataCr = creatinineTruncLabel(FoundICUIdxsCr,:);
        
        timeUnformatedCr = SubdataCr(:,3);
        timeUnformatedCellCr = dataset2cell(timeUnformatedCr);
        timeUnformatedCellCr = timeUnformatedCellCr(2:end);
        DateVectsCr= datevec(timeUnformatedCellCr,1915);
        % if one or more measurement
        if ~isempty(DateVectsCr)
            
            % Make the creatinine measurement times from icuin time
            relTimesCr_ICUIN = NaN*ones(size(DateVectsCr,1),1);
            for i = 1:size(DateVectsCr,1)
                relTimesCr_ICUIN(i,1) = etime(DateVectsCr(i,:),IN_Time_FORM); % seconds integer numbers indices of times
            end
            
            % prepend 0 to relTimesCr_ICUIN
            relTimesCr_ICUIN = [0;relTimesCr_ICUIN];
            
            % for each creatinine measurement:
            toRemove = []; % new for each ICU ID; prevent shift when unbalanced
            for crTimeIdx = 2: length(relTimesCr_ICUIN)
                % get the label
                crLabel = SubdataCr.Label(crTimeIdx-1);
                % find the windows (using start time) between it and the
                % one before it
                indxbetweenCr = find(timeGEE_ICUID_fixed >= relTimesCr_ICUIN(crTimeIdx-1) & timeGEE_ICUID_fixed< relTimesCr_ICUIN(crTimeIdx)); % not GEE index!!!
                
                if ~isempty(indxbetweenCr)
                % If start + window length > creatinine measurement time:
                WindowsCrossingIndx = find((timeGEE_ICUID_fixed(indxbetweenCr) + WindowLength*3600) > relTimesCr_ICUIN(crTimeIdx));
                
                
                % mark to remove using GEE indx (!!!!)
                toremoveCr = GEEIndx(indxbetweenCr(WindowsCrossingIndx));
                toRemove = [toRemove;toremoveCr]; % too many layers of indices
                
                % Not to remove but relabel
                toLabel = setdiff(GEEIndx,toremoveCr); % in GEE indexing
                
                % relabel
                GoldGEE{windowLenIndx}(toLabel) = crLabel;
                
                end
            end
            % Find the windows (start time) > last creatinine measurement
            
            indxAfterLastCr = find(timeGEE_ICUID_fixed >= relTimesCr_ICUIN(end));
            toRemove = [toRemove;GEEIndx(indxAfterLastCr)];
            
            % delete them and others.
            
            IDGEE{windowLenIndx}(toRemove,:) = [];
            GoldGEE{windowLenIndx}(toRemove,:) = [];
            TimesGEE{windowLenIndx}(toRemove,:) = [];
            XGEE{windowLenIndx}(toRemove,:) = [];
            
        else % if cr meas is empty: delete all the related GEE data
            %
            IDGEE{windowLenIndx}(GEEIndx,:) = [];
            GoldGEE{windowLenIndx}(GEEIndx,:) = [];
            TimesGEE{windowLenIndx}(GEEIndx,:) = [];
            XGEE{windowLenIndx}(GEEIndx,:) = [];
            
        end
        
    end
    
   %save('GEEVars_ noCrossingWindoes.mat','IDGEE','GoldGEE','TimesGEE','XGEE');
   %save('GEEVars_ Orig.mat','IDGEEOrig','GoldGEEOrig','TimesGEEOrig','XGEEOrig');
   
   % Print how much was removed. Total number of instances. Unique ICU IDs
   changes = NaN*ones(4,12);
   for windowLenIndx = 1:12
       indxToRemove = find(isnan(IDGEEOrig{windowLenIndx}));
       IDGEEOrig{windowLenIndx}(indxToRemove,:) = [];
       GoldGEEOrig{windowLenIndx}(indxToRemove,:) = [];
       TimesGEEOrig{windowLenIndx}(indxToRemove,:) = [];
       XGEEOrig{windowLenIndx}(indxToRemove,:) = [];
       
       changes(1,windowLenIndx) = length(IDGEE{windowLenIndx});
       changes(2,windowLenIndx) = length(IDGEEOrig{windowLenIndx});
       
       
       changes(3,windowLenIndx) = length(unique(IDGEE{windowLenIndx}));
       changes(4,windowLenIndx) = length(unique(IDGEEOrig{windowLenIndx}));
   end
   %save('changes.mat','changes');
end


end
