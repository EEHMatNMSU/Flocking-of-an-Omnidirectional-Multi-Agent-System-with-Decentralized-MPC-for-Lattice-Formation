%---------------------------------------------------------------------------------------------------
% Code to reproduce material in the article
% "Flocking of an Omnidirectional Multi-Agent System with 
% Decentralized MPC for Lattice Formation: Sigma-Norm Design and Comparative Performance Assessment"
% by EUSEBIO E. HERNÁNDEZ, HENGAMEH MIRHAJIANMOGHADAM, EDUARDO S. ESPINOZA, LUIS RODOLFO GARCIA CARRILLO
% Instituto Politécnico Nacional, Ciudad de Mexico 07320 Mexico 
% Author: Eusebio Hernandez (e-mail: euhernandezm@ipn.mx)
%---------------------------------------------------------------------------------------------------

clear all;
close all;
nexec=25;
promJqH = zeros(1,nexec);
promJpH = zeros(1,nexec);
promJqS = zeros(1,nexec);
promJpS = zeros(1,nexec);
promJqO = zeros(1,nexec);
promJpO = zeros(1,nexec);
promJqHu = zeros(1,nexec);
promJpHu = zeros(1,nexec);
%AlgIndex=2;
for i = 1:nexec
    [promJqH(i),promJpH(i)] = funct_mean_agents_indexes(1, 8.4, 8.4);
end 
for i = 1:nexec
    %[promJqHu(i),promJpHu(i)] = funct_mean_agents_indexes(2, 4, 4);%Mios
    [promJqHu(i),promJpHu(i)] = funct_mean_agents_indexes(2, 8.4, 6);
end
for i = 1:nexec
    %[promJqO(i),promJpO(i)] = funct_mean_agents_indexes(3, 4, 4);%Mios
    [promJqO(i),promJpO(i)] = funct_mean_agents_indexes(3, 8.4, 5.02);
end 
for i = 1:nexec
    [promJqS(i),promJpS(i)] = funct_mean_agents_indexes(4, 10.5, 6);
end 

% figure(1)
% h1=boxplot([promJqH, promJqS]);
% xlabel('Executions')
% ylabel('Irregularity position')
% title('Jq index measures')
% figure(2)
% h2=boxplot([promJpH, promJpS]);
% xlabel('Executions')
% ylabel('Irregularity velocity')
% title('Jp index measures')

% theta=-pi:.1:pi
% y=sin(theta)
% plot(theta,y,'LineWidth',2)
%ax = gca; 
%ax.FontSize = 24; % De esta forma se cambian todas las fuentes
% xlabel('time', 'FontSize',16) % y de esta forma se cambia solo para la que se define que se requeire cambiar
% ylabel('Amplitude')
% legend('sin(\theta)')

%%%%%%%%    Boostrap Hypothesis testing vs MPC Hastedt
x1 = promJqH;
x2 = promJqS;
nReps = 10000;
myStatistic = @(x1,x2) mean(x1)-mean(x2);
n1 = nexec;            %sample size 1
n2 = nexec;            %sample size 2
alpha = .05;        %alpha value
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
xx = min(bootstrapStat):.01:max(bootstrapStat);
figure(1)
hist(bootstrapStat,xx);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24; 
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means', 'FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue1, dispJA, dispJB] = myboostrap(x1,x2,nReps);
mypvalue1

%%%%Distribution of MPC Hastedt
figure(2)
histogram(dispJA)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC Proposal
figure(3)
histogram(dispJB)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%%%%%    Boostrap Hypothesis testing vs MPC Huang
x1 = promJqHu;
x2 = promJqS;
%nReps = 10000;
myStatistic = @(x1,x2) mean(x1)-mean(x2);
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .01;        %alpha value
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
xx = min(bootstrapStat):.01:max(bootstrapStat);
figure(4)
hist(bootstrapStat,xx);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24;
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means', 'FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue2, dispJA, dispJB] = myboostrap(x1,x2,nReps);
mypvalue2

