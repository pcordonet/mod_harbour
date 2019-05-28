#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )
#define CRLF '<br>'
#xcommand ? <cText> => AP_RPuts( <cText> )

/* Ejemplo recibiendo parametros via POST */

function Controller()
	
	LOCAL cAction 	:= TPost( 'action' )
	
	DO CASE
		CASE cAction == 'update'		; Update()
		OTHERWISE
			? AP_METHOD()+ CRLF
			? AP_Args()
	ENDCASE
	
RETU NIL

FUNCTION Update()

	LOCAL nRecno 	:= val( TPost( 'recno', 0 ) )
	LOCAL oCustomer := TCustomer():New()
	LOCAL aData 	:= {}
	

	
	Aadd( aData, { 'FIRST'   , TPost( 'FIRST' ) } )
	Aadd( aData, { 'LAST'    , TPost( 'last' ) } )
	Aadd( aData, { 'STREET'  , TPost( 'STREET' ) } )
	
	? oCustomer:Update( nRecno, aData )

RETU NIL
	
#include '/var/www/html/browse/model/tsistema.prg'
#include '/var/www/html/browse/model/tcustomer.prg'