function []=densitySituationBasedOnType(data)
[avg,std]=classStatus(data);
threshold=avg - std;

num=30;
blockNum=size(data,1)/num;
A=num*ones(1,blockNum);
N=mat2cell(data,A,size(data,2));
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