%----------------------------------
% �������ڵ�ͨ�˲�����
% data:�����ź�
% fs:data�Ĳ���Ƶ��
% f:��ͨ�˲��Ľ�ֹƵ��
% dataOut:�˲�����ź�
% ---------------------------------
function [dataOut]=lowpass(data,fs,f)
%��ͨ�˲����˳� f HZ���ϵ��ź�
[b,a] = butter(8,f/fs*2);
dataOut = filter(b,a,data);