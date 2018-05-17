function[mdl]=DBSCAN(data)
% 一种基于高密度连通区域的基于密度的聚类算法
% 
    [num,~]=size(data);
    [E,~]=classStatus(data);
    E=E;
    MinPts=100;
    
    label=zeros(1,num);
    classNum=0;
    unvisited=1:num;% 标记所有对象为未访问
    while ~isempty(unvisited)
        p_num=randperm(size(unvisited,2),1);
        p=unvisited(p_num); % 随机选择一个未访问的为访问对象
        unvisited(p_num)=[]; % 标记p为已访问
        
        pts=neighbor(data,num,p,E);
        if size(pts,2)>=MinPts
            classNum=classNum+1;
            label(p)=classNum;
            while ~isempty(pts)
                pt_num=pts(1);
                pts(1)=[];
                if any(unvisited==pt_num) % 如果pt_num未访问
                    unvisited(find(unvisited==pt_num))=[]; % 标记为访问
                    pts_in=neighbor(data,num,pt_num,E);
                    if size(pts_in,2)>=MinPts
                        pts=[pts pts_in]; % 把新点添加到pts中
                    end
                end
                if label(pt_num)==0
                    label(pt_num)=classNum;
                end
            end%    end while
        
        else 
            fprintf('%d.',p);
        end
    end% end while
    mdl.label=label;
    mdl.classNum=classNum;
    
    figure;
    scatter(1:num,label,'k'); 
    ylim([0,classNum+1]);
end