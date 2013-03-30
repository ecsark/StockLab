clear;

stockID = '600005';

tableName = strcat('CLICK', stockID);
address = strcat('/home/ecsark/Documents/Lab/Stock/click/', tableName,'.db');

conn = database(address,'','','org.sqlite.JDBC',strcat('jdbc:sqlite:',address));
setdbprefs('DataReturnFormat','cellarray');

date = [];
click = [];

for year = 2012:2013
    for month = 1:12
        for day = 1:31
            sql = strcat('SELECT SUM(click) FROM CLICK',stockID,' WHERE date LIKE "%', int2str(year),   '-');
            if month<10
                sql = strcat(sql, '0', int2str(month));
            else
                sql = strcat(sql, int2str(month));
            end;
            sql = strcat(sql, '-');
            if day<10
                sql = strcat(sql, '0', int2str(day));
            else
                sql = strcat(sql, int2str(day));
            end;
            sql = strcat(sql, '%"');
            
            curs = exec(conn, sql);
            curs = fetch(curs);
            
            if ~( isempty(curs.Data) )
                s = cell2mat(curs.Data);
                if strcmpi( 'No Data',s)==1
                    continue;
                end;
                date = [date, [year;month;day]];
                click = [click, s];
            end;
        end;
    end;
end;

close(conn);