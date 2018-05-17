function [ mdl ] = clustering_new( data )
% 阈值基于 密度变化率 决定是否分类
% mdl.data: 聚类的训练样本
% mdl.label: 聚类的训练样本的分类
% mdl.classNum: 聚类后形成的类的数量

    mdl.data = data;
    num = size(data, 1);
    label = zeros(1, num);
    pre_index = zeros(1, num); % 保存标签和数据的对应关系,标明该数据为第几个被选上
    p_label = 1:num; % data标志序列
    threshold = 0.3;
    fprintf('threshold: %s ',threshold);
    %% 找出两两距离最小的两个点
    D = pdist2(data, data);
    D(D == 0) = Inf;
    [d, i] = min(D);
    [~, index] = min(d);
    index = i(index);
    % 将两个点中的其中一个放入到 finded 数据中
    finded = data(index, :);
    data(index, :) = [];% 在data集中去掉该数据
    pre_index(index) = 1;% 标明该数据为第几个选上
    p_label(index) = [];% 从序列中抹掉

    class_label=zeros(1, num);% 表示第几行数据是哪一类
    class_label(index)=1;
    %% 聚类, 将 当前类 数组中的点与剩余点计算两两距离，找出最小距离，将这个点也加入到 该类 数组中
    % 先将一定为同一类区分
    % 1. 低于阈值
    % 2. 比上一个的距离小
    minMat=[];
    classFlag=1;
    label(1)=1;
    for i=2:num
        min_ratio = Inf;
        for j=1:size(data, 1)% 寻找最类似于已有集的点
            cursor = find(class_label==classFlag);
            [ratio,flag] = densityChange(data(j, :), mdl.data(cursor,:));% 以密度变化为判断基准，只有一个点时用距离判断
            if ratio < min_ratio
                min_ratio = ratio;
                min_i = j;
            end
        end
        if flag==0
            minMat=[minMat 0];
            class_label(p_label(min_i))=classFlag;
            label(i)=label(i-1);
        else
            minMat=[minMat min_ratio];
            if min_ratio <= threshold 
                class_label(p_label(min_i))=classFlag;
                label(i)=label(i-1);
            else
                classFlag=classFlag+1;
                class_label(p_label(min_i))=classFlag;
                label(i)=classFlag;
            end
        end
        finded = [finded; data(min_i, :)];
        data(min_i, :) = [];
        pre_index(p_label(min_i)) = i;
        p_label(min_i) = [];
    end

    figure;
    plot(minMat);
    hold on;
    plot([0, num + 1], [threshold, threshold]);
    xlim([0, num + 1]);
    for i=1:num-1
        text(i, minMat(i), num2str(find(pre_index==i)));
    end
    %% 
    classNum=max(class_label);
%     figure;
%     plot(dis);
%     hold on;
%     plot([0, num + 1], [threshold, threshold]);
%     xlim([0, num + 1]);
%     % plot label
%     for i=1:num
%         text(i, dis(i), num2str(label(i)));
%     end
    data = finded;
    %% 合并相似类
%     for i=1:classNum
%         index = find(label == i);
%         if size(index, 2) == 0
%             continue
%         end
%         
%         data1 = data(index, :); % 属于该类数据
%         min_d = Inf;
%         min_j = 0;
%         for j=1:classNum
%             if i == j
%                 continue
%             end
%             index = find(label == j); % 另一个类的
%             if size(index, 2) < size(data1, 1) % 若是个小类，则继续运行
%                 continue
%             end
%             data2 = data(index, :); % 新类的数据
%             d1 = mean(pdist(data2)); % 新类的平均距离
%             d2 = mean(pdist([data1; data2]));  % 合在一起的平均距离
%             if d2 / d1 < min_d
%                 min_d = d2 / d1;
%                 min_j = j;
%             end
%         end
% %         fprintf('%d %d %.4f %d\n', i, min_j, min_d, sum(label == i));
%         if min_d < 1.05
%             label(label == i) = min_j;
%         end
%     end
    
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
%     dis(1) = dis(2);
%     figure;
%     plot(dis);
%     hold on;
%     plot([0, num + 1], [threshold, threshold]);
%     xlim([0, num + 1]);
%     % plot label
%     for i=1:num
%         text(i, dis(i), num2str(label(i)));
%     end
    
    %% 恢复标签与 data 的对应关系
    label = label(pre_index);
    %% 查看分类效果
    figure;
    scatter(1:num,label,'k'); 
    ylim([0,classNum+1]);
    
    mdl.label = label;
    mdl.classNum = classNum;
end