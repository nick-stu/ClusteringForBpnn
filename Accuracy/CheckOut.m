close all;
figure;plot(A');title('A');grid on;
figure;plot(B');title('B');grid on;
profit=mean(B(:))-mean(A(:));
fprintf('%.f %.f\n',mean(A(:)),mean(A(:)));
figure;
subplot(3,1,1);plot(mean(B)-mean(A),'k');title(num2str(profit));
hold on;grid on;
plot([1 size(A,2)],[0 0],'r');
plot([1 size(A,2)],[0.01 0.01],'r');
plot([1 size(A,2)],[-0.01 -0.01],'r');

subplot(3,1,2);plot(mean(A),'k');title(num2str(mean( A(:) ) ));
hold on;grid on;plot([1 size(A,2)],[mean(A(:)) mean(A(:))],'r');
subplot(3,1,3);plot(mean(B),'k');title(num2str(mean( B(:) ) ));
hold on;grid on;plot([1 size(B,2)],[mean(B(:)) mean(B(:))],'r');
