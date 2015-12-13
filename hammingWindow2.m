function window = hammingWindow2(window_size, hamming_flag)
    %% flag type can be either 'periodic' or 'symmetric' 
    if ~exist('hamming_flag', 'var')
        hamming_flag = 'periodic';
    end

    hamming_x = hamming(window_size(2), hamming_flag);
    hamming_y = hamming(window_size(1), hamming_flag);
    [X,Y] = meshgrid(hamming_x, hamming_y);
    window = X.*Y;
end
