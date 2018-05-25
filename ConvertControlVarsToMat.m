function [ ControlVars] = ConvertControlVarsToMat(AllRows,data)
%ICU stay,
%Gender, 
%age, 
%weight (at the moment I have max weight), 
%fluid intake (don’t have), 
%and diuretics (have three, which one?)
%% Converting the ICU stay from string to numbers

ICU = NaN*ones(length(AllRows),1);
ICUColumn = ConvertToCell(data,14,AllRows);

% 1 : CSRU

TFMatchesICU = strcmp('CSRU',ICUColumn);
RowsMatchingICU = find(TFMatchesICU==1);
ICU(RowsMatchingICU,1) = ones(length(RowsMatchingICU),1);

% 2: SICU
TFMatchesICU = strcmp('SICU',ICUColumn);
RowsMatchingICU = find(TFMatchesICU==1);
ICU(RowsMatchingICU,1) = 2*ones(length(RowsMatchingICU),1);

% 3: CCU
TFMatchesICU = strcmp('CCU',ICUColumn);
RowsMatchingICU = find(TFMatchesICU==1);
ICU(RowsMatchingICU,1) = 3*ones(length(RowsMatchingICU),1);

% 4:MICU + FICU
ICU1 = 'MICU';% 'MICU'+'FICU'
ICU2 = 'FICU';
TFMatchesICU = (strcmp(ICU1,ICUColumn) | strcmp(ICU2,ICUColumn));
RowsMatchingICU = find(TFMatchesICU==1);
ICU(RowsMatchingICU,1) = 4*ones(length(RowsMatchingICU),1);


%%  Gender  15; Male = 0; Female = 1;
Gender = NaN*ones(length(AllRows),1);
GenderColumn = ConvertToCell(data,15,AllRows);
TFMatchingMale = strcmp('M',GenderColumn);
RowsMatchingMale = find(TFMatchingMale==1);
Gender(RowsMatchingMale,1) = 0*ones(length(RowsMatchingMale),1);
TFMatchingFemale = strcmp('F',GenderColumn);
RowsMatchingFemale = find(TFMatchingFemale==1);
Gender(RowsMatchingFemale,1) = 1*ones(length(RowsMatchingFemale),1);

%% Age 27
Age  = cell2mat(ConvertToCell(data,27,AllRows));


%% Weight  65
Weight  = cell2mat(ConvertToCell(data,68,AllRows)); % first weight


%% Diuretics: using all at the 

% FIRST_LASIX_BE4_48HRS_ICU (10), FIRST_LASIX_AFTER_48HRS_I (11),
% LASIX_PRE_ADMISSION (52)

FIRST_LASIX_BE4_48HRS_ICU  = cell2mat(ConvertToCell(data,10,AllRows));
FIRST_LASIX_AFTER_48HRS_I =  cell2mat(ConvertToCell(data,11,AllRows));
LASIX_PRE_ADMISSION = cell2mat(ConvertToCell(data,52,AllRows));

Diuretics = FIRST_LASIX_BE4_48HRS_ICU | FIRST_LASIX_AFTER_48HRS_I|LASIX_PRE_ADMISSION;

%% Height
Height = cell2mat(ConvertToCell(data,66,AllRows));

%% Creatinine Level at Admission
FirstCr = cell2mat(ConvertToCell(data,64,AllRows));

%% Diabetes

DiabetesUncomp = cell2mat(ConvertToCell(data,36,AllRows)); 
DiabetesComp = cell2mat(ConvertToCell(data,37,AllRows)); 
Diabetes = NaN * ones(size(DiabetesUncomp));
for g = 1: size(DiabetesUncomp,1)
    if isnan(DiabetesUncomp(g)) | isnan(DiabetesComp(g))
        Diabetes(g) = NaN;
    else  Diabetes(g) = DiabetesUncomp(g)|DiabetesComp(g);
    end
end
        
%% LBM
LBM = cell2mat(ConvertToCell(data,74,AllRows)); 



%% Control variables 
ControlVars = [ICU Gender Age Weight Diuretics Height FirstCr Diabetes LBM];

end

