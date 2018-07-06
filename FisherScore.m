function [ score ] = FisherScore( data, people_num, interval )
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
    %��������
    dim = size(data, 2);
    sample_size = size(data, 1);
    per_num = sample_size / people_num;%ÿһ����������Ŀ

    %����ÿһάÿ????��ƽ��??
    everyClassAverage = zeros(people_num, dim);
    for i=1:people_num
        everyClassAverage(i, :) = mean(data((i - 1) * per_num + 1 : i * per_num, :));
    end

    %����ÿһά����ƽ��??
    allAverage = mean(data);

    %�������A
    A = mean((everyClassAverage - allAverage) .^ 2);

    %�����ĸB
    B = zeros(1, dim);
    for i=1:people_num
        B(1, :) = B(1, :) + mean((data((i - 1) * per_num + 1 : i * per_num, :) - everyClassAverage(i, :)) .^ 2);
    end
    B = B ./ people_num;

    %������F
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

