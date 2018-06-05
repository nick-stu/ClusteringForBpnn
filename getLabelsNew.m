function[trainLabel,tag]=getLabelsNew(trainData,isClu)
%% ע���������õľ��ຯ�����Ƽǵø�
    if isClu==false
        %% �˹�����
        fprintf('----manual sorting----\n');
        rows = size(trainData, 1);
        singleNum = rows / 9;
        tag=[]; trainLabel=[];
        cursor=0;
        for i = 1:9
            mdl.label=...
                [ones(1,singleNum/5)*1 ones(1,singleNum/5)*2 ones(1,singleNum/5)*3 ones(1,singleNum/5)*4 ones(1,singleNum/5)*5];
            label=zeros(singleNum,rows);
            for j=1:singleNum
                label(j,mdl.label(j)+cursor)=1; 
            end
            cursor=cursor+max(mdl.label);
            tag=[tag repmat(i,[1,max(mdl.label)])];
            trainLabel=[trainLabel;label];
        end
        trainLabel(:, find( sum(trainLabel,1)==0) )=[];
        fprintf('classNum:%d\t',size(tag,2));
    else
        %% ����
        fprintf('----clustering----\n');
        rows = size(trainData, 1);
        singleNum = rows / 9;
        tag=[]; trainLabel=[];
        cursor=0;
        for i = 1:9
            mdl=clustering_offset_nearest( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
    %         mdl=clustering_offset_nearest_MhtD( trainData( (i-1)*singleNum+1 : i*singleNum,:),false );
            label=zeros(singleNum,rows);
            for j=1:singleNum
                label(j,mdl.label(j)+cursor)=1; 
            end
            cursor=cursor+mdl.classNum;
            tag=[tag repmat(i,[1,mdl.classNum])];
            trainLabel=[trainLabel;label];

            %% show detail
            for z=1:mdl.classNum
               fprintf('%d ',length(find(mdl.label==z))); 
            end
            fprintf('\n');
        end
        trainLabel(:, find( sum(trainLabel,1)==0) )=[];
        fprintf('classNum:%d\t',size(tag,2));
    end
end