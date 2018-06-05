clear; clc; close all;
warning off;
addpath(genpath(pwd));
basePath = './敲击偏移数据/';
dirs = dir(basePath);
% DBIndex=[];
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s-> ', dirs(x).name);

    I=[]; D=[]; T=[]; A=[];
    for begin=1:30:270
        %% Load DATA
        load([basePath, dirs(x).name, '/over/overdecimate_data_0.6k.mat']);
        over = decimate_data(begin:begin+29, :);
        load([basePath, dirs(x).name, '/below/belowdecimate_data_0.6k.mat']);
        below = decimate_data(begin:begin+29, :);
        load([basePath, dirs(x).name, '/left/leftdecimate_data_0.6k.mat']);
        left = decimate_data(begin:begin+29, :);
        load([basePath, dirs(x).name, '/right/rightdecimate_data_0.6k.mat']);
        right = decimate_data(begin:begin+29, :);
        load([basePath, dirs(x).name, '/center/centerdecimate_data_0.6k.mat']);
        center = decimate_data(begin:begin+29, :);
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
%         [data,~]=featureNormalize(data,data);% 归一化
        %% 聚类
%         mdl=clustering_dis_offset(data,false);
%         mdl=clustering_offset_nearest(data,false);
%         mdl=clusteringDebug(data,false);
%         mdl=DBSCAN(data);
%         mdl=k_means(data,5);
%         mdl=clustering(data,true);
        %% 查看密度情况
    %     clusteringDensity(mdl);
%         densitySituationBasedOnType(data);
        [inner,diff,threshold,avg]=featureExploration(data);
        I=[I; inner]; D=[D; diff]; T=[T threshold]; A=[A avg];
    %     batchDTW(data);
        %% 查看 DB指数
    %     dbi=DBI(mdl);
    %     DBIndex=[DBIndex dbi];
        %% 可视化
%         pcaPlot_offset(originData,3,mdl.label);
%         mdsPlot_offset(data,3,mdl.label);
%         mdsPlotBasedonLabel(data,3,mdl.label,200);
%         pcaPlotBasedonLabel(originData,3,mdl.label,200);
    end
    %% plot
    figure;
    I=mean(I); D=mean(D);
    ALL=[I D];
    plot(ALL,'-*k');hold on;
    plot([5.5 5.5],[max(ALL)+1 min(ALL)-1]); % gap
    plot([1 15],[mean(A) mean(A)],'b--');% avg
    plot([1 15],[mean(T) mean(T)],'r');% threshold
    plot([1 5],[mean(I) mean(I)]);% inner mean
    plot([6 15],[mean(D) mean(D)]);% diff mean
end
% mean(DBIndex(~isnan(DBIndex)))