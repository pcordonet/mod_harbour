
STATIC FUNCTION InitQuery()
				
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
	
	IF hb_HHasKey( hParam, lower(cKey) )
		uValue := hParam[ cKey ]
	ELSE
		uValue := hb_default( @uDefault, '' )
	ENDIF

RETU uValue
