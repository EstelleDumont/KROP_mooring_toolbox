function [mat_path,e_path]=clean_data(path,beg,last,bins,wbin,depth,direction,mpathout,mout,epathout,eout,lunar_phase,offset)
% function clean_data
% input: path = full path and file name of the input data
%        beg = the number of the first data segment in the file
%        last = the number of the last data segment in the file
%        bins = the number of bins per data segment
%        wbin = the distance between two consecutive bins
%        depth = the depth of the first bin in the data
%        direction = was the ADCP facing up or down
%        mpathout = full directory path for output MAT file
%        mout = the output MAT filename
%        epathout = full directory path for output of the Excel file
%        eout = the output Excel filename
%        lunar_phase = 1 for full moon, 2 for new moon
%        offset = first datafile number
%        It is assumed that the file contains only consecutively numbered
%        data segments.
%        It is also important that there is a 0 in front of the single
%        digit numbers of your input, if you have more than 9 files and
%        less than 99, if you have more than 99 files but less than 999,
%        two zeroes have to be in front of the single digit numbers and one
%        in front of the double digit numbers, and so on.

% output: the function will return the full path and file names of the
%         saved output data

format long g

% This line turns off the warning when a new Sheet is added to an Excel file.
warning off MATLAB:xlswrite:AddSheet

% In the following section the input filenames are stored for later usage.
spec=dir([path, '\*.csv_Spec']);
auto=dir([path, '\*.csv_Auto']);
% spec=dir([path, '\*.CSV_SPEC']);
% auto=dir([path, '\*.CSV_AUTO']);

% NB: Filename set-up method has been modified in order to not have to 
% rename all the CLEAN files
% Deletes the .CSV_SPEC and .CSV_AUTO parts of the file names and stores the
% rest in a matrix.
% for i=1:length(spec)
%     j=find(spec(i).name(:)=='.');
%     if j==26;
%         staSpec_cell{i}=['00' spec(i).name];
%     elseif j==27;
%         staSpec_cell{i}=['0' spec(i).name];
%     elseif j==28;
%         staSpec_cell{i}=spec(i).name;
%     end
%     %     staSpec(i,1:j-1)=str2mat(spec(i).name(1:j-1));
% end
% staSpec=str2mat(staSpec_cell);
% 
% for i=1:length(auto)
%     j=find(auto(i).name(:)=='.');
%     if j==26;
%         staAuto_cell{i}=['00' auto(i).name];
%     elseif j==27;
%         staAuto_cell{i}=['0' auto(i).name];
%     elseif j==28;
%         staAuto_cell{i}=auto(i).name;
%     end
%     % staAuto(i,1:j-1)=str2mat(auto(i).name(1:j-1));
% end
% staAuto=str2mat(staAuto_cell);


%% READING IN AND PROCESSING SPEC DATA

% Set names of varables / tabs according to moon phase
if lunar_phase==1;
    tab_name='Spec_FullMoon_';
elseif lunar_phase==2;
    tab_name='Spec_NewMoon_';
else
    tab_name='Spec_UnspecMoon_';
end

% These two loops extract the spec-data from the input files and store them in a
% structure array for the Mat file and in a matrix for the excel file. At
% the end we save the two in the files they should be in.


