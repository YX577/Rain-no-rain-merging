function [wei,m] = CTC_M(Y,thres,n)
% Coded by Jianzhi Dong, September, 2020.
% Y: a triplet of independent precipitation time series
% rain/no-rain threshold
% n: merging factor
% algorithm details are shown in https://doi.org/10.1175/JHM-D-20-0097.1

% no-rain days are assigned as -1, and rain days are assigned as 1.
k = find(Y<=thres); Y(k) = -1;  k = find(Y>thres); Y(k) = 1;
% revmove days with data gaps
y = Y; k = find(isnan(y(:,1))|isnan(y(:,2))|isnan(y(:,3)) ); y(k,:) = [];


Q = cov(y); % equations 3 to 5 in https://doi.org/10.1175/JHM-D-20-0097.1
v = [(Q(1,2)*Q(1,3)/Q(2,3));
    (Q(1,2)*Q(2,3)/Q(1,3));
    (Q(2,3)*Q(1,3)/Q(1,2))]; % equations 6 to 8

v = sqrt(abs(v)).^n;
wei = v./sum(v); % merging weigths, equation 12

% merging the rain/no-rain time series, equation 9
m = Y*wei;
k = find(m<=0); m(k) = -1;  ec = Y(:,1); ec(k) = -1;
k = find(m>0); m(k) = 1;



