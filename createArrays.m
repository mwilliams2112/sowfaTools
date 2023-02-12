function [u, v, w, uu, uv, uw, vv, vw, ww, t] = createArrays(U, UU, T, heights)


u = zeros(1,length(heights));
v = zeros(1,length(heights));
w = zeros(1,length(heights));
uu = zeros(1,length(heights));
uv = zeros(1,length(heights));
uw = zeros(1,length(heights));
vv = zeros(1,length(heights));
vw = zeros(1,length(heights));
ww = zeros(1,length(heights));

for i = 1:length(heights)
    u(i)  = mean(U(:,i*3+0));
    v(i)  = mean(U(:,i*3+1));
    w(i)  = mean(U(:,i*3+2));
    uu(i) = mean(UU(:,i*6-3)); % This is <u'u'>
    uv(i) = mean(UU(:,i*6-2)); % This is <u'v'>
    uw(i) = mean(UU(:,i*6-1)); % This is <u'w'>    
    vv(i) = mean(UU(:,i*6+0)); % This is <v'v'>
    vw(i) = mean(UU(:,i*6+1)); % This is <v'w'>
    ww(i) = mean(UU(:,i*6+2)); % This is <w'w'>
end

% Time average the velocities
for i = 1:length(heights)
    u(i) = mean(U(:,i*3+0));
    v(i) = mean(U(:,i*3+1));
    w(i) = mean(U(:,i*3+2));
    uu(i) = mean(UU(:,i*6-3)); % This is <u'u'>
    uv(i) = mean(UU(:,i*6-2)); % This is <u'v'>
    uw(i) = mean(UU(:,i*6-1)); % This is <u'w'>    
    vv(i) = mean(UU(:,i*6+0)); % This is <v'v'>
    vw(i) = mean(UU(:,i*6+1)); % This is <v'w'>
    ww(i) = mean(UU(:,i*6+2)); % This is <w'w'>
end

% Time average the potential temperature
t = mean(T,1);



