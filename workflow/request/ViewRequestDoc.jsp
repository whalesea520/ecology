
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<%
String requestid = Util.null2String(request.getParameter("requestid"));
int desrequestid= Util.getIntValue(request.getParameter("desrequestid"),0) ;
String isrequest = Util.null2String(request.getParameter("isrequest"));
int wflinkno=Util.getIntValue(request.getParameter("wflinkno"));
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
int usertype = 0;
//TopTitle.jsp 页面参数
String status=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"status"));
String workflowname=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"workflowname"));
String requestmark=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestmark"));
int urger=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"urger"),0);
int ismonitor=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"ismonitor"),0);
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(648,user.getLanguage())+":"
	                +SystemEnv.getHtmlLabelName(553,user.getLanguage())+" - "+Util.toScreen(workflowname,user.getLanguage()) + " - " +  status + " "+requestmark ;



String needfav ="1";
String needhelp ="";
%>
<script language=javascript>
  function protectCreatorFlow(){
        event.returnValue="<%=SystemEnv.getHtmlLabelName(18674,user.getLanguage())%>";
   }
 function resetbanner(objid,typeid){
 			/**added by cyril on 2008-07-02 for TD:8921**/
		 	try{
		 		document.getElementById("iframes").contentWindow.document.getElementById("onbeforeunload_protectDoc").click();
		 		if(document.getElementById("iframes").contentWindow.document.getElementById("onbeforeunload_protectDoc_return").value=='0') {
		 			return;
		 		}
		 		document.getElementById("iframes").contentWindow.document.body.onbeforeunload = null;
		 	}
		 	catch(e){}
		 	/**end added by cyril on 2008-07-02 for TD:8921**/
  	for(i=0;i<=1;i++){
  		document.all("oTDtype_"+i).background="/images/tab2_wev8.png";
  		document.all("oTDtype_"+i).className="cycleTD";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2_wev8.png";
  	document.all("oTDtype_"+objid).className="cycleTDCurrent";
    var o = document.iframes.document;
     if (objid=="0")
    {
    o.location="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%>&isrequest=<%=isrequest%>&fromFlowDoc=1&isovertime=<%=isovertime%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>&wflinkno=<%=wflinkno%>";
    }
    else
    
    {
    //alert(document.getElementById("iframes").contentWindow.document.getElementById("createdoc").id);
    //document.getElementById("iframes").contentWindow.document.getElementById("createdoc").click();
	    try{
	    document.getElementById("iframes").contentWindow.document.body.onbeforeunload = null;//by cyril on 2008-06-27 for td:8828
			document.getElementById("iframes").contentWindow.document.getElementById("createdoc").click();
		}catch(e){
			alert("<%=SystemEnv.getHtmlLabelName(20990,user.getLanguage())%>");
			document.all("oTDtype_1").background="/images/tab2_wev8.png";
			document.all("oTDtype_1").className="cycleTD";
			document.all("oTDtype_0").background="/images/tab.active2_wev8.png";
			document.all("oTDtype_0").className="cycleTDCurrent";
		}
    }
    
  }
function setgwwtableheight(){
    var totalheight=5;
    if(document.all("divTopTitle")!=null){
        totalheight+=document.all("divTopTitle").clientHeight;
    }
    document.all("gww_table").height=document.body.clientHeight-totalheight;
}
function window.onresize(){
	setgwwtableheight();
}
 </script>
<body  style="overflow:auto" onload="setgwwtableheight()">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%%>
<table width=100% border="0" height="95%" cellspacing="0" cellpadding="0" id="gww_table">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>	<td valign="top">
<!--请求的标题开始 -->
<DIV align="center">
<font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
</DIV>
<!--请求的标题结束 -->
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="60">

<form name=weaver id=weaver>
<input type="hidden" name="requestIdDoc">
 <table style="width:100%;height:100%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
		</colgroup>
  <TBODY>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent" nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2_wev8.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="resetbanner(0,0)">
	  <b><%=SystemEnv.getHtmlLabelName(21618,user.getLanguage())%></b></td>
	  <td class="cycleTD" nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2_wev8.png" width=79px align=center onmouseover="style.cursor='hand'"  onclick='if (	document.all("oTDtype_1").className=="cycleTD")  resetbanner(1,1)'>
	  <b><%=SystemEnv.getHtmlLabelName(21619,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	  <tr>
		 <td  colspan="5" style="padding:0;">
		 <iframe src="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isrequest=<%=isrequest%>&desrequestid=<%=desrequestid%>&fromFlowDoc=1&isovertime=<%=isovertime%>&urger=<%=urger%>&ismonitor=<%=ismonitor%>&wflinkno=<%=wflinkno%>" ID="iframes" name="iframes" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
		</td></tr>
		</TBODY>
	  </table>



</form>

 
</td>
</tr>

</table>
</td></tr></table>
</td><td></td></tr></table>
</body>