function [ weight ] = calVariance( data, keyNum )
% 通过方差给特征计算权重

% 计算每一维的方差
m = mean(data);
d = mean((data - m) .^ 2);

% 计算每一类每一维的方差
PER_KEY_NUM = size(data, 1) / keyNum;
dc = zeros(keyNum, size(data, 2));
for k=1:keyNum
    kdata = data((k - 1) * PER_KEY_NUM + 1 : k * PER_KEY_NUM, :);
    m = mean(kdata);
    dc(k, :) = mean((kdata - m) .^ 2);
end

weight = d ./ sum(dc);

end

