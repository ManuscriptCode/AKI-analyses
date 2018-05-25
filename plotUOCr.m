function [] = plotUOCr( ICUID, weight, minCr )
global creatinine urineDataChosen

CreatinineDataINDX = find(creatinine.icustay_id == ICUID);
CreatinineData = creatinine(CreatinineDataINDX,:);
timeUnformated = CreatinineData(:,3);
timeUnformatedCell = dataset2cell(timeUnformated);
timeUnformatedCell = timeUnformatedCell(2:end);
DateVectsCr= datevec(timeUnformatedCell,1915);



UODataINDX = find(urineDataChosen.ICUSTAY_ID == ICUID);
UOData = urineDataChosen(UODataINDX,:);
timeUnformatedUO = UOData(:,3);
timeUnformatedUOCell = dataset2cell(timeUnformatedUO);
timeUnformatedUOCell = timeUnformatedUOCell(2:end);
DateVectsUO= datevec(timeUnformatedUOCell,1915);

TimesCr = zeros(size(DateVectsCr,1),1);
TimesUO = zeros(size(DateVectsUO,1),1);


for i = 1:size(DateVectsCr,1)
    TimesCr(i,1) = etime(DateVectsCr(i,:),DateVectsUO(1,:)); % seconds integer numbers indices of times
end


for i = 1:size(DateVectsUO,1)
    TimesUO(i,1) = etime(DateVectsUO(i,:),DateVectsUO(1,:)); % seconds integer numbers indices of times
end

% divide by weight also


plot(TimesUO/3600, table2array(dataset2table(UOData(:,4)))/weight,'ro')
hold on 
plot(TimesCr/3600, CreatinineData(:,4),'bx')
hold on 
line([0 120],[minCr minCr]);
xlabel('hours from first UO measure');
ylabel('Value');
legend({'normalized UO', 'Creatinine', 'min creatinine per hospital'});


end

