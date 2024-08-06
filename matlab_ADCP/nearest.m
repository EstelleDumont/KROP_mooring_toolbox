function [output] = nearest(a,b)

output = find(abs(a-b) == min(abs(a-b)));