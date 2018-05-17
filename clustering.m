function [ mdl ] = clustering( data ,isPlot)
% 阈值基于最近距离决定是否分类
% mdl.data: 聚类的训练样本
% mdl.label: 聚类的训练样本的分类
% mdl.classNum: 聚类后形成的类的数量

    mdl.data = data;

    num = size(data, 1);
    label = zeros(1, num);
    pre_index = zeros(1, num); % 保存标签和数据的对应关系
    dis = zeros(1, num);
    p_label = 1:num;

    %% 找出两两距离最小的两个点
    D = pdist2(data, data);
    D(D == 0) = Inf;
    [d, i] = min(D);
    [~, index] = min(d);
    index = i(index);
    % 将两个点中的其中一个放入到 finded 数据中
    finded = data(index, :);
    data(index, :) = [];
    pre_index(index) = 1;
    p_label(index) = [];

    %% 将 finded 数组中的点与剩余点计算两两距离，找出最小距离，将这个点也加入到 finded 数组中
    for i=2:num
        min_d = Inf;
        for j=1:size(data, 1)
            [~, d] = nearest(data(j, :), finded);
            if d(1) < min_d
                min_d = d(1);
                min_i = j;
            end
        end
        dis(i) = min_d;
        finded = [finded; data(min_i, :)];
        data(min_i, :) = [];
        pre_index(p_label(min_i)) = i;
        p_label(min_i) = [];
    end

    %% 聚类
    % 先将一定为同一类区分
    % 1. 低于阈值(平均距离 + 方差)
    % 2. 比上一个的距离小
    threshold = mean(dis(2 : end)) + std(dis(2 : end));
    classNum = 1;
    label(1) = 1;
    label(2) = 1;
    for i=3:num
        if dis(i) <= threshold || dis(i) / dis(i - 1) < 1
            label(i) = label(i - 1);
        else
            classNum = classNum + 1;
            label(i) = classNum;
        end
    end
    dis(1) = dis(2);
    if isPlot
        figure;
        plot(dis);
        hold on;
        plot([0, num + 1], [threshold, threshold]);
        xlim([0, num + 1]);
    %     plot label
        for i=1:num
             text(i, dis(i), num2str(label(i)));
        end
    end
    data = finded;
    %% 合并相似类
    for i=1:classNum
        index = find(label == i);
        if size(index, 2) == 0
            continue
        end
        
        data1 = data(index, :);
        min_d = Inf;
        min_j = 0;
        for j=1:classNum
            if i == j
                continue
            end
            index = find(label == j);
            if size(index, 2) < size(data1, 1)
                continue
            end
            data2 = data(index, :);
            d1 = mean(pdist(data2));
            d2 = mean(pdist([data1; data2]));
            if d2 / d1 < min_d
                min_d = d2 / d1;
                min_j = j;
            end
        end
%         fprintf('%d %d %.4f %d\n', i, min_j, min_d, sum(label == i));
        if min_d < 1.05
            label(label == i) = min_j;
        end
    end
    
    %% 恢复由于合并类导致的 label 不连续
    maxClassNum = max(label);
    classNum = 0;
    for i=1:maxClassNum
        index = find(label == i);
        if size(index, 2) > 0
            classNum = classNum + 1;
            label(index) = classNum;
        end
    end

    %% 画图看下分类的准确性
    dis(1) = dis(2);
    if isPlot
    figure;
    plot(dis);
    hold on;
    plot([0, num + 1], [threshold, threshold]);
    xlim([0, num + 1]);
    % plot label
    for i=1:num
        text(i, dis(i), num2str(label(i)));
    end
    end
    %% 恢复标签与 data 的对应关系
    label = label(pre_index);
    %% 查看分类效果
%     figure;
%     scatter(1:num,label); 
%     ylim([0,classNum+1]);
    
    mdl.label = label;
    mdl.classNum = classNum;
    
end