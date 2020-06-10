%% HW14
clc,clear,close all

data_number = 100;
x = linspace(-1,5,data_number);
y = linspace(-3,4,data_number);
[X,Y] = meshgrid(x,y);

syms x y
f = sin(x+y-1) + (x-y-1)^2 -1.5*x + 2.5*y +1;
z = sin(X+Y -1) + (X-Y-1).^2 - 1.5*X + 2.5*Y +1;

x_0 = [-0.5 3]';     % saddle point(0)
%x_0 = [4.75 -0.01]';  % saddle point(x)
buffer = 50;
%% Newton's method and SFN
lambda = 0.1;
f_gradient = [diff(f,'x');diff(f,'y')];

x_gradient = zeros(2,buffer);
z_gradient = zeros(1,buffer);

x_newton = zeros(2,buffer);
z_newton = zeros(1,buffer);

x_SFN = zeros(2,buffer);
z_SFN = zeros(1,buffer);

x_gradient(:,1) = x_0;
z_gradient(:,1) = double(subs(f,[x,y],x_0'));

x_newton(:,1) = x_0;
z_newton(:,1) = z_gradient(:,1);

x_SFN(:,1) = x_0;
z_SFN(:,1) = z_gradient(:,1);

f_hessian = hessian(f);
f_inv_H = inv(f_hessian);

count = zeros(1,3);
tolerance = 10^-5;

% gradient
for j = 1:3
    switch j
        case 1
            i = 1;
            while(true)
                x_gradient(:,i+1) = x_gradient(:,i)-lambda*double(subs(f_gradient,[x, y],x_gradient(:,i)'));
                z_gradient(:,i+1) = double(subs(f,[x,y],x_gradient(:,i+1)'));
                if(abs(z_gradient(1,i+1)-z_gradient(1,i)) < tolerance)
                    count(1,j) = i;
                    break;
                end
                i=i+1;
            end
        case 2
            i = 1;
            while(true)
                x_newton(:,i+1) = x_newton(:,i) - double(subs(f_inv_H,[x, y],x_newton(:,i)')) * double(subs(f_gradient,[x, y],x_newton(:,i)'));
                z_newton(:,i+1) = double(subs(f,[x,y],x_newton(:,i+1)'));
                if(abs(z_newton(1,i+1)-z_newton(1,i)) < tolerance)
                    count(1,j) = i;
                    break;
                end
                i=i+1;
            end
        case 3
            i = 1;
            while(true)
                f_abs_H = double(subs(f_inv_H,[x, y],x_SFN(:,i)'));
                [eig_vector,eig_value] = eig(f_abs_H);
                f_abs_H = eig_vector * abs(eig_value) * eig_vector';          
                x_SFN(:,i+1) = x_SFN(:,i) - f_abs_H * double(subs(f_gradient,[x, y],x_SFN(:,i)'));
                z_SFN(:,i+1) = double(subs(f,[x,y],x_SFN(:,i+1)'));
                if(abs(z_SFN(1,i+1)-z_SFN(1,i)) < tolerance)
                    count(1,j) = i;
                    break;
                end
                i=i+1;
            end
    end
end

%% plot graph
figure(1)
subplot(1,2,1)
surf(X,Y,z)
xlabel('x')
ylabel('y')
zlabel('z')

subplot(1,2,2)
contour(X,Y,z)
colorbar
%% plot gradient descent
figure(2)
suptitle('gradient descent')
subplot(1,2,1)
surf(X,Y,z)
hold on
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                                  % start
h2 = plot3(x_gradient(1,2:count(1)-1),x_gradient(2,2:count(1)-1),z_gradient(1,2:count(1)-1),'r*'); % ing 
h3 = plot3(x_gradient(1,count(1)),x_gradient(2,count(1)),z_gradient(1,count(1)),'g*');             % end 
h = [h1 h2 h3];
legend(h,'start','ing','end')

subplot(1,2,2)
contour(X,Y,z)
hold on 
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                                      % start
h2 = plot3(x_gradient(1,2:count(1)-1),x_gradient(2,2:count(1)-1),z_gradient(1,2:count(1)-1),'r*');     % ing 
h3 = plot3(x_gradient(1,count(1)),x_gradient(2,count(1)),z_gradient(1,count(1)),'g*');                 % end 
h = [h1 h2 h3];
legend(h,'start','ing','end')
colorbar

%% plot newton method and SFN
figure(3)
suptitle('Newton method vs SFN')
subplot(1,2,1)
surf(X,Y,z)
hold on
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                           % start
h2 = plot3(x_newton(1,2:count(2)),x_newton(2,2:count(2)),z_newton(1,2:count(2)),'r*');      % newton 
h3 = plot3(x_SFN(1,2:count(3)),x_SFN(2,2:count(3)),z_SFN(1,2:count(3)),'c*');               % SFN 
h=[h1 h2 h3];
legend(h,'start','newton','SFN')

subplot(1,2,2)
contour(X,Y,z)
hold on
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                                                                      % start
h2 = plot3(x_newton(1,2:count(2)-1),x_newton(2,2:count(2)-1),z_newton(1,2:count(2)-1),'rd','Markersize',10);                           % newton ing
h3 = plot3(x_SFN(1,2:count(3)-1),x_SFN(2,2:count(3)-1),z_SFN(1,2:count(3)-1),'d','color',[0.8500 0.3250 0.0980],'Markersize',12);      % SFN ing
h4 = plot3(x_newton(1,count(2)),x_newton(2,count(2)),z_newton(1,count(2)),'k*');                                                       % newton end
h5 = plot3(x_SFN(1,count(3)),x_SFN(2,count(3)),z_SFN(1,count(3)),'*','color',[0.4940 0.1840 0.5560]);                                  % SFN end
h=[h1 h2 h3 h4 h5];
legend(h,'start','newton ing','SFN ing','newton end','SFN end')
colorbar

%%
figure(4)
subplot(1,2,1)
contour(X,Y,z)
hold on 
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                                                   % start
h2 = plot3(x_gradient(1,2:count(1)-1),x_gradient(2,2:count(1)-1),z_gradient(1,2:count(1)-1),'r.','Markersize',9);   % ing 
h3 = plot3(x_gradient(1,count(1)),x_gradient(2,count(1)),z_gradient(1,count(1)),'g*');                              % end 
h = [h1 h2 h3];
legend(h,'start','ing','gradient end')
title('gradient descent')

subplot(1,2,2)
contour(X,Y,z)
hold on
h1 = plot3(x_gradient(1,1),x_gradient(2,1),z_gradient(1,1),'m*');                                               % start
h2 = plot3(x_newton(1,2:count(2)-1),x_newton(2,2:count(2)-1),z_newton(1,2:count(2)-1),'r.','Markersize',9);     % newton ing
h3 = plot3(x_newton(1,count(2)),x_newton(2,count(2)),z_newton(1,count(2)),'g*');                                % newton end
h=[h1 h2 h3];
legend(h,'start','ing','newton end')
title('newton method')
colorbar
