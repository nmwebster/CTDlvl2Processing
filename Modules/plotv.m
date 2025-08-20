function plotv
	
	global D HRD DD HRDD wx l1 l2

    subplot(1,3,1); cla; hold on
	subplot(3,1,2); cla; hold on
	subplot(3,1,3); cla; hold on

% COLUMNS OF DATA MATRIX D =  1=CS, 2=PR, 3=T1, 4=S1, 5=Sigt1, 6=FLAG  

    %keyboard

    wx2 = find(HRD(:,1) == D(wx(1),1));
    wx3 = find(HRDD(:,1) == DD(wx(1),1));
	intrpd = find(D(wx,6));	
	where = find(D(wx,2) <= l2 & D(wx,2) >= l1);
    
		subplot(1,3,1); 
                plot(HRD(wx2,3), HRD(wx2,2),'k-','linewidth',2); hold on
                plot(HRDD(wx3,3), HRDD(wx3,2),'k-','linewidth',2); hold on
				plot(D(wx,3)+.005, D(wx,2),'b-','linewidth',2); hold on
				plot(D(wx,3)-.005, D(wx,2),'b-','linewidth',2)
				plot(D(wx,3), D(wx,2),'r*-','markersize',5,'linewidth',2)
				plot(D(wx(intrpd),3), D(wx(intrpd),2),'b*','markersize',5,'linewidth',2)
				ylabel('Pressure (db)','fontname','times','fontweight','bold')
				title('Temperature','fontname','times','fontweight','bold')
				set(gca,'box','on','ydir','reverse')
				set(gca,'ylim',[l1 l2],'fontname','times','fontweight','bold')
				set(gca,'xlim',[min(D(wx(where),3))-.005 max(D(wx(where),3))+.005]) 
		subplot(1,3,2); 
                plot(HRD(wx2,4), HRD(wx2,2),'k-','linewidth',2); hold on
                plot(HRDD(wx3,4), HRDD(wx3,2),'k-','linewidth',2); hold on
				plot(D(wx,4)+.005, D(wx,2),'b-','linewidth',2); hold on
				plot(D(wx,4)-.005, D(wx,2),'b-','linewidth',2)
				plot(D(wx,4), D(wx,2),'r*-','markersize',5,'linewidth',2)
				plot(D(wx(intrpd),4), D(wx(intrpd),2),'b*','markersize',5,'linewidth',2)
				title('Salinity','fontname','times','fontweight','bold')
				set(gca,'box','on','ydir','reverse')
				set(gca,'ylim',[l1 l2],'fontname','times','fontweight','bold')
				set(gca,'xlim',[min(D(wx(where),4))-.005 max(D(wx(where),4))+.005]) 
		subplot(1,3,3); 
                plot(HRD(wx2,5), HRD(wx2,2),'k-','linewidth',2); hold on
	            plot(HRDD(wx3,5), HRDD(wx3,2),'k-','linewidth',2); hold on
                plot(D(wx,5)+.005, D(wx,2),'b-','linewidth',2); hold on
				plot(D(wx,5)-.005, D(wx,2),'b-','linewidth',2)
		 		plot(D(wx,5), D(wx,2),'r*-','markersize',5,'linewidth',2)
		 		plot(D(wx(intrpd),5), D(wx(intrpd),2),'b*','markersize',5,'linewidth',2)
				title('In-Situ Density','fontname','times','fontweight','bold')
				set(gca,'box','on','ydir','reverse')
				set(gca,'ylim',[l1 l2],'fontname','times','fontweight','bold')
				set(gca,'xlim',[min(D(wx(where),5))-.005 max(D(wx(where),5))+.005]) 