%wj=getdistance(39.227796,116.935564,39.227982,116.935547);



% X = [pts.lon,pts.lat];
X = [lon1,lat1];
minPts=8;
E=25;
P=X';       %����ת��
[C, ptsC] = dbscan(P, E, minPts);


% plot(X(:,1),X(:,2),'k.');
% hold on;
%plot(X(C{1,1}(1,:),1),X(C{1,1}(1,:),2),'r*',X(C{1,2}(1,:),1),X(C{1,2}(1,:),2),'b*');


[dim, num_farm] = size(C);
 k10=num_farm+1;           
 farm_index=max(ptsC)+1;
for i=1:num_farm
    if isequal(C{1,i},{})       %ũ���Ƿ�ɾ��
        continue;
    end
    c1=sort( C{1,i});         %c1�洢�����ĵ�i��ũ��ĵ� 
    C{1,i}=c1;
    c2=diff(c1);              %c2�洢���ڵ�ű�Ĳ�ֵ
    c3=find(c2>1);            %c3�洢���ڲ�ű�ֵ����1�ĵ�
   
    c4=length(c3);            %c4�洢c3���󳤶�
   
    for k9=c4:-1:1           %c4ÿִ��һ�μ�һ��ֱ��k9=1ִ�����һ��
        if(c2(c3(k9))>25)    %ǰ��ű�������25
            c5=c3(k9)+1;     
              [dim, c6] = size(C{1,i});  %��ǰũ��ĸ���
            C{k10}=C{1,i}(1,c5:c6);      %��c5Ϊ�磬�ѵ�ǰũ���ٻ���Ϊ2�飬�����ӵ�������֣����������
            C{1,i}(c5:c6)=[];            %��������ھ�����ɾ��
             ptsC(C{k10}(1,:))= farm_index;%����ÿ�����ũ����
             farm_index=farm_index+1;
            k10=k10+1;
        end
        
    end
    
end

%�����ѷָ��ũ���е����С��30�����
[dim, num_farm] = size(C);
num_extra=0;
isContain0=false;
for i=1:num_farm
    [dim2,n_eachfarm]=size(C{1,i});%n_eachfarm ��n��ũ��ĵ���
    if n_eachfarm<=30
      
      num_extra=num_extra+1;
      if i==num_farm
            ptsC(C{1,i}(1,:))=0;   %���һ��
      else
            ptsC(C{1,i}(1,:))=0;   %ũ��i���Ϊ��·
            for j=i+1:num_farm
                ptsC(C{1,j}(1,:))= ptsC(C{1,j}(1,:))-1;     %ũ��i+1���Ϊũ��i
            end
      end
             C{1,i}={};      %ũ��iɾ��
    end
    % index = find([C{1,i}{:}] == 0);    
    %�жϵ�ǰũ���Ƿ������һ���㣬ɸ��ճ���ʱ�ѻ��ĵ�
    if isContain0==false && ~isempty(C{1,i})  %�ж�ũ���Ƿ�Ϊ��  
        %�ж��Ƿ������һ����
    index = find(C{1,i}(1,:) == 1);
     if ~isempty(index)
         num_extra=num_extra+1;
         isContain0=true;
         %ͬ��ɾ��ũ�����
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


% ���ݼ���ĽǶ�ɸѡ��ͷ��
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

% �������нǶ�ɸѡ��ͷ��
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

global area_each;   %ȫ�ֱ������ַ���
 num_size=0;
[dim1, num_farm] = size(C);
for i=1:num_farm
    if isequal(C{1,i},{}) %�ж��Ƿ�Ϊ��
        continue;
    end
     [dim1, num_size] = size(C{1,i});  
   min1= C{1,i}(1);
   max1=C{1,i}(num_size);
     min2=num2str( min1);
     max2=num2str( max1);
     %�洢��ֹ��Ľű�
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
       area_ev(i,1)=distance_all * fukuan * 1000 * 0.0015;  %��ƽ����ת��ΪĶ
       area_1w=num2str( area_ev(i,1));
       %�ַ���ƴ��
       area_each=[area_each,','];
       area_each=[area_each,area_1w];  
   
end



scatter(lon1,lat1,10,ptsC,'filled'); 

   
