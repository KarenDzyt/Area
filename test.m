%wj=getdistance(39.227796,116.935564,39.227982,116.935547);



%X = [pts.lon,pts.lat];
X = [lon1,lat1];
minPts=8;
E=25;
P=X';
[C, ptsC] = dbscan(P, E, minPts);


% plot(X(:,1),X(:,2),'k.');
% hold on;
%plot(X(C{1,1}(1,:),1),X(C{1,1}(1,:),2),'r*',X(C{1,2}(1,:),1),X(C{1,2}(1,:),2),'b*');
[dim1, num_farm] = size(C);
num_extra=0;
isContain0=false;
for i=1:num_farm
    [dim2,n_eachfarm]=size(C{1,i});
    if n_eachfarm<=30
      
      num_extra=num_extra+1;
      if i==num_farm
            ptsC(C{1,i}(1,:))=0; 
      else
            ptsC(C{1,i}(1,:))=0;
            for j=i+1:num_farm
                ptsC(C{1,j}(1,:))= ptsC(C{1,j}(1,:))-1;
            end
      end
             C{1,i}={};
    end
    % index = find([C{1,i}{:}] == 0);
    if isContain0==false && ~isempty(C{1,i})
        
    index = find(C{1,i}(1,:) == 1);
     if ~isempty(index)
         num_extra=num_extra+1;
         isContain0=true;
      if i==num_farm
            ptsC(C{1,i}(1,:))=0; 
      else
            ptsC(C{1,i}(1,:))=0;
            for j=i+1:num_farm
                ptsC(C{1,j}(1,:))= ptsC(C{1,j}(1,:))-1;
            end
      end
             C{1,i}={};
         
     end
    end
         
    
    
end

global area_each;
 C_num =zeros(1,num_farm);
% t=0;
 num_size=0;
for i=1:num_farm
    if isequal(C{1,i},{})
      %  t=t+1;
        continue;
    end
    c1=sort( C{1,i});
    c2=diff(c1);
    c3=max(c2);
    [dim1, num_size] = size(c1);
    if c3>=60
        c4 = find(c2 == c3);    
        if num_size-c4>c4
            c1(1:c4)=[];
        else
            c1(c4:num_size)=[];
        end
        
    end 
     [dim1, num_size] = size(c1);
   % t=t+1;
     % C_num(t) = num_size; 
   min1=c1(1);
   max1=c1(num_size);
     min2=num2str( min1);
     max2=num2str( max1);
   area_each=[area_each,',',min2,',',max2];
   
end
area_each=[area_each,';'];

%===========计算幅宽,计算点数最多的农田的  线与线之间的距离 ，去掉最大值最小值，求平均
%  Index = find(C_num ==  max(C_num)); 
%  Pnt_farm=sort(C{1,Index});
%    min1=Pnt_farm(1);
%    [dim,dim1]=size(Pnt_farm);
%    max1=Pnt_farm(dim1);
%     oren_eachfarm=oren1(min1:max1);
%     lat_eachfarm=lat1(min1:max1);
%     lon_eachfarm=lon1(min1:max1);
%     mode(oren_eachfarm);   %取到众数
    %==============存放线段里的 点 
% %line1
% x1=lat_eachfarm(242:258);
% y1=lon_eachfarm(242:258);
%  p=polyfit(x1,y1,1); 
% 
% %line2
% x2=lat_eachfarm(262:280);
% y2=lon_eachfarm(262:280);
%  p=polyfit(x2,y2,1); 
% 
% %line3
% x3=lat_eachfarm(283:301);
% y3=lon_eachfarm(283:301);
%  p=polyfit(x3,y3,1); 
% %line4
% x4=lat_eachfarm(303:311);
% y4=lon_eachfarm(303:311);
%  p=polyfit(x4,y4,1); 
% 
%  d=abs(113.9666-113.7548)/sqrt(0.2114*0.2114+1);
% 
% 
% d = abs(det([Q2-Q1,P-Q1]))/norm(Q2-Q1);



fukuan=1;
numberOfElements_each=length(lon1);
 area_ev=zeros(num_farm-num_extra,1);

  for wj1=1:num_farm-num_extra 
      distance_all=0;
   for j=2:numberOfElements_each       
        if(ptsC(j)==ptsC(j-1) &&ptsC(j)==wj1)      
         wj_distance=getdistance( lat1(j), lon1(j),lat1(j-1),lon1(j-1));        
         distance_all=distance_all+wj_distance;
        end 
   end
   area_ev(wj1,1)=distance_all * fukuan * 1000 * 0.0015;
   area_1w=num2str( area_ev(wj1,1));
   area_each=[area_each,','];
   area_each=[area_each,area_1w];
  end




scatter(lon1,lat1,10,ptsC,'filled'); 
scatter(lon,lat,10,ptsC,'filled'); 

   

