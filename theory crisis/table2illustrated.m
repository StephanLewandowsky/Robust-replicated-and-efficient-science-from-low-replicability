%theory crisis table 2 and so on
close all

%--- begin with some quick functions to compute components
%theory level
%p_t = prior of theory
%p_x_t = likelihood of hypothesis if theory true
%p_x_nott = likelihood of hypothesis if theory not true
priorX = @(p_t, p_x_t, p_x_nott) p_x_t*p_t + p_x_nott*(1-p_t);
postT_Htrue = @(p_t, p_x_t, p_x_nott) (p_x_t * p_t) /(p_x_t*p_t + p_x_nott*(1-p_t));
postT_Hfalse = @(p_t, p_x_t, p_x_nott) ((1-p_x_t) * p_t) /((1-p_x_t)*p_t + (1-p_x_nott)*(1-p_t));

%empirical level
% power = 1-beta or likelihood of data if hypothesis true
% alpha = likelihood of data if hypothesis false
postH_data = @(priX, power, alpha) power*priX / (power*priX + alpha*(1-priX));

%combining both levels
postT_data = @(pstT_Htrue, pstH_data, pstT_Hfalse) pstT_Htrue * pstH_data + pstT_Hfalse * (1-pstH_data);

%--- explore parameter values
p_t = [.5 .5];
p_x_t = [.1 1];
p_x_nott = [.02 .2];
alphas = .005:.001:.05;
power = .8;
postTheory=zeros(2,length(alphas));
for tR=1:2 %both types of research
    k=0;
    for alpha=alphas
        k=k+1;
        postTheory(tR, k) = postT_data(postT_Htrue(p_t(tR), p_x_t(tR), p_x_nott(tR)), ...
            postH_data(priorX(p_t(tR), p_x_t(tR), p_x_nott(tR)),power, alpha), ...
            postT_Hfalse(p_t(tR), p_x_t(tR), p_x_nott(tR))) %#ok<NOPTS>
    end
end
figure;
hold on;
plot(alphas,postTheory(1,:),'b-', ...
    alphas,postTheory(2,:),'r-')
legend(' Discovery oriented',' Theory testing','Location','SouthWest')
xlabel('\alpha')
ylabel('P(T|"x")')
axis([0 .05 .5 .9])
ax = gca;
ax.XTick = [0:.01:.05];
ax.YTick = [.5:.05:.9];
ax.YTickLabel = {'0.5','','0.6','','0.7','','0.8','','0.9'};
hold off;

