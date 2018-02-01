%算法描述
%在本算法中，首先最外层循环是将所有点进行遍历
%在遍历时，首先判断某一点，是否为核心，若不是，将其标记为噪声点
%若是，将其加入到C中，并对其进行标记（1,2,3……借以取费不同的簇），将其距离范围内的点加入到neighbourPts中
%迭代
%对neighbourPts每个点进行遍历，若未被访问，对其进行距离判定，并将其返回值加入到neighbourPts中
%在判定该点是否被加入到C中，若没有，将其加入到C中，并且将其进行cluster 标记，
%
function [C, ptsC] = dbscan(P, E, minPts)
     
    [dim, Npts] = size(P);       %dim=行数（2），Npts=列数（点数）    
     
    ptsC  = zeros(Npts,1);   %存储所有点的农田编号的矩阵
    %C定义的是细胞数组，其中的每一个元素性质大小均可不同
    C     = {};              % C是cell类型，存储C{1，1}存储第一块田的所有点，存储C{1，2}存储第二块田的所有点
    Nc    = 0;               % Cluster counter. 第N块田
    Pvisit = zeros(Npts,1);  % Array to keep track of points that have been visited.
     
    for n = 1:Npts
       if ~Pvisit(n)                            % If this point not visited yet；~ 逻辑非 
           Pvisit(n) = 1;                       % mark as visited

            
           %返回以第n个向量为核心的距离为E的圆周内的向量
           neighbourPts = regionQuery(P, n, E); % and find its neighbours
 
           if length(neighbourPts) < minPts  % Not enough points to form a cluster
               %如果数量不够，讲该函数标记为噪音点
               ptsC(n) = 0;                    % Mark point n as noise.
            
           else                % Form a cluster...
               %标记非噪声点的数量
               Nc = Nc + 1;    % Increment number of clusters and process
                               % neighbourhood.
               %将该核心点加入到C中，Nc农田编号
            
               C{Nc} = [n];    % Initialise cluster Nc with point n
              %标注该点与哪个核心店密度可达，该店属于cluster Nc  ，存储Nc中的所有点
               ptsC(n) = Nc;   % and mark point n as being a member of cluster Nc.标记该点的农田编号
                
               ind = 1;        % Initialise index into neighbourPts array.
                
               %将以第n个向量为核心的点的周围的点进行判别
                
               % For each point P' in neighbourPts ...
               %该处为一迭代算法知道与相关的点全都迭代完全为止（先找第一个点的领域内所有的点，再把第二个点邻域内所有的点遍历，一直迭代迭代）
               while ind <= length(neighbourPts)
                    
                   nb = neighbourPts(ind);
                  
                    %若该点没有被访问，就进行同上判别 
                   if ~Pvisit(nb)        % If this neighbour has not been visited
                       Pvisit(nb) = 1;   % mark it as visited.
                        
                       % Find the neighbours of this neighbour and if it has
                       % enough neighbours add them to the neighbourPts list
                       neighbourPtsP = regionQuery(P, nb, E);  %存储nb点的邻域内的点
                       if length(neighbourPtsP) >= minPts
                           neighbourPts = [neighbourPts  neighbourPtsP];    %将之前的点和新加入的点加在一起
                       end
                   end            
                    
                   % If this neighbour nb not yet a member of any cluster add it
                   % to this cluster.
                   %如果这个点没有进行标注，把这个点放进C，并且标记其所在的cluster 的标号
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
    %？？？？？？？？？？？？？？？？？？？？？
    %创建一个与C长度相等大小的向量，维数为dim
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
%              P - the dim x Npts array of data points  坐标
%              n - Index of point of interest           兴趣点索引
%              E - Distance threshold                   距离阈
 
%该函数返回的是每次验证一个点的时候，判断该点是不是距离以内的，返回的是所有点的位置
 
function neighbours = regionQuery(P, n, E)
     
     
    [dim, Npts] = size(P);      %Npts点数 
    neighbours = [];          
     
    for i = 1:Npts
        %优化算法效率
         dis1=abs(P(2,n)-P(2,i)); %纬度
                if dis1>0.009    
                    continue;
                end
                dis1=abs(P(1,n)-P(1,i));%经度
                if dis1>0.001
                    continue;
                end
                
        if i ~= n
           
            %计算的欧式距离
%             v = P(:,i)-P(:,n);
%             dist2 = v'*v;
            
            distance=getdistance(P(2,n),P(1,n),P(2,i),P(1,i));
            dist2=distance*1000;
            if dist2 < E
                
               neighbours = [neighbours i];   %存储所有和nb/n满足欧氏距离限制的点
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