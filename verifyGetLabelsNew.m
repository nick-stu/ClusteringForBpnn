function[verifyTrainLabel,verifyTag,verifyTrainData]=verifyGetLabelsNew(trainData)
    rows = size(trainData, 1);
    singleNum = rows / 9; % 原训练样本每个键位的样本数
    tag=[]; % 键位--类对应标签
    trainLabelTmp=[];
    verifyTrainData=[];
    verifyTrainLabel=[];
    numLabel=[]; % 类样本数
    classNumLabel=[]; % 键位类数
    innerOrder=[]; % 键位内聚类序号
    for i = 1:9
        %%
        mdl=clustering_offset_nearest( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
        for j=1:mdl.classNum
            numLabel=[numLabel length(find(mdl.label==j))];
        end
        
        tag=[tag repmat(i,[1,mdl.classNum])];
        innerOrder=[innerOrder 1:mdl.classNum];
        trainLabelTmp=[trainLabelTmp;mdl.label];
        classNumLabel=[classNumLabel mdl.classNum];
    end

    %% findMIN
    minclass=min(classNumLabel); % 键位的最小聚类数
    if minclass==1
        error('聚类过度,不适合验证');
    end
    %% 设置样本数，即找出最大的sampleNum，即符合所有键位中的都至少存在minclass个类的样本数大于sampleNum
    sampleNumMat=[];
    for i=1:9
        index=find(tag==i);
        tmp=numLabel(index);
        tmp=sort(tmp,'descend'); % 这里为descend，因为我们是要选出最大的最小
        sampleNumMat=[sampleNumMat tmp(1:minclass)];
    end
    sampleNum=min(sampleNumMat);
    fprintf('minclass:%d sampleNum: %d\n',minclass,sampleNum);
    %% 给每个键位中将被选出的类打标记
    %% 选出有何标准？先来后到吗？
    lectMat=zeros(9,max(classNumLabel)); % 对应键位将被选中的类，序号为键位内类序号
    flagMat=ones(1,9)*(-1)*minclass;
    for i=1:length(numLabel)
        if numLabel(i)>=sampleNum 
            if flagMat( tag(i) )<0
                flagMat( tag(i) )=flagMat( tag(i) )+1;
                lectMat( tag(i),innerOrder(i) )=1;
            end
        end
    end
    %% 等分选出，训练数据与训练标签
    verifyTag=[];
    cursor=0;
    for i = 1:9
        tmpLabel=trainLabelTmp(i,:);
        trainDataTmp=trainData( (i-1)*singleNum+1 : i*singleNum,:);
        outindex=find(lectMat(i,:)==1); % 该键位被选中的类
        for j=1:minclass
            %% 设置标签
            label=zeros(sampleNum ,minclass*9);
            label(:,cursor+j)=1;
            innerClassNum=outindex(j); % 该类的键位内序号
            index=find(tmpLabel==innerClassNum); % 该类的标签
            %% 随机取sampleNum个数
            delMat=randperm(length(index),length(index)-sampleNum);
            index(delMat)=[];
            verifyTrainData=[verifyTrainData ; trainDataTmp(index,:)];
            verifyTrainLabel=[verifyTrainLabel;label];
        end
        cursor=cursor+minclass;
        verifyTag=[verifyTag repmat(i,[1,minclass])];
    end
    %----------------------------------------------------------------------------- 验证一下是否输出正确
    %% partialTrainData
%     partialTrainData=[];
%     for i=1:9
%         partialTrainData=[partialTrainData;
%             verifyTrainData( (i-1)*(sampleNum*minclass)+1 : (i-1)*(sampleNum*minclass)+sampleNum ,:)];
%     end
    %% randomCluster
%     fprintf('randomCluster \n');
%     for i=1:9
%        randomTmp=verifyTrainData( (i-1)*(sampleNum*minclass)+1 : i*(sampleNum*minclass) ,:); 
%        randomSq=randperm((sampleNum*minclass),(sampleNum*minclass));
%        randomTmp=randomTmp(randomSq,:);
%        verifyTrainData( (i-1)*(sampleNum*minclass)+1 : i*(sampleNum*minclass) ,:)=randomTmp;
%     end
end