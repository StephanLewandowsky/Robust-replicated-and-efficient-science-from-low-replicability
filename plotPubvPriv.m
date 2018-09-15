function plotPubvPriv(h, T, varnams) 
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
    plot(again.gain,table2array(again(:,varnams{1})),'ro','MarkerFaceColor','red')
    plot(again.gain,table2array(again(:,varnams{2})),'bo','MarkerFaceColor','blue')
    privRepMean(k)=mean(table2array(again(:,varnams{1})));
    pubRepMean(k)=mean(table2array(again(:,varnams{2})));
end
plot(gains,privRepMean,'r-');
plot(gains,pubRepMean,'b-');
