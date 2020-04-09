%% HW5
clc,clear,close all
%% Points P, P'
p=[-0.5 0 2.121320; 0.5 0.0 2.121320; 0.5 -0.707107 2.828427; 0.5 0.707107 2.828427; 1 1 1]';
p_prime=[1.363005 -0.427130 2.339082; 1.748084 0.437983 2.017688; 2.636461 0.184843 2.400710; 1.4981 0.8710 2.8837]';

%% 원점 평행이동 및 평면 법선벡터 h,h'  
p_1 = p + -p(:,1);                                                     % p1이 원점이 되도록 A를 평행이동
p_h = cross(p_1(:,2),p_1(:,3));                                        % p1p2p3의 법선벡터
p_primeh = cross(p_prime(:,2)-p_prime(:,1),p_prime(:,3)-p_prime(:,1)); % p1'p2'p3'의 법선벡터

%% 회전변환 R1
rotation_axis = cross(p_h,p_primeh);
angle_1 = acosd(dot(p_h,p_primeh)/(norm(p_h)*norm(p_primeh)));
R1 = R(rotation_axis,angle_1);

%% 회전변환 R2
p_11 = R1*p_1;
angle_2 = acosd(dot(p_prime(:,3)-p_prime(:,1),p_11(:,3)-p_11(:,1))/(norm(p_prime(:,3)-p_prime(:,1))*norm(p_11(:,3)-p_11(:,1))));
R2 = R(p_primeh,-angle_2); %회전축으로부터 회전하는 방향(-)

%% 결과 확인

P = R2*R1*(p-p(:,1)) + p_prime(:,1);

if(round(P(:,4),4)==p_prime(:,4)) % p4 검증
    for i = 1:5
       fprintf('p(%d) = %9.6f %9.6f %9.6f --> p''(%d) = %9.6f %9.6f %9.6f \n',i,p(:,i),i,P(:,i))
    end
else
    disp('wrong!')
end
