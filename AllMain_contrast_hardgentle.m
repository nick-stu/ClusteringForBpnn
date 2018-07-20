function[oldMat,newMat]=AllMain_contrast_hardgentle()
clear;
warning off;
addpath(genpath(pwd));
mode = 'Contrast_KNN';
fprintf('----Mode %s----\n',mode);
basePath = './大力小力/';
dirs = dir(basePath);
sampleNum = 270;
oldMat=[];newMat=[];
k = 1;

for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
%     fprintf('%s ', dirs(x).name);
    
    %% original data
    load([basePath, dirs(x).name, '/hard/harddecimate_data_0.6k.mat']);
    hard = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/gentle/gentledecimate_data_0.6k.mat']);
    gentle = decimate_data(1:sampleNum, :);
    frontSize=size(gentle,2);

    %% psd data
     psdData1 = PSD(hard, 600);
     psdData2 = PSD(gentle, 600);
    %% confusion data
    data1 = cat(2,hard,psdData1);
    data2 = cat(2,gentle,psdData2);
    %% split data
    [trainData1, testData1] = Split(data1);
    [trainData2, testData2] = Split(data2);
    trainData=mergeData(trainData1,trainData2);
    testData=mergeData(testData1,testData2);
    %% generate label
    trainLabel = [];
    testLabel =[];
    for i = 1:9
        trainLabel = [trainLabel ;repmat(i,[40,1])];
        testLabel = [testLabel ;repmat(i,[20,1])];
    end
    %% random index
%     idx=randperm(length(testLabel));
%     testLabel = testLabel(idx);
%     testData = testData(idx,:);
    %% test
    accuracy1 = CalAccuracy_KNN (trainData, testData, trainLabel, testLabel, k);
     
    %% 只对PSD做标准化
%     length=size(psdData1,2); col=size(trainData,2);
%     trainData(:,col-length+1:end)=featureNormalize(trainData(:,col-length+1:end));
%     testData(:,col-length+1:end)=featureNormalize(testData(:,col-length+1:end));
    %% Multiple map label
%     tmp=testLabel;testLabel=[];
%     for m=1:size(tmp,2)
%         testLabel=[testLabel repmat(tmp(:,m),[1,Mul])];
%     end
    %% BatchReliefF
%     [trainData,testData]=BatchReliefF(trainData(:,1:frontSize),testData(:,1:frontSize),45);
    %% VarFilter
%     [trainData,testData]=VarFilter(trainData(:,1:frontSize),testData(:,1:frontSize));
%     [trainData,testData]=mypca(trainData(:,1:frontSize),testData(:,1:frontSize),fix(frontSize*0.9));
    %% Pow
%     plot(data');
%     trainData(:,40:frontSize)=[];%trainData(:,40:frontSize)*0.01;
%     testData(:,40:frontSize)=[];%testData(:,40:frontSize)*0.01;
    %% RePsd
%     psdData1 = PSD(trainData, 600);
%     psdData2 = PSD(testData, 600);
%     trainData = cat(2,trainData,psdData1);
%     testData = cat(2,testData,psdData2);
    %% Fisher
    score = calVariance( trainData, 9);
    trainData=score.*trainData;
    testData=score.*testData;
    %% rmOutcast
%     index=rmOutcastBasedonZscore(trainData);
    %% z-score
%     [trainData,testData] = featureNormalize( trainData,testData );
    
    accuracy2 = CalAccuracy_KNN (trainData, testData, trainLabel, testLabel, k);
%     accuracy2 = CalAccuracy_KNN_withUpdate (trainData, testData, trainLabel, testLabel, k);
    
    oldMat=[oldMat accuracy1];
    newMat=[newMat accuracy2];
end