% script to input, read and calculate backscatter data from 300kHz ADCP
% Based on an Excel workbook written by Geraint Tarling
% Calculation follows the method described by Deines - RDI technical paper
% FRC July 2003

% Modified so that it uses previously extracted backscatter rather than
% extracting it again - speeds up the process quite a lot! (MIW May 2008)

function error=Sv_calc(path,in_filename,out_filename)

%% Variables that can vary for each instrument and therefore have to be
%% checked.

Kc=0.5025; % From RDI                                                       
C=-143.5; % From Deines, Table 1                                            
R0=0.98; % From Deines, Table 1 (Rayleigh Distance)
alpha=0.07; % Depends on the frequency, the depth, and the sea temperature.  %Obtained from TRANSECT - use 0.07 for Kongsfjord 

%% initialise variables

SS=[];
current=[];
voltage=[];
Tx=[];
E=[];

load(in_filename);

% Obtain ADCP set-up values

 B=config.blank;                                           
 L=config.xmit_pulse;
 Ldbm=10*(log10(L));                                                 
 D=config.cell_size;
 theta=config.beam_angle;                                       

    %% Remove deployment and recovery periods using limits defined previously in adcp_qc processing

ss=nearest(start,mtime_all);
ss=ss(1); %if several values are found it crashes the script

   while mtime_all(ss)<start

       ss=ss+1;

   end

ee=nearest(stop,mtime_all);

   while mtime_all(ee)>stop

       ee=ee-1;

   end
SS=[SS ssp(ss:ee)];
current=[current adc(1,ss:ee)];                                   
voltage=[voltage adc(2,ss:ee)];
Tx=[Tx temperature(ss:ee)]'; 

SSctd=SS;                                                                  

%%Details from RDI 31/Oct/2007
%%TC and TV are respectively analog currents and voltage which have been converted to digital hence in counts by the ADCP. 
%%These scale factors are respectively in amps/counts and volts/counts and they both depend on the system frequency as follow: 

%%freq        TC                TV 

%%300        0.011451        0.592157 

%%600        0.011451        0.380667 

%%1200        0.011451        0.253765 

current=current*0.011451;                                                  
voltage=voltage*0.592157;

power=current.*voltage;
p_factor=power/power(1);
Pdbw=p_factor*14; % value of Pdbw=14.0 from Deines, Table 1

% Echo intensity reference level

figure(1)
clf
plot(E(1,1:100))
hold on
xlabel('Ensemble number')
ylabel('Counts')
title('Echo Intensity for Bin #1')

figure(2)
subplot(3,1,1)
plot(Tx)
title('ADCP transducer temperature')
ylabel('Temp (^oC)')

subplot(3,1,2)
plot(SS)
title('ADCP calculated speed of sound')
ylabel('Speed of sound (m/sec)')

subplot(3,1,3)
plot(Pdbw)
title('Transducer power output')
ylabel('10Log(Power)')
xlabel('Ensemble Number')


%% Calculate mtime_local

%1 deg = 4 minutes
change=4*long_deg;
eval(['mtime_local=mtime+datenum(0,0,0,0,',num2str(change),',0);'])

%% Calculate slant range R

N=1:size(E,1); %number of bins                                            
SSfactor=(SSctd./SS);

for i=1:length(N)
    R(:,i)=((B+((L+D)/2)+((N(i)-1)*D)+(D/4))/(cos(deg2rad(theta))))*SSfactor; 
end

figure(3)
plot(R(1,:))
title('Slant Range to Bin')
xlabel('Bin Number')
ylabel('Range (m)')


error=0;
% Value should be smaller or equal to R (suggested by Deines)
d=(pi*R0)/4;
for i=1:length(N)
    if R(1,i)<d
        error=1;
        break
    end
end
        

%% Calculate 2-alpha-R
if error==0
    alpha_n=(2*alpha*D)/(cos(deg2rad(theta)));

    for i=1:length(N)
        sum_alpha_n(i)=alpha_n*i;
    end

    for i=1:length(N)
        two_alpha_r(i)=((2*alpha*B)/(cos(deg2rad(theta))))+sum_alpha_n(i);
    end

    
%% Calculate backscatter coefficient 'Sv'

    for i=1:length(N)
        Sv(i,:)= C + (10*(log10((Tx'+273.16).*(R(:,i)'.^2)))) - Ldbm - Pdbw + two_alpha_r(i) + (Kc*(E(i,:)-E_ref));
    end

 copyfile(in_filename,[out_filename '.mat']);
 eval(['save ', out_filename,'.mat power Sv mtime_local -append'])
end


%% Additional functions called.

function [output] = nearest(a,b)

output = find(abs(a-b) == min(abs(a-b)));
