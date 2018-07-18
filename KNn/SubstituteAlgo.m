function [trainData,trainLabel] = SubstituteAlgo(inx,trainData,trainLabel,trueLabel,chosenOne)
% inx 为 输入测试数据，trainData，trainLabel
UNACCEPT = [ 0 0 1 0 0 1 1 1 1;
             0 0 0 0 0 0 1 1 1;
             1 0 0 1 0 0 1 1 1;
             0 0 1 0 0 1 0 0 1;
             0 0 0 0 0 0 0 0 0;
             1 0 0 1 0 0 1 0 0;
             1 1 1 0 0 1 0 0 1;
             1 1 1 0 0 0 0 0 0;
             1 1 1 1 0 0 1 0 0 ];
[datarow , ~] = size(trainData);
diffMat = repmat(inx,[datarow,1]) - trainData ;
distanceMat = sum(abs(diffMat).^1,2);
[~ , IX] = sort(distanceMat,'ascend'); %IX表示训练样本中的行号，最上为离测试样本最近的
falseLabel= trainLabel(chosenOne); %猜错为哪一类
%% 替换同类
tmpLabel = trainLabel(IX,:); %表示类标签，最上为离测试样本最近的
sameIndex = find(tmpLabel==trueLabel); % 提取出正确标签所对应的行号，最上为离测试样本最近的
IX=IX(sameIndex); % 提取出正确标签对应的训练样本行号，最上为离训练样本最近的
OuterIndex = IX(end); % 正确标签距离测试样本最远的行号
trainData(OuterIndex,:) = inx; % 用测试样本代替
%% 删去误导性异类
if UNACCEPT(trueLabel,falseLabel)==1 % 错误是否可接受
    trainData(chosenOne,:)=[]; % 将训练样本中误导性样本删除
    trainLabel(chosenOne)=[]; % 标签也删除
end
%% 替代策略
% 替代的话就是当样本发生错误时  
% 把训练集中相同标签的样本中与 当前测试样本 最远的样本替换成当前测试样本

% 然后考虑一下错误的样本是否是对于当前实际类别的不可接受的样本。如果是就删除掉错误的类别中与当前样本最近的样本
% 举个例子，1号键对应的不可接受的情况为｛3，6，7，8，9｝