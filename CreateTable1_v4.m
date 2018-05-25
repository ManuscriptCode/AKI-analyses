function [ Table1 ] = CreateTable1_v4(GoodRowsTF, GEEgoodrowTF)
% added fisher extact test for binomial data
% With t-test [h,p] = ttest2(x,y): x, y unequal sizes, works for 
global data;
Table1 = cell(23,6);

AllTF = ones(size(data,1),1);
AllRows = 1: size(data,1);
GoodRowsInd = find(GoodRowsTF ==1);
GEEGoodRowsInd = find(GEEgoodrowTF ==1);

Properties = {'Number', 'Age','SAPSI first','SOFA first','Gender (Male)','Hospital  LOS (in days,survivals only)', ...
'Hospital  LOS(in days, deceased only)','ICU LOS(in days, survivals only)',...
'ICU LOS(in days, deceased only)','Survival rate','First ICU weight(Kgs)', 'Diabetes', ... 
'Height','number in CSRU', 'number in SICU', 'number in CCU', 'number in MICU and FICU', ...
'First cr','Diuretics', 'LBM', 'Met AKIcr def', 'Met AKIuop trad. def'};

Table1{1,1} = 'Properties';
Table1(2:end,1) = Properties;
Table1(1,2:end) = {'All', 'Selected Cohort', 'Used in GEE', 't-test All-Selected cohort','t-test All-GEE cohort'};

TotalNumber = length(AllRows);
numCohort = length(GoodRowsInd);
numGEE = length(GEEGoodRowsInd);
%% Number: 2

Table1{2,2}  = num2str(TotalNumber); % All
Table1{2,3} = num2str(numCohort); % Cohort
Table1{2,4} = num2str(numGEE); % GEE

%% Age : 3
Agedata = data.AGE;

