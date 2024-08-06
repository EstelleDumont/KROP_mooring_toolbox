function [DAT]=mv_wind(x,tile_size,method,option)
% Syntax
% [DAT] = mv_wind(x,tile_size,method,option)
%
% This program applies a (mean, sum, std, median, min, max or standard error of mean) 
% moving window to a 1D or 2D matrix, where "x" can have missing values indicated by 
% NaN's. The tile size (or foot print) can be as follows:
% For 1D matrix is 2,3,4,5 ... and a 2D matrix can be any dimension 2x1,1x2 2x2, 2x3, etc
%
% The particular moving window application is set by setting a "method" (see below)
%
% Input 
%
% x = matrix
% tile_size :  is the size of the window, e.g. if tile_size = 3
%              then of a 1D matrix the window is 3x1 or in a 2D
%              matrix the window 3x3, however the 2D any be any dimension
%              e.g., 3x1, 3x2, etc. The Syntax for example a 3x1 tilesize is written 
%              as [3 1] meaning 3 pixels in the vertical and 1 pixel in the horizonal 
%                
% method = 'mean'
%   "    = 'sum'
%   "    = 'std'
%   "    = 'median'
%   "    = 'min'
%   "    = 'max'
%   "    = 'se_mean' (standard error of mean) WARNING this assumes that all the pixels 
%                      are independentfrom one anonther- which most of the time is false.
%                      Thus, this SE of the mean will be underestimated 
%   "    = 'no_obs' (No of Obsevations within each window)
%   "    = 'gradient' (Multi Point Central Difference Operator)
%   "    = 'nan_gradient' - Multi Point Central Difference Operator, however
%                           if nan's are present within the tile window then
%                           the window is subsampled to calculate the gradient.
%
%  WARNING - gradient (or nan_gradient) tile window must be odd dimensions, i.e. 3x5, 5x3, 3x3,3x7, etc.      
%
% option =  'none'     : if you don't use the option command the applied matrix will not be padded or fix at the egdes
%           'pad_edges': Pads the edges with nan's to the original size of the matrix
%           'fix_edges': Fixes edges with values to the original size of the matrix
%                         using a subset of the tile size
%          
% Output
% [DAT]
%
%
% Written by Andrew Shaw 20/7/2001


[m,n] = size(x);

tile_size = tile_size(:);

%if any(isnan(x(:)))==0

if size(tile_size,1) ==1; tile_size=tile_size.*ones(2,1); end
if  (strcmp(option, 'fix_edges') & strcmp(method, 'gradient')) | (strcmp(option, 'fix_edges') & strcmp(method, 'nan_gradient')) ;
    disp( '   ')
    disp( '   ')
    disp('ERROR  - nan_gradient or gradient can not do fixed edges')
    return
end
 
%if  strcmp(option, 'fix_edges');[x] = padding2(x,tile_size); end

if any(isnan(x(:)))==0
    
if strcmp(method, 'no_obs')
    disp( '   ')
     disp('            ERROR')
    disp('The "method" you used does not exist because you have no holes in your data')
   return
   end
%else
       
end

% To determine if the "x" is 1-D or 2-D
DIM = 0;
FLAG = 0;
if min([m;n])==1 
    
%
% One Dimensional Case
%
if max([m;n]) <= tile_size 
    disp(' ')
    disp('                 ERROR')
    disp( 'The size of the tile is too big for the matrix');
    return
end
    x = x(:);
    DIM =1;
    tile_size = tile_size(1,1);
    if  strcmp(option, 'fix_edges');[x] = padding2(x,tile_size); end
   [DAT,x_max,y_max]=mv_1D_fast(x,tile_size);
 
   if any(isnan(x(:)))==1
      [DAT]= applic_gap(DAT,y_max,x_max,method,tile_size,DIM);
  else
      [DAT]= applic(DAT,y_max,x_max,method,tile_size,DIM);
  end
   FLAG = 1;
else 
 %   
 % Two Dimensional Case
 %
 if m <= tile_size | n <=tile_size;
    disp(' ')
    disp('                 ERROR')
    disp( 'The size of the tile is too big for the matrix');
    return
end

