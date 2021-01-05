
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

 <form name="docshare" method="post">
  
 </form>
 <SCRIPT LANGUAGE="JavaScript">
 function shareNext(obj){
 	var sharedocids = _xtable_CheckedCheckboxId();
    if(sharedocids==""){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
        return;
    }
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18037,user.getLanguage())%>";
	dialog.Width = 800;
	dialog.Height = 450;
	dialog.URL = "/docs/tabs/DocCommonTab.jsp?_fromURL=45&urlType=13&sharedocids="+sharedocids;
	dialog.maxiumnable = true;
	dialog.show();
}
</SCRIPT>
