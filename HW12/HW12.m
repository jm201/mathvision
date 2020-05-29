clc,clear,close all
%% point input
n = 80; % data number
point_x = linspace(-3,3,n);
point_y = -2*point_x + 0.5;
points = [point_x ; point_y]';

%% initialization
sample_number = 3;          % sampling 개수
iteration = [5 10 20 50];   % 반복 횟수
threshold = 10^-2;
outlier_ratio = 90;
outlier_number = floor(outlier_ratio*n/100);
outlier_index = randperm(n,outlier_number)';
points(outlier_index,:) = points(outlier_index,:) + randn(outlier_number,2)/2;

%% RANSAC
syms X Y
for i = 1:length(iteration)
    cnt_max = 0;
    cnt_cur = 0;
    best_model = zeros(1,n);
    for j = 1:iteration(i)
        sample_index = randperm(n,sample_number); % Sampleing
        x = points(sample_index,1);
        y = points(sample_index,2);
        
        A = [x , y,ones(sample_number,1)];
        [U,S,V] = svd(A);
        x_hat = V(:,end);
        
        distance = abs(x_hat(1)*points(:,1)+x_hat(2)*points(:,2)+x_hat(3))/sqrt(x_hat(1)^2+x_hat(2)^2); % 점과 직선의 사이 거리 계산
        cnt_cur = length(find(distance<threshold)); % threshold보다 작은 데이터들의 개수
        
        if(cnt_cur>cnt_max) % 최적 모델 update
            cnt_points = find(distance<threshold);
            xx = x;
            yy = y;
            cnt_max = cnt_cur;
            best_model = x_hat;
            line_equation = X*best_model(1) + best_model(2)*Y + best_model(3); % 직선 근사
        end
    end
    %% plot
    figure(1)
    sgtitle('RANSAC')
    subplot(2,2,i)
    p1=plot(points(:,1),points(:,2),'bo');
    hold on
    p2=plot(points(outlier_index,1),points(outlier_index,2),'ko');
    p3=fimplicit(line_equation,'linewidth',1.5);
    p4=plot(xx,yy,'ro','Markersize',10);
    h = [p1 p2 p3 p4];
    legend(h,'inlier data','outlier data','ax+by+c=0','sampling data')
    title(['iteration: ',num2str(iteration(i)),' threshold:',num2str(threshold),' outlier:',num2str(outlier_ratio),'%'])
    axis auto
    hold off
end
