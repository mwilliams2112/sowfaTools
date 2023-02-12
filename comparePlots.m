%{
Script for postprocessing and comparing SOWFA-6 results
Author: Matt Williams (2023) 
%}

%{
This script has beeen set up to compare up to 5 cases, but it should be
clear how to add more if you need to. 

%}
close all
set(gcf,'units','centimeters','position',[2 2 30 20])
set(0,'defaultTextInterpreter','tex');
set(0,'defaultfigurecolor',[1 1 1]);

% Adapt path to where you keep simulation data
path = "C:\Users\mattwilliams\OneDrive - Durham University\L4\L4 Research Project\Simulations\";
% Case variables, enter the name of the case folder 
case1 = "0.1roughness"; 
case2 = "LowRoughness_2.2.2023";
case3 = "latitude0";
% case4 = 
% case5 = 

% Read in constants 
[k, Uhub, zhub, heights, startAvg, endAvg] = readConst();

% Specify the surface roughness you entered into SOWFA
z01 = 0.1;               
z02 = 0.001;             
z03 = 0.1;
% z04 = 
% z05 = 

% Some variables for the legends 
Z01 = "$$z_{0} = $$" + num2str(z01) + "$$m$$";
Z02 = "$$z_{0} = $$" + num2str(z02) + "$$m$$";
Z03 = "$$z_{0} = $$" + num2str(z03) + "$$m$$";
% Z04 = "$$z_{0} = $$" + num2str(z04) + "$$m$$";
% Z05 = "$$z_{0} = $$" + num2str(z05) + "$$m$$";


% Read in the data 
[U1, UU1, T1] = readData(path + case1 + "/");
[U2, UU2, T2] = readData(path + case2 + "/");
[U3, UU3, T3] = readData(path + case3 + "/");
% [U4, UU4, T4] = readData(path + case4 + "/");
% [U5, UU5, T5] = readData(path + case5 + "/");


% Remove unwanted data
[U1, UU1, T1] = removeData(U1, UU1, T1, startAvg, endAvg);
[U2, UU2, T2] = removeData(U2, UU2, T2, startAvg, endAvg);
[U3, UU3, T3] = removeData(U3, UU3, T3, startAvg, endAvg);
% [U4, UU4, T4] = removeData(U4, UU4, T4, startAvg, endAvg);
% [U5, UU5, T5] = removeData(U5, UU5, T5, startAvg, endAvg);


% Write data to individual arrays ready for plotting 
[u1, v1, w1, uu1, uv1, uw1, vv1, vw1, ww1, t1] = createArrays(U1, UU1, T1, heights);
[u2, v2, w2, uu2, uv2, uw2, vv2, vw2, ww2, t2] = createArrays(U2, UU2, T2, heights);
[u3, v3, w3, uu3, uv3, uw3, vv3, vw3, ww3, t3] = createArrays(U3, UU3, T3, heights);
% [u4, v4, w4, uu4, uv4, uw4, vv4, vw4, ww4, t4] = createArrays(U4, UU4, T4, heights);
% [u5, v5, w5, uu5, uv5, uw5, vv5, vw5, ww5, t5] = createArrays(U5, UU5, T5, heights);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit this section depending on the plots you want 


%{

4 Pack plot: Velocity Profile, Semilog plot, Reynolds stresses,
Turbulence intensity 

%}

u_uh_1 = u1/Uhub;            % Normalise velocities with respect to Uhub
u_uh_2 = u2/Uhub;     
u_uh_3 = u3/Uhub;            

norm_heights = heights/zhub; % Normalise heights with respect to zhub


% Plot wind speed
tiledlayout(1,4)
nexttile
plot(u_uh_1, norm_heights, 'ok', u_uh_2, norm_heights, 'ob', u_uh_3, norm_heights, 'or');
axis([min(min(u_uh_1,u_uh_2)) 1.2 0 3.5]);
xlabel('\it \fontname{Times New Roman} \fontsize{14} U_0 / U_h');
ylabel('\it \fontname{Times New Roman} \fontsize{14} z/z_h');
l = legend(Z01, Z02, 'Location', 'northwest');
set(l,'Interpreter', 'latex', 'fontsize',14);


