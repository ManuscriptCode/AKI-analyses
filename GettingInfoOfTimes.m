%% Initializing cell of ICUID, ICUstay in, first Cr meas, first UO meas
% all dates are unformatted, because we can't save formatted to cell or mat
% Need to format when using later with datevec(Time,1915);

load('urinedataNonNaNCommon.mat')
urineDataChosen = urinedataNonNaNCommon;%urinedataNonNaNCommonTrunc; urinedataNonNaNCommon;% might remove later

load('DataSetAllFirstCrMaxWeightNoReptCommonHeightWeightsCathsBoth.mat');
data2 = DataSetAllFirstCrMaxWeightNoReptCommonHeightWeightsCathsBoth;
load('icuintimes.mat');
load('creatinine.mat');

ICUSTAYIDS = data2.ICUSTAY_ID;
Times_stay_Cr_UO = cell(length(ICUSTAYIDS),4);
Times_stay_Cr_UO(:,1) = num2cell(ICUSTAYIDS);

n = 1;
for icu_id = ICUSTAYIDS'
    
    %% Get ICUstay in times
    INDX = find(icuintimes.ICUSTAY_ID == icu_id);
    IN_Time = icuintimes.ICUSTAY_INTIME(INDX);
    
    if ~isempty(IN_Time)
        Times_stay_Cr_UO(n,2) = IN_Time;
    end
        
    
    %% Get time of first Cr Measurements
    
    CreatinineDataINDX = find(creatinine.ICUSTAY_ID == icu_id);
    CreatinineData = creatinine(CreatinineDataINDX,:);
    timeUnformated = CreatinineData(:,3);
    
    if ~isempty(timeUnformated)
        Times_stay_Cr_UO(n,3) = timeUnformated.CHARTTIME(1);
    end
    

    %% Get time of first UO meas
    
    UODataINDX = find(urineDataChosen.ICUSTAY_ID == icu_id);
    UOData = urineDataChosen(UODataINDX,:);
    timeUnformatedUO = UOData(:,3);
    
     if ~isempty(timeUnformatedUO)
        Times_stay_Cr_UO(n,4) =  timeUnformatedUO.DAY_HOUR(1);
    end
    
    
    % Increment n
    n = n+1;
end

%% remove all rows that have one empty
%# find empty cells
Times_stay_Cr_UO_temp = Times_stay_Cr_UO;% just in case I mess up.

emptyCells = cellfun(@isempty,Times_stay_Cr_UO);
emptyCells_sim = sum(emptyCells,2)>=1;

%# remove empty cells
Times_stay_Cr_UO(emptyCells_sim,:) = [];

%% Histogram of time diff between all three
timeDiff_ICU_cr_UO = NaN*ones(size(Times_stay_Cr_UO,1),3);
% ICU and cr, ICU and UO, Cr and UO (in order)

for k = 1: size(Times_stay_Cr_UO,1)
    ICUInTime = Times_stay_Cr_UO{k,2}; ICUIn_time_form = datevec(ICUInTime,1915);
    CrFirstTime = Times_stay_Cr_UO{k,3}; CrFirstTime_form = datevec(CrFirstTime,1915);
    UOFirstTime = Times_stay_Cr_UO{k,4}; UOFirstTime_form = datevec(UOFirstTime,1915);
    
    ICU_Cr = etime(CrFirstTime_form, ICUIn_time_form); % should be positive
    ICU_UO = etime(UOFirstTime_form, ICUIn_time_form); % should be positive
    Cr_UO = etime(CrFirstTime_form, UOFirstTime_form);
    
    timeDiff_ICU_cr_UO(k,:) = [ICU_Cr, ICU_UO,  Cr_UO]/3600; % in hours
    
    
end

%% Figure settings : copied from main function for now (temp)
width = 3;% Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize


%% Hist ICUin and First Cr
length(find(timeDiff_ICU_cr_UO(:,1)<0)); % 2923/14830: bad: how did they have cr measured before getting admitted?
fig = figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); 
set(gca, 'FontSize', fsz, 'LineWidth', alw); 
hist(timeDiff_ICU_cr_UO(:,1),500)
xlim([-50,100])
xlabel('Time difference between the first creatinine measurement and icustay in');
ylabel('Count')
figName = 'Histogram of the time difference between the first creatinine measurement and icustay in';
title(figName);
print(figName,'-dpng','-r300');
saveas(fig, [figName,'.fig']);
close;
%% Hist ICUin and First UO
length(find(timeDiff_ICU_cr_UO(:,2)<0)) % 0 good.  Because used truncated version.
% non Trunc : 2123
fig = figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); 
set(gca, 'FontSize', fsz, 'LineWidth', alw); 
hist(timeDiff_ICU_cr_UO(:,2),1000)
xlim([-50,50])
xlabel('Time difference between the first UO measurement (not Trunc) and icustay in');
ylabel('Count')
figName = 'Histogram of the time difference between the first UO (not Trunc) measurement and icustay in';
title(figName);
print(figName,'-dpng','-r300');
saveas(fig, [figName,'.fig']);


%% Hist First Cr and First UO:  Cr - UO
length(find(timeDiff_ICU_cr_UO(:,3)<0)) % 7244: for about half, the creatinine meas was taken before UO meas
fig = figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); 
set(gca, 'FontSize', fsz, 'LineWidth', alw); 
hist(timeDiff_ICU_cr_UO(:,3),500)
xlim([-50,50])
xlabel('Time difference between the first Cr and first UO measurement');
ylabel('Count')
figName = 'Histogram of the time difference between the first Cr and first UO measurement';
title(figName);
print(figName,'-dpng','-r300');
saveas(fig, [figName,'.fig']);