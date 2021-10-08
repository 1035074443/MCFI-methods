function im_interp = AOBMC(im_prev_pad,im_next_pad,MVF,im_rows, im_cols, block_size, search_range, step_size)

% MVF = num2cell(MVF,1);
MVF_row = padarray(squeeze(MVF(1,:,:)),[1,1],'replicate');
MVF_col = padarray(squeeze(MVF(2,:,:)),[1,1],'replicate');

params.block_size = block_size;
enlarged_block_size = block_size * 2;
params.im_rows = im_rows;
params.im_cols = im_cols;
params.search_range = search_range;
params.step_size = step_size;


[block_rows,block_cols] = size(squeeze(MVF(1,:,:)));
im_interp_pad = zeros(size(im_prev_pad));

win = CreateWindow(enlarged_block_size,'Raised Cosine');

for ii = 2:block_rows+1
    for jj = 2:block_cols+1
        
        MV_ii = MVF_row(ii,jj);
        MV_jj = MVF_col(ii,jj);
        
        interp_ii = (ii-2)*block_size+1+search_range;
        interp_jj = (jj-2)*block_size+1+search_range;
        
        %Reliability of the neighboring
        prev_ii = interp_ii+MV_ii;
        prev_jj = interp_jj+MV_jj;
        next_ii = interp_ii-MV_ii;
        next_jj = interp_jj-MV_jj;
        prev_block = im_prev_pad(prev_ii:prev_ii+block_size-1,prev_jj:prev_jj+block_size-1);
        next_block = im_next_pad(next_ii:next_ii+block_size-1,next_jj:next_jj+block_size-1);
        SBAD_current = sum(abs(prev_block(:)-next_block(:)));
        Phi = zeros(3,3);
        Phi(2,2) = 1;
        for mm = -1:1
            for nn = -1:1
                if (mm==0)&&(nn==0)
                    continue;
                end
                MV_ii = MVF_row(ii+mm,jj+nn);
                MV_jj = MVF_col(ii+mm,jj+nn);
                prev_ii = interp_ii+MV_ii;
                prev_jj = interp_jj+MV_jj;
                next_ii = interp_ii-MV_ii;
                next_jj = interp_jj-MV_jj;
                prev_block = im_prev_pad(prev_ii:prev_ii+block_size-1,prev_jj:prev_jj+block_size-1);
                next_block = im_next_pad(next_ii:next_ii+block_size-1,next_jj:next_jj+block_size-1);
                SBAD_candidate = sum(abs(prev_block(:)-next_block(:)));
                if SBAD_candidate == 0
                   Phi(mm+2,nn+2) = 1;
                else
                   Phi(mm+2,nn+2) = SBAD_current/SBAD_candidate;
                end
            end
        end
          
        %Left-Upper
        mark_ii = interp_ii;
        mark_jj = interp_jj;
        temp = zeros(block_size/2,block_size/2);
        win_sum = temp;
        for mm = -1:0
            for nn = -1:0
                MV_ii = MVF_row(ii+mm,jj+nn);
                MV_jj = MVF_col(ii+mm,jj+nn);
                prev_ii = mark_ii+MV_ii;
                prev_jj = mark_jj+MV_jj;
                next_ii = mark_ii-MV_ii;
                next_jj = mark_jj-MV_jj;
                prev_block = im_prev_pad(prev_ii:prev_ii+block_size/2-1,prev_jj:prev_jj+block_size/2-1);
                next_block = im_next_pad(next_ii:next_ii+block_size/2-1,next_jj:next_jj+block_size/2-1);
                Phi_current = Phi(mm+2,nn+2);
                if (mm==0)&&(nn==0)
                    win_current = win(block_size/2+1:block_size,block_size/2+1:...
                    block_size);
                elseif (mm==0)&&(nn==-1)
                    win_current = win(block_size/2+1:block_size,1.5*block_size+1:...
                    2*block_size);
                elseif (mm==-1)&&(nn==0)
                    win_current = win(1.5*block_size+1:2*block_size,block_size/2+1:...
                    block_size);
                else
                    win_current = win(1.5*block_size+1:2*block_size,1.5*block_size+1:...
                    2*block_size);
                end
                temp = temp + 0.5*(Phi_current*win_current.*(prev_block+...
                    next_block));
                win_sum = win_sum + Phi_current*win_current;
            end
        end
        temp = temp./win_sum;
        im_interp_pad(mark_ii:mark_ii+block_size/2-1,...
            mark_jj:mark_jj+block_size/2-1) = temp;
        
        %Left-bottom
        mark_ii = interp_ii+block_size/2;
        mark_jj = interp_jj;
        temp = zeros(block_size/2,block_size/2);
        win_sum = temp;
        for mm = 0:1
            for nn = -1:0
                MV_ii = MVF_row(ii+mm,jj+nn);
                MV_jj = MVF_col(ii+mm,jj+nn);
                prev_ii = mark_ii+MV_ii;
                prev_jj = mark_jj+MV_jj;
                next_ii = mark_ii-MV_ii;
                next_jj = mark_jj-MV_jj;
                prev_block = im_prev_pad(prev_ii:prev_ii+block_size/2-1,prev_jj:prev_jj+block_size/2-1);
                next_block = im_next_pad(next_ii:next_ii+block_size/2-1,next_jj:next_jj+block_size/2-1);
                Phi_current = Phi(mm+2,nn+2);
                if (mm==0)&&(nn==0)
                    win_current = win(block_size+1:1.5*block_size,block_size/2+1:...
                    block_size);
                elseif (mm==0)&&(nn==-1)
                    win_current = win(block_size+1:1.5*block_size,1.5*block_size+1:...
                    2*block_size);
                elseif (mm==1)&&(nn==0)
                    win_current = win(1:0.5*block_size,block_size/2+1:...
                    block_size);
                else
                    win_current = win(1:0.5*block_size,1.5*block_size+1:...
                    2*block_size);
                end
                temp = temp + 0.5*(Phi_current*win_current.*(prev_block+...
                    next_block));
                win_sum = win_sum + Phi_current*win_current;
            end
        end
        temp = temp./win_sum;
        im_interp_pad(mark_ii:mark_ii+block_size/2-1,...
            mark_jj:mark_jj+block_size/2-1) = temp;
        %Right-upper
        mark_ii = interp_ii;
        mark_jj = interp_jj+block_size/2;
        temp = zeros(block_size/2,block_size/2);
        win_sum = temp;
        for mm = -1:0
            for nn = 0:1
                MV_ii = MVF_row(ii+mm,jj+nn);
                MV_jj = MVF_col(ii+mm,jj+nn);
                prev_ii = mark_ii+MV_ii;
                prev_jj = mark_jj+MV_jj;
                next_ii = mark_ii-MV_ii;
                next_jj = mark_jj-MV_jj;
                prev_block = im_prev_pad(prev_ii:prev_ii+block_size/2-1,prev_jj:prev_jj+block_size/2-1);
                next_block = im_next_pad(next_ii:next_ii+block_size/2-1,next_jj:next_jj+block_size/2-1);
                Phi_current = Phi(mm+2,nn+2);
                if (mm==0)&&(nn==0)
                    win_current = win(0.5*block_size+1:block_size,block_size+1:...
                    1.5*block_size);
                elseif (mm==0)&&(nn==1)
                    win_current = win(0.5*block_size+1:block_size,1:...
                    0.5*block_size);
                elseif (mm==-1)&&(nn==1)
                    win_current = win(1.5*block_size+1:2*block_size,1:...
                    block_size/2);
                else
                    win_current = win(1.5*block_size+1:2*block_size,block_size+1:...
                    1.5*block_size);
                end
                temp = temp + 0.5*(Phi_current*win_current.*(prev_block+...
                    next_block));
                win_sum = win_sum + Phi_current*win_current;
            end
        end
        temp = temp./win_sum;
        im_interp_pad(mark_ii:mark_ii+block_size/2-1,...
            mark_jj:mark_jj+block_size/2-1) = temp;
        %Right-bottom
        mark_ii = interp_ii+block_size/2;
        mark_jj = interp_jj+block_size/2;
        temp = zeros(block_size/2,block_size/2);
        win_sum = temp;
        for mm = 0:1
            for nn = 0:1
                MV_ii = MVF_row(ii+mm,jj+nn);
                MV_jj = MVF_col(ii+mm,jj+nn);
                prev_ii = mark_ii+MV_ii;
                prev_jj = mark_jj+MV_jj;
                next_ii = mark_ii-MV_ii;
                next_jj = mark_jj-MV_jj;
                prev_block = im_prev_pad(prev_ii:prev_ii+block_size/2-1,prev_jj:prev_jj+block_size/2-1);
                next_block = im_next_pad(next_ii:next_ii+block_size/2-1,next_jj:next_jj+block_size/2-1);
                Phi_current = Phi(mm+2,nn+2);
                if (mm==0)&&(nn==0)
                    win_current = win(block_size+1:1.5*block_size,block_size+1:...
                    1.5*block_size);
                elseif (mm==0)&&(nn==1)
                    win_current = win(block_size+1:1.5*block_size,1:...
                    0.5*block_size);
                elseif (mm==1)&&(nn==1)
                    win_current = win(1:0.5*block_size,1:...
                    block_size/2);
                else
                    win_current = win(1:0.5*block_size,block_size+1:...
                    1.5*block_size);
                end
                temp = temp + 0.5*(Phi_current*win_current.*(prev_block+...
                    next_block));
                win_sum = win_sum + Phi_current*win_current;
            end
        end
        temp = temp./win_sum;
        im_interp_pad(mark_ii:mark_ii+block_size/2-1,...
            mark_jj:mark_jj+block_size/2-1) = temp;
        
    end
end

im_interp = im_interp_pad((1+search_range):(im_rows+search_range),...
        (1+search_range):(im_cols+search_range));
    
end
        
                    
                
            
                
        
        
        
        








