function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Expand the 'y' output values into a matrix of single values
I = eye(num_labels);
Y = zeros(m, num_labels);
for i=1:m
  Y(i, :)= I(y(i), :);
end

% feedforward
a1 = [ones(m,1) X]                      % 5000 x 401
z2 = a1 * Theta1';                      % 5000 x 401 * 401 x 25 -> 5000 x 25
a2 = [ones(size(z2, 1), 1) sigmoid(z2)];% 5000 x 26
z3 = a2 * Theta2';                      % 5000 x 26 * 26 x 10 -> 5000 x 10
a3 = sigmoid(z3);                       % 5000 x 10
hyp = a3;

% calculate regulator
p = sum(sum(Theta1(:, 2:end).^2), 2) + sum(sum(Theta2(:, 2:end).^2), 2);

% calculate J
J = sum(sum((-Y).*log(hyp) - (1-Y).*log(1-hyp), 2))/m + lambda*p/(2*m);

% calculate sigmas
sigma3 = a3-Y;                          % 5000 x 10
                                        % 5000 x 10 * 10 x 26 -> 5000 x 26
sigma2 = (sigma3*Theta2).*sigmoidGradient([ones(size(z2, 1), 1) z2]);
sigma2 = sigma2(:, 2:end);

% accumulate gradients
delta_1 = (sigma2'*a1);                 % 26 x 5000 * 5000 x 401 -> 26 x 401
delta_2 = (sigma3'*a2);                 % 10 x 5000 * 5000 x 26 -> 10 x 26

% calculate partial derivative terms
p1 = (lambda/m)*[zeros(size(Theta1, 1), 1) Theta1(:, 2:end)];
p2 = (lambda/m)*[zeros(size(Theta2, 1), 1) Theta2(:, 2:end)];
Theta1_grad = delta_1./m + p1;
Theta2_grad = delta_2./m + p2;




% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end