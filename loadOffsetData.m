clear; clc;
warning off;
addpath(genpath(pwd));
mode='new';
if strcmp(mode,'old')
    %%
    basePath = './敲击偏移数据/';

    dirs = dir(basePath);
    begin=30*4 +1;%7
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

        %% GCC
    %     partSize=size(over,1);
    %     GCCData=BatchGCC_ExternalBase([over ;below ;left ;right ; center]);
    %     over=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    %     below=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    %     left=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    %     right=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    %     center=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
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
    %     mdl=clustering_offset_nearest(data,false);
    %     mdl=clusteringExploration(data,false);
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
        outlabel=[ones(1,30)*1 ones(1,30)*2 ones(1,30)*3 ones(1,30)*4 ones(1,30)*5];
        mdsPlotBasedonLabel(data,2,outlabel,100);
    %     pcaPlotBasedonLabel(originData,2,outlabels,100);
    end
    % mean(DBIndex(~isnan(DBIndex)))  
elseif strcmp(mode,'new')
    %%
    basePath = './chj/data/20-300/';
    begin=120*4 +1; tail=begin+119;
    outlabel=[ones(1,120)*1 ones(1,120)*2 ones(1,120)*3 ones(1,120)*4 ones(1,120)*5];
    DBIndex=[];
    %% Load DATA
    load([basePath, '/decimate_overdata20-300_69k_0.6k.mat']);
    over = decimate_data(begin:tail, :);
    load([basePath, '/decimate_belowdata20-300_69k_0.6k.mat']);
    below = decimate_data(begin:tail, :);
    load([basePath, '/decimate_leftdata20-300_69k_0.6k.mat']);
    left = decimate_data(begin:tail, :);
    load([basePath, '/decimate_rightdata20-300_69k_0.6k.mat']);
    right = decimate_data(begin:tail, :);
    load([basePath, '/decimate_centerdata20-300_69k_0.6k.mat']);
    center = decimate_data(begin:tail, :);
    %% GCC
    partSize=size(over,1);
    GCCData=BatchGCC_ExternalBase([over ;below ;left ;right ; center]);
    over=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    below=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    left=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    right=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
    center=GCCData(1:partSize,:); GCCData(1:partSize,:)=[];
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
    %     data=featureNormalize(data);% 归一化
    %% 聚类
    %     mdl=clustering_dis_offset(data,false);
    %     mdl=clustering_offset_nearest(data,false);
    %     mdl=clusteringExploration(data,false);
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
    mdsPlotBasedonLabel(data,2,outlabel,20);
    %     pcaPlotBasedonLabel(originData,2,outlabel,100);

    % mean(DBIndex(~isnan(DBIndex)))
end