%%%%Distribution of MPC Huang
figure(5)
histogram(dispJA)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC Proposal
figure(6)
histogram(dispJB)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%%%%%    Boostrap Hypothesis testing vs Olfati
x1 = promJqO;
x2 = promJqS;
%nReps = 10000;
myStatistic = @(x1,x2) mean(x1)-mean(x2);
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .01;        %alpha value
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
xx = min(bootstrapStat):.01:max(bootstrapStat);
figure(7)
hist(bootstrapStat,xx);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24;
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means','FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue3, dispJA, dispJB] = myboostrap(x1,x2,nReps);
mypvalue3


%%%%Distribution of Olfati-Saber
figure(8)
histogram(dispJA)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC proposal
figure(9)
histogram(dispJB)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%%%Boxplots irregularity position indexes
figure(10)
gx = [promJqH, promJqHu, promJqO, promJqS];
g1 = repmat({'MPC Hastedt'},nexec,1);
g2 = repmat({'MPC Huang'},nexec,1);
g3 = repmat({'Olfati-Saber'},nexec,1);
g4 = repmat({'MPC Proposal'},nexec,1);
g = [g1; g2; g3; g4];
%g = [g1; g2; g3];
boxplot(gx, g)
ax = gca; 
ax.FontSize = 24;
ylabel('Mean of irregularity position index', 'FontSize',24)
%title('Jq index measures')


%%%%%%Boxplots irregularity velocity indexes 
figure(11)
hx = [promJpH, promJpHu, promJpO, promJpS];
h1 = repmat({'MPC Hastedt'},nexec,1);
h2 = repmat({'MPC Huang'},nexec,1);
h3 = repmat({'Olfati-Saber'},nexec,1);
h4 = repmat({'MPC Proposal'},nexec,1);
%h = [h1; h2; h3];
h = [h1; h2; h3; h4];
boxplot(hx, h)
ax = gca; 
ax.FontSize = 24;
ylabel('Mean of irregularity velocity index', 'FontSize',24)
%title('Jp index measures')

% x1 = promJpH;
% x2 = promJpS;
% nReps = 10000;
% myStatistic = @(x1,x2) mean(x1)-mean(x2);
% [mypvalue] = myboostrap(x1,x2,nReps)
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .01;        %alpha value
% sampStat = myStatistic(x1,x2);
% bootstrapStat = zeros(nReps,1);
% for i=1:nReps
%     sampX1 = x1(ceil(rand(n1,1)*n1));
%     sampX2 = x2(ceil(rand(n2,1)*n2));
%     bootstrapStat(i) = myStatistic(sampX1,sampX2);
% end
% CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);
% %Hypothesis test: Does the confidence interval cover zero?
% H = CI(1)>0 | CI(2)<0;
% xx = min(bootstrapStat):.01:max(bootstrapStat);
% figure(4)
% hist(bootstrapStat,xx);
% hold on
% ylim = get(gca,'YLim');
% h1=plot(sampStat*[1,1],ylim,'y-','LineWidth',2);
% h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
% plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
% %h3=plot([0,0],ylim,'b-','LineWidth',2);
% xlabel('Difference between means');
% decision = {'Fail to reject H0','Reject H0'};
% title(decision(H+1));
% legend([h1,h2],{'Sample mean',sprintf('%2.0f%% CI',100*alpha)},'Location','NorthWest');



%%%%%%%%%%%%%%              Velocity
%%%%%%%%    Boostrap Hypothesis testing vs MPC Hastedt
y1 = promJpH;
y2 = promJpS;
%nReps = 10000;
myStatistic = @(y1,y2) mean(y1)-mean(y2);
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .05;        %alpha value
sampStat = myStatistic(y1,y2);
bootstrapStat = zeros(nReps,1);
for i=1:nReps
    sampY1 = y1(ceil(rand(n1,1)*n1));
    sampY2 = y2(ceil(rand(n2,1)*n2));
    bootstrapStat(i) = myStatistic(sampY1,sampY2);
