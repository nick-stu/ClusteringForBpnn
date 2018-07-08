function [myssbeg,myssend,peakSize,interval]=my_sig_seg(data,fs,Lm,Rm,ethresh,zcthresh,minlen,maxInter,minInter,segLen,Debug)
% 特别说明：
% 若是用于切割语音信号，则过零率是小于阈值，而不是大于阈值，需要修改代码的切割开始那个while循环
% function to find endpoints of a speech utterance
%
%     %切割脚步声的参数设置
%     %帧长
%     Lm=7;
%     %帧移
%     Rm=2;
%     %能量最小阈值
%     ethresh=40;
%     %过零率最大阈值
%     zcthresh=50;
%
%     %最短的脚步声的长度（用于去除长度太小的峰）
%     minlen  = 20;
%     %同一个脚步声的相邻峰的最大间隔(用于合并同一个脚步声的相邻峰)
%     maxInter=20;
%     %不同脚步声的相邻峰的最小间隔(用于去除大于最小长度，但相邻间隔太小的峰)
%     minInter=100;
%     segLen:切割每一个信号的长度（帧数）
%     Debug：是否画图
% Inputs
%   data:original signal ,要切割的信号，为行向量
%   fs: sampling rate in Hz，采样频率
%   Lm:Lm is analysis frame window duration in msec (40); L is analysis frame
%   window duration in samples (computed from sampling rate)
%   Rm:Rm is analysis frame window shift in msec (10); R is analysis frame
%   ethresh=initial threshold on log loge contour
%   zcthresh=threshold on zero crossing rate contour
%   minlen:the minimum length of a footstep signal
%   Debug：plot the figure or not
% Outputs
%   beginf: estimate of initial frame
%   endf: estimate of final frame

%R=frame shift in samples
%L=frame duration in samples
L=round(Lm*fs/1000);
R=round(Rm*fs/1000);

data = reshape(data, [], 1);
nsamples=length(data);
ss=1;
loge=[];
zc=[];
while (ss+L-1 <= nsamples)
    frame=data(ss:ss+L-1).*hamming(L);
    %loge=log energy contour of full utterance
    loge=[loge 10*log10(sum(frame.^2))];
    zc=[zc sum(abs(diff(sign(frame))))];
    ss=ss+R;
end
%nfrm=number of frames in original utterance
nfrm=length(loge);
%zc = normalized (per 10 msec) zero crossings contour for utterance
zc=zc*fs/(200*L);

y=data;
zcs=zc;

% normalize log loge contour so that peak is at 0 db
logem=max(loge);
loge(find(loge < logem - 60))=logem-60;
logen=loge-logem;

% force first frame to be below threshold
if (logen(1) > -ethresh-1) logen(1)=-ethresh-1;
end

% force last frame to be below threshold
if (logen(nfrm) > -ethresh-1) logen(nfrm)=-ethresh-1;
end

isav=1;

%切割的开始
while(1)
    % using threshold of 0 (dB) -thresh, find the strongest centroid and zero
    % out the region for future checks
    % peak1 is the lower peak, peak2 is the higher peak
    logem=max(logen);
    if (logem < -ethresh)
        isav=isav-1;
        break;
    end
    
    %         zcm=min(zcs);
    %         peak=find(zcs == zcm);
    %        if (zcm > zcthresh || peak(1) < 5 || peak(1) > nfrm-5)
    % %         if (zcm > zcthresh || peak(1) < 5 || peak(1) > nfrm-5)
    %             isav=isav-1;
    %             break;
    %         end
    
    peak=find(logen == logem);
    %         peaklow=find((logen(1:peak(1)-1) < -ethresh) & (zcs(1:peak(1)-1) > zcthresh));
    peaklow=find((logen(1:peak(1)-1) < -ethresh));
    peak1(isav)=peaklow(length(peaklow));
    %         peakhi=find(logen(peak(1)+1:nfrm) < -ethresh & zcs(peak(1)+1:nfrm) > zcthresh);
    peakhi=find(logen(peak(1)+1:nfrm) < -ethresh);
    peak2(isav)=peakhi(1)+peak(1);
    peak2(isav)=peakhi(1)+peak(1);
    
    %防止又找回原来的位置
    %         zcs(peak1(isav):peak2(isav))=1000;
    %防止又找回原来的位置
    logen(peak1(isav):peak2(isav))=-100;
    
    isav=isav+1;
