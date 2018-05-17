function [ bestNet, bestAccuracy ] = bpnnTrain( data, label )
%训练神经网络
%   data: 每行一个样本数据
%   label: 每行一个样本标签，每行九列

    rows = size(data, 1); % 样本个数
    perNum = rows / 9; % 每个按键的样本个数
    trainNum = rows * 0.6; % 训练样本个数
    perTrainNum = trainNum / 9; % 每个按键训练样本个数
    testNum = rows * 0.4; % 测试样本个数
    perTestNum = testNum / 9; % 每个按键测试样本个数
    
%     bestNet = NNTrain(data, label);
    %统计识别正确率
%     Y = sim(bestNet, data');
%     validNum = 0;
%     correctNum = 0;
%     s = size(Y, 2);
%     for i = 1 : s
%         [m , index] = max(Y( : , i));
%         if m > 0
%             validNum = validNum + 1;
%             if size(label, 2) == 1
%                 if(label(i) == index)
%                     correctNum = correctNum + 1 ; 
%                 end
%             else
%                 if(label(i, index)  == 1)
%                     correctNum = correctNum + 1 ; 
%                 end
%             end
%         end
%     end
%     fprintf("训练精度: %.4f\n", correctNum / validNum);
%     return
    
    % 训练20次,找出最佳模型
    bestAccuracy = 0;
    for trainTime=1:20
        % 打乱训练样本顺序
        randomIndex = 1:perNum;
        randomIndex = randomIndex(randperm(perNum));

        trainData = zeros(trainNum, size(data, 2));
        trainLabel = zeros(trainNum, 9);
        testData = zeros(testNum, size(data, 2));
        testLabel = zeros(testNum, 9);

        % 分离训练样本、标签和测试样本、标签
        for i=1:9
            range1 = (i - 1) * perNum + randomIndex(perTrainNum + 1:end);
            range2 = (i - 1) * perTestNum + 1:(i * perTestNum);
            testData(range2, :) = data(range1, :);
            testLabel(range2, :) = label(range1, :);

            range1 = (i - 1) * perNum + randomIndex(1:perTrainNum);
            range2 = (i - 1) * perTrainNum + 1:(i * perTrainNum);
            trainData(range2, :) = data(range1, :);
            trainLabel(range2, :) = label(range1, :);
        end
        
        % 训练网络
        net = NNTrain(trainData, trainLabel);

        %仿真
        Y = sim( net , testData' );

        %统计识别正确率
        validNum = 0;
        correctNum = 0;
        s = size(Y, 2);
        for i = 1 : s
            [m , index] = max(Y( : , i));
            if m > 0
                validNum = validNum + 1;
                if size(testLabel, 2) == 1
                    if(testLabel(i) == index)
                        correctNum = correctNum + 1 ; 
                    end
                else
                    if(testLabel(i, index)  == 1)
                        correctNum = correctNum + 1 ; 
                    end
                end
            end
        end
        
        accuracy = correctNum / validNum;
        if accuracy > bestAccuracy
            bestNet = net;
            bestAccuracy = accuracy;
%             fprintf("best accuracy: %f\n", bestAccuracy);
        end
    end
end
