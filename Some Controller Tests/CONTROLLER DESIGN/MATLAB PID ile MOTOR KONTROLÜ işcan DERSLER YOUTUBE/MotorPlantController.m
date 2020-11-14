clear all;
close all;
clc;

syms K R L J  b s Kp Kd KI;

G = K/((J*L)*s^2 + (J*R + L*b)*s + (R*b+K^2)); %Plant
G_c = Kp + Kd*s; %PD Controller
W_d = 1/s; %Desired input (unit step)

T_s=(G*G_c)/(1+G*G_c); % Controller + Plant closed loop TF

pretty(simplify(T_s))

%Real parameter values:
J=0.09;
K=85*10^-3;
R=0.55;
b=0.05;
L=25*10^-3;

G_v = K/ ((J*L)*s^2 +(J*R + L*b)*s +(R*b+K^2)); %Plant

pretty(G_v)
pretty (collect(G_v,s))

G_c_v = Kp + Kd*s; % Controller
W_d_v = 1/s; % Input

T_s_v = (G_v*G_c_v)/(1+G_v*G_c_v); %Closed loop TF

pretty (collect(T_s_v,s))


% Ws=W_d_v*T_s_v;
% Wt=ilaplace(Ws);
% text2="Time Domain Response"
% pretty(simplify(Wt)) %Time Domain Response