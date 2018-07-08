function[ oldMat,newMat]=Wrapper()
clear; warning off;
addpath(genpath(pwd));
mode = 'contrast';
fprintf('----Mode %s----\n',mode);
basePath = './600/';
dirs = dir(basePath);
sampleNum = 270;
oldMat=[]; newMat=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s ', dirs(x).name);
    
    %% original data
    load([basePath, dirs(x).name, '/decimate_data_0.6k.mat']);
    data = decimate_data(1:sampleNum, :);
    frontSize=size(data,2);
    
    %% Psd data
     psdData = PSD(data, 600);
    %% confusion data
    data = cat(2,data,psdData);
    col=size(data,2);
    %% split data
    [trainData, testData] = Split(data);
    %% generate label
    testLabel = GenerateNNLabel(size(testData, 1));
    %% Wrapper label
    [InnerTrainData, InnerTestData] = SplitForWrapper(trainData);
    InnerTestLabel = GenerateNNLabel(size(InnerTestData, 1));
    %% test
    [accuracy,~]=NN(trainData, testData, testLabel); oldMat=[oldMat accuracy];
    fprintf('%.4f\n',accuracy);
    [UpperMax,~]=NN(InnerTrainData, InnerTestData, InnerTestLabel);
    %% loop
    MaxOutcast=fix(col/9);
    for loop=1:MaxOutcast
        MaxAc=0;
        for i=1:size(InnerTrainData,2)
            tmp1=InnerTrainData;  tmp2=InnerTestData;
            tmp1(:,i)=[]; tmp2(:,i)=[];
            [ac,~]=NN(tmp1, tmp2, InnerTestLabel);
            if MaxAc<ac
                MaxAc=ac;
                flag=i;
            end
        end
        if MaxAc<UpperMax
            break;
        end
        UpperMax=MaxAc;
        InnerTrainData(:,flag)=[]; InnerTestData(:,flag)=[];
        trainData(:,flag)=[]; testData(:,flag)=[];
    end
    %% test
    [accuracy,~]=NN(trainData, testData, testLabel); newMat=[newMat accuracy];
    fprintf('%.4f\n',accuracy);
end