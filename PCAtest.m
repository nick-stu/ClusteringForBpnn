function [data] = PCAtest(data)
data=featureNormalize(data);
[eigenVectors,scores,eigenValues] = pca(data);
transMatrix = eigenVectors(:,1:3);
data = data*transMatrix;
fprintf('∫œ¿Ì∂»£∫%f\n',sum(eigenValues(1:3))/sum(eigenValues));

figure;
for i=1:300
    if i<=150
        scatter3(data(i,1),data(i,2),data(i,3), 150,'y','filled');hold on;
    else
        scatter3(data(i,1),data(i,2),data(i,3), 150,'m','filled');
    end
end
title('PCA');
end