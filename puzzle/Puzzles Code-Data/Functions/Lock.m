% References: 
% 1. Hoff, D., Olver, P.J., Automatic Solution of Jigsaw Puzzles, preprint, University of Minnesota, 2012.
% 2. Hoff, D., Olver, P.J.: Extensions of Invariant Signatures for Object Recognition. J. Math. Imaging Vis., Online First(TM), 7 June 2012.


% This function performs the locking algorithm described in [1]. It 
% is intended for use by the Assemble() function.
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'g_0':      This input should be a matrix of the form [theta a b] 
            where these parameters specify a rigid motion as 
            described in [2] (a translation by [a b] and a rotation 
            by theta radians around the origin). 

'C_Delta':  This should be a discretized planar curve of n points 
            represented as an n-by-2 matrix, each row of which 
            specifies a point in R^2. The curve is assumed to be 
            closed; no repetition of points is necessary.

'Ctilde_Delta': This should be a discretized planar curve of n points 
            represented as an n-by-2 matrix, each row of which 
            specifies a point in R^2. The curve is assumed to be 
            closed; no repetition of points is necessary.

'K_1', 'K_2', 'K_3', 'K_4', 'epsilon', 'nu', 'rho', 'j_max':   These inputs
            should be doubles that give the parameters as described
            in [1].

'plotter':  In this bool, value of 1 results in the plotting of a 
            visualization of the piece locking whereas a value of 0 
            does not. 

'fh':       If this input is supplied and plotter = 1, the 
            visualization is plotted on the figure with handle 'fh'.

%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'g_lock'	: This is the resulting transformation as described in 
			[1].

'D_Delta_3_Ics', 'Dtilde_Delta_3_Ics', 'D_Delta_2_Ics', 
'Dtilde_Delta_2_Ics': These columns contain the 
            indices (within C_Delta and Ctilde_Delta) of
            the points in the sets as defined in [1].

'xph':      This output is assigned only if 'fh' is inputted and 
            plotter = 1, in which case it contains the handle of an
            object to be later deleted by the Assemble() function.

%--------------------------------------------------------------------
%}


function [g_lock D_Delta_3_Ics Dtilde_Delta_3_Ics D_Delta_2_Ics Dtilde_Delta_2_Ics xph] = Lock(g_0, C_Delta, Ctilde_Delta, K_1, K_2, K_3, K_4, epsilon, nu, rho, j_max, plotter, fh)

    % Initialize variables
    n = size(C_Delta, 1);  
    d_star = sum(sqrt((circshift(C_Delta(:, 1), -1) - C_Delta(:, 1)).^2+(circshift(C_Delta(:, 2), -1) - C_Delta(:, 2)).^2))/n;
    E_Delta_K_1 = [];
    Etilde_Delta_K_1 = {};
    D_Delta_3_Ics = [];
    Dtilde_Delta_3_Ics = [];
	D_Delta_2_Ics = [];
    Dtilde_Delta_2_Ics = [];
    xph = [];
    

    % Set up plot if applicable
    if(plotter)      
        if(~exist('fh', 'var'))
            solo = 1;
            fh = figure();
            plot(Ctilde_Delta(:, 1), Ctilde_Delta(:, 2), '.b', 'MarkerSize', 5);
            hold on;
            axis equal;
        else
            figure(fh);
            solo = 0;
        end;
        x = transf(C_Delta, g_0, [0 0]);
        inith = plot(x(:, 1), x(:, 2), '--k');
        axis auto;     
    end;
    
    
    % Calculate Relevant Sets   
    for c1 = 1:n
        temp_pts = Ctilde_Delta(vecnorm(Ctilde_Delta-ones(size(Ctilde_Delta, 1), 1)*transf(C_Delta(c1, :), g_0, [0, 0])) < K_1*d_star, :);
        if(~isempty(temp_pts))
            Etilde_Delta_K_1 = [Etilde_Delta_K_1 ; temp_pts];
            E_Delta_K_1 = [E_Delta_K_1 ; C_Delta(c1, :)];
        end;     
    end;
    n1 = size(E_Delta_K_1, 1);
    
    % Terminate algorithm if no changes will be made
    if(n1 == 0)
        q_tilde = 0;
        q = 0;
        g_lock = g_0;
        return
    end;
    
    % Calculate perturbation constants
    z_cm = sum(E_Delta_K_1, 1)/n1;
    r_2 = sum(vecnorm(E_Delta_K_1 - ones(n1, 1)*z_cm).^2);
    r_infty = max(vecnorm(E_Delta_K_1 - ones(n1, 1)*z_cm));    
    
    % Convert g_0 from the form used in Assemble() (rotation around the
    % origin) to the form used in Lock() (rotation around the center of
    % mass
    g_j = [g_0(1), (g_0(2:3)' - z_cm' + [cos(g_0(1)), -sin(g_0(1)) ; sin(g_0(1)) cos(g_0(1))]*z_cm')'];
    w_j = z_cm + g_j(1, 2:3);

    
    % Perform iterative perturbation
    d_j = K_1*d_star;
	theta_jm1 = 0;
	c_jm1 = 0;
    for j = 1:j_max
        tau_tot_j = 0;
        f_tot_j = [0 0];
        A_j = zeros(n1, 1);
        for c2 = 1:n1
            diff = Etilde_Delta_K_1{c2, 1} - ones(size(Etilde_Delta_K_1{c2, 1}, 1), 1)*transf(E_Delta_K_1(c2, :), g_j, z_cm);
            A_j(c2, 1) = min(vecnorm(diff));
            if(A_j(c2, 1) >= K_4*d_star)
                f_j = sum(diff./((vecnorm(diff).^(nu+1)+epsilon*vecnorm(diff))*[1 1]), 1);
            else
                f_j = [0 0];
            end;
            f_tot_j = f_tot_j + f_j;              
            tau_tot_j = tau_tot_j + cross([transf(E_Delta_K_1(c2, :), g_j, z_cm)- w_j  0], [f_j 0])*[0 ; 0 ; 1];
        end;
        d_av_j = mean(A_j);
        d_med_j = median(A_j); 

        % Terminate the algorithm if fit is poor and getting worse.
        if(d_av_j > d_j && d_med_j >= K_3*d_star)       
            g_j = g_j - [theta_j c_j];
            w_j = w_j - c_j;
            if(plotter)
                figure(fh);   
                delete(xph);
                x = transf(C_Delta, g_j, z_cm);
                xph = plot(x(:, 1), x(:, 2), 'k');
            end;
            break;
        end;
        
        % Calculate new transformation
        delta_j = rho*d_med_j/max([vecnorm(f_tot_j)/n1, r_infty*abs(tau_tot_j)/r_2]);
        theta_j = delta_j*tau_tot_j/r_2;
        c_j = delta_j*f_tot_j/n1;
        
        % Update key quantities
        g_j = g_j + [theta_j c_j];
        w_j = w_j + c_j;
        d_j = d_av_j;
        
        % Plot changes if applicable
        if(plotter)
            figure(fh);   
            delete(xph);
            x = transf(C_Delta, g_j, z_cm);
            xph = plot(x(:, 1), x(:, 2), 'k');
        end;
		if((theta_j*theta_jm1 < 0 && c_j(1, 1)*c_jm1(1, 1) < 0 && c_j(1, 2)*c_jm1(1, 2) < 0))
            break;
        end;
        theta_jm1 = theta_j;
		c_jm1 = c_j;
    end;   
    
    
    % Find indices of relevant sets
    for c2 = 1:n
        diff = vecnorm(ones(size(Ctilde_Delta, 1), 1)*transf(C_Delta(c2, :), g_j, z_cm) - Ctilde_Delta);
        temp_ind = find(diff < K_2*d_star);
        if(~isempty(temp_ind))
            D_Delta_2_Ics = [D_Delta_2_Ics ; c2];
            Dtilde_Delta_2_Ics = [Dtilde_Delta_2_Ics; temp_ind];
        end;
		temp_ind = find(diff < K_3*d_star);
        if(~isempty(temp_ind))
            D_Delta_3_Ics = [D_Delta_3_Ics ; c2];
            Dtilde_Delta_3_Ics = [Dtilde_Delta_3_Ics; temp_ind];
        end;
    end;  
	Dtilde_Delta_2_Ics = unique(Dtilde_Delta_2_Ics);
	Dtilde_Delta_3_Ics = unique(Dtilde_Delta_3_Ics); 
    
    % Plot if applicable
    if(plotter)
        figure(fh);
        x = transf(C_Delta, g_j, z_cm);
        if(solo)      
            plot(x(D_Delta_3_Ics(:, 1), 1), x(D_Delta_3_Ics(:, 1), 2), 'ro');
            pause;
        else
            if(get(gcf, 'CurrentCharacter') == 'p')
                set(gcf, 'CurrentCharacter', 'a')          
                temph = plot(x(D_Delta_3_Ics(:, 1), 1), x(D_Delta_3_Ics(:, 1), 2), 'ro');
                pause;  
                delete(temph);
            end;      
            delete(inith);
        end;
    end;
    
    % Convert g_j to the form used in Assemble()
    g_lock = [g_j(1), (g_j(2:3)' + z_cm'- [cos(g_j(1)), -sin(g_j(1)) ; sin(g_j(1)) cos(g_j(1))]*z_cm')'];
        
 
end



function lengths = vecnorm(points)

% This function calculates the norms of a collection of points in R^2
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'points':   This variable should contain points represented as an 
            n-by-2 matrix, each row of which specifies a point in R^2

%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'lengths':  This output is a n-by-1 matrix whose jth element is the norm of
            the jth point in 'points'

%--------------------------------------------------------------------
%}

lengths = (points(:, 1).^2 + points(:, 2).^2).^(1/2);


end


function new_points = transf(points, trans, cm)

% This function applies a rigid motion to inputed points
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'points':   This should be n points represented as an n-by-2 matrix, 
            each row of which specifies a point in R^2. 

'trans':    This input should be a matrix of the form [theta a b] 
            where these parameters specify a rigid motion consisting
            of a translation by [a b] and a rotation of theta radians
            around the point cm. 

'cm':       The point in R^2, represented by a 1-by-2 matrix, about 
            which the rotation will take place.

%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'new_points':   This output gives the transformed points as an n-by-2 
            matrix, each row of which specifies a point in R^2.

%--------------------------------------------------------------------
%}

points = points - ones(size(points, 1), 1)*cm;

new_points(:, 1) = cos(trans(1))*points(:, 1) - sin(trans(1))*points(:, 2)+trans(2);
new_points(:, 2) = sin(trans(1))*points(:, 1) + cos(trans(1))*points(:, 2)+trans(3);

new_points = new_points + ones(size(points, 1), 1)*cm;

end











