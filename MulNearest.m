function [nearMat]=MulNearest(data1,data2)
    rows=size(data1,1);
    center=mean(data2,1);
    nearMat=zeros(rows,1);
    for i=1:rows
        nearMat(i)=pdist2(data1(i,:),center);
    end
end