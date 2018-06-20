% Read json and plot fov
clc;
clear;
%%%%%%%%%%%%%%%%%%%%%%Read Json data
addpath('C:\Program Files\MATLAB\R2018a\toolbox\jsonlab-1.5');
modeldata=loadjson('model2.json');
sw=modeldata.camera_stitch_params.global.sensorwidth;
sh=modeldata.camera_stitch_params.global.sensorheight;
%px=modeldata.camera_stitch_params.global.pixel_size;
px=0.00162;
f=25;
%mcam=zeros(sw,sh)+1;
%f=modeldata.camera_stitch_params.global.focal_length;
for i=1:19
    Yaw(i)=modeldata.camera_stitch_params.microcameras{i}.Yaw;
    Pitch(i)=modeldata.camera_stitch_params.microcameras{i}.Pitch;
    Roll(i)=modeldata.camera_stitch_params.microcameras{i}.Roll;
    F(i)=modeldata.camera_stitch_params.microcameras{i}.F;
    %mcamdata(:,:,i)=imrotate(mcam,-Roll(i))+10;
end
%%%%%%%%Calculate Offset and Magnification
M=max(F)./F;
[k,index]=min(F);
offsetx=Yaw./px/180*pi*f.*M(i);
offsety=Pitch./px/180*pi*f.*M(i);
%%%%%%%%%%% Apply Offset 
for i=1:19
    array(1,:,i)=[offsety(i)-sh/2.*M(i),offsetx(i)-sw/2.*M(i)];
    array(2,:,i)=[offsety(i)+sh/2.*M(i),offsetx(i)-sw/2.*M(i)];
    array(3,:,i)=[offsety(i)+sh/2.*M(i),offsetx(i)+sw/2.*M(i)];
    array(4,:,i)=[offsety(i)-sh/2.*M(i),offsetx(i)+sw/2.*M(i)];
    array(5,:,i)=[offsety(i)-sh/2.*M(i),offsetx(i)-sw/2.*M(i)];
end
%%%%%%%%%Plot FOV
figure
hold on
for i=1:19
    plot(squeeze(array(:,2,i)),squeeze(array(:,1,i)))
end
axis([-15000,15000 -8000 10000])
hold off
%%%%%%%%%%% Calculate standard
figure
M1=max(F)./min(F);
shiftsh=offsety(index)/M1;shiftsw=offsetx(index)/M1;
plot(squeeze(array(:,2,index)),squeeze(array(:,1,index)))
for j=1:3
for i=1:6
    offsetx1=sw*0.8*(i-3.5);
    offsety1=sh*0.8*(j-2);
    array1(1,:,i,j)=[offsety1-sh/2+shiftsh,offsetx1-sw/2+shiftsw];
    array1(2,:,i,j)=[offsety1+sh/2+shiftsh,offsetx1-sw/2+shiftsw];
    array1(3,:,i,j)=[offsety1+sh/2+shiftsh,offsetx1+sw/2+shiftsw];
    array1(4,:,i,j)=[offsety1-sh/2+shiftsh,offsetx1+sw/2+shiftsw];
    array1(5,:,i,j)=[offsety1-sh/2+shiftsh,offsetx1-sw/2+shiftsw];
end
end
hold on
for j=1:3
for i=1:6
    plot(squeeze(array1(:,2,i,j)),squeeze(array1(:,1,i,j)))
end
end

axis([-15000,15000 -8000 10000])
hold off

%%%%Composite 
figure
plot(squeeze(array(:,2,index)),squeeze(array(:,1,index)))
hold on
for i=1:19
    plot(squeeze(array(:,2,i)),squeeze(array(:,1,i)),'LineWidth',3)
end
for j=1:3
for i=1:6
    plot(squeeze(array1(:,2,i,j)),squeeze(array1(:,1,i,j)),'--r')
end
end
axis([-15000,15000 -8000 10000])
hold off
