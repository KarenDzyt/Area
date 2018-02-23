%wj=getdistance(39.227796,116.935564,39.227982,116.935547);



% X = [pts.lon,pts.lat];
X = [lon1,lat1];
minPts=8;
E=25;
P=X';       %矩阵转置
[C, ptsC] = dbscan(P, E, minPts);


% plot(X(:,1),X(:,2),'k.');
% hold on;
%plot(X(C{1,1}(1,:),1),X(C{1,1}(1,:),2),'r*',X(C{1,2}(1,:),1),X(C{1,2}(1,:),2),'b*');


[dim, num_farm] = size(C);
 k10=num_farm+1;           
 farm_index=max(ptsC)+1;
for i=1:num_farm
    if isequal(C{1,i},{})       %农田是否被删除
        continue;
    end
    c1=sort( C{1,i});         %c1存储排序后的第i块农田的点 
    C{1,i}=c1;
    c2=diff(c1);              %c2存储相邻点脚标的差值
    c3=find(c2>1);            %c3存储相邻差脚标值大于1的点
   
    c4=length(c3);            %c4存储c3矩阵长度
   
    for k9=c4:-1:1           %c4每执行一次减一，直到k9=1执行最后一次
        if(c2(c3(k9))>25)    %前后脚标相差大于25
            c5=c3(k9)+1;     
              [dim, c6] = size(C{1,i});  %当前农田的个数
            C{k10}=C{1,i}(1,c5:c6);      %以c5为界，把当前农田再划分为2块，后续加点继续划分；新田提出来
            C{1,i}(c5:c6)=[];            %提出的田在旧田中删除
             ptsC(C{k10}(1,:))= farm_index;%更新每个点的农田编号
             farm_index=farm_index+1;
            k10=k10+1;
        end
        
    end
    
end

%处理已分割的农田中点个数小于30的情况
[dim, num_farm] = size(C);
num_extra=0;
isContain0=false;
for i=1:num_farm
    [dim2,n_eachfarm]=size(C{1,i});%n_eachfarm 第n块农田的点数
    if n_eachfarm<=30
      
      num_extra=num_extra+1;
      if i==num_farm
            ptsC(C{1,i}(1,:))=0;   %最后一块
      else
            ptsC(C{1,i}(1,:))=0;   %农田i标记为道路
            for j=i+1:num_farm
                ptsC(C{1,j}(1,:))= ptsC(C{1,j}(1,:))-1;     %农田i+1标记为农田i
            end
      end
             C{1,i}={};      %农田i删除
    end
    % index = find([C{1,i}{:}] == 0);    
    %判断当前农田是否包含第一个点，筛查刚出发时堆积的点
    if isContain0==false && ~isempty(C{1,i})  %判断农田是否为空  
        %判断是否包含第一个点
    index = find(C{1,i}(1,:) == 1);
     if ~isempty(index)
         num_extra=num_extra+1;
         isContain0=true;
         %同上删除农田操作
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


% 根据计算的角度筛选调头点
% [dim2, num_farm] = size(C);
%  for i=1:num_farm
%     if isequal(C{1,i},{}) 
%         continue;
%     end
%        [dim3, num_size] = size(C{1,i});
%         deta_oren = [];
%        deta_oren(1) = getorentation(lat1(2),lon1(2),lat1(1),lon1(1));
%        for k=2:num_size
%            deta_oren(k) = getorentation(lat1(k),lon1(k),lat1(k-1),lon1(k-1)) ;
%            deta_o(k-1) = abs(deta_oren(k)-deta_oren(k-1));
%            if  deta_o(k-1) >135
%                ptsC(C{1,i}(k-1))=0;  
%            end     
%        end
%  end

% 根据已有角度筛选调头点
% [dim2, num_farm] = size(C);
%  for i=1:num_farm
%     if isequal(C{1,i},{}) 
%         continue;
%     end
%        [dim3, num_size] = size(C{1,i});
%        deta_oren = [];  
%        for k=2:num_size
%            deta_oren(k-1) = abs(oren1(k)-oren1(k-1)) ;
%            if  deta_oren(k-1) >20 
%                ptsC(C{1,i}(k-1))=0;  
%            end     
%        end
%  end

global area_each;   %全局变量是字符串
 num_size=0;
[dim1, num_farm] = size(C);
for i=1:num_farm
    if isequal(C{1,i},{}) %判断是否为空
        continue;
    end
     [dim1, num_size] = size(C{1,i});  
   min1= C{1,i}(1);
   max1=C{1,i}(num_size);
     min2=num2str( min1);
     max2=num2str( max1);
     %存储起止点的脚标
   area_each=[area_each,',',min2,',',max2];  
   
end
area_each=[area_each,';'];

fukuan=1;
 area_ev=zeros(num_farm,1); 
 for i=1:num_farm
    if isequal(C{1,i},{}) 
        continue;
    end
    distance_all=0;
       [dim1, num_size] = size(C{1,i});
       for k=2:num_size
       wj_distance=getdistance( lat1(C{1,i}(k)), lon1(C{1,i}(k)),lat1(C{1,i}(k-1)),lon1(C{1,i}(k-1)));        
         distance_all=distance_all+wj_distance;    
       end   
       area_ev(i,1)=distance_all * fukuan * 1000 * 0.0015;  %把平方米转化为亩
       area_1w=num2str( area_ev(i,1));
       %字符串拼接
       area_each=[area_each,','];
       area_each=[area_each,area_1w];  
   
end



scatter(lon1,lat1,10,ptsC,'filled'); 

   
