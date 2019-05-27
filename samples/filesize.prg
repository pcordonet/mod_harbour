#include '/var/www/html/include/dbinfo.ch'
#xcommand ? <cText> => AP_RPuts( <cText> )

#define CRLF '<br>'

function main()

	LOCAL aFile := Directory( '/var/www/html/data/customer.dbf' )
	LOCAL cAlias
	
	USE ( '/var/www/html/data/customer.dbf' ) SHARED NEW
	
	cAlias := Alias()
	
	
	
	
	? hb_valtostr( aFile[1][1] ) + CRLF 
	? hb_valtostr( aFile[1][2] ) + CRLF 
	? hb_valtostr( aFile[1][3] ) + CRLF 
	? hb_valtostr( aFile[1][4] ) + CRLF 
	? hb_valtostr( (cAlias)->(RecCount()) ) + CRLF 
	
	? hb_valtostr( (cAlias)->( dbInfo(DBI_GETHEADERSIZE) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_LASTUPDATE) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_GETRECSIZE) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_DB_VERSION) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_FCOUNT) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_FULLPATH) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_GETRECSIZE) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_TABLEEXT) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_MEMOEXT) )) + CRLF 
	? hb_valtostr( (cAlias)->( dbInfo(DBI_RDD_VERSION) )) + CRLF 
	
	
	
RETU NIL