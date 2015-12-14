function W = window2(window_size, window_type, scale_method)
    %% W = window2(window_size, window_type, scale_method)
    %
    % Generates a 2D window array that can be used to window an impulse response of size window_size
    %
    % window_size - size of the window to generate
    % window_type - type of window to generate, options include:
    %     'bartlett'
    %     'hanning'
    % scale_method - specifies the method to use generalze the 1D window selected above:
    %     'separable'
    %     'circular'

    num_row = window_size(1);
    num_col = window_size(2);

    x_axis = -floor(num_col/2):(ceil(num_col/2) - 1);
    y_axis = -(-floor(num_row/2):ceil((num_row/2) - 1));

    [X, Y] = meshgrid(x_axis, y_axis);
    T = min(window_size);

    switch lower(window_type)
        case 'bartlett'
            w = @bartlett_window;
        case 'hanning'
            w = @hanning_window;
        otherwise
            error('Unexpected window type!');
    end

    switch lower(scale_method)
        case 'separable'
            W = w(X, T) .* w(Y, T);

        case 'circular'
            R = sqrt(X.^2 + Y.^2);
            W = w(R, T);

        otherwise
            error('Unexpected scale method!');
    end


function w = bartlett_window(t, T)
    if abs(t) > T
        w = 0;
    elseif t >= 0
        w = 1 - t/T;
    else
        w = 1 + t/T;
    end


function w = hanning_window(t, T)
    if abs(t) < T
        w = 0.5*(1 + cos(pi*t/T));
    else
        w = 0;
    end
