function [ result,peakBeg,peakEnd ] = seg_var( data,fs )
%ʹ�÷����ʾ�źŵ�����

    % ��������
    dataLen=length(data);   % �źų���
    frameEnergy=[];         % ֡����
    frameLen=200/1000*fs;   % ֡��
    frameMove=10/1000*fs;   % ֡��
    frameNum=(dataLen-frameLen)/frameMove+1;    % ֡��
    thres=0.15;                % ��ֵ
    minPeakLen=7;           % �ɽ��ܵ�һ���������ܳ��ȣ�֡�������С�ڸó��ȣ��򽫸÷�ɾ��
    minInterval=5;          % �ɽ��ܵ����ڷ���С�����֡���������������С�ڸü�������һ���屻ɾ��
    peakLen=20;             % һ������Ҫ�ĳ��ȣ�֡��
    delBegLen=0;           % �źſ�ͷ��Ҫƽ���ķ峤�ȣ��粻��Ҫƽ���źſ�ͷ����Ϊ0
    Debug=1;                % �Ƿ�ͼ
    isWarning=1;            % �Ƿ񾯸�
    
    % ��ȡ֡����
    for i=1:frameNum
        frameBeg=(i-1)*frameMove+1;             % ÿ֡�Ŀ�ʼλ��
        frameEnd=frameBeg+frameLen-1;           % ÿ֡�Ľ���λ��
        tmpFrame=data(frameBeg:frameEnd);       % ��ȡ��ǰ֡
        tmpFrame=(tmpFrame-mean(tmpFrame));
        tmpFrame=tmpFrame.*hamming(frameLen)';  % �Ӵ�����������
        tmpEnergty=sum(tmpFrame.^2);            % ���㷽��
        frameEnergy=[frameEnergy,tmpEnergty];   % ��¼֡����
    end
    
    % ��ǰ�漸֡��С��ʹǰ�漸֡��Ӱ����ֵ�ж�
    for i=1:delBegLen
        frameEnergy(i)=frameEnergy(i)*i/delBegLen/2;
    end
    
    % Ѱ����ʼ���������
    begFrame=[];
    endFrame=[];
    flag=1;
    for i=1:frameNum
        % ��ʼ��
        if frameEnergy(i)>thres && flag==1
            begFrame=[begFrame,i];
            flag=0;
        end
        % ������
        if frameEnergy(i)<=thres && flag==0
            endFrame=[endFrame,i];
            flag=1;
        end
    end
    
    % ɾ�����̷�
    peakNum=length(endFrame);
    i=1;
    while i<=peakNum
        if endFrame(i)-begFrame(i)<minPeakLen
            if isWarning==1
                disp('���ּ��̷壡��ɾ����')
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % �ϲ����ڷ�
    peakNum=length(endFrame);
    i=2;
    while i<=peakNum
        if begFrame(i)-endFrame(i-1)<minInterval
            if isWarning==1
                disp('�������ڷ����̫������ɾ����һ���塣')
            end
            begFrame(i)=[];
            endFrame(i)=[];
            i=i-1;
            peakNum=peakNum-1;
        end
        i=i+1;
    end
    
    % �쳣���
    if isempty(begFrame)
        disp('û���и�壡');
        result=-1;
        return
    end
    
    % ��ȡԭʼ���ݵ���ʼ�����λ��
    endFrame=begFrame+peakLen;      %�����ȡ�̶�����
    begFrame=begFrame-3;            %���ӻ�����
    endFrame=endFrame+10;           %���ӻ�����
    peakBeg=begFrame.*frameMove;    %������ʵ��ʼλ��
    peakEnd=endFrame.*frameMove;    %������ʵ����λ��
    result=1;
    
    % ���ֽ����㳬���źų��ȵ����
    if peakEnd(end)>dataLen
        if peakEnd(end)-dataLen>peakLen*frameMove*0.25
            % �÷岻������
            disp('��ʼ������������鲻һ�£����Զ�ɾ�����һ����ʼ��');
            peakBeg(end)=[];
            peakEnd(end)=[];
        else
            % �÷��㹻����
            disp('��ʼ������������鲻һ�£����Զ�ȡ�ź�β��Ϊ������');
            peakEnd(end)=dataLen;      %������ʵ����λ��
            peakBeg(end)=peakEnd(end)-(peakEnd(1)-peakBeg(1))+1;    %������ʵ��ʼλ��
        end
    end
    
    % ��ͼ
    if Debug==1
        % ԭͼ��
        h=figure;
        subplot(2,1,1);
        
        set(h,'Position',[10,410,500,350]);
        plot(data);
        
        hold on;
        for i=1:length(peakBeg)
            plot([peakBeg(i),peakBeg(i)],[min(data),max(data)],'r');
            plot([peakEnd(i),peakEnd(i)],[min(data),max(data)],'r');
        end

        % ֡����ͼ��
        hold on;
        subplot(2,1,2);
        set(h,'Position',[510,410,500,350]);
        plot(frameEnergy);
        hold on;
        for i=1:length(begFrame)
            plot([begFrame(i),begFrame(i)],[0,max(frameEnergy)],'r');
            plot([endFrame(i),endFrame(i)],[0,max(frameEnergy)],'r');
        end
    end
end

