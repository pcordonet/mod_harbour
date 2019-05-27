#include '/var/www/html/include/hbclass.ch'

CLASS TCustomer

	DATA cDescription 	INIT 'Customer (Harbour)'
	DATA cFile 			INIT '/var/www/html/data/customer.dbf'
	DATA cAlias
	DATA nFields

	METHOD  New() CONSTRUCTOR
	METHOD  GetPage( nPage, nRows )	
	METHOD  GetFields()	
	METHOD  FieldName( n )				INLINE (::cAlias)->( FieldName( n ) )
	METHOD  FieldGet( n )				INLINE (::cAlias)->( FieldGet( n ) )
	METHOD  Delete( n )	
	METHOD  RecCount() 					INLINE (::cAlias)->( RecCount() )	
	METHOD  Info() 						

ENDCLASS

METHOD New( nRecno ) CLASS TCustomer
	

	Set( _SET_DELETED, .F. )

	USE ( ::cFile ) SHARED NEW
	
	::cAlias 	:= Alias()
	::nFields 	:= (::cAlias)->( FCount() )
	
	IF valtype( nRecno ) == 'N'
		(::cAlias)->( DbGoto( nRecno ) )
	ENDIF

RETU Self

METHOD GetPage( nPage, nRows ) CLASS TCustomer

	LOCAL nRecno
	LOCAL nRead   	:= 0
	LOCAL aReg   	:= {}
	LOCAL aRows  	:= {}

	zb_default( @nPage, 1 )
	zb_default( @nRows, 5 )
	
	nRecno	:= Max( ((  nPage - 1 ) * nRows ) + 1 , 1 )
	
	(::cAlias)->( DbGoTo( nRecno ) )
	
	WHILE ( (::cAlias)->( !Eof() ) .and. nRead++ < nRows ) 
	
		aReg := {}
		
		Aadd( aReg, (::cAlias)->( Recno()) )
		Aadd( aReg, (::cAlias)->( Deleted() ) )
		
		FOR nI := 1 TO ::nFields		
			Aadd( aReg, (::cAlias)->( FieldGet( nI )) ) 
		NEXT	

		Aadd( aRows, aReg )

		( ::cAlias)->( DbSkip() )

	END 

RETU aRows

METHOD GetFields() CLASS TCustomer

	LOCAL aFields  	:= {}
	LOCAL nI
	
	FOR nI := 1 TO ::nFields
		Aadd( aFields, (::cAlias)->( FieldName( nI ) ) )	
	NEXT
	
RETU aFields

METHOD Delete( n ) CLASS TCustomer

	(::cAlias)->( DbGoTo( n ) )
	
	IF ( (::cAlias)->( Rlock() ) )
	
		IF ( ::cAlias)->( Deleted() )	
			(::cAlias)->( DbRecall() )
		ELSE
			(::cAlias)->( DbDelete() ) 
		ENDIF
		
		(::cAlias)->( DbUnlock() )

	ENDIF

RETU NIL

METHOD Info() CLASS TCustomer

	LOCAL aInfo := {=>}
	LOCAL aFile := Directory( ::cFile )
	
	aInfo['file'] := ::cFile
	aInfo['size'] := aFile[1][2]
	aInfo['reccount'] := ::RecCount()


RETU aInfo
