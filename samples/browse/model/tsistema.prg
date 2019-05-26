#define CRLF '<br>'

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
