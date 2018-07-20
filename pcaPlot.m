function [data] = pcaPlot(data,K)
[data,~]=featureNormalize(data,0);
[eigenVectors,scores,eigenValues] = pca(data);
transMatrix = eigenVectors(:,1:K);
data = data*transMatrix;
fprintf('∫œ¿Ì∂»£∫%f\n',sum(eigenValues(1:K))/sum(eigenValues));
figure;
for i=1:60
    if i<=30
        scatter3(data(i,1),data(i,2),data(i,3), 100,'k','filled');hold on;
%         text(data(i,1),data(i,2),data(i,3),num2str(label(i)));
    else
        scatter3(data(i,1),data(i,2),data(i,3), 100,'b','filled');
%         text(data(i,1),data(i,2),data(i,3), num2str(label(i)));
    end
end
title('PCA based on Type');
end