function [accuracy, net ] = NN( trainData, testData, testLabel )
% ʹ��������

% trainData = normalization(trainData);
% testData = normalization(testData);

% ����ѵ����ǩ
rows = size(trainData, 1);
singleNum = rows / 9;
trainLabel = zeros(rows, 9);
for i=1:9
    for j=1:singleNum
        trainLabel((i - 1) * singleNum + j, i) = 1;
    end
end
% ѵ������
net = NNTrain(trainData, trainLabel);

% ����
Y = sim( net , testData' );

% ͳ��ʶ����ȷ��
validNum = 0;
correctNum = 0;
s = size(Y, 2);
for i = 1 : s
    [m , index] = max(Y( : , i));
    if m > 0
        validNum = validNum + 1;
        if((size(testLabel, 2) == 9 && testLabel(i, index) == 1) || index  == testLabel(i))
            correctNum = correctNum + 1 ; 
        end
    end
end
accuracy=correctNum / validNum;
fprintf('%.4f\n', correctNum / validNum);
