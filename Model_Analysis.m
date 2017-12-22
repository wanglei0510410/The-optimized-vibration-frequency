
% �������ݵ�����
fprintf( '����Euler-Bernoulli Beam ������⡢�ڵ����ɶ�Ϊ2\n' );
L=input( 'ϵͳ����(m):  ' );
Nel=input( '΢Ԫ��������' );
E=input( '������ϵĵ���ģ��(10^11pa):  ');
N=input( '������������ѹ����Mpa����    ');
Q=input('��������(m^3/min)��    ');
B=input( '������ͷ���⾶(m)��   ');
D=input( '�����׹ܵ��⾶(m)��   ');
d=input( '�����׹ܵ��ھ�(m):    ');
ef=input( '����ˮ�ཬ���ܶȣ�kg/m^3):    ');
ep=input( '�����׹ܵ��ܶ� (kg/m^3)��     ');
gTimeEnd=input('����ʱ�䳤�ȣ�s����      ');
gDeltaT=input('����ʱ�䲽����s����       ');




L=11;
Nel=60;
E=2.1;
N=17;
Q=1.5;
B=input( '������ͷ���⾶(m)��   ');
D=input( '�����׹ܵ��⾶(m)��   ');
d=input( '�����׹ܵ��ھ�(m):    ');
ef=1800;
ep=7800;
gTimeEnd=10;
gDeltaT=0.02;
Q=Q/60;                                                           % ��λ����
N=10^6 * N;                                                       % ��λѹǿ����
I=pi*(D^4-d^4)/64;                                                % ת�����������
A1=pi*(B^2)/4;                                                    % ���ۺ�����
A2=pi*(D^2)/4;                                                    % �׹������
A3=pi*(d^2)/4;                                                    % �׹������
Uo=Q/(A1-A2);                                                     % �����ⷵ��
Ui=Q/A3;                                                          % ����������
E=E*10^11; 
cm=(B^2+D^2)/(B^2-D^2);
timestep=gTimeEnd/gDeltaT;                                        % ���㲽��
ma=cm*ef*A2;                                                      
mf=ef*A3;
mp=ep*(A2-A3);
m=mf+mp+ma;

%΢Ԫ��ڵ���б��
Nnode=Nel+1;                                                  % �ڵ�����
node=(1:Nnode);                                               % ���ɽڵ�����
x=0:(L/Nel):L;                                                % �Խڵ����������
xx=x';                                                        % �ڵ�x��������
yy=zeros(Nnode,1);                                            % �ڵ��node
                %�ڵ���            �ڵ�x����             �ڵ�y����
gNode=[   transpose(node)              xx                    yy];   %�ڵ���б��

 %No.3΢Ԫ��ͽڵ�Ĺ�ϵ����

              %΢Ԫ����             ��˽ڵ�             �Ҷ˽ڵ�
