function [ weight ] = calVariance( data, keyNum )
% ͨ���������������Ȩ��

% ����ÿһά�ķ���
m = mean(data);
d = mean((data - m) .^ 2);

% ����ÿһ��ÿһά�ķ���
PER_KEY_NUM = size(data, 1) / keyNum;
dc = zeros(keyNum, size(data, 2));
for k=1:keyNum
    kdata = data((k - 1) * PER_KEY_NUM + 1 : k * PER_KEY_NUM, :);
    m = mean(kdata);
    dc(k, :) = mean((kdata - m) .^ 2);
end

weight = d ./ sum(dc);

end

