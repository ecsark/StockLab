import sqlite3
from datetime import timedelta,date
from time import strftime
import os
import re

def getQuant(curorg,stockID,itemName,date,threshold):
	sql = "SELECT SUM(%s) FROM %s WHERE date LIKE %s" % (itemName,'CLICK'+stockID,'\'%'+date+'%\'')
	curorg.execute(sql)
	rst = curorg.fetchone()[0]
	if rst == None:
		return rst
	sqlsub = sql + ' AND %s>%s' % (itemName,threshold)
	curorg.execute(sqlsub)
	rstsub = curorg.fetchone()[0]
	if rstsub != None:
		rst = rst - rstsub
	return rst


class DateException(Exception):
	pass


def parsedate(datelist):
	if int(datelist[0]) > 1900 and int(datelist[0]) < 2500:
		if int(datelist[1]) > 0 and int(datelist[1]) < 13:
			if int(datelist[2] >0 and int(datelist[2]) <32):
				return date(int(datelist[0]), int(datelist[1]), int(datelist[2]))
	raise DateException("Date format: YYYY-MM-DD")


def daterange(start_date, end_date):
    for n in range(int ((end_date - start_date).days)):
        yield start_date + timedelta(n)


def handlesingle(curorg,stockID,start,end,threshold = 100000):	
	for single_date in daterange(start, end):
		dd = strftime("%Y-%m-%d", single_date.timetuple())
		clicks = getQuant(curorg,stockID,'click', dd, threshold)
		if clicks == None:
			continue
		replies = getQuant(curorg,stockID,'reply', dd, threshold)
		if replies == None:
			replies = 0
		curcln.execute("INSERT INTO click VALUES(?,?,?,?)", (dd, stockID, clicks, replies))




def process(rootDir,begindate,enddate):
	start = parsedate(begindate.split('-'))
	end = parsedate(enddate.split('-'))
	lists = os.listdir(rootDir)
	for (index,f) in zip(xrange(len(lists)), lists):
	    if str(f).startswith('CLICK') == True:
	    	db_original = sqlite3.connect(os.path.join(rootDir, f))
	    	curorg = db_original.cursor()
	       	stockID = re.split('K|\.',str(f))[1]
	       	print stockID, str(index*100/len(lists))+'%'
	       	handlesingle(curorg,stockID,start,end)
	       	db_clean.commit()
	       	db_original.close()
	       	




if __name__ == '__main__':
	#directory of CLICK*******.db
	click_dir = '/home/ecsark/Documents/Lab/StockLab/click'
	#location of the summary database
	#FIRST RUN:
	#create a table in this summary db using the following command:
	#	CREATE TABLE click(date varchar(30), stockid varchar(30), clicksum integer, replysum integer)
	sum_db = '/home/ecsark/Documents/Lab/StockLab/CLICK_SUMMARY.db'
	date_since = "2012-12-23"
	date_till = "2013-04-09"
	
	db_clean = sqlite3.connect(sum_db)
	curcln = db_clean.cursor()
	process(click_dir,date_since,date_till)
	db_clean.close()