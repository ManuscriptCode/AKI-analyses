function [ numMeasAll,numMeas6hoursAll, timeIntervalsAll, timeIntervals6hoursAll] = filterAndPreprocessing_analysis()
% add MAP and totalBal here

width = 3;     % Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize
lw = 1.5;      % LineWidth
msz = 8;       % MarkerSize


% apply filtering criterions and return list of indices that satisfy them
%% using 'datawithmin.mat'
global data urineDataChosen;

% remove that later
AllRows = 1:size(data,1);

%% Intersection of datasets
% number of ICUs in urineDataChosen.
' number of ICUs in urineDataChosen'
length(unique(urineDataChosen.ICUSTAY_ID))

% number of ICUs in data
'number of ICUs in data should be 22372'
[C,IA,IC] = unique(data.ICUSTAY_ID);
repeatedIndices = setdiff(AllRows,IA);
length(C)


% number of Unique subject IDs in urineDataChosen.
'number of Unique subject IDs in urineDataChosen.'
length(unique(urineDataChosen.SUBJECT_ID))

% number of Unique Subject IDs in data.
'number of Unique Subject IDs in data.'
length(unique(data.SUBJECT_ID))

% number of ICUs in common
'number of ICUs in common'
[c1,ia1,ib1] = intersect(unique(data.ICUSTAY_ID),unique(urineDataChosen.ICUSTAY_ID));
length(c1)

% number of Subject IDs in common
'number of Subject IDs in common'
[c1,ia1,ib1] = intersect(unique(data.SUBJECT_ID),unique(urineDataChosen.SUBJECT_ID));
length(c1)

% number of ICU and Subject IDs in common.
'number of ICU and Subject IDs in common.'

SUBJECT_IDindx = 1;
ICUSTAY_IDindx =2;

SUBJECT_ID_COL = cell2mat(ConvertToCell(data,SUBJECT_IDindx,AllRows));

ICUSTAY_ID_COL = cell2mat(ConvertToCell(data, ICUSTAY_IDindx,AllRows));

AllrowsUrine = 1: size(urineDataChosen,1);
UrineDataSubjectCol = cell2mat(ConvertToCell(urineDataChosen, 1,AllrowsUrine));
UrineDataICUColumn = cell2mat(ConvertToCell(urineDataChosen, 2,AllrowsUrine));
UrineSubjectICU = [UrineDataSubjectCol UrineDataICUColumn];

%countCommonBothICUANDSubject = 0;

numMeasAll = NaN*ones(21693 ,1);
numMeas6hoursAll = NaN*ones(21693 ,1);
timeIntervalsAll = NaN*ones(0,0);
timeIntervals6hoursAll = NaN*ones(0,0);

% stopped here
i = 1;
for SubjectID = unique(SUBJECT_ID_COL') % in data SUBJECT_ID_COL 
    % find ICU IDs for subject ID
    indixesSubjectID = find(SUBJECT_ID_COL(:,1) == SubjectID );
    for IcuID = ICUSTAY_ID_COL(indixesSubjectID,1)' 
        % find all the rows of urineDataChosen that have the SubjectID and ICUID
                
        FoundSubjectAndICUIdxs = find((UrineSubjectICU(:,1) == SubjectID) &(UrineSubjectICU(:,2) == IcuID) ) ;
        
        if ~isempty(FoundSubjectAndICUIdxs)
            Subdata = urineDataChosen(FoundSubjectAndICUIdxs,:);
            [ numMeas, numMeas6hours, timeIntervals, timeIntervals6hours ] = TestingsOfPatientsAndIsUOFirst6hoursMeeting( Subdata );
            numMeasAll(i) = numMeas;
            numMeas6hoursAll(i) = numMeas6hours;
            timeIntervalsAll = [timeIntervalsAll;timeIntervals];
            timeIntervals6hoursAll = [timeIntervals6hoursAll;timeIntervals6hours];
            
            
            %countCommonBothICUANDSubject = countCommonBothICUANDSubject+1;
            % get histogram of number of meaurements
            % get histogram of number of measurements in the first six
            % hours
            % get histogram of time intervals
            % get hitogram of time intervals in the first six hours.
            
        end
        i = i+1;
    end
end

%% make histograms
% number of measurements in the first 6 hours
figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hist(numMeas6hoursAll)
xlabel('Number of measurements in the first six hours');
ylabel('Count')
title('Histogram of the number of measurements in the first six hours');
print('Histogram of the number of measurements in the first six hours','-dpng','-r300');

% number of measurements in the entire ICU stay
figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hist(log10(numMeasAll),100)
xlabel('Number of measurements in the entire ICU stay - log10');
ylabel('Count')
title('Histogram of the number in the entire ICU stay');
print('Histogram of the number in the entire ICU stay','-dpng','-r300');

% time interval between measurements in the first 6 hours
figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hist(timeIntervals6hoursAll)
xlabel('Time interval between measurements in the first 6 hours');
ylabel('Count')
title('Histogram of the time intervals between measurements in the first 6 hours');
print('Histogram of the time intervals between measurements in the first 6 hours','-dpng','-r300');


% Time interval between measurements throughout the ICU stay

figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hist(timeIntervalsAll(find(timeIntervalsAll<50)),100)
%xlim([0,50])
xlabel('Time interval between measurements throughout the ICU stay');
ylabel('Count')
title('Histogram of the time interval between measurements throughout the ICU stay');
print('Histogram of the time interval between measurements throughout the ICU stay','-dpng','-r300');



end

