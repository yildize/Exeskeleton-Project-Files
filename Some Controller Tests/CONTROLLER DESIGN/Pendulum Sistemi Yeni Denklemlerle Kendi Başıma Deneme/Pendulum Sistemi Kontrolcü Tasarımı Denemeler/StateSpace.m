clear all;
close all;
clc;

%MOTOR MODELÝ ÝÇÝN STATE SPACE ÖRNEÐÝ

%Real parameter values:
R=0.55;
Kt=85*10^-3;
L=25*10^-3;
J=0.06+0.03;
b=0.05;

%State space matrix (Bunu video 21'de çýkardýk)
a00=-R/L;
a01=-Kt/L;
a10= Kt/J;
a11= -b/J;

b00=1/L;
b10=0;

A=[a00,a11;
   a10,a11];

B=[b00; 
    b10];

%Check system controllability

ctrb_motor = ctrb(A,B); %Defterde belirtilen Cm matrisi bu matris.
rank_eval = rank(ctrb_motor)-rank(A); % Bu iþlem de defterde belirtildi iki rank birbirine eþitse rank_eval=0 olur bu da sistem controllable demektir.

%A matrisinin eigen value'su  bize sistemin karakteristik denkleminin
%köklerini gösterir
eig(A)

%place function
%Sistemin CE köklerini istediðimiz gibi manipüle edeceðiz:
p=[-4,-5]; %desired CE roots
K=place(A,B,p);%required K values for desired CE roots
    
%Full state feedbackten sonra Closed Loop A aþaðýdaki halde:
A_cl = (A-B*K);

%Bakalým bu sistemin CE'si istenilen köklere sahip mi?
eig(A_cl) % Sonuç -4 ve -5 istenilen þekilde çýktý.



%% Yeni e_dot state i tanýmlandýktan sonra Anew Bnew ve yeni kökler tanýmlandý.
A_new = [A, zeros(2,1);
         0, 1, 0];
B_new = [B;
         0];
     
p = [-10,-20,-22];
%videoda p1 akým için p2 hýz için p3 error için denmiþ bu doðru mu? Aslýnda
%p1 p2 p3 birlikte her üç state için de CE yi tanýmlamýyor mu?

K = place(A_new,B_new,p)

eig(A_new - B_new*K)















% pretty(simplify(Wt)) %Time Domain Response