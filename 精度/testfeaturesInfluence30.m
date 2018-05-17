clear; clc;
addpath(genpath(pwd));

basePath = './600/';
dirs = dir(basePath);

sampleNum = 270;

for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    
    fprintf('%s ', dirs(x).name);
    
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
    
    %% confusion data
    data = cat(2,decimate_data,psdData);
%      data=psdData;
    %% split data
    [trainData, testData] = Split(data);

    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    
    %% fisher data
    [fisherTrain, fisherTest] = FisherScoreData(trainData, testData, 0);
    
    %% test
    NN(fisherTrain, fisherTest, testLabel);
%     NNTrain2(cat(2, psdData, decimate_data, fftData, decimate_data_mfccdata), label);
%     NNTrain2(cat(2, psdData, decimate_data, fftData), label);
%     NNTrain2(decimate_data, label);
end

