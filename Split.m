function [ trainData, testData ] = Split( data )
%   split data into trainData(60%) and testData(40%)
%   Detailed explanation goes here
    % useful varï¼?    
    perNum = size(data, 1) / 9;
%     perTrainNum = perNum * 0.6; % trainData percent
     perTrainNum = 20; % trainData percent
    trainNum = perTrainNum * 9;
    perTestNum = perNum - perTrainNum;
    testNum = perTestNum * 9;

    % random index
    randomIndex = 1:perNum;
    randomIndex = randomIndex(randperm(perNum));

    trainData = zeros(trainNum, size(data, 2));
    testData = zeros(testNum, size(data, 2));
    for i=1:9
        range1 = (i - 1) * perNum + randomIndex(perTrainNum + 1:end);
        range2 = (i - 1) * perTestNum + 1:(i * perTestNum);
        testData(range2, :) = data(range1, :);
        range1 = (i - 1) * perNum + randomIndex(1:perTrainNum);
        range2 = (i - 1) * perTrainNum + 1:(i * perTrainNum);
        trainData(range2, :) = data(range1, :);
    end
end