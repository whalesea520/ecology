
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

 <form name="docshare" method="post">
  
 </form>
 <SCRIPT LANGUAGE="JavaScript">
 function shareNext(obj){
	
    var sharedocids = _xtable_CheckedCheckboxId();
    if(sharedocids==""){
        alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
        return;
    }

    document.docshare.action="/docs/docs/ShareManageDocTo.jsp?sharedocids="+sharedocids;
    obj.disabled=true;
    document.docshare.submit();
}

 function shareEntire(obj){
	
    
    document.docshare.action="/docs/docs/ShareManageDocTo.jsp?sharedocids=shareentire";
	
		obj.disabled=true;
       document.docshare.submit();

    
}


</SCRIPT>
