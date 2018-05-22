function [accuracy, net ] = NN( trainData, testData, testLabel )
% 使用神经网络
trainData = featureNormalize(trainData);
testData = featureNormalize(testData);

% 生成训练标签
rows = size(trainData, 1);
singleNum = rows / 9;
trainLabel = zeros(rows, 9);
for i=1:9
    for j=1:singleNum
        trainLabel((i - 1) * singleNum + j, i) = 1;
    end
end
%%  Sample Disorder
% index = randperm(rows,rows);
% trainData = trainData(index,:);
% trainLabel = trainLabel(index,:);
%% 训练网络
net = NNTrain(trainData, trainLabel);

% 仿真
Y = sim( net , testData' );

% 统计识别正确率
validNum = 0;
correctNum = 0;
s = size(Y, 2);
for i = 1 : s
    [m , index] = max(Y( : , i));
    if m > 0
        validNum = validNum + 1;
        if((size(testLabel, 2) == 9 && testLabel(i, index) == 1) )%|| index  == testLabel(i))
            correctNum = correctNum + 1 ; 
        end
    else
        disp('--------------Invalid--------------');
        pause;
    end
end
accuracy=correctNum / validNum;
fprintf('%.4f\n',accuracy);
% fprintf('%d/%d\n', correctNum , validNum);