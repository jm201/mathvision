clc,clear,close all
%%
while(1)
    n = input('How many points do you want to enter? (2 or more) \n');
    if(n<2)
        disp('Please, reenter 2 or more points.')
    else
        break;
    end
end
scalr_size = 300;
x = linspace(0,scalr_size,n);
iteration = 30;
y = zeros(n,iteration+1);

%% LS : y = ax +b
points = ginput(n);
points = points*scalr_size;

A = [points(:,1) ones(n,1)];
B = points(:,2);
A_pinv = (A'*A)^-1*A';

X1 = A_pinv*B;
y(:,1) = X1(1)*x+X1(2);
%% Robust LS : y = ax + b
r = zeros(n,iteration);
W = zeros(n);

figure(1)
plot(points(:,1),points(:,2),'bo')
hold on
grid on
p1=plot(x,y(:,1),'r');
for i = 1:n
    text(points(i,1)+5,points(i,2)+10,num2str(i),'Color','k')
end
title('LS:y=ax+b')
xlabel('x')
ylabel('y')

for i = 1:iteration
    % step1 : compute residual w.r.t current model
    r(:,i) = B - A*X1;
    
    % step2 : compute weight based on the residual
    for j = 1: n
       W(j,j) = 1/((abs(r(j,i))/1.3998) +1);
    end
    
    % step3 : re_estimate parameter by weighted LS
    X1 = (A'*W*A)^-1 *(A'*W*B);
    y(:,i+1) = X1(1)*x+X1(2);
    pause(0.02);
    if(i==1)
        p2=plot(x,y(:,2),'m');
    elseif(rem(i,4)==0)
        p3=plot(x,y(:,i+1),'g');
    end
    i
end

h =[p1 p2 p3];
legend(h,'LS:y=ax+b','Iteration:1','Iterating')
title('iterative weighted least square using Cauchy weight function')
xlabel('x')
ylabel('y')
hold off;

figure(2)
for i = 1:n
   plot(1:iteration,r(i,:))
   legendInfo{i} = num2str(i);
   hold on
end
grid on
title('Residual')
xlabel('Iteration')
ylabel('r=y-AX')
legend(legendInfo);

figure(3)
plot(points(:,1),points(:,2),'bo')
hold on
grid on
p1=plot(x,y(:,1),'r');
for i = 1:n
    text(points(i,1)+5,points(i,2)+10,num2str(i),'Color','k')
end
p2=plot(x,y(:,end),'y');
title('LS vs Robust LS')
hold off
h = [p1,p2];
legend(h,'LS:y=ax+b','Robust LS: y=ax+b')
