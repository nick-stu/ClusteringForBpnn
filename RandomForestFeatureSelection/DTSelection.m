function [feature,Demension] = DTSelection (data ,datadiff,mode)
%       
%       决策树筛选连续的维度的特征
%           mode：
%               多类      ‘mul’
%               一类      ‘one’
%
%       输入：
%           data         ：   样本数据
%           datadiff     ：  样本份数（人）
%           mode        ：   模式。现仅支持‘one’
%           times         :     筛选进行times次
%           

    if mode == 'one'
        Label = zeros(1,size(data,1)/datadiff * 2 );
        Label(1:size(Label,2)/2) = 1;
        Demension = zeros(size(data,2),1);
        times = 2;
        
        for i = 1:datadiff
            Data(1:size(data,1)/datadiff,:) = data((1+(i-1)*size(data,1)/datadiff):i*size(data,1)/datadiff,:);
            for kk = 1:times
                for j = 1:size(data,1)/datadiff
                    tmp = randperm(datadiff,1);
                    if tmp ~= i
                        Data(size(Data,1)+1,:) = data(((tmp-1)*size(data,1)/datadiff + randperm(size(data,1)/datadiff,1)),:);
                    else
                        while tmp == i
                            tmp = randperm(datadiff,1);
                        end
                        Data(size(Data,1)+1,:) = data(((tmp-1)*size(data,1)/datadiff + randperm(size(data,1)/datadiff,1)),:);
                    
                    end
                end
                NodeArray = CreateTree(Data,Label);

                for itr = 2:size(NodeArray,2)
                    Demension(NodeArray(itr).Demension) = Demension(NodeArray(itr).Demension)+0.5;
                end
                
                Data((size(data,1)/datadiff+1):size(data,1)/datadiff*2,:) = [];
            end
            
        end
        feature = data(:,find(Demension>0));
        Demension'
    end
end