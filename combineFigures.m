%combine already saved figures with theoretical landscape
close all
% Load saved figures
ha=hgload('output/centroid0.1.fig');
hb=hgload('output/centroid.5.fig');
hc=hgload('output/centroid1.0.fig');

% Prepare subplots
figure
h(1)=subplot(1,3,1);
text(1,9,'\rho = 0.1');
axis square; box on;
axis([0 11 0 11])
h(2)=subplot(1,3,2);
axis square; box on;
axis([0 11 0 11])
h(3)=subplot(1,3,3);
axis square; box on;
axis([0 11 0 11])

% Paste figures on the subplots
copyobj(allchild(get(ha,'CurrentAxes')),h(1));
colormap(h(1),bone);
text(h(1),1,1,'\rho = 0.1');
copyobj(allchild(get(hb,'CurrentAxes')),h(2));
colormap(h(2),bone);
text(h(2),1,1,'\rho = 0.5');
copyobj(allchild(get(hc,'CurrentAxes')),h(3));
colormap(h(3),bone);
text(h(3),1,1,'\rho = 1.0');
hh = gcf;
hh.PaperOrientation= 'landscape';
suplabel('Independent variable','x',[.1 .36 .84 .84]);
suplabel('Dependent variable','y',[.13 .09 .84 .84]);
print('output/explainTheory', '-dpdf', '-fillpage');
% Add legends
% l(1)=legend(h(1),'LegendForFirstFigure')
% l(2)=legend(h(2),'LegendForSecondFigure')