% 
% Dates = creatinine.charttime;
% GoodDateFormat = FixingDateFormat2(Dates);
% B = cell2dataset(GoodDateFormat);
% creatinine = table2dataset(creatinine);
% creatinine.charttime = B.CHARTTIME;


%% AKICr = True, AKIuo = True; ICU ID = 10
global creatinine urineDataChosen
plotUOCr( 10, 104, 1.4 )

%% AKICr = True, AKIuo = False; ICU ID = 4

plotUOCr( 4, 96.8, 1.3 )

%% AKICr = False, AKIuo = True; ICU ID = 19
plotUOCr( 19, 68, 0.7 )

%% AKICr = False, AKIuo = False; ICU ID = 5

plotUOCr( 5, 53, 0.4 )



