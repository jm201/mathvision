clc,clear,close all

%% data load
data_a = load('data_a.txt');
data_b = load('data_b.txt');
data = [data_a;data_b];

cov_data = cov(data); % 1,500개 data 공분산행렬

[eigvector_data, eigvalue_data] = eig(cov_data) % 공분산행렬의 고유값 및 고유벡터

percent_data = (diag(eigvalue_data)./sum(diag(eigvalue_data)))*100 % 데이터 분산 보존율 계산

coeff = pca(data); % 주성분 계수 계산

data_2d = data*coeff(:,1:2); % 데이터를 부분공간 S에 투영

%% 데이터 2D 가시화
figure(1)
plot(data_2d(1:1000,1),data_2d(1:1000,2),'r*')
hold on
grid on
plot(data_2d(1001:1500,1),data_2d(1001:1500,2),'b*')
legend('A','B')
hold off
title('2D(DataA, DataB)')
xlabel('x')
ylabel('y')

mapcaplot(data) % PCA plot

%% 2D Gaussian
x1 = -15:0.1:15;
x2 = -4:0.1:8;
[X1,X2] = meshgrid(x1,x2);
X =[X1(:),X2(:)];

% A data
cov_A = cov(data_2d(1:1000,:));
mean_A = mean(data_2d(1:1000,:));
y = mvnpdf(X,mean_A,cov_A);
y = reshape(y,length(x2),length(x1));

% B data
cov_B = cov(data_2d(1001:1500,:));
mean_B = mean(data_2d(1001:1500,:));
y1 = mvnpdf(X,mean_B,cov_B);
y1 = reshape(y1,length(x2),length(x1));

figure(2)
h=surf(x1,x2,y,'edgecolor','none');
set(h,'edgecolor','none')
colormap jet
hold on
surf(x1,x2,y1,'edgecolor','none')
title('2D Gaussian')
xlabel('x')
ylabel('y')

%% test data
test_data = load('test.txt');
test_2d = test_data*coeff(:,1:2);

mahal_distance=zeros(4,2);

% matlab Mahalanobis function
for i = 1:2
mahal_distance(i,1)=mahal(test_2d(i,:),data_2d(1:1000,:));    
mahal_distance(i,2)=mahal(test_2d(i,:),data_2d(1001:1500,:)); 
end

mean_AB = [mean_A; mean_B];

% Mahalanobis equation
for i = 1:2
    for j = 1:2
        if j==1
            data_cov = cov_A;
        else
            data_cov = cov_B;
        end
mahal_distance(i+2,j)=(test_2d(i,:)-mean_AB(j,:))*data_cov^-1*(test_2d(i,:)-mean_AB(j,:))';   
    end
end

mahal_distance
