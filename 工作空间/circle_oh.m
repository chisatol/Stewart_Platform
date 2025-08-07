function circle_oh(R,z,c) 
%画圆心在原点的圆,带高度
alpha=0:pi/36:2*pi;
x=R*cos(alpha); 
y=R*sin(alpha); 
zz=z*ones(73);
h=plot3(x,y,zz,'--');
set(h,'color',c,'LineWidth',1.5);
hold on;
end

