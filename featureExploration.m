function [inner,diff,threshold,avg]=featureExploration(data)
[A,std]=classStatus_MhtD(data);
threshold=A - std;
threshold=threshold*1.15;
%% Split data
over=data(1:30,:);
below=data(31:60,:);
left=data(61:90,:);
right=data(91:120,:);
center=data(121:150,:);
%% cumulate
% for i=1:30
%     [tmp,~]=classStatus_MhtD(left(1:i,:));
%     fprintf('%.4f  %.4f\n',tmp,threshold);
% end
% fprintf('-----------------------\n');
% for i=1:30
%     [tmp,~]=classStatus_MhtD([left ;center(1:i,:)]);
%     fprintf('%.4f  %.4f\n',tmp,threshold);
% end
%% each type 
inner=[];
[avg,~]=classStatus_MhtD(over); inner=[inner avg];
[avg,~]=classStatus_MhtD(below); inner=[inner avg];
[avg,~]=classStatus_MhtD(left); inner=[inner avg];
[avg,~]=classStatus_MhtD(right); inner=[inner avg];
[avg,~]=classStatus_MhtD(center); inner=[inner avg];
%% merged types 
diff=[];

[avg,~]=classStatus_MhtD([over; center]); diff=[diff avg];
[avg,~]=classStatus_MhtD([left; center]); diff=[diff avg];
[avg,~]=classStatus_MhtD([below; center]); diff=[diff avg];
[avg,~]=classStatus_MhtD([right; center]); diff=[diff avg];

[avg,~]=classStatus_MhtD([below; left]); diff=[diff avg];
[avg,~]=classStatus_MhtD([below; right]); diff=[diff avg];
[avg,~]=classStatus_MhtD([over; left]); diff=[diff avg];
[avg,~]=classStatus_MhtD([over; right]); diff=[diff avg];

[avg,~]=classStatus_MhtD([over; below]); diff=[diff avg];
[avg,~]=classStatus_MhtD([left; right]); diff=[diff avg];
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