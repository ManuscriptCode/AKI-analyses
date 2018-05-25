
TimeThresholdRange = [2:2:24];
CIlowlist = ones(1,12);
CIuplist = 3*ones(1,12);
pointEstlist = 2*ones(1,12);
pvalslist = 0.002*2*ones(1,12);


fig = figure();

pos = get(gcf, 'Position');
set(gcf, 'Position', [pos(1) pos(2) width*100, height*100]); %<- Set size
set(gca, 'FontSize', fsz);
for timeDurIndx = 1:12
    
    timeDur = TimeThresholdRange(timeDurIndx);
   

    CIlow = CIlowlist(timeDurIndx);
    pointEst  = pointEstlist(timeDurIndx);
    CIHigh = CIuplist(timeDurIndx);
    pvalue = pvalslist(timeDurIndx);
    
    
    plot(timeDur,CIlow, 'r*')
    hold on
    plot(timeDur,CIHigh, 'r*')
    plot(timeDur, pointEst, 'b+')
    plot([timeDur,timeDur],[CIHigh,CIlow],'g-')
    
end
xlabel('Time duration')
ylabel('CI and point estimate')
figName = ['CI low and high and point estimate for ',var ];
title(figName);
print(figName,'-dpng','-r300');



timeDur = 2;
CIlow = 2;
pointEst  = 3;
CIHigh = 5 ;
pvalue = 0.5;

close all
figure

[hax12, hline1, hline2] = plotyy([2:2:24],0*ones(1,12),[2:2:24],0*ones(1,12));
%set(hax12,'NextPlot','add')


hold(hax12(1))
plot(hax12(1),timeDur,CIlow, 'b*')
plot(hax12(1),timeDur,CIHigh, 'b*')
plot(hax12(1),timeDur, pointEst, 'b+')
plot(hax12(1),[timeDur,timeDur],[CIHigh,CIlow],'b-')

hold(hax12(2))
plot(hax12(2), timeDur,pvalue,'color',[0 0.5 0], 'LineStyle','o')

ylimits1 = [-1,7];
ylimits2 = [0,1];
set(hax12(1),'ylim',ylimits1);
set(hax12(1),'YTick',[ylimits1(1):0.5:ylimits1(2)])
set(hax12(2),'ylim',ylimits2); 
set(hax12(2),'YTick',[ylimits2(1):0.5:ylimits2(2)])



ylabel(hax12(1),'Point estimate and CI of variable coefficient')
ylabel(hax12(2),'p-value') % right y-axis
xlabel('Time duration')

title('Multiple Decay Rates')


