/**
'*********************************
'Show the multi reqeusts selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi reqeusts selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected reqeusts' id.
'@param	spanname	the span object name, it shows the selected reqeusts' name.
'****************************************************************************************
**/
function onShowMultiRequest(inputname, spanname){
	onShowMultiRequestBase(inputname, spanname, false)
}
/**
'****************************************************************************************
'Show the multi reqeusts selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected reqeusts' id.
'@param	spanname	the span object name, it shows the selected reqeusts' name.
'****************************************************************************************
**/
function onShowMultiRequestNeeded(inputname, spanname){
	onShowMultiRequestBase(inputname, spanname, true)
}

/**
'****************************************************************************************
'Show the multi reqeusts selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected reqeusts' id.
'@param	spanname	the span object name, it shows the selected reqeusts' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
**/
function onShowMultiRequestBase(inputname, spanname, needed){
	var data=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	if(data){
		if(data.id){
			ids = data.id.split(",");
		    names =data.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<A href='/workflow/request/ViewRequest.jsp?requestid="+ids[i]+"' target='_blank'>"+names[i]+"</A>&nbsp;";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(data.id.indexOf(",")!=0?data.id:data.id.substring(1));
		}else{
			if(needed){
				$("#"+spanname).html("<IMG src='/images/BacoError.gif' align=absMiddle>");
			}else{
				$("#"+spanname).html("");
			}
		    $("input[name="+inputname+"]").val("");
		}
	}
}