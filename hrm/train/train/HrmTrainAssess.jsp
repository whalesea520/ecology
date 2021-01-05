<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.train.TrainLayoutComInfo,weaver.conn.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="TrainTypeComInfo" class="weaver.hrm.tools.TrainTypeComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="TrainComInfo" class="weaver.hrm.train.TrainComInfo" scope="page" />

<html>
<%!
/**
* Created By Charoes Huang On June 1,2004 ，For bug 304
* 
*/
private boolean canAddAssess(String id ,String userid){
	  RecordSet rs = new RecordSet();
	  String sql = "select resourceid from HrmTrainAssess where trainid = '"+id+"'";
	  rs.executeSql(sql);
	  while(rs.next()){
		  if(rs.getString("resourceid").equals(userid)){
			  return false;
		  }
	  }
	  return true;
  }

%>
<%	
int userid = user.getUID();
String trainid = request.getParameter("trainid");
boolean isOperator = TrainComInfo.isOperator(trainid,""+user.getUID());
boolean isActor = TrainComInfo.isActor(trainid,""+user.getUID());
boolean isFinish = TrainComInfo.isFinish(trainid);
boolean canAddAssess = canAddAssess(trainid,""+userid);
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
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainAssessAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(16144,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmTrainAssessEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16144,user.getLanguage())%>";
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
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6102,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
 if((!isFinish &&canAddAssess)&&(isActor||isOperator)){//只有参与人、组织人、创建人并且还没有考评的才能考评，参与人只有在设定考评日期的情况下才有权限
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrainEdit.jsp?id="+trainid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmMain method=post >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if((!isFinish &&canAddAssess)&&(isActor||isOperator)){//只有参与人、组织人、创建人并且还没有考评的才能考评，参与人只有在设定考评日期的情况下才有权限%>
				<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<%}%>
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
    <th><%=SystemEnv.getHtmlLabelName(15695,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(15677,user.getLanguage())%></th>    
    <th><%=SystemEnv.getHtmlLabelName(15696,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></th>
  </tr> 
<%
  String sql = "select * from HrmTrainAssess where trainid = "+trainid ;  
  if(qname.length()>0)sql += " and exists (select * from hrmresource where id = resourceid and lastname like '%"+qname+"%')";
  sql +=" order by id";
  rs.executeSql(sql);
  while(rs.next()){
    String resourceid = rs.getString("resourceid");
    if(!isOperator &&!ResourceComInfo.isManager(user.getUID(),resourceid)&&!resourceid.equals(""+user.getUID()))
      continue;
    int result = Util.getIntValue(rs.getString("implement"),2);
    String testdate = rs.getString("assessdate");
    String explain = rs.getString("explain");
%>
  <tr class=DataLight>
    <td>
     <%=ResourceComInfo.getResourcename(resourceid)%>
    </td>
    <td>
     <%if(Util.getIntValue(resourceid,0) == user.getUID() && !isFinish){%>
     <a href="javascript:openDialog('<%=rs.getString("id")%>')">
       <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(result==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(result==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(result==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
     </a>
     <%}else{
     %>
       <%if(result==0){%><%=SystemEnv.getHtmlLabelName(15661,user.getLanguage())%> <%}%>
       <%if(result==1){%> <%=SystemEnv.getHtmlLabelName(15660,user.getLanguage())%>  <%}%>
       <%if(result==2){%><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>   <%}%>
       <%if(result==3){%><%=SystemEnv.getHtmlLabelName(15700,user.getLanguage())%>   <%}%>
       <%if(result==4){%><%=SystemEnv.getHtmlLabelName(16132,user.getLanguage())%>   <%}%>
     <%}%>
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
<input class=inputstyle type=hidden name=trainid value=<%=trainid%>>
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
<script language=javascript>
function dosave(){      
    location="HrmTrainAssessAdd.jsp?trainid=<%=trainid%>";
  } 
 </script>
 
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
