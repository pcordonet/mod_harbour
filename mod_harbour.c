/*
**  mod_harbour.c -- Apache harbour module
**  [Autogenerated via ``apxs -n harbour -g'']
*/

#include "httpd.h"
#include "http_config.h"
#include "http_protocol.h"
#include "ap_config.h"
#include "util_script.h"

#ifdef _WINDOWS_
   #include <windows.h>
#else
   #include <dlfcn.h>
#endif        

static request_rec * _r;
static apr_array_header_t * POST_pairs = NULL;

int ap_headers_in_count( void )
{
   return apr_table_elts( _r->headers_in )->nelts;
}

int ap_headers_out_count( void )
{
   return apr_table_elts( _r->headers_out )->nelts;
}

int ap_post_pairs_count( void )
{
   if( POST_pairs != NULL )
      return POST_pairs->nelts;
   else
      return 0;
}

const char * ap_headers_in_key( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( _r->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].key;
   else
      return "";
}

const char * ap_headers_in_val( int iKey )
{
   const apr_array_header_t * fields = apr_table_elts( _r->headers_in );
   apr_table_entry_t * e = ( apr_table_entry_t * ) fields->elts;

   if( iKey >= 0 && iKey < fields->nelts )
      return e[ iKey ].val;
   else
      return "";
}

const char * ap_post_pairs_key( int iKey )
{
   ap_form_pair_t * e;

   if( POST_pairs != NULL )
   {
      e = ( ap_form_pair_t * ) POST_pairs->elts;

      if( iKey >= 0 && iKey < POST_pairs->nelts )
         return e[ iKey ].name;
      else
         return "";
   }
   else
      return "";
}

const char * ap_getenv( const char * szVarName )
{
   return apr_table_get( _r->subprocess_env, szVarName );
}   

const char * ap_post_pairs_val( int iKey )
{
   ap_form_pair_t * e;

   if( POST_pairs != NULL )
   {
      e = ( ap_form_pair_t * ) POST_pairs->elts;

      if( iKey >= 0 && iKey < POST_pairs->nelts )
      {
         apr_off_t len;
         apr_size_t size; 
         char * buffer;

         apr_brigade_length( e[ iKey ].value, 1, &len );
         size = ( apr_size_t ) len;
         buffer = apr_palloc( _r->pool, size + 1 );
         apr_brigade_flatten( e[ iKey ].value, buffer, &size );
         buffer[ len ] = 0;

         return buffer;
      }
      else
         return "";
   }
   else
      return "";
}

void ap_headers_out_set( const char * szKey, const char * szValue )
{
   apr_table_set( _r->headers_out, szKey, szValue );
}

void ap_set_contenttype( const char * szContentType )
{
   char * szType = ( char * ) apr_pcalloc( _r->pool, strlen( szContentType ) + 1 );
   
   strcpy( szType, szContentType );
   
   _r->content_type = szType;
}

const char * ap_body( void )
{
   if( ap_setup_client_block( _r, REQUEST_CHUNKED_ERROR ) != OK )
      return "";

   if( ap_should_client_block( _r ) ) 
   {
      long length = _r->remaining;
      char * rbuf = ( char * ) apr_pcalloc( _r->pool, length + 1 );
         
      ap_get_client_block( _r, rbuf, length + 1 );
      return rbuf;
   }
   else
      return "";
}

#ifdef _WINDOWS_

char * GetErrorMessage( DWORD dwLastError )
{
   LPVOID lpMsgBuf;

   FormatMessage( FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
                  NULL,
                  dwLastError,
                  MAKELANGID( LANG_NEUTRAL, SUBLANG_DEFAULT ), // Default language
                  ( LPTSTR ) &lpMsgBuf,
                  0,
                  NULL );

   return ( ( char * ) lpMsgBuf );
   LocalFree( lpMsgBuf );
}

#endif

