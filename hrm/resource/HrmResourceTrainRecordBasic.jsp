<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page"/>
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
</script>
</head>
<%
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
char separator = Util.getSeparator() ;
boolean canedit = HrmUserVarify.checkUserRight("HrmResourceTrainRecordEdit:Edit", user) ;
String paraid = Util.null2String(request.getParameter("paraid")) ;//培训记录ID
String id = Util.null2String(request.getParameter("resourceid")) ;//培训人员ID
String trainrecordid = paraid ;
String traintypeid = Util.null2String(request.getParameter("traintypeid")) ;//培训内容ID

RecordSet.executeProc("HrmTrainRecord_SelectByID",trainrecordid);
RecordSet.next();

String resourceid = Util.null2String(RecordSet.getString("resourceid"));
String trainstartdate = Util.toScreen(RecordSet.getString("trainstartdate"),user.getLanguage());
String trainenddate = Util.toScreen(RecordSet.getString("trainenddate"),user.getLanguage());
String traintype = Util.null2String(RecordSet.getString("traintype"));
int trainrecord = Util.getIntValue(RecordSet.getString("trainrecord"));
int trainhour = (int)RecordSet.getFloat("trainhour");
String trainunit = Util.toScreenToEdit(RecordSet.getString("trainunit"),user.getLanguage());

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(816,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/resource/HrmResourceTrainRecord.jsp?resourceid="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM name=frmain action=HrmResourceTrainRecordOperation.jsp? method=post>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="resourceid" value="<%=resourceid%>">
<input class=inputstyle type="hidden" name="trainrecordid" value="<%=trainrecordid%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
     <wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
     <wea:item><%=ResourceComInfo.getLastname(resourceid)%></wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
     <wea:item><%=trainstartdate%></wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
     <wea:item><%=trainenddate%></wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></wea:item>
     <wea:item><%=Util.toScreen(TrainComInfo.getTrainname(traintype),user.getLanguage())%></wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></wea:item>
     <wea:item>        
       <%if(trainhour==0){%><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%> <%}%>
       <%if(trainhour==1){%> <%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%>  <%}%>
       <%if(trainhour==2){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%>   <%}%>
       <%if(trainhour==3){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>   <%}%>
     </wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></wea:item>
     <wea:item><%=TrainResourceComInfo.getResourcename(trainunit)%></wea:item>
     <wea:item><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%></wea:item>
     <wea:item>        
      <%if(trainrecord==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
      <%if(trainrecord==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
      <%if(trainrecord==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
      <%if(trainrecord==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
      <%if(trainrecord==4){%><%=SystemEnv.getHtmlLabelName(15728,user.getLanguage())%>   <%}%>
     </wea:item>
	</wea:group>
</wea:layout>
</FORM>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<SCRIPT language=VBS>
sub onShowTrainType()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/tools/TrainTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	traintypespan.innerHtml = id(1)
	frmain.traintype.value=id(0)
	else 
	traintypespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	frmain.traintype.value="" 
	end if
	end if
end sub

</SCRIPT>

<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.frmain,"traintype"))
	{	
		document.frmain.operation.value="edit";
		document.frmain.submit();
	}
}
function onDelete(){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        document.frmain.operation.value="delete";
        document.frmain.submit();
		}
}
</script>

</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
