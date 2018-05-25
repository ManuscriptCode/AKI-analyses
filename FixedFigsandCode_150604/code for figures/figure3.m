%% To fix
% Add additional tickmarks on the x axis (with/without nmbers) look at it
% and see what looks better. : done
% 
% Add some Grid lines,: done
% make the text pretty, etc. : done
% 
% Remove the title :done
% 
% Explain in the figure legend exactly how they should interpret the plot.
% For example:  done
% 
% The red dot, illustrate the standard blah blah blah
%% Plot properties
width = 3;% Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 18;%11;      % Fontsize
lw = 3; %1.5;      % LineWidth
msz = 8;       % MarkerSize

%% Needs: 
% models
%TimeThresholdRange
% Plot properties

%% Load
load('TimeThresholdRange');
load('models_All_FludBal_noInOut_NoWHG');

%% Plot AUC, circle t = 6hrs;
AUCvals = cell2mat(models(2:end,10));
fig = figure();   
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); 
set(gca, 'FontSize', fsz);

plot(TimeThresholdRange,AUCvals,'x-','LineWidth',2)
hold on;
plot(TimeThresholdRange(3),AUCvals(3),'go','LineWidth',4);
xlabel('Length of Urine Output Window (hours)');
ylabel('AUC');  
figName = ('GEE - AUC vs time');
set(gca,'XTick',TimeThresholdRange) 
grid on 
%title(figName)
print(['Fig3_',figName],'-dpng','-r300');

close all;