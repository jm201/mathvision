clc,clear,close all

while(1)
    n = input('How many points do you want to enter? (2 or more) \n');
    if(n<2)
        disp('Please, reenter 2 or more points.')
    else
        break;
    end
end

figure(1)
points = ginput(n);
%% y=ax+b
A = [points(:,1),ones(n,1)];
B = points(:,2);
sigmazero_check = 0;

[U,S,V] = svd(A);   % SVD

% 특이값 중 0이 있는지 확인
for i = 1:2
    if(S(i,i)==0)
        sigmazero_check = 1;
        break;
    else
        S(i,i) = 1/S(i,i);
    end
end
if(sigmazero_check==1)
    X1 = V(:,i);
    x = A(:,1);
    y = X1(1)*A(:,1)+X1(2);
else
    x = linspace(-5,5,n);
    A_pinv = V'*S'*U';                      % Pseudo Inverse
    X1 = A_pinv*B;
    y = X1(1)*x+X1(2);
end
%% ax+by+c=0
syms X Y
points1 = [A(:,1) B, A(:,2)];
[U,S,V] = svd(points1);
X2 = V(:,end);
line_equation = X2(1)*X + X2(2)*Y + X2(3);  % ax+by+c=0
%% Plot
p1=plot(points(:,1),points(:,2),'ko');      % points
xlabel('x')
ylabel('y')
title(['n=',num2str(n)])
hold on
grid on
p2=plot(x,y,'-g');                          % y=ax+b
p3=fimplicit(line_equation,'-r');           % ax+by+c=0
hold off
axis equal
axis([-2 2 -2 2])
h = [p1 p2 p3];
legend(h,'point','y=ax+b','ax+by+c=0')
