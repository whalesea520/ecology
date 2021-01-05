<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />
<html>
<%	
String trainid = request.getParameter("trainid");
boolean isOperator = TrainComInfo.isOperator(trainid,""+user.getUID());
boolean isActor = TrainComInfo.isActor(trainid,""+user.getUID());
boolean isFinish = TrainComInfo.isFinish(trainid);
String qname = Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#weaver").submit();
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainTestAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16143,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainTestEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16143,user.getLanguage())%>";
	}
	url+="&trainid=<%=trainid%>";
	dialog.Width = 600;
	dialog.Height = 303;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6106,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isOperator&&!isFinish){//只有培训创建人与组织人才能新建考核
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=frmMain action="HrmTrainTest.jsp" method=post >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(isOperator&&!isFinish){//只有培训创建人与组织人才能新建考核 %>
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%} %>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="40%">
  <TBODY>
   <tr class=HeaderForXtalbe>
   <TH><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%> </TH>
   <TH><%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%></TH>    
   <TH><%=SystemEnv.getHtmlLabelName(15702,user.getLanguage())%></TH>
   <TH><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></TH>
 </tr> 
<%
  String sql = "select * from HrmTrainTest where trainid = "+trainid ;
	if(qname.length()>0)sql += " and exists (select * from hrmresource where id = resourceid and lastname like '%"+qname+"%')"; 
				sql += " order by testdate";
				
  rs.executeSql(sql);
  while(rs.next()){
    String resourceid = rs.getString("resourceid");
    if(!isOperator &&!ResourceComInfo.isManager(user.getUID(),resourceid)&&!resourceid.equals(""+user.getUID()))
      continue;
    int result = Util.getIntValue(rs.getString("result"),1);
    String testdate = rs.getString("testdate");
    String explain = rs.getString("explain");
%>
  <tr class=DataLight>
    <td>
     <%=ResourceComInfo.getResourcename(resourceid)%>
    </td>
    <td>
	 <%if(isOperator&&!isFinish){%>
	 <a href="javascript:openDialog('<%=rs.getString("id")%>')">	<%}%>
     <%if(result==0){%><%=SystemEnv.getHtmlLabelName(16130,user.getLanguage())%> <%}%>
     <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(16131,user.getLanguage())%>  <%}%>
     <%if(result==2){%><%=SystemEnv.getHtmlLabelName(821,user.getLanguage())%>   <%}%>
     <%if(result==3){%><%=SystemEnv.getHtmlLabelName(824,user.getLanguage())%>   <%}%>
	  <%if(isOperator&&!isFinish){%></a><%}%>
    </td>
    <td>
     <%=testdate%>
    </td>
    <td>
      <%=explain%>
    </td>
  </tr>
<%    
  }
%>          
 </TBODY>
</TABLE> 
<input class=inputstyle type="hidden" name=operation> 
<input class=inputstyle type=hidden name=trainid id=trainid value=<%=trainid%>>
</form>

 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub
</script>
 
</BODY>
 <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