No_calcs = (m-(tile_size(1,1)-1)).*(n-(tile_size(2,1)-1)).*(tile_size(1,1).*tile_size(2,1));
Threshold = 1000000;
%Threshold = 10;
if  strcmp(option, 'fix_edges');[x] = padding2(x,tile_size); end

        if No_calcs < Threshold
     
         [DAT,x_max,y_max]=mv_2D_fast(x,tile_size);
         
         % To improve speed of not looking for nan's
          if any(isnan(x(:)))==1
             [DAT]= applic_gap(DAT,y_max,x_max,method,tile_size,DIM);
         else
            [DAT]= applic(DAT,y_max,x_max,method,tile_size,DIM);
             
          end
     else
      %   disp('HELLO1')
         [DAT]=mv_2D_slow(x,tile_size,No_calcs,Threshold,method,DIM);
     end      
end

% Add padding in the form of nan's
if nargin>3
    if  strcmp(option, 'pad_edges')
      if strcmp(method, 'gradient') | strcmp(method, 'nan_gradient')
         [DAT.Abs_Grad] = padding1(x,DAT.Abs_Grad,tile_size);
        if length(DAT.X_grad(:))~=1; [DAT.X_grad] = padding1(x,DAT.X_grad,tile_size);end
        if length(DAT.Y_grad(:))~=1; [DAT.Y_grad] = padding1(x,DAT.Y_grad,tile_size);end
         [DAT.Grad_theta] = padding1(x,DAT.Grad_theta,tile_size);
      else
         [DAT] = padding1(x,DAT,tile_size);
      end
  end
end 
 %
% End of MAIN PROGRAM
%
% *********************************************************************
% *********************************************************************
% *********************************************************************
function [DAT] = padding1(x,DAT,tile_size)
        if length(tile_size(:))==1;tile_size = [tile_size;1];end
       [dat_row,dat_col] = size(x);
        window  = fix(tile_size./2);
        G_sum =  (fix(tile_size(1,1)./2)).*2;
        [DAT_y,DAT_x] = size(DAT);  

        Starting_point=  (window(2,1).*dat_row)+ window(1,1);
 
        if mod(tile_size(1,1),2)==0; G_sum =G_sum -1;end
        
         G_sum = [0:G_sum:(DAT_x-1).*G_sum];
         G_sum = repmat(G_sum,DAT_y,1);
         G_sum = G_sum(:);
           if isempty(G_sum)==1;G_sum=0;end 
         
         DAT1 = DAT(:);
    
         p = [1:length(DAT1)]'+Starting_point;
         p = p +G_sum;
      
         DAT = ones(dat_row.*dat_col,1).*nan;
         DAT(p,1) = DAT1;
         DAT = reshape(DAT,dat_row,dat_col);
        
% *********************************************************************
       
function [x] = padding2(x,tile_size);
        if length(tile_size(:))==1;tile_size = [tile_size;1];end
        [dat_row,dat_col] = size(x);
        window  = fix(tile_size./2);
        G_sum =  (fix(tile_size(1,1)./2)).*2;
        Starting_point=  (window(2,1).*(dat_row+tile_size(1,1)-1))+ window(1,1);
        if mod(tile_size(1,1),2)==0; G_sum =G_sum -1;end
        
         G_sum = [0:G_sum:(dat_col-1).*G_sum];
         G_sum = repmat(G_sum,dat_row,1);
         G_sum = G_sum(:);
         
           if isempty(G_sum)==1;G_sum=0;end 
         
         x1 = x(:);  
         p = [1:length(x1)]'+Starting_point;
         p = p +G_sum;
         x = ones((dat_row+tile_size(1,1)-1).*(dat_col+tile_size(2,1)-1),1).*nan;
         x(p,1) = x1;
         x = reshape(x,(dat_row+tile_size(1,1)-1),(dat_col+tile_size(2,1)-1));

 % *********************************************************************
 
function [DAT,x_max,y_max] = mv_1D_fast(x,tile_size)

  x= x(:);
 [dat_row,dat_col] = size(x);
  window	    = fix(tile_size./2);
  y_min      	    = 1;
  y_max      	    = dat_row-(window*2);
  x_max             = 1;  

if mod(tile_size,2)==0;y_max=y_max+1;end

Y1=[1:tile_size]';

