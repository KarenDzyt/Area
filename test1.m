 

% clear all;
% 
% wj=getdistance(39.227796,116.935564,39.227982,116.935547);
% 
% 
% wj1=getdistance(39.227800,116.935564,39.227982,116.935564);
% 
% wj2=getdistance(39.227900,116.935564,39.227982,116.935564);

X = [pts.lon,pts.lat];
%X = [randn(20,2)+ones(20,2); randn(20,2)-ones(20,2)];
minPts=4;
E=20;
P=X';
% [C, ptsC, centres] = dbscan(P, E, minPts,pts.time);
  num1=datenum(pts.time(5,:),'HH:MM:SS');
                 num2=datenum(pts.time(20,:),'HH:MM:SS');
                 a=abs(num1-num2)/6.9444e-004;
                 if a<21
                     chegong='³É¹¦';
              msgbox(chegong);  
                 end

%scatter(pts.lon,pts.lat,10,ptsC,'filled')