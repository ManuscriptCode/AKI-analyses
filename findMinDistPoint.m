function [ mins]  = findMinDistPoint( Performance, k)
% returns the rows of the k points with min distances.
% k is the number of minimum values.
WantedSpecificity = 1;
WantedSensitivity = 1;

Specificity = Performance(:,4);
Sensitivity = Performance(:,5);

Distances = sqrt((WantedSpecificity - Specificity).^2 + (WantedSensitivity - Sensitivity).^2);
v = Distances;
D = [Performance Distances];
[v, ix] = sort(v);      % sort it, and remember the permutation
%mins = Distances(ix(1:k),:);
mins = D(ix(1:k),:);

end

