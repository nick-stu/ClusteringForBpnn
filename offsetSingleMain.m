clear; clc;
warning off;
addpath(genpath(pwd));
mode = 'old';
basePath = './ÇÃ»÷Æ«ÒÆÊý¾Ý/';
dirs = dir(basePath);
sampleNum = 270;
accuracyMat=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
    %% original data
    load([basePath, dirs(x).name, '/center/centerdecimate_data_0.6k.mat']);
    trainData = decimate_data(1:sampleNum, :);
    
    load([basePath, dirs(x).name, '/right/rightdecimate_data_0.6k.mat']);
    testData = decimate_data(1:sampleNum, :);
    
    %% psd data
     psdData1 = PSD(trainData, 600);
     psdData2 = PSD(testData, 600);
    %% confusion data
    data1 = cat(2,trainData,psdData1);
    data2 = cat(2,testData,psdData2);
    %% split data
    [trainData, ~] = Split(data1);
    [~, testData] = Split(data2);
    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    
    %% test
    if strcmp(mode,'old')
        [accuracy,~]=NN(trainData, testData, testLabel);
    elseif strcmp(mode,'new')
        [accuracy,~]=NN_New(trainData, testData, testLabel);
    else
        disp("WRONG!!!");
    end
    accuracyMat=[accuracyMat accuracy];
end
fprintf('AVG: %.4f\n',mean(accuracyMat));