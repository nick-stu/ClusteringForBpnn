function[]=mdsPlotBasedonLabel(data,K,label,Pointsize)
data=MDS(data,K);
figure;
if K==3
    for i=1:size(label,2)
        index=find(label==i);
        a=rand*0.6+0.4; b=rand*0.6+0.4; c=rand*0.6+0.4;
        for j=1:length(index)
            scatter3(data(index(j),1),data(index(j),2),data(index(j),3), Pointsize,[a b c],'filled');hold on;
            text(data(index(j),1),data(index(j),2),data(index(j),3),num2str(label(index(j))));
        end
    end
elseif K==2
    for i=1:size(label,2)
        index=find(label==i);
        a=rand*0.6+0.4; b=rand*0.6+0.4; c=rand*0.6+0.4;
        for j=1:length(index)
            scatter(data(index(j),1),data(index(j),2), Pointsize,[a b c],'filled');hold on;
            text(data(index(j),1),data(index(j),2),num2str(label(index(j))));
        end
    end
end
title('MDS based on label');
end