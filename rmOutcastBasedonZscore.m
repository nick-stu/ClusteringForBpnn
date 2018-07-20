function [index] = rmOutcastBasedonZscore(trainData)
    cols = size(trainData, 2);
    rows = size(trainData, 1);
    singleNum = rows / 9;
    index=[];
    disp=zeros(1,9);
    for i=1:9
        tmp=abs( featureNormalize( trainData((i - 1) * singleNum + 1 : i* singleNum, :),0) );
        [x,~]=find(tmp>3);
        for j=1:singleNum
           out=find(x==j);
           if length(out)>=3
              index =[index (i-1)*singleNum + j];
              disp(i)=disp(i)+1;
           end
        end
    end
    for i=1:9
        fprintf('%d   ',disp(i));
    end
end