function [relustLabel,chosenOne] = KNNBasedOnDtw_MhtD(inx,data,labels,k,frontSize)
%   inx Ϊ ����������ݣ�dataΪ�������ݣ�labelsΪ������ǩ
[datarow , ~] = size(data);
diffMat = repmat(inx(frontSize+1:end),[datarow,1]) - data(:,frontSize+1:end) ;
distanceMat = sum(abs(diffMat).^1,2);
for i=1:datarow
    distanceMat(i) = distanceMat(i) + dtw(inx(1:frontSize),data(i,1:frontSize));
end
[B , IX] = sort(distanceMat,'ascend');
len = min(k,length(B));
relustLabel = mode(labels(IX(1:len)));
if k==1
    chosenOne = IX(1);
else
    chosenOne = 0;
end
end