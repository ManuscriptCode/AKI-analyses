function [ median1HrBefore ] = ComputeAvgMAP1hrPrior(IcuID, StartTime, firstTimeStr)

global MAPCommonFixed;

rows = find( MAPCommonFixed.ITEMID == 52  &  MAPCommonFixed.ICUSTAY_ID == IcuID);
if isnan(rows)
    % try the other itemid, doing this because we don't want to mix two
    % informations together. What if the patient had both invasive and
    % non-invasive measurements
    rows = find( MAPCommonFixed.ITEMID == 456  &  MAPCommonFixed.ICUSTAY_ID == IcuID);
    
    
end

median1HrBefore = NaN;
if (~isnan(StartTime)) && (~isempty(rows))  % if doesn't have data in both itemids
    
    Dates = MAPCommonFixed.CHARTTIME(rows);
    DateVects= datevec(Dates,1915);
    
    Times = zeros(size(DateVects,1),1);
    
    DateVectFirstTime = datevec(firstTimeStr,1915);
    
    for i = 1:size(DateVects,1)
        Times(i,1) = etime(DateVects(i,:),DateVectFirstTime); % seconds integer numbers indices of times
    end
    
    Volumes = MAPCommonFixed.VALUE1NUM(rows);
    
    % median1HrBefore the volumes with times that are before StartTimeBelowThresholdStr
    % or until maximum of three hours before 
   
    %rowsOfTimeBefore = find((Times <= StartTime) & (Times >= (StartTime-3600)));
    
    for hrs = 1:3
        rowsOfTimeBefore = find((Times <= StartTime) & (Times >= (StartTime-hrs*3600)));
        if ~isempty(rowsOfTimeBefore)
            median1HrBefore = nanmedian(Volumes(rowsOfTimeBefore));
            
            break
        end
    end
    
%     if ~isempty(rowsOfTimeBefore)
%                 median1HrBefore = nanmedian(Volumes(rowsOfTimeBefore));
% 
%     end
    
end


end

