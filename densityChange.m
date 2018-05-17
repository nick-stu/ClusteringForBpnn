function [ ratio,flag ] = densityChange( sample, traindata )
    [num,~]=size(traindata);
    flag=1;
    if num==1
        distance=pdist2(sample,traindata);
        ratio=sum(distance(:))/ num;
        flag=0;
    else
        total=pdist2(traindata,traindata);
        density1 = sum(total(:))/(num*(num-1));
        total=pdist2([sample;traindata],[sample; traindata]);
        density2 = sum(total(:))/(num*(num+1));
        
        ratio=density1/density2;
        ratio=abs(ratio-1);
    end
end