#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )
#define CRLF '<br>'
#xcommand ? <cText> => AP_RPuts( <cText> )

FUNCTION xxx()

TEMPLATE
	<div class="modal-body">

		<table class="table table-striped table-bordered" style="margin:0px;">

			<tbody>
			
				<?prg 
					
					LOCAL oCustomer := TCustomer():New()	 
					LOCAL aInfo  	:= oCustomer:Info()
					LOCAL cRows		:= ''	
					
					cRows += '<tr>'
					cRows += '   <td class="center">File</td>'
					cRows += '   <td class="center">' + aInfo[ 'file' ] + "</td>"
					cRows += '</tr>'
					
					cRows += '<tr>'
					cRows += '   <td class="center">Size</td>'
					cRows += '   <td class="center">' + hb_valtostr(aInfo[ 'size' ]) + "</td>"
					cRows += '</tr>'					
					
					cRows += '<tr>'
					cRows += '   <td class="center">RecCount</td>'
					cRows += '   <td class="center">' + hb_valtostr(aInfo[ 'reccount' ]) + "</td>"
					cRows += '</tr>'	
					
					RETURN cRows
				?>

			</tbody> 
		</table>

	</div>


	<div class="modal-footer">
	  <button data-dismiss="modal" class="btn btn-danger" ">Salvar Datos</button>
	</div>

	
ENDTEXT


RETU NIL


#include '/var/www/html/browse/model/tsistema.prg'
#include '/var/www/html/browse/model/tcustomer.prg'