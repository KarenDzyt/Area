    %lon1=lon(start_end(i*2-1):start_end(i*2));
    %lat1=lat(start_end(i*2-1):start_end(i*2));
    %speed1=speed(start_end(i*2-1):start_end(i*2));
    %oren1=oren(start_end(i*2-1):start_end(i*2));
    %time1=time(start_end(i*2-1):start_end(i*2),:); 


%首先筛除冗余点,得到数据集a0
 numberOfElements_extra = length(lon);
 number_now=2;
 for i=2:numberOfElements_extra
   
   if(  lon(number_now)==lon(number_now-1) && lat(number_now)==lat(number_now-1)) 
        lon(number_now)=[];
        lat(number_now)=[];
        time_wj1(number_now)=[];
     %   speed(number_now)=[];
       oren(number_now)=[];
%         time(number_now,:)=[];
%         date(number_now,:)=[];

       number_now=number_now-1;
   end
   number_now=number_now+1;
    
end
   
