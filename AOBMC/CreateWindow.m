function win = CreateWindow(block_size,style)

win = zeros(block_size,block_size);

switch style
    case 'Raised Cosine'
        [C,R] = meshgrid(0:block_size-1,0:block_size-1);
        win_ii = 0.5*(1-cos(pi*(R+0.5)/(block_size/2)));
        win_jj = 0.5*(1-cos(pi*(C+0.5)/(block_size/2)));
        win = win_ii .* win_jj;
    case 'Bilinear'
            [C,R] = meshgrid(0:(block_size/2-1),0:(block_size/2-1));
            win_ii = (R+0.5)/(block_size/2);
            win_jj = (C+0.5)/(block_size/2);
            win(1:block_size/2,1:block_size/2) = win_ii .* win_jj;
            win(block_size:-1:(block_size/2+1),...
                1:block_size/2) = win(1:block_size/2,1:block_size/2);
            win(1:block_size/2,...
                block_size:-1:(block_size/2+1)) = win(1:block_size/2,1:block_size/2);
            win(block_size:-1:(block_size/2+1),...
                block_size:-1:(block_size/2+1)) = win(1:block_size/2,1:block_size/2);   
end

end
                
                
                