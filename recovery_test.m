%recovery(100, 5, @fit_3params_softmax, @choose_UCB, @() [rand*10, rand*10, 4, 10, 0, rand*10]);
%recovery(100, 5, @fit_5params_softmax, @choose_UCB, @() [rand*10, rand*10, rand*10, rand*20+5, 0, rand*10]);
%recovery(100, 5, @fit_4params_UCB, @choose_UCB, @() [rand*10, rand*10, 4, 10, rand*10, rand*10]);
%recovery(100, 5, @fit_6params_UCB, @choose_UCB, @() [rand*10, rand*10, rand*10, rand*20+5, rand*10, rand*10]);
recovery(100, 5, @fit_2params_Thompson, @choose_Thompson, @() [rand*10, rand*10], 3000, 10);
recovery(100, 5, @fit_4params_Thompson, @choose_Thompson, @() [rand*10, rand*10, rand*10, rand*20+5], 3000, 10);
