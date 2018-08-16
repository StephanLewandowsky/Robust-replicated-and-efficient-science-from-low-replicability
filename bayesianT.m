%% ==== Bayesian t-test adapted from http://www.lifesci.sussex.ac.uk/home/Zoltan_Dienes/inference/Bayesfactor.html
% assuming uniform prior
%16/8/18: unable to reproduce published values, hence discarded in favour
%of t1smpbf.m which matches Rouder's online calculator and BayesFactor
%package
function Bayesfactor = bayesianT(obtained, ... %sample mean
    sd, ...         %standard error of sample mean
    lowerbnd, ...   %lower bound of uniform prior
    upperbnd)       %upper bound of uniform prior

%anonymous function to evaluate normal
normaly = @(mn, variance, x) 2.718283^(- (x - mn)*(x - mn)/(2*variance))/realsqrt(2*pi*variance);

sd2 = sd*sd;
theta = lowerbnd;
incr = (upperbnd-lowerbnd)/2000;

area = 0;
for A = -1000:1000
    theta = theta + incr;
    dist_theta = 0;
    if and(theta >= lowerbnd, theta <= upperbnd)
        dist_theta = 1/(upperbnd-lowerbnd);
    end
    height = dist_theta * normaly(theta, sd2, obtained); %p(population value=theta|theory)*p(data|theta)
    area = area + height*incr; %integrating the above over theta
end

Likelihoodtheory = area;
Likelihoodnull = normaly(0, sd2, obtained);
Bayesfactor = Likelihoodtheory/Likelihoodnull;