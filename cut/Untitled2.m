figure;
[S1,F1,T1,P1] = spectrogram(data(1,:),256,250,256,65000);
surf(T1,F1,10*log10(P1),'edgecolor','none');
ylim([0 3000]);  
view(0,90);  
xlabel('Time (Seconds)'); ylabel('Hz');