end

%determine final endpoints
%排序且去掉最后的0
peak1s=sort(peak1(1:isav));
peak2s=sort(peak2(1:isav));

%把同一个脚步声的相邻峰合并
flag=1;
while(flag==1)
    flag=0;
    i=1;
    while (i<=length(peak1s))
        if(i~=1 && i~=length(peak1s))
            if (abs(peak1s(i)-peak2s(i-1)) <= abs(peak2s(i)-peak1s(i+1)) && abs(peak1s(i)-peak2s(i-1)) <= maxInter)
                peak2s(i-1)=peak2s(i);
                peak1s(i)=0;
                peak2s(i)=0;
                flag=1;
                i=1-1;
            elseif (abs(peak1s(i)-peak2s(i-1)) >= abs(peak2s(i)-peak1s(i+1)) && abs(peak2s(i)-peak1s(i+1))<= maxInter)
                peak1s(i+1)=peak1s(i);
                peak1s(i)=0;
                peak2s(i)=0;
                flag=1;
                i=1-1;
            end
        elseif (i==1 && length(peak1s)>1 && abs(peak2s(i)-peak1s(i+1))<= maxInter)
            peak1s(i+1)=peak1s(i);
            peak1s(i)=0;
            peak2s(i)=0;
            flag=1;
            i=1-1;
        elseif (i==length(peaks) && abs(peak1s(i)-peak2s(i-1))<= maxInter)
            peak2s(i-1)=peak2s(i);
            peak1s(i)=0;
            peak2s(i)=0;
            flag=1;
            i=1-1;
        end
        % update peak1s, peak2s and determine final endpoints
        %合并两个峰后，把被合并的峰所占的位置清楚掉，排序还是从大到小来排，顺序不变，后面得向前挤
        peak1s=peak1s(find(peak1s~=0));
        peak2s=peak2s(find(peak2s~=0));
        % 前后对应顺序不变，所以不用再次排序了
        % peak1s=sort(peak1s(1:end));
        % peak2s=sort(peak2s(1:end));
        i=i+1;
    end
end

peakSize=peak2s-peak1s;

%去除长度小于最小长度且离左右的间隔都大于同一个脚步声的两个峰的最大间隔的振动峰
%和长度大于最小长度但离左右间隔小于不同脚步声的相邻峰的最小间隔的振动峰
for i=1:length(peak1s)
    if (peak2s(i)-peak1s(i) < minlen)
        peak1s(i)=0;
        peak2s(i)=0;
    else
        if (i~=length(peak1s) && abs(peak2s(i)-peak1s(i+1)) < minInter)
            if peakSize(i)>= peakSize(i+1)
                peak1s(i+1)=0;
                peak2s(i+1)=0;
            else
                peak1s(i)=0;
                peak2s(i)=0;
            end
        end
    end
end
%去掉0，即舍弃长度较少的
peak1s=peak1s(find(peak1s~=0));
peak2s=peak2s(find(peak2s~=0));

peak2s=peak1s+segLen;
peakSize=peak2s-peak1s;
interval=peak1s(2:end)-peak2s(1:end-1);
for index=1:length(peak1s)
    %         ssbeg=(beginf-1)*R+L/2+1; ssend=(endf-1)*R+L/2+1;
    myssbeg(index)=(peak1s(index)-1)*R+L/2+1; myssend(index)=(peak2s(index)-1)*R+L/2+1;
