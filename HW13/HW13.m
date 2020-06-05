clc,clear,close all
%% HW13
data_number = 50;
x = linspace(-1,1.5,data_number);
y = linspace(-1.2,0.2,data_number);

[X,Y] = meshgrid(x,y);

z = (X+Y).*(X.*Y+X.*Y.^2);

figure(1)
surf(X,Y,z)
title('(x+y)(xy+xy^2)')
xlabel('x(-1<=x<=1.5)')
ylabel('y(-1.2<=y<=0.2)')
zlabel('z')
%%
syms x y

f = (x+y)*(x*y+x*y^2);

g = [diff(f,'x') diff(f,'y')] % gradient
subs(g,[x,y],[1,0])

criticalpoints = solve(g==0,[x y]);
criticalpoints = [criticalpoints.x(:,1),criticalpoints.y(:,1)];

H = hessian(f,[x,y])
H_eig = zeros(length(criticalpoints),2);

figure(2)
surfc(X,Y,z)
title('(x+y)(xy+xy^2)')
xlabel('x')
ylabel('y')
% Hessian test 
for i = 1: 4
    f_critical = subs(f,[x,y],[criticalpoints(i,1),criticalpoints(i,2)]);
    hold on
    plot3(criticalpoints(i,1),criticalpoints(i,2),f_critical,'ro')
    
    Hessian_test = subs(H,[x,y], criticalpoints(i,:));
    [Hessian_eigvec,Hessian_eigvalue] = eig(Hessian_test);
    H_eig(i,1:2) = diag(Hessian_eigvalue);
    
    if(H_eig(i,1)>0 && H_eig(i,2)>0)
        text(criticalpoints(i,1),criticalpoints(i,2),f_critical+0.2,'극소점','Color','red','FontSize',14)
    elseif(H_eig(i,1)<0 && H_eig(i,2)<0)
        text(criticalpoints(i,1),criticalpoints(i,2),f_critical+0.2,'극대점','Color','red','FontSize',14)
    elseif(sum(sign(H_eig(i,:)))==0 && sum((sign(H_eig(i,:))~=0))==2)
        text(criticalpoints(i,1),criticalpoints(i,2),f_critical+0.2,'안장점','Color','red','FontSize',14)
    else
        text(criticalpoints(i,1),criticalpoints(i,2),f_critical+0.2,'해당없음','Color','red','FontSize',14)
    end
end

G1 = subs(g(1), [x y], {X,Y});
G2 = subs(g(2), [x y], {X,Y});

figure(3)
quiver(X,Y,G1,G2,1.5)
xlabel('x')
ylabel('y')
hold on
contour(X,Y,z)
colorbar
