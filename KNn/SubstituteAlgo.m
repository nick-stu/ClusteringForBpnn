function [trainData,trainLabel] = SubstituteAlgo(inx,trainData,trainLabel,trueLabel,chosenOne)
% inx Ϊ ����������ݣ�trainData��trainLabel
UNACCEPT = [ 0 0 1 0 0 1 1 1 1;
             0 0 0 0 0 0 1 1 1;
             1 0 0 1 0 0 1 1 1;
             0 0 1 0 0 1 0 0 1;
             0 0 0 0 0 0 0 0 0;
             1 0 0 1 0 0 1 0 0;
             1 1 1 0 0 1 0 0 1;
             1 1 1 0 0 0 0 0 0;
             1 1 1 1 0 0 1 0 0 ];
[datarow , ~] = size(trainData);
diffMat = repmat(inx,[datarow,1]) - trainData ;
distanceMat = sum(abs(diffMat).^1,2);
[~ , IX] = sort(distanceMat,'ascend'); %IX��ʾѵ�������е��кţ�����Ϊ��������������
falseLabel= trainLabel(chosenOne); %�´�Ϊ��һ��
%% �滻ͬ��
tmpLabel = trainLabel(IX,:); %��ʾ���ǩ������Ϊ��������������
sameIndex = find(tmpLabel==trueLabel); % ��ȡ����ȷ��ǩ����Ӧ���кţ�����Ϊ��������������
IX=IX(sameIndex); % ��ȡ����ȷ��ǩ��Ӧ��ѵ�������кţ�����Ϊ��ѵ�����������
OuterIndex = IX(end); % ��ȷ��ǩ�������������Զ���к�
trainData(OuterIndex,:) = inx; % �ò�����������
%% ɾȥ��������
if UNACCEPT(trueLabel,falseLabel)==1 % �����Ƿ�ɽ���
    trainData(chosenOne,:)=[]; % ��ѵ����������������ɾ��
    trainLabel(chosenOne)=[]; % ��ǩҲɾ��
end
%% �������
% ����Ļ����ǵ�������������ʱ  
% ��ѵ��������ͬ��ǩ���������� ��ǰ�������� ��Զ�������滻�ɵ�ǰ��������

% Ȼ����һ�´���������Ƿ��Ƕ��ڵ�ǰʵ�����Ĳ��ɽ��ܵ�����������Ǿ�ɾ���������������뵱ǰ�������������
% �ٸ����ӣ�1�ż���Ӧ�Ĳ��ɽ��ܵ����Ϊ��3��6��7��8��9��