PP1 = repmat(Y1(:),y_max,1);
A = [0:y_max-1];
B = repmat(A,tile_size,1);
B = B(:);
IND = PP1+B;
DAT = zeros(size(IND,1),1);
DAT = x(IND,1);
DAT = reshape(DAT,tile_size(1,1),length(DAT)./(tile_size(1,1)));

% *********************************************************************

function [DAT,x_max,y_max]=mv_2D_fast(x,tile_size)
  [dat_row,dat_col] = size(x);
  window	    = fix(tile_size./2);
  x_min		    = 1; 
  x_max      	    = dat_col-(window(2,1)*2);
  y_min      	    = 1;
  y_max      	    = dat_row-(window(1,1)*2);
  OBS = tile_size(1,1).*tile_size(2,1);
  
  if mod(tile_size(1,1),2)==0;
     y_max=y_max+1;
    end
  
 if mod(tile_size(2,1),2)==0;
    x_max=x_max+1;
  end
  
Y1=[1:tile_size(2,1)]';
X1= [1:tile_size(1,1)]';
[X1,Y1] = meshgrid(X1,Y1);
p1	= (((Y1.*dat_row)-dat_row+1)+(X1-1))';
PP1 = repmat(p1(:),y_max,1);
A = [0:y_max-1];
B = repmat(A,tile_size(2,1),1);
B = B(:);
B = repmat(B,1,tile_size(1,1))';
B = B(:);
C = PP1+B;
D = repmat(C,x_max,1);
E = [0:dat_row:dat_row.*(x_max-1)];
E = repmat(E,length(C),1);
E = E(:);
IND = D+E;
DAT = zeros(size(IND,1),1);
x = x(:);
DAT = x(IND,1);

DAT = reshape(DAT,OBS,length(DAT)./(OBS));

% *********************************************************************
function [DAT]=mv_2D_slow(x,tile_size,No_calcs,Threshold,method,DIM)
  %No_calcs

  [dat_row,dat_col] = size(x);
  window	    = fix(tile_size./2);
  x_min		    = 1; 
  x_max      	    = dat_col-(window(2,1)*2);
  y_min      	    = 1;
  y_max      	    = dat_row-(window(1,1)*2);
  OBS = tile_size(1,1).*tile_size(2,1);


  % Spliting up the data set
  No_mat_split= fix(No_calcs./Threshold);
     
    
   INT=  fix(dat_col./No_mat_split);
    if INT< tile_size(2,1);
        INT = tile_size(2,1);
        No_mat_split = fix(dat_col./INT);
    end; 

   Sub_Total = INT.* No_mat_split;
   ENDING = dat_col-Sub_Total;
   X1 =  [1:INT:dat_col-ENDING]';
   X2 = X1;
   X2(1:end-1,1) = X1(2:end,1)+tile_size(2,1)-2;
   X2(end,1) = dat_col;
 
    % Function "loop1 & loop2" were written to reduce an
    % if statment being part of a loop 
    
      if any(isnan(x(:)))==1
          [DAT]=loop1(x,X1,X2,tile_size,method,DIM);
      else
          [DAT]=loop2(x,X1,X2,tile_size,method,DIM);
      end    

      

function [DAT]=loop1(x,X1,X2,tile_size,method,DIM)

 DAT     = [];
 DAT2    = [];
 DATg    = [];
 X_grad2 = [];
 Y_grad2 = [];
 Grad_theta2 = [];

    for K = 1:length(X1)
        xx = x(:,X1(K,1):X2(K,1));
        [DAT1,x_max,y_max]=mv_2D_fast(xx,tile_size);
        [DAT1]= applic_gap(DAT1,y_max,x_max,method,tile_size,DIM);
         if strcmp(method, 'gradient') | strcmp(method, 'nan_gradient')
            DAT2        = DAT1.Abs_Grad; 
            X_grad1     = DAT1.X_grad;
            Y_grad1     = DAT1.Y_grad;
            Grad_theta1 = DAT1.Grad_theta;
            DATg        = [DATg DAT2];
              if isempty(X_grad1)==0;
                  X_grad2 = [X_grad2 X_grad1];
              else
                  X_grad2 = 0;
              end
              if isempty(Y_grad1)==0;
                  Y_grad2  = [Y_grad2 Y_grad1];
              else 
                  Y_grad2 = 0;
              end

            Grad_theta2 = [Grad_theta2 Grad_theta1];
            DAT.Abs_Grad = DATg;
            DAT.X_grad  = X_grad2;
            DAT.Y_grad = Y_grad2;
            DAT.Grad_theta = Grad_theta2;
            DAT2        = [];
            X_grad      = [];
            Y_grad      = [];
            Grad_theta1 = [];
        else
             DAT = [DAT DAT1];
            DAT1 = [];
        end
       
     end    
