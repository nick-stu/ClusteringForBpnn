function []=mdsPlot(data,K)
data=MDS(data,K);

figure;
for i=1:60
    if i<=30
        scatter3(data(i,1),data(i,2),data(i,3), 100,'k','filled');hold on;
    elseif i>30 && i<=60
        scatter3(data(i,1),data(i,2),data(i,3), 100,'b','filled');
    end
end
title('MDS');
end