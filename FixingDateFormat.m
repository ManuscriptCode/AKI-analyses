function GoodDateFormat = FixingDateFormat(Dates)

s = length(Dates);
GoodDateFormat = cell(s+1,1);
GoodDateFormat{1} = 'CHARTTIME';
%% DD-MO-YY HH:MM:SS
for i = 1:s
    
    DD = Dates{i}(1:2);
    MO = Dates{i}(4:6);
    YY = Dates{i}(8:9);
    HH = Dates{i}(11:12);
    MM = Dates{i}(14:15);
    SS = Dates{i}(17:18);
    
    GoodDateFormat{i+1} = [DD '-' MO '-' YY ' ' HH ':' MM ':' SS];
    
    
end
    
end