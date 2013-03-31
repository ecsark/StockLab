function [date, clicksum] = getClick(stockID, threshold)

address = strcat('/home/ecsark/Documents/Lab/StockLab/click/CLICK', stockID,'.db');

conn = database(address,'','','org.sqlite.JDBC',strcat('jdbc:sqlite:',address));

date = [];
clicksum = [];

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
            rst = fetch(curs);
            
            if ~( isempty(rst.Data) )
                s = cell2mat(rst.Data);
                if strcmpi( 'No Data',s)==1
                    continue;
                end;
                sqlsub = horzcat(sql, ' AND click>',int2str(threshold));
                curs = exec(conn, sqlsub);
                curs = fetch(curs);
                ss = cell2mat(curs.Data);
                if strcmpi( 'No Data',ss)~=1
                    s = s-ss;
                end;
                date = [date, [year;month;day]];
                clicksum = [clicksum, s];
            end;
            close(curs);
        end;
    end;
end;

close(conn);

end
