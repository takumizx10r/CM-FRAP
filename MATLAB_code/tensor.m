clear
close all



[inputimage, ABSPATH_TENSOR]=uigetfile(strcat(pwd,'\.tif'));

tiff_info = imfinfo(inputimage);
[im_filepath, im_filename, im_extension]=fileparts(inputimage);
imageindex=im_filename;
resolution=tiff_info(1).XResolution; %um
maxTotalFrame=size(tiff_info,1);
addpath (ABSPATH_TENSOR);


prompt = {'Interval (s):','Num of waiting frames:','Right after bleach frame:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'15','2', '3'};
answer = inputdlg(prompt,dlgtitle,dims,definput);
interval=str2num(answer{1}); %sec
Pre_frame=str2num(answer{2});
RAB_Frame=str2num(answer{3});

rangeofkeepf=4;

pixelsize=1/resolution;
TotalFrame=maxTotalFrame-RAB_Frame+1;


imagelist=dir(strcat(ABSPATH_TENSOR,'\tensor-coordinates\',imageindex,'*'));

mkdir(strcat(ABSPATH_TENSOR,'\MATLAB-Results-Tensor'));

for j=1:length(imagelist)
    filenum=imagelist(j,1).name;
    list=dir(strcat(ABSPATH_TENSOR,'\tensor-coordinates\',filenum,'\*.txt'));

    filename_rec = strcat(ABSPATH_TENSOR,'\Recovery\',filenum,'.txt');
    FRAPData	= dlmread(filename_rec,'\t',1,0);
    I=FRAPData(:,3);
    filename_pre = strcat(ABSPATH_TENSOR,'\Prebleach\',filenum,'.txt');
    Pre	= dlmread(filename_pre,'\t',1,0);


    SizeOfMatrix=min(length(list),TotalFrame);
    % Define Matrix
    Def_vec=zeros(SizeOfMatrix-1,2);                                    %%%displacement vector
    GreenStrainTensor=zeros(2,2,SizeOfMatrix-1);
    AlmansiStrainTensor=zeros(2,2,SizeOfMatrix-1);
    StrainTensor=zeros(2,2,SizeOfMatrix-1);
    SpinTensor=zeros(2,2,SizeOfMatrix-1);
    PrincipalInvariant_Strain=zeros(SizeOfMatrix-1,2);
    PrincipalInvariant_StrainRate=zeros(SizeOfMatrix-1,2);
    ArrowArg=zeros(SizeOfMatrix-1,1);
    ArrowNorm=zeros(SizeOfMatrix-1,1);
    SpinComponent=zeros(SizeOfMatrix-1,1);

    for i=1:SizeOfMatrix-1
        input=strcat(ABSPATH_TENSOR,'\tensor-coordinates\',filenum,'\',list(1,1).name);
        DT=interval*i;
        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        firstkeep=  [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize;%%um

        input=strcat(ABSPATH_TENSOR,'\tensor-coordinates\',filenum,'\',list(i+1,1).name);
        Data=dlmread(input,'\t',1,0);
        tData=Data.';
        secondkeep= [tData(1,:) tData(2,:) tData(3,:) tData(4,:)].*pixelsize; %%um

        % % %     Calculate Tensor
        [ U,E,e,Strain,StrainRate, SpinRate]=function_calculate_tensor_ver3(firstkeep, secondkeep, DT);
        % % %
        % % %     Calculate EigenValues
        [Vs,Ds]=eig(Strain);
        a1=Ds(1,1);
        a2=Ds(2,2);
        PrincipalInvariant_Strain(i,1:2)=[a1+a2, a1*a2];

        [Vr,Dr]=eig(StrainRate);
        a1=Dr(1,1);
        a2=Dr(2,2);
        PrincipalInvariant_StrainRate(i,1:2)=[a1+a2, a1*a2];
        % % %
        % %     output parameters
        Def_vec(i,1:2)=U;
        GreenStrainTensor(1:2,1:2,i)=E;
        AlmansiStrainTensor(1:2,1:2,i)=e;
        StrainTensor(1:2,1:2,i)=Strain;
        ArrowArg(i,1)=atan2(Def_vec(i,2),Def_vec(i,1));
        ArrowNorm(i,1)=norm(U);
        SpinTensor(1:2,1:2,i)=SpinRate;
        SpinComponent(i,1)=SpinRate(1,2);
        % % %



    end
    % % %          Strain Rate

    TimeForPlot=[1:SizeOfMatrix-1];
    TimeForPlot=TimeForPlot*interval;
    fun = @(x,xdata)x(1)*xdata;
    x0=1;

    Keepf=find(PrincipalInvariant_Strain(:,1) ~= 0);
    x = lsqcurvefit(fun,x0,TimeForPlot(Keepf).',PrincipalInvariant_Strain(Keepf,1));
    StrainRate_FitLinear=x;

    % % %          Volume Strain Rate
    KeepStrainRate=PrincipalInvariant_Strain(:,1)./(TimeForPlot(1,:).' );
    Keepf=find(KeepStrainRate ~= 0);
    AveStrainRate=mean(KeepStrainRate(round(Keepf/2):length(Keepf)));

    % % %            Deformation
    KeepDef=ArrowNorm;
    Keepf=find(KeepDef ~= 0);
    x = lsqcurvefit(fun,x0,TimeForPlot(Keepf).',ArrowNorm(Keepf));
    DispRate_FitLinear=x;

    % % %             Floe Rate
    KeepFlow=ArrowNorm./(TimeForPlot(1,:).' );
    Keepf=find(KeepFlow ~= 0);
    AveFlow=mean(KeepFlow(round(Keepf/2):Keepf));



    % % %              Save Matfile
    savefile=strcat(ABSPATH_TENSOR,'\MATLAB-Results-Tensor');
    savematfile=strcat(savefile,'\',filenum);
    save(savematfile)

    % % % % % %  FRAP analysis
    PB_intensity=mean(Pre(:,3));
    RAB_intensity=I(1);
    % % % % % Normalize and find time constant
    keepF=(I-RAB_intensity)./(PB_intensity-RAB_intensity);
    % keepF=(I)./(PB_intensity);
    findframe=find(isnan(keepF)==0);
    time=(FRAPData(findframe,1)-FRAPData(1:1)) * interval;
    F=keepF(findframe);
    [FitPara]=func_fit_FRAPCurve(time,F);
    % [FitPara]=func_fit_FRAPCurve_NormalizebyRAB(time,F);
    % FitPara
    MF=FitPara(1);
    k=FitPara(2);


    % % %
    Min= min(find(TimeForPlot>(1/k)));
    if rangeofkeepf>=Min
        rangeofkeepf=Min-1;
    end
    clear keepf
    keepf=[Min-rangeofkeepf:Min+rangeofkeepf];
    if max(keepf)>length(PrincipalInvariant_Strain)
        keepf = [Min-rangeofkeepf:Min];
    end
    AverageStrain=mean(PrincipalInvariant_Strain(keepf,:));
    AverageSpin=mean(SpinComponent(keepf,:));

    % % %
    save(savematfile);
    close all
    j/length(imagelist)*100
end

messagedialog
function messagedialog
    d = dialog('Position',[300 300 250 150],'Name','Complete!');

    txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[20 80 210 40],...
               'String','Variables were saved in "MATLAB-Results-Tensor".');

    btn = uicontrol('Parent',d,...
               'Position',[85 20 70 25],...
               'String','Close',...
               'Callback','delete(gcf)');
end