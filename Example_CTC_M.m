clear

load Rain_no_rain_data
% e: ERA-Interim; s: SM2Rain; t: TRMM; obs: EOBS, used as a reference

% step 1: convert raw data into rain/no-rain time series
thres = 0.5; % rain/no-rain thresholds, can be change to other thresholds
n = 1.5; % merging factor, 1.5 is recommended. See https://doi.org/10.1175/JHM-D-20-0097.1
Y = [e' s' t'];

% call CTC_M, wei is the weights and m is the merged product
[wei,m] = CTC_M(Y,thres,n);


%% A simple comparison of CTC-M and ETA-Interim
dates = datenum(2007,1,1):datenum(2015,6,30);

merged = m; k = find(merged <0); merged(k) = nan; 
k = find(merged >0); merged(k) = 0; 
merged2 = m; k = find(merged2 >0); merged2(k) = nan; 
k = find(merged2 <0); merged2(k) = 0; 



close all
figure
width=9
height=3
set(gcf,'position',[10 10 width*100 height*100])

hh = bar(dates,obs,'k'); hold on
hh.FaceColor = [1 1 1]*0.75; hh.EdgeColor = 'k';
hold on
l1 = plot(dates,e,'k','linewidth',2);
hold on

hold on
l2 = plot(dates,merged,'bo','linewidth',2,'markersize',2);
l3 = plot(dates,merged2,'ro','linewidth',2,'markersize',2);


set(gca,'xtick',[dates(1):3:dates(end)])
datetick('x','mm/dd','keepticks')
xlim(dates([1310 1355])); ylim([0 40])
grid on
ylabel('mm/day')
L = legend([hh,l1,l2,l3],'EOBS','ERA','CTC-M: rain','CTC-M: no-rain')

title('Grid cell centered at 49^oN, 11.125^oE (Germany)')











