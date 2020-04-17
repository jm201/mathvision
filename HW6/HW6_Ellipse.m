%% HW6 Ellipse

clc,clear,close all
while(1)
    n = input('입력할 점의 개수는? (4개이상) \n');
    if(n<4)
        disp('다시 입력하세요.(4개 이상)')
    else
        break;
    end
end

figure(1)
Ellipse_Point = ginput(n) % 임의의 점 n개 입력
A = [Ellipse_Point(:,1).^2 Ellipse_Point(:,1).*Ellipse_Point(:,2) Ellipse_Point(:,2).^2 Ellipse_Point(:,1) Ellipse_Point(:,2) ones(n,1)] % Ax=0 선형시스템의 A행렬
[U, S, V] = svd(A)        % A행렬의 SVD
x = V(:,end)              % Ax=0을 만족하는 해 x 


center_y = (-x(4)/x(1) + 2*x(5)/x(2))/(-4*x(3)/x(2) + x(2)/x(1));
center_x = -2*x(3)*center_y/x(2) -x(5)/x(2);

syms X Y 
ellipse_equation = x(1)*X^2 + x(2)*X*Y + x(3)*Y^2 + x(4)*X + x(5)*Y + x(6);
plot(Ellipse_Point(:,1),Ellipse_Point(:,2),'ro')
for i = 1:length(Ellipse_Point)
    text(Ellipse_Point(i,1)+0.02,Ellipse_Point(i,2)-0.01,num2str(i),'Color','b')
end
hold on
grid on
fimplicit(ellipse_equation)
plot(center_x,center_y,'b.')
xlabel('x')
ylabel('y')
