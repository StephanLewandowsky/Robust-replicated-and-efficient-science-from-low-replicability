%power distribution as per Brzezinski15
%https://math.stackexchange.com/questions/486552/plotting-power-law-fit-in-cumulative-distribution-function-plots
%http://tuvalu.santafe.edu/~aaronc/powerlaws/
alpha = 3.9;
xzero=52;

p_x=zeros(1,400-xzero+1);
for x=xzero:400
    p_x(x) = x^-alpha/zeta_hurwitz(alpha,xzero);
end

ccdf = ((xzero:400)./xzero).^(-alpha+1);

plot(1-cumsum(p_x))

cdf=cumsum(p_x)/max(cumsum(p_x));
plot(1-cdf)
ax=gca
ax.XScale = 'log';
