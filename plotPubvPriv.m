function [hpriv, hpub]= plotPubvPriv(h, T, varnams, shading) 
figure(h);
hold on
box on
allgains = unique(T.gain);
gains = allgains(allgains>0);
privRepMean = zeros(1,length(gains));
pubRepMean = privRepMean;
k=0;
for g = gains'
    k=k+1;
    again = T(T.gain==g,:);
    %plot(again.gain,table2array(again(:,varnams{1})),'ro','MarkerFaceColor','red')
    %plot(again.gain,table2array(again(:,varnams{2})),'bo','MarkerFaceColor','blue')
    privRepMean(k)=mean(table2array(again(:,varnams{1})));
    pubRepMean(k)=mean(table2array(again(:,varnams{2})));
end
plot(gains,privRepMean,'r-','LineWidth',shading*3);
hpriv=scatter(gains,privRepMean,shading*60,'MarkerFaceColor','red','MarkerEdgeColor','black');%,'MarkerFaceAlpha',shading,'MarkerEdgeAlpha',shading);
plot(gains,pubRepMean, 'b-','LineWidth',shading*3);
hpub=scatter(gains,pubRepMean,shading*60, 'MarkerFaceColor','blue','MarkerEdgeColor','black');%,'MarkerFaceAlpha',shading,'MarkerEdgeAlpha',shading);
