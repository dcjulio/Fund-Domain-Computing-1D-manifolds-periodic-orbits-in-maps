%function Sam_ProcessData()
close all
clear all

name='period20';
sol=1000;
xi=1.2;

file=sprintf('./data_orbits/a4.2_b0.3_%s.csv',name);

xs = readmatrix(file);
period = size(xs, 2);
ys = [xs(:,2:end) xs(:,1)];

for k=1:period
    vec=flip(mod((period:-1:1)+k-2,period)+1);
    x0(k) = xs(sol,k);
    y0(k) = ys(sol,k);
    z0(k) = sum(xi.^(period-1:-1:0).*ys(sol,vec))/(1-xi^period);
end

% save(sprintf('./temp/%s.mat',file(8:end-4)),"xs","ys");