% *********************************************************************

function [DAT]=loop2(x,X1,X2,tile_size,method,DIM)
    DAT     = [];
    DAT2    = [];
    DATg    = [];
    X_grad2 = [];
    Y_grad2 = [];
    Grad_theta2 = [];
    
       for K = 1:length(X1)
   
        xx = x(:,X1(K,1):X2(K,1));
        [DAT1,x_max,y_max]=mv_2D_fast(xx,tile_size);
        [DAT1]= applic(DAT1,y_max,x_max,method,tile_size,DIM);
        
        if strcmp(method, 'gradient') | strcmp(method, 'nan_gradient')
            
            DAT2        = DAT1.Abs_Grad; 
            X_grad1     = DAT1.X_grad;
            Y_grad1     = DAT1.Y_grad;
            Grad_theta1 = DAT1.Grad_theta;
            DATg        = [DATg DAT2];

              if isempty(X_grad1)==0;
                  X_grad2 = [X_grad2 X_grad1];
              else
                  X_grad2 = 0;
              end
              if isempty(Y_grad1)==0;
                  Y_grad2  = [Y_grad2 Y_grad1];
              else 
                  Y_grad2 = 0;
              end
            Grad_theta2 = [Grad_theta2 Grad_theta1];
            DAT.Abs_Grad = DATg;
          
            DAT.X_grad  = X_grad2;
            DAT.Y_grad = Y_grad2;
            DAT.Grad_theta = Grad_theta2;
            DAT2        = [];
            X_grad      = [];
            Y_grad      = [];
            Grad_theta1 = [];
       else
           DAT = [DAT DAT1];
           DAT1 = [];
        end     
             
     end    

     
% *********************************************************************
function [DAT]= applic_gap(DAT,y_max,x_max,method,tile_size,DIM)
FLAG = 0;
if  strcmp(method, 'mean')
   DAT =meangap(DAT);
   % nopt = 1;
elseif strcmp(method, 'sum')
    DAT =sumgap(DAT);
elseif strcmp(method, 'std')
    DAT =stdgap(DAT);
elseif strcmp(method, 'median')
     DAT =nanmedian(DAT);
elseif strcmp(method, 'min')
     DAT =nanmin(DAT);
elseif strcmp(method, 'max')
     DAT =nanmax(DAT);
elseif strcmp(method, 'se_mean')
     DAT =se_meangap(DAT);
elseif strcmp(method, 'no_obs')
  DAT = num_obs_gap(DAT);
elseif strcmp(method, 'gradient')
    FLAG=1;  
    spacing = 1;
 
  if DIM==0
   
        [DAT,X_grad,Y_grad,Grad_theta]=gradient1(DAT,tile_size,spacing);
        DAT_1   = reshape(DAT,y_max,x_max);
        if length(X_grad(:))~=1;X_grad  = reshape(X_grad,y_max,x_max);end
        if length(Y_grad(:))~=1;Y_grad  = reshape(Y_grad,y_max,x_max);end
        Grad_theta = reshape(Grad_theta,y_max,x_max);
        DAT.Abs_Grad = DAT_1;
        DAT.X_grad = X_grad;
        DAT.Y_grad = Y_grad;
        DAT.Grad_theta = Grad_theta;
else
   [DAT]=gradient3(DAT,tile_size,spacing);
    
 end   
elseif strcmp(method, 'nan_gradient')
    FLAG=1;
    spacing = 1;
    [DAT,X_grad,Y_grad,Grad_theta]=gradient2(DAT,tile_size,spacing);
    DAT_1   = reshape(DAT,y_max,x_max);
    if length(X_grad(:))~=1;X_grad  = reshape(X_grad,y_max,x_max);end
    if length(Y_grad(:))~=1;Y_grad  = reshape(Y_grad,y_max,x_max);end
    Grad_theta = reshape(Grad_theta,y_max,x_max);
    DAT.Abs_Grad = DAT_1;
    DAT.X_grad = X_grad;
    DAT.Y_grad = Y_grad;
    DAT.Grad_theta = Grad_theta;
