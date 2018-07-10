function [relustLabel,chosenOne] = KNN(inx,data,labels,k)
%   inx 为 输入测试数据，data为样本数据，labels为样本标签
[datarow , ~] = size(data);
diffMat = repmat(inx,[datarow,1]) - data ;
distanceMat = sum(abs(diffMat).^1,2);
[B , IX] = sort(distanceMat,'ascend');
len = min(k,length(B));
relustLabel = mode(labels(IX(1:len)));
if k==1
    chosenOne = IX(1);
else
    chosenOne = 0;
end
end