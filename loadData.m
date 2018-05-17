clear; clc;
warning off;
addpath(genpath(pwd));
basePath = './大力小力/';
dirs = dir(basePath);
begin=30*7 + 1;
tail=begin+29;
for x=1:size(dirs, 1)
    if (dirs(x).name(1) == '.')
        continue;
    end
    fprintf('%s-> ', dirs(x).name);
    
    load([basePath, dirs(x).name, '/hard/hard_decimatedata_0.6k_withPSD.mat']);
    hard = decimate_data(begin:tail, :);
    load([basePath, dirs(x).name, '/gentle/gentle_decimatedata_0.6k_withPSD.mat']);
    gentle = decimate_data(begin:tail, :);
    data=[hard;gentle];
    %% 是否归一化
    originData=data;
    data=featureNormalize(data);% 归一化
%     mdl=clustering_dis(data);
    mdl=clustering(data,false);
%     densitySituation(data);
    pcaPlot(originData,3);
    mdsPlot(originData,3);
end