function [feature,Demension] = DTSelection (data ,datadiff,mode)
%       
%       ������ɸѡ������ά�ȵ�����
%           mode��
%               ����      ��mul��
%               һ��      ��one��
%
%       ���룺
%           data         ��   ��������
%           datadiff     ��  �����������ˣ�
%           mode        ��   ģʽ���ֽ�֧�֡�one��
%           times         :     ɸѡ����times��
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