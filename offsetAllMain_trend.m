function[accuracy]=offsetAllMain_trend()
%% 观察精度趋势（关于样本数量），现每个键位的每个偏移类型共有样本120个
clear; %clc;
warning off;
addpath(genpath(pwd));
mode = 'new';
fprintf('----Mode %s----\n',mode);
basePath = './chj/data/';
dirs = dir(basePath);
perTrainNum = 115;
    
%% original data
load([basePath, 'decimate_overdata180-300_69k_0.6k.mat']);
over = decimate_data;
load([basePath, 'decimate_belowdata180-300_69k_0.6k.mat']);
below = decimate_data;
load([basePath, 'decimate_leftdata180-300_69k_0.6k.mat']);
left = decimate_data;
load([basePath, 'decimate_rightdata180-300_69k_0.6k.mat']);
right = decimate_data;
load([basePath, 'decimate_centerdata180-300_69k_0.6k.mat']);
center = decimate_data;
%% GCC
partSize=size(over,1);
GCCData=BatchGCC_ExternalBase([over ;below ;left ;right ; center]);
over=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
below=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
left=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
right=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
center=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
%% psd data
 psdData1 = PSD(over, 600);
 psdData2 = PSD(below, 600);
 psdData3 = PSD(left, 600);
 psdData4 = PSD(right, 600);
 psdData5 = PSD(center, 600);
% psdData5 = [];psdData4 = psdData5; psdData3 = psdData4;psdData2 = psdData3; psdData1 = psdData2;
%% confusion data
data1 = cat(2,over,psdData1);
data2 = cat(2,below,psdData2);
data3 = cat(2,left,psdData3);
data4 = cat(2,right,psdData4);
data5 = cat(2,center,psdData5);
%% split data
[trainData1, testData1] = AdjustableSplit(data1,perTrainNum);
[trainData2, testData2] = AdjustableSplit(data2,perTrainNum);
[trainData3, testData3] = AdjustableSplit(data3,perTrainNum);
[trainData4, testData4] = AdjustableSplit(data4,perTrainNum);
[trainData5, testData5] = AdjustableSplit(data5,perTrainNum);

trainData=mergeData_offset(trainData1,trainData2,trainData3,trainData4,trainData5);
testData=mergeData_offset(testData1,testData2,testData3,testData4,testData5);
%% 只对PSD做标准化
%     length=size(psdData1,2); col=size(trainData,2);
%     trainData(:,col-length+1:end)=featureNormalize(trainData(:,col-length+1:end));
%     testData(:,col-length+1:end)=featureNormalize(testData(:,col-length+1:end));
%% generate label
 testLabel = GenerateNNLabel(size(testData, 1));
%% generate label without merge
%     rows = size(testData, 1);
%     singleNum = rows / (9*5);
%     testLabel = zeros(rows, 45);
%     for i=1:45
%         for j=1:singleNum
%             testLabel((i - 1) * singleNum + j, i) = 1;
%         end
%     end

%% test
if strcmp(mode,'old')
    [accuracy,~]=NN(trainData, testData, testLabel);
elseif strcmp(mode,'new')
    [accuracy,~]=NN_New(trainData, testData, testLabel);
else
    disp("wrong!!!");
end