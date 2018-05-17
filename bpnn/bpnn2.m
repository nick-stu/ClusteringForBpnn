function [ label, probility ] = bpnn( net, testData, n )
% 对数据进行分类
%  net 训练模型
%  testData为一个样本数据
    Y = sim( net , testData(:) );
    [value, index] = sort(Y);
    label = index(9 - n + 1:n);
    probility = value(9 - n + 1:n);
end