% All
MedianAge = nanmedian(Agedata(AllRows)); 
Q = quantile(Agedata(AllRows),[0.25, 0.75]); 
Table1{3,2} = [num2str(MedianAge), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% Cohort
MedianAge = nanmedian(Agedata(GoodRowsInd)); 
Q = quantile(Agedata(GoodRowsInd),[0.25, 0.75]); 
Table1{3,3} = [num2str(MedianAge), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% GEE
MedianAge = nanmedian(Agedata(GEEGoodRowsInd)); 
Q = quantile(Agedata(GEEGoodRowsInd),[0.25, 0.75]); 
Table1{3,4} = [num2str(MedianAge), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% t-test All- cohort
[h,p] = ttest2(Agedata(AllRows),Agedata(GoodRowsInd));
Table1{3,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(Agedata(AllRows),Agedata(GEEGoodRowsInd));
Table1{3,6} = ['(',num2str(h),', ',num2str(p),')'];

%% 'SAPSI first' : 4

SAPSIfirstVals = data.SAPSI_FIRST;

% All
MedianSAPSI_first = nanmedian(SAPSIfirstVals(AllRows)); 
Q = quantile(SAPSIfirstVals(AllRows),[0.25, 0.75]); 
Table1{4,2} = [num2str(MedianSAPSI_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% Cohort
MedianSAPSI_first = nanmedian(SAPSIfirstVals(GoodRowsInd)); 
Q = quantile(SAPSIfirstVals(GoodRowsInd),[0.25, 0.75]); 
Table1{4,3} = [num2str(MedianSAPSI_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% GEE
MedianSAPSI_first = nanmedian(SAPSIfirstVals(GEEGoodRowsInd)); 
Q = quantile(SAPSIfirstVals(GEEGoodRowsInd),[0.25, 0.75]); 
Table1{4,4} = [num2str(MedianSAPSI_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];
    
% t-test All- cohort
[h,p] = ttest2(SAPSIfirstVals(AllRows),SAPSIfirstVals(GoodRowsInd));
Table1{4,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(SAPSIfirstVals(AllRows),SAPSIfirstVals(GEEGoodRowsInd));
Table1{4,6} = ['(',num2str(h),', ',num2str(p),')'];

%% 'SOFA first' : 5
SOFAfirstVals = data.SOFA_FIRST;

% All
MedianSOFA_first = nanmedian(SOFAfirstVals(AllRows));
Q = quantile(SOFAfirstVals(AllRows),[0.25, 0.75]);  %
Table1{5,2} = [num2str(MedianSOFA_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];
   
% Cohort
MedianSOFA_first = nanmedian(SOFAfirstVals(GoodRowsInd));
Q = quantile(SOFAfirstVals(GoodRowsInd),[0.25, 0.75]);  %
Table1{5,3} = [num2str(MedianSOFA_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];
   
% GEE
MedianSOFA_first = nanmedian(SOFAfirstVals(GEEGoodRowsInd));
Q = quantile(SOFAfirstVals(GEEGoodRowsInd),[0.25, 0.75]);  %
Table1{5,4} = [num2str(MedianSOFA_first), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% t-test All- cohort
[h,p] = ttest2(SOFAfirstVals(AllRows),SOFAfirstVals(GoodRowsInd));
Table1{5,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(SOFAfirstVals(AllRows),SOFAfirstVals(GEEGoodRowsInd));
Table1{5,6} = ['(',num2str(h),', ',num2str(p),')'];


       
%% 'Gender (Male)' : 6  : Fisher
GenderData = data.GENDER;
MTF = ~strcmp('F',GenderData);% Male = 0; Female = 1; 

% All
numMale = length(find(MTF & AllTF));
percentMale = (numMale*100)/TotalNumber;
Table1{6,2} = [num2str(numMale),' (',num2str(percentMale),' %)'];

a = numMale; % for fisher's exact test

% Cohort
numMale = length(find(MTF & GoodRowsTF));
percentMale = (numMale*100)/numCohort;
Table1{6,3} = [num2str(numMale),' (',num2str(percentMale),' %)'];

% GEE
numMale = length(find(MTF & GEEgoodrowTF));
percentMale = (numMale*100)/numGEE;
Table1{6,4} = [num2str(numMale),' (',num2str(percentMale),' %)'];

b = numMale;

% Fisher  All-GEE
c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{6,6} = num2str(Two_tail);
 

% % t-test All- cohort
% [h,p] = ttest2(find(MTF & AllTF),find(MTF & GoodRowsTF));
% Table1{6,5} = ['(',num2str(h),', ',num2str(p),')'];
% 
% % t-test All - GEE cohort
% [h,p] = ttest2(find(MTF & AllTF),find(MTF & GEEgoodrowTF));
% Table1{6,6} = ['(',num2str(h),', ',num2str(p),')'];

 
%% Deceased TF 
deceasedTF = strcmp('Y',data.HOSPITAL_EXPIRE_FLG);

%% 'Hospital  LOS (in days,survivals only)': 7
HOSPITAL_LOS_Data = data.HOSPITAL_LOS;

% All
toUseInd = find(deceasedTF & AllTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %       2.0432e+04
Table1{7,2} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

AllData = HOSPITAL_LOS_Data(toUseInd);
% Cohort
toUseInd = find(deceasedTF & GoodRowsTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %       2.0432e+04
Table1{7,3} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

CohortData = HOSPITAL_LOS_Data(toUseInd);

% GEE
toUseInd = find(deceasedTF & GEEgoodrowTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %       2.0432e+04
Table1{7,4} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

GEEData = HOSPITAL_LOS_Data(toUseInd);

% t-test All- cohort
[h,p] = ttest2(AllData,CohortData);
Table1{7,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(AllData,GEEData);
Table1{7,6} = ['(',num2str(h),', ',num2str(p),')'];


%% 'Hospital  LOS(in days, deceased only)' : 8

% All
toUseInd = find((~deceasedTF) & AllTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %       2.0432e+04
Table1{8,2} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

AllData = HOSPITAL_LOS_Data(toUseInd);
% Cohort
toUseInd = find((~deceasedTF) & GoodRowsTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %       2.0432e+04
Table1{8,3} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

CohortData = HOSPITAL_LOS_Data(toUseInd);
% GEE
toUseInd = find((~deceasedTF) & GEEgoodrowTF);
MedianHOSPITAL_LOS = nanmedian(HOSPITAL_LOS_Data(toUseInd))/(60*24); 
Q = quantile(HOSPITAL_LOS_Data(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{8,4} = [num2str(MedianHOSPITAL_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

GEEData = HOSPITAL_LOS_Data(toUseInd);
% t-test All- cohort
[h,p] = ttest2(AllData,CohortData);
Table1{8,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(AllData,GEEData);
Table1{8,6} = ['(',num2str(h),', ',num2str(p),')'];


%% 'ICU LOS(in days, survivals only)' : 9

ICULOSData = data.ICUSTAY_LOS;
% All
toUseInd = find(deceasedTF & AllTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{9,2} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

AllData = ICULOSData(toUseInd);
% Cohort
toUseInd = find(deceasedTF & GoodRowsTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{9,3} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

CohortData = ICULOSData(toUseInd);
% GEE
toUseInd = find(deceasedTF & GEEgoodrowTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{9,4} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

GEEData = ICULOSData(toUseInd);

% t-test All- cohort
[h,p] = ttest2(AllData,CohortData);
Table1{9,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(AllData,GEEData);
Table1{9,6} = ['(',num2str(h),', ',num2str(p),')'];

%% 'ICU LOS(in days, deceased only)' : 10
% All
toUseInd = find((~deceasedTF) & AllTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{10,2} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

AllData = ICULOSData(toUseInd);
% Cohort
toUseInd = find((~deceasedTF) & GoodRowsTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{10,3} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

CohortData = ICULOSData(toUseInd);
% GEE
toUseInd = find((~deceasedTF) & GEEgoodrowTF);
MedianICU_LOS = nanmedian(ICULOSData(toUseInd))/(60*24); 
Q = quantile(ICULOSData(toUseInd),[0.25,0.75])/(60*24);  %      
Table1{10,4} = [num2str(MedianICU_LOS), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

GEEData= ICULOSData(toUseInd);
% t-test All- cohort
[h,p] = ttest2(AllData,CohortData);
Table1{10,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(AllData,GEEData);
Table1{10,6} = ['(',num2str(h),', ',num2str(p),')'];

%% 'Hospital Survival rate' : 11 : Fisher

% All
numSurvived = length(find(deceasedTF & AllTF));
survival_rate = (numSurvived * 100)/TotalNumber; 
Table1{11,2} = [num2str(survival_rate), ' %'];

a = numSurvived;

% Cohort
numSurvived = length(find(deceasedTF & GoodRowsTF));
survival_rate = (numSurvived * 100)/numCohort; 
Table1{11,3} = [num2str(survival_rate), ' %'];

b = numSurvived;

% GEE
numSurvived = length(find(deceasedTF & GEEgoodrowTF));
survival_rate = (numSurvived * 100)/numGEE; 
Table1{11,4} = [num2str(survival_rate), ' %'];


% Fisher  All-GEE
c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{11,6} = num2str(Two_tail);
 

% % t-test All- cohort
% [h,p] = ttest2(find(deceasedTF & AllTF),find(deceasedTF & GoodRowsTF));
% Table1{11,5} = ['(',num2str(h),', ',num2str(p),')'];
% 
% % t-test All - GEE cohort
% [h,p] = ttest2(find(deceasedTF & AllTF),find(deceasedTF & GEEgoodrowTF));
% Table1{11,6} = ['(',num2str(h),', ',num2str(p),')'];


%% 'First ICU weight(Kgs)' : 12
FirstICUWeight = data.FIRST_WEIGHT;

% All
MedianFirstICUWeight =nanmedian(FirstICUWeight(AllRows));
Q = quantile(FirstICUWeight(AllRows),[0.25,0.75]);
Table1{12,2} = [num2str(MedianFirstICUWeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% Cohort
MedianFirstICUWeight =nanmedian(FirstICUWeight(GoodRowsInd));
Q = quantile(FirstICUWeight(GoodRowsInd),[0.25,0.75]);
Table1{12,3} = [num2str(MedianFirstICUWeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% GEE
MedianFirstICUWeight =nanmedian(FirstICUWeight(GEEGoodRowsInd));
Q = quantile(FirstICUWeight(GEEGoodRowsInd),[0.25,0.75]);
Table1{12,4} = [num2str(MedianFirstICUWeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];


% t-test All- cohort
[h,p] = ttest2(FirstICUWeight(AllRows),FirstICUWeight(GoodRowsInd));
Table1{12,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(FirstICUWeight(AllRows),FirstICUWeight(GEEGoodRowsInd));
Table1{12,6} = ['(',num2str(h),', ',num2str(p),')'];
%% 'Diabetes' : 13 : Fisher

DiabetesUncomp = data.DIABETES_UNCOMPLICATED; 
DiabetesComp = data.DIABETES_COMPLICATED; 
DiabetesTF = NaN * ones(size(DiabetesUncomp));
for g = 1: size(DiabetesUncomp,1)
    if isnan(DiabetesUncomp(g)) | isnan(DiabetesComp(g))
        DiabetesTF(g) = NaN;
    else  DiabetesTF(g) = DiabetesUncomp(g)|DiabetesComp(g);
    end
end
        
% All

numDiab = length(find((DiabetesTF==1) & AllTF));
percentDiab = (numDiab*100)/TotalNumber;
Table1{13,2} = [num2str(numDiab),' (',num2str(percentDiab),' %)'];

AllData = find((DiabetesTF==1) & AllTF);

a = numDiab;

% Cohort

numDiab = length(find((DiabetesTF==1) & GoodRowsTF));
percentDiab = (numDiab*100)/numCohort;
Table1{13,3} = [num2str(numDiab),' (',num2str(percentDiab),' %)'];

CohortData = find((DiabetesTF==1) & GoodRowsTF);

% GEE

numDiab = length(find((DiabetesTF==1) & GEEgoodrowTF));
percentDiab = (numDiab*100)/numGEE;
Table1{13,4} = [num2str(numDiab),' (',num2str(percentDiab),' %)'];

GEEData = find((DiabetesTF==1) & GEEgoodrowTF);

b = numDiab;


% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{13,6} = num2str(Two_tail);
 
% 
% % t-test All- cohort
% [h,p] = ttest2(AllData,CohortData);
% Table1{13,5} = ['(',num2str(h),', ',num2str(p),')'];
% 
% % t-test All - GEE cohort
% [h,p] = ttest2(AllData,GEEData);
% Table1{13,6} = ['(',num2str(h),', ',num2str(p),')'];
%% 'Height' : 14
HeightData = data.HEIGHT;

% All
MedianHeight = nanmedian(HeightData(AllRows)); 
Q = quantile(HeightData(AllRows),[0.25, 0.75]); 
Table1{14,2} = [num2str(MedianHeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

AllData = HeightData(AllRows);
% Cohort
MedianHeight = nanmedian(HeightData(GoodRowsInd)); 
Q = quantile(HeightData(GoodRowsInd),[0.25, 0.75]); 
Table1{14,3} = [num2str(MedianHeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

CohortData = HeightData(GoodRowsInd);

% GEE
MedianHeight = nanmedian(HeightData(GEEGoodRowsInd)); 
Q = quantile(HeightData(GEEGoodRowsInd),[0.25, 0.75]); 
Table1{14,4} = [num2str(MedianHeight), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

GEEData = HeightData(GEEGoodRowsInd);


% t-test All- cohort
[h,p] = ttest2(AllData,CohortData);
Table1{14,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(AllData,GEEData);
Table1{14,6} = ['(',num2str(h),', ',num2str(p),')'];

%% Different ICUs
ICUColumn = data.ICUSTAY_FIRST_SERVICE;
CSRUTF = strcmp('CSRU',ICUColumn);
SICUTF = strcmp('SICU',ICUColumn);
CCUTF = strcmp('CCU',ICUColumn);
MICUTF = (strcmp('MICU',ICUColumn) | strcmp('FICU',ICUColumn));
 
%% 'number in CSRU' : 15 : Fisher
% All
numCSRU = length(find(CSRUTF & AllTF));
percentCSRU = (numCSRU*100)/TotalNumber;
Table1{15,2} = [num2str(numCSRU),' (',num2str(percentCSRU),' %)'];

a =  numCSRU;

% Cohort
numCSRU = length(find(CSRUTF & GoodRowsTF));
percentCSRU = (numCSRU*100)/numCohort;
Table1{15,3} = [num2str(numCSRU),' (',num2str(percentCSRU),' %)'];

% GEE
numCSRU = length(find(CSRUTF& GEEgoodrowTF));
percentCSRU = (numCSRU*100)/numGEE;
Table1{15,4} = [num2str(numCSRU),' (',num2str(percentCSRU),' %)'];

b = numCSRU;

% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{15,6} = num2str(Two_tail);
 

%% 'number in SICU' : 16 : Fisher
% All
numSICU = length(find(SICUTF & AllTF));
percentSICU = (numSICU*100)/TotalNumber;
Table1{16,2} = [num2str(numSICU),' (',num2str(percentSICU),' %)'];

a = numSICU;

% Cohort
numSICU = length(find(SICUTF & GoodRowsTF));
percentSICU = (numSICU*100)/numCohort;
Table1{16,3} = [num2str(numSICU),' (',num2str(percentSICU),' %)'];

% GEE
numSICU = length(find(SICUTF & GEEgoodrowTF));
percentSICU = (numSICU*100)/numGEE;
Table1{16,4} = [num2str(numSICU),' (',num2str(percentSICU),' %)'];

b = numSICU;

% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{16,6} = num2str(Two_tail);
 
%% 'number in CCU' :17 :Fisher
% All
numCCU = length(find(CCUTF & AllTF));
percentCCU = (numCCU*100)/TotalNumber;
Table1{17,2} = [num2str(numCCU),' (',num2str(percentCCU),' %)'];

a = numCCU;

% Cohort
numCCU = length(find(CCUTF & GoodRowsTF));
percentCCU = (numCCU*100)/numCohort;
Table1{17,3} = [num2str(numCCU),' (',num2str(percentCCU),' %)'];

% GEE
numCCU = length(find(CCUTF & GEEgoodrowTF));
percentCCU = (numCCU*100)/numGEE;
Table1{17,4} = [num2str(numCCU),' (',num2str(percentCCU),' %)'];

b = numCCU

% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{17,6} = num2str(Two_tail);
 

%% 'number in MICU and FICU' : 18 : Fisher
% All
numMICU = length(find(MICUTF & AllTF));
percentMICU = (numMICU*100)/TotalNumber;
Table1{18,2} = [num2str(numMICU),' (',num2str(percentMICU),' %)'];

a = numMICU;

% Cohort
numMICU = length(find(MICUTF & GoodRowsTF));
percentMICU = (numMICU*100)/numCohort;
Table1{18,3} = [num2str(numMICU),' (',num2str(percentMICU),' %)'];

% GEE
numMICU = length(find(MICUTF & GEEgoodrowTF));
percentMICU = (numMICU*100)/numGEE;
Table1{18,4} = [num2str(numMICU),' (',num2str(percentMICU),' %)'];

b = numMICU;

% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{18,6} = num2str(Two_tail);
 


%% 'First cr' : 19
FirstCrData = data.FIRST_CR;

% All
MedianFirstCr =nanmedian(FirstCrData(AllRows));
Q = quantile(FirstCrData(AllRows),[0.25,0.75]);
Table1{19,2} = [num2str(MedianFirstCr), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];


% Cohort
MedianFirstCr =nanmedian(FirstCrData(GoodRowsInd));
Q = quantile(FirstCrData(GoodRowsInd),[0.25,0.75]);
Table1{19,3} = [num2str(MedianFirstCr), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% GEE
MedianFirstCr =nanmedian(FirstCrData(GEEGoodRowsInd));
Q = quantile(FirstCrData(GEEGoodRowsInd),[0.25,0.75]);
Table1{19,4} = [num2str(MedianFirstCr), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];


% t-test All- cohort
[h,p] = ttest2(FirstCrData(AllRows),FirstCrData(GoodRowsInd));
Table1{19,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(FirstCrData(AllRows),FirstCrData(GEEGoodRowsInd));
Table1{19,6} = ['(',num2str(h),', ',num2str(p),')'];
%% 'Diuretics' : 20 : Fisher

FIRST_LASIX_BE4_48HRS_ICU = data.FIRST_LASIX_BE4_48HRS_ICU;
FIRST_LASIX_AFTER_48HRS_I = data.FIRST_LASIX_AFTER_48HRS_I;
LASIX_PRE_ADMISSION = data.LASIX_PRE_ADMISSION;
DiureticsTF = FIRST_LASIX_BE4_48HRS_ICU | FIRST_LASIX_AFTER_48HRS_I|LASIX_PRE_ADMISSION;

%All
numDiur = length(find(DiureticsTF & AllTF));
percentDiur = (numDiur*100)/TotalNumber;
Table1{20,2} = [num2str(numDiur),' (',num2str(percentDiur),' %)'];

a = numDiur;

% Cohort

numDiur = length(find(DiureticsTF & GoodRowsTF));
percentDiur = (numDiur*100)/numCohort;
Table1{20,3} = [num2str(numDiur),' (',num2str(percentDiur),' %)'];

% GEE

numDiur = length(find(DiureticsTF & GEEgoodrowTF));
percentDiur = (numDiur*100)/numGEE;
Table1{20,4} = [num2str(numDiur),' (',num2str(percentDiur),' %)'];

b = numDiur;

% Fisher  All-GEE

c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{20,6} = num2str(Two_tail);
 

% 
% 
% % t-test All- cohort
% [h,p] = ttest2(find(DiureticsTF & AllTF),find(DiureticsTF & GoodRowsTF));
% Table1{20,5} = ['(',num2str(h),', ',num2str(p),')'];
% 
% % t-test All - GEE cohort
% [h,p] = ttest2(find(DiureticsTF & AllTF),find(DiureticsTF & GEEgoodrowTF));
% Table1{20,6} = ['(',num2str(h),', ',num2str(p),')'];

%% 'LBM' : 21
LBMData = data.LBM;

% All
MedianLBM =nanmedian(LBMData(AllRows));
Q = quantile(LBMData(AllRows),[0.25,0.75]);
Table1{21,2} = [num2str(MedianLBM), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% Cohort
MedianLBM =nanmedian(LBMData(GoodRowsInd));
Q = quantile(LBMData(GoodRowsInd),[0.25,0.75]);
Table1{21,3} = [num2str(MedianLBM), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];

% GEE
MedianLBM =nanmedian(LBMData(GEEGoodRowsInd));
Q = quantile(LBMData(GEEGoodRowsInd),[0.25,0.75]);
Table1{21,4} = [num2str(MedianLBM), ' (',num2str(Q(1)),', ',num2str(Q(2)),')'];


% t-test All- cohort
[h,p] = ttest2(LBMData(AllRows),LBMData(GoodRowsInd));
Table1{21,5} = ['(',num2str(h),', ',num2str(p),')'];

% t-test All - GEE cohort
[h,p] = ttest2(LBMData(AllRows),LBMData(GEEGoodRowsInd));
Table1{21,6} = ['(',num2str(h),', ',num2str(p),')'];
%% 'Met AKIcr def' :22 : Fisher

AKICrNewTF = data.AKICrNew;

% All
numAKIcr = length(find((AKICrNewTF==1) & AllTF));
percentAKIcr = (numAKIcr*100)/TotalNumber;
Table1{22,2} = [num2str(numAKIcr),' (',num2str(percentAKIcr),' %)'];

a = numAKIcr;

% Cohort

numAKIcr = length(find((AKICrNewTF==1) & GoodRowsTF));
percentAKIcr = (numAKIcr*100)/numCohort;
Table1{22,3} = [num2str(numAKIcr),' (',num2str(percentAKIcr),' %)'];

% GEE

numAKIcr = length(find((AKICrNewTF==1) & GEEgoodrowTF));
percentAKIcr = (numAKIcr*100)/numGEE;
Table1{22,4} = [num2str(numAKIcr),' (',num2str(percentAKIcr),' %)'];

b = numAKIcr;

% Fisher  All-GEE
c = TotalNumber - a;
d = numGEE - b;

[Left_tail, Right_tail, Two_tail] = testfisherexact(a,b,c,d);

Table1{22,6} = num2str(Two_tail);
 

% 
% % t-test All- cohort
% [h,p] = ttest2(find((AKICrNewTF==1) & AllTF),find((AKICrNewTF==1) & GoodRowsTF));
% Table1{22,5} = ['(',num2str(h),', ',num2str(p),')'];
% 
% % t-test All - GEE cohort
% [h,p] = ttest2(find((AKICrNewTF==1) & AllTF),find((AKICrNewTF==1) & GEEgoodrowTF));
% Table1{22,6} = ['(',num2str(h),', ',num2str(p),')'];


%% 'Met AKIuop trad. def' : 23
% from NewData, 



  
    
end




