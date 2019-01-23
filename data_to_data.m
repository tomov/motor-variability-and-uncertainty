function data = data_to_data
    % convert Ashesh's data to [S x 1] struct data array
    % that Sam's mfit toolbox likes

    load('from_paper/task_learn_curves (1).mat', 'targs');
    nrats = size(targs, 1);

    for rat = 1:nrats
        rat
        stationary = 1; % non stationary

        data(rat) = rat_to_exp(rat, stationary);
    end

    save data.mat
