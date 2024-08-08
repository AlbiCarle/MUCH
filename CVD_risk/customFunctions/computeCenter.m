function [baricentroSVDD] = ...
    computeCenter(X, y,class,method)
% compute the center of gravity of a certain class, considering only points inside a certain class or inside the corresponding SVDD region
% X: set of points
% y: corresponding real class or predicted points
% class: class of interest
% method: 'centerOfGravity' , 'mvksdensity'
%select points of the class of interest

X_class = X(y==class,:);
y=  y(y==class,:);

switch(method)
    case 'centerOfGravity'
        w=ones(size(X_class)); % set all weights to 1-> center of mass= mean
        c=zeros(1,size(X_class,2));
        numerator=0;
        for j=1:(size(X_class,2)) % for each column
            
            for i=1:size(X_class,1) % for each row
                numerator=numerator+(w(i,j)*X_class(i,j));
            end
            denominatore= sum(w(:,j)); % sum of the columns' weights
            c(j)=numerator/denominator;
            numerator=0;
        end
        baricentroSVDD=c;

    case 'mvksdensity'
        %f = mvksdensity(x,pts,'Bandwidth',bw) computes a probability density estimate of the sample data in the n-by-d matrix x, evaluated at the points in pts using the required name-value pair argument value bw for the bandwidth value. The estimation is based on a product Gaussian kernel function.
        %Create a array of points at which to estimate the density. 
        grid_coord = 0.1:0.4:0.9;  %0.15
       
        [x1,x2,x3,x4,x5,x6,x7,x8,x9,x10] = ndgrid(grid_coord,grid_coord,grid_coord,grid_coord,grid_coord,grid_coord,grid_coord,grid_coord,grid_coord,grid_coord);
        % ndgrid(grid_coord,grid_coord,grid_coord,grid_coord)
           
        x1 = x1(:,:)';
        x2 = x2(:,:)';
        x3 = x3(:,:)';
        x4 = x4(:,:)';
        x5 = x5(:,:)';
        x6 = x6(:,:)';
        x7 = x7(:,:)';
        x8 = x8(:,:)';
        x9 = x9(:,:)';
        x10 = x10(:,:)';
         
        xi = [x1(:) x2(:) x3(:) x4(:) x5(:) x6(:) x7(:) x8(:) x9(:) x10(:)];
        f = mvksdensity(X_class,xi,'bandwidth',1); 
    otherwise
        
end
