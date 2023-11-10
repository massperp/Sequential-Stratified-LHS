function [] = plot_stratification(numDim, stratum, f)

% Surface plots of the test function and final stratifications for 2D and 3D problems

% INPUTS
% numDim: number of dimensions
% stratum: stratification with stratum object containing geometry, samples,
% etc.
% f: handle to test function

numStrata = size(stratum,2);
figure('Position',[100,100,240,220]);
if numDim == 2
    N_plot = 50;
    f_surf = zeros(N_plot);
    yy=linspace(0,1,N_plot);
    for i=1:N_plot
        for j=1:N_plot
            f_surf(i,j) = f([yy(i) yy(j)]);
        end
    end
    surf(yy,yy,f_surf);
    shading interp
    grid off;
    alpha(0.6)
    view(0,90)
    hold on;
    for n=1:numStrata
        a = stratum{n}.a;
        b = stratum{n}.b;
        line([a(1) a(1)],[a(2) b(2)],'color','k','LineWidth',2);
        line([b(1) b(1)],[a(2) b(2)],'color','k','LineWidth',2);
        
        line([a(1) b(1)],[a(2) a(2)],'color','k','LineWidth',2);
        line([a(1) b(1)],[b(2) b(2)],'color','k','LineWidth',2);
    end
    set(gca,'FontSize',14);
end
if numDim == 3
    N_plot = 41;
    yy=linspace(0,1,N_plot);
    f_surf = zeros(N_plot,N_plot,N_plot);
    
    [y1,y2,y3] = meshgrid(yy,yy,yy);
    for i=1:N_plot^numDim
        f_surf(i) = f([y1(i),y2(i),y3(i)]);
    end
    
    zslice = 0.5;
    xslice = 0.5;
    yslice = 0.5;
    figure('Position',[100,100,240,220]);
    slice(y1,y2,y3,f_surf,xslice,yslice,zslice);
    %pbaspect([3 1 1])
    grid off;
    colormap jet
    shading interp
    colorbar
    
    hold on;
    for n=1:numStrata
        a = stratum{n}.a;
        b = stratum{n}.b;
        line([a(1) a(1)],[a(2) a(2)],[a(3) b(3)],'color','k','LineWidth',2);
        line([a(1) a(1)],[b(2) b(2)],[a(3) b(3)],'color','k','LineWidth',2);
        
        line([b(1) b(1)],[a(2) a(2)],[a(3) b(3)],'color','k','LineWidth',2);
        line([b(1) b(1)],[b(2) b(2)],[a(3) b(3)],'color','k','LineWidth',2);
        
        line([a(1) a(1)],[a(2) b(2)],[a(3) a(3)],'color','k','LineWidth',2);
        line([b(1) b(1)],[a(2) b(2)],[a(3) a(3)],'color','k','LineWidth',2);
        
        line([a(1) a(1)],[a(2) b(2)],[b(3) b(3)],'color','k','LineWidth',2);
        line([b(1) b(1)],[a(2) b(2)],[b(3) b(3)],'color','k','LineWidth',2);
        
        line([a(1) b(1)],[a(2) a(2)],[a(3) a(3)],'color','k','LineWidth',2);
        line([a(1) b(1)],[b(2) b(2)],[a(3) a(3)],'color','k','LineWidth',2);
        
        line([a(1) b(1)],[a(2) a(2)],[b(3) b(3)],'color','k','LineWidth',2);
        line([a(1) b(1)],[b(2) b(2)],[b(3) b(3)],'color','k','LineWidth',2);
        
    end
    alpha(0.6)
    view(60,20)
    set(gca,'FontSize',14);
end
