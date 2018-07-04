function writeOutputData(Results,csv_directory,csv_filename)

%writeOutputData
% Writes data to a csv spreadsheet. 'Results' = results structure generated by terminus change
% functions; 'csv_directory' is the folder in which the spreadsheet will
% be saved; 'csv_filename is the name of the spreadsheet. 

%combine data into one array
if strcmp(Results.Method,'Centreline Method') || strcmp(Results.Method,'Curvilinear Box Method') || strcmp(Results.Method,'Variable Box Method')
    combined=[Results.Date,Results.RawDistance,Results.Distance,Results.TerminusChange...
        Results.RateChange,Results.TerminusWidth,Results.TerminusPathLength,Results.TerminusDetail];
    if strcmp(Results.Method,'Curvilinear Box Method') || strcmp(Results.Method,'Variable Box Method')
        combined=[combined,Results.BoxWidth,Results.BoxArea];
    end

    output=[];
    output={Results.Method,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;'Year','Month','Day','Serial Date'...
        ,'Terminus Position on flowline','Terminus position relative to most recent observation (m)','Terminus change (m)',...
        'Rate of Terminus Change (m/yr)','Terminus Width (m)','Terminus path length (m)','Mean distance between nodes (m)'};
    if strcmp(Results.Method,'Curvilinear Box Method') || strcmp(Results.Method,'Variable Box Method')
            output={Results.Method,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN;'Year','Month','Day','Serial Date'...
            ,'Terminus Position on flowline','Terminus position relative to most recent observation (m)','Terminus change (m)',...
            'Rate of Terminus Change (m/yr)','Terminus Width (m)','Terminus path length (m)','Mean distance between nodes (m)'...
            ,'Box Width (m)','Box Area (m^2)'};
        for n=1:length(combined(:,1))
            for m=1:length(combined(1,:))
                output{n+2,m}=combined(n,m);
            end
        end
       
    else
        for n=1:length(combined(:,1))
            for m=1:length(combined(1,:))
                output{n+2,m}=combined(n,m);
            end
        end
        
        
    end
    [~,~,suffix]=fileparts(csv_filename);
    if isempty(suffix)
        csv_filename=strcat(csv_filename,'.csv');
    end
    fid=fopen(strcat(csv_directory,csv_filename),'w');
    fprintf(fid,'%s\n',output{1,1});
    fprintf(fid,'%s,',output{2,1:end-1});
    fprintf(fid,'%s\n',output{2,end});
    fclose(fid);
    dlmwrite(strcat(csv_directory,csv_filename),output(3:end,:),'-append');

