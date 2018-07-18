function [accuracy]= CalAccuracy_KNN_withUpdate(trainData, testData, trainLabel, testLabel, k)
    trueNum = 0;
    rows = size(testData,1);
    for i = 1:rows
        [result,chosenOne] = KNN(testData(i,:),trainData,trainLabel,k);
        if result == testLabel(i)
            trueNum = trueNum + 1;
        else
%             trainData(chosenOne,:)=testData(i,:); % ɾȥ����ѵ������,���жϴ���Ĳ��������������
%             trainLabel(chosenOne)=testLabel(i);
%             trainData=[trainData ;testData(i,:)]; % ��ɾȥ����ѵ������,�����жϴ���Ĳ�������
%             trainLabel=[trainLabel; testLabel(i)];
            [trainData,trainLabel] = SubstituteAlgo(testData(i,:),trainData,trainLabel,testLabel(i),chosenOne);
        end
    end
    accuracy = trueNum / rows;
end