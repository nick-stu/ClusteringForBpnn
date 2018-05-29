function [ out, result ] = segmain2( dataIn, fs, eth ,Inter)
%% ��������жκ������������ÿ��һ���ź�
dataOriginal=dataIn; %ԭʼ��������
%% �и�Ų����Ĳ�������
hpindex = 4000;%ȥ����ͨ�˲���ǰ�����ɸ���
min=30;
high=90; low=350;
Lm=9; %֡��
Rm=6; %֡��
ethresh = eth; %������С��ֵ
zcthresh = 2; %�����������ֵ
minlen  = 3; %��̵ĽŲ����ĳ��ȣ�����ȥ������̫С�ķ壩
maxInter=Inter; %ͬһ���Ų��������ڷ�������(���ںϲ�ͬһ���Ų��������ڷ�)
minInter=Inter; %��ͬ�Ų��������ڷ����С���(����ȥ��������С���ȣ������ڼ��̫С�ķ�)
segLen=20; %�и�ÿһ���źŵĳ��ȣ�֡����
Debug=1; %�Ƿ���ʾ�и�ʾ��ͼ
filterDebug=0; %�Ƿ���ʾ�˲�����ź�
%%
data=[]; %��ʼ��data,���ڱ�������
if filterDebug==1
    figure;
    plot(dataOriginal);
    title('ԭʼ����');
    grid;
end
%��ͨ�˲����˵�20HZ���µ�Ƶ��
hpdata=highpass(dataOriginal,fs,high);
if filterDebug==1
    figure;
    plot(hpdata);
    title('��ͨ�˲��������');
    grid;
end
hpdata=hpdata(hpindex:end); %ȥ��ǰ��100����
if filterDebug==1
    figure;
    plot(hpdata);
    title(['��ͨ�˲�','ȥ��ǰ���',num2str(hpindex),'����������']);
    grid;
end
%��ͨ�˲���ȥ����Ƶ����
lpdata=lowpass(hpdata,fs,low);

if filterDebug==1
    figure;
    plot(lpdata);
    title('��ͨ300HZ�������');
    grid;
end
[ssbeg,ssend,~]=my_sig_seg(lpdata,fs,Lm,Rm,ethresh,...
    zcthresh,minlen,maxInter,minInter,segLen,Debug); %�ж�
%     if find(cycleIndex==[6])
%         ssbeg=ssbeg(1:end-1);
%         ssend=ssend(1:end-1);
%     end

%     if length(ssbeg)~=length(ssend) || length(ssbeg)~=knockTimes
%         disp(['length(ssbeg)~=length(ssend) or length(ssbeg)~=',num2str(knockTimes)]);
%         result = -1;
%         out = [];
%         return;
%     end
%     ssbeg=ssbeg+hpindex;
%     ssend=ssend+hpindex;
out=[];

beglen=length(ssbeg);
% samplelen=length(lpdata);
fprintf('�г�%d���ź�\n',beglen);

if beglen<min
    result=-1;
%     disp('�ж�����Ҫ��')
    out=[out,-1];
    return;
end

for i=1:30
    data=[data;lpdata(ssbeg(i):ssend(i))];
end
out=data;
result=1;
end