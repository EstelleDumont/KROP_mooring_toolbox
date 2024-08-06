function KROP_read_data(info_file)

% Read and save raw data
% ESDU, SAMS, Jan 2019

% Load info file
load(info_file);

read_data = 1;

% First check if data has already been read
file_out = [d_mat '\' mooring_id '_CTD.mat'];
if exist(file_out,'file')
    % Ask user if they want to re-read data
    reread=input('Mooring mat file already exists, do you want to re-read the data (Y/N)?   ','s');
    if regexp(reread,'N','ignorecase')
        disp('Using existing mat file, not re-reading data...')
        read_data = 0;
    end
end

if read_data == 1
    
    % Read SBE16p
    if sbe16p_num >0
        for j = 1:sbe16p_num
            disp_str = ['            Reading data from SBE16+ s/n ' num2str(sbe16p_sn{j}) '...'];
            disp(disp_str);
            sbe16p_x=KROP_read_sbe16p(mooring_id,mooring_lat,sbe16p_sn{j},d_sbe16p,...
                sbe16p_depth{j},sbe16p_p(j),sbe16p_t(j),sbe16p_c(j),...
                sbe16p_flc(j),sbe16p_par(j),sbe16p_tur(j),start_year);
            eval(['RAW.SBE16p_' sbe16p_sn{j} '=sbe16p_x;']);
            clear sbe16p_x
        end
        clear j sbe16p*
    end
    
     % Read SBE19p
    if sbe19p_num >0
        for j = 1:sbe19p_num
            disp_str = ['            Reading data from SBE19+ s/n ' num2str(sbe19p_sn{j}) '...'];
            disp(disp_str);
            sbe19p_x=KROP_read_sbe19p(mooring_id,mooring_lat,sbe19p_sn{j},d_sbe19p,...
                sbe19p_depth{j},sbe19p_p(j),sbe19p_t(j),sbe19p_c(j),...
                sbe19p_flc(j),sbe19p_par(j),sbe19p_tur(j),start_year);
            eval(['RAW.SBE19p_' sbe19p_sn{j} '=sbe19p_x;']);
            clear sbe19p_x
        end
        clear j sbe19p*
    end
    
     % Read HydroCAT
    if hcat_num >0
        for j = 1:hcat_num
            disp_str = ['            Reading data from HydroCAT s/n ' num2str(hcat_sn{j}) '...'];
            disp(disp_str);
            hcat_x=KROP_read_hcat(mooring_id,mooring_lat,hcat_sn{j},d_hcat,...
                hcat_depth{j},hcat_p(j),hcat_t(j),hcat_c(j),...
                hcat_ph(j),hcat_flc(j),hcat_tur(j),hcat_oxy(j),start_year);
            eval(['RAW.HCAT_' hcat_sn{j} '=hcat_x;']);
            clear hcat_x
        end
        clear j hcat*
    end
    
     % Read ESM-1
     clear j
    if exist('esm1_num','var')
    if esm1_num >0
        for j = 1:esm1_num
            disp_str = ['            Reading data from ESM-1 logger s/n ' num2str(esm1_sn{j}) '...'];
            disp(disp_str);
            esm1_x=KROP_read_esm1(mooring_id,esm1_sn{j},esm1_flc(j),start_year,d_esm1,esm1_depth{j},esm1_flc_bits(j),esm1_flc_range(j));
            eval(['RAW.ESM1_' esm1_sn{j} '=esm1_x;']);
            clear esm1_x
        end
        clear j esm1*
    end
    end
    
    
    % Read SBE37
    if sbe37_num >0
        for j = 1:sbe37_num
            disp_str = ['            Reading data from SBE37  s/n ' num2str(sbe37_sn{j}) '...'];
            disp(disp_str);
            sbe37_x=KROP_read_sbe37(mooring_id,mooring_lat,sbe37_sn{j},d_sbe37,...
                sbe37_depth{j},sbe37_p(j),start_year);
            eval(['RAW.SBE37_' sbe37_sn{j} '=sbe37_x;']);
            clear sbe37_x
        end
        clear j sbe37*
    end
    
    
    % Read SBE56
    if sbe56_num >0
        for j = 1:sbe56_num
            disp_str = ['            Reading data from SBE56  s/n ' num2str(sbe56_sn{j}) '...'];
            disp(disp_str);
            sbe56_x=KROP_read_sbe56(mooring_id,sbe56_sn{j},d_sbe56,sbe56_depth{j});
            eval(['RAW.SBE56_' sbe56_sn{j} '=sbe56_x;']);
            clear sbe56_x
        end
        clear j sbe56*
    end
    
    
    % Read Minilogs
    if ml_num >0
        for j = 1:ml_num
            disp_str = ['            Reading data from Minilog s/n ' num2str(ml_sn{j}) '...'];
            disp(disp_str);
            if exist('ml_p','var')
                ml_x=KROP_read_minilog(mooring_id,ml_sn{j},start_year,d_ml,ml_depth{j},ml_p(j));
            else
                ml_x=KROP_read_minilog(mooring_id,ml_sn{j},start_year,d_ml,ml_depth{j},0);
            end
            eval(['RAW.ML_' ml_sn{j} '=ml_x;']);
            clear ml_x
        end
        clear j ml*
    end
    
    
    % Save data in mat file
    save(file_out,'RAW');
    
end