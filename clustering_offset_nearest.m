function [ mdl ] = clustering_offset_nearest( data ,isPlot)
% mdl.data: 聚类的训练样本
% mdl.label: 聚类的训练样本的分类
% mdl.classNum: 聚类后形成的类的数量
% 最佳加入点依据最近距离
% 阈值判断为加入后当前类的平均距离

    mdl.data = data;
    num = size(data, 1);
    label = zeros(1, num);
    pre_index = zeros(1, num); % 保存标签和数据的对应关系,标明该数据为第几个被选上
    dis = zeros(1, num);
    p_label = 1:num; % data标志序列
    [avgTotal,std]=classStatus(data);
    threshold = avgTotal-std; % 这里是平均距离
    mergeThreshold = threshold*1.3;
%     fprintf('threshold: %s ',threshold);
    %% 找出两两距离最小的两个点
    D = pdist2(data, data);
    D(D == 0) = Inf;
    [d, i] = min(D);
    [~, index] = min(d);
    index = i(index);
    % 将两个点中的其中一个放入到 finded 数据中
    finded = data(index, :);
    data(index, :) = []; % 在data集中去掉该数据
    pre_index(index) = 1; % 标明该数据为第几个选上
    p_label(index) = []; % 从序列中抹掉

    class_label=zeros(1, num);% 表示第几个样本是哪一类
    class_label(index)=1;
    %% 聚类, 将 当前类 中的点与剩余点计算两两距离，找出最小距离，将这个点也加入到 该类 点集中
    classFlag=1;
    dis(1)=0;
    label(1)=1;
%     DMat=[];
    for i=2:num
        min_d = Inf;
        cursor = find(class_label==classFlag);
        for j=1:size(data, 1)% 寻找最类似于已有集的点
%           d = nearestPoint(data(j, :), mdl.data(cursor,:));
            d = distanceChange(data(j, :), mdl.data(cursor,:));
            if d < min_d
                min_d = d;
                min_i = j;
            end
        end
%         D=densityBasedonNeighbor(mdl.data(cursor,:),data(min_i, :),5);
%         DMat=[DMat D];
        
        [avg,~]=classStatus([mdl.data(cursor,:);data(min_i, :)]);
        
        dis(i) = avg;
        if avg <= threshold % 这里不宜设置点数过小时无条件加入
            class_label(p_label(min_i))=classFlag;
            label(i)=label(i-1);
        else
            classFlag=classFlag+1;
            class_label(p_label(min_i))=classFlag;
            label(i)=classFlag;
        end
        finded = [finded; data(min_i, :)];
        data(min_i, :) = [];
        pre_index(p_label(min_i)) = i;
        p_label(min_i) = [];
    end
    %% 
    classNum=max(class_label);
    if isPlot==true
        figure;
        plot(dis);
        title('未进行合并相似类前的样本与类的平均距离与样本归属类');
        hold on;
        plot([0, num + 1], [threshold, threshold]);
        xlim([0, num + 1]);
        % plot label
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
        
        data1 = data(index, :); % 属于该类数据
        min_d = Inf;
        min_j = 0;
        for j=1:classNum
            if i == j
                continue
            end
            index = find(label == j); % 另一个类的
            if size(index, 2) < size(data1, 1) % 若不是个大类，则跳过
                continue
            end
            data2 = data(index, :); % 新类的数据
            d = nearestPoint(data1,data2);
            if d < min_d
                min_d = d;
                min_j = j;
            end
        end
        
        if min_j == 0
            continue;
        end
        
        tmp=[data1;data(find(label == min_j), :)];
        [densityMin,~]=classStatus(tmp);
%         fprintf('%.4f\n',densityMin);
        if densityMin < mergeThreshold || size(data1,1)<=fix(num/15)
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
     %% 样本平均化
% %     fprintf('%d %d\n',size(mdl.data, 1),classNum);% 打印总样本数和类数
%     sampleNum=floor( size(mdl.data, 1)/classNum );% 计算平均化样本数（向下取整）
%     for i=1:classNum
%         index=find(label==i);
%         inNum=sampleNum-length( index );% 需要添加的样本数
% %         fprintf('class %d has %d points. sampleNum is %d.\n',i,length( index ),sampleNum);
%         % 重要的是移到小类的点适不适合这个类，而不是这个点之前在大类是什么位置的
%         if inNum<=0 % 大类跳过
%             continue;
%         end
%         smallData=data(index,:); % 小类样本
%         bigClassTag=[]; indexTag=[];
%         bigClassData=[];
%         % 大类样本
%         for k=1:classNum
%             index=find(label==k);
%             if sampleNum<length( index )
%                 bigClassData=[bigClassData ;data(index,:)];
%                 bigClassTag=[bigClassTag repmat( k,[1,length(index)] )];% 标记,标明为哪个类
%                 indexTag=[indexTag index];
%             end
%         end    
%         % I代表位置
%         [~,I] = sort ( sum(pdist2(bigClassData,smallData),2) ); % 这里的指标暂取平均距离
%         % 刷新标记
%         bigClassTag=bigClassTag(I);
%         indexTag=indexTag(I);
%         % 从大类中取出最适合的inNum个点
%         j=1; k=0;
%         while j<=inNum
%             k=k+1;
%             index=find( label== bigClassTag(k) );
%             if length(index)<=sampleNum
%                 continue;
%             end
%             label( indexTag(k) )=i;
%             j=j+1;
%         end
%     end
% %     检查一下平均情况
% %     fprintf('-------------------------------------------------------\n');
%     for i=1:classNum
%         index=find(label==i);
% %         fprintf('class %d has %d points. sampleNum is %d.\n',i,length( index ),sampleNum);
%     end
    %% 画图看下分类的准确性
    dis(1) = dis(2);
    if isPlot==true
        figure;
        plot(dis);
        title("合并类之后的平均距离情况与样本归属类");
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
    mdl.label = label;
    mdl.classNum = classNum;
    
    %% remove outcast
%     for i=1:classNum
%         index=find(mdl.label==i);
%         data=mdl.data(index,:);
%         center=mean(data);
%         dis=sum((data-center).^2,2);
%         [B,I]=sort(dis,'descend');
%         rmIndex=index(I(1:3));
%         mdl.data( rmIndex ,:)=[];
%         mdl.label(rmIndex)=[];
%     end
%%
%     fprintf('--%d--',classNum);
end