function [accuracy]= CalAccuracy_KNN_withUpdate(trainData, testData, trainLabel, testLabel, k)
    trueNum = 0;
    rows = size(testData,1);
    for i = 1:rows
        [result,chosenOne] = KNN(testData(i,:),trainData,trainLabel,k);
        if result == testLabel(i)
            trueNum = trueNum + 1;
        else
            trainData(chosenOne,:)=testData(i,:); % 删去误导性样本,用最新的进行替代
            trainLabel(chosenOne)=testLabel(i);
        end
    end
    accuracy = trueNum / rows;
end