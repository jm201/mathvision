%% HW6 Circle
clc,clear,close all

while(1)
    n = input('입력할 점의 개수는? (3개이상) \n');
    if(n<3)
        disp('다시 입력하세요.(3개 이상)')
    else
        break;
    end
end

%% Circle plot
figure(1)
Circle_Point = ginput(n)                                                   % 임의의 점 n개 입력

A = [Circle_Point(:,1), Circle_Point(:,2) ones(n,1)]                       % Ax=b 선형시스템의 A행렬 
B = (-Circle_Point(:,1).^2)+(-Circle_Point(:,2).^2)                        % Ax=b 선형시스팀의 B행렬

Pseudo_inverse = (A'*A)^-1*A'                                              % A행렬의 의사 역행렬
x = Pseudo_inverse*B                                                       % 선형시스템의 해 x 

circle_center = [-x(1)/2 -x(2)/2]                                          % 중심점 계산
circle_radius = sqrt(x(1)^2+x(2)^2-4*x(3))/2                               % 반지름 계산

syms X Y
circle_equation = X^2+Y^2+x(1)*X+x(2)*Y+x(3)
plot(Circle_Point(:,1),Circle_Point(:,2),'ro')
hold on
for i = 1:length(Circle_Point)
    text(Circle_Point(i,1)+0.02,Circle_Point(i,2)-0.01,num2str(i),'Color','b')
end
fimplicit(circle_equation) 
plot(circle_center(1),circle_center(2),'b.') 
text(circle_center(1)-0.01,circle_center(2)-0.02,'Center','Color','b')

hold on
line([circle_center(1) circle_center(1)+circle_radius],[circle_center(2) circle_center(2)],'Color','red','LineStyle','--')
axis([0 1 0 1])
axis equal
grid on
xlabel('x')
ylabel('y')
