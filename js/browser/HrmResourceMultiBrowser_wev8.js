/**
'*********************************
'Show the multi hrm resources selecting browser.
'@author	lupeng
'@version	04/08/12
'*********************************

'****************************************************************************************
'Show the multi hrm resources selecting browser, not needed.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected reqeusts' name.
'****************************************************************************************
**/
function onShowMultiHrmResource(inputname, spanname){
	onShowMultiHrmResourceBase(inputname, spanname, false)
}

/**
'****************************************************************************************
'Show the multi hrm resources selecting browser, needed.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected hrm resources' name.
'****************************************************************************************
**/
function onShowMultiHrmResourceNeeded(inputname, spanname){
	onShowMultiHrmResourceBase(inputname, spanname, true)
}

/**
'****************************************************************************************
'Show the multi hrm resources selecting browser, the base function.
'@param	inputname	the hidden or not input object name, it stores the selected hrm resources' id.
'@param	spanname	the span object name, it shows the selected hrm resources' name.
'@param	needed		the flag that whether or not to need input.
'****************************************************************************************
**/
function onShowMultiHrmResourceBase(inputname, spanname, needed){
	var linkurl="javaScript:openhrm(";
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+$("input[name="+inputname+"]").val());
	   if (datas) {
            if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href=\"/hrm/resource/HrmResource.jsp?id="+ids[i]+"\"  target='_blank'>"+names[i]+"</a>&nbsp;";
				    	
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id.indexOf(",")!=0?datas.id:datas.id.substring(1));
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
