 % Detect ice - manual mode

e=load('2003_INRS_007_rdr_qc.mat');

surf_bin_no = length(e.bin_depth);
[nobin,xx]=size(e.E_all);
jj=nobin-surf_bin_no;
if jj>5
    jj=5;
end;

for j = (surf_bin_no - 1): (surf_bin_no + jj)
    bscat_avg (j)=mean(e.E_all(j,:));
end;

[k,l] = max(bscat_avg);
ice_bin = l+1
if ice_bin > nobin;
    ice_bin=nobin
end;

ind = find(e.mtime_all<=0);
e.mtime_all(ind) = NaN;
clear ind

% Plot horizontal velocity
first_bin=15; %ice_bin-3;
figure(1);
plot(e.mtime_all,e.u_all(first_bin,:),'k'); hold on;
plot(e.mtime_all,e.u_all(first_bin+1,:),'b');
plot(e.mtime_all,e.u_all(first_bin+2,:),'c');
plot(e.mtime_all,e.u_all(first_bin+3,:),'g');
plot(e.mtime_all,e.u_all(first_bin+4,:),'y');
plot(e.mtime_all,e.u_all(first_bin+5,:),'r');
plot(e.mtime_all,e.u_all(first_bin+6,:),'m');
plot(e.mtime_all,e.u_all(first_bin+7,:),'k');

% Plot variance - 1 day avg
nodays=floor(max(e.mtime_all)-min(e.mtime_all));
sample=floor(length(e.u_all)/nodays);
mm=0;
for m=1:nodays
    std_u12(m)=std(e.u_all(12,mm+1:(mm+sample-1)));
    avg_E12(m)=mean(e.E_all(12,mm+1:(mm+sample-1)));
    %std_vel12(m)=std(vel(12,mm+1:(mm+sample-1)));
    mm=mm+sample-1;
end;
mm=0;
for m=1:nodays
    std_u13(m)=std(e.u_all(13,mm+1:(mm+sample-1)));
    avg_E13(m)=mean(e.E_all(13,mm+1:(mm+sample-1)));
   % std_vel13(m)=std(vel(13,mm+1:(mm+sample-1)));
    mm=mm+sample-1;
end;
mm=0;
for m=1:nodays
    std_u14(m)=std(e.u_all(14,mm+1:(mm+sample-1)));
    avg_E14(m)=mean(e.E_all(14,mm+1:(mm+sample-1)));
    %std_vel14(m)=std(vel(14,mm+1:(mm+sample-1)));
    mm=mm+sample-1;
end;
mm=0;
for m=1:nodays
    std_u9(m)=std(e.u_all(9,mm+1:(mm+sample-1)));
    avg_E9(m)=mean(e.E_all(9,mm+1:(mm+sample-1)));
    %std_vel15(m)=std(vel(15,mm+1:(mm+sample-1)));
    mm=mm+sample-1;
end;
mm=0;
for m=1:nodays
    std_u16(m)=std(e.u_all(16,mm+1:(mm+sample-1)));
    %std_vel16(m)=std(vel(16,mm+1:(mm+sample-1)));
    mm=mm+sample-1;
end;

figure;
plot(std_u12,'k');
hold on
plot(std_u13,'b');
plot(std_u14,'g');


% Plot vertical velocity
first_bin=10;
figure(2);
plot(e.mtime_all,e.v_all(first_bin,:),'k'); hold on;
plot(e.mtime_all,e.v_all(first_bin+1,:),'b');
plot(e.mtime_all,e.v_all(first_bin+2,:),'c');
plot(e.mtime_all,e.v_all(first_bin+3,:),'g');
plot(e.mtime_all,e.v_all(first_bin+4,:),'y');
plot(e.mtime_all,e.v_all(first_bin+5,:),'r');
plot(e.mtime_all,e.v_all(first_bin+6,:),'m');

% Plot velocity
vel=sqrt((e.u_all.*e.u_all)+(e.v_all.*e.v_all));
figure
plot(e.mtime_all,vel(first_bin,:),'k'); hold on;
plot(e.mtime_all,vel(first_bin+1,:),'b');
plot(e.mtime_all,vel(first_bin+2,:),'c');
plot(e.mtime_all,vel(first_bin+3,:),'g');
plot(e.mtime_all,vel(first_bin+4,:),'y');
plot(e.mtime_all,vel(first_bin+5,:),'r');
plot(e.mtime_all,vel(first_bin+6,:),'m');

% Plot correlation
first_bin=10;
figure(4);
plot(e.mtime_all,e.E_all(first_bin,:),'k'); hold on;
plot(e.mtime_all,e.E_all(first_bin+1,:),'b');
plot(e.mtime_all,e.E_all(first_bin+2,:),'c');
plot(e.mtime_all,e.E_all(first_bin+3,:),'g');
plot(e.mtime_all,e.E_all(first_bin+4,:),'y');
plot(e.mtime_all,e.E_all(first_bin+5,:),'r');
plot(e.mtime_all,e.E_all(first_bin+6,:),'m');



