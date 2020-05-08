clc,clear,close all

M = 360;
people_number = 40;
motion = 10;
ext = '.png';   % 이미지 확장자
image_row = 56; % image_size : 56 x 46
image_col = 46;

%% image load
image_data = zeros(M,image_row*image_col);
image_data_index = zeros(M,2);
count = 0;
for i = 1:people_number
    for j = 2:motion
        count = count + 1;
        image_name = strcat('s',num2str(i),'_',num2str(j),ext);
        temp_image = imread(image_name);
        image_data(count,:) = reshape(temp_image,1,image_row*image_col);
        image_data_index(count,:) = [i,j];
    end
end

%% PCA
cov_data = cov(image_data);
[eigvector,eigvalue] = eig(cov_data);
V=eigvector(:,end-9:end);

% visualization
count = 1;
figure(1)
for i = 10:-1:1
    V1 = V(:,i);
    V1 = scaling(V1);
    eig1 = reshape(V1,56,46);
    subplot(2,5,count)
    imshow(uint8(eig1))
    xlabel(['V',num2str(count)])
    count = count + 1;
end
sgtitle('eigenvectors visualization')

%% face reconstruction
people_index = 15;
image_name = strcat('s',num2str(people_index),'_',num2str(1),ext);
face_image = imread(image_name);
face_image = reshape(face_image,1,image_row*image_col);

vecter_number = [1 10 100 200];
for i = 1:4
    x_image = zeros(1,image_row*image_col);
    count = 0;
    temp = 0;
    for j = 1:vecter_number(i)
        coeff(j) = dot(double(face_image),eigvector(:,end-count)); 
        temp = coeff(j)*eigvector(:,end-count);
        x_image = x_image + temp;
        count = count+1;
    end
    x_image = scaling(x_image);
    figure(2)
    subplot(1,5,i)
    imshow(uint8(reshape(x_image,56,46)))
    xlabel(['k=',num2str(vecter_number(i))])
end
subplot(1,5,5)
imshow(reshape(face_image,56,46))
xlabel('original image')
sgtitle('face reconstruction')

%% image recognition
k=200;
coeff = zeros(1,k);
x_image = zeros(1,image_row*image_col);
x1_image = zeros(1,image_row*image_col);
id_index = zeros(1,people_number);
for i = 1:people_number
    del = zeros(1,M);
    image_name = strcat('s',num2str(i),'_',num2str(1),ext);
    first_image = imread(image_name);
    first_image = reshape(first_image,1,image_row*image_col);
    for j = 1:k
        coeff(j) = dot(double(first_image),eigvector(:,end-(j-1)));
        temp = coeff(j)*eigvector(:,end-(j-1));
        x_image = x_image + temp;
        x_image = scaling(x_image);
    end
        for K=1:M
            y_image = image_data(K,:);
            for J=1:k
                coeff(J) = dot(y_image,eigvector(:,end-(J-1)));
                temp1 = coeff(J)*eigvector(:,end-(J-1));
                x1_image = x1_image + temp1; 
                x1_image = scaling(x1_image);
            end
            del(K)=abs(norm(x1_image-x_image));
        end
    [value,id_index(i)] = min(del);
end

%% image recognition result plot
count = 1;
for i = 1:8
    figure(i+2)
    for j = 1:5
        image_name = strcat('s',num2str(count),'_',num2str(1),ext);
        first_image = imread(image_name);
        subplot(2,5,j)
        imshow(first_image)
        xlabel(['s',num2str(count),'\_',num2str(1)])
        subplot(2,5,j+5)
        imshow(uint8(reshape(image_data(id_index(count),:),56,46)))
        xlabel(['s',num2str(image_data_index(id_index(count),1)),'\_',num2str(image_data_index(id_index(count),2))])
        count = count + 1;
    end
end

count = 0;
for i = 1:40
    if(image_data_index(id_index(1,i))-i==0)
        count = count +1;
    end    
end

fprintf('총 이미지 %d장 성공 %d장 실패 %d장 성공률(%%) = %f%% \n',people_number,count,i-count,(count/i)*100)
%% my image
my_image = imread('jmk.png');
my_image = rgb2gray(my_image);
my_image = double(reshape(my_image,image_row*image_col,1));

k=10;
coeff = zeros(1,k);
del = zeros(1,M);
x_image = zeros(image_row*image_col,1);
x1_image = zeros(image_row*image_col,1);


for i = 1:k
    coeff(i) = dot(double(my_image),eigvector(:,end-(i-1)));
    temp = coeff(i)*eigvector(:,end-(i-1));
    x_image = x_image + temp;
    x_image = scaling(x_image);
end

for i = 1:M
    y_image = image_data(i,:);
    for J=1:k
        coeff(J) = dot(y_image,eigvector(:,end-(J-1)));
        temp1 = coeff(J)*eigvector(:,end-(J-1));
        x1_image = x1_image + temp1;
        x1_image = scaling(x1_image);
    end
    del(i)=abs(norm(x1_image-x_image));
end
[value,index] = min(del);

figure(11)
subplot(1,2,1)
imshow(uint8(reshape(my_image,56,46)))
title('input image')
subplot(1,2,2)
imshow(uint8(reshape(image_data(index,:),56,46)))
title('output image')

function [v] = scaling(v)
    v = ((v-min(v))/(max(v)-min(v)))*255; 
end
