%%  ==========draw illustrative figure of citation distribution, pareto fit, and
function [decisionBound, gpParms]=plotParetoCites(boundPertile,psychcites2014,printflag,opdir)

figure;
h2=histfit(psychcites2014,30,'gp');
set(gca, 'XLim', [0 100])
yt = get(gca, 'YTick');
set(gca, 'YTick', yt, 'ytickLabel', (num2str(yt./numel(psychcites2014),'%.1f\n')))
hold on
gpParms = fitdist(psychcites2014,'gp')  %#ok<NOPRT>
%k=shape, sigma=scale
%k-->alpha and sigma-->X_m in https://en.wikipedia.org/wiki/Pareto_distribution#Probability_density_function
%if k=-1 then pareto sampling returns uniform distribution

%create decision function and so on centered on 90th percentile of citations
%this could also be done as: decisionBound = quantile(psychcites2014,boundPertile);
decisionBound = gpinv(boundPertile,gpParms.k,gpParms.sigma,gpParms.theta); %stays constant
citcounts = sort(psychcites2014);
%plot boundary for various levels of temp
k=0;
for temp=[1,5,10]
    k=k+1;
    pRepDecision = makeRepDecision(citcounts, decisionBound, temp);
    %add a bit to get it off the axis
    hl(k)=plot(citcounts,pRepDecision*numel(psychcites2014)+10,'-','LineWidth',2);  %#ok<AGROW>
end
vline(decisionBound,'k--');
annotation('textarrow',[.4 .32],[.35 .35],'String','Threshold')
annotation('textarrow',[.45 .38],[.25 .14],'String','Pareto fit to observed distribution')
xlabel('Total number of citations')
ylabel('Proportion of articles / P(Interest)')
l1=legend(hl,'1','5', '10', ...
    'Location','best');
title(l1,'Temperature')
hold off
if printflag
    print([opdir 'citesDecisions' num2str(boundPertile) '.pdf'],'-dpdf'); 
end