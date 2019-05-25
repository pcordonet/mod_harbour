FUNCTION InitQuery()
				
	STATIC hParameters 	:= { => }
	
	LOCAL cArgs 		:= AP_Args()
	LOCAL cPart
		
	FOR EACH cPart IN hb_ATokens( cArgs, "&" )
	
	   IF ( nI := At( "=", cPart ) ) > 0
		 hParameters[ lower(Left( cPart, nI - 1 )) ] := SubStr( cPart, nI + 1 ) 
	   ELSE
		 hParameters[ lower(cPart) ]:=  NIL 
	   ENDIF
	NEXT	

RETU hParameters

FUNCTION TGet( cKey, uDefault )

	LOCAL hParam := Initquery()
	LOCAL uValue

	zb_default( @cKey, '' )
	zb_default( @uDefault, '' )
	
	cKey := lower( cKey )
	
	IF hb_HHasKey( hParam, cKey )
		uValue := hParam[ cKey ]
	ELSE
		uValue := uDefault
	ENDIF

RETU uValue

/* HB_DEFAULT() no funciona bien */

FUNCTION ZB_Default( pVar, uValue )

	IF Valtype( pVar ) == 'U' 
		pVar := uValue
	ENDIF
	
RETU NIL
