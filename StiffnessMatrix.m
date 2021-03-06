function  ke=StiffnessMatrix(ie)
global gNode gElement N A1 mf Ui
   xi=gNode(gElement(ie,2),2);
   xj=gNode(gElement(ie,3),2);
   yi=gNode(gElement(ie,2),3);
   yj=gNode(gElement(ie,3),3);
   p= ( (xj-xi)^2 + (yj-yi)^2 )^(1/2) ;                   % 计算微元体的长度哇~~
   
   %弹性变形引起的刚度矩阵
   Kea=E*I/(p^3)*...
	[12     6*p    -12         6*p;...
    6*p   4*p^2  -6*p   2*p^2; ...
    -12    -6*p     12        -6*p;...
    6*p    2*p^2  -6*p     4*p^2];
   
   % 科氏力产生的微元刚度矩阵
    Keb=(N*A1-mf*Ui^2)*...
    [6/(5*p) 1/10    -6/(5*p)   1/10;...
    1/10    2*p/15   -1/10      -1/30;...
    -6/(5*p) -1/10   6/(5*p)  -1/10;...
    1/10    -1/30     -1/10      2*p/15];
    ke=Kea+Keb;                                                %微元的总体刚度矩阵
    T = CoorTransMatrix( ie ) ;                            %坐标变换矩阵
    ke = T*ke*transpose(T) ;
return

%已检查，没问题