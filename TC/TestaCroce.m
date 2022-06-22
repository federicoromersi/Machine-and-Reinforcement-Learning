classdef TestaCroce
    
    properties
        money;
        reward;
        action;
        P;
        R; % reward 
        nStates;
        nActions;
        probT;  % probabilità che esce testa    
    end
    
    methods
        function obj = TestaCroce(probT)

            obj.nStates = 101; 
            % nello stato n ho n-1 soldi
            obj.probT = probT; % probabilità che esce testa
            obj.R = zeros(obj.nStates, 1);
            obj.R(101) = 1; 
            obj.nActions = 99;
        end
        
        function obj = Pgenerator(obj)
            % P -> matrice di dimensione nStates x nStates x nStates che
            % descrive la matrice del transizione dello stato per un
            % determinato stato iniziale e per una data azione
            obj.P = zeros(obj.nStates, obj.nActions, obj.nStates);
            % i -> stato da cui parto (quantità di soldi che ho)
            % j -> azione che ho giocato (quantità di soldi puntati)
            for i = 2:obj.nStates
               for j = 1:obj.nActions
                  if (i > j)
                      obj.P(i, j, min(i+j,101)) = obj.probT;
                      obj.P(i, j, max(1,i-j)) = (1 - obj.probT);
                  end
               end
            end
        end
    end
end

