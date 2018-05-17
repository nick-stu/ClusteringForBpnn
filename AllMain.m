clear; clc;
warning off;
addpath(genpath(pwd));
mode = 'old';
fprintf('----Mode %s----\n',mode);
basePath = './大力小力/';
dirs = dir(basePath);
sampleNum = 270;
accuracyMat=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
    %% original data
    load([basePath, dirs(x).name, '/hard/harddecimate_data_0.6k.mat']);
    hard = decimate_data(1:sampleNum, :);
    load([basePath, dirs(x).name, '/gentle/gentledecimate_data_0.6k.mat']);
    gentle = decimate_data(1:sampleNum, :);
    
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