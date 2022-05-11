classdef valueIter
    
    properties
        P;          % Transition matrix
        R;          % Reward matrix
        gamma;      % Discount factor
        tol;        % Tollerance
        nStates;    % Number of states
        nActions;   % Number of actions
        policy;     % Current policy
        value;      % Current state value function
    end
    
    methods
        function obj = valueIter(R, P, gamma, tol)
            obj.R = R;
            obj.P = P;
            obj.gamma = gamma;
            obj.tol = tol;
            obj.value = zeros(nStates, 1);
            obj.policy;
        end
        
        function obj = playValueIter(obj)
            
            while (1)
                for s=2:obj.nStates
                    tempVal = obj.value(s);
                    valAct = zeros(obj.nActions);
                    for a=1:obj.nActions
                        valAct(a) = obj.P(s, a, min(s+a, 101)) * (obj.R(s) + obj.gamma * obj.value(min(s+a, 101))) + ...
                                    obj.P(s, a, max(s-a, 1)) * (obj.R(s) + obj.gamma * obj.value(max(s-a, 1)));
                    end
                    [obj.value(s), obj.policy(s)] = max(valAct);
                end
                if (vecnorm(tempVal - obj.value, Inf) < obj.tol)
                    break;
                end
            end
        end
    end
end

