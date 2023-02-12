function [U, UU, T] = removeData(U, UU, T, startAvg, endAvg)

times = U(:,1);
dt    = U(:,2);
idx1 = find(times > startAvg);
idx2 = find(times > endAvg);

% Remove data outside averaging interval
U(idx2(1):end,:)  = [];
U(1:idx1(1),:)    = [];

UU(idx2(1):end,:) = [];
UU(1:idx1(1),:)   = [];

T(idx2(1):end,:) = [];
T(1:idx1(1),:) = [];
