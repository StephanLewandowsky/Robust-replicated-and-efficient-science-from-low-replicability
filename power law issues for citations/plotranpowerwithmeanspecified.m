%https://uk.mathworks.com/matlabcentral/answers/287691-random-numbers-drawn-from-power-law-with-certain-mean
n=1000
mu=30
D=-(1/mu)+1
b=1
%mu = b/(1-D)

pp= b*rand(n,1).^(-D);
hist(pp)
mean(pp)
