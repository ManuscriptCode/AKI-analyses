function [AKIcrList, TimesList, FirstCr] = ComputingAKICr2()
%% need: min creatinine level, icustay_INTIME, For each of the ICUIDs(
% not only included ones because will need to filter again based on AKIcr if
% null or not. Otherwise will ruin indicization.

global data icuintimes creatinine;
ICUSTAYIDS = data.ICUSTAY_ID;
AKIcrList = NaN*ones(length(ICUSTAYIDS),1);
TimesList = cell(length(ICUSTAYIDS),1);
FirstCr = NaN*ones(length(ICUSTAYIDS),1); % just temp; remove after updated data.FirstCr

n = 1;
for icu_id = ICUSTAYIDS'
    
    INDX = find(icuintimes.ICUSTAY_ID == icu_id);
    IN_Time = icuintimes.ICUSTAY_INTIME(INDX);
    IN_Time_FORM = datevec(IN_Time,1915);
    
    % getting the creatinine data
    CreatinineDataINDX = find(creatinine.ICUSTAY_ID == icu_id);
    CreatinineData = creatinine(CreatinineDataINDX,:);
    timeUnformated = CreatinineData(:,3);
    timeUnformatedCell = dataset2cell(timeUnformated);
    timeUnformatedCell = timeUnformatedCell(2:end);
    DateVectsCr= datevec(timeUnformatedCell,1915);
    
    TimesCr = zeros(size(DateVectsCr,1),1); % from admittance to ICU
    
    
    for i = 1:size(DateVectsCr,1)
        TimesCr(i,1) = etime(DateVectsCr(i,:),IN_Time_FORM); % seconds integer numbers indices of times
    end
    
    % get minimum creatinine over the entire hospital stay.
    indxData = find(data.ICUSTAY_ID == icu_id);
    minCr = data.MIN_CR_PER_HOSP_ADM(indxData);
    
    
    % Obtaining the creatinine measurements that are within the first 48
    % hours
    
    Within48INDX = find((0<= TimesCr) & (TimesCr<= 48 * 3600)); % Changed this 150124
    
    % Get first Cr value (temp, comment out after update data.FirstCR)
    firstCrVal = NaN;
    if ~isempty(Within48INDX)
        firstCrVal = CreatinineData.VALUENUM(Within48INDX(1));
    end
    % max creatinine value within the first 48 hours
    
    %max48 = nanmax(CreatinineData.valuenum(Within48INDX));
    
    
    
    increaseFromMin = CreatinineData.VALUENUM(Within48INDX) - minCr;
    
    percentinc = 100* (CreatinineData.VALUENUM(Within48INDX) - minCr)/minCr;
    
    % checking first definition >= 0.3 increase in value from hospital min
    increaseFromMinMet = increaseFromMin >= 0.3;
    % Is there any measurement that met the first definition in the first
    % 48 hours? If so, extract the charttime.
    INDincreaseFromMinMet = find(increaseFromMinMet ==1);
    if ~isempty(INDincreaseFromMinMet) % met
        % need to convert back to original indices
        origINDX = Within48INDX(INDincreaseFromMinMet(1));
        increaseFromMinMetChartTime = timeUnformated.CHARTTIME{origINDX};
        
    end
    
    
    % checking second definition >= 50% increase from hospital min
    
    percentincMet = percentinc>= 50;
    
    
    % Is there any measurement that met the second definition in the first
    % 48 hours? If so, extract the charttime.
    
    INDpercentincMet = find(percentincMet ==1);
    if ~isempty(INDpercentincMet) % met
        % need to convert back to original indices
        percentincMetChartTime = timeUnformated.CHARTTIME(Within48INDX(INDpercentincMet(1)));
        
    end
    
    
    % using the first time that either definitions were met.
    if (isempty(increaseFromMinMet) || isempty(percentincMet)) % no data
        AKIcr = NaN; time = NaN;
        
    elseif (~isempty(INDincreaseFromMinMet)) &&(~isempty(INDpercentincMet))
        AKIcr = 1;
        
        if INDpercentincMet(1) < INDincreaseFromMinMet(1)
            time = percentincMetChartTime;
        else
            time = increaseFromMinMetChartTime;
        end
        
    elseif (~isempty(INDincreaseFromMinMet))
        AKIcr = 1;  time = percentincMetChartTime;
        
    elseif  (~isempty(INDpercentincMet))
        AKIcr = 1;
        time = percentincMetChartTime;
        
        
        
    else %((increaseFromMin < 0.3) && (percentinc < 50)) % has data but not met
        AKIcr = 0;time = NaN;
        
        
    end
    
    AKIcrList(n) = AKIcr;
    TimesList{n} = time;
    FirstCr(n) = firstCrVal;
    n = n+1;
    
    
end





end



