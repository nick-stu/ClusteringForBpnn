function [data] = pcaPlotBasedonLabel(data,K,label,Pointsize)
[data,~]=featureNormalize(data,[1]);
[eigenVectors,scores,eigenValues] = pca(data);
transMatrix = eigenVectors(:,1:K);
data = data*transMatrix;
fprintf('∫œ¿Ì∂»£∫%f\n',sum(eigenValues(1:K))/sum(eigenValues));


figure;
if K==3
    for i=1:size(label,2)
        index=find(label==i);
        a=rand; b=rand; c=rand;
        for j=1:length(index)
            scatter3(data(index(j),1),data(index(j),2),data(index(j),3), Pointsize,[a b c],'filled');hold on;
            text(data(index(j),1),data(index(j),2),data(index(j),3),num2str(label(index(j))), 'Color',[1-a,1-b,1-c]);
        end
    end
elseif K==2
    for i=1:size(label,2)
        index=find(label==i);
        a=rand; b=rand; c=rand;
        for j=1:length(index)
            scatter(data(index(j),1),data(index(j),2), Pointsize,[a b c],'filled');hold on;
            text(data(index(j),1),data(index(j),2),num2str(label(index(j))), 'Color',[1-a,1-b,1-c]);
        end
    end
end
title('PCA based on label');
end