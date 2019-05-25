#include '/var/www/html/include/hbclass.ch'

CLASS TCustomer

	DATA cDescription INIT 'Customer (Harbour)'
	DATA cAlias
	DATA nFields

	METHOD  New() CONSTRUCTOR
	METHOD  GetPage( nPage, nRows )	
	METHOD  GetFields()	
	METHOD  Delete( n )	
	METHOD  RecCount() 					INLINE (::cAlias)->( RecCount() )	

ENDCLASS

METHOD New() CLASS TCustomer

	Set( _SET_DELETED, .F. )

	USE ( '/var/www/html/data/customer.dbf' ) SHARED NEW
	
	::cAlias 	:= Alias()
	::nFields 	:= (::cAlias)->( FCount() )

RETU Self

METHOD GetPage( nPage, nRows ) CLASS TCustomer

	LOCAL nRecno
	LOCAL nRead   	:= 0
	LOCAL aReg   	:= {}
	LOCAL aRows  	:= {}

	hb_default( @nPage, 1 )
	hb_default( @nRows, 5 )
	
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


