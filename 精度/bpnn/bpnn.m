function [ label ] = bpnn( net, testData, confident )
% 对数据进行分类
%  net 训练模型
%  testData为一个样本数据
%  confident 置信度，小于置信度返回-1
    Y = sim( net , testData(:) );
    [probability, index] = max(Y); 
    if probability >= confident
        label = index;
    else
        label = -1;
    end
end
