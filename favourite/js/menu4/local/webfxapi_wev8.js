/*
 *	This script is used for WebFX Api pages
 *
 *	It defines one funtion and includes helptip.js, helptip_wev8.css and webfxapi.css
 */

document.write( "<script type='text/javascript' src='local/helptip_wev8.js'><\/script>" );
document.write( "<link type='text/css' rel='stylesheet' href='local/helptip_wev8.css' />" );
document.write( "<link type='text/css' rel='stylesheet' href='local/webfxapi_wev8.css' />" );

function toggleMethodArguments( e, a ) {
	if ( a && a.nextSibling &&
		typeof a.nextSibling.innerHTML != "undefined" &&
		typeof showHelpTip != "undefined" ) {
	
		showHelpTip( e, a.nextSibling.innerHTML );
		
	}
}
  