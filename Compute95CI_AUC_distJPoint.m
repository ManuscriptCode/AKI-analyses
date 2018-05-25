function [CIAUC, CIdistJpoint] = Compute95CI_AUC_distJPoint(GoldValid,pihat,nboot, alpha)

% alpha is in percent
%e.g: CI = 95 %, alpha = 5 

AUCboots = NaN*ones(nboot,1);
distJpointBoots = NaN*ones(nboot,1);

parfor boot=1:nboot
   goldBootIndices = randsample(1:length(GoldValid),length(GoldValid),'true');
   pihatBootIndices = randsample(1:length(pihat),length(pihat),'true');
   GoldValidBoot = GoldValid(goldBootIndices);
   pihatBoot = pihat(pihatBootIndices);

   [XBoot,YBoot,TBoot,AUCBoot] = perfcurve(GoldValidBoot,pihatBoot,[2]); %% Probabilty or True, T = thresholds, X, Y : 1- spec , sens?
    AUCboots(boot)= AUCBoot;
   distJpointBoots(boot) = nanmin(sqrt((XBoot-0).^2  + (YBoot-1).^2));
        
      
end
 
% 95 % CI

CIAUC  = prctile(AUCboots,[alpha/2 (100-alpha/2)]);
CIdistJpoint = prctile(distJpointBoots,[alpha/2 (100-alpha/2)]); 
end