for i=beg:last
    
    %fnmSpec=[staSpec((1+(i-beg)*bins),:) '.csv_Spec'];%'.CSV_SPEC'];
    % fnmSpec=[num2str(1+(i-beg)*bins) ' Worm activity for CLEAN.csv_Spec'];
    fnmSpec=[num2str(offset+(i-beg)*bins) ' Worm activity for CLEAN.csv_Spec'];
    [cleanSpec.t_hours,cleanSpec.data_spec_units,cleanSpec.confi_limit_95,cleanSpec.confi_limit_99]=textread([path '\' fnmSpec],'%f %f %f %f','headerlines',0);
    
    % MAT
    %     eval(['specDataSeg_' num2str(i) '(1,:).t_hours=cleanSpec.t_hours;']);
    %     eval(['specDataSeg_' num2str(i) '(1,:).data_spec_units=[depth; cleanSpec.data_spec_units];']);
    %     eval(['specDataSeg_' num2str(i) '(1,:).confi_limit_95=cleanSpec.confi_limit_95;']);
    %     eval(['specDataSeg_' num2str(i) '(1,:).confi_limit_99=cleanSpec.confi_limit_99;']);
    eval([tab_name num2str(i) '(1,:).t_hours=cleanSpec.t_hours;']);
    eval([tab_name num2str(i) '(1,:).data_spec_units=[depth; cleanSpec.data_spec_units];']);
    eval([tab_name num2str(i) '(1,:).confi_limit_95=cleanSpec.confi_limit_95;']);
    eval([tab_name num2str(i) '(1,:).confi_limit_99=cleanSpec.confi_limit_99;']);
    
    
    % EXCEL
    eval(['especDataSeg_' num2str(i) '(:,1)=[nan; cleanSpec.t_hours];']);
    eval(['especDataSeg_' num2str(i) '(:,2)=[depth; cleanSpec.data_spec_units];']);
    eval(['especDataSeg_' num2str(i) '(:,3)=[nan; cleanSpec.confi_limit_95];']);
    eval(['especDataSeg_' num2str(i) '(:,4)=[nan; cleanSpec.confi_limit_99];']);
    
    for j=2:bins
        
        % fnmSpec=[staSpec((j+(i-beg)*bins),:) '.CSV_SPEC'];
        % fnmSpec=[num2str(j+(i-beg)*bins) ' Worm activity for CLEAN.csv_Spec'];
        fnmSpec=[num2str(j+(i-beg)*bins+(offset-1)) ' Worm activity for CLEAN.csv_Spec'];
        [cleanSpec.t_hours,cleanSpec.data_spec_units,cleanSpec.confi_limit_95,cleanSpec.confi_limit_99]=textread([path '\' fnmSpec],'%f %f %f %f','headerlines',0);
        
        if direction == 'u' % Depending on the direction the ADCP was facing the depth of the bins is calculated accordingly.
            % MAT
            % eval(['specDataSeg_' num2str(i) '(j,:).data_spec_units=[depth-(j-1)*wbin; cleanSpec.data_spec_units];']);
            eval([tab_name num2str(i) '(j,:).data_spec_units=[depth-(j-1)*wbin; cleanSpec.data_spec_units];']);
            
            % EXCEL
            eval(['especDataSeg_' num2str(i) '(:,(2+(j-1)*4))=[depth-(j-1)*wbin; cleanSpec.data_spec_units];']);
            
        else
            % eval(['specDataSeg_' num2str(i)'(j,:).data_spec_units=[depth+(j-1)*wbin; cleanSpec.data_spec_units];']);
            eval([tab_name num2str(i) '(j,:).data_spec_units=[depth+(j-1)*wbin; cleanSpec.data_spec_units];']);
            eval(['especDataSeg_' num2str(i) '(:,(2+(j-1)*4))=[depth+(j-1)*wbin; cleanSpec.data_spec_units];']);
            
        end
        
        % MAT
        %         eval(['specDataSeg_' num2str(i) '(j,:).confi_limit_95=cleanSpec.confi_limit_95;']);
        %         eval(['specDataSeg_' num2str(i) '(j,:).confi_limit_99=cleanSpec.confi_limit_99;']);
        
        eval([tab_name num2str(i) '(j,:).confi_limit_95=cleanSpec.confi_limit_95;']);
        eval([tab_name num2str(i) '(j,:).confi_limit_99=cleanSpec.confi_limit_99;']);
        
        % EXCEL
        eval(['especDataSeg_' num2str(i) '(:,(3+(j-1)*4))=[nan; cleanSpec.confi_limit_95];']);
        eval(['especDataSeg_' num2str(i) '(:,j*4)=[nan; cleanSpec.confi_limit_99];']);
        
    end
    
    %% SAVING SPEC DATA
    
    if exist([mpathout, '\', mout, '.mat'], 'file')==2 % If the mat-file already exists the array has to be appended.
        
        % eval(['save ',mpathout, '\', mout, ' specDataSeg_' num2str(i) ' -append;'])
        eval(['save ',mpathout, '\', mout, ' ' tab_name num2str(i) ' -append;'])
        
    else
        % eval(['save ',mpathout, '\', mout, ' specDataSeg_' num2str(i) ';'])
        eval(['save ',mpathout, '\', mout, ' ' tab_name num2str(i) ';'])
        
    end
    
    % eval(['xlswrite(''',epathout, '\', eout,'.xls'',especDataSeg_'num2str(i) ,',''Spec data-segment ' num2str(i) ''',''A1'');'])
    eval(['xlswrite(''',epathout, '\', eout,'.xls'',especDataSeg_' num2str(i) ,',''' tab_name num2str(i) ''',''A1'');'])
    
end



%% LOADING AND SAVING AUTO FILES

% These two loops extract the auto-data from the input files and store them in a
% structure array for the Mat file and in a matrix for the excel file. At
% the end we save the two in the files they should be in.

A1=nan(1,1);  %This Matrix has the purpose of preventing errors in the loops.
for i=1:last-beg+1
    k=i+beg-1;
    A=A1;       % A is a help-matrix that we use to store the current matrix A1 so we can widen A1 according to the new data from the loop.
    % This is done because it has been the case that two
    % matrices of different sizes had to be merged to one.
    [m,n]=size(A);
    
    %fnmAuto=[staAuto((1+(i-1)*bins),:) '.CSV_AUTO'];
    %fnmAuto=[num2str(1+(i-1)*bins) ' Worm activity for CLEAN.csv_Auto'];  
    fnmAuto=[num2str(offset+(i-beg)*bins) ' Worm activity for CLEAN.csv_Auto'];
    
    [cleanAuto.t_hours,cleanAuto.data_auto_units,cleanAuto.confi_limit_95,cleanAuto.confi_limit_99]=textread([path '\' fnmAuto],'%f %f %f %f','headerlines',0);
    
    
    eval(['autoData(',num2str(i),',:).dataSeg=''dataSeg_',num2str(k),''';']);
    
    autoData((i),:).t_hours=(cleanAuto.t_hours./2);
    
    A1=nan(max(length(autoData((i),:).t_hours)+1,length(A)),i*(5+bins)-1); % The dimension of the matrix is adjusted according to the columns it
    % is supposed to hold.
    A1(1:m,1:n)=A; % The already generated matrix is inserted first, the new data is added after it.
    A1(1:length(A1),2+(i-1)*(5+bins))=[nan; (cleanAuto.t_hours./2)];
    
    autoData((i),:).dataMat_auto_units(:,1)=[depth; cleanAuto.data_auto_units];
    
    A1(1:length(A1),3+(i-1)*(5+bins))=[depth; cleanAuto.data_auto_units];
    
    
    for j=2:bins
        
        % fnmAuto=[staAuto((j+(i-1)*bins),:) '.CSV_AUTO'];
        % fnmAuto=[num2str(j+(i-1)*bins) ' Worm activity for CLEAN.csv_Auto'];
        fnmAuto=[num2str(j+(i-beg)*bins+(offset-1)) ' Worm activity for CLEAN.csv_Auto'];
      
        
        [cleanAuto.t_hours,cleanAuto.data_auto_units,cleanAuto.confi_limit_95,cleanAuto.confi_limit_99]=textread([path '\' fnmAuto],'%f %f %f %f','headerlines',0);
        if direction == 'u'
            
            autoData((i),:).dataMat_auto_units(:,j)=[depth-(j-1)*wbin; cleanAuto.data_auto_units];
            
            
        else
            autoData((i),:).dataMat_auto_units(:,j)=[depth+(j-1)*wbin; cleanAuto.data_auto_units];
            
        end
        
        A1(1:length(A1),2+j+(i-1)*(5+bins))=autoData((i),:).dataMat_auto_units(:,j);
        
    end
    
    autoData((i),:).confi_limit_95=cleanAuto.confi_limit_95;
    
    A1(1:length(A1),i*(5+bins)-2)=[nan; cleanAuto.confi_limit_95];
    
    autoData((i),:).confi_limit_99=cleanAuto.confi_limit_99;
    
    A1(1:length(A1),i*(5+bins)-1)=[nan; cleanAuto.confi_limit_99];
    
    
    %% SAVING AUTO DATA
    
    eval(['save ',mpathout, '\', mout,' autoData' ' -append;'])
    
end

eval(['xlswrite(''',epathout, '\', eout,'.xls'',A1' ,',''Auto'');'])

%% ADDITIONAL FUNCTIONS CALLED
%created by: Quan Quach
%date: 11/6/07
%this part erases any empty sheets in an excel document

excelObj = actxserver('Excel.Application');
%opens up an excel object
%excelWorkbook = excelObj.workbooks.Open([epathout,'\',eout]);
excelWorkbook = excelObj.workbooks.Open([epathout,'\',eout,'.xls']);
worksheets = excelObj.sheets;
%total number of sheets in workbook
numSheets = worksheets.Count;

count=1;
for x=1:numSheets
    %stores the current number of sheets in the workbook
    %this number will change if sheets are deleted
    temp = worksheets.count;
    
    %if there's only one sheet left, we must leave it or else
    %there will be an error.
    if (temp == 1)
        break;
    end
    
    %this command will only delete the sheet if it is empty
    worksheets.Item(count).Delete;
    
    %if a sheet was not deleted, we move on to the next one
    %by incrementing the count variable
    if (temp == worksheets.count)
        count = count + 1;
    end
end
excelWorkbook.Save;
excelWorkbook.Close(false);
excelObj.Quit;
delete(excelObj);

%% Here we create the output of the function.
mat_path= [mpathout, '\', mout, '.mat;'];
e_path= [epathout, '\', eout, '.xls;'];




