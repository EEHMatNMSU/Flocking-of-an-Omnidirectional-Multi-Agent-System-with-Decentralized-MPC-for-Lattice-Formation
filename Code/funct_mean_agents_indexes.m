%---------------------------------------------------------------------------------------------------
% Adapted from the code in the paper
% "Distributed Model Predictive Flocking with Obstacle Avoidance and Asymmetric Interaction Forces"
% by P. Hastedt and H. Werner
% Copyright (c) Institute of Control Systems, Hamburg University of Technology. All rights reserved.
% Licensed under the GPLv3. See LICENSE in the project root for license information.
% Author(s): Philipp Hastedt
%---------------------------------------------------------------------------------------------------

function [promJq, promJp] = funct_mean_agents_indexes(MyAlgIndex, Myrange, Myro)

%% Select Scenario

% Scenarios
% 1: Large obstacle
% 2: Field of small Obstacles

algorithmIndex  = MyAlgIndex;
scenarioIndex   = 1;

%% Setup
addpath(genpath('simulation/mas-simulation/lib'))
addpath(genpath('simulation'))
simPath = "simulation/";

algorithms = simPath + [...
    "hastedt_mpc"
    "huang_mpc"
    "olfati-saber"
    "Sigma_mpc"
    ];

preallocate = {...
    @preallocateHastedt
    @preallocateHuang
    @preallocateOlfatiSaber
    @preallocateSigma
    };

generateSetup = {...
    @generateSetupHastedt
    @generateSetupHuang
    @generateSetupOlfatiSaber
    @generateSetupSigma
    };
%% Set Agent Parameters
cfg = generateConfig(algorithms, algorithmIndex);

%% Simulation Setup
% define output and initialization files and paths
outPath = strcat(simPath,"out/",erase(algorithms(algorithmIndex),simPath),"/");
outFile = outPath+"results.mat";
initializationFile = simPath+"initialStates_20.mat";

% simulation parameters
Tf               = 200; % 80 Simulation duration [s]   %400 original
param.agentCount = 15; % Number of agents in the network
param.dimension  = 2;  % Dimension of the space the agents move in
param.dT         = 0.2; % Size of the simulation time steps [s]
param.range      = Myrange; % 10.5 Agent interaction range %Original 8.4 Funciona bien con 7-8.4, 9-12
param.ro         = Myro;   % 8.4 Obstacle interaction range
% param.range      = 18.0;  % Agent interaction range
% param.ro         = 12.0;  % Obstacle interaction range

% scenario
param.reference = [80;80;0;0];
%param.reference = [100;100;0;0];
if (scenarioIndex == 1)
    param.obstacles = [45;45;10];
elseif (scenarioIndex == 2)
    % param.obstacles = [ 50  67  50  50  33  33  67
    %                     50  50  67  33  50  67  33
    %                     1   1   1   1   1   1   1];
    % param.obstacles = [ 55  20  
    %                     25  50 
    %                     17  17];%MPC_SigmaNorm_2obst_10AgentsTf80S02.avi
    % param.obstacles = [ 43  20  
    %                     21  40 
    %                     10  10];%MPC_SigmaNorm_2obst_10AgentsTf80S02.avi
    %                     %%Obstaculos para MPC sigma
    param.obstacles = [ 50  15  
                        21  40 
                        10  10];%%Obstaculos para algoritmos
    % param.obstacles = [ 35   
    %                     25  
    %                     10];%MPC_SigmaNorm_1obst_10AgentsTf80S02.avi
end

%init = load(initializationFile);
% Randomly place the agents in the square [0, 15]^2 with initial velocities between
% [-0.5,0.5]
for i = 1: param.agentCount
    initpos(:,i) = param.range*(rand(param.dimension,1));
    initvel(:,i) =-0.5+1*(rand(2, 1));
 end

setup = generateSetup{algorithmIndex}(cfg, param, 1, initpos, initvel);

%% Run Simulation
sim = SimulationManager(setup.Network, setup.Agents);
leech = preallocate{algorithmIndex}(setup, sim, Tf);
data = performSimulation(sim, leech, Tf);
out.t = data.t;
out.data = data.data;
save(outFile,'out','setup','param', 'cfg');

%CALCULATEPERFORMANCEINDCES calculate minimum distance between agents and 
%                           obstacles
% Inputs
%   out             :   simulation data
%   param           :   parameter struct
%   plotResults     :   if true, results will be plotted
%   d               :   desired inter-agent distance
%   do              :   desired agent-obstacle separation
% Outputs
%   Jq              :   alpha lattice irregularity
%   Jp              :   velocity mismatch
%[minDistNeighbors, minDistObstacles] = calculateMinimumDistances(out, param, true, cfg.d, cfg.do);
[Jq,Jp,promJq,promJp] = calculatePerformanceIndices(out,param.range,sqrt(cfg.d),0);%10.5 y d=9 dmet=3 %%Ivvan rc=6 dmetrica=1.8 dalg=3.24
%[Jq,Jp] = calculatePerformanceIndices(out,8.4,7,1);
%promJq
%promJp


end