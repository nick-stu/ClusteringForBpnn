load('/Users/chenlin/Documents/iot/NNData/2017-9-19(cwq)/WMRdata_0.6k.mat');
trainData = decimate_data;

load('/Users/chenlin/Documents/iot/NNData/2017-9-19(cwq)/WMRTdata_0.6k.mat');
testData = decimate_data;

% 生成标签
label = zeros(270, 9);
for i=1:9
    for j=1:30
        label((i - 1) * 30 + j, i) = 1;
    end
end
testLabel=[6 3 7 8 5 1 2 4 9 6 1 7 4 9 5 8 3 2 2 8 9 1 5 7 6 3 4 2 4 5 3 8 7 1 6 9 5 2 1 7 6 8 9 3 4 5 4 1 8 6 9 3 2 7 8 9 2 3 7 4 1 5 6 7 4 8 2 6 9 3 1 5 6 1 9 4 3 8 7 2 5 9 2 1 6 8 3 7 4 5];

% 训练网络
net = NNTrain(trainData, label);

% 测试数据
correctNum = 0;
validNum = 0;
for i=1:size(testData, 1)
    res = bpnn(net, testData(i, :), 0); % 测试
    if res == -1
        disp("判断失败");
    else
        validNum = validNum + 1;
        if res == testLabel(i)
            correctNum = correctNum + 1;
        end
    end
end

fprintf("精度: %.4f\n", correctNum / validNum);