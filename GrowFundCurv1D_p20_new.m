%% Things to add:
% give an approximate and find with newton the true %% easiest
% ask for all periodic points of certain period %% a tiny bit harder

%% Adding the path
    clear all
    close all
    addpath('./GrowFundCurv1D_functions');

%% Options

% %--- Define coordinates of the periodic orbit in original coordinates
% orientation-preserving
seed = ...
    [1.766275936449080   1.471492499501780  -4.414373687361070
   1.471492499501780   1.504827042975290  -3.825755925331500
   1.504827042975290   1.494047820879720  -3.086080067422520
   1.494047820879720   1.516372996031980  -2.209248260027300
   1.516372996031980   1.452398590641080  -1.134724916000780
   1.452398590641080   1.635626435094200   0.090728691440146
   1.635626435094200   1.089006587628720   1.744500864822370
   1.089006587628720   2.523376721572990   3.182407625415570
   2.523376721572990  -2.494132055265080   6.342265872071670
  -2.494132055265080  -2.777707725572690   5.116586991220930
  -2.777707725572690  -2.767420592126710   3.362196663892420
  -2.767420592126710  -2.625304416055140   1.267215404544200
  -2.625304416055140  -1.861997099320610  -1.104645930602110
  -1.861997099320610   1.520558126938170  -3.187572216043140
   1.520558126938170   2.446502112398480  -2.304528532313600
   2.446502112398480  -2.241540024051680  -0.318932126377843
  -2.241540024051680  -1.558452313145130  -2.624258575705090
  -1.558452313145130   2.443688394868090  -4.707562603991240
   2.443688394868090  -1.304077277269450  -3.205386729921390
  -1.304077277269450   1.766275936449080  -5.150541353175120];

    %--- Information of the system
    opts.thesystem=StdHenon3D_periodic; % What is the name of the system file
    opts.par=struct('a', 4.2,'b', 0.3, 'xi', 1.2); % The parameter values and names (has to match with the names defined in StdHenon3D)
    PO = solve_periodic_orbit(seed, opts);  %find periodic orbit using the seed

    opts.user_arclength = 10; % What is the approximate arclength of the manifold
    opts.per_orbit.name ='p20';
    opts.per_orbit.coord = struct('x',PO(:,1)','y',PO(:,2)','z',PO(:,3)');
    opts.stability='Smanifold';

    %--- Number of iterations used to compute the manifold
    opts.max_funditer=100; % how many times (max) the algorithm iterates the fundamental domain

    %--- Accuracy parameters (default)
    %opts.accpar.alphamax=0.3;
    %opts.accpar.deltalphamax=0.001; 
    %opts.accpar.deltamin=0.000001;
    %opts.accpar.deltamax=0.01;  

    %--- Initial step (default)
    %opts.accpar.init_step=10^-7; % pos value is positive branch and viceversa

%% Computing the manifold: Ws(pmin) orientation-preserving
     opts.branch = 'pos'; %which branch: 'pos', 'neg' or '' to consider sign of initial step.
     manif=GrowFundCurv1D_periodic(opts);

%% Computing intersection points
    angle=pi/2; %the angle of the plane from [-pi, pi]. (angle=pi/2: x==0 (y>0), angle=0: y==0 (x>0))
    manif=inter_plane_periodic(manif,angle);
%% Plot
    manifplot_periodic(manif);

%% Epsilon pseudo orbit (orientation-preserving)
    
branch    = 'pos';
idxPO     = 1;

if numel(manif.inter.points{idxPO}.(branch).idx)>0

    idxpoint  = manif.inter.points{idxPO}.(branch).idx(end);
    orbit     = eps_pseudo_orbit_periodic(manif, idxPO, idxpoint, branch);
    
    % plot the epsilon orbit. Starting and end point are colored in solid red.
    hold on
    plot3(orbit.x([1,end]),orbit.y([1,end]),orbit.z([1,end]),'r.','MarkerSize',27) %epsilon orbit
    plot3(orbit.x,orbit.y,orbit.z,'ko--','LineWidth',1.2) %epsilon orbit
end