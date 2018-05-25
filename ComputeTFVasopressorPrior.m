function [ TFPressor ] = ComputeTFVasopressorPrior(IcuID, StartTime, firstTimeStr)
global VasopressorsCommonFixed;
TFPressor = NaN;

rows = find(VasopressorsCommonFixed.ICUSTAY_ID == IcuID);

if ~isnan(StartTime)
    if ~isempty(rows)
        firstRow = rows(1);
        
        Dates = VasopressorsCommonFixed.CHARTTIME(rows);
        DateVects= datevec(Dates,1915);
                
        Times = zeros(size(DateVects,1),1);

        DateVectFirstTime = datevec(firstTimeStr,1915);
        
        for i = 1:size(DateVects,1)
            Times(i,1) = etime(DateVects(i,:),DateVectFirstTime); % seconds integer numbers indices of times
        end
        
        Volumes = VasopressorsCommonFixed.DOSE(rows);
        
        % sum the volumes with times that are before StartTimeBelowThresholdStr
        rowsOfTimeBefore = find(Times <= StartTime);
        Sum = sum(Volumes(rowsOfTimeBefore));

        if ~isempty(rowsOfTimeBefore)
            
    
            % add up part of the day for
            nextMeasurementIndex = rowsOfTimeBefore(end)+ 1;
            % check if another measurement actually exists
            if find(rows == nextMeasurementIndex + firstRow -1)> 0
                nextMeasurement = Volumes(nextMeasurementIndex);
                
                ratio = abs(Times(rowsOfTimeBefore(end))) / ( abs(Times(rowsOfTimeBefore(end)))  + Times(nextMeasurementIndex));
                Sum = Sum + ratio* nextMeasurement;
                
            end
        end
        if Sum>0
            TFPressor = true;
            
        else
            TFPressor = false;
            
        end
    else
        TFPressor = false;
        
    end
end

end

