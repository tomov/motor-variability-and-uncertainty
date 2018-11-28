function ex = stationary(ex)

    % include stationary context; make sure to run after init_exp

    ex.tarclamp(round(ex.n*1/3):round(ex.n*2/3)) = 0;
