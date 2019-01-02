function ex = breaks(ex)

    % include breaks after every 3 sessions (i.e. as if the next day begins)

    ex.breaks(ex.session_size*3 : ex.session_size*3 : end) = 3 * ex.session_size;