end  

    if FLAG==0;DAT = reshape(DAT,y_max,x_max);end
        
% *********************************************************************
function [DAT]= applic(DAT,y_max,x_max,method,tile_size,DIM)
FLAG = 0;
if  strcmp(method, 'mean')
    DAT =mean(DAT);
elseif strcmp(method, 'sum')
    DAT =sum(DAT);
elseif strcmp(method, 'std')
    DAT =std(DAT);
elseif strcmp(method, 'median')
     DAT =median(DAT);
elseif strcmp(method, 'min')
     DAT =min(DAT);
elseif strcmp(method, 'max')
     DAT =max(DAT);
elseif strcmp(method, 'gradient')

    FLAG =1;
    spacing = 1;
    
    if DIM==0
        
       [DAT,X_grad,Y_grad,Grad_theta]=gradient1(DAT,tile_size,spacing);
         DAT_1   = reshape(DAT,y_max,x_max);
        if length(X_grad(:))~=1;X_grad  = reshape(X_grad,y_max,x_max);end
        if length(Y_grad(:))~=1;Y_grad  = reshape(Y_grad,y_max,x_max);end
        Grad_theta = reshape(Grad_theta,y_max,x_max);
        DAT.Abs_Grad = DAT_1;
        DAT.X_grad = X_grad;
        DAT.Y_grad = Y_grad;
        DAT.Grad_theta = Grad_theta;
    else
   
     [DAT]=gradient3(DAT,tile_size,spacing);
     
    end
    
    
elseif strcmp(method, 'nan_gradient')

    FLAG=1;
    spacing = 1;
  
    if DIM==0
 
        if any(isnan(DAT(:)))==1
            [DAT,X_grad,Y_grad,Grad_theta]=gradient2(DAT,tile_size,spacing);
        else
            [DAT,X_grad,Y_grad,Grad_theta]=gradient1(DAT,tile_size,spacing);
        end
        DAT_1   = reshape(DAT,y_max,x_max);
        if length(X_grad(:))~=1;X_grad  = reshape(X_grad,y_max,x_max);end
        if length(Y_grad(:))~=1;Y_grad  = reshape(Y_grad,y_max,x_max);end
        Grad_theta = reshape(Grad_theta,y_max,x_max);
        DAT.Abs_Grad = DAT_1;
        DAT.X_grad = X_grad;
        DAT.Y_grad = Y_grad;
        DAT.Grad_theta = Grad_theta;
   
    else
        [DAT]=gradient3(DAT,tile_size,spacing);
    end
end % elseif's
  
 if FLAG==0;DAT = reshape(DAT,y_max,x_max);end
  

% *********************************************************************
% Sums with missing values
function [A]= sumgap(DATA)
GAPS = isnan(DATA);
P = find(GAPS);
DATA(P) = zeros(size(P));
A = sum(DATA);
P1= find(all(GAPS));
A(P1) = P1.*nan;
P1=[];P =[];GAPS = [];DATA =[];

% *********************************************************************
% Means with missing values
function [A]= meangap(DATA)
Mat_size = size(DATA);
S = sumgap(DATA);
GAPS = isnan(DATA);
DATA1 = sumgap(GAPS);
No_NON_zeros = size(DATA,1) -DATA1;
P1 = find(No_NON_zeros==0);
No_NON_zeros(P1) = P1.*nan;
A = S./No_NON_zeros;
P1=[];P =[];GAPS = [];DATA =[];No_NON_zeros = [];

% *********************************************************************
% Standard Deviation with missing values
function [A]= stdgap(DATA)
GAPS = isnan(DATA);
DATA = DATA - repmat(meangap(DATA),size(DATA,1),1);
DATA1 = sumgap(GAPS);
No_NON_zeros = size(DATA,1) -DATA1;
Zeros = find(No_NON_zeros==1);
No_NON_zeros(Zeros) = nan;
A  = sqrt((sumgap(DATA.^2))./(No_NON_zeros-1));
A(Zeros) = 0;

