clear all;
close all;
clc;

syms s Kt Jr b m  g r Kp Kd KI;

G = (Kt/Jr)/(s^2 + (b/Jr)*s + (m*g*r/Jr)); %Plant
G_c = Kp + Kd*s; %PD Controller
W_d = 1/s; %Desired input (unit step)

T_s=(G*G_c)/(1+G*G_c); % Controller + Plant closed loop TF

pretty(simplify(T_s))

%Real parameter values:
m = 0.8;                  % mass of the pendulum bob (kg)
l = 0.3;                 % length of the pendulum rod (m)
r = l/3;                  % center of mass (m)
b = 0.2;                  % estimate of viscous friction coefficient (N-m-s)
g = 9.81;                 % acceleration due to gravity (m/s^2)
Kt = 1.54;                % N.m/Amp
Jr = (m*l^2/3)/4;

G_v = (Kt/Jr)/(s^2 + (b/Jr)*s + (m*g*r/Jr)); %Plant

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

