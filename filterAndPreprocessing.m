function [ GoodRowsindices,GoodRowsTF, Values] = filterAndPreprocessing()
% AllRows = 1:size(DataSetAllWithFirstCrMaxWeightNoRepeat,1);
% apply filtering criterions and return list of indices that satisfy them
%% using 'datawithmin.mat'

global data urineDataChosen totalBalCommonFixed MAPCommonFixed;
%load('DataSetAllFirstCrMaxWeightNoReptCommonHeightWeightsCathsBoth');
%load('urinedataNonNaNCommon');
%load('totalBalCommonFixed');
%load('MAPCommonFixed');
%data = DataSetAllFirstCrMaxWeightNoReptCommonHeightWeightsCathsBoth;

AllRows = 1: size(data,1);


%% Intersection of datasets: done already
% ICUID_DataSetAllWithFirstCrMaxWeight = data.ICUSTAY_ID;
% ICUID_urinedata = urinedataNonNaNCommon.ICUSTAY_ID;
%
% % get overlapping ICU IDs
% [c1,ia1,ib1] = intersect(ICUID_DataSetAllWithFirstCrMaxWeight,ICUID_urinedata);
%
% TFIntersection = zeros(length(AllRows),1);
% TFIntersection(ia1,1) = ones(length(ia1),1);
%
% TIntersectionIndices = find(TFIntersection==1);
% NumberMetIntersection = length(TIntersectionIndices)
% NumberDidNotMeetIntersection = length(AllRows) - NumberMetIntersection



%% creatinine level of first measurement should be <1.2
CRThreshold = 1.2;% change this later

FirstCreatinine = cell2mat( ConvertToCell(data,64,AllRows));
TFFirstCreatinine = FirstCreatinine <= CRThreshold ;

% get number of included and excluded
TFirstCreatinineIndices = find(TFFirstCreatinine==1);
NumberMetCr = length(TFirstCreatinineIndices)
NumberDidNotMeetCr = length(AllRows) - NumberMetCr


%% dialyses
%remove dialyses: DIALYSIS_FLAG 12: filter to only have 0
Dailysis_flagColumn = cell2mat(ConvertToCell(data,12,AllRows));
TFDailysesrows = Dailysis_flagColumn == 0;

% get number of included and excluded
TDialysesIndices = find(TFDailysesrows==1);
NumberMetDia = length(TDialysesIndices)
NumberDidNotMeetDia = length(AllRows) - NumberMetDia

%% Has MAP info
% 'Doesnt have MAP info'
% [c1,ia1,ib1] = intersect(data.ICUSTAY_ID,unique(MAPCommonFixed.ICUSTAY_ID));
% TFMAPinfo = ismember(AllRows,ia1);
% length(AllRows) - length(find(TFMAPinfo))


% %% Has totalBal info
% 'Doesnt have totalBal info'
% [c1,ia1,ib1] = intersect(data.ICUSTAY_ID,unique(totalBalCommonFixed.ICUSTAY_ID));
% TFtotalBalinfo = ismember(AllRows,ia1);
% length(AllRows) - length(find(TFtotalBalinfo))

%% Doesn't have height info
'Doesnt have height info'
TFHasHeight = ~isnan(data.HEIGHT);
length(find(TFHasHeight == 0))

%% Remove weight < 1 Kgs;
TFHasWeightless1 = data.FIRST_WEIGHT < 1;
TFHasWeightNaN = isnan(data.FIRST_WEIGHT);
TFHasWeight = TFHasWeightless1 | TFHasWeightNaN;
TFHasWeight = ~ TFHasWeight; % negating because true = keep, false = reject
'Doesnt have weight info'
length(find(TFHasWeight == 0))

%% Indices Till now
GoodRowsTF =  TFFirstCreatinine & TFDailysesrows & TFHasHeight & TFHasWeight;
GoodRowsindices = find(GoodRowsTF ==1);

%% For the first 6 hours each normalized UO should be >=  0.5
% make function that returns 1 if Average UO should be >= 0.5. 0 otherwize.

