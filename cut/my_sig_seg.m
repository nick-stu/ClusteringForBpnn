function [myssbeg,myssend,peakSize,interval]=my_sig_seg(data,fs,Lm,Rm,ethresh,zcthresh,minlen,maxInter,minInter,segLen,Debug)
% �ر�˵����
% ���������и������źţ����������С����ֵ�������Ǵ�����ֵ����Ҫ�޸Ĵ�����иʼ�Ǹ�whileѭ��
% function to find endpoints of a speech utterance
%
%     %�и�Ų����Ĳ�������
%     %֡��
%     Lm=7;
%     %֡��
%     Rm=2;
%     %������С��ֵ
%     ethresh=40;
%     %�����������ֵ
%     zcthresh=50;
%
%     %��̵ĽŲ����ĳ��ȣ�����ȥ������̫С�ķ壩
%     minlen  = 20;
%     %ͬһ���Ų��������ڷ�������(���ںϲ�ͬһ���Ų��������ڷ�)
%     maxInter=20;
%     %��ͬ�Ų��������ڷ����С���(����ȥ��������С���ȣ������ڼ��̫С�ķ�)
%     minInter=100;
%     segLen:�и�ÿһ���źŵĳ��ȣ�֡����
%     Debug���Ƿ�ͼ
% Inputs
%   data:original signal ,Ҫ�и���źţ�Ϊ������
%   fs: sampling rate in Hz������Ƶ��
%   Lm:Lm is analysis frame window duration in msec (40); L is analysis frame
%   window duration in samples (computed from sampling rate)
%   Rm:Rm is analysis frame window shift in msec (10); R is analysis frame
%   ethresh=initial threshold on log loge contour
%   zcthresh=threshold on zero crossing rate contour
%   minlen:the minimum length of a footstep signal
%   Debug��plot the figure or not
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

%�и�Ŀ�ʼ
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
    
    %��ֹ���һ�ԭ����λ��
    %         zcs(peak1(isav):peak2(isav))=1000;
    %��ֹ���һ�ԭ����λ��
    logen(peak1(isav):peak2(isav))=-100;
    
    isav=isav+1;
end

%determine final endpoints
%������ȥ������0
peak1s=sort(peak1(1:isav));
peak2s=sort(peak2(1:isav));

%��ͬһ���Ų��������ڷ�ϲ�
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
        %�ϲ�������󣬰ѱ��ϲ��ķ���ռ��λ��������������ǴӴ�С���ţ�˳�򲻱䣬�������ǰ��
        peak1s=peak1s(find(peak1s~=0));
        peak2s=peak2s(find(peak2s~=0));
        % ǰ���Ӧ˳�򲻱䣬���Բ����ٴ�������
        % peak1s=sort(peak1s(1:end));
        % peak2s=sort(peak2s(1:end));
        i=i+1;
    end
end

peakSize=peak2s-peak1s;

%ȥ������С����С�����������ҵļ��������ͬһ���Ų��������������������񶯷�
%�ͳ��ȴ�����С���ȵ������Ҽ��С�ڲ�ͬ�Ų��������ڷ����С������񶯷�
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
%ȥ��0�����������Ƚ��ٵ�
peak1s=peak1s(find(peak1s~=0));
peak2s=peak2s(find(peak2s~=0));

peak2s=peak1s+segLen;
peakSize=peak2s-peak1s;
interval=peak1s(2:end)-peak2s(1:end-1);
for index=1:length(peak1s)
    %         ssbeg=(beginf-1)*R+L/2+1; ssend=(endf-1)*R+L/2+1;
    myssbeg(index)=(peak1s(index)-1)*R+L/2+1; myssend(index)=(peak2s(index)-1)*R+L/2+1;
end
myssbeg=uint32(myssbeg); %ת����������
myssend=uint32(myssend); %ת����������
%     ssbeg=(peak1s(index)-1)*R+L/2+1;
%     ssend=(peak2s(index)-1)*R+L/2+1;
%
if Debug==1
    %��ͼ
    
    figure;
    subplot(211);
    set(gcf,'outerposition',get(0,'screensize'));
    % normalize speech signal to range [-1 +1]
    ym=max(abs(y));
    y=y/ym;
    
    %����ԭ�ź�
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
    %����������I find it
    
    %�����и������λ��
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
    %����ԭ�źŵ�����
    subplot(212);
    % plot log loge contour in graphics Panel 2
    plot(1:nfrm,loge,'r','LineWidth',2),xlabel('Frame Number'),...
        ylabel('log loge (dB)'),hold on,grid on;
    
    % plot each log loge centroid beginning and ending frames
    %���������������и�λ��
    for index=1:length(peak1s)
        xx=[peak1s(index) peak1s(index)];
        yy=[max(loge) min(loge)];
        plot(xx,yy,'g:','LineWidth',2);
        xx=[peak2s(index) peak2s(index)];
        plot(xx,yy,'b:','LineWidth',2);
    end
    %������ͼ�л������յ��и�λ��
    % plot beginning and ending frame lines
    for index=1:length(peak1s)
        xx=[peak1s(index) peak1s(index)];
        plot(xx,yy,'k','LineWidth',2);
        xx=[peak2s(index) peak2s(index)];
        plot(xx,yy,'k','LineWidth',2);
    end
    %������ͼ�л�����������ֵ��
    % plot log loge threshold
    xx=[1 nfrm];
    yy=[max(loge)-ethresh max(loge)-ethresh];
    plot(xx,yy,'r:','LineWidth',2); axis tight;
    axis([0 nfrm+1 min(loge) max(loge)]);
    
    %         % figure;
    %         subplot(313);
    %         %����ԭ�źŵĹ�����
    %         % plot zero crossings rate contour in graphics Panel 1
    %             plot(1:nfrm,zc,'r','LineWidth',2),xlabel('Frame Number'),...
    %                 ylabel('zc rate'),hold on,grid on;
    %
    %             %���������ʾ������и�λ��
    %         % plot each zero crossing centroid beginning and ending frames
    %             for index=1:length(peak1s)
    %                 xx=[peak1s(index) peak1s(index)];
    %                 yy=[max(zc) min(zc)];
    %                 plot(xx,yy,'g:','LineWidth',2);
    %                 xx=[peak2s(index) peak2s(index)];
    %                 plot(xx,yy,'b:','LineWidth',2);
    %             end
    %
    %              %�ڹ�����ͼ�л������յ��и�λ��
    %         % plot beginning and ending frame lines
    %         for index=1:length(peak1s)
    %                 xx=[peak1s(index) peak1s(index)];
    %                 yy=[max(zc) min(zc)];
    %                 plot(xx,yy,'k','LineWidth',2);
    %                 xx=[peak2s(index) peak2s(index)];
    %                 plot(xx,yy,'k','LineWidth',2);
    %         end
    %
    %                 %�ڹ�����ͼ�л��������ʵ���ֵ��
    %         % plot zero crossing threshold
    %                 xx=[1 nfrm];
    %                 yy=[zcthresh zcthresh];
    %                 plot(xx,yy,'r:','LineWidth',2);
    %                 axis([0 nfrm+1 min(zc) max(zc)]);
end
end