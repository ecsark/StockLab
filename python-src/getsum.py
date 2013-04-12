import sqlite3

db_original = sqlite3.connect("/home/ecsark/Documents/Lab/StockLab/click/CLICK000001.db")
db_clean = sqlite3.connect("/home/ecsark/Documents/Lab/StockLab/CLICK_SUMMARY.db")

curorg = db_original.cursor()
curcln = db_clean.cursor()

stockID = "000001"
threshold = 100000

for year in range(2012, 2014):
	for month in range(1,13):
		for day in range(1,32):
			date = str(year)+'-'+str(month).zfill(2)+'-'+str(day).zfill(2)
			sql = "SELECT SUM(click) FROM CLICK%s WHERE date LIKE %s" % (stockID,'\'%'+date+'%\'')	
			curorg.execute(sql)
			rst = curorg.fetchone()[0]
			if rst == None:
				continue
			sqlsub = sql + ' AND click>%s' % threshold
			curorg.execute(sqlsub)
			rstsub = curorg.fetchone()[0]
			if rstsub != None:
				rst = rst - rstsub
			curcln.execute("INSERT INTO click VALUES(?,?,?,?)", (date, stockID, rst, 0))
			print date

db_clean.commit()
db_clean.close()
db_original.close()