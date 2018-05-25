function [] = ConfusionMatrixInfo( CM )

a = CM(1,1); 
b = CM(1,2);
c = CM(2,1);
d = CM(2,2);

% Sensitivity =  a/(a+c)
Sensitivity = a/(a+c)
% Specificity = d/(b+d)
Specificity = d/(b+d)
% Positive predictive value (PPV) = a/(a+b)
PPV = a/(a+b)
% Negative predictive value (NPV) = d/(c+d)
NPV =  d/(c+d)
% Accuracy =  (a+d)/t
t = a + b + c + d;
Accuracy =  (a+d)/t

% X2
% P-value
[Pvalue,x2] = chisquarecont(CM)


end

