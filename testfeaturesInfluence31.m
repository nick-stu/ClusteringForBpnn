clear; clc;close all
warning off;
addpath(genpath(pwd));

basePath = '.\600(35¸öÈËµÄdata)\';
dirs = dir(basePath);

sampleNum = 270;
allAccuracy=[];
cycleTimes=10;

for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    for cycleIndex=1:cycleTimes
        fprintf([num2str(cycleIndex),':%s '], dirs(x).name);

        %% original data
        load([basePath, dirs(x).name, '/decimate_data_0.6k.mat']);
        decimate_data = decimate_data(1:sampleNum, :);

        %% mfcc data
    %     load([basePath, dirs(x).name, '/decimate_data_0.6k_mfccdata.mat']);
    %     decimate_data_mfccdata = decimate_data_mfccdata(1:sampleNum, :);
    %     decimate_data_mfccdata = premnmx(decimate_data_mfccdata);

        %% fft data
    %      fftdata = FFT(decimate_data);

        %% psd data
         psdData = PSD(decimate_data, 600);
    %     psdData = 1 ./ psdData;

        %% gfcc
%         load([basePath, dirs(x).name, '/decimate_data_0.6k_GFCCData.mat']);
%         gfccdata=GFCCData(1:sampleNum, :);

        %% confusion data
%         data = cat(2,decimate_data,psdData);
%         data = decimate_data;
        data = psdData;
    %      data=psdData;
        %% split data
        [trainData, testData] = Split(data);

        %% generate label
        testLabel = GenerateNNLabel(size(testData, 1));

        %% fisher data
    %     [fisherTrain, fisherTest] = FisherScoreData(trainData, testData, 0);

        %% test
        accuracy=NN(trainData, testData, testLabel);
    %     NN(fisherTrain, fisherTest, testLabel);
    %     NNTrain2(cat(2, psdData, decimate_data, fftData, decimate_data_mfccdata), label);
    %     NNTrain2(cat(2, psdData, decimate_data, fftData), label);
    %     NNTrain2(decimate_data, label);
        allAccuracy(x-2,cycleIndex)=accuracy;
    end
end
for x=3:37
    disp(dirs(x).name);
end
