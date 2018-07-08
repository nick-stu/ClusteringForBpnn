function [] = sfft( segmentSample1,fs )
%PLOTSTFT ª≠ ±∆µÕº
%   
    %∂Ã ±∏µ¿Ô“∂±‰ªª
    figure;
    [S1,F1,T1,P1] = spectrogram(segmentSample1,256,250,256,fs);
    surf(T1,F1,10*log10(P1),'edgecolor','none');
    axis tight;
    view(0,90);
    xlabel('Time(Seconds)');
    ylabel('Hz');

end


