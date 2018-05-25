%% ToFix:
% How about reducing eavch of the colored lines into a single point, that is the closest to the J-Point.
% 
% You might play around with adding gridlines.
% 
% You should follow – making pretty plots tutorial online to adjust the text style and size. 
% 
% You might want to make the dashed middle line thicker and a color which does not conflict with one of the other lines.
% 
% Not v, volume
% 

clear all
clc
%% Needs:
% TimeThresholdRange
% AvgVolumeThresholdRange
% NewData
% Plot properties: Line width ...
%% Plot properties
global width height alw fsz lw msz;
width = 3;% Width in inches
height = 3;    % Height in inches
alw = 0.75;    % AxesLineWidth
fsz = 18;%11;      % Fontsize
lw = 2; %1.5;      % LineWidth
msz = 8;       % MarkerSize


%% Loading 
load('TimeThresholdRange');
load('AvgVolumeThresholdRange.mat');
load('NewData.mat');
numIndices = length(TimeThresholdRange) * length(AvgVolumeThresholdRange);

%% calculate the specificty and sensitivity for each TimeThreshold and AvgVolumeThreshold combo

Performance = NaN*ones(numIndices,10);% linear_index TimeThreshold AvgVolumeThreshold specificity sensitivity TN FP TP FN total
%row number =

colSub =0;
for TimeThreshold = TimeThresholdRange
    colSub = colSub +1;
    
    rowSub =0;
    for AvgVolumeThreshold = AvgVolumeThresholdRange
        rowSub=rowSub+1;
        
        % get Linear index / get column number
        linearInd = sub2ind([length(AvgVolumeThresholdRange),length(TimeThresholdRange)], rowSub, colSub);
        colNum = linearInd+2;
        
        % specify ICU
        %         %TFMatchesICU = (strcmp('MICU',ICUColumn) | strcmp('FICU',ICUColumn));
        %         TFMatchesICU = (strcmp('MICU',ICUColumn) | strcmp('FICU',ICUColumn));%strcmp('CCU',ICUColumn) ;
        %         RowsMatchingICU = find(TFMatchesICU==1);
        %         [CommonRows,ia,ib] = intersect(RowsMatchingICU,GoodRowsindices);
        
        % All
        
        % calculate confusion matrix
        [CM,order] = confusionmat(NewData(:,2),NewData(:,colNum));
        % calculate specificity = TN/(TN + FP)
        TN = CM(1,1);
        FP = CM(1,2);
        specificity = TN/(TN + FP);
        
        % calculate sensitivity = TP/(TP + FN)
        TP = CM(2,2);
        FN = CM(2,1);
        
        sensitivity = TP/(TP + FN);
        
        % TimeThreshold AvgVolumeThreshold specificity sensitivity TN FP TP FN
        Performance(linearInd,1) = linearInd;
        Performance(linearInd,2) = TimeThreshold ;
        Performance(linearInd,3) = AvgVolumeThreshold ;
        Performance(linearInd,4) = specificity ;
        Performance(linearInd,5) = sensitivity ;
        Performance(linearInd,6) = TN ;
        Performance(linearInd,7) = FP ;
        Performance(linearInd,8) = TP ;
        Performance(linearInd,9) = FN ;
        Performance(linearInd,10) = sum([TN,FP,TP,FN]);
        
        
        
    end
end

[ mins]  = findMinDistPoint( Performance, 30);
%save('PerformanceAllCombo.mat','Performance');

timesEvery2Indices =  find(Performance(:,2)==2|Performance(:,2)==4|Performance(:,2)==6|Performance(:,2)==8|Performance(:,2)==10|Performance(:,2)==12| Performance(:,2)==14| Performance(:,2)==16| Performance(:,2)==18| Performance(:,2)==20| Performance(:,2)==22| Performance(:,2)==24);
VolThr =[0 0.3 0.5 0.6 0.9]; %[0 0.3 0.4 0.5 0.7 0.9];
colorShape = {'yx-','kx-','gx-','rx-','bx-'};

figure(2);
pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz, 'LineWidth', alw); %<- Set properties

for j =  1: length(VolThr)
    indicesVol = find(Performance(:,3) <VolThr(j) + 0.01 &Performance(:,3)> VolThr(j) - 0.01);
    indxs = intersect(timesEvery2Indices,indicesVol);
    
    
    plot(1-Performance(indxs,4),Performance(indxs,5),colorShape{j},'LineWidth',lw,'MarkerSize',msz);%,Performance(:,1)) %scatter
    
    hold on
end

%AvgVolumeThresholdRange = [0: 0.1: 1];%rowSub
%TimeThresholdRange = [2,4,6,8,10,12,14,16,18,20,22,24];% colSub
ind6_pt5 = sub2ind([length(AvgVolumeThresholdRange),length(TimeThresholdRange)],6,3)
ind24_pt5 = sub2ind([length(AvgVolumeThresholdRange),length(TimeThresholdRange)],6,12)
ind2_pt5 = sub2ind([length(AvgVolumeThresholdRange),length(TimeThresholdRange)],6,1)
s = blanks(3)';
labels= [s,num2str(Performance([ind6_pt5,ind24_pt5,ind2_pt5],2)),s,num2str( Performance([ind6_pt5,ind24_pt5,ind2_pt5],3))];

H = text(1- Performance([ind6_pt5,ind24_pt5,ind2_pt5],4),Performance([ind6_pt5,ind24_pt5,ind2_pt5],5),labels); %Performance(:,1)

set(H,'fontsize', 14)

xlim([0,1])
ylim([0,1])
plot([0,1],[0,1],'LineStyle','--','Color',[0.5 0.5 0.5],'LineWidth',lw)
xlabel('1 - Specificity')
ylabel('Sensitivity')
legend({'Volume = 0','Volume = 0.3','Volume = 0.5','Volume = 0.6','Volume = 0.9','Linear'});

grid on
%title('ROC plots')
legend('Location', 'SouthEast');

print('ROC plots','-dpng','-r300');


% Labeling all points
% s = blanks(numIndices)';
% labels= [s,num2str(Performance(:,2)),s,num2str( Performance(:,3))];
% plot(1-Performance(:,4),Performance(:,5),'x');%,Performance(:,1)) %scatter
% text(1- Performance(:,4),Performance(:,5),labels); %Performance(:,1)
% xlabel('1 - specificity')
% ylabel('sensitivity')
%title('MICU + FICU');
%zlabel('Linear Index')


% Specificity
% Specificity=true negatives/(true negative + false positives)
% If a person does not have the disease how often will the test be negative (true negative rate)?
%In other terms, if the test result for a highly specific test is positive you can be nearly certain that they actually have the disease.

%Sensitivity
% If a person has a disease, how often will the test be positive (true positive rate)?
% % Put another way, if the test is highly sensitive and the test result is negative you can be nearly certain that they don’t have disease.
% A Sensitive test helps rule out disease (when the result is negative). Sensitivity rule out or "Snout"
% Sensitivity= true positives/(true positive + false negative)


