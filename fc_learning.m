

function [] = fc_learning

    % https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/
    learning_rate = 0.7;
    
    input_values = [0 0; 0 1; 1 0; 1 1];
    target_values = [0 ; 1; 1; 0];
    
    hidden_neurons_count = 2;
    rng(0,'v5uniform');
    INIT_EPISLON = 0.8;

    W1 = [    0.6881   -0.2164 -0.7690;
            0.2379   -0.1385 -0.0963  ];
    W2 = [   -0.4840   -0.6903 -0.1433];
    
    bias = -1;

    W_input_to_hidden = rand(size(input_values,2)+1, hidden_neurons_count) * (2*INIT_EPISLON) - INIT_EPISLON;
    W_input_to_hidden = W1';
    
    assert(isequal(size(W_input_to_hidden), [size(input_values,2)+1 hidden_neurons_count]));
    
    
    output_neurons_count = 1;
    W_hidden_to_output = rand(hidden_neurons_count+1, output_neurons_count) * (2*INIT_EPISLON) - INIT_EPISLON;
    W_hidden_to_output = W2';
    
    assert(isequal(size(W_hidden_to_output), [hidden_neurons_count+1 output_neurons_count]));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    for iter = 1:10000
        ind = rem(iter,4);
        
        if(ind == 0)
            ind = 4;
        end
        
        target = target_values(ind,:);
        input = input_values(ind,:);
        %target = target_values;
        %input = input_values;
        
        
        % forward pass
        hidden_i = sum(W_input_to_hidden' .* repmat([input bias], [hidden_neurons_count 1]),2);% [input 1] * W_input_to_hidden
        hidden_o = activation(hidden_i)';

        output_i = sum(W_hidden_to_output' .*  repmat([hidden_o bias], [output_neurons_count 1]),2);% + hidden_bias * W_hidden_to_output_bias;
        output_o = activation(output_i)';

        e = (target - output_o) .* (target - output_o) / 2;

        %disp(sum(e));
        
        % backward pass
        De_Dotput_o = (output_o - target);
        Do_Doutput_i = activation_der(output_i');
        De_Doutput_i = De_Dotput_o .* Do_Doutput_i;
        % delta_hidden=delta_output*W2.*dsigmoid(Z2);

        d_W_hidden_to_output = repmat(De_Doutput_i, [numel([hidden_o bias]) 1])' .* repmat([hidden_o bias], [numel(De_Doutput_i) 1]);

        dE_Dhidden_o = W_hidden_to_output * De_Doutput_i';
        do_Dhidden_i = activation_der([hidden_i' bias]);
        dE_Dhidden_i = do_Dhidden_i .* dE_Dhidden_o';
        dE_Dhidden_i = dE_Dhidden_i(1:end-1);
        
        %De_Doutput_i
        %dE_Dhidden_i

        d_W_input_to_hidden = repmat(dE_Dhidden_i, [numel([input bias]) 1])' .* repmat([input bias], [numel(dE_Dhidden_i) 1]);

        W_input_to_hidden = W_input_to_hidden - learning_rate * d_W_input_to_hidden';
        W_hidden_to_output = W_hidden_to_output - learning_rate * d_W_hidden_to_output';

        %pause(0.00005);
        
        %WWW = [W_input_to_hidden' ; W_hidden_to_output']; 
        %WWW
        
        %DW = [d_W_input_to_hidden ; d_W_hidden_to_output];
        %DW
        
    end
    
     for ind = 1:4
        target = target_values(ind,:);
        input = input_values(ind,:);
        
        
        % forward pass
        hidden_i = sum(W_input_to_hidden' .* repmat([input bias], [hidden_neurons_count 1]),2);% + input_bias * W_input_to_hidden_bias;
        hidden_o = activation(hidden_i)';

        output_i = sum(W_hidden_to_output' .*  repmat([hidden_o bias], [output_neurons_count 1]),2);% + hidden_bias * W_hidden_to_output_bias;
        output_o = activation(output_i)';
    
        e = (target - output_o) .* (target - output_o) / 2;
        disp([num2str(output_o) ' ' num2str(e)]);
     end

end

function [y] = activation(x)
    y = 1 ./ (1 + exp(-x));
end

function [y] = activation_der(x)
    y = activation(x) .* (1 - activation(x));
end