function [ score ] = FisherScore( data, people_num, interval )
%UNTITLED2 此处显示有关此函数的摘要
    %导入数据
    dim = size(data, 2);
    sample_size = size(data, 1);
    per_num = sample_size / people_num;%每一类样本的数目

    %计算每一维每????的平均??
    everyClassAverage = zeros(people_num, dim);
    for i=1:people_num
        everyClassAverage(i, :) = mean(data((i - 1) * per_num + 1 : i * per_num, :));
    end

    %计算每一维的总平均??
    allAverage = mean(data);

    %计算分子A
    A = mean((everyClassAverage - allAverage) .^ 2);

    %计算分母B
    B = zeros(1, dim);
    for i=1:people_num
        B(1, :) = B(1, :) + mean((data((i - 1) * per_num + 1 : i * per_num, :) - everyClassAverage(i, :)) .^ 2);
    end
    B = B ./ people_num;

    %计算结果F
    tmp = A ./ B;
    if interval == 1
        score = tmp;
    else
        score = zeros(1, dim / interval);

        for i=1:(dim / interval)
            score(i) = mean(tmp((i - 1) * interval + 1: i * interval));
        end
    end
end

