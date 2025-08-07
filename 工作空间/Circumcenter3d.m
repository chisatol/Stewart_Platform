%求外接圆，x,y,z向量分别为三角形三点的x轴坐标、y轴坐标、z轴坐标；%Cx,Cy,Cz是返回的圆心坐标，r是半径
function [Cx,Cy,Cz,r]=Circumcenter3d(x,y,z)
    P1x=x(1);
    P2x=x(2);
    P3x=x(3);

    P1y=y(1);
    P2y=y(2);
    P3y=y(3);

    P1z=z(1);
    P2z=z(2);
    P3z=z(3);

    D21x = P2x-P1x;
    D21y = P2y-P1y;
    D21z = P2z-P1z;
    D31x = P3x-P1x;
    D31y = P3y-P1y;
    D31z = P3z-P1z;

    F21 = 0.5*(P2x^2+P2y^2+P2z^2-P1x^2-P1y^2-P1z^2);
    F31 = 0.5*(P3x^2+P3y^2+P3z^2-P1x^2-P1y^2-P1z^2);

    M23xy = D21x*D31y-D21y*D31x;
    M23yz = D21y*D31z-D21z*D31y;
    M23xz = D21z*D31x-D21x*D31z;

    F23y = F31*D21y-F21*D31y;
    F23z = F21*D31z-F31*D21z;

    Cx = (M23yz*(P1x*M23yz+P1y*M23xz+P1z*M23xy)-M23xy*F23y-M23xz*F23z)/(M23xy^2+M23yz^2+M23xz^2);
    Cy = (F23z+M23xz*Cx)/M23yz;
    Cz = (F23y+M23xy*Cx)/M23yz;

    r=sqrt((Cx-P1x)^2 + (Cy-P1y)^2 + (Cz-P1z)^2);
end