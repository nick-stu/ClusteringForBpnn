function[oldMat,newMat]=AllMain_contrast30_knn(Tsize)
% clear;
warning off;
addpath(genpath(pwd));
mode = 'Contrast_KNN';
fprintf('----Mode %s----\n',mode);
basePath = './600/';
dirs = dir(basePath);
sampleNum = 270;
oldMat=[];newMat=[];
k = 1;
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    
    %% original data
    load([basePath, dirs(x).name, '/decimate_data_0.6k.mat']);
    data = decimate_data(1:sampleNum, :);
    frontSize=size(data,2);

    %% psd data
     psdData = PSD(data, 600);
    %% confusion data
    data = cat(2,data,psdData);
    %% split data
    [trainData, testData] = Split(data,Tsize);
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
   %% Fisher
    score = calVariance( trainData, 9);
    trainData=score.*trainData;
    testData=score.*testData;
   %% reliefFscore
    score = reliefFscore( trainData, trainLabel, 5);
    trainData=score.*trainData;
    testData=score.*testData;
    
    accuracy2 = CalAccuracy_KNN (trainData, testData, trainLabel, testLabel, k);
%     accuracy2 = CalAccuracy_KNN_withUpdate (trainData, testData, trainLabel, testLabel, k);
    
    oldMat=[oldMat accuracy1];
    newMat=[newMat accuracy2];
end