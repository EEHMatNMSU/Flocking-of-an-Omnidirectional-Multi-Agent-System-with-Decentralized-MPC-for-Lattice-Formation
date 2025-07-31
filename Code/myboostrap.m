%---------------------------------------------------------------------------------------------------
% Code to reproduce material in the article
% "Flocking of an Omnidirectional Multi-Agent System with 
% Decentralized MPC for Lattice Formation: Sigma-Norm Design and Comparative Performance Assessment"
% by EUSEBIO E. HERNÁNDEZ, HENGAMEH MIRHAJIANMOGHADAM, EDUARDO S. ESPINOZA, LUIS RODOLFO GARCIA CARRILLO
% Instituto Politécnico Nacional, Ciudad de Mexico 07320 Mexico 
% Author: Eusebio Hernandez (e-mail: euhernandezm@ipn.mx)
%---------------------------------------------------------------------------------------------------

function [mypvalue, dispJA, dispJB] = myboostrap(promJA,promJB,nboostrap)
% promJA=rand(1,19);
% promJB=rand(1,19);
% nboostrap=10000;
nJA=length(promJA);
nJB=length(promJB);
if(nJA~=nJB)
    exit;
end
cont=0;
dispJA=[];
dispJB=[];
for i=1:nboostrap
mediaA=mean(promJA(randsample(1:nJA,nJA,true)));
mediaB=mean(promJB(randsample(1:nJB,nJB,true)));
cont=cont+double(mediaA<mediaB);
%cont=cont+double(mean(promJA(randsample(1:nJA,nJA,true)))<mean(promJB(randsample(1:nJB,nJB,true))));
dispJA=[dispJA mediaA];
dispJB=[dispJB mediaB];
end
%cont
mypvalue=1-cont/nboostrap;
%hist(dispJpA)
end
%distJpA=[dispJpA mean(promJA(randsample(1:nJA,nJA,true))] Graficar
%distribucion con histograma

%Llamada a funcion [mypvalue] = myboostrap(JA,JB,1000,1)