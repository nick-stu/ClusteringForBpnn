function[data]=pcaPlotDebug(data,K)
data=featureNormalize(data);
[eigenVectors,scores,eigenValues] = pca(data);
transMatrix = eigenVectors(:,1:K);
data = data*transMatrix;


figure;
for i=1:150
    if i<=30
        scatter3(data(i,1),data(i,2),data(i,3), 150,'c');hold on;
    elseif i>30 && i<=60
        scatter3(data(i,1),data(i,2),data(i,3), 150,'g');
    elseif i>60 && i<=90
        scatter3(data(i,1),data(i,2),data(i,3), 150,'b');
    elseif i>90 && i<=120
        scatter3(data(i,1),data(i,2),data(i,3), 150,'m');
    elseif i>120 && i<=150
        scatter3(data(i,1),data(i,2),data(i,3), 150,'r');
    end
    text(data(i,1),data(i,2),data(i,3),num2str(i));
end
title('PCA debug');
end