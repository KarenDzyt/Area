clear all;

 %从excel中读取数据 
 data='jinsui00800602';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1);
 lon=a(:,1);
 lat=a(:,2);

num=length(lon);
% for i=1:num
%     for j=1:num
%         if i~=j
%             distance=getdistance(lat(i),lon(i),lat(j),lon(j));
%             xlscell{i,j}=distance*1000;
%         else
%             xlscell{i,j}=0;
%         end
%     end
% end
% xlswrite('getdata.xlsx',xlscell)

Data=zeros(num,num);
  for i=1:num
    for j=1:num
        if i~=j
            distance=getdistance(lat(i),lon(i),lat(j),lon(j));
            Data(i,j)=distance*1000;
        else
            Data(i,j)=0;
        end
    end
end
  
 
 
  arr_max=max(Data);
  arr_max1=max(arr_max);
  if mod(arr_max1,10)==0
      edges_max=fix(arr_max1/10);
  else
        edges_max=fix(arr_max1/10)+1;
  end
  edges_max=edges_max*10;
  edges=0:1:500;
%   y=hist(Data(20,:))

n=zeros(num,length(edges));
n1=zeros(num,length(edges));

 for k=1:num  
            
      wj1=sort(Data(k,:));  
      Data(k,:)=wj1;
      [n(k,:),bin]=histc(wj1,edges);
      for j=1:500
          n1(k,j)=sum(n(k,1:j));
      end
 end
  
 
xlswrite('getdata.xlsx',n1);