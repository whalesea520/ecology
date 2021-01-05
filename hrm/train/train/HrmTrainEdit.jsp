<%--
*@Modified By Charoes Huang
*@Date July 9,2004
*@Description For bug  304
--%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.sql.Timestamp" %>

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
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String id = request.getParameter("id");
int userid = user.getUID();
  String name = "";
  String planid = "";
  String organizer = "";
  String startdate="";
  String enddate = "";
  String content="";
  String aim = "";
  String address = "";
  String resource = "";
  String testdate = "";

int errormsg = 1;

  String sql = "select * from HrmTrain where id = "+id;
  rs.executeSql(sql);

  while(rs.next()){
     errormsg = 0;
     name = Util.null2String(rs.getString("name"));
     planid = Util.null2String(rs.getString("planid"));
     organizer = Util.null2String(rs.getString("organizer"));
     startdate = Util.null2String(rs.getString("startdate"));
     enddate = Util.null2String(rs.getString("enddate"));
     content = Util.null2String(rs.getString("content"));
     aim = Util.null2String(rs.getString("aim"));
     address = Util.null2String(rs.getString("address"));
     resource = Util.null2String(rs.getString("resource_n"));
     testdate = Util.null2String(rs.getString("testdate"));
  }
  boolean isOperator = TrainComInfo.isOperator(id,""+userid);
  boolean isActor = TrainComInfo.isActor(id,""+userid);
  boolean isFinish = TrainComInfo.isFinish(id);
  boolean canView = false;
  if(HrmUserVarify.checkUserRight("HrmTrainEdit:Edit", user)){
   canView = true;
  }
  if(TrainPlanComInfo.isViewer(planid,""+userid)){
    canView = true;
  }
  boolean isActorManager = TrainComInfo.isActorManager(id,""+userid);
  if(!canView&& !isOperator &&!isActor&&!isActorManager){
  response.sendRedirect("/notice/noright.jsp");
  return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(89,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isOperator&&!isFinish){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(16148,user.getLanguage())+",javascript:addactor(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if((isOperator||isActor||isActorManager)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16143,user.getLanguage())+",javascript:dotest(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if((isOperator||((isActor||isActorManager)))){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16144,user.getLanguage())+",javascript:doassess(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(isOperator){
 if(!isFinish){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(405,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+",javascript:dofinish(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
 }else{
    RCMenu += "{"+SystemEnv.getHtmlLabelName(6135,user.getLanguage())+",javascript:dofinish(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
 }
}

/*
//Commented By Charoes Huang On July 9,2004 For bug 304
if(isOperator&&!isFinish&&nowdate.equals(testdate)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16149,user.getLanguage())+",javascript:doinfo(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
*/
if(HrmUserVarify.checkUserRight("HrmTrain:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+83+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
if(isOperator&&!isFinish){
RCMenu += "{"+SystemEnv.getHtmlLabelName(16151,user.getLanguage())+",javascript:addtrainday(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">

<FORM id=weaver name=frmMain action="TrainOperation.jsp" method=post >
<%if(errormsg == 1){%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlLabelName(16147,user.getLanguage())%>
</div>
<% } %>

<TABLE class=ViewForm>
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=Title>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6136,user.getLanguage())%></TH></TR>
  <TR class=Spacing style="height:2px">
    <TD class=Line1 colSpan=2 ></TD>
  </TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD class=Field>
            <%=name%>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
          <TD class=Field>
	       	 <%=TrainPlanComInfo.getTrainPlanname(planid)%>
          </TD>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16141,user.getLanguage())%> </td>
          <td class=Field>
	      <%=ResourceComInfo.getMulResourcename(organizer)%>
	  </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=Field>
            <%=startdate%></SPAN>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=Field>
            <%=enddate%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></td>
          <td class=Field>
            <%=content%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(16142,user.getLanguage())%> </td>
          <td class=Field>
            <%=aim%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></TD>
          <TD class=Field><%=address%>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(15879,user.getLanguage())%></TD>
          <TD class=Field>
            <%=TrainResourceComInfo.getResourcename(resource)%>
          </td>
        </TR>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(6102,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15781,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
          <td class=Field>
            <%=testdate%>
          </td>
        </tr>
        <TR style="height:1px"><TD class=Line colSpan=2></TD></TR>
  </TBODY>
</TABLE>
<table class=ListStyle cellspacing=1 >
 <COLGROUP>
  <COL width="20%">
  <COL width="40%">
  <COL width="40%">
 <tbody>
   <TR class=header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16150,user.getLanguage())%></TH>
   </TR>
     <tr class=header>
     <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></td>
     <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
     <td><%=SystemEnv.getHtmlLabelName(2187,user.getLanguage())%></td>
   </tr>
   <TR class=Line><TD colspan="3" ></TD></TR>
<%
 sql = "select * from HrmTrainDay where trainid = "+id+" order by traindate";
 rs.executeSql(sql);
 while(rs.next()){
   String dayid = rs.getString("id");
   String day = rs.getString("traindate");
%>
   <tr>
     <td class=Field>
       <img <%%>src="/images/project_rank2_wev8.gif"<%%>class="project_rank"  onmouseup='rankclick("infodiv<%=dayid%>",event)'>
<%
if(isOperator){
%>
       <%if(isOperator){%><a href="HrmTrainDayEdit.jsp?id=<%=dayid%>"><%}%>
<%
}
%>
       <%=day%>
       </a>
     </td>
   </tr>
   <tr>
    <td colspan=3>
    <div id=infodiv<%=dayid%> style="display:none">
     <TABLE class=ViewForm>
     <COLGROUP>
      <COL width="20%">
      <COL width="40%">
      <COL width="40%">
<%
  sql = "select * from HrmTrainActor where traindayid = "+dayid;
  rs2.executeSql(sql);
  while(rs2.next()){
    String isattend = rs2.getString("isattend");
%>
    <tr>
      <td class=Field>&nbsp</td>
      <td class=Field><%=ResourceComInfo.getResourcename(rs2.getString("resourceid"))%></td>
      <td class=Field>
        <%if(isattend.equals("1")){%><%=SystemEnv.getHtmlLabelName(2195,user.getLanguage())%><%}%>
        <%if(isattend.equals("0")){%><%=SystemEnv.getHtmlLabelName(16135,user.getLanguage())%><%}%>
      </td>
    </tr>
<%
  }
%>
      </TABLE>
     </div>
    </td>
   </tr>
<%
 }
%>
 </tbody>
</table>

<input class=inputstyle type="hidden" name=operation>
<input class=inputstyle type="hidden" name=id value=<%=id%>>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
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

sub onShowTrainResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/train/trainresource/HrmTrainResourceBrowser.jsp")
	if Not isempty(id) then
	if id(0)<> 0 then
	resourcespan.innerHtml = id(1)
	frmMain.resource.value=id(0)
	else
	resourcespan.innerHtml = ""
	frmMain.resource.value=""
	end if
	end if
end sub

</script>
<script language=javascript>
function dosave(){
location="HrmTrainEditDo.jsp?id=<%=id%>";
  }
function doinfo(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>")){
    document.frmMain.operation.value="info";
    document.frmMain.submit();
   }
  }
function addactor(){
    location="HrmTrainActorAdd.jsp?trainid=<%=id%>";
  }
function dotest(){
    location="HrmTrainTest.jsp?trainid=<%=id%>";
  }
function doassess(){
    location="HrmTrainAssess.jsp?trainid=<%=id%>";
  }
function dofinish(){
  if(!<%=isFinish%>){
    location="HrmTrainFinish.jsp?id=<%=id%>";
  }else{
    location="HrmTrainFinishView.jsp?id=<%=id%>";
  }
  }
function addtrainday(){
    location="HrmTrainDayAdd.jsp?trainid=<%=id%>";
  }
function rankclick(targetId,event)
{
	event = $.event.fix(event);
  	var objSrcElement = event.target;
    if (jQuery("#targetId")==null) {
           objSrcElement.src = "/images/project_rank1_wev8.gif";

	} else {
         var targetElement = $GetEle(targetId);

          if (targetElement.style.display == "none")
		{

             objSrcElement.src = "/images/project_rank1_wev8.gif";
             targetElement.style.display = "";
		}
            else
		{
             objSrcElement.src = "/images/project_rank2_wev8.gif";
             targetElement.style.display = "none";
		}
	}

}

function submitData() {
 frmMain.submit();
}
 </script>
 </BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 </HTML>