elseif strcmp(Results.Method,'Multi-centreline method')   %for multi-centreline method output
    output=cell(size(Results.DistanceFullRes)+1);
    output{1,1}='Distance across terminus (m)';
    for n=1:length(Results.DistAcrossAll)
        output{n+1,1}=Results.DistAcrossAll(n,1);
    end
    for n=1:length(Results.DateAll(:,1))
        output{1,n+1}=strcat(num2str(Results.DateAll(n,1)),'/',num2str(Results.DateAll(n,2)),'/',num2str(Results.DateAll(n,3)));
    end
    %Distance Full temporalresolution output
    for n=1:length(Results.DistanceFullRes(:,1))
        for m=1:length(Results.DistanceFullRes(1,:))
            output{n+1,m+1}=Results.DistanceFullRes(n,m);
        end
    end
    csv_filename1=strcat(csv_filename,'_MCLM_DistanceFullRes.csv');
    [~,~,suffix]=fileparts(csv_filename);
    if isempty(suffix)
        csv_filename1=strcat(csv_filename,'_MCLM_DistanceFullRes.csv');
    end
     fid=fopen(strcat(csv_directory,csv_filename1),'w');
     fprintf(fid, '%s,',output{1,1:end-1});
     fprintf(fid, '%s\n',output{1,end});
     fclose(fid);
     dlmwrite(strcat(csv_directory,csv_filename1),output(2:end,:),'-append');
     
     %Redefine size of cell array where dates are filtered
     output=cell(size(Results.Distance)+1);
    output{1,1}='Distance across terminus (m)';
    for n=1:length(Results.DistAcross)
        output{n+1,1}=Results.DistAcross(n,1);
    end
    for n=1:length(Results.Date(:,1))
        output{1,n+1}=strcat(num2str(Results.Date(n,1)),'/',num2str(Results.Date(n,2)),'/',num2str(Results.Date(n,3)));
    end
    %Distance Raw output
    for n=1:length(Results.DistanceRaw(:,1))
        for m=1:length(Results.DistanceRaw(1,:))
            output{n+1,m+1}=Results.DistanceRaw(n,m);
        end
    end
    csv_filename1=strcat(csv_filename,'_MCLM_DistanceRaw.csv');
    [~,~,suffix]=fileparts(csv_filename1);
    if isempty(suffix)
        csv_filename1=strcat(csv_filename,'_MCLM_DistanceRaw.csv');
    end
     fid=fopen(strcat(csv_directory,csv_filename1),'w');
     fprintf(fid, '%s,',output{1,1:end-1});
     fprintf(fid, '%s\n',output{1,end});
     fclose(fid);
     dlmwrite(strcat(csv_directory,csv_filename1),output(2:end,:),'-append');
     
    %Distance output
    for n=1:length(Results.Distance(:,1))
        for m=1:length(Results.Distance(1,:))
            output{n+1,m+1}=Results.Distance(n,m);
        end
    end
    csv_filename1=strcat(csv_filename,'_MCLM_Distance.csv');
    [~,~,suffix]=fileparts(csv_filename1);
    if isempty(suffix)
        csv_filename1=strcat(csv_filename,'_MCLM_Distance.csv');
    end
     fid=fopen(strcat(csv_directory,csv_filename1),'w');
     fprintf(fid,'%s,',output{1,1:end-1});
     fprintf(fid,'%s\n',output{1,end});
     fclose(fid);
     dlmwrite(strcat(csv_directory,csv_filename1),output(2:end,:),'-append');
     
     %Distance change output
    for n=1:length(Results.DistanceChange(:,1))
        for m=1:length(Results.DistanceChange(1,:))
            if n==1
                output{n+1,m+1}=NaN;
            else
                output{n+1,m+1}=Results.DistanceChange(n,m);
            end
        end
    end
    csv_filename1=strcat(csv_filename,'_MCLM_DistanceChange.csv');
    [~,~,suffix]=fileparts(csv_filename1);
    if isempty(suffix)
        csv_filename1=strcat(csv_filename,'_MCLM_DistanceChange.csv');
    end
     fid=fopen(strcat(csv_directory,csv_filename1),'w');
     fprintf(fid, '%s,',output{1,1:end-1});
     fprintf(fid, '%s\n',output{1,end});
     fclose(fid);
     dlmwrite(strcat(csv_directory,csv_filename1),output(2:end,:),'-append'); 
     
     %Rate change output
    for n=1:length(Results.RateChange(:,1))
        for m=1:length(Results.RateChange(1,:))
            if n==1
                output{n+1,m+1}=NaN;
            else
                output{n+1,m+1}=Results.RateChange(n,m);
            end
        end
    end
    csv_filename1=strcat(csv_filename,'_MCLM_RateChange.csv');
    [~,~,suffix]=fileparts(csv_filename1);
    if isempty(suffix)
        csv_filename1=strcat(csv_filename,'_MCLM_RateChange.csv');
    end
     fid=fopen(strcat(csv_directory,csv_filename1),'w');
     fprintf(fid, '%s,',output{1,1:end-1});
     fprintf(fid, '%s\n',output{1,end});
     fclose(fid);
     dlmwrite(strcat(csv_directory,csv_filename1),output(2:end,:),'-append'); 
end
end