end
myssbeg=uint32(myssbeg); %转成整数类型
myssend=uint32(myssend); %转成整数类型
%     ssbeg=(peak1s(index)-1)*R+L/2+1;
%     ssend=(peak2s(index)-1)*R+L/2+1;
%
if Debug==1
    %画图
    
    figure;
    subplot(211);
    set(gcf,'outerposition',get(0,'screensize'));
    % normalize speech signal to range [-1 +1]
    ym=max(abs(y));
    y=y/ym;
    
    %画出原信号
    % align samples of waveform with frames of representation
    ss1=L/2+1-R;
    % check that ss1 doesn't go negative; check that es1 doesn't exceed length
    % of speech file
    if (ss1 < 1) ss1=1; end
    es1=L/2+1+nfrm*R;
    if (es1 > length(y)) es1=length(y); end
    
    %             xpp=['Time in Samples; fs=',num2str(fs),' samples/second'];
    plot(uint32(ss1):uint32(es1),y(uint32(ss1):uint32(es1)),'b'),xlabel('Samples'),...
        ylabel('Amplitude'),grid on, axis([1 length(y) min(y)-0.1 max(y)+0.1]);
    %哈哈哈哈，I find it
    
    %画出切割出来的位置
    hold on;
    for index=1:length(peak1s)
        %         ssbeg=(beginf-1)*R+L/2+1; ssend=(endf-1)*R+L/2+1;
        ssbeg=(peak1s(index)-1)*R+L/2+1; ssend=(peak2s(index)-1)*R+L/2+1;
        xx=[ssbeg ssbeg]; yy=[min(y) max(y)];
        plot(xx,yy,'k','LineWidth',2);
        xx=[ssend ssend];
        plot(xx,yy,'k','LineWidth',2);
        axis([ss1 es1 min(y) max(y)]);
    end
    %画出原信号的能量
    subplot(212);
    % plot log loge contour in graphics Panel 2
    plot(1:nfrm,loge,'r','LineWidth',2),xlabel('Frame Number'),...
        ylabel('log loge (dB)'),hold on,grid on;
    
    % plot each log loge centroid beginning and ending frames
    %画出能量决定的切割位置
    for index=1:length(peak1s)
        xx=[peak1s(index) peak1s(index)];
        yy=[max(loge) min(loge)];
        plot(xx,yy,'g:','LineWidth',2);
        xx=[peak2s(index) peak2s(index)];
        plot(xx,yy,'b:','LineWidth',2);
    end
    %在能量图中画出最终的切割位置
    % plot beginning and ending frame lines
    for index=1:length(peak1s)
        xx=[peak1s(index) peak1s(index)];
        plot(xx,yy,'k','LineWidth',2);
        xx=[peak2s(index) peak2s(index)];
        plot(xx,yy,'k','LineWidth',2);
    end
    %在能量图中画出能量的阈值线
    % plot log loge threshold
    xx=[1 nfrm];
    yy=[max(loge)-ethresh max(loge)-ethresh];
    plot(xx,yy,'r:','LineWidth',2); axis tight;
    axis([0 nfrm+1 min(loge) max(loge)]);
    
    %         % figure;
    %         subplot(313);
    %         %画出原信号的过零率
    %         % plot zero crossings rate contour in graphics Panel 1
    %             plot(1:nfrm,zc,'r','LineWidth',2),xlabel('Frame Number'),...
    %                 ylabel('zc rate'),hold on,grid on;
    %
    %             %画出过零率决定的切割位置
    %         % plot each zero crossing centroid beginning and ending frames
    %             for index=1:length(peak1s)
    %                 xx=[peak1s(index) peak1s(index)];
    %                 yy=[max(zc) min(zc)];
    %                 plot(xx,yy,'g:','LineWidth',2);
    %                 xx=[peak2s(index) peak2s(index)];
    %                 plot(xx,yy,'b:','LineWidth',2);
    %             end
    %
    %              %在过零率图中画出最终的切割位置
    %         % plot beginning and ending frame lines
    %         for index=1:length(peak1s)
    %                 xx=[peak1s(index) peak1s(index)];
    %                 yy=[max(zc) min(zc)];
    %                 plot(xx,yy,'k','LineWidth',2);
    %                 xx=[peak2s(index) peak2s(index)];
    %                 plot(xx,yy,'k','LineWidth',2);
    %         end
    %
    %                 %在过零率图中画出过零率的阈值线
    %         % plot zero crossing threshold
    %                 xx=[1 nfrm];
    %                 yy=[zcthresh zcthresh];
    %                 plot(xx,yy,'r:','LineWidth',2);
    %                 axis([0 nfrm+1 min(zc) max(zc)]);
end
end