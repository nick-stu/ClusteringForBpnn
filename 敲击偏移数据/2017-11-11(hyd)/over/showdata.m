clc;clear;close all
%��ȡ.txt�ļ�����
% data1=dlmread('4-1.txt');
data1=dlmread('channel_0.txt');
% data1=dlmread('X1-1.txt');
% data1=dlmread('5-3.txt');

figure(1);     
% subplot(311);
plot(data1);ylabel('���');xlabel('������');  
title('���մ�Sensor + Amplifier��ʱ��ͼ');
% subplot(312);
% plot(data2);ylabel('�� ��');xlabel  ('������');   
% subplot(313);
% plot(data3);
ylabel('���');
xlabel( '������'); 