typedef int ( * PHB_APACHE )( void * pRequestRec, void * pAPRPuts, 
                              const char * szFileName, const char * szArgs, const char * szMethod, const char * szUserIP,
                              void * pHeadersIn, void * pHeadersOut, 
                              void * pHeadersInCount, void * pHeadersInKey, void * pHeadersInVal, 
                              void * pPostPairsCount, void * pPostPairsKey, void * pPostPairsVal,
                              void * pHeadersOutCount, void * pHeadersOutSet, void * pSetContentType, 
                              void * pApacheGetenv, void * pAPBody );

static int harbour_handler( request_rec * r )
{
   #ifdef _WINDOWS_
      HMODULE lib_harbour = NULL;
   #else
      void * lib_harbour = NULL;
   #endif
   
   PHB_APACHE _hb_apache = NULL;
   int iResult = OK;

   if( strcmp( r->handler, "harbour" ) )
      return DECLINED;

   r->content_type = "text/html";
   _r = r;

   #ifdef _WINDOWS_
      lib_harbour = LoadLibrary( ap_getenv( "LIBHARBOUR" ) ); 
      if( lib_harbour == NULL )
         lib_harbour = LoadLibrary( "c:\\Apache24\\htdocs\\libharbour.dll" );
   #else
      #ifdef DARWIN
         lib_harbour = dlopen( "/usr/local/var/www/libharbour.3.2.0.dylib", RTLD_LAZY );
      #else
         lib_harbour = dlopen( "/var/www/html/libharbour.so.3.2.0", RTLD_LAZY );
      #endif
   #endif

   if( lib_harbour == NULL )
   {
      #ifdef _WINDOWS_
         char * szErrorMessage = GetErrorMessage( GetLastError() );

         ap_rputs( "c:\\Apache24\\htdocs\\libharbour.dll<br>", r ); 
         ap_rputs( szErrorMessage, r );
         LocalFree( ( void * ) szErrorMessage );
      #else
         ap_rputs( dlerror(), r ); 
      #endif
   }   
   else
   {
      ap_add_cgi_vars( r );
      ap_add_common_vars( r );
   
      #ifdef _WINDOWS_
         #ifdef __GNUC__
            _hb_apache = ( PHB_APACHE ) GetProcAddress( lib_harbour, "hb_apache" );
         #else  
            ( ( FARPROC ) _hb_apache ) = GetProcAddress( lib_harbour, "hb_apache" );
         #endif 
      #else
         _hb_apache = dlsym( lib_harbour, "hb_apache" );
      #endif

      if( _hb_apache == NULL )
         ap_rputs( "failed to load hb_apache()", r );
      else
         iResult = _hb_apache( r, ap_rputs, r->filename, r->args, r->method, r->useragent_ip, 
                               r->headers_in, r->headers_out,
                               ( void * ) ap_headers_in_count, ( void * ) ap_headers_in_key, ( void * ) ap_headers_in_val,
                               ( void * ) ap_post_pairs_count, ( void * ) ap_post_pairs_key, ( void * ) ap_post_pairs_val, 
                               ( void * ) ap_headers_out_count, ( void * ) ap_headers_out_set, ( void * ) ap_set_contenttype,
                               ( void * ) ap_getenv, ( void * ) ap_body );
   }

   if( lib_harbour != NULL )
      #ifdef _WINDOWS_	
         FreeLibrary( lib_harbour );
      #else
         dlclose( lib_harbour );
      #endif      

   return iResult;
}

static void harbour_register_hooks( apr_pool_t * p )
{
    ap_hook_handler( harbour_handler, NULL, NULL, APR_HOOK_MIDDLE );
}

/* Dispatch list for API hooks */
module AP_MODULE_DECLARE_DATA harbour_module = {
    STANDARD20_MODULE_STUFF,
    NULL,                  /* create per-dir    config structures */
    NULL,                  /* merge  per-dir    config structures */
    NULL,                  /* create per-server config structures */
    NULL,                  /* merge  per-server config structures */
    NULL,                  /* table of config file commands       */
    harbour_register_hooks  /* register hooks                      */
};
