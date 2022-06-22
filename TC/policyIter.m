classdef policyIter

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
        % Class constructor
        function obj = policyIter(P, R, gamma, tol)
            % Set properties
            obj.P = P;
            obj.R = R;
            obj.gamma = gamma;
            obj.tol = tol;
            % Set the number of states
            obj.nStates = size(P, 1);
            % Set the number of actions
            obj.nActions = 99;
            % Generate a randomic initial policy
            obj.policy = zeros(obj.nStates, 1);
            for i=2:obj.nStates
                obj.policy(i) = randi(i, 1, 1);
            end
            % Initialize the state value function
            obj.value = zeros(obj.nStates, 1);
        end

        %         % Policy Evaluation
        %         % Given a policy pi, estimate its value function v_pi
        %         function obj = policyEval(obj)
        %             % Define the transitions and the rewards for the current policy
        %             Ppi = zeros(obj.nStates, obj.nStates);
        %             Rpi = zeros(obj.nStates, 1);
        %             for s = 1 : obj.nStates
        %                 Ppi(s, :) = obj.P(s, obj.policy(s), :);
        %                 Rpi(s) = obj.R(s, obj.policy(s));
        %             end
        %             % Iterate the evaluation, until it's reached a fixed point
        %             while (1)
        %                 % Store the old values to compute their variations
        %                 oldValue = obj.value;
        %                 % Update the estimates
        %                 % v_{k+1}(s) = sum_{s',r}(p(s',r|s,a) * (r + gamma * v_{k}(s'))) =
        %                 %            = sum_{s',r}(p(s',r|s,a) * r) + ...
        %                 %              gamma * sum_{s',r}(p(s',r|s,a) * v_{k}(s'))) =
        %                 %            = R(s,pi(s)) + gamma * P(s'|s,pi(s)) * v_{k}(s')
        %                 obj.value = Rpi + obj.gamma * Ppi * obj.value;
        %                 % Compute the max variation of the value function
        %                 % Inf-norm: max{i}(|x_i|)
        %                 % Test: vecnorm([0, -1, 2, -4], Inf)
        %                 if (vecnorm(obj.value - oldValue, Inf) < obj.tol)
        %                     % If the max variation is less than the tollerance stop!
        %                     break;
        %                 end
        %             end
        %         end

        % Policy Evaluation
        % Given a policy pi, estimate its value function v_pi
        function obj = policyEval(obj)
            % Initialize the state value function
            obj.value = zeros(obj.nStates, 1);
            % Iterate the evaluation, until it's reached a fixed point
            while (1)
                % Store the old values to compute their variations
                oldValue = obj.value;
                % Iterate on states
                for s = 2 : obj.nStates
                    % Update the estimates
                    obj.value(s) = obj.P(s, obj.policy(s), min(s+obj.policy(s), 101))*(obj.R(s) + obj.gamma * obj.value(min(s+obj.policy(s), 101))) + ...
                                   obj.P(s, obj.policy(s), max(s-obj.policy(s), 1))*(obj.R(s) + obj.gamma * obj.value(max(s-obj.policy(s), 1)));
                end
                % Compute the max variation of the value function
                % Inf-norm: max{i}(|x_i|)
                % Test: vecnorm([0, -1, 2, -4], Inf)
                if (vecnorm(obj.value - oldValue, Inf) < obj.tol)
                    % If the max variation is less than the tollerance stop!
                    break;
                end
            end
        end

        % Policy Improvment
        % Given a policy pi, find a new policy pi' s.t v_pi' >= v_pi
        function obj = policyImprov(obj)
            % Iterate on states
            Q = zeros(99, 99);  % (stati, azioni)
            for s = 2 : obj.nStates
                % Compute the state-action value function
                Qpi = zeros(1, obj.nActions);
                % Iterate on actions
                for a = 1 : obj.nActions
                    % Compute the estimate
                    Qpi(a) = obj.P(s, a, min(s+a, 101)) * (obj.R(s) + obj.gamma * obj.value(min(s+a, 101))) + ...
                             obj.P(s, a, max(s-a, 1)) * (obj.R(s) + obj.gamma * obj.value(max(s-a, 1)));
                    Q(s,a) = Qpi(a);
                end
                % Take the best action
                obj.policy(s) = find(Qpi == max(Qpi), 1,'first');
                disp(Qpi)
            end
            
            
            figure(3)
           
            X = (1:99);
            Y = (1:99);
            Z = Q(X,Y);
            surf(Z)
            title("funzione stato-azione")
            xlabel("azioni")
            ylabel("stati")
        end

        % Policy Iteration
        function obj = callPolicyIter(obj)
            % Iterate alternating policy evaluation and policy improvment
            % until it's reached a fixed point
            while (1)
                oldPolicy = obj.policy;
                % Policy evaluation: pi -> v_pi
                obj = obj.policyEval();
                % Policy improvment: pi -> pi' s.t. v_pi' >= v_pi
                obj = obj.policyImprov();
                % Check if the new policy is equal to the previous one
                if (vecnorm(obj.policy - oldPolicy, Inf) == 0)
                    % uso la norma infinita 
                    % If the two policirs are equal stop
                    break;
                end
            end

            
        end
    end
end
