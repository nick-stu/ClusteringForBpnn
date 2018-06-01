function [ out, result ] = segmain2( dataIn, fs, eth ,Inter)
%% 输出的是切段后的数据样本，每行一个信号
dataOriginal=dataIn; %原始加载数据
%% 切割脚步声的参数设置
hpindex = 4000;%去掉高通滤波后前面若干个点
min=30;
high=20; low=300;
Lm=9; %帧长
Rm=6; %帧移
ethresh = eth; %能量最小阈值
zcthresh = 2; %过零率最大阈值
minlen  = 3; %最短的脚步声的长度（用于去除长度太小的峰）
maxInter=Inter; %同一个脚步声的相邻峰的最大间隔(用于合并同一个脚步声的相邻峰)
minInter=Inter; %不同脚步声的相邻峰的最小间隔(用于去除大于最小长度，但相邻间隔太小的峰)
segLen=20; %切割每一个信号的长度（帧数）
Debug=1; %是否显示切割示意图
filterDebug=0; %是否显示滤波后的信号
%%
data=[]; %初始化data,用于保存数据
if filterDebug==1
    figure;
    plot(dataOriginal);
    title('原始数据');
    grid;
end
%高通滤波，滤掉20HZ以下的频率
hpdata=highpass(dataOriginal,fs,high);
if filterDebug==1
    figure;
    plot(hpdata);
    title('高通滤波后的数据');
    grid;
end
hpdata=hpdata(hpindex:end); %去掉前面100个点
if filterDebug==1
    figure;
    plot(hpdata);
    title(['高通滤波','去掉前面的',num2str(hpindex),'个点后的数据']);
    grid;
end
%低通滤波，去掉高频噪音
lpdata=lowpass(hpdata,fs,low);

if filterDebug==1
    figure;
    plot(lpdata);
    title('低通300HZ后的数据');
    grid;
end
[ssbeg,ssend,~]=my_sig_seg(lpdata,fs,Lm,Rm,ethresh,...
    zcthresh,minlen,maxInter,minInter,segLen,Debug); %切断
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
fprintf('切出%d个信号\n',beglen);

if beglen<min
    result=-1;
%     disp('切断少于要求')
    out=[out,-1];
    return;
end

for i=1:min
    data=[data;lpdata(ssbeg(i):ssend(i))];
end
out=data;
result=1;
end