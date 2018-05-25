function [ trainData, testData ] = AdjustableSplit( data , perTrainNum )
%for NINEKEYS
    perNum = size(data, 1) / 9;
    trainNum = perTrainNum * 9;
    perTestNum = perNum - perTrainNum;
    testNum = perTestNum * 9;

    % random index
    randomIndex = 1:perNum;
    randomIndex = randomIndex(randperm(perNum));

    trainData = zeros(trainNum, size(data, 2));
    testData = zeros(testNum, size(data, 2));
    for i=1:9
        range1 = (i - 1) * perNum + randomIndex(perTrainNum + 1:end); %data index
        range2 = (i - 1) * perTestNum + 1:(i * perTestNum); %testData index
        testData(range2, :) = data(range1, :);
        range1 = (i - 1) * perNum + randomIndex(1:perTrainNum); %data index
        range2 = (i - 1) * perTrainNum + 1:(i * perTrainNum); %trainData index
        trainData(range2, :) = data(range1, :);
    end
end