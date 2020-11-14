%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Pendulum

clear all;
close all;
clc;


%Real parameter values:
m = 1;                  % mass of the pendulum bob (kg)
l = 0.3;                % length of the pendulum rod (m)
r = l/2;      %Assuming a uniform cylindrical rod.
b = 5;               % estimate of viscous friction coefficient (N-m-s)
g = 9.81;               % acceleration due to gravity (m/s^2)
Jr = m*l^2/3; %Assuming a uniform cylindrical rod.

N = 4;
Kt = 1.54;                % N.m/Amp


a1 = b/Jr;
a2 = m*g*r/Jr;
b2 = 1/Jr;

A = [-a1,  -a2;
     1,     0];
 
B = [b2/Kt;
     0]; 
    
C = [1 0;
     0 1];
 
D = [0;
     0];
 
Ts = 0.03;
%% new A,B, Ref matrix 
A_new = [A,zeros(2,1);
         0,-1/Ts,0];
     
     
B_new = [B;
         0];
     
C_new = [1 0 0;
         0 0 1];

     
D_new = [0;0];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


[A_new,B_new] = c2d(A_new,B_new,Ts)

Q = [10,0,0;
     0,1000,0;
     0,0,10000000000];
 
R = 1e-1;
K = dlqr(A_new,B_new,Q,R)

Ac = [(A_new-B_new*K)];

E  = [0;
      0;
      1];

eig(Ac)

Init_condition = [0;
                  0;
                  0];

%% Pendulum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%