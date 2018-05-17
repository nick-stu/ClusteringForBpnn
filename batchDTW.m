function[]=batchDTW(data)
num=30;
blockNum=size(data,1)/num;
A=num*ones(1,blockNum);
N=mat2cell(data,A,size(data,2));
dMat=[];
%% 类内
for i=1:length(N)
    avg1=[];
    for j=1:num
        for k=j+1:num
            avg1=[avg1 dtw(N{i}(j,:),N{i}(k,:))];
        end
    end
    dMat=[dMat avg1];
end
%% 类间
for i=1:length(N)
    for j=i+1:length(N)
        avg2=[];
        for x=1:30
            for y=1:30
                avg2=[avg2 dtw(N{i}(x,:),N{j}(y,:))];
            end
        end
        dMat=[dMat avg2];
    end
end
%% 画图
figure;
plot(dMat);hold on;
plot([length(N)+0.5 length(N)+0.5],[min(dMat)-10 max(dMat)+10],'b');

plot([0 length(N)],[mean(dMat(1:length(N))) mean(dMat(1:length(N)))],'b--');
dMat(1:length(N))=[];
plot([length(N)+0.5 size(dMat,2)+1+length(N)],[mean(dMat) mean(dMat)],'m--');

end