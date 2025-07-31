%---------------------------------------------------------------------------------------------------
% For Paper
% "Distributed Model Predictive Flocking with Obstacle Avoidance and Asymmetric Interaction Forces"
% by P. Hastedt and H. Werner
% Copyright (c) Institute of Control Systems, Hamburg University of Technology. All rights reserved.
% Licensed under the GPLv3. See LICENSE in the project root for license information.
% Author(s): Philipp Hastedt
%---------------------------------------------------------------------------------------------------

function sigma = MysigmaNorm(z)
epsilon=0.1;
sigma= (1 / epsilon ) * ( sqrt (1 + epsilon * norm ( z ) ^2) - 1);
%sigma = z/sqrt(1+norm(z)^2);
end

