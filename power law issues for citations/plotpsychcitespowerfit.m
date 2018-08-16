%fit generalized pareto to psych 2014 citations from scopus (obtained by R)
%C:/Users/Lewan/Documents/MATLAB/Modeling/Replication market/plotting citations scopus
close all
load 'psychcites2014.mat'
h2=histfit(psychcites2014,30,'gp')
yt = get(gca, 'YTick');
set(gca, 'YTick', yt, 'ytickLabel', (num2str(yt./numel(psychcites2014),'%.1f\n')))
hold on

parms = fitdist(psychcites2014,'gp')
%k=shape, sigma=scale
%k-->alpha and sigma-->X_m in https://en.wikipedia.org/wiki/Pareto_distribution#Probability_density_function

%get 90th percentile
decisionBound = gpinv(.9,parms.k,parms.sigma,parms.theta)
%convert to replication decision
citcounts = sort(psychcites2014);
for gain=[2,5,10]
    pRepDecision = 1./(1+exp(-(citcounts-decisionBound)/gain));
    plot(citcounts,pRepDecision*numel(psychcites2014),'-')
end
hold off

%sampling from pareto: https://uk.mathworks.com/help/stats/gprnd.html

paretos = gprnd(gpParms.k,gpParms.sigma,gpParms.theta,1,1000);