gElement=[    (1:Nel)',               (1:Nel)',            (2:Nnode)'];  


  %No.4 ��һ�߽���������

	    %�ڵ��       ���ɶȺ�               �߽�ֵ
 gBco=[    1,              1,                 0
	             1,              2,                 0
	        Nnode,          1,                 0
		    Nnode,          2,                 0];
         
   % No.5 ΢Ԫ��ĳ���
   xi=gNode(gElement(1,2),2);
   xj=gNode(gElement(1,3),2);
   yi=gNode(gElement(1,2),3);
   yj=gNode(gElement(1,3),3);
   p=sqrt((xi-xj)^2+(yi-yj)^2);    
    
   % No.6 ��������͸նȾ���
   
   % ����΢Ԫ�����������
     me=m/420*...            
	[156*p  22*p^2  54*p     -13*p^2;...
    22*p^2 4*p^3  13*p^2      -3*p^3;...
    54*p  13*p^2   156*p     -22*p^2;...
    -13*p^2  -3*p^3  -22*p^2  4*p^3];

	%�׹ܵ�΢Ԫ�նȾ���
    Kea=E*I/(p^3)*...
	[12     6*p    -12     6*p;...
    6*p   4*p^2   -6*p    2*p^2;...
    -12    -6*p     12    -6*p;...
    6*p    2*p^2  -6*p    4*p^2];

    %�ɿ�����������΢Ԫ�նȾ���
	Keb=(N*A3+mf*Ui^2)*...
    [6/(5*p)   1/10    -6/(5*p)   1/10;...
    1/10      2*p/15   -1/10      -1/30;...
    -6/(5*p)  -1/10   6/(5*p)    -1/10;...
    1/10        -1/30     -1/10     2*p/15];
	%΢Ԫ������նȾ���
	ke=Kea+Keb;    
    
% No7. ��������͸նȾ��������װ 
       gK=zeros(Nnode*2);
       gM=zeros(Nnode*2);
     %����΢Ԫ�����װ��       
   for ie=1:Nel        % Nel ��ʾ�ж��ٸ�΢Ԫ
     for i=1:2
       for j=1:2
           for p=1:2
               for q=1:2
                   m=(i-1)*2+p;
                   n=(j-1)*2+q;
                   M=(gElement(ie,i)-1)*2+m;      
                   N=(gElement(ie,j)-1)*2+n;
                   gK(M,N)=gK(M,N)+ke(m,n);
                   gM(M,N)=gM(M,N)+me(m,n);
               end
           end
        end
     end
   end      
   
   % No.8 ���õ�һ��߽���������ʩ�ӱ߽����� 
    [bc1_number, ~]=size(gBco);
    w2max = max( diag(gK)./diag(gM) ); 
    
   for ibc=1:1:bc1_number
        n = gBco(ibc, 1 );                                       %������ҵ��ǽڵ�
        d = gBco(ibc, 2 );                                       %����Լ��ʩ�ӵ����ɶ�
        m = (n-1)*2 + d;                                         %����Լ�����ɶ����ܸվ�����ռ�õ����ɶ�
        gK(:,m) = zeros( Nnode*2, 1 );                           %�л���0
        gK(m,:) = zeros( 1, Nnode*2 );                           %�л���0
        gK(m,m) = 1;  
   end
    
   for ibc=1:1:bc1_number
        n = gBco(ibc, 1 );
        d = gBco(ibc, 2 );
        m = (n-1)*2 + d;      
        gM(:,m) = zeros( Nnode*2, 1 );
        gM(m,:) = zeros( 1, Nnode*2 ) ;
        gM(m,m) = gK(m,m)/w2max/1e10 ;         
   end
    
    for i=1:Nnode*2
           for j=i:Nnode*2
               gK(j,i) = gK(i,j);
               gM(j,i) = gM(i,j);                           % ���жԳƻ�����
           end 
    end
                     
      % ����ճ������������
      % ��������ֵ��������
    [gEigVector, gEigValue] = eigs(gK, gM, 6, 'SM' );       %��ȡ��������ֵ 
    fre_number=length(diag(gEigValue));  
    for ibc=1:1:bc1_number
	    n = gBco(ibc, 1 );
        d = gBco(ibc, 2 );
        m = (n-1)*2 + d;                                   
        gEigVector(m,:) = gBco(ibc,3);                       %�����ͽ��б߽绯
    end 
                        
    w1=sqrt(gEigValue(1,1))/2/pi;                                    
    w2=sqrt(gEigValue(2,2))/2/pi;                            % ��ȡǰ���׹�����Ƶ��
    
    %No.9 ˮ�ཬ�����΢Ԫ��ճ��������� 
    dRatio=0.008;                                            % �ṹ����ȣ��ֲ�ˮ��ѡȡ0.008
    % Rayleigh Damping                                       % ճ�����ᣬ���ñ������᷽ʽ
    alpha=2*(w1*w2)*dRatio/(w1+w2);                          % w1��w2�ǹܲĵĹ�����Ƶ��
    beta= 2*dRatio/(w1+w2); 
    Ca=alpha*gM+beta*gK;                                     % rayleigh ����ȷ���Ľṹ�������
    
    %�����������
	cb=-(2*mf*Ui + ma*Uo)*...
    [0          -p/10       -1/2            p/10;...
    p/10       0           -p/10          p^2/60;...
    1/2        p/10           0            -p/10;...
    -p/10     -p^2/60       p/10              0];                                
   % ��������������װ���Ӷ��ܹ��ĳ�������������
 
 Cb=zeros(Nnode*2);
    for ie=1:Nel                                                    % Nel ��ʾ�ж��ٸ�΢Ԫ
     for i=1:2
       for j=1:2
           for p=1:2
               for q=1:2
                   m=(i-1)*2+p;
                   n=(j-1)*2+q;
                   M=(gElement(ie,i)-1)*2+m;      
                   N=(gElement(ie,j)-1)*2+n;
                  Cb(M,N)=Cb(M,N)+cb(m,n);
               end
           end
        end
     end
    end
   
   gC=Cb+Ca;
	
	% ��ӡ����ֵ
    fprintf( '\n\n\n\n ����   ����ֵ(Ƶ��)�б�  \n' ) ;
    fprintf( '----------------------------------------------------------\n') ;
    fprintf( '   ����       ����ֵ       ������Ƶ��(Hz)     ԲƵ��(rad/s)\n') ;
    fprintf( '----------------------------------------------------------\n') ;
    for i=fre_number:-1:1
        fprintf( '%6d   %15.7e   %15.7e   %15.7e\n', fre_number-i+1, ...
            gEigValue(i,i), sqrt(gEigValue(i,i))/2/pi, sqrt(gEigValue(i,i)) ) ;
    end
    fprintf( '----------------------------------------------------------\n') ;

% ������׷������񶯷��棡
% gDisp -------- λ��ʱ����Ӧ
% gVelo -------- �ٶ�ʱ����Ӧ
% gAcce -------- ���ٶ�ʱ����Ӧ
% ����λ�ƣ��ٶȺͼ��ٶ�
    gDisp = zeros( Nnode*2, timestep ) ;
    gVelo = zeros( Nnode*2, timestep ) ;
    gAcce = zeros( Nnode*2, timestep ) ;  
    % ��ʼ����
    gDisp(:,1) = zeros(Nnode*2, 1 ) ;                   %��ʼλ��
    gVelo(:,1) = ones(Nnode*2, 1) ;                     
    f=zeros(Nnode*2, timestep); 
 
    % ������Ҫ���¶���û��ʩ�ӱ߽��������������󡢸նȾ���
    
    hK=zeros(Nnode*2);
    hM=zeros(Nnode*2);
    
   for ie=1:Nel                                                     % Nel ��ʾ�ж��ٸ�΢Ԫ
     for i=1:2
       for j=1:2
           for p=1:2
               for q=1:2
                   m=(i-1)*2+p;
                   n=(j-1)*2+q;
                   M=(gElement(ie,i)-1)*2+m;      
                   N=(gElement(ie,j)-1)*2+n;
                   hK(M,N)=hK(M,N)+ke(m,n);
                   hM(M,N)=hM(M,N)+me(m,n);
               end
           end
        end
     end
   end
   
   %�����ʼ���ٶ�
    gAcce(:,1) =hM\(f(:,1)-hK*gDisp(:,1)-gC*gVelo(:,1)); 
   
    %������Newmark���������񶯷���
    gama = 0.5 ;
    beta = 0.25 ;                                                   % ����ƽ�����ٶȷ��� Newmark- beta ����
    alpha0 = 1/beta/gDeltaT^2;
    alpha1 = gama/beta/gDeltaT;
    alpha2 = 1/beta/gDeltaT;
    alpha3 = 1/2/beta - 1;
    alpha4 = gama/beta - 1;
    alpha5 = gDeltaT/2*(gama/beta-2);           
    alpha6 = gDeltaT*(1-gama);
    alpha7 = gama*gDeltaT;
    K1 = hK + alpha0*hM + alpha1*gC;            %������Ч�նȾ���
     
% �Ѽ��������ɵ�����ڵ���������

   [bc1_number, ~]=size(gBco);
   K1im = zeros(Nnode*2, bc1_number);
    for ibc=1:1:bc1_number
        n=gBco(ibc,1);
        d=gBco(ibc,2);
        m=(n-1)*2+d;
        K1im(:,ibc)=K1(:,m);                            % ���ǽ�ԭʼ�߽��������浽Klim��ȥ����������������ʩ�ӱ߽�����
        K1(:,m) = zeros( Nnode*2, 1 );                  % ����Ч�նȾ�����и�ֵ
        K1(m,:) = zeros( 1, Nnode*2);                   % ���С����з��Ա߽���������ʩ��
        K1(m,m) = 1.0;                                  % ʩ�ӱ߽�����
    end
  [KL,KU]=lu(K1);
   
   %��ÿһ��ʱ�䲽���㡢�ǰ���ʱ�䲽�����м���
  
    for i=2:1:timestep
        
        if mod(i,100) == 0
            fprintf( '��ǰʱ�䲽��%d\n', i );          % ��ʾ����������ģΪ������
        end      
    
        f1 =f(:,i)+hM*(alpha0*gDisp(:,i-1)+alpha2*gVelo(:,i-1)+alpha3*gAcce(:,i-1)) ...
                  + gC*(alpha1*gDisp(:,i-1)+alpha4*gVelo(:,i-1)+alpha5*gAcce(:,i-1)) ;
            
        % ��f1���б߽���������, ʩ�����ı߽�����
        [bc1_number,~] = size( gBco ) ;
        for ibc=1:1:bc1_number
            n = gBco(ibc, 1 ) ;
            d = gBco(ibc, 2 ) ;
            m = (n-1)*2 + d ;
        %�������  ��ô��Ҫ��������ʩ�ӱ߽�����
            f1 = f1 - gBco(ibc,3) * K1im(:,ibc) ;      % �����ʩ�ӱ߽�����    ���û��л��з�ʩ�ӱ߽�����    
            f1(m)=gBco(ibc,3);
        end
        y=KL\f1;
        gDisp(:,i) = KU\y ;
        gAcce(:,i) = alpha0*(gDisp(:,i)-gDisp(:,i-1)) - alpha2*gVelo(:,i-1) - alpha3*gAcce(:,i-1) ;
        gVelo(:,i) = gVelo(:,i-1) + alpha6*gAcce(:,i-1) + alpha7*gAcce(:,i) ;
     end

    % ����ʱ������
    t = 0:gDeltaT:(gTimeEnd-gDeltaT);
    d = gDisp((floor(Nnode/4)*2)+1,:);
    subplot(2,1,1);
    plot( t, d );
    title( 'L/2���Ӷ�ʱ������');
    xlabel( 'ʱ��(s)');
    ylabel( '�Ӷ�(m)' );
    grid on
   
    % ��ʱ�����߽���FFT�任����ȡƵ������
    fd = fft( d ) ;
    df = 1/gTimeEnd ;
    f = (0:length(d)-1)*df ;
    subplot(2,1,2);
    plot(f,abs(fd)) ;
    set(gca,'xlim',[0,25]) ;
    title( 'L/2���Ӷȵ�Ƶ��ͼ' ) ;
    xlabel( 'Ƶ��(Hz)') ;
    ylabel( '��ֵ' ) ;
   
    % ��עƵ�ʷ�ֵ
    fifi1 = diff(abs(fd));
    n = length(fifi1) ;
    d1 = fifi1(1:n-1);
    d2 = fifi1(2:n) ;
    indmax = find( d1.*d2<0 & d1>0 )+1;
    for i=1:length(indmax)
        if f(indmax(i)) > 10
            break;
        end
        text( f(indmax(i)+2), abs(fd(indmax(i)))*0.9, sprintf('f=%.3f',f(indmax(i))));
    end