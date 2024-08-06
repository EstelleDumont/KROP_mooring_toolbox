function [err,err_msg,out_files] = KROP_export_adcp_mat(root_dir,moor_id)

% Reformat and export ADCP variables for KROP
% Script adapted to run with KROP ADCP GUI toolbox
% ESDU, SAMS, Oct-22


% Set up directories
matlab_dir  = [root_dir '\processing\matlab_ADCP'];
moor_dir    = [root_dir '\' moor_id];
raw_dir     = [moor_dir '\bin\ADCP\2_converted'];
mat_dir     = [moor_dir '\mat'];

err_msg = [];
file_unknown = [];

% First check the ADCP data directory exists
if ~isfolder(raw_dir)
    err_msg = 'ADCP data folder not found for this mooring';
    out_files = [];
    
else
    
    % Get list of data files in that mooring subdirectory.
    % Select only the final ones containing the Sv data (so look for '_sv' suffix)
    % The filename convention is usually MM_YY_YY_ADCP_O_rdr_qc_ice_sv.mat,
    % although in some instances both ADCPs looking up, or only there was only
    % one ADCP on the mooring. so look for all files that may be a match in the
    % directory.
    eval(['cd ' raw_dir ])
    m_str = [moor_id '_ADCP_*_sv.mat'];
    fl_list = dir(m_str);
    
    % Check if there are processed files in the directory
    if isempty(fl_list)
        err_msg = 'ADCP data folder not found for this mooring';
        file_out = 'n/a';
        
    else
        
        %% Loop through files
        uf=1;
        of = 1;
        err_msg = [];
        file_unknown = [];
        
        eval(['addpath ' matlab_dir]); % Path cleared by keep function at each loop, add again
        
        for j=1:length(fl_list)
            
            in_file = fl_list(j).name;
            if regexp(in_file,'_D_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_D_rdr_qc_ice_sv.mat','_D.mat')];
            elseif regexp(in_file,'_D1_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_D_rdr_qc_ice_sv.mat','_D1.mat')];
            elseif regexp(in_file,'_D2_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_D_rdr_qc_ice_sv.mat','_D2.mat')];
            elseif regexp(in_file,'_U_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_U_rdr_qc_ice_sv.mat','_U.mat')];
            elseif regexp(in_file,'_U1_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_U1_rdr_qc_ice_sv.mat','_U1.mat')];
            elseif regexp(in_file,'_U2_rdr_qc_ice_sv.mat')
                out_file = [mat_dir '\' regexprep(in_file,'_U2_rdr_qc_ice_sv.mat','_U2.mat')];
            else % filename not recognised
                err_msg = ['Input filename not recognised:   ' in_file];
                break
            end
            
            % Load data
            DATA_IN = load(in_file);
            
            % Extract variables
            latitude = (abs(DATA_IN.lat_deg) + DATA_IN.lat_min/0.6/100) * (DATA_IN.lat_deg/abs(DATA_IN.lat_deg));
            longitude = (abs(DATA_IN.long_deg) + DATA_IN.long_min/0.6/100) * (DATA_IN.long_deg/abs(DATA_IN.long_deg));
            nominal_depth = DATA_IN.adcp_depth;
            seafloor_depth = DATA_IN.w_depth;
            bin_depth = DATA_IN.bin_depth;
            mtime = DATA_IN.mtime;
            time =  posixtime(datetime(datestr(mtime)));
            u = DATA_IN.u;
            v = DATA_IN.v;
            w = DATA_IN.w;
            velocity_err = DATA_IN.err;
            ice_cover = DATA_IN.ice_cover;
            Sv = DATA_IN.Sv;
            pressure0 = DATA_IN.pressure;
            pitch0 = DATA_IN.pitch;
            roll0 = DATA_IN.roll;
            
            % Resize some variables
            ind = nan(length(mtime),1);
            for jj=1:length(mtime)
                ind(jj,1) = find(DATA_IN.mtime_all == mtime(jj));
            end
            pressure = pressure0(ind);
            pitch = pitch0(ind);
            roll = roll0(ind);
            
            % Export data
            save(out_file,'latitude','longitude','nominal_depth',...
                'seafloor_depth','mtime','time','bin_depth','u','v','w',...
                'velocity_err','ice_cover','Sv','pressure','pitch','roll');
            
            % Add file to list of output files
            out_files{of+1} = out_file;
            of = of+1;
            
            keep j moor_id fl_list matlab_dir raw_dir mat_dir root_dir...
                file_unknown out_files uf of err_msg
                   
        end
    end 
    
end

% Set error flag
if ~isempty(err_msg)
    err = 1;
    out_files = [];
else
    err = 0;
    err_msg = '';
end
