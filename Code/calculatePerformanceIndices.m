%---------------------------------------------------------------------------------------------------
% Code to reproduce material in the article
% "Flocking of an Omnidirectional Multi-Agent System with 
% Decentralized MPC for Lattice Formation: Sigma-Norm Design and Comparative Performance Assessment"
% by EUSEBIO E. HERNÁNDEZ, HENGAMEH MIRHAJIANMOGHADAM, EDUARDO S. ESPINOZA, LUIS RODOLFO GARCIA CARRILLO
% Instituto Politécnico Nacional, Ciudad de Mexico 07320 Mexico 
% Author: Eusebio Hernandez (e-mail: euhernandezm@ipn.mx)
%---------------------------------------------------------------------------------------------------

function [Jq,Jp,promJq, promJp] = calculatePerformanceIndices(data, rc, d, plotResults)
%%rc communication range
%%d desired distance of an agent i to all of its neighbors
agentCount = length(data.data.position(1,1,:));
Jq = zeros(1,length(data.t));
Jp = zeros(1,length(data.t));
promJq=0;
promJp=0;
for t = 1:length(data.t)
    position = data.data.position;
    velocity = data.data.velocity;

    % calculate position performance index
    countQ = 0;
    for i  = 1:agentCount
        for j =1:agentCount
            qij = norm(position(t,:,i)-position(t,:,j));
            if (qij<=rc) && (j>i) %(qij<=rc) && (i~=j)
                Jq(t) = Jq(t)+(qij-d)^2;
                countQ = countQ+1;
            end
            %mqij(i,j)=qij;
        end
    end
    if countQ ~=0
        Jq(t) = Jq(t)/countQ;
    end
    % calculate velocity performance index
    for i = 1:agentCount
        p_mean = sum(squeeze(velocity(t,:,:)),2)/agentCount;
        Jp(t) = Jp(t) + norm(velocity(t,:,i)-p_mean')^2/agentCount;
    end
end
promJq=sum(Jq)/length(Jq);
promJp=sum(Jp)/length(Jp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function irregularity = computeAlphaLatticeIrregularity(positions, d, adjacency)
%     % Compute the alpha-lattice irregularity measure for a multi-agent system.
%     % Inputs:
%     %   positions : N x 2 (or N x 3) matrix of agent positions [x, y (, z)]
%     %   d        : Desired inter-agent distance (scalar)
%     %   adjacency: N x N adjacency matrix (1 = neighbors, 0 = not neighbors)
%     % Output:
%     %   irregularity: Scalar measure of formation irregularity.
%     N = size(positions, 1); % Number of agents
%     irregularity = 0;
%     for i = 1:N
%         neighbors = find(adjacency(i, :)); % Get neighbors of agent i
%         for j = neighbors
%             if j > i % Avoid double-counting pairs
%                 dist_ij = norm(positions(i, :) - positions(j, :));
%                 irregularity = irregularity + (dist_ij - d)^2;
%             end
%         end
%     end
%     irregularity = irregularity / N; % Normalize by number of agents
% end
if plotResults
    figure()
    subplot(1,2,1)
    plot(data.t, Jq);
    xlabel('time');
    ylabel('J_q');
    title('Position Irregularity');
    grid on;
    subplot(1,2,2)
    plot(data.t, Jp);
    xlabel('time');
    ylabel('J_p');
    title('Velocity Mismatch');
    grid on;
    set(gca, 'XLim', [0 data.t(end-1)]);
end

end
%0.4338   16.9584
