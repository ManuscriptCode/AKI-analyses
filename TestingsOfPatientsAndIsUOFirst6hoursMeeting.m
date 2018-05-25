function [ numMeas, numMeas6hours, timeIntervals, timeIntervals6hours ] = TestingsOfPatientsAndIsUOFirst6hoursMeeting( Subdata )
% Getting data for histograms about the people

a = Subdata(:,3);
b = dataset2cell(a);
c = b(2:end);

Dates = c;%ConvertToCell(Subdata,3,:);
DateVects= datevec(Dates,1915);% changed
Times = zeros(size(DateVects,1),1);

for i = 1:size(DateVects,1)
    Times(i,1) = etime(DateVects(i,:),DateVects(1,:)); % seconds integer numbers indices of times
end

numMeas = length(Times);


% Times is in seconds 
diffTimes = diff(Times)/3600; % difference between each time point and the previous starting from the second.
timeIntervals = diffTimes;

StartTime = 0;%3600; 
CutOff6hrs= StartTime + 6*3600;

% indices of times that fall within the time frames
indices6 = find ((StartTime <= Times) & (Times <= CutOff6hrs) );% changed from < to <=: 14/01/13

numMeas6hours = length(indices6);

timeIntervals6hours = diffTimes(indices6(1:end-1));


end