function [data] = pcaPlot_offset(data,K,label)
data=featureNormalize(data);
[eigenVectors,scores,eigenValues] = pca(data);
transMatrix = eigenVectors(:,1:K);
data = data*transMatrix;
fprintf('∫œ¿Ì∂»£∫%f\n',sum(eigenValues(1:K))/sum(eigenValues));

figure;
for i=1:150
    if i<=30
        scatter3(data(i,1),data(i,2),data(i,3), 180,'c','filled');hold on;
        text(data(i,1),data(i,2),data(i,3),num2str(label(i)));
    elseif i>30 && i<=60
        scatter3(data(i,1),data(i,2),data(i,3), 180,'g','filled');
        text(data(i,1),data(i,2),data(i,3), num2str(label(i)));
    elseif i>60 && i<=90
        scatter3(data(i,1),data(i,2),data(i,3), 180,'y','filled');
        text(data(i,1),data(i,2),data(i,3), num2str(label(i)));
    elseif i>90 && i<=120
        scatter3(data(i,1),data(i,2),data(i,3), 180,'m','filled');
        text(data(i,1),data(i,2),data(i,3), num2str(label(i)));
    elseif i>120 && i<=150
        scatter3(data(i,1),data(i,2),data(i,3), 180,'r','filled');
        text(data(i,1),data(i,2),data(i,3), num2str(label(i)));
    end
end
title('PCA');
end