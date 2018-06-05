function [inner,diff,threshold,avg]=featureExploration(data)
[A,std]=classStatus(data);
threshold=A ;
% threshold=threshold*1.4;
%% Split data
over=data(1:30,:);
below=data(31:60,:);
left=data(61:90,:);
right=data(91:120,:);
center=data(121:150,:);
%% cumulate
for i=1:30
    [tmp,~]=classStatus(below(1:i,:));
    fprintf('%.4f  %.4f\n',tmp,threshold);
end
fprintf('---------------------\n');
for i=1:30
    [tmp,~]=classStatus([below ;center(1:i,:) ]);
    fprintf('%.4f  %.4f\n',tmp,threshold);
end
%% each type 
inner=[];
[avg,~]=classStatus(over); inner=[inner avg];
[avg,~]=classStatus(below); inner=[inner avg];
[avg,~]=classStatus(left); inner=[inner avg];
[avg,~]=classStatus(right); inner=[inner avg];
[avg,~]=classStatus(center); inner=[inner avg];
%% merged types 
diff=[];
[avg,~]=classStatus([over below]); diff=[diff avg];
[avg,~]=classStatus([left right]); diff=[diff avg];

[avg,~]=classStatus([below left]); diff=[diff avg];
[avg,~]=classStatus([below right]); diff=[diff avg];
[avg,~]=classStatus([over left]); diff=[diff avg];
[avg,~]=classStatus([over right]); diff=[diff avg];

[avg,~]=classStatus([over center]); diff=[diff avg];
[avg,~]=classStatus([left center]); diff=[diff avg];
[avg,~]=classStatus([below center]); diff=[diff avg];
[avg,~]=classStatus([right center]); diff=[diff avg];

%% plot
% figure;
% ALL=[inner diff];
% plot(ALL,'-*k');hold on;
% plot([5.5 5.5],[max(ALL)+1 min(ALL)-1]); % gap
% plot([1 15],[A A],'b--');% avg
% plot([1 15],[threshold threshold],'r');% threshold
% plot([1 5],[mean(inner) mean(inner)]);% inner mean
% plot([6 15],[mean(diff) mean(diff)]);% diff mean
end