% *********************************************************************
% Standard Error of mean with missing values
function [A]= se_meangap(DATA)
[A1]= stdgap(DATA);
GAPS = isnan(DATA);
DATA1 = sumgap(GAPS);
No_NON_zeros = size(DATA,1) -DATA1;
Zeros = find(No_NON_zeros==0);
No_NON_zeros(Zeros) = 1;
A = A1./sqrt(No_NON_zeros);

% *********************************************************************
% Standard Error of mean with missing values
function [A]= se_mean(DATA)
[A1]= std(DATA);
GAPS = isnan(DATA);
DATA1 = sum(GAPS);
No_NON_zeros = size(DATA,1) -DATA1;
Zeros = find(No_NON_zeros==0);
No_NON_zeros(Zeros) = 1;
A = A1./sqrt(No_NON_zeros);

% *********************************************************************
function [A] = num_obs_gap(DATA)
GAPS = isnan(DATA);
DATA1 = sumgap(GAPS);
A = size(DATA,1) -DATA1;

% *********************************************************************
function [True_Grad,X_grad,Y_grad,Grad_theta]=gradient1(DAT,tile_size,spacing)

% This program calculates the gradient at the centre of the window
% using a Multi Point Central Difference Operator

if tile_size(1,1)~=1
[Scalar_Y,Y]  = pt_diff(tile_size(1,1));

    w_F			= repmat(Y',1,tile_size(2,1));
    w_F         = w_F(:);
    w_F         = repmat(w_F,1,size(DAT,2));
    F1			= w_F.*DAT;
    F_			= sum(F1);
    Y_grad		= (F_./tile_size(2,1))./(Scalar_Y.*spacing);
else
    Y_grad =0;
end

if tile_size(2,1)~=1

    [Scalar_X,X]  = pt_diff(tile_size(2,1));
    w_E			= repmat(X,tile_size(1,1),1);
    w_E         = w_E(:);
    w_E         = repmat(w_E,1,size(DAT,2));
    E1 			= w_E.* DAT;
    E_			= sum(E1);
    X_grad		= (E_./tile_size(1,1))./(Scalar_X.*spacing);
else
    X_grad =0;
end
True_Grad 	= abs(X_grad+i.*Y_grad);
Grad_theta	= atan2(Y_grad,X_grad);


% *********************************************************************
function [True_Grad,X_grad,Y_grad,Grad_theta]=gradient2(DAT,tile_size,spacing)

% This program calculates the gradient at the centre of the window
% using a Multi Point Central Difference Operator

if tile_size(1,1)~=1
% *******************************************
% This bit deal with the vertical component

[Scalar_Y,Y]  = pt_diff(tile_size(1,1));
w_F			= repmat(Y',1,tile_size(2,1));
w_F         = w_F(:);
w_F         = repmat(w_F,1,size(DAT,2));
F1          = w_F.*DAT; 

GAPS = isnan(F1);
P1 = find(GAPS(:)==1);
Ind1 = fix(P1./size(F1,1));
Ind1_ = mod(P1,size(F1,1));
Ind2 = find(Ind1_~=0);
No_COL=Ind1;
No_COL(Ind2) = Ind1(Ind2)+1; % Cols wrt first matrix
No_Row = mod(P1,size(F1,1));
Ind2 = find(No_Row==0);
No_Row(Ind2)= size(F1,1);
ROW1 = mod(No_Row,tile_size(1,1));
Ind2 = find(ROW1==0);
ROW1(Ind2)= tile_size(1,1);
COLS = fix(No_Row./tile_size(1,1))+1;
COLS(Ind2) = COLS(Ind2)-1;
No_COLS= repmat(COLS,1,tile_size(1,1)).';
No_COLS = No_COLS(:);
No_ROWS = repmat([1:tile_size(1,1)],1,size(COLS,1)).';
ROW1= ((No_COLS.*tile_size(1,1))-tile_size(1,1)+1)+(No_ROWS-1);
No_COL2= repmat(No_COL,1,tile_size(1,1)).';
No_COL2  =No_COL2(:);
p1	= ((No_COL2.*size(F1,1)-size(F1,1)+1)+(ROW1-1));
F1(p1) = nan;
T_S1 = tile_size(2,1) - (sum(isnan(F1))./tile_size(1,1));
p_2 = find(T_S1==0);
T_S1(p_2) = 1;
F_			= sumgap(F1);
Y_grad		= (F_./T_S1)./(Scalar_Y.*spacing);

else
     Y_grad = 0; ;
end

if tile_size(2,1)~=1
    
    %   *******************************************
    % This bit deal with the horizonal

 [Scalar_X,X]  = pt_diff(tile_size(2,1));
 w_E			= repmat(X,tile_size(1,1),1);
 w_E         = w_E(:);
 w_E         = repmat(w_E,1,size(DAT,2));
 E1		= w_E.* DAT;
GAPS = isnan(E1);
P1 = find(GAPS(:)==1);
Ind1 = fix(P1./size(E1,1));
Ind1_ = mod(P1,size(E1,1));
Ind2 = find(Ind1_~=0);
No_COL=Ind1;
No_COL(Ind2) = Ind1(Ind2)+1;
No_Row = mod(P1,size(E1,1));
Ind2 = find(No_Row==0);
No_Row(Ind2)= size(E1,1);
%[No_COL No_Row]
ROW1 = mod(No_Row,tile_size(1,1));
Ind2 = find(ROW1==0);
ROW1(Ind2)= tile_size(1,1);
ROWs = repmat(ROW1,1,tile_size(2,1))';
ROWs = ROWs(:);
COLS = repmat([1:tile_size(2,1)],1,size(No_COL,1))';
%[COLS ROWs]
%No_COL
No_COLS1= repmat(No_COL,1,tile_size(2,1))';
% No_COLS1 is position down the Column (i.e., row)
No_COLS1 = No_COLS1(:);
% i.e., [Col Rows]
%[COLS No_COLS1]
ROW1= ((COLS.*tile_size(1,1))-tile_size(1,1)+1)+(ROWs-1);
p1	= (((No_COLS1.*size(E1,1))-size(E1,1)+1)+(ROW1-1));
E1(p1) = nan;
T_S = tile_size(1,1) - (sum(isnan(E1))./tile_size(2,1));
p_2 = find(T_S==0);
T_S(p_2) = 1;
E_			= sumgap(E1);
X_grad		= (E_./T_S)./(Scalar_X.*spacing);
else
    
 X_grad = 0;   
end        
True_Grad 	= abs(X_grad+i.*Y_grad);
Grad_theta	= atan2(Y_grad,X_grad);


% *********************************************************************

function [Scalar,X]= pt_diff(No_pts)
%Multi Point Central Difference Operator
%odd_even=rem(No_pts,2);
centre_pts = fix(No_pts./2);
x	= [fliplr(-1:-1:-centre_pts) [1:1:centre_pts]]';
x	= (x*ones(1,(No_pts-1)))';
Power   =  (1:1:No_pts-1)';
Power	=  Power*ones(1,(No_pts-1));	
MATRIX	= x.^(Power);
RHS	= [1;zeros(No_pts-2,1) ];

% Gauss Elimination
X	= MATRIX\RHS;
MIN	= min(abs(X));
X	= X./MIN;
X1	= X(1:centre_pts,1);
X2	= X(centre_pts+1:No_pts-1,1);
X	= [X1;0;X2]';
Scalar  = 1./MIN;% N.B. 1./Scalar x (X)

% *********************************************************************
function [DAT]=gradient3(DAT,tile_size,spacing)

% This program calculates the gradient at the centre of the window
% using a Multi Point Central Difference Operator


[Scalar_Y,Y]  = pt_diff(tile_size(1,1));
    w_F         = Y(:);
    w_F         = repmat(w_F,1,size(DAT,2));
    F1			= w_F.*DAT;
    F_			= sum(F1);
    Y_grad		= (F_./(Scalar_Y.*spacing)).';
    X_grad =0;
   True_Grad 	= abs(X_grad+i.*Y_grad);
   Grad_theta	= atan2(Y_grad,X_grad);
   DAT.Abs_Grad= True_Grad;
   DAT.Y_grad   = Y_grad;
   DAT.X_grad   = X_grad;
   DAT.Grad_theta = Grad_theta;

 


     
     
