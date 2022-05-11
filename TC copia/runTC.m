%% policy iteration
gamma = 0.99;
tol = 0.1;

tc = TestaCroce(0.4);

tc = tc.Pgenerator;

pi = policyIter(tc.P, tc.R, gamma, tol);
pi = pi.callPolicyIter;




states = (1:99);

figure(1)
plot(states, pi.policy(2:100), ".", "MarkerSize", 20);
sgtitle('policy ottima');
grid on
%histogram(pi.policy(2:100))

figure(2)
plot(states, pi.value(2:100), "LineWidth", 2)
sgtitle("funzione valore")
grid on


%% value interation

gamma = 0.99;
tol = 0.1;

tc = TestaCroce(0.4);

tc = tc.Pgenerator;

pi = policyIter(tc.P, tc.R, gamma, tol);
pi = pi.callPolicyIter;

states = (1:99);


figure(1)
plot(states, pi.policy(2:100), ".", "MarkerSize", 20);
%histogram(pi.policy(2:100))

figure(2)
plot(states, pi.value(2:100), "LineWidth", 2)
