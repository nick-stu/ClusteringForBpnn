function [accuracy]= CalAccuracy_KNN (trainData, testData, trainLabel, testLabel, k)
    trueNum = 0;
    rows = size(testData,1);
    for i = 1:rows
        [result,~] = KNN(testData(i,:),trainData,trainLabel,k);
        if result == testLabel(i)
            trueNum = trueNum + 1;
        end
    end
    accuracy = trueNum / rows;
end