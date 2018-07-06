function[oldMat,newMat]=AllMain_contrast30()
clear;
warning off;
addpath(genpath(pwd));
mode = 'contrast';
fprintf('----Mode %s----\n',mode);
basePath = './600/';
dirs = dir(basePath);
sampleNum = 270;
oldMat=[];newMat=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
    %% original data
    load([basePath, dirs(x).name, '/decimate_data_0.6k.mat']);
    data = decimate_data(1:sampleNum, :);
    frontSize=size(data,2);

    %% psd data
     psdData = PSD(data, 600);
    %% confusion data
    data = cat(2,data,psdData);
    %% split data
    [trainData, testData] = Split(data);
    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    %% test
    fprintf('old:');
    [accuracy1,~]=NN(trainData, testData, testLabel);
    fprintf('new:');

    %% multiple map label
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
    score = FisherScore( trainData, 9, 1 );
    trainData=score.*trainData;
    testData=score.*testData;
    [accuracy2,~]=NN(trainData, testData, testLabel);
    
    oldMat=[oldMat accuracy1];
    newMat=[newMat accuracy2];
end