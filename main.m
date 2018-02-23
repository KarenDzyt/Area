clear all;

 %��excel�ж�ȡ���� 
 data='77_20171021';
 data1=[data,'.xlsx'];
 [a,txt]=xlsread(data1); %[num, txt]= xlsread(filename, ...)�ѷ��ص��������ı��ֿ����档
 lon=a(:,1);
 lat=a(:,2);
 speed=a(:,3);
 oren=a(:,4);
 
 %��������ں����ֵĴ��� �������ݻ���Ϊÿһ��
 time_wj0=txt(:,1);
 time_wj1=time_wj0(2:length(time_wj0));
 
 %����ɸ�������
 clearExtraData;

 time_wj2 = datenum(time_wj1, 'yyyy/mm/dd  HH:MM:SS');  %datenum�����������������ַ���ת��Ϊ�������֡�
 date= datestr(time_wj2,'yyyy-mm-dd');   %datestr�ǽ����ں�ʱ��ת��Ϊ�ַ�����ʽ������
 time=datestr(time_wj2,'HH:MM:SS');
 %��һ�����ԣ� ��������ʽ�и�
 %S = REGEXP(time_wj1,'\s');
 
 %�ڶ������ԣ�char���黯����Ϊ�������ȳ���ʧ��
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
   elseif(strcmp(date(i,:),date(i-1,:)))  %strcmp�ַ�����С�Ƚϣ�ǰһ��ͺ�һ��һ��
          
  % elseif(~strcmp(date(i),date(i-1)))
   else                                  %��i����ڵ�i-1�죬��¼start_end[i]��start_end[i-1]�ָ�������ͬ�����ڣ�start_end��¼�ֽ��յĸ�����
               num_date=num_date+1;
               start_end(num_date)=i-1; 
               num_date=num_date+1;
               start_end(num_date)=i; 
   end    
 end


 %����ÿһ�����ҵĶ�����ָһ��һ��ѭ�� 
num_date=num_date/2;        %����
area=cell(num_date,1);      %numdate��1��     
global area_each;           
t=1;
area_classify=zeros(num_date,1);   %zeros����0���󣬳�ʼ�����飬�ж��ٿ���
for i_date=1:num_date   %��������ÿ�У�ÿ��ֱ����
    i1=i_date;         
 
    lon1=lon(start_end(i_date*2-1):start_end(i_date*2));  %�ֱ�洢ÿ��ľ�γ��
    lat1=lat(start_end(i_date*2-1):start_end(i_date*2));
    speed1=speed(start_end(i_date*2-1):start_end(i_date*2));
    oren1=oren(start_end(i_date*2-1):start_end(i_date*2));
    time1=time(start_end(i_date*2-1):start_end(i_date*2),:);  %�洢ÿ���ʱ��
    date1=date(start_end(i_date*2-1):start_end(i_date*2),:);
    pts=struct('date',date1,'time',time1,'lon',lon1,'lat',lat1,'speed',speed1,'oren',oren1);
    
     %15��11��27�յ������Ǽ���ƽ�أ�����ͨ���ٶ���ֵ����ֵ�����ٶȷ�������
     %����������median(151212)=6  median(160411)=5   median(151127)=13 
    
    %subplot(3,2,i);scatter(lon1,lat1,10,speed1,'filled'); 
    %hold off;
    num_each=length(lon1);           
     if(num_each<30)
         area_classify(i1)=0;       
    continue;                       %�����������30ʱ��ֱ�Ӹ�������󸳿�ֵ����ִ���·���䡣
     end
     area_each='';          
      divide_farm;
      area_classify(i1)=1;      %������ɺ�ƽ��
    area{i1,1}=area_each;
    
  
     s1 = regexp(area_each, '\;', 'split') ;
     %���
      s3 = regexp(s1(1), '\,', 'split') ; 
      %���
       s2 = regexp(s1(2), '\,', 'split') ;
       
    date1=date(start_end(i_date*2-1),:);
   %datei= datestr(date1(1,:),'yyyy-mm-dd');
    datei= datestr(date1,'yyyy-mm-dd');
    [dim,num_excel]=size(s2{1,1});  %��ȡũ�����

  for k=2:num_excel        %��һ��Ϊ�գ��и���
      
      
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
% %չʾͼ��
% %scatter(lon,lat,10,speed,'filled'); 
% %hold off;
