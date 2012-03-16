 function [ psogp ] = addToPSOGP( x, y, psogp )
%addToPSOGP Summary of this function goes here
%   Detailed explanation goes here
    kstar = getKStar(x,psogp);
    
    %is this a new psogp?
    if not(isfield(psogp, 'phi'))
       psogp.alpha = y / (kstar + psogp.noise);
       psogp.C = -1/(kstar + psogp.noise);
       psogp.Q = 1/kstar;
       psogp.phi{1} = x;
    else
        %nope, let's do a geometric test
        C = psogp.C;
        alpha = psogp.alpha;
        Q = psogp.Q;
        
        
        k = getKStarVector(x, psogp);
        m = k'*alpha;
        s2 = kstar + (k.'*C*k);
        
        if (s2 < 1e-12)
            fprintf(1, 's2 stability: %f\n',s2);
            s2 = 1e-12;
        end
        
        
        r = -1.0/(s2 + psogp.noise);
        q = -r*(y - m);
        ehat = Q*k;

        gamma = kstar - dot(k,ehat);
        eta = 1.0/(1.0 + gamma*r);
        if (gamma < 1e-12 )
            fprintf(1, 'gamma stability: %f\n', gamma);
            gamma = 0;
        end

        if (gamma >= psogp.epsilon*kstar)  
                        %full update
            s = [C*k; 1];
%             p = zeros(size(s,1),1);
%             p(end) = 1;
            
            %add to bv
            psogp.phi{end+1} = x;
            
            %update Q
            Q(end+1, end+1) = 0;
            ehat(end+1) = -1;
            ehat = ehat(:); %make ehat a column vector

            Q = Q + (1/gamma)*(ehat*ehat.');
            
            alpha(end+1) = 0;
            alpha = alpha(:);

            alpha = alpha + (s*q);
            C(end+1, end+1) = 0;
            C = C+r*(s*s.');
        else

            %sparse update
            s = C*k +ehat;
            alpha = alpha + s*(q*eta).';
            C = C+r*eta*(s*s.');
        end
        
        psogp.C = C;
        psogp.alpha = alpha;
        psogp.Q = Q;
        
    end
    
    %basis vector deletion
    len_phi = length(psogp.phi);   
    if (len_phi > psogp.capacity)
        %score
        for i = 1:len_phi
            score(i) = norm(alpha(i,:))^2/ (Q(i,i) + C(i,i));
        end
        [min_val, min_index] = min(score);
        psogp = deleteFromPSOGP( min_index, psogp );
    end
    

end