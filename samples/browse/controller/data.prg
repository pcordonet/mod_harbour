#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )
#define CRLF '<br>'
#xcommand ? <cText> => AP_RPuts( <cText> )


function Controller()

	LOCAL cAction 	:= TGet( 'action' )
	
	DO CASE
		CASE cAction == 'load' 		; Load()
		CASE cAction == 'delete' 	; Del()
		CASE cAction == 'edit' 		; Edit()
		OTHERWISE
			? AP_METHOD()+ CRLF
			? AP_Args()
	ENDCASE
	
RETU NIL
	
STATIC FUNCTION Load()	
	
	LOCAL nPage 	:= val( TGet( 'page', '1' ) )
	LOCAL nRows 	:= val( TGet( 'rows', '5' ) )
	LOCAL cType 	:= TGet( 'output', 'HTML' ) 	//	JSON
	//LOCAL cType 	:= 'HTML'
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
				cHtml += '<button type="button" onClick="Edit(' + cRecno + ')" class="btn btn-xs btn-default">'
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

			//	Para usarlo desde llamadas tipo ws
			//	Check -> http://localhost/browse/controller/data.prg?action=load&output=JSON&rows=100 

			hRequest[ 'rows'    ] := aRows
			hRequest[ 'reccount'] := oCustomer:RecCount()		
			
			//	Pendiente de crear cabecera type json
			? hb_jsonEncode( hRequest )
			
	ENDCASE
	   
RETU NIL

STATIC FUNCTION Del() 

	LOCAL nRecno 	:= val( TGet( 'recno', 0 ) )
	LOCAL oCustomer := TCustomer():New()
	
	? hb_valtostr( oCustomer:Delete( nRecno ) )

RETU NIL

STATIC FUNCTION Edit()

	//LOCAL nRecno 	:= val( TGet( 'recno', 0 ) )
	LOCAL x := '123'
	
TEMPLATE
	<div class="modal-body">

		<table class="table table-striped table-bordered" style="margin:0px;">
			<thead>
				<tr>
					<th>FieldName</th>
					<th>Value</th>
			</thead>
			<tbody id='myfields' data-recno="<?prg return TGet( 'recno' )?>">
            <?prg 
				LOCAL nRecno 	:= val( TGet( 'recno' ) )
				LOCAL oCustomer := TCustomer():New( nRecno )	 
				LOCAL cRows 	:= "", n
				LOCAL cField 	:= ''				
				
                FOR n := 1 TO oCustomer:nFields
						cField := oCustomer:FieldName( n )
						cRows += '<tr>'
						cRows += '   <td class="center">' + cField + "</td>"
						cRows += '   <td  class="center"><input type="text" data-field="' + cField + '" class="form-control" style="border-radius:0px"' + ;
                                   " value='" + ValToChar( oCustomer:FieldGet( n ) ) + "'></td>"
						cRows += '</tr>'
                NEXT
				
                RETURN cRows
			?>
			</tbody> 
		</table>

	</div>


	<div class="modal-footer">
	  <button data-dismiss="modal" class="btn btn-danger" onClick="Test_Update()">Salvar Datos</button>
	</div>
	
	<script>
	
		function Test_Update() {
		
			var nRecno 	= $("#myfields").attr( 'data-recno' )
			var aFields = $("#myfields :input");
			var nFields = aFields.length
			var oParam	= new Object()
			var oData	= new Object()
						
			oParam[ 'action' ] = 'update'
			oParam[ 'recno' ] = nRecno
			
			
			//	Esto de momento no funciona cuando llega al server...
			/*
				for (i = 0; i < nFields; i++) {
					oData[ $(aFields[i]).attr('data-field') ] = aFields[i].value 
				}
				
				//	Lo suyo seria pasar este objeto via post pero de momento casca 
				
					oParam[ 'data' ] = oData			
				
					
			*/
			
			//	Lo pondremos en el mismo array para recuperar bien el POST
			
				for (i = 0; i < nFields; i++) {
					oParam[ $(aFields[i]).attr('data-field') ] = aFields[i].value 
				}			
			
			
				console.log( 'oParam', oParam )
			
			
			$.post( "controller/data_update.prg", oParam )
					.done(function( data ) {
						alert( "Data Loaded: " + data );
						
						//	Pendiente de Refrescar Pagina...
						LoadPage( nActual )
					});
				
				
					
		}
	</script>	
	
ENDTEXT


RETU NIL



#include '/var/www/html/browse/model/tsistema.prg'
#include '/var/www/html/browse/model/tcustomer.prg'