clc;clear;close all

data=dlmread('channel_0.txt');

figure(1);     
plot(data);ylabel('���');xlabel('������');  
title('���մ�Sensor + Amplifier��ʱ��ͼ');
ylabel('���');
xlabel( '������'); 

%�����ļ�������
value=input('�����ļ����֣�');
a=floor(value/10);
b=mod(value,10);
outName=[num2str(a),'-',num2str(b)];

eval(['!rename' , ',channel_0.txt' , [',',outName,'.txt']]); %������channel_0.txt