function [delta1,delta2,delta3,d1,d2,d3] = delta_ink(L,R,r,Xn,Yn,Zn)
%结构参数:L-拉杆长度;R-顶面外接圆半径;r-效应器外接圆半径;
alpha=[210 330 450];%上三角框架的三个顶点的向量角
%e点是末端的中心点
Xe=Xn;
Ye=Yn;
Ze=Zn;
s45=sind(45);
c45=cosd(45);
%E123点是末端执行器的两个球头的中点
%r为末端球头连线中点的内接圆半径
XE1= Xe+cosd(alpha(1)).*r;
YE1= Ye+sind(alpha(1)).*r;
ZE1= Ze;
XE2= Xe+cosd(alpha(2)).*r;
YE2= Ye+sind(alpha(2)).*r;
ZE2= Ze;
XE3= Xe+cosd(alpha(3)).*r;
YE3= Ye+sind(alpha(3)).*r;
ZE3= Ze;

Q1=L.^2-XE1.^2-YE1.^2-ZE1.^2;
Q2=L.^2-XE2.^2-YE2.^2-ZE2.^2;
Q3=L.^2-XE3.^2-YE3.^2-ZE3.^2;

A=1;
B1=2.*(c45*cosd(alpha(1)).*XE1+c45*sind(alpha(1)).*YE1+s45*ZE1-c45*R);
B2=2.*(c45*cosd(alpha(2)).*XE2+c45*sind(alpha(2)).*YE2+s45*ZE2-c45*R);
B3=2.*(c45*cosd(alpha(3)).*XE3+c45*sind(alpha(3)).*YE3+s45*ZE3-c45*R);
% B1=sqrt(2).*(cosd(alpha(1)).*XE1+sind(alpha(1)).*YE1+ZE1-R);
% B2=sqrt(2).*(cosd(alpha(2)).*XE2+sind(alpha(2)).*YE2+ZE2-R);
% B3=sqrt(2).*(cosd(alpha(3)).*XE3+sind(alpha(3)).*YE3+ZE3-R);
C1=R.^2-(2.*cosd(alpha(1)).*XE1.*R)-(2.*sind(alpha(1)).*YE1.*R)-Q1;
C2=R.^2-(2.*cosd(alpha(2)).*XE2.*R)-(2.*sind(alpha(2)).*YE2.*R)-Q2;
C3=R.^2-(2.*cosd(alpha(3)).*XE3.*R)-(2.*sind(alpha(3)).*YE3.*R)-Q3;

delta1=B1.^2-(4.*A.*C1);
delta2=B2.^2-(4.*A.*C2);
delta3=B3.^2-(4.*A.*C3);

d1=(-B1-sqrt(delta1))./(2.*A);
d2=(-B2-sqrt(delta2))./(2.*A);
d3=(-B3-sqrt(delta3))./(2.*A);

end