SUBJECT_IDindx = 1;
ICUSTAY_IDindx =2;

SUBJECT_ID_COL = cell2mat(ConvertToCell(data,SUBJECT_IDindx,AllRows));

ICUSTAY_ID_COL = cell2mat(ConvertToCell(data, ICUSTAY_IDindx,AllRows));

AllrowsUrine = 1: size(urineDataChosen,1);
UrineDataSubjectCol = cell2mat(ConvertToCell(urineDataChosen, 1,AllrowsUrine));
UrineDataICUColumn = cell2mat(ConvertToCell(urineDataChosen, 2,AllrowsUrine));
UrineSubjectICU = [UrineDataSubjectCol UrineDataICUColumn];

TFAllRowsUO  =  NaN*ones(size(SUBJECT_ID_COL,1),1); % is the avg UO > 0.5 ?

%have all the rows
NewData = [SUBJECT_ID_COL ICUSTAY_ID_COL TFAllRowsUO];



% SUBJECT_ID_COL_SUB = SUBJECT_ID_COL(1:20,1);
% ICUSTAY_ID_COL_SUB = ICUSTAY_ID_COL(1:20,1);
% TFAllRowsAVGUO_SUB = TFAllRowsAVGUO(1:20,1);


%NewDataSub = [SUBJECT_ID_COL_SUB ICUSTAY_ID_COL_SUB TFAllRowsAVGUO_SUB];

% subdata =
Values = NaN*ones(length(ICUSTAY_ID_COL),3); % ICU ID and value timedifferencebetween6hoursandnextmeasurement

j = 1;
for SubjectID = unique(SUBJECT_ID_COL') % in data SUBJECT_ID_COL
    % find ICU IDs for subject ID
    indixesSubjectID = find(SUBJECT_ID_COL(:,1) == SubjectID );
    for IcuID = ICUSTAY_ID_COL(indixesSubjectID,1)'
        % find all the rows of urineDataChosen that have the SubjectID and ICUID
        
        FoundSubjectAndICUIdxs = find((UrineSubjectICU(:,1) == SubjectID) &(UrineSubjectICU(:,2) == IcuID) ) ;
        
        if ~isempty(FoundSubjectAndICUIdxs)
            
            % Subdata
            Subdata = urineDataChosen(FoundSubjectAndICUIdxs,:);
            FirstWeight = data(j,68);
            FirstWeightValue = FirstWeight.FIRST_WEIGHT;
            % need to check that indeed the Subject ID and ICU ID are the same
            GottenSubjectIDDataSet = data(j,1);
            GottenSubjectID = GottenSubjectIDDataSet.SUBJECT_ID;
            GottenICUIDDataSet = data(j,2);
            GottenICUID = GottenICUIDDataSet.ICUSTAY_ID;
            if (SubjectID~= GottenSubjectID) | (IcuID ~= GottenICUID)
                'Something went wrong with the indices, the IDs dont match up';
                break
            end
            
            [TF, value, timediff] = IsUOFirst6HrsMeetingCutoff( Subdata , FirstWeightValue,IcuID);
            NewData(j,3)= TF;
            Values(j,1) = IcuID;
            Values(j,2) = value; %TimeNormalized_SUMUO6
            Values(j,3) =  timediff;% time difference between 6 hours and the next measurement.
            
        end
        j =j+1;
    end
end

% remove NaN and false
TFAvgUO = NewData(:,3) == 0;% keep only the patients that do not have AKI in the first six hours

NumberNaNUO = length(find(isnan(NewData(:,3))))


% get number of included and excluded
TrueUOIndices = find(TFAvgUO==1);
NumberMetUO = length(TrueUOIndices)

NumberDidNotMeetUO = length(AllRows) - NumberMetUO -NumberNaNUO %	Urine output (mL/kg/hr) for the first 6 hours < 0.5 ml/kg/hour  

GoodRowsTF = GoodRowsTF & TFAvgUO;
GoodRowsindices = find(GoodRowsTF == 1);



end