% Plot semilog relationship between velocity and height 
nexttile
semilogy(u_uh_1, norm_heights, 'ok', u_uh_2, norm_heights, 'ob', u_uh_3, norm_heights, 'or')
axis([min(min(u_uh_1,u_uh_2)) 1.2 min(log(norm_heights)) 3.5])
xlabel('\it \fontname{Times New Roman} \fontsize{14} U_0 / U_h');

% Plot normalised Reynold's shear stress
nexttile
RSS1 = -uw1/(Uhub^2);
RSS2 = -uw2/(Uhub^2);
RSS3 = -uw3/(Uhub^2);

plot(RSS1, norm_heights, '-ok', RSS2, norm_heights, '-ob', RSS3, norm_heights, '-or');
axis([0 0.004 0 3.5]);
c = xlabel("$$-\overline{u'w'} / U_{h}^2$$");
set(c,'Interpreter', 'latex', 'fontsize',14);

% Plot turbulence intensity 
nexttile
I1 =  uu1.^0.5/(Uhub);
I2 =  uu2.^0.5/(Uhub);
I3 =  uu3.^0.5/(Uhub);

plot(I1, norm_heights, 'ok', I2, norm_heights, 'ob', I3, norm_heights, 'or')
axis([min(I1) 0.2 0 3.5])
d = xlabel("$$I = \sigma_u / U_{h} = \sqrt{\overline{u'u'}} / U_{h}$$");
set(d,'Interpreter', 'latex', 'fontsize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %{
% Semilog plot with fitted line in order to estimate friction velocity
% %}
% B1 = polyfit(log(heights(2:10)), u1(2:10), 1); % Fits a straight line to cells 2-6
% fitFOE1 = polyval(B1,log(heights));          % Evaluates the straightline at each height
% Slope1 = B1(1);                              % Slope of straight line
% Intercept1 = B1(2);                          % Intercept of straight line
% 
% B2 = polyfit(log(heights(2:10)), u2(2:10), 1); % Fits a straight line to cells 2-6
% fitFOE2 = polyval(B2,log(heights));          % Evaluates the straightline at each height
% Slope1 = B2(1);                              % Slope of straight line
% Intercept2 = B2(2);                          % Intercept of straight line
% 
% semilogx(heights, u1, 'o',    heights, fitFOE1,'-') % Plot the data with the fitted polynomial 
% hold on
% semilogx(heights, u2, 'o',    heights, fitFOE2,'-') % Plot the data with the fitted polynomial 
% 
% xlabel('Height,m');
% ylabel('U, m/s');
% grid on
% 
% % This is a crucial step and estimates friction velocity from the fitted
% % line. We assume that the surface roughness z0 is kept at the specified
% % level throughout the simulation. 
% ustar1 = (-Intercept1 * k)/log(z01);
% ustar2 = (-Intercept2 * k)/log(z02);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Non-dimensional mean shear phi
% 
% dUdz1 = ([diff(u1) 0]./[diff(heights) 10]);
% dUdz2 = ([diff(u2) 0]./[diff(heights) 10]);
% H = 750; % Boundary layer height 
% 
% phi1 = k*heights/ustar1 .* dUdz1;
% phi2 = k*heights/ustar2 .* dUdz2;
% 
% plot(phi1,heights/H,'-xk')
% axis([0 2.5 0 0.4])
% xline(1,'--')
% philabel = xlabel("$$\phi = \frac{kz}{u_{*}} \frac{dU}{dz}$$");
% set(philabel,'Interpreter', 'latex', 'fontsize',12);
% zzilabel = ylabel("$$\frac{z}{z_{i}}$$");
% set(zzilabel,'Interpreter', 'latex', 'fontsize',12);
% 
% hold on 
% 
% plot(phi2,heights/H,'-xb')
% axis([0 2.5 0 0.4])
% xline(1,'--')
% philabel = xlabel("$$\phi = \frac{kz}{u_{*}} \frac{dU}{dz}$$");
% set(philabel,'Interpreter', 'latex', 'fontsize',12);
% zzilabel = ylabel("$$\frac{z}{z_{i}}$$");
% set(zzilabel,'Interpreter', 'latex', 'fontsize',12);
% 
% l2 = legend(Z01, Z02, 'Location', 'northwest');
% set(l2,'Interpreter', 'latex', 'fontsize',14);






