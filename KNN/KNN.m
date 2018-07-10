function [relustLabel,chosenOne] = KNN(inx,data,labels,k)
%   inx Ϊ ����������ݣ�dataΪ�������ݣ�labelsΪ������ǩ
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