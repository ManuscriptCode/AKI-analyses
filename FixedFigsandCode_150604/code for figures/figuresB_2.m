%% To Fix:


clear all
clc
%% Needs: 
% varNames
% Plot properties
% TimeThresholdRange

% Get from models:

% pValsMat
% CIlowMat
% CoeffEstMat
% CIhighMat

%% Plot properties:
width = 4;% Width in inches
height = 4;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 12;%11;      % Fontsize
lw = 1.8; %1.5;      % LineWidth
msz = 8;       % MarkerSize

%% Load
load('varNames.mat');
load('TimeThresholdRange');
load('models_All_FludBal_noInOut_NoWHG');


%% Extracting values from 'models' because hadn't saved them seperately before 
empty =  NaN*ones(length(TimeThresholdRange),length(varNames));
pValsMat = empty;
CIlowMat = empty;
CoeffEstMat = empty;
CIhighMat = empty;


for controlInd = 2:length(varNames)+1
    controlIndCol = models(2:end,controlInd);
    
    for i = 1:length(controlIndCol)
        ting2 = controlIndCol{i}(2:end-1);
        ting3 = strsplit(ting2,',');
        
        CIlowMat(i,controlInd-1) = str2num(ting3{1});
        CoeffEstMat(i,controlInd-1) = str2num(ting3{2});
        CIhighMat(i,controlInd-1) = str2num(ting3{3});
        pValsMat(i,controlInd-1) = str2num(ting3{4});
    end
    
end

%% Plotting CI interval and point estimate of model coeff for each var and p-value

close all
for controlInd = 1:length(varNames)
    var = varNames{controlInd};
    fig = figure();
    
    pos = get(gcf, 'Position');
    set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
    set(gca, 'FontSize', fsz);
    
    [hax12, hline1, hline2] = plotyy([2:2:24],0*ones(1,12),[2:2:24],0*ones(1,12));  
    pValCurrent = pValsMat(:,controlInd);
    
    hold(hax12(2))
    plot(hax12(2), TimeThresholdRange,pValCurrent,'color',[0 0.5 0], 'LineStyle','o','LineWidth',lw )
    hold(hax12(1))
    for timeDurIndx = 1:12 % check of CI of 12th is within 
        
        timeDur = TimeThresholdRange(timeDurIndx);
        
        CIlowVal = CIlowMat(timeDurIndx,controlInd);
        CoeffEstVal = CoeffEstMat(timeDurIndx,controlInd);
        CIhighVal = CIhighMat(timeDurIndx,controlInd);
        
       
        plot(hax12(1),timeDur,CIlowVal, 'b*','LineWidth',lw )
        plot(hax12(1),timeDur,CIhighVal, 'b*','LineWidth',lw )
        plot(hax12(1),timeDur, CoeffEstVal, 'b+','LineWidth',lw )
        plot(hax12(1),[timeDur,timeDur],[CIlowVal,CIhighVal],'b-','LineWidth',lw )
          
        
    end
  
    ylimits1 = [min([CIlowMat(:,controlInd);0]),max([CIhighMat(:,controlInd);0])];
    ylimits2 = [min([pValsMat(:,controlInd);0]),max(pValsMat(:,controlInd))];
    set(hax12(1),'ylim',ylimits1);
    set(hax12(1),'YTick',[ylimits1(1):(ylimits1(2)-ylimits1(1))/10:ylimits1(2)])
    set(hax12(2),'ylim',ylimits2);
    set(hax12(2),'YTick',[ylimits2(1):(ylimits2(2)-ylimits2(1))/10:ylimits2(2)])
    set(hax12,'xlim',[1.5,24.5]);
    set(hax12,'XTick',TimeThresholdRange) 
    set(hax12,'FontSize',fsz)
   
    grid on
    ylabel(hax12(1),'Point Estimate and CI of Variable Coefficient')
    ylabel(hax12(2),'p-value', 'FontSize', fsz) % right y-axis
    xlabel('Time Duration (hours)')

    figName = ['Point Estimate and CI of Variable Coefficient and p-value for ',var ];
    
     
    %title(figName);
    print(figName,'-dpng','-r300'); 
    %print(figName,'-djpg','-r300'); 
    %print(figName, 'djpeg','-r300');
    
    %print('testjpeg','-djpeg','-noui')

  
    savefig(fig,[figName,'.fig']);
    close;
end

