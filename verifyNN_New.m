function [accuracy] = verifyNN_New( trainData, testData,testLabel )
loop=5;
A=[];B=[];
for i=1:loop
    %% 生成训练标签
    [trainLabel,tag,verifyTrainData] = verifyGetLabelsNew(trainData);
    
    [tmp,~]=NN(verifyTrainData, testData, testLabel);
    A=[A tmp];
    
    %% Z-score
    verifyTrainData = featureNormalize(verifyTrainData);
    verifyTestData = featureNormalize(testData);
    %% 计算聚类后精度
    tmp=CalcAccuracy(verifyTrainData,verifyTestData,testLabel,trainLabel,tag);
    B=[B tmp];
end
fprintf('A avg:%.4f',mean(A(:)));
fprintf('  A avgDiff:%.4f\n',md(A));
fprintf('B avg:%.4f',mean(B(:)));
fprintf('  B avgDiff:%.4f\n',md(B));
accuracy=[mean(A(:)) mean(B(:))];

% function [accuracy] = verifyNN_New( trainData, testData,testLabel )
% loop=5;
% %% 生成训练标签
% [trainLabel,tag,trainData] = verifyGetLabelsNew(trainData);
% %% 
% A=[];
% for i=1:loop
%     [tmp,~]=NN(trainData, testData, testLabel);
%     A=[A tmp];
% end
% fprintf('A avg:%.4f',mean(A(:)));
% fprintf('  A avgDiff:%.4f\n',md(A));
% %% Z-score
% trainData = featureNormalize(trainData);
% testData = featureNormalize(testData);
% %% 计算聚类后精度
% B=[];
% for i=1:loop
%     tmp=CalcAccuracy(trainData,testData,testLabel,trainLabel,tag);
%     B=[B tmp];
% end
% fprintf('B avg:%.4f',mean(B(:)));
% fprintf('  B avgDiff:%.4f\n',md(B));
% accuracy=[mean(A(:)) mean(B(:))];