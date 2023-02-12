function [U, UU, T] = readData(CASE)

U = readtable(CASE + 'U.txt');  % Horizontally averaged velocity file from SOWFA
U = table2array(U);
UU = readtable(CASE + 'UU.txt');  % Horizontally averaged velocity file from SOWFA
UU = table2array(UU);
T = readtable(CASE + 'T.txt');  % Horizontally averaged velocity file from SOWFA
T = table2array(T);



