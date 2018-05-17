clear; clc;
warning off;
addpath(genpath(pwd));
mode = 'new';
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
    load([basePath, dirs(x).name, '/gentle/gentledecimate_data_0.6k.mat']);
    decimate_data = decimate_data(1:sampleNum, :);
    
    %% psd data
     psdData = PSD(decimate_data, 600);
     
    %% confusion data
    data = cat(2,decimate_data,psdData);
    
    %% split data
    [trainData, testData] = Split(data);

    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    
    %% fisher data
%     [fisherTrain, fisherTest] = FisherScoreData(trainData, testData, 0);
    
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