%%% Script to load in data from 1 simulation %%%

% This is a useful script for quickly loading a single case
% Once you change the case1 and z0 variables, enter LOAD into the command
% window to load in data 

% For more help email mattethanwilliams@outlook.com


close all
set(gcf,'units','centimeters','position',[2 2 30 20])
set(0,'defaultTextInterpreter','tex');
set(0,'defaultfigurecolor',[1 1 1]);
% Adapt path to where you keep simulation data
path = "C:\Users\mattwilliams\OneDrive - Durham University\L4\L4 Research Project\reportSimulations\";
% Case variables, enter the name of the case folder 
case1 = "0.001roughness"; 

% Read in constants 
[k, Uhub, zhub, heights, startAvg, endAvg] = readConst();

% Specify the surface roughness you entered into SOWFA
z0 = 0.1;               

% Some variables for the legends 
Z0 = "$$z_{0} = $$" + num2str(z0) + "$$m$$";

% Read in the data 
[U1, UU1, T1] = readData(path + case1 + "/");

[U1, UU1, T1] = removeData(U1, UU1, T1, startAvg, endAvg);


% Write data to individual arrays ready for plotting 
[u1, v1, w1, M1, uu1, uv1, uw1, vv1, vw1, ww1, t1] = createArrays(U1, UU1, T1, heights);


