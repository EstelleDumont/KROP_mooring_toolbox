function KROP_qc_rough(info_file)

% Despiking: first pass - rough level to remove major spikes
% ESDU, SAMS, 2019

% Note: currently there are sections of code for each intrument (clearer / 
% easier to write it that way), but in future versions this script could be 
% improved by merging the individual bits of code and make it applicable to
% all instrument types. 


close all
load(info_file)

% Load mooring data
mat_fl = [d_mat '\' mooring_id '_CTD.mat'];
load(mat_fl)

% Prepare plot
scrsz = get(0,'ScreenSize');


%% Despike SBE16p
if exist('sbe16p_num','var')
    if sbe16p_num >0
        
        % Loop through each instrument
        for j = 1:sbe16p_num
            
            % Get instrument structure name and variables
            inst = ['SBE16p_' sbe16p_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            cond=DATA_IN.cond;
            sal=DATA_IN.sal;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev from mean)
            thr = 2;    % T & C threshold
            thr_s = 0.5; % Salinity threshold
            
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                [ind_c,p2]=KROP_flag_bad_data(mooring_id,inst,nd,cond,'cond',mtime,blk,thr,2);
                ylabel('Cond (mS/cm)');
                [ind_s,p3]=KROP_flag_bad_data(mooring_id,inst,nd,sal,'sal',mtime,blk,thr_s,3);
                ylabel('Salin (psu)');
                linkaxes([p1 p2 p3],'x');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    DATA_OUT.cond(ind_c)=NaN; DATA_OUT.cond(ind_s)=NaN;
                    DATA_OUT.sal(ind_s)=NaN; DATA_OUT.sal(ind_t)=NaN; DATA_OUT.sal(ind_c)=NaN;
                    DATA_OUT.sigmatheta(ind_s)=NaN; DATA_OUT.sigmatheta(ind_t)=NaN; DATA_OUT.sigmatheta(ind_c)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance_t=thr;
                    DATA_OUT.despiking_rough_tolerance_c=thr;
                    DATA_OUT.despiking_rough_tolerance_s=thr_s;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?               ','s');
                    thr_str=input('New tolerance (number of std dev) for T & C?  ','s');
                    thr_s_str=input('New tolerance (number of std dev) for S?      ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    thr_s=str2num(thr_s_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Despike SBE19p
if exist('sbe19p_num','var')
    if sbe19p_num >0
        
        % Loop through each instrument
        for j = 1:sbe19p_num
            
            % Get instrument structure name and variables
            inst = ['SBE19p_' sbe19p_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            cond=DATA_IN.cond;
            sal=DATA_IN.sal;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev)
            thr = 2;    % T & C threshold
            thr_s = 0.5; % Salinity threshold
            
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                [ind_c,p2]=KROP_flag_bad_data(mooring_id,inst,nd,cond,'cond',mtime,blk,thr,2);
                ylabel('Cond (mS/cm)');
                [ind_s,p3]=KROP_flag_bad_data(mooring_id,inst,nd,sal,'sal',mtime,blk,thr_s,3);
                ylabel('Salin (psu)');
                linkaxes([p1 p2 p3],'x');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    DATA_OUT.cond(ind_c)=NaN; DATA_OUT.cond(ind_s)=NaN;
                    DATA_OUT.sal(ind_s)=NaN; DATA_OUT.sal(ind_t)=NaN; DATA_OUT.sal(ind_c)=NaN;
                    DATA_OUT.sigmatheta(ind_s)=NaN; DATA_OUT.sigmatheta(ind_t)=NaN; DATA_OUT.sigmatheta(ind_c)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance_t=thr;
                    DATA_OUT.despiking_rough_tolerance_c=thr;
                    DATA_OUT.despiking_rough_tolerance_s=thr_s;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?               ','s');
                    thr_str=input('New tolerance (number of std dev) for T & C?  ','s');
                    thr_s_str=input('New tolerance (number of std dev) for S?      ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    thr_s=str2num(thr_s_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Despike Hydrocat
if exist('hcat_num','var')
    if hcat_num >0
        
        % Loop through each instrument
        for j = 1:hcat_num
            
            % Get instrument structure name and variables
            inst = ['HCAT_' hcat_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            cond=DATA_IN.cond;
            sal=DATA_IN.sal;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev)
            thr = 2;    % T & C threshold
            thr_s = 0.5; % Salinity threshold
            
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                [ind_c,p2]=KROP_flag_bad_data(mooring_id,inst,nd,cond,'cond',mtime,blk,thr,2);
                ylabel('Cond (mS/cm)');
                [ind_s,p3]=KROP_flag_bad_data(mooring_id,inst,nd,sal,'sal',mtime,blk,thr_s,3);
                ylabel('Salin (psu)');
                linkaxes([p1 p2 p3],'x');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    DATA_OUT.cond(ind_c)=NaN; DATA_OUT.cond(ind_s)=NaN;
                    DATA_OUT.sal(ind_s)=NaN; DATA_OUT.sal(ind_t)=NaN; DATA_OUT.sal(ind_c)=NaN;
                    DATA_OUT.sigmatheta(ind_s)=NaN; DATA_OUT.sigmatheta(ind_t)=NaN; DATA_OUT.sigmatheta(ind_c)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance_t=thr;
                    DATA_OUT.despiking_rough_tolerance_c=thr;
                    DATA_OUT.despiking_rough_tolerance_s=thr_s;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?               ','s');
                    thr_str=input('New tolerance (number of std dev) for T & C?  ','s');
                    thr_s_str=input('New tolerance (number of std dev) for S?      ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    thr_s=str2num(thr_s_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Despike SBE37
if exist('sbe37_num','var')
    if sbe37_num >0
        
        % Loop through each instrument
        for j = 1:sbe37_num
            
            % Get instrument structure name and variables
            inst = ['SBE37_' sbe37_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            cond=DATA_IN.cond;
            sal=DATA_IN.sal;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev)
            thr = 2;     % T & C
            thr_s = 0.5; % sal
            
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                [ind_c,p2]=KROP_flag_bad_data(mooring_id,inst,nd,cond,'cond',mtime,blk,thr,2);
                ylabel('Cond (mS/cm)');
                [ind_s,p3]=KROP_flag_bad_data(mooring_id,inst,nd,sal,'sal',mtime,blk,thr_s,3);
                ylabel('Salin (psu)');
                linkaxes([p1 p2 p3],'x');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    DATA_OUT.cond(ind_c)=NaN; DATA_OUT.cond(ind_s)=NaN;
                    DATA_OUT.sal(ind_s)=NaN; DATA_OUT.sal(ind_t)=NaN; DATA_OUT.sal(ind_c)=NaN;
                    DATA_OUT.sigmatheta(ind_s)=NaN; DATA_OUT.sigmatheta(ind_t)=NaN; DATA_OUT.sigmatheta(ind_c)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance_t=thr;
                    DATA_OUT.despiking_rough_tolerance_c=thr;
                    DATA_OUT.despiking_rough_tolerance_s=thr_s;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?               ','s');
                    thr_str=input('New tolerance (number of std dev) for T & C?  ','s');
                    thr_s_str=input('New tolerance (number of std dev) for S?      ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    thr_s=str2num(thr_s_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Despike SBE56
if exist('sbe56_num','var')
    if sbe56_num >0
        
        % Loop through each instrument
        for j = 1:sbe56_num
            
            % Get instrument structure name and variables
            inst = ['SBE56_' sbe56_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev)
            thr = 2;
            
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance_t=thr;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?               ','s');
                    thr_str=input('New tolerance (number of std dev)?            ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Despike Minilogs
if exist('ml_num','var')
    if ml_num >0
        
        % Loop through each instrument
        for j = 1:ml_num
            
            % Get instrument structure name and variables
            inst = ['ML_' ml_sn{j}];
            eval(['DATA_IN=RAW3.' inst ';'])
            mtime=DATA_IN.mtime;
            temp=DATA_IN.temp;
            nd = DATA_IN.nominal_depth(1);
            
            % Get number of samples over 4 hours to set as averaging block in
            % despiking function
            blk = round(4/((mtime(2)-mtime(1))*24));
            % Needs to be an even number, if not round up
            if mod(blk,2)==1
                blk=blk+1;
            end
            
            % Set threshold / tolerance for spike detection (number of std dev)
            thr = 2;
           
            dspk = 0;
            
            % Set up loop to test different despiking parameters until user is
            % happy with result
            while dspk == 0
                
                % Despike data
                fig=figure('Position',[1 1 scrsz(3) scrsz(4)]);
                [ind_t,p1]=KROP_flag_bad_data(mooring_id,inst,nd,temp,'temp',mtime,blk,thr,1);
                ylabel('Temp (^oC)');
                
                fig_nm = [d_plot_qc '\despike_rough_' mooring_id '_' inst];
                saveas(fig,fig_nm,'png')
                
                % Wait for user ok
                disp('*****');
                despike_ok=input('Accept despiking? (Y/N)            ','s');
                
                if regexp(despike_ok,'Y','ignorecase')
                    % Apply despiking
                    DATA_OUT=DATA_IN;
                    DATA_OUT.temp(ind_t)=NaN;
                    % Record despiking parameters
                    DATA_OUT.despiking_rough_avg_block=blk;
                    DATA_OUT.despiking_rough_tolerance=thr;
                    % Save data
                    eval(['RAW4.' inst '=DATA_OUT;']);
                    dspk = 1;
                else
                    % Ask user for new despiking parameters
                    blk_hrs=input('New averaging duration (hours)?   ','s');
                    thr_str=input('New tolerance (number of std dev)? ','s');
                    % Calculate block (number of samples) from duration given
                    hrs = str2num(blk_hrs);
                    blk = round(hrs/((mtime(2)-mtime(1))*24));
                    % Needs to be an even number, if not round up
                    if mod(blk,2)==1
                        blk=blk+1;
                    end
                    thr=str2num(thr_str);
                    close(fig)
                end
                
                clear DATA_OUT ind_t ind_c ind_s p1 p2 p3 fig
                
            end
            clear inst mtime temp cond sal p1 p2 p3 fig_nm DATA_IN
            
        end
        
        clear j
    end
end


%% Don't despike flc data from ESM-1 but add to PRO file
if exist('esm1_num','var')
    if esm1_num >0
        
        % Loop through each instrument
        for j = 1:esm1_num
            
            % Get instrument structure name and variables
            inst = ['ESM1_' esm1_sn{j}];
            
            % No despiking for esm1 (no T or C data)
            % Save data
            eval(['RAW4.' inst '=RAW3.' inst ';']);
            
        end
    end
end

%% Save final dataset
save(mat_fl,'RAW','RAW2','RAW3','RAW4');

