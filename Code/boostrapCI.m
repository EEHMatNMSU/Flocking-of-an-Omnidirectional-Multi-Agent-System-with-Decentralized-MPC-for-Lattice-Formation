%---------------------------------------------------------------------------------------------------
% Code to reproduce material in the article
% "Flocking of an Omnidirectional Multi-Agent System with 
% Decentralized MPC for Lattice Formation: Sigma-Norm Design and Comparative Performance Assessment"
% by EUSEBIO E. HERNÁNDEZ, HENGAMEH MIRHAJIANMOGHADAM, EDUARDO S. ESPINOZA, LUIS RODOLFO GARCIA CARRILLO
% Instituto Politécnico Nacional, Ciudad de Mexico 07320 Mexico 
% Author: Eusebio Hernandez (e-mail: euhernandezm@ipn.mx)
%---------------------------------------------------------------------------------------------------

nReps = 10000;
n1 = 20;            %sample size 1
n2 = 20;            %sample size 2
alpha = .01;        %alpha value
x1 = promJqH;
x2 = promJqS;
myStatistic = @(x1,x2) mean(x1)-mean(x2);
sampStat = myStatistic(x1,x2);
bootstrapStat = zeros(nReps,1);
for i=1:nReps
    sampX1 = x1(ceil(rand(n1,1)*n1));
    sampX2 = x2(ceil(rand(n2,1)*n2));
    bootstrapStat(i) = myStatistic(sampX1,sampX2);
end
CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);

%Hypothesis test: Does the confidence interval cover zero?
H = CI(1)>0 | CI(2)<0;
%clf
xx = min(bootstrapStat):.01:max(bootstrapStat);
figure(3)
hist(bootstrapStat,xx);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'y-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means');
decision = {'Fail to reject H0','Reject H0'};
title(decision(H+1));
legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');