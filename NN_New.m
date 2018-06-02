function [accuracy, net ] = NN_New( trainData, testData, testLabel, isClu )
% 使用神经网络

% 生成训练标签
[trainLabel,tag] = getLabelsNew(trainData,isClu);

[trainData,testData] = featureNormalize(trainData,testData);
%%  Sample Disorder
% rows = size(trainData,1);
% index = randperm(rows,rows);
% trainData = trainData(index,:);
% trainLabel = trainLabel(index,:);
%% 训练网络
net = NNTrainNew(trainData, trainLabel,size(tag,2));
% fprintf("please\n");
% pause;
% 仿真
Y = sim( net , testData' );

% 统计识别正确率
validNum = 0;
correctNum = 0;
s = size(Y, 2);
for i = 1 : s
    [m , index] = max(Y( : , i));
    if m > 0
        index=tag(index);
        validNum = validNum + 1;
        if testLabel(i, index) == 1% || index  == testLabel(i))
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