function [ Sum ] = ComputeTotalFluidPrior( IcuID, StartTime, firstTimeStr)
% A general function that computes  bi
global totalBalCommonFixed;

rows = find(totalBalCommonFixed.ICUSTAY_ID == IcuID);
Sum = NaN;


if (~isnan(StartTime)) && (~isempty(rows))
    firstRow = rows(1);
    
    Dates = totalBalCommonFixed.CHARTTIME(rows);
    DateVects= datevec(Dates,1915);
    
    Times = zeros(size(DateVects,1),1);
    
    DateVectFirstTime = datevec(firstTimeStr,1915);
    
    for i = 1:size(DateVects,1)
        Times(i,1) = etime(DateVects(i,:),DateVectFirstTime); % seconds integer numbers indices of times
    end
    
    Volumes = totalBalCommonFixed.CUMVOLUME(rows);
    
    % sum the volumes with times that are before StartTimeBelowThresholdStr
    rowsOfTimeBefore = find(Times <= StartTime);
    if ~isempty(rowsOfTimeBefore)
        Sum = sum(Volumes(rowsOfTimeBefore));
        
        % add up part of the day for
        nextMeasurementIndex = rowsOfTimeBefore(end)+ 1;
        % check if another measurement actually exists
        if find(rows == nextMeasurementIndex + firstRow -1)> 0
            nextMeasurement = Volumes(nextMeasurementIndex);
            
            ratio = abs(Times(rowsOfTimeBefore(end))) / ( abs(Times(rowsOfTimeBefore(end)))  + Times(nextMeasurementIndex));
            Sum = Sum + ratio* nextMeasurement;
            
        end
    end
end


end

