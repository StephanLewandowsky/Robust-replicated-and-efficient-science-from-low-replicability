function [hpriv, hpub, hpriv2, hpub2]= plotPubvPriv(h, T, tvarname, varnams, shading) 
figure(h);
hold on
box on
allgains = table2array(unique(T(:,tvarname)));
gains = allgains(allgains>0);
privRepMean = zeros(1,length(gains));
pubRepMean = privRepMean;
privIntMean =privRepMean;
pubIntMean = privRepMean;
k=0;
for g = gains'
    k=k+1;
    again = T(table2array(T(:,tvarname))==g,:);
    %plot(again.gain,table2array(again(:,varnams{1})),'ro','MarkerFaceColor','red')
    %plot(again.gain,table2array(again(:,varnams{2})),'bo','MarkerFaceColor','blue')
    privRepMean(k)=mean(table2array(again(:,varnams{1})));
    pubRepMean(k)=mean(table2array(again(:,varnams{2})));
    if length(varnams)>2
        privIntMean(k) = mean(table2array(again(:,varnams{3})));
        pubIntMean(k) = mean(table2array(again(:,varnams{4})));
    end
end
plot(gains,privRepMean,'r-','LineWidth',shading*3);
hpriv=scatter(gains,privRepMean,shading*60,'MarkerFaceColor','red','MarkerEdgeColor','black');%,'MarkerFaceAlpha',shading,'MarkerEdgeAlpha',shading);
plot(gains,pubRepMean, 'b-','LineWidth',shading*3);
hpub=scatter(gains,pubRepMean,shading*60, 'MarkerFaceColor','blue','MarkerEdgeColor','black');%,'MarkerFaceAlpha',shading,'MarkerEdgeAlpha',shading);
if length(varnams)>2
    hpriv2=plot(gains,privIntMean,'r--','LineWidth',shading);
    hpub2=plot(gains,pubIntMean,'b--','LineWidth',shading);
end
