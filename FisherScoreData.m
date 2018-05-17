function [ fisherTrainData, fisherTestData ] = FisherScoreData( trainData, testData, threshold )
%   threshold should be [-1, 1]
%   Detailed explanation goes here
    score = FisherScore(trainData, size(trainData, 2), size(trainData, 1), 9);
    score = premnmx(score);
    score = (score + 1) .* 5 ./ 2;
   
    [~, index] = sort(score, 'descend');
    index = index(score >= threshold);
    fisherTrainData = trainData(:, index);
    fisherTestData = testData(:, index);
end