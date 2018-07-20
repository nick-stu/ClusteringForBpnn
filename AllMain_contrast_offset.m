function[oldMat,newMat]=AllMain_contrast_offset(Tsize)
warning off;
addpath(genpath(pwd));
mode = 'Contrast_KNN';
fprintf('----Mode %s----\n',mode);
basePath = './敲击偏移数据/';
dirs = dir(basePath);
sampleNum = 270;
oldMat=[];newMat=[];
k = 1;
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    
    %% original data
    load([basePath, dirs(x).name, '/over/overdecimate_data_0.6k.mat']);
    over = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/below/belowdecimate_data_0.6k.mat']);
    below = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/left/leftdecimate_data_0.6k.mat']);
    left = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/right/rightdecimate_data_0.6k.mat']);
    right = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/center/centerdecimate_data_0.6k.mat']);
    center = decimate_data(1:sampleNum, :);
    frontSize=size(center,2);

    %% psd data
     psdData1 = PSD(over, 600);
     psdData2 = PSD(below, 600);
     psdData3 = PSD(left, 600);
     psdData4 = PSD(right, 600);
     psdData5 = PSD(center, 600);
    %% confusion data
    data1 = cat(2,over,psdData1);
    data2 = cat(2,below,psdData2);
    data3 = cat(2,left,psdData3);
    data4 = cat(2,right,psdData4);
    data5 = cat(2,center,psdData5);
    %% split data
    [trainData1, testData1] = Split(data1,Tsize);
    [trainData2, testData2] = Split(data2,Tsize);
    [trainData3, testData3] = Split(data3,Tsize);
    [trainData4, testData4] = Split(data4,Tsize);
    [trainData5, testData5] = Split(data5,Tsize);

    trainData=mergeData_offset(trainData1,trainData2,trainData3,trainData4,trainData5);
    testData=mergeData_offset(testData1,testData2,testData3,testData4,testData5);
    %% generate label
    trainLabel = [];
    testLabel =[];
    for i = 1:9
        trainLabel = [trainLabel ;repmat(i,[size(trainData,1)/9,1])];
        testLabel = [testLabel ;repmat(i,[size(testData,1)/9,1])];
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
%     [trainData,testData]=BatchReliefF(trainData,testData,50);
    %% VarFilter
%     [trainData,testData]=VarFilter(trainData(:,1:frontSize),testData(:,1:frontSize));
%     [trainData,testData]=mypca(trainData(:,1:frontSize),testData(:,1:frontSize),fix(frontSize*0.9));
    %% Pow
%     plot(data');
%     trainData(:,40:frontSize)=[];%trainData(:,40:frontSize)*0.01;
%     testData(:,40:frontSize)=[];%testData(:,40:frontSize)*0.01;
    %% Fisher
%     score = calVariance( trainData, 9);
%     trainData=score.*trainData;
%     testData=score.*testData;
    %% reliefFscore
    score = reliefFscore( trainData, trainLabel, k);
    trainData=score.*trainData;
    testData=score.*testData;
    %% RePsd
%     psdData1 = PSD(trainData, 600);
%     psdData2 = PSD(testData, 600);
%     trainData = cat(2,trainData,psdData1);
%     testData = cat(2,testData,psdData2);
    %% rmOutcast
%     index=rmOutcastBasedonZscore(trainData);
    %% z-score
%     [trainData,testData] = featureNormalize( trainData,testData );
    
    accuracy2 = CalAccuracy_KNN (trainData, testData, trainLabel, testLabel, k);
%     accuracy2 = CalAccuracy_KNN_withUpdate (trainData, testData, trainLabel, testLabel, k);
    
    oldMat=[oldMat accuracy1];
    newMat=[newMat accuracy2];
end