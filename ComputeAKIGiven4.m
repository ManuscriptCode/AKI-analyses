function [AKIUOCurrentdefPerCombfinalList,minVol, startTimeMin,  firstTimeStr,lastTimeStr, AKIUOCurrentdefPerCombListVol, StartTimes ] =  ComputeAKIGiven4( Subdata,TimeThreshold, FirstWeightValue)
%% removed StartTimeBelowThresholdList from output

%% fixing the overestimation of avg UO and extracting the start time of each window from the first measurement
% changing to go through all windows and return minimum value and compare
% min value to volume threshold. Going through mutliple values of volume
% thresholds to save time otherwise would take ~ 4-5 days to run.

global AvgVolumeThresholdRange;

AKIUOCurrentdefPerCombfinalList = NaN*ones(length(AvgVolumeThresholdRange),1);
StartTimeBelowThresholdList = NaN*ones(length(AvgVolumeThresholdRange),1);
% Times
a = Subdata(:,3);
b = dataset2cell(a);
c = b(2:end);

Dates = c; %ConvertToCell(Subdata,3,:);
DateVects= datevec(Dates,1915);% added this
Times = zeros(size(DateVects,1),1);

firstTimeStr = Dates{1};
lastTimeStr = Dates{end};

for i = 1:size(DateVects,1)
    Times(i,1) = etime(DateVects(i,:),DateVects(1,:)); % seconds integer numbers indices of times
end


% Volumes
a = Subdata(:,4);
b = dataset2cell(a);
c = b(2:end); 
UO= c;%ConvertToCell(Subdata,4,:);%volumes
UOmat = cell2mat(UO);
UOmatNormalized = UOmat/FirstWeightValue; % all hours. Weight normalized.

AKIUOCurrentdefPerCombfinal = NaN;minVol = NaN; startTimeMin = NaN; StartTimeBelowThreshold = NaN;% defaults in case if ((Times(end) - TimeThreshold*3600 )>=0) is false
AKIUOCurrentdefPerCombListVol  = []; StartTimes = [];
if ((Times(end) - TimeThreshold*3600 )>=0) % it was >.
%     AKIUOCurrentdefPerCombListVol  = [];
%     StartTimes = [];
    for StartTime = 0 : 3600: Times(end) - TimeThreshold*3600 % in seconds
            
        CutOffTime= StartTime + TimeThreshold*3600;
        
        % indices of times that fall within the time frames
        indicesT = find ((StartTime < Times) & (Times <= CutOffTime) );% changed this in ver 140126; %this is what was producing the 3 NaNs
             % By having it (StartTime < Times) we are ignoring the first
             % measurement
                                                                     
                                                                       
        
        if length(indicesT)>0%~isempty(indicesT) % used to consider also the first number that is why
            
            UOmatNormalizedTHours = UOmatNormalized(indicesT); % first 6 hours normalized with weight only
            
                        
            SUMUOT = nansum(UOmatNormalizedTHours(2:end)); % changed from 1: end to 2 to end because we should not use the full amount of the first measurement
            % it will give an empty matrix if there is only one measurement
            
            % check if there is a measurement after the first T hours. Then do
            % division. If there is no measurement after the first T hours, return NaN.
            
            % flipped the two if statements
            if (Times(indicesT(end)) < CutOffTime)  % because if = then don't need to do division.
                if ( (indicesT(end)) < length(UOmatNormalized) ) % was (indicesT(end) +1) % is there another measurement after the cutoff
                    
                    VolumeNextMeasurement = UOmatNormalized(indicesT(end) +1);
                    TimeLastMeasurementInThours = Times(indicesT(end));
                    TimeNextMeasurement = Times(indicesT(end)+1);
                    Ratio =  (CutOffTime - TimeLastMeasurementInThours)/(TimeNextMeasurement-TimeLastMeasurementInThours);
                    
                    VolumeDivided = Ratio*VolumeNextMeasurement;
                    
                    SUMUOT = nansum([SUMUOT, VolumeDivided]);
                    
                else 'here';%SUMUOT = NaN; %count = count +1;% if the last measurement was before the cutoff time and there wasn't any measurement after it.
                end
                
            end
            
            %% Taking care of first measurement in window.
            % Time of first measurement
            TimeFirstMeasInWindow = Times(indicesT(1)); % Time of first measurement in window from first measurement 
            VolFirstMeasInWondow = UOmatNormalized(indicesT(1));
            if ( (indicesT(1)) > 1 ) % Is there a measurement before it?
                % Time of measurement before it
                TimeMeasBeforeFirstInWindow = Times(indicesT(1)-1);
                
                Ratio = (TimeFirstMeasInWindow -  StartTime)/(TimeFirstMeasInWindow -TimeMeasBeforeFirstInWindow);
                    
                SUMUOT = nansum([SUMUOT, Ratio*VolFirstMeasInWondow]);
                               
                
            elseif (indicesT(1) == 1) 
                'This shouldnt happen'
            end
                
            % if it is the first measurement (after excluding the first
            % measurement then use (0, startTime, Times(index)) 
            
            % if there is a measurement before, use (Times(pervious), startTime, Times(index))
            
            
            
            
            TimeNormalizedUO = SUMUOT/TimeThreshold;
        
            
            AKIUOCurrentdefPerCombListVol = [AKIUOCurrentdefPerCombListVol,TimeNormalizedUO];
            StartTimes =  [StartTimes, StartTime];
            
            
         
        end
    end
    %AKIUOCurrentdefPerCombfinal = nanmax(AKIUOCurrentdefPerCombListVol); %% getting the max to catch if AKI in any window...
    'AKIUOCurrentdefPerCombListVol';
    AKIUOCurrentdefPerCombListVol;
    
    [minVol, minIndx] = nanmin(AKIUOCurrentdefPerCombListVol);
    startTimeMin = StartTimes(minIndx);
    
    for h = 1: length(AvgVolumeThresholdRange)
        AvgVolumeThreshold = AvgVolumeThresholdRange(h);
        
        belowIndxs = find(AKIUOCurrentdefPerCombListVol <= AvgVolumeThreshold);
        if isempty(belowIndxs)
            StartTimeBelowThreshold = NaN;
            
        else
            
            StartTimeBelowThreshold = StartTimes(belowIndxs(1));
        end
        
        
        if minVol <= AvgVolumeThreshold
            AKIUOCurrentdefPerCombfinal = 1;
            
        end
        
        if minVol > AvgVolumeThreshold
            AKIUOCurrentdefPerCombfinal = 0;
        end
        
        if isempty(minVol)
            minVol = NaN; startTimeMin = NaN;
            AKIUOCurrentdefPerCombfinal = NaN;
        end
        
        if isnan(minVol)
            AKIUOCurrentdefPerCombfinal = NaN;
        end
        
        AKIUOCurrentdefPerCombfinalList(h) = AKIUOCurrentdefPerCombfinal;
        StartTimeBelowThresholdList(h) = StartTimeBelowThreshold;
    end
    
    
end





end
