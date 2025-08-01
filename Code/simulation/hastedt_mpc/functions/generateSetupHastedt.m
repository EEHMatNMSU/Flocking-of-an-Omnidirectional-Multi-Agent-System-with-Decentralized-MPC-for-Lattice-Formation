%---------------------------------------------------------------------------------------------------
% For Paper
% "Distributed Model Predictive Flocking with Obstacle Avoidance and Asymmetric Interaction Forces"
% by P. Hastedt and H. Werner
% Copyright (c) Institute of Control Systems, Hamburg University of Technology. All rights reserved.
% Licensed under the GPLv3. See LICENSE in the project root for license information.
% Author(s): Philipp Hastedt
%---------------------------------------------------------------------------------------------------

function setup = generateSetupHastedt(configFile, param, setVelocity, pos, vel, varargin)
switch nargin
    case 3
        [pos, vel] = calculateInitialStates(param.agentCount, param.dimension, param.field_size, setVelocity);
    case 5
        if setVelocity==0
            vel = 0*pos;
        end
    otherwise
        error('This number of arguments is not supported')
end
setup = struct;
Network = IdealNetwork(param.agentCount, param.dT, param.dimension, param.range);
setup.Network = Network;
Agents = cell(param.agentCount, 1);

for i = 1:length(Agents)
    %Agents{i} = HastedtAgent(Network.getId(), param, pos(:,i), vel(:,i),
    %configFile); %Con error al integrar obstacle component
    %Agents{i} = HastedtAgent_Sesion08(Network.getId(), param, pos(:,i),vel(:,i), configFile);%Sesion 8 con tf 400 10 agents en Copy
    %of simulation Sesion08.m
    Agents{i} = HastedtAgent(Network.getId(), param, pos(:,i),vel(:,i), configFile);
end
setup.Agents = [Agents{:}];

end