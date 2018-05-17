function [trainData]=mergeData(trainData1,trainData2)
rows = size(trainData1, 1);
singleNum = rows / 9;
trainData=[];
for i=1:9
        trainData=[trainData; trainData1((i-1)*singleNum+1:i*singleNum,:)];
        trainData=[trainData; trainData2((i-1)*singleNum+1:i*singleNum,:)];
end
