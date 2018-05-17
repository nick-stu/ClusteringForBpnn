function[DBIndex]=DBI(mdl)
% return Davies-Bouldin Index
% 越小越好
k=mdl.classNum;
if k==1
    fprintf('这只有一个类\n');
    DBIndex=NaN;
    return;
end
maxD=0;
DBIndex=0;
for i=1:k
    data=mdl.data(find(mdl.label==i),:);
    [avg_i,~]=classStatus(data);
    dcen_i=mean(data,1);
    for j=i+1:k
       data=mdl.data(find(mdl.label==j),:); 
       [avg_j,~]=classStatus(data);
        dcen_j=mean(data,1);
        dbi=(avg_i+avg_j)/pdist2(dcen_i,dcen_j);
        if dbi>maxD
            maxD=dbi;
        end
    end
    DBIndex=DBIndex+dbi;
end
DBIndex=DBIndex/k;
fprintf('DBI is %f\n',DBIndex);
end