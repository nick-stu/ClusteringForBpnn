% 考察样本丰富性缺失情况下的精度情况
clear; clc;
warning off;
addpath(genpath(pwd));
mode = 'old';
fprintf('----Mode %s----\n',mode);
basePath = './敲击偏移数据/';
dirs = dir(basePath);
sampleNum = 270;
accuracyMat=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
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
%     [trainData1, testData1] = Split(data1);
%     [trainData2, testData2] = Split(data2);
%     [trainData3, testData3] = Split(data3);
%     [trainData4, testData4] = Split(data4);
%     [trainData5, testData5] = Split(data5);

    trainData=mergeData_offset(data2,data3,data4,data1);
    testData=data5;
    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    
    %% test
    if strcmp(mode,'old')
        [accuracy,~]=NN(trainData, testData, testLabel);
    elseif strcmp(mode,'new')
        [accuracy,~]=NN_New(trainData, testData, testLabel);
    else
        disp("wrong!!!");
    end
    accuracyMat=[accuracyMat accuracy];
end

fprintf('AVG: %.4f\n',mean(accuracyMat));