end
CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);
%Hypothesis test: Does the confidence interval cover zero?
H = CI(1)>0 | CI(2)<0;
yy = min(bootstrapStat):.01:max(bootstrapStat);
figure(12)
hist(bootstrapStat,yy);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24; 
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means', 'FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue1v, dispJAv, dispJBv] = myboostrap(y1,y2,nReps);
mypvalue1v

%%%%Distribution of MPC Hastedt
figure(13)
histogram(dispJAv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC Proposal
figure(14)
histogram(dispJBv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%%%%%    Boostrap Hypothesis testing vs MPC Huang
y1 = promJpHu;
y2 = promJpS;
%nReps = 10000;
myStatistic = @(y1,y2) mean(y1)-mean(y2);
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .05;        %alpha value
sampStat = myStatistic(y1,y2);
bootstrapStat = zeros(nReps,1);
for i=1:nReps
    sampY1 = y1(ceil(rand(n1,1)*n1));
    sampY2 = y2(ceil(rand(n2,1)*n2));
    bootstrapStat(i) = myStatistic(sampY1,sampY2);
end
CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);
%Hypothesis test: Does the confidence interval cover zero?
H = CI(1)>0 | CI(2)<0;
yy = min(bootstrapStat):.01:max(bootstrapStat);
figure(15)
hist(bootstrapStat,yy);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24;
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means', 'FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue2v, dispJAv, dispJBv] = myboostrap(y1,y2,nReps);
mypvalue2v

%%%%Distribution of MPC Huang
figure(16)
histogram(dispJAv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC Proposal
figure(17)
histogram(dispJBv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%%%%%    Boostrap Hypothesis testing vs Olfati
y1 = promJpO;
y2 = promJpS;
%nReps = 10000;
myStatistic = @(y1,y2) mean(y1)-mean(y2);
% n1 = nexec;            %sample size 1
% n2 = nexec;            %sample size 2
% alpha = .05;        %alpha value
sampStat = myStatistic(y1,y2);
bootstrapStat = zeros(nReps,1);
for i=1:nReps
    sampY1 = y1(ceil(rand(n1,1)*n1));
    sampY2 = y2(ceil(rand(n2,1)*n2));
    bootstrapStat(i) = myStatistic(sampY1,sampY2);
end
CI = prctile(bootstrapStat,[100*alpha/2,100*(1-alpha/2)]);
%Hypothesis test: Does the confidence interval cover zero?
H = CI(1)>0 | CI(2)<0;
yy = min(bootstrapStat):.01:max(bootstrapStat);
figure(18)
hist(bootstrapStat,yy);
hold on
ylim = get(gca,'YLim');
h1=plot(sampStat*[1,1],ylim,'g-','LineWidth',2);
h2=plot(CI(1)*[1,1],ylim,'r-','LineWidth',2);
plot(CI(2)*[1,1],ylim,'r-','LineWidth',2);
ax = gca; 
ax.FontSize = 24;
%h3=plot([0,0],ylim,'b-','LineWidth',2);
xlabel('Difference between means','FontSize',24);
decision = {'Fail to reject H0','Reject H0'};
%title(decision(H+1));
legend([h1,h2],{'Sample mean',sprintf('%2.0f%% Confidence interval',100*alpha)},'Location','NorthWest');
%legend([h1,h2,h3],{'Sample mean',sprintf('%2.0f%% CI',100*alpha),'H0 mean'},'Location','NorthWest');
[mypvalue3v, dispJAv, dispJBv] = myboostrap(y1,y2,nReps);
mypvalue3v


%%%%Distribution of Olfati-Saber
figure(19)
histogram(dispJAv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qA}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);

%%%%Distribution of MPC Proposal
figure(20)
histogram(dispJBv)
ax = gca; 
ax.FontSize = 24;
ax.FontName='Times New Roman';
xlabel('$\hat\mu_{J_{qB}}$','Interpreter','latex','FontSize',24);
ylabel('Frequency', 'FontSize',24);