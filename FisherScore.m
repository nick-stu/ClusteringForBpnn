function [ FisherScore ] = FisherScore( input,WeiShu,YangBenShu,LeiShu )
%UNTITLED2 此处显示有关此函数的摘要
    %导入数据
    Originaldata=input;
    EveryYangBenShu=YangBenShu/LeiShu;%每一类样本的数目
    
    %计算每一维每一类的平均值
    everyClassAverage = zeros(WeiShu,LeiShu);
    sum = 0;
    for i =1:WeiShu
        for j = 1:YangBenShu
            sum = sum + Originaldata(j,i);
            if mod(j,EveryYangBenShu)==0
                everyClassAverage(i,floor((j-1)/EveryYangBenShu+1))=sum/EveryYangBenShu;
                sum=0;
            end
        end
    end

    %计算每一维的总平均值
    allAverage = zeros(WeiShu,1);
    for i =1:WeiShu
        sum=0;
        for j=1:YangBenShu
            sum = sum + Originaldata(j,i);
        end
        allAverage(i,1)=sum/YangBenShu;
    end

    %计算分子A
    A=zeros(WeiShu,1);
    for i=1:WeiShu
        for j=1:LeiShu
            A(i,1)=A(i,1)+(everyClassAverage(i,j)-allAverage(i,1))*(everyClassAverage(i,j)-allAverage(i,1));
        end
    end

    %计算分母B
    B=zeros(WeiShu,1);
    for i=1:WeiShu
        for j=1:YangBenShu
            B(i,1)=B(i,1)+(Originaldata(j,i)-everyClassAverage(i,floor((j-1)/EveryYangBenShu)+1)) * (Originaldata(j,i)-everyClassAverage(i,floor((j-1)/EveryYangBenShu)+1));
        end
    end

    %计算结果F
    FisherScore = zeros(WeiShu,1);
    for i=1:WeiShu
        FisherScore(i,1)=A(i,1)/B(i,1);
    end

end

