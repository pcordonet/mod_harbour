#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )
#define CRLF '<br>'
#xcommand ? <cText> => AP_RPuts( <cText> )


function Controller()

	LOCAL cAction 	:= TGet( 'action' )
	
	DO CASE
		CASE cAction == 'load' 		; Load()
		CASE cAction == 'delete' 	; Del()
		OTHERWISE
			? 'Metodo erroneo...'
	ENDCASE
	
RETU NIL
	
STATIC FUNCTION Load()	
	
	LOCAL nPage 	:= val( TGet( 'page', 1 ) )
	LOCAL nRows 	:= val( TGet( 'rows', 5 ) )
	LOCAL cType 	:= 'HTML'	//	JSON
	LOCAL aRows 	:= {}
	LOCAL cHtml 	:= ''
	LOCAL cRecno 	:= ''
	LOCAL oCustomer := TCustomer():New()
	LOCAL hRequest  := {=>}
	LOCAL nI,nFields
	
	aRows 	:= oCustomer:GetPage( nPage, nRows )
	
	DO CASE
	
		CASE cType == 'HTML'
		
			nLen 	:= len( aRows ) 
			nFields := oCustomer:nFields

			FOR nI := 1 TO nLen 
			
				cHtml += '<tr>'
			
				cRecno  := hb_valtostr( aRows[nI][1] )
				cDel 	:= iif( aRows[nI][2], '<span class="reg_status reg_del">•</span>', '<span class="reg_status reg_ok">•</span>' )
			
				cHtml += '<td>' + cRecno  + '</td>'
				cHtml += '<td>' + cDel + '</td>'
				
				FOR nJ := 3 TO (nFields+2) 
					cHtml += '<td>' + hb_valtostr( aRows[nI][nJ] ) + '</td>'
				NEXT
				
				cHtml += "<td>"
				cHtml += '<button type="button" class="btn btn-xs btn-default">'
				cHtml += '   <span class="glyphicon glyphicon-pencil" data-recno="' + cRecno + '"></span>'
				cHtml += "</button>"
				//cHtml += '<button type="button" data-bind="click: $parent.remove" class="remove-news btn btn-xs btn-default" data-toggle="tooltip" data-placement="top" data-original-title="Delete">'
				cHtml += '<button type="button" onClick="Delete(' + cRecno + ')" class="remove-news btn btn-xs btn-default" data-toggle="tooltip" data-placement="top" data-original-title="Delete">'
				cHtml += '   <span class="glyphicon glyphicon-trash"></span>'
				cHtml += "</button>"
				cHtml += "</td>"
				
				cHtml += '</tr>'
				
			NEXT
			
			? cHtml
			
		CASE cType == 'JSON'		

			hRequest[ 'rows'] := aRows
			hRequest[ 'reccount'] := oCustomer:RecCount()		
			
			//	Pendiente de crear cabecera type json
			//? hb_jsonEncode( hRequest )
			
	ENDCASE
	   
RETU NIL

STATIC FUNCTION Del() 

	LOCAL nRecno 	:= val( TGet( 'recno', 0 ) )
	LOCAL oCustomer := TCustomer():New()
	
	? hb_valtostr( oCustomer:Delete( nRecno ) )

RETU NIL

#include '/var/www/html/browse/model/tsistema.prg'
#include '/var/www/html/browse/model/tcustomer.prg'