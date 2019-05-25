#xcommand TEMPLATE => #pragma __cstream | AP_RPuts( Template( %s ) )
#define CRLF '<br>'

function Main()

	Public oCustomer 	:= TCustomer():New()
	Public cTable 		:= oCustomer:cDescription
	Public nRegisters 	:= oCustomer:RecCount()
	Public nRows   		:= 5
	Public nPages  		:= Int( nRegisters/ nRows )


TEMPLATE 
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Ejemplo Browse</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto|Varela+Round">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script src="lib/bootpag/jquery.bootpag.min.js"></script>
<link rel="stylesheet" href="css/app.css">
</head>
<body>
    <div class="mycontainer">
        <div class="table-wrapper">
            <div class="table-title">
                <div class="row">
                    <div class="col-sm-5">
						<h2>Table 
						<?prg 
							LOCAL cHtml := '<b>' + cTable + '</b>' 
							cHtml += '<h5>Registers: ' + ltrim(str(nRegisters)) + '</h5>' 
							return cHtml
						?>
						</h2>
					</div>
					<div class="col-sm-7" style="margin-top:15px;">
						<a href="#" class="btn btn-primary"><i class="material-icons">&#xE147;</i> <span>Añadir Regsitro</span></a>						
						<a href="#" class="btn btn-primary" onClick="Info()"><i class="material-icons">&#xE24D;</i> <span>Informacion</span></a>
					</div>
                </div>
            </div>
            <table class="table table-striped table-hover">
                <thead>				
                    <tr>
						<?prg 
							LOCAL aFields 	:= oCustomer:GetFields()
							LOCAL cCols 	:= '<th>Id.</th><th>Del</th>'
							
							FOR nI := 1 To oCustomer:nFields
								cCols += "<th>" + aFields[ nI ] + "</th>"								
							NEXT
							
							cCols += '<th>Acciones</th>'
							return cCols
						?>					
                    </tr>
                </thead>
                <tbody id="dat">

                </tbody>
            </table>
        </div>
		<div id="pagination-selection" class="pagination-bar">

		</div>
    </div>
	
	<!-- Modal HTML -->
	<div class="modal fade" id="dlg_info" role="dialog">
	  <div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-body">
				No me ha dado tiempo...
			</div>

			<div class="modal-footer">
			  <button data-dismiss="modal" class="btn btn-danger">Aceptar</button>
			</div>

		</div>
	  </div>
	</div>
	
	
    <script>
		var nActual = 0
		var nPages 	= <?prg return str(nPages) ?>
		var nRows 	= <?prg return str(nRows) ?>
			
		$(document).ready(function(){	
		
			$('#pagination-selection').bootpag({
				total: nPages,
				page: 1,
				maxVisible: 5,
				leaps: true,
				firstLastUse: true,
				first: '←',
				last: '→',
				wrapClass: 'pagination',
				activeClass: 'active',
				disabledClass: 'disabled',
				nextClass: 'next',
				prevClass: 'prev',
				lastClass: 'last',
				firstClass: 'first'
			}).on("page", function(event, nPage ){ 
					LoadPage( nPage );									
			});
			
			LoadPage( 1 )
			
		});
		
		function LoadPage( nPage ) {
		
			$("#dat").html("LOADING...")
			$("#dat").load("controller/data.prg?action=load&page=" + nPage + "&rows=" + nRows);	
			nActual = nPage	
		}
		
		function Info() {

			$('#dlg_info').modal('show');
		}
		
		function Delete( n ) {
		
			if ( confirm( 'Ejecutar ?' ) ) {
			
				$.get("controller/data.prg?action=delete&recno=" + n, function(data, status){

					LoadPage( nActual )
					
				});	
			}
		}		
		
    </script>
	
</body>
</html>
ENDTEXT

RETU NIL

FUNCTION Template( cText )

   local nStart, nEnd, cCode

   while ( nStart := At( "<?prg", cText ) ) != 0
      nEnd = At( "?>", SubStr( cText, nStart + 5 ) )
      cCode = SubStr( cText, nStart + 5, nEnd - 1 )
      cText = SubStr( cText, 1, nStart - 1 ) + Replace( cCode ) + SubStr( cText, nStart + nEnd + 6 )
   end 
   
RETU cText

FUNCTION Replace( cCode )

RETU Execute( "function __Inline()" + HB_OsNewLine() + cCode )   

#include '/var/www/html/browse/model/tsistema.prg'
#include '/var/www/html/browse/model/tcustomer.prg'
