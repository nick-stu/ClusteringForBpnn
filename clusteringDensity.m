function[]=clusteringDensity(mdl)
[avg,std]=classStatus(mdl.data);
threshold=avg - std;

fprintf('classNum:%d\n',mdl.classNum);
N=cell(mdl.classNum,1);
for i=1:mdl.classNum
    N{i}=mdl.data(find(mdl.label==i),:);
end
dMat=[];
for i=1:length(N)
[avg1,~]=classStatus(N{i});
dMat=[dMat avg1];
end

for i=1:length(N)
    for j=i+1:length(N)
        [avg2,~]=classStatus(N{i},N{j});
        dMat=[dMat avg2];
    end
end

figure;
plot(dMat);hold on;
plot([0 size(dMat,2)+1],[avg avg],'r--');
plot([0 size(dMat,2)+1],[threshold threshold],'r');
plot([length(N)+0.5 length(N)+0.5],[min(dMat)-10 max(dMat)+10],'b');

plot([0 length(N)],[mean(dMat(1:length(N))) mean(dMat(1:length(N)))],'b--');
dMat(1:length(N))=[];
plot([length(N)+0.5 size(dMat,2)+1+length(N)],[mean(dMat) mean(dMat)],'m--');
end