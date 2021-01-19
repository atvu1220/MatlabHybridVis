function [component] = calculateDistComponents(ParticleInCellVel,ParticleInCellPos,dir,outputSteps,timeSteps,t,outputDirectory)
t=20*t;%500 steps

[qx,qy,qz,nt,nx,ny,nz,va] = read_Coordinates(outputDirectory);
[X,Z,X2,Z2] = scale_Data(qx,qz);
nt=	floor(timeSteps/25)
if dir == "x"
    ParticleInCellVel(:,:,1);
elseif dir == "y"
    ParticleInCellVel(:,:,2);
elseif dir == "z"
    ParticleInCellVel(:,:,3);
elseif dir == "B"
    [Bdata] = read_Plasma('B',t,nx,ny,nz,outputDirectory);
    display('B loaded')
    [Bxdata_interp] = (interpolate_Data(Bdata,1,t,nx,nz,X,Z,X2,Z2));
    [Bydata_interp] = (interpolate_Data(Bdata,2,t,nx,nz,X,Z,X2,Z2));
    [Bzdata_interp] = (interpolate_Data(Bdata,3,t,nx,nz,X,Z,X2,Z2));
    component = [];
    for j=1:length(ParticleInCellPos(:,1))
        partPos = fliplr(floor(ParticleInCellPos(j,:)./(qx(2)-qx(1))));
        [vpara,~] = calculate_components(Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2)),...
            ParticleInCellVel(j,1),ParticleInCellVel(j,2),ParticleInCellVel(j,3));
        component = [component;vpara];
    end
elseif dir == "perp"
    [Bdata] = read_Plasma('B',t,nx,ny,nz,outputDirectory);
    display('B loaded')
    [Bxdata_interp] = (interpolate_Data(Bdata,1,t,nx,nz,X,Z,X2,Z2));
    [Bydata_interp] = (interpolate_Data(Bdata,2,t,nx,nz,X,Z,X2,Z2));
    [Bzdata_interp] = (interpolate_Data(Bdata,3,t,nx,nz,X,Z,X2,Z2));
    component = [];
    for j=1:length(ParticleInCellPos(:,1))
        partPos = fliplr(floor(ParticleInCellPos(j,:)./(qx(2)-qx(1))));
        [~,vperp] = calculate_components(Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2)),...
            ParticleInCellVel(j,1),ParticleInCellVel(j,2),ParticleInCellVel(j,3));
        component = [component;vperp];
    end
elseif dir == "ExB"
    [up_cold_data] = read_Plasma('up_cold',nt,nx,ny,nz,outputDirectory);
    display('u cold loaded')
    [Bdata] = read_Plasma('B',t,nx,ny,nz,outputDirectory);
    display('B loaded')
    
    [Bxdata_interp] = (interpolate_Data(Bdata,1,t,nx,nz,X,Z,X2,Z2));
    [Bydata_interp] = (interpolate_Data(Bdata,2,t,nx,nz,X,Z,X2,Z2));
    [Bzdata_interp] = (interpolate_Data(Bdata,3,t,nx,nz,X,Z,X2,Z2));
    
    [upx_cold_data_interp] = (interpolate_Data(up_cold_data,1,t,nx,nz,X,Z,X2,Z2));
    [upy_cold_data_interp] = (interpolate_Data(up_cold_data,2,t,nx,nz,X,Z,X2,Z2));
    [upz_cold_data_interp] = (interpolate_Data(up_cold_data,3,t,nx,nz,X,Z,X2,Z2));
    component = [];
    for j=1:length(ParticleInCellPos(:,1))
        partPos = fliplr(floor(ParticleInCellPos(j,:)./(qx(2)-qx(1))));
        
        E = - cross([upx_cold_data_interp(partPos(1),partPos(2)),upy_cold_data_interp(partPos(1),partPos(2)),upz_cold_data_interp(partPos(1),partPos(2))],[Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))]);
        ExB= cross(E,[Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))])./norm([Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))]).^2;
        ExB = ExB./norm(ExB);
        [vpara,~] = calculate_components(ExB(1),ExB(2),ExB(3),...
            ParticleInCellVel(j,1),ParticleInCellVel(j,2),ParticleInCellVel(j,3));
        component = [component;vpara];
        
        
    end
    

    
    
elseif dir == "ExBperp"
    [up_cold_data] = read_Plasma('up_cold',nt,nx,ny,nz,outputDirectory);
    display('u cold loaded')
    [Bdata] = read_Plasma('B',t,nx,ny,nz,outputDirectory);
    display('B loaded')
    
    [Bxdata_interp] = (interpolate_Data(Bdata,1,t,nx,nz,X,Z,X2,Z2));
    [Bydata_interp] = (interpolate_Data(Bdata,2,t,nx,nz,X,Z,X2,Z2));
    [Bzdata_interp] = (interpolate_Data(Bdata,3,t,nx,nz,X,Z,X2,Z2));
    
    [upx_cold_data_interp] = (interpolate_Data(up_cold_data,1,t,nx,nz,X,Z,X2,Z2));
    [upy_cold_data_interp] = (interpolate_Data(up_cold_data,2,t,nx,nz,X,Z,X2,Z2));
    [upz_cold_data_interp] = (interpolate_Data(up_cold_data,3,t,nx,nz,X,Z,X2,Z2));
    component = [];
    for j=1:length(ParticleInCellPos(:,1))
        partPos = fliplr(floor(ParticleInCellPos(j,:)./(qx(2)-qx(1))));
        
        E = - cross([upx_cold_data_interp(partPos(1),partPos(2)),upy_cold_data_interp(partPos(1),partPos(2)),upz_cold_data_interp(partPos(1),partPos(2))],[Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))]);
        ExB= cross(E,[Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))])./norm([Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))]).^2;
        ExBperp = cross([Bxdata_interp(partPos(1),partPos(2)),Bydata_interp(partPos(1),partPos(2)),Bzdata_interp(partPos(1),partPos(2))],ExB);
        ExBperp = ExBperp./norm(ExBperp);
        [vpara,~] = calculate_components(ExBperp(1),ExBperp(2),ExBperp(3),...
        ParticleInCellVel(j,1),ParticleInCellVel(j,2),ParticleInCellVel(j,3));
        component = [component;vpara];
    end
    
end

end
