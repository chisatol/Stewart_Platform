function frame_plot
% clc;
% clear;
% close all;
%顶面丝杆中心截面三角形的三个点，外接圆半径为192.86123477（直径385.72）
high=85.17;
R=192.86123477;
alpha=[210 330 450];%三个丝杆在XOY平面上的投影角度，正三角形的三条轴线角度
%三个顶点坐标
XA1= cosd(alpha(1))*R; 
YA1= sind(alpha(1))*R; 
ZA1= high;
XA2= cosd(alpha(2))*R; 
YA2= sind(alpha(2))*R;
ZA2= high;
XA3= cosd(alpha(3))*R;         
YA3= sind(alpha(3))*R;
ZA3= high;
%三个丝杆连接处的小三角形，外接圆半径26.69120312
rr=26.69120312;
H=385.3;%框架高度
h=166.17009358;%丝杆交汇处的高度
XC1= cosd(alpha(1))*rr; 
YC1= sind(alpha(1))*rr; 
ZC1= ZA1-h;
XC2= cosd(alpha(2))*rr; 
YC2= sind(alpha(2))*rr;
ZC2= ZA2-h;
XC3= cosd(alpha(3))*rr;         
YC3= sind(alpha(3))*rr;
ZC3= ZA3-h;
%底面的三角形，随便选择，不影响计算，所以选择跟Ai点一样
XB1= XA1; YB1= YA1; ZB1= -H;
XB2= XA2; YB2= YA2; ZB2= -H;
XB3= XA3; YB3= YA3; ZB3= -H;
%画图
hold on;
grid on;
axis equal;
view(-13,18);
% view(90,0);

circle_oh(110,-H,'r');%底面的圆形，模拟那个220mm的铝板

set(gcf,'units','centimeters','Position',[15,1.5,26,25], 'color','w');
%画原点和坐标轴
plot3(0,0,0,'co','LineWidth',8,'markersize',8);%原点
lx=line([0 260],[0 0],[0 0]);     %红色X轴
text(265,0,0,'X轴','fontsize',20,'color','r');
set(lx,'linewidth',2,'color','r');
xlabel('x-axis');
ly=line([0 0],[0 350],[0 0]);     %蓝色Y轴
text(10,370,0,'Y轴','fontsize',20,'color','b');
set(ly,'linewidth',2,'color','b');
ylabel('y-axis');
lz=line([0 0],[0 0],[0 160]);     %黑色Z轴
text(0,0,165,'Z轴','fontsize',20,'color','k');
set(lz,'linewidth',2,'color','k');
zlabel('z-axis');
% 画顶面-玫红色
h1=plot3(XA1,YA1,ZA1,'o');
set(h1,'color','m','linewidth',8,'markersize',10);
text(XA1-80,YA1+10,ZA1+0,'A1','fontsize',25,'color','k');
h2=plot3(XA2,YA2,ZA2,'o');
set(h2,'color','m','linewidth',8,'markersize',10);
text(XA2+20,YA2-10,ZA2+0,'A2','fontsize',25,'color','k');
h3=plot3(XA3,YA3,ZA3,'o');
set(h3,'color','m','linewidth',8,'markersize',10);
text(XA3-70,YA3+0,ZA3+10,'A3','fontsize',25,'color','k');
LA1=[XA1,XA2,XA3,XA1];
LA2=[YA1,YA2,YA3,YA1];
LA3=[ZA1,ZA2,ZA3,ZA1];
line(LA1,LA2,LA3,'color','r','linewidth',2,'linestyle','-');
% 画底部位置-红色
h4=plot3(XB1,YB1,ZB1,'o');
set(h4,'color','r','linewidth',8,'markersize',5);
text(XB1-80,YB1+10,ZB1+0,'B1','fontsize',25,'color','k');
h5=plot3(XB2,YB2,ZB2,'o');
set(h5,'color','r','linewidth',8,'markersize',5);
text(XB2+20,YB2-10,ZB2+0,'B2','fontsize',25,'color','k');
h6=plot3(XB3,YB3,ZB3,'o');
set(h6,'color','r','linewidth',8,'markersize',5);
text(XB3-70,YB3+0,ZB3+10,'B3','fontsize',25,'color','k');
LB1=[XB1,XB2,XB3,XB1];
LB2=[YB1,YB2,YB3,YB1];
LB3=[ZB1,ZB2,ZB3,ZB1];
line(LB1,LB2,LB3,'color','r','linewidth',2,'linestyle','-');
% 画小三角形位置-红色
h7=plot3(XC1,YC1,ZC1,'o');
set(h7,'color','r','linewidth',5,'markersize',5);
% text(XC1+10,YC1+10,ZC1+10,'C1','fontsize',10,'color','k');
h8=plot3(XC2,YC2,ZC2,'o');
set(h8,'color','r','linewidth',5,'markersize',5);
% text(XC2+10,YC2+10,ZC2+10,'C2','fontsize',10,'color','k');
h9=plot3(XC3,YC3,ZC3,'o');
set(h9,'color','r','linewidth',5,'markersize',5);
% text(XC3+10,YC3+10,ZC3+10,'C3','fontsize',10,'color','k');
LC1=[XC1,XC2,XC3,XC1];
LC2=[YC1,YC2,YC3,YC1];
LC3=[ZC1,ZC2,ZC3,ZC1];
line(LC1,LC2,LC3,'color','r','linewidth',2,'linestyle','-');
LS1=[XC1,XA1,XA3,XC3,XC2,XA2];
LS2=[YC1,YA1,YA3,YC3,YC2,YA2];
LS3=[ZC1,ZA1,ZA3,ZC3,ZC2,ZA2];
line(LS1,LS2,LS3,'color','r','linewidth',2,'linestyle','-');
% jiajiao(0,0,ZA1,XA1,YA1,ZA1,XC1,YC1,ZC1)
% jiajiao(0,0,ZA2,XA2,YA2,ZA2,XC2,YC2,ZC2)
% jiajiao(0,0,ZA3,XA3,YA3,ZA3,XC3,YC3,ZC3)
% norm([XA1-XC1,YA1-YC1,ZA1-ZC1])
% norm([XA2-XC2,YA2-YC2,ZA2-ZC2])
% norm([XA3-XC3,YA3-YC3,ZA3-ZC3])



% %画球头连接的中轴线位置
% RR=176.28;
% % circle_oh(RR,0,'b');%顶面的外接圆
% XP1= cosd(alpha(1))*RR; 
% YP1= sind(alpha(1))*RR; 
% ZP1= 0;
% XP2= cosd(alpha(2))*RR; 
% YP2= sind(alpha(2))*RR; 
% ZP2= 0;
% XP3= cosd(alpha(3))*RR; 
% YP3= sind(alpha(3))*RR; 
% ZP3= 0;
% h10=plot3(XP1,YP1,ZP1,'.');
% set(h10,'color','b','linewidth',8,'markersize',25);
% h11=plot3(XP2,YP2,ZP2,'.');
% set(h11,'color','b','linewidth',8,'markersize',25);
% h12=plot3(XP3,YP3,ZP3,'.');
% set(h12,'color','b','linewidth',8,'markersize',25);
% view(0,90);
end













