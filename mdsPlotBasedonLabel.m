function[]=mdsPlotBasedonLabel(data,K,label,Pointsize)
data=MDS(data,K);
figure;
for i=1:size(label,2)
    index=find(label==i);
    a=rand; b=rand; c=rand;
    for j=1:length(index)
        scatter3(data(index(j),1),data(index(j),2),data(index(j),3), Pointsize,[a b c],'filled');hold on;
        text(data(index(j),1),data(index(j),2),data(index(j),3),num2str(label(index(j))));
    end
end
title('MDS based on label');
end