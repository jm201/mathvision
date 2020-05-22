clc,clear,close all
%%
original_image = imread('hw11_sample.png');
[image_row, image_col] = size(original_image);
background_image = zeros(image_row,image_col);

A = zeros(image_row*image_col,6);
B = zeros(image_row*image_col,1);
count = 0;

%% LS
for i = 1:image_row
    for j = 1:image_col
        count = count +1;
        A(count,:) = [i^2 j^2 i*j i j 1];
        B(count,1) = double(original_image(i,j));
    end
end

A_pinv = (A'*A)^-1*A';
X = A_pinv*B;

for i = 1:image_row
    for j = 1:image_col
        background_image(i,j) = X(1)*i^2 + X(2)*j^2 + X(3)*i*j + X(4)*i +X(5)*j +X(6);
    end
end

figure(1)
imshow(original_image)
result_image = double(original_image)-background_image;
temp = result_image;

background_image = uint8(background_image);

figure(2)
imshow(background_image)

figure(3)
imshow(result_image)

%% BW 
for i = 1:image_row
    for j = 1:image_col
        if(result_image(i,j)<=-6)
            result_image(i,j) = 255;
        else
            result_image(i,j) = 0;
        end
    end
end

figure(4)
imshow(uint8(result_image))
