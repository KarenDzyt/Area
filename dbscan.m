%�㷨����
%�ڱ��㷨�У����������ѭ���ǽ����е���б���
%�ڱ���ʱ�������ж�ĳһ�㣬�Ƿ�Ϊ���ģ������ǣ�������Ϊ������
%���ǣ�������뵽C�У���������б�ǣ�1,2,3��������ȡ�Ѳ�ͬ�Ĵأ���������뷶Χ�ڵĵ���뵽neighbourPts��
%����
%��neighbourPtsÿ������б�������δ�����ʣ�������о����ж��������䷵��ֵ���뵽neighbourPts��
%���ж��õ��Ƿ񱻼��뵽C�У���û�У�������뵽C�У����ҽ������cluster ��ǣ�
%
function [C, ptsC] = dbscan(P, E, minPts)
     
    [dim, Npts] = size(P);       %dim=������2����Npts=������������    
     
    ptsC  = zeros(Npts,1);   %�洢���е��ũ���ŵľ���
    %C�������ϸ�����飬���е�ÿһ��Ԫ�����ʴ�С���ɲ�ͬ
    C     = {};              % C��cell���ͣ��洢C{1��1}�洢��һ��������е㣬�洢C{1��2}�洢�ڶ���������е�
    Nc    = 0;               % Cluster counter. ��N����
    Pvisit = zeros(Npts,1);  % Array to keep track of points that have been visited.
     
    for n = 1:Npts
       if ~Pvisit(n)                            % If this point not visited yet��~ �߼��� 
           Pvisit(n) = 1;                       % mark as visited

            
           %�����Ե�n������Ϊ���ĵľ���ΪE��Բ���ڵ�����
           neighbourPts = regionQuery(P, n, E); % and find its neighbours
 
           if length(neighbourPts) < minPts  % Not enough points to form a cluster
               %����������������ú������Ϊ������
               ptsC(n) = 0;                    % Mark point n as noise.
            
           else                % Form a cluster...
               %��Ƿ������������
               Nc = Nc + 1;    % Increment number of clusters and process
                               % neighbourhood.
               %���ú��ĵ���뵽C�У�Ncũ����
            
               C{Nc} = [n];    % Initialise cluster Nc with point n
              %��ע�õ����ĸ����ĵ��ܶȿɴ�õ�����cluster Nc  ���洢Nc�е����е�
               ptsC(n) = Nc;   % and mark point n as being a member of cluster Nc.��Ǹõ��ũ����
                
               ind = 1;        % Initialise index into neighbourPts array.
                
               %���Ե�n������Ϊ���ĵĵ����Χ�ĵ�����б�
                
               % For each point P' in neighbourPts ...
               %�ô�Ϊһ�����㷨֪������صĵ�ȫ��������ȫΪֹ�����ҵ�һ��������������еĵ㣬�ٰѵڶ��������������еĵ������һֱ����������
               while ind <= length(neighbourPts)
                    
                   nb = neighbourPts(ind);
                  
                    %���õ�û�б����ʣ��ͽ���ͬ���б� 
                   if ~Pvisit(nb)        % If this neighbour has not been visited
                       Pvisit(nb) = 1;   % mark it as visited.
                        
                       % Find the neighbours of this neighbour and if it has
                       % enough neighbours add them to the neighbourPts list
                       neighbourPtsP = regionQuery(P, nb, E);  %�洢nb��������ڵĵ�
                       if length(neighbourPtsP) >= minPts
                           neighbourPts = [neighbourPts  neighbourPtsP];    %��֮ǰ�ĵ���¼���ĵ����һ��
                       end
                   end            
                    
                   % If this neighbour nb not yet a member of any cluster add it
                   % to this cluster.
                   %��������û�н��б�ע���������Ž�C�����ұ�������ڵ�cluster �ı��
                   if ~ptsC(nb)  
                       C{Nc} = [C{Nc} nb];
                       ptsC(nb) = Nc;
                   end
                    
                   ind = ind + 1;  % Increment neighbour point index and process
                                   % next neighbour
               end
           end
       end
    end
     
    % Find centres of each cluster
    %������������������������������������������
    %����һ����C������ȴ�С��������ά��Ϊdim
%     centres = zeros(dim,length(C));
%     for n = 1:length(C)
%         for k = 1:length(C{n})
%             centres(:,n) = centres(:,n) + P(:,C{n}(k));
%         end
%         centres(:,n) = centres(:,n)/length(C{n});
%     end
 
end % of dbscan    
     
%------------------------------------------------------------------------
% Find indices of all points within distance E of point with index n
% This function could make use of a precomputed distance table to avoid
% repeated distance calculations, however this would require N^2 storage.
% Not a big problem either way if the number of points being clustered is
% small.   For large datasets this function will need to be optimised.
 
% Arguments:
%              P - the dim x Npts array of data points  ����
%              n - Index of point of interest           ��Ȥ������
%              E - Distance threshold                   ������
 
%�ú������ص���ÿ����֤һ�����ʱ���жϸõ��ǲ��Ǿ������ڵģ����ص������е��λ��
 
function neighbours = regionQuery(P, n, E)
     
     
    [dim, Npts] = size(P);      %Npts���� 
    neighbours = [];          
     
    for i = 1:Npts
        %�Ż��㷨Ч��
         dis1=abs(P(2,n)-P(2,i)); %γ��
                if dis1>0.009    
                    continue;
                end
                dis1=abs(P(1,n)-P(1,i));%����
                if dis1>0.001
                    continue;
                end
                
        if i ~= n
           
            %�����ŷʽ����
%             v = P(:,i)-P(:,n);
%             dist2 = v'*v;
            
            distance=getdistance(P(2,n),P(1,n),P(2,i),P(1,i));
            dist2=distance*1000;
            if dist2 < E
                
               neighbours = [neighbours i];   %�洢���к�nb/n����ŷ�Ͼ������Ƶĵ�
             end   
%             if dist2 < E
%                  num1=datenum(time(n,:),'HH:MM:SS');
%                  num2=datenum(time(i,:),'HH:MM:SS');
%                  if abs(num1-num2)/6.9444e-004<21
%                neighbours = [neighbours i];   
%                  end
                 
                 
            
        end
    end
     
end % of regionQuery