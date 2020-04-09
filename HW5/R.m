function [Rotation] = R(u,angle)

%% Rotation matrix
% u : unit vector
% angle : degree 

u = u/norm(u);

R_1 = [cosd(angle)+u(1)^2*(1-cosd(angle)) u(1)*u(2)*(1-cosd(angle))-u(3)*sind(angle) u(1)*u(3)*(1-cosd(angle))+u(2)*sind(angle)];
R_2 = [u(2)*u(1)*(1-cosd(angle))+u(3)*sind(angle) cosd(angle)+u(2)^2*(1-cosd(angle)) u(2)*u(3)*(1-cosd(angle))-u(1)*sind(angle)];
R_3 = [u(1)*u(3)*(1-cosd(angle))-u(2)*sind(angle) u(2)*u(3)*(1-cosd(angle))+u(1)*sind(angle) cosd(angle)+u(3)^2*(1-cosd(angle))];
Rotation = [R_1;R_2;R_3];

end
