% References: 
% 1. Hoff, D., Olver, P.J., Automatic Solution of Jigsaw Puzzles, preprint, University of Minnesota, 2012.
% 2. Hoff, D., Olver, P.J.: Extensions of Invariant Signatures for Object Recognition. J. Math. Imaging Vis., Online First(TM), 7 June 2012.


% This function attemps to solve a puzzle using the algorithm 
% described in [1].
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'puzzle':   This should be a single row cell array, each of whose 
            entries represents the boundary of a puzzle piece. Each 
            boundary should be a discretized planar curve of m points 
            represented as an m-by-2 matrix, each row of which 
            specifies a point in R^2. The curves are assumed to be 
            closed; no repetition of initial points is necessary. 

'plotter':  This input should belong to the set {0, 1, 2, 3} and 
            controls what aspects of the algorithm are visualized as 
            the code runs. In all cases, a GUI is employed to gather 
            parameters and a progress report is generated. If plotter 
            = 0, no other figures are generated. If plotter = 1, the 
            final solution is also plotted. If plotter = 2, the 
            current subpuzzle is plotted as the puzzle is assemble. 
            If plotter = 3, each piece-locking is also plotted. 
 
'saver':    This logical input determines whether or not data is
            saved as the algorithm runs. Data is saved to the current
            directory as 'CurrentPuzzleData.mat' and can be used with
            the 'Assemble.m' function to resume computation at the 
            point of saving.

'parameters':   This variable contains the parameters (described in 
            [1]) used by the algorithm. In most cases this input 
            should be ommitted, allowing the user to input parameters 
            through a GUI. Default values are calculated based on the 
            size of the 'puzzle' array. However, if a parameter 
            sequence with j_star > 7 is desired, it must be inputted 
            manually through the 'parameters' variable. See the 
            default values of 'parameters' below for the form this 
            input must take.

%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'pieces':   This output is a 1-by-n structure each of whose columns
            corresponds to a puzzle piece. The 'Points' field 
            contains the boundary of a piece as a planar curve of m 
            points represented as an m-by-2 matrix, each row of which 
            specifies a point in R^2. The 'Signature' field contains 
            the corresponding Euclidean signature. The 'Arcs' field 
            contains the bivertex arcs of the boundary as well as the 
            corresponding arcs of the Euclidean signature. The 
            'Pt2Arc' field contains a vector whose jth entry is the 
            bivertex arc to which the jth point of the boundary curve 
            belong, where a 0 indicates that the point does not 
            belong to a bivertex arc.
            
'placements':     This output is a 1-by-n structure whose jth 
            column corresponds to the jth piece placed by the 
            algorithm. The 'Piece' field indicates the index of the 
            piece within the 'pieces' structure. The 'Score' field 
            contains a matrix [q q_tilde] where these are the scores 
            resulting from the piece locking that placed the jth 
            piece as described in Sect. 5.3 of [1]. The 'g_lock' field
            contains the rigid motion that takes the piece boundary 
            to its place in the solution, represented as a matrix 
            [theta a b] where these parameters are as described in 
            Sect. 3.3 of [2]. The 'Fit' field contains a structure 
            containing detailed information about the fit that was 
            refined by piece-locking to produce 'g_lock'. The field
            'Neighbors' contains the indices (within the 'pieces'
            structure) of the pieces adjacent to the jth piece in the
            solution.
            
'tracker':  This ouput is a 1-by-n structure whose jth column gives
            detailed information about the state of the puzzle 
            assembly after j pieces have been placed. The fields 
            'PPc', 'RPc', 'IArcs', 'AArcs', 'IPts', 'APts', and 
            'Pc2Place' indicate, respectively, the placed pieces, the
            remaining pieces, the inactive arcs, the active arcs, the 
            inactive points, the active points, and order in which 
            pieces have been placed.

'time':     This output gives the length of time required to solve 
            the puzzle in seconds. This does not include time spent 
            inputting parameters through the GUI.

