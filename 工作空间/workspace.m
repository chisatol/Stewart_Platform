clc;
clear;
close all;
LL=280;%拉杆长度
R=176.284493;%顶面外接圆半径
r=23;%效应器外接圆半径


XP= -329:6:329;   
YP= -329:6:329; 
ZP=  -234.3157:-6:-385.3;
% ZP=-300*ones(1,110);
% ZP=-600:10:300;

L=1;
M=1;
N=1;
for i=1:length(XP)
    for j=1:length(YP)
      for k=1:length(ZP)  
[delta1,delta2,delta3,d1,d2,d3] = delta_ink(LL,R,r,XP(i),YP(j),ZP(k)); 
        if((delta1>=0)&&(delta2>=0)&&(delta3>=0))  
%                if((sqrt(XP(i)^2+YP(j)^2)<=170))
                x(L)=XP(i);
                y(M)=YP(j);  
                z(N)=ZP(k);
                L=L+1;
                M=M+1;  
                N=N+1;
%                 end
               
                
        end  
      end
    end
end
figure('color','w');



plot3(x,y,z,'.g','markersize',10);     
hold on;   
grid on;
% axis equal;
view(-73,16);
% circle_oh(320,-0,'b');
circle_oh(170,-385.3,'b');
frame_plot;
xxx=[x',y',z'];
% ptCloud=pointCloud(xxx);
% pcwrite(ptCloud,'xxx.ply');

figure;

x=xxx(:,1);
y=xxx(:,2);
z=xxx(:,3);
f=boundary(x,y,z,0); % MATLAB R2014b 引入的函数
patch('faces',f,'vertices',[x,y,z],'edgecolor','none','facecolor','r');
view(-30,22)
axis equal tight off vis3d
lighting gouraud
camlight
light('position',[0 0 -1])
frame_plot;
circle_oh(170,-385.3,'b');









