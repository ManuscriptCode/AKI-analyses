function [TF, TimeNormalized_SUMUO6,timediff] = IsUOFirst6HrsMeetingCutoff( Subdata, MaxWeightValue, ICUID )

global count countlength countTimes;
a = Subdata(:,3);
b = dataset2cell(a);
c = b(2:end);

Dates = c;%ConvertToCell(Subdata,3,:);
DateVects= datevec(Dates,1915);% added this 140126
Times = zeros(size(DateVects,1),1);

for i = 1:size(DateVects,1)
    Times(i,1) = etime(DateVects(i,:),DateVects(1,:)); % seconds integer numbers indices of times
end

% Times is in seconds
if length(Times)>= 4 % need to have atleast 4 measurements total.
    diffTimes = diff(Times)/3600; % difference between each time point and the previous starting from the second.
    
    StartTime = 0;%3600;
    CutOff6hrs= StartTime + 6*3600;
    
    % indices of times that fall within the time frames
    indices6 = find ((StartTime <= Times) & (Times <= CutOff6hrs) );% changed from < to <=: 14/01/13
    
    a = Subdata(:,4);
    b = dataset2cell(a);
    c = b(2:end);
    
    UO= c;%ConvertToCell(Subdata,4,:);%volumes
    
    UOmat = cell2mat(UO);
    UOmatNormalized = UOmat /MaxWeightValue; % all hours
    
    UOmatNormalizedWithTime = UOmatNormalized(2: end)./diffTimes;% per hour
    
    UOmatNormalized6Hours = UOmatNormalized(indices6); % first 6 hours normalized with weight only
    
    
    %% Method: Check that the average is >= 0.5, edge case is taken care of.
    
    SUMUO6 = nansum(UOmatNormalized6Hours(2:end)); %  ignoring first measurement.
    
    % check if there is a measurement after the first 6 hours. Then do
    % division. If there is no measurement after the first 6 hours, return NaN.
    
    if (Times(indices6(end)) < CutOff6hrs)  % because if = then don't need to do division.
        if ( (indices6(end)) < length(UOmatNormalized) ) % is there another measurement after the six hour cutoff
            
            VolumeNextMeasurement = UOmatNormalized(indices6(end) +1);
            TimeLastMeasurementIn6hours = Times(indices6(end));
            TimeNextMeasurement = Times(indices6(end)+1);
            timediff = TimeNextMeasurement - CutOff6hrs;
            Ratio =  (CutOff6hrs - TimeLastMeasurementIn6hours)/(TimeNextMeasurement-TimeLastMeasurementIn6hours);
            
            VolumeDivided = Ratio*VolumeNextMeasurement;
            
            SUMUO6 = nansum([SUMUO6, VolumeDivided]);
            
            
            % I am not overestimating the UO here because it should use up the full amount of the second measurement
        else timediff = NaN;count = count +1;SUMUO6 = NaN; % no other 
        end
        
    else timediff =0; countTimes = countTimes +1;
    end
    
    
    TimeNormalized_SUMUO6 = SUMUO6 / 6;
       
    if isnan(TimeNormalized_SUMUO6)
        TF = NaN;
        
    elseif TimeNormalized_SUMUO6 >= 0.5
        TF = 0;
    else TF = 1;
    end
    
    
else TF = NaN; TimeNormalized_SUMUO6 = NaN; timediff=NaN; countlength = countlength+1;
end

end
