clear all;

 %从excel中读取数据 
 data='77_20171021';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)把返回的数据与文本分开保存。
 lon=a(:,1);
 lat=a(:,2);
 speed=a(:,3);
 oren=a(:,4);
 
 %增添对日期和数字的处理 ，把数据划分为每一天
 time_wj0=txt(:,1);
 time_wj1=time_wj0(2:length(time_wj0));
 
 %首先筛除冗余点
 clearExtraData;

 time_wj2 = datenum(time_wj1, 'yyyy/mm/dd  HH:MM:SS');  %datenum用来将给定的日期字符串转换为日期数字。
 date= datestr(time_wj2,'yyyy-mm-dd');   %datestr是将日期和时间转换为字符串格式函数。
 time=datestr(time_wj2,'HH:MM:SS');
 %第一个尝试： 用正则表达式切割
 %S = REGEXP(time_wj1,'\s');
 
 %第二个尝试：char数组化，因为变量不等长而失败
 %time_wj2=char(time_wj1);
 %time_wj3=time_wj2(:,[1:2,4:5]);
 


 

start_end=[];
num_date=1;
numberOfElements = length(lon);
 for i=1:numberOfElements
   if(i==1)
      start_end(num_date)=1; 
   elseif (i==numberOfElements)
       num_date=num_date+1;
       start_end(num_date)=numberOfElements;
   elseif(strcmp(date(i,:),date(i-1,:)))  %strcmp字符串大小比较，前一天和后一天一样
          
  % elseif(~strcmp(date(i),date(i-1)))
   else                                  %第i天大于第i-1天，记录start_end[i]和start_end[i-1]分割两个不同的日期，start_end记录分界日的个数。
               num_date=num_date+1;
               start_end(num_date)=i-1; 
               num_date=num_date+1;
               start_end(num_date)=i; 
   end    
 end


 %计算每一天的作业亩数，分割，一天一次循环 
num_date=num_date/2;        %天数
area=cell(num_date,1);      %numdate行1列     
global area_each;           
t=1;
area_classify=zeros(num_date,1);   %zeros生成0矩阵，初始化数组，有多少块田
for i_date=1:num_date   %遍历数组每行，每天分别计算
    i1=i_date;         
 
    lon1=lon(start_end(i_date*2-1):start_end(i_date*2));  %分别存储每天的经纬度
    lat1=lat(start_end(i_date*2-1):start_end(i_date*2));
    speed1=speed(start_end(i_date*2-1):start_end(i_date*2));
    oren1=oren(start_end(i_date*2-1):start_end(i_date*2));
    time1=time(start_end(i_date*2-1):start_end(i_date*2),:);  %存储每天的时间
    date1=date(start_end(i_date*2-1):start_end(i_date*2),:);
    pts=struct('date',date1,'time',time1,'lon',lon1,'lat',lat1,'speed',speed1,'oren',oren1);
    
     %15年11月27日的数据是激光平地，可以通过速度中值、均值或者速度方差来看
     %测试数据中median(151212)=6  median(160411)=5   median(151127)=13 
    
    %subplot(3,2,i);scatter(lon1,lat1,10,speed1,'filled'); 
    %hold off;
    num_each=length(lon1);           
     if(num_each<30)
         area_classify(i1)=0;       
    continue;                       %当坐标点少于30时，直接给分类矩阵赋空值，不执行下方语句。
     end
     area_each='';          
      divide_farm;
      area_classify(i1)=1;      %标记深松和平地
    area{i1,1}=area_each;
    
  
     s1 = regexp(area_each, '\;', 'split') ;
     %标号
      s3 = regexp(s1(1), '\,', 'split') ; 
      %面积
       s2 = regexp(s1(2), '\,', 'split') ;
       
    date1=date(start_end(i_date*2-1),:);
   %datei= datestr(date1(1,:),'yyyy-mm-dd');
    datei= datestr(date1,'yyyy-mm-dd');
    [dim,num_excel]=size(s2{1,1});  %获取农田块数

  for k=2:num_excel        %第一个为空，有个，
      
      
        xlscell{t,1}=t;
        xlscell{t,2}=data;
        xlscell{t,3}=k-1;
        xlscell{t,4}=datei;
        wj=2*(k-1);
        s4=char(s3{1,1}(wj));      
        s5=char(s3{1,1}(wj+1));
        s6=str2num(s4);
        s7=str2num(s5);
        xlscell{t,5}=time1(s6,:);
        xlscell{t,6}=time1(s7,:);
        s8=char(s2{1,1}(k));
        xlscell{t,7}=s8;
        t=t+1;
      
  end
  
  
   
clear lon1;
clear lat1;
clear speed1;
clear oren1;
clear time1;

   
end
xlswrite('test_77_20171021.xlsx',xlscell)
% sum_shensong=0;
% sum_pingdi=0;
% sum_wj=0;
% for i=1:num_date
%     if(area_classify(i)==2)
%         sum_shensong=sum_shensong+area(i,1);
%     else
%         sum_pingdi=sum_pingdi+area(i,1);
%     end
% end
% sum_wj=sum_shensong+sum_pingdi;
% %展示图像
% %scatter(lon,lat,10,speed,'filled'); 
% %hold off;
