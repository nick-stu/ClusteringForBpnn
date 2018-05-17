clear; clc;
warning off;
addpath(genpath(pwd));
basePath = './敲击偏移数据/';
dirs = dir(basePath);
begin=30*7 +1;%7
tail=begin+29;
DBIndex=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s-> ', dirs(x).name);
    %% Load DATA
    load([basePath, dirs(x).name, '/over/overdecimate_data_0.6k.mat']);
    over = decimate_data(begin:tail, :);
    load([basePath, dirs(x).name, '/below/belowdecimate_data_0.6k.mat']);
    below = decimate_data(begin:tail, :);
    load([basePath, dirs(x).name, '/left/leftdecimate_data_0.6k.mat']);
    left = decimate_data(begin:tail, :);
    load([basePath, dirs(x).name, '/right/rightdecimate_data_0.6k.mat']);
    right = decimate_data(begin:tail, :);
    load([basePath, dirs(x).name, '/center/centerdecimate_data_0.6k.mat']);
    center = decimate_data(begin:tail, :);
    %% PSD
    psdData1 = PSD(over, 600);
    psdData2 = PSD(below, 600);
    psdData3 = PSD(left, 600);
    psdData4 = PSD(right, 600);
    psdData5 = PSD(center, 600);

    over = cat(2,over,psdData1);
    below = cat(2,below,psdData2);
    left = cat(2,left,psdData3);
    right = cat(2,right,psdData4);
    center = cat(2,center,psdData5);
    
    %%
    data=[over;below;left;right;center];
    %% 归一化
    originData=data;
%     data=featureNormalize(data);% 归一化
    %% 聚类
%     mdl=clustering_dis_offset(data,false);
    mdl=clustering_offset_nearest(data,false);
%     mdl=clusteringDebug(data,false);
%     mdl=DBSCAN(data);
%     mdl=k_means(data,5);
%     mdl=clustering(data,true);
    %% 查看聚类的密度情况
%     clusteringDensity(mdl);
%     densitySituationBasedOnType(data);
%     batchDTW(data);
    %% 查看 DB指数
%     dbi=DBI(mdl);
%     DBIndex=[DBIndex dbi];
    %% 可视化
%     pcaPlot_offset(originData,3,mdl.label);
%     mdsPlot_offset(data,3,mdl.label);

    mdsPlotBasedonLabel(data,3,mdl.label,200);
%     pcaPlotBasedonLabel(originData,3,mdl.label,200);
end
% mean(DBIndex(~isnan(DBIndex)))