%--------------------------------------------------------------------
%}



function [pieces placements tracker time] = Solve_Puzzle(puzzle, plotter, saver, parameters)


% Set default parameter values
if(~exist('parameters', 'var'))
    if(size(puzzle, 2) >= 100)
        parameters = {2, 5, 5, 1000, 2, 15, 4, 1/2, 20, 8, 3, 10^(-4), 1/3, 50, 1, 1.5, .976, .24, .3, .029, struct('p_0', {.94}, 'm_0', {2}, 'mu_0', {.6}, 'K_3', {.707})};
    else
        if(size(puzzle, 2) >= 69)
            parameters = {2, 5, 5, 1000, 2, 15, 4, 1/2, 20, 10, 3, 10^(-4), 1/3, 50, 1, 1.5, .9, .2, .3, 0, struct('p_0', {.94 .9}, 'm_0', {3 2}, 'mu_0', {.6 .6}, 'K_3', {1.118 2})};
        else
            parameters = {2, 5, 5, 1000, 2, 15, 4, 1/2, 30, 10, 3, 10^(-4), 1/3, 50, 1, 1.5, .9, .2, .3, 0, struct('p_0', {.94 .9}, 'm_0', {2 2}, 'mu_0', {.6 .6}, 'K_3', {.707 2})};
        end;
    end;
else
    if(size(parameters{16}, 2) > 7)
        % Reorder the pieces randomly
        %--------------------------------------------------------------------
        % Shuffle the random seed
        rng('shuffle');
        % Randomize
        puzzle = puzzle(1, randperm(size(puzzle, 2)));
        %--------------------------------------------------------------------
        
        %Start timer
        timer = tic;
        [pieces placements tracker] = Assemble(puzzle, plotter, saver, parameters);
        % Stop timer
        time = toc(timer);
        return;
    end;
end;
if(~exist('plotter', 'var'))
    plotter = 2;
end;
if(~exist('saver', 'var'))
    saver = 0;
end;

% Initialize handle
err_msg = [];     

% Employ GUI to gather parameters
hGUI = figure('Visible','off', 'Units', 'normalized', 'OuterPosition', [.025, .1, .2, .8]);
set(hGUI,'Name','Please Set Parameters');

% Get scale of figure to use for text size
set(hGUI, 'Units', 'points')
framesize = get(hGUI, 'Position');
textsize = .025*framesize(4);

% Return units to normalized
set(hGUI, 'Units', 'normalized');


% Create Buttons
hsolve = uicontrol('Style','pushbutton','String','Solve Puzzle', 'Units', 'normalized', 'Position',[.03, .95, .4, .04], 'FontSize', textsize,'Callback',{@solvebutton_Callback}); 
hreset = uicontrol('Style','pushbutton','String','Reset Parameters','Units', 'normalized', 'Position',[.5, .95, .47, .04], 'FontSize', textsize,'Callback',{@resetbutton_Callback});

% Create 'Fixed Parameters' label
uicontrol('Style','text','String', 'Fixed Parameters' , 'Units', 'normalized', 'Position', [0, .9, 1, .04], 'FontSize', textsize);


% Create editable fields for collecting fixed parameters
%--------------------------------------------------------------------
halpha = uicontrol('Style','edit','String', parameters{1} ,  'Units', 'normalized', 'Position', [.2, .85, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .85, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\alpha$:', 'Position', [-.5, .5], 'FontSize', textsize);

hbeta = uicontrol('Style','edit','String', parameters{2} ,  'Units', 'normalized', 'Position', [.2, .8, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .8, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\beta$:', 'Position', [-.5, .5], 'FontSize', textsize);

hgamma = uicontrol('Style','edit','String', parameters{3} ,  'Units', 'normalized', 'Position', [.2, .75, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .75, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\gamma$:', 'Position', [-.5, .5], 'FontSize', textsize);

hC_1 = uicontrol('Style','edit','String', parameters{4} ,  'Units', 'normalized', 'Position', [.2, .7, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .7, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$C_1$:', 'Position', [-.5, .5], 'FontSize', textsize);

hC_2 = uicontrol('Style','edit','String', parameters{5} ,  'Units', 'normalized', 'Position', [.2, .65, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .65, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$C_2$:', 'Position', [-.5, .5], 'FontSize', textsize);

hK_1 = uicontrol('Style','edit','String', parameters{6} ,  'Units', 'normalized', 'Position', [.2, .6, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .6, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$K_1$:', 'Position', [-.5, .5], 'FontSize', textsize);

hK_2 = uicontrol('Style','edit','String', parameters{7} ,  'Units', 'normalized', 'Position', [.2, .55, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .55, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$K_2$:', 'Position', [-.5, .5], 'FontSize', textsize);

hK_4 = uicontrol('Style','edit','String', parameters{8} ,  'Units', 'normalized', 'Position', [.2, .5, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .5, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$K_4$:', 'Position', [-.5, .5], 'FontSize', textsize);

hlambda_0 = uicontrol('Style','edit','String', parameters{9} ,  'Units', 'normalized', 'Position', [.2, .45, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .45, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$\lambda_0$:', 'Position', [-.5, .5], 'FontSize', textsize);

hlambda_1 = uicontrol('Style','edit','String', parameters{10} ,  'Units', 'normalized', 'Position', [.2, .4, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.2, .4, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\lambda_1$:', 'Position', [-.5, .5], 'FontSize', textsize);

hnu = uicontrol('Style','edit','String', parameters{11} ,  'Units', 'normalized', 'Position', [.65, .85, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .85, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\nu$:', 'Position', [-.5, .5], 'FontSize', textsize);

hepsilon = uicontrol('Style','edit','String', parameters{12} ,  'Units', 'normalized', 'Position', [.65, .8, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .8, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\epsilon$:', 'Position', [-.5, .5], 'FontSize', textsize);

hrho = uicontrol('Style','edit','String', parameters{13} ,  'Units', 'normalized', 'Position', [.65, .75, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .75, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$\rho$:', 'Position', [-.5, .5], 'FontSize', textsize);

hj_max = uicontrol('Style','edit','String', parameters{14} ,  'Units', 'normalized', 'Position', [.65, .7, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .7, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex','String', '$j_\mathrm{max}$:', 'Position', [-.5, .5], 'FontSize', textsize);

heta_1 = uicontrol('Style','edit','String', parameters{15} ,  'Units', 'normalized', 'Position', [.65, .65, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .65, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$\eta_1$:', 'Position', [-.5, .5], 'FontSize', textsize);

heta_2 = uicontrol('Style','edit','String', parameters{16} ,  'Units', 'normalized', 'Position', [.65, .6, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .6, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$\eta_2$:', 'Position', [-.5, .5], 'FontSize', textsize);

hQ_1 = uicontrol('Style','edit','String', parameters{17} ,  'Units', 'normalized', 'Position', [.65, .55, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .55, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$Q_1$:', 'Position', [-.5, .5], 'FontSize', textsize);

hQ_2 = uicontrol('Style','edit','String', parameters{18} ,  'Units', 'normalized', 'Position', [.65, .5, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .5, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$Q_2$:', 'Position', [-.5, .5], 'FontSize', textsize);

hQ_2_star = uicontrol('Style','edit','String', parameters{19} ,  'Units', 'normalized', 'Position', [.65, .45, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .45, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$Q_2^{\star}$:', 'Position', [-.5, .5], 'FontSize', textsize);

hQ_3 = uicontrol('Style','edit','String', parameters{20} ,  'Units', 'normalized', 'Position', [.65, .4, .25, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
axes('Units', 'normalized' , 'Position', [.65, .4, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$Q_3$:', 'Position', [-.5, .5], 'FontSize', textsize);
%--------------------------------------------------------------------

% Create 'Parameter Sequence' label
uicontrol('Style','text','String', 'Parameter Sequence' , 'Units', 'normalized', 'Position', [0, .35, 1, .04], 'FontSize', textsize);

% Create editable fields to collect parameter sequence
%--------------------------------------------------------------------
hj_star = uicontrol('Style','edit','String', size(parameters{21}, 2) ,  'Units', 'normalized', 'Position', [.2, .3, .25, .04], 'FontSize', textsize, 'Callback',{@j_star_Callback});
axes('Units', 'normalized' , 'Position', [.2, .3, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$j_{\star}$:', 'Position', [-.5, .5], 'FontSize', textsize);
axes('Units', 'normalized' , 'Position', [.2, .25, .25, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$j$', 'Position', [-.5, .2], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
axes('Units', 'normalized' , 'Position', [.2, .25, .15, .04], 'Visible', 'off');
text('Interpreter', 'latex', 'String', '$(\;p_{0, j}$', 'Position', [0, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$,$', 'Position', [1, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$\;\;m_{0, j}$', 'Position', [1.33333, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$,$', 'Position', [2.3333, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$\;\;\mu_{0, j}$', 'Position', [2.6666, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$,$', 'Position', [3.6666, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
text('Interpreter', 'latex', 'String', '$\;\;K_{3, j} )$', 'Position', [4, .1], 'FontSize', textsize, 'VerticalAlignment', 'bottom');
axes('Units', 'normalized' , 'Position', [.05, .23, .9, .04], 'Visible', 'off');
line([0, 1], [0, 0], 'Color', 'k');
h_seq = [];
j_star_Callback(hj_star);
for c1 = 1:size(parameters{21}, 2)
    set(h_seq(c1, 1), 'String', parameters{21}(c1).p_0)
    set(h_seq(c1, 2), 'String', parameters{21}(c1).m_0)
    set(h_seq(c1, 3), 'String', parameters{21}(c1).mu_0)
    set(h_seq(c1, 4), 'String', parameters{21}(c1).K_3)
end;
%--------------------------------------------------------------------


% Make the GUI visible.
set(hGUI,'Visible','on');

% Pause execution until puzzle is solved
uiwait(hGUI);

%--------------------------------------------------------------------
%--------------------------------------------------------------------
% GUI Callbacks
%--------------------------------------------------------------------
%--------------------------------------------------------------------
function j_star_Callback(source, ~)
    j_star = str2num(get(source, 'String'));
    if(j_star > 7)
        j_star = 7;
        set(source, 'String', 7);
        msg = 1;     
    else 
        msg = 0;
    end;
    if(j_star < size(h_seq, 1))
        delete(h_seq(j_star+1:end, :));
        h_seq(j_star+1:end, :) = [];
    else
        if(j_star > size(h_seq, 1))
            for c1 = size(h_seq, 1)+1:j_star
                figure(hGUI);
                h_seq(c1, 1) = uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', [.2, .25-.05*c1, .15, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
                h_seq(c1, 2) = uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', [.4, .25-.05*c1, .15, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
                h_seq(c1, 3) = uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', [.6, .25-.05*c1, .15, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
                h_seq(c1, 4) = uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', [.8, .25-.05*c1, .15, .04], 'FontSize', textsize,'Callback',{@fields_Callback});
                h_seq(c1, 5) = axes('Units', 'normalized', 'Position', [.2, .25-.05*c1, .25, .04], 'Visible', 'off');
                text('Interpreter', 'latex', 'String', num2str(c1), 'Position', [-.5, .5], 'FontSize', textsize);
            end;
        end;
    end;
    if(msg)
        msgbox('Parameter sequences with more than 7 elements must be inputted from the command line.')
    end;
end

%--------------------------------------------------------------------

function fields_Callback(~, ~)
    parameter_sequence = struct('p_0', [], 'm_0', [], 'mu_0', [], 'K_3', []);
    for c3 = 1:str2double(get(hj_star, 'String'))
        parameter_sequence(c3).p_0 = str2double(get(h_seq(c3, 1), 'String'));
        parameter_sequence(c3).m_0 = str2double(get(h_seq(c3, 2), 'String'));
        parameter_sequence(c3).mu_0 = str2double(get(h_seq(c3, 3), 'String'));
        parameter_sequence(c3).K_3 = str2double(get(h_seq(c3, 4), 'String'));
    end;
    nparameters = {str2double(get(halpha, 'String')), str2double(get(hbeta, 'String')), str2double(get(hgamma, 'String')),...
        str2double(get(hC_1, 'String')), str2double(get(hC_2, 'String')), str2double(get(hK_1, 'String')), str2double(get(hK_2, 'String')),...
        str2double(get(hK_4, 'String')), str2double(get(hlambda_0, 'String')), str2double(get(hlambda_1, 'String')),...
        str2double(get(hnu, 'String')), str2double(get(hepsilon, 'String')), str2double(get(hrho, 'String')),...
        str2double(get(hj_max, 'String')), str2double(get(heta_1, 'String')), str2double(get(heta_2, 'String')),...
        str2double(get(hQ_1, 'String')), str2double(get(hQ_2, 'String')), str2double(get(hQ_2_star, 'String')),...
        str2double(get(hQ_3, 'String')), parameter_sequence};
    errors = check_parameters(nparameters, 0);
    if(~isempty(errors))
        if(ishandle(err_msg))
            delete(err_msg);
        end;
        err_msg = msgbox(errors);
    end;
end

%--------------------------------------------------------------------

function solvebutton_Callback(~, ~)
 
    % Extract and check parameters
    parameter_sequence = struct('p_0', [], 'm_0', [], 'mu_0', [], 'K_3', []);
    for c3 = 1:str2double(get(hj_star, 'String'))
        parameter_sequence(c3).p_0 = str2double(get(h_seq(c3, 1), 'String'));
        parameter_sequence(c3).m_0 = str2double(get(h_seq(c3, 2), 'String'));
        parameter_sequence(c3).mu_0 = str2double(get(h_seq(c3, 3), 'String'));
        parameter_sequence(c3).K_3 = str2double(get(h_seq(c3, 4), 'String'));
    end;
    nparameters = {str2double(get(halpha, 'String')), str2double(get(hbeta, 'String')), str2double(get(hgamma, 'String')),...
        str2double(get(hC_1, 'String')), str2double(get(hC_2, 'String')), str2double(get(hK_1, 'String')), str2double(get(hK_2, 'String')),...
        str2double(get(hK_4, 'String')), str2double(get(hlambda_0, 'String')), str2double(get(hlambda_1, 'String')),...
        str2double(get(hnu, 'String')), str2double(get(hepsilon, 'String')), str2double(get(hrho, 'String')),...
        str2double(get(hj_max, 'String')), str2double(get(heta_1, 'String')), str2double(get(heta_2, 'String')),...
        str2double(get(hQ_1, 'String')), str2double(get(hQ_2, 'String')), str2double(get(hQ_2_star, 'String')),...
        str2double(get(hQ_3, 'String')), parameter_sequence};
    errors = check_parameters(nparameters, 1);
    if(isempty(errors))
        % Disable controls
        for c3 = 1:str2double(get(hj_star, 'String'))
            set(h_seq(c3, 1), 'Enable', 'off');
            set(h_seq(c3, 2), 'Enable', 'off');
            set(h_seq(c3, 3), 'Enable', 'off');
            set(h_seq(c3, 4), 'Enable', 'off');
        end;
        set(halpha, 'Enable', 'off');
        set(hbeta, 'Enable', 'off');
        set(hgamma, 'Enable', 'off');
        set(hC_1, 'Enable', 'off');
        set(hC_2, 'Enable', 'off');
        set(hK_1, 'Enable', 'off');
        set(hK_2, 'Enable', 'off');
        set(hK_4, 'Enable', 'off');
        set(hlambda_0, 'Enable', 'off');
        set(hlambda_1, 'Enable', 'off');
        set(hnu, 'Enable', 'off');
        set(hepsilon, 'Enable', 'off');
        set(hrho, 'Enable', 'off');
        set(hj_max, 'Enable', 'off');
        set(heta_1, 'Enable', 'off');
        set(heta_2, 'Enable', 'off');
        set(hQ_1, 'Enable', 'off');
        set(hQ_2, 'Enable', 'off');
        set(hQ_2_star, 'Enable', 'off');
        set(hQ_3, 'Enable', 'off');
        set(hj_star, 'Enable', 'off');
        set(hsolve, 'Enable', 'off');
        set(hreset, 'Enable', 'off');
        
        
        % Reorder the pieces randomly
        %--------------------------------------------------------------------
        % Shuffle the random seed
        rng('shuffle');
        % Randomize
        puzzle = puzzle(1, randperm(size(puzzle, 2)));
        %--------------------------------------------------------------------
        
        %Start timer
        timer = tic;
        [pieces placements tracker] = Assemble(puzzle, plotter, saver, nparameters);
        % Stop timer
        time = toc(timer);
        uiresume(hGUI);
    else
        if(ishandle(err_msg))
            delete(err_msg);
        end;
        err_msg = msgbox(errors);
    end;
end

%--------------------------------------------------------------------

function resetbutton_Callback(~, ~)
    set(halpha, 'String', parameters{1});
    set(hbeta, 'String', parameters{2});
    set(hgamma, 'String', parameters{3});
    set(hC_1, 'String', parameters{4});
    set(hC_2, 'String', parameters{5});
    set(hK_1, 'String', parameters{6});
    set(hK_2, 'String', parameters{7});
    set(hK_4, 'String', parameters{8});
    set(hlambda_0, 'String', parameters{9});
    set(hlambda_1, 'String', parameters{10});
    set(hnu, 'String', parameters{11});
    set(hepsilon, 'String', parameters{12});
    set(hrho, 'String', parameters{13});
    set(hj_max, 'String', parameters{14});
    set(heta_1, 'String', parameters{15});
    set(heta_2, 'String', parameters{16});
    set(hQ_1, 'String', parameters{17});
    set(hQ_2, 'String', parameters{18});
    set(hQ_2_star, 'String', parameters{19});
    set(hQ_3, 'String', parameters{20});
    set(hj_star, 'String', size(parameters{21}, 2));
    j_star_Callback(hj_star);
    for c2 = 1:size(parameters{21}, 2)
        set(h_seq(c2, 1), 'String', parameters{21}(c2).p_0)
        set(h_seq(c2, 2), 'String', parameters{21}(c2).m_0)
        set(h_seq(c2, 3), 'String', parameters{21}(c2).mu_0)
        set(h_seq(c2, 4), 'String', parameters{21}(c2).K_3)
    end;
end

end


%--------------------------------------------------------------------
%--------------------------------------------------------------------
%--------------------------------------------------------------------
% Auxiliary Function
%--------------------------------------------------------------------
%--------------------------------------------------------------------
%--------------------------------------------------------------------


function errors = check_parameters(parameters, strict)

% This function checks parameters to see if they are appropriate for 
% use as described in [1].
%{
%--------------------------------------------------------------------
INPUTS
%--------------------------------------------------------------------

'parameters':   This variable should be a cell array containing 
            parameters to be checked. See the default values of 
            'parameters' in Solve_Puzzle() (above) for the form this 
            input must take. 

'strict':   This bool should be 1 if empty values in the parameter
            sequence are not to be permitted, and 0 otherwise.

%--------------------------------------------------------------------


%--------------------------------------------------------------------
OUTPUTS
%--------------------------------------------------------------------

'pieces':   This output is a n-by-1 cell array each of whose rows is 
            a string containing a message indicating why a particular 
            parameter value is inappropriate for use as described in [1].

%--------------------------------------------------------------------
%}


% Initialize output
errors = {};
if(~(parameters{1} >= 0))
    errors = [errors ; {'alpha must be a nonnegative real number'} ;' '];
end;
if(~(parameters{2} >= 0))
    errors = [errors ; {'beta must be a nonnegative real number'} ;' '];
end;
if(~(parameters{3} >= 0))
    errors = [errors ; {'gamma must be a nonnegative real number'} ;' '];
end;
if(~(parameters{4} > 0))
    errors = [errors ; {'C_1 must be a positive real number'} ;' '];
end;
if(~(parameters{5} > 0))
    errors = [errors ; {'C_2 must be a positive real number'} ;' '];
end;
if(~(parameters{6} > 0))
    errors = [errors ; {'K_1 must be a positive real number'} ;' '];
end;
if(~(parameters{7} > 0))
    errors = [errors ; {'K_2 must be a positive real number'} ;' '];
end;
if(~(parameters{8} > 0))
    errors = [errors ; {'K_3 must be a positive real number'} ;' '];
end;
if(~(parameters{9} > 0))
    errors = [errors ; {'lambda_0 must be a positive real number'} ;' '];
end;
if(~(parameters{10} > 0))
    errors = [errors ; {'lambda_1 must be a positive real number'} ;' '];
end;
if(~(parameters{11} >= 0))
    errors = [errors ; {'nu must be a nonnegative real number'} ;' '];
end;
if(~(parameters{12} > 0))
    errors = [errors ; {'epsilon must be a positive real number'} ;' '];
end;
if(~(parameters{13} >= 0))
    errors = [errors ; {'rho must be a nonnegative real number'} ;' '];
end;
if(~(isa(parameters{14}, 'double') && round(parameters{14}) == parameters{14}  && parameters{14} > 0))
    errors = [errors ; {'j_max must be a positive integer'} ;' '];
end;
if(~(parameters{15} >= 0))
    errors = [errors ; {'eta_1 must be a nonnegative real number'} ;' '];
end;
if(~(parameters{16} >= 0))
    errors = [errors ; {'eta_2 must be a nonnegative real number'} ;' '];
end;
if(~(parameters{17} >= 0))
    errors = [errors ; {'Q_1 must be a nonnegative real number'} ;' '];
end;
if(~(parameters{18} >= 0))
    errors = [errors ; {'Q_2 must be a nonnegative real number'} ;' '];
end;
if(~(parameters{19} >= 0))
    errors = [errors ; {'Q_2^{star} must be a nonnegative real number'} ;' '];
end;
if(~(parameters{20} >= 0))
    errors = [errors ; {'Q_3 must be a nonnegative real number'} ;' '];
end;


parameter_seq = parameters{21};
for c1 = 1:size(parameter_seq, 2)
    if(~(parameter_seq(c1).p_0 >= 0 && parameter_seq(c1).p_0 <= 1) && (~isnan(parameter_seq(c1).p_0) || strict))
        errors = [errors ; {['p_(0,' num2str(c1) ') must belong to the interval [0, 1]']} ;' '];
        parameter_seq(c1).p_0
    end;
    if(~(isa(parameter_seq(c1).m_0, 'double') && round(parameter_seq(c1).m_0) == parameter_seq(c1).m_0  && parameter_seq(c1).m_0 > 0) && (~isnan(parameter_seq(c1).m_0) || strict))
        errors = [errors ; {['m_(0,' num2str(c1) ') must be a positive integer']} ;' '];
    end;
    if(~(parameter_seq(c1).mu_0 >= 0 && parameter_seq(c1).mu_0 <= 1) && (~isnan(parameter_seq(c1).mu_0) || strict))
        errors = [errors ; {['mu_(0,' num2str(c1) ') must belong to the interval [0, 1]']} ;' '];
    end;
    if(~(parameter_seq(c1).K_3 > 0) && (~isnan(parameter_seq(c1).K_3) || strict))
        errors = [errors ; {['K_(3,' num2str(c1) ') must be a positive real number']} ;' '];
    end;
end;


end





