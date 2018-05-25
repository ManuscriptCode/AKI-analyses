function [] = Histograms( Values )
%Values(j,3) % time difference between 6 hours and the next measurement.
%Values(j,2)  %TimeNormalized_SUMUO6
global width height alw fsz lw msz;

%%
'Histogram of the time difference between the 6 hour time threshold and the next measurement'

figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
hist(Values(:,3)/3600, 1000)
xlim([0,50])
xlabel('Time difference between the six hour threshold and the next measurement');
ylabel('Count')
title('Histogram of the time difference between the six hour threshold and the next measurement');
print('Histogram of the time difference between the six hour threshold and the next measurement','-dpng','-r300');

close all
%%


'Histogram  of the time and weight normalized urine output in the first six hours'

figure()
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties
rows = Values(:,2)<Inf;
hist(Values(rows,2),10000)
xlim([0,10])
xlabel('Urine output (mL/kg/hr) in the first six hours');
ylabel('Count')

hold on 
line([0.5 0.5],[0,1200],'Color','red');
text(0.5,-50,'0.5')
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

title('Histogram of urine output (mL per kg per hr) in the first six hours');
print('Histogram of urine output (mL per kg per hr) in the first six hours','-dpng','-r300');

end

