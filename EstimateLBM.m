function [ EstimatedLBMs ] = EstimateLBM()

% Using first weight to be consistent

global data;
ICUSTAYIDS = data.ICUSTAY_ID;
EstimatedLBMs = NaN*ones(length(ICUSTAYIDS),1);

for indx = 1:length(ICUSTAYIDS)
    
    W = data(indx,'FIRST_WEIGHT').FIRST_WEIGHT;
    H = data(indx,'HEIGHT').HEIGHT;
    G = data(indx,'GENDER').GENDER;
    
    if strcmpi(G,'F') % case insensitive
        %women : LBM =( 0.29569 * W) + (0.41813 * H) - 43.2933
        EstimatedLBMs(indx) = ( 0.29569 * W) + (0.41813 * H) - 43.2933;
    elseif strcmpi(G,'M')
        %men : LBM = (0.32810 * W) + (0.33929 * H) - 29.5336
        EstimatedLBMs(indx) = (0.32810 * W) + (0.33929 * H) - 29.5336;

    else % gender = NaN; 
        EstimatedLBMs(indx) = NaN;
        
    
    end
end

end

