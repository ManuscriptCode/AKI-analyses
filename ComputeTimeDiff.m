function [ timeDiff ] = ComputeTimeDiff( firstTimeStr, StartTimeBelowThreshold, AKICrStartTime)
% Gets the time difference between the time the avg UO gets below the
% threshold and the time Cr rises.
% (Cr time  - UO time) /3600 : in hours

AKICrDateVect= datevec(AKICrStartTime,1915);% added this
firstTimeStrDateVect = datevec(firstTimeStr,1915);
AKICrFromfirstTimeStr = etime(AKICrDateVect,firstTimeStrDateVect);


timeDiff = (AKICrFromfirstTimeStr - StartTimeBelowThreshold )/3600;

end

