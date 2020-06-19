clc,clear,close all

points = ginput();
x = points(:,1);
y = points(:,2);

A = std(y);
B = 4;
C = 5;
D = mean(y);

p = [A B C D]';
tolerance = 10^-8;

%%
syms X

% model => y=Asin(Bx+C)+D

count = 0;
while(1)
    r = residual(x,y,p);
    J = jaco(x,p);
    p_temp = p;
    
    figure(1)
    plot(x,y,'r.','MarkerSize',10)
    drawnow
    hold on
    h=fplot(p(1)*sin(p(2)*X+p(3))+p(4),[0 1]);
    pause(0.3)
    p = p - (J'*J)^-1*J'*r; % gauss-newton 
    count = count +1;
    if(norm(p-p_temp) < tolerance)
        break;
    else
        delete(h);
   end
end
xlabel('x')
ylabel('y')
if(sign(p(3))>0)
    title([num2str(p(1)),'sin(',num2str(p(2)),'x +',num2str(p(3)),') + ',num2str(p(4))])
else
    title([num2str(p(1)),'sin(',num2str(p(2)),'x ',num2str(p(3)),') + ',num2str(p(4))])
end

function [r] = residual(x,y,p)
% residual
r = zeros(length(x),1);
    for i = 1:length(x)
        r(i,1) = y(i) - (p(1)*sin(p(2)*x(i)+p(3)) + p(4));
    end
end

function [J] = jaco(x,p)
% jacobian matrix  
J = zeros(length(x),4);   
    for i = 1:length(x)
        J(i,1) = -sin(p(2)*x(i)+p(3));
        J(i,2) = -p(1)*x(i)*cos(p(2)*x(i)+p(3));
        J(i,3) = -p(1)*cos(p(2)*x(i)+p(3));
        J(i,4) = -1;
    end
end
