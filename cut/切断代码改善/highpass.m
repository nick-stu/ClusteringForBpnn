%----------------------------------
% �������ڸ�ͨ�˲�����
% data:�����ź�
% fs:data�Ĳ���Ƶ��
% f:��ͨ�˲��Ľ�ֹƵ��
% dataOut:�˲�����ź�
% ---------------------------------
function [dataOut]=highpass(data,fs,f)
%��ͨ�˲����˳�ֱ����fHZ���µ��ź�
[b,a] = butter(2,f/fs*2,'high');
dataOut = filter(b,a,data);