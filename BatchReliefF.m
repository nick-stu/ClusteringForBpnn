function [A,B]=BatchReliefF(trainData,testData,k)
A=trainData;B=testData;
% [trainData,testData]=featureNormalize(trainData,testData);
%% Species
rows = size(trainData, 1);
singleNum = rows / 9;
trainLabel = zeros(rows, 1);
for i=1:9
    for j=1:singleNum
        trainLabel((i - 1) * singleNum + j, 1) = i;
    end
end
%% reliefF
[~,weight] = relieff(trainData,trainLabel,k);
index=find(weight<0);
%% weaken or removed
A(:,index)=[];
B(:,index)=[];
bar(weight);
end