function [ bestNet ] = NNTrain2( trainData, trainLabel )
%NNTRAIN Summary of this function goes here
%   Detailed explanation goes here

    % 用到的一些值，
    perNum = size(trainData, 1) / 9;
    perTrainNum = perNum * 0.6; % 训练样本占0.6
    trainNum = perTrainNum * 9;
    perTestNum = perNum - perTrainNum;
    testNum = perTestNum * 9;

    % 从样本中分出训练和测试样本
    randomIndex = 1:perNum;
    randomIndex = randomIndex(randperm(perNum));

    traData = zeros(trainNum, size(trainData, 2));
    traLabel = zeros(trainNum, 9);
    testData = zeros(testNum, size(trainData, 2));
    testLabel = zeros(testNum, 9);
    for i=1:9
        range1 = (i - 1) * perNum + randomIndex(perTrainNum + 1:end);
        range2 = (i - 1) * perTestNum + 1:(i * perTestNum);
        testData(range2, :) = trainData(range1, :);
        testLabel(range2, :) = trainLabel(range1, :);
        range1 = (i - 1) * perNum + randomIndex(1:perTrainNum);
        range2 = (i - 1) * perTrainNum + 1:(i * perTrainNum);
        traData(range2, :) = trainData(range1, :);
        traLabel(range2, :) = trainLabel(range1, :);
    end

    % 创建神经网络
    net =  newff(minmax(traData'), [140 9], {'logsig', 'logsig'}, 'traingdx');

    %设置训练参数
    net.trainparam.show = 50;
    net.trainparam.epochs = 1000;
    net.trainparam.goal = 0.001;
    net.trainParam.lr = 0.01;
    net.performParam.regularization = 0;

    %开始训练
    net = train( net, traData' , traLabel' );

    % 计算精度
    %仿真
    Y = sim( net , testData' );
    validNum = 0;
    correctNum = 0;
    s = size(Y, 2);
    for i = 1 : s
        [m , index] = max(Y( : , i));
        if m > 0
            validNum = validNum + 1;
            if( 1 == testLabel(i, index) )
                correctNum = correctNum + 1 ; 
            end
        end
    end
    fprintf("%.4f\n", correctNum / validNum);
    bestNet = net;
end

