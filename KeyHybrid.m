center=data(601:750,:);%5
left=data(451:600,:);%4
right=data(751:900,:);%6
over=data(151:300,:);%2
below=data(1051:1200,:);%8
%%
overIndex= 1:30;   belowIndex= 31:60;   leftIndex= 61:90;    rightIndex= 91:120;   centerIndex= 121:150;

center_left=center(leftIndex,:);
center_right=center(rightIndex,:);
center_over=center(overIndex,:);
center_below=center(belowIndex,:);
center_center=center(centerIndex,:);

left_right=left(rightIndex,:);
right_left=right(leftIndex,:);
over_below=over(belowIndex,:);
below_over=below(overIndex,:);
% 
% PCAtest([center;left]);
% PCAtest([center;right]);
% PCAtest([center;over]);
% PCAtest([center;below]);

MDStest([center_left;center_center]);
% MDStest([center_right;right_left]);
% MDStest([center_over;over_below]);
% MDStest([center_below;below_over]);