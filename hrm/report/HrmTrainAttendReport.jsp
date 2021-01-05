<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainReportManage" class="weaver.hrm.report.TrainReportManage" scope="page" />
<jsp:useBean id="TrainResourceComInfo" class="weaver.hrm.train.TrainResourceComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String actor = Util.null2String(request.getParameter("actor"));
String startdatefrom = Util.null2String(request.getParameter("startdatefrom"));
String startdateto = Util.null2String(request.getParameter("startdateto"));

String sqlwhere = " where t1.traindayid=t2.id and t2.trainid=t3.id and t1.isattend=1 ";
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;

if(!actor.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t1.resourceid =" + actor +" ";
	}
	else
		sqlwhere += " and t1.resourceid =" + actor +" ";
}

if(!startdatefrom.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where t2.traindate >='" + startdatefrom +"' ";
	}
	else
		sqlwhere += " and t2.traindate >='" + startdatefrom +"' ";
}
if(!startdateto.equals("")){
	if(ishead==0){
        ishead = 1;
        if(rs.getDBType().equals("oracle")){
            sqlwhere += " where (t2.traindate is not null and t2.traindate <='" + startdateto +"') ";
        }else{
            sqlwhere += " where (t2.traindate <> '' and t2.traindate <='" + startdateto +"') ";
		}
	}
	else
        if(rs.getDBType().equals("oracle")){
            sqlwhere += " and (t2.traindate is not null and t2.traindate <='" + startdateto +"') ";
        }else{
            sqlwhere += " and (t2.traindate<>'' and t2.traindate <='" + startdateto +"') ";
		}
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(352,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17535,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
<tr>
<td valign="top">
<form name=frmmain method=post action="HrmTrainAttendReport.jsp">
   <table class=ViewForm>
  <colgroup>
    <col width=10%>
    <col width=20%>
    <col width=10%>
    <col width=56%>
  <tbody>
  <tr>
    <td class=field><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></td>
    <td class=field>
      <INPUT class=wuiBrowser id=actor type=hidden name=actor value="<%=actor%>"
      _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
      _displayText="<%=ResourceComInfo.getLastname(actor)%>"
      >
    </td>
    <td class=field><%=SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field colspan=3>
       <BUTTON type=button class=Calendar id=selectstartdatefrom onclick="getDate(startdatefromspan,startdatefrom)"></BUTTON>
       <SPAN id=startdatefromspan ><%=startdatefrom%></SPAN> -
       <BUTTON type=button class=Calendar id=selectstartdateto onclick="getDate(startdatetospan,startdateto)"></BUTTON>
       <SPAN id=startdatetospan ><%=startdateto%></SPAN>
       <input class=inputStyle type="hidden" name="startdatefrom" value="<%=startdatefrom%>">
       <input class=inputStyle type="hidden" name="startdateto" value="<%=startdateto%>">
    </td>
  </tr>
  <TR style="height:2px"><TD class=Line colSpan=2></TD></TR>

  </tbody>
  </table>
  <table class=ListStyle cellspacing=1 >
  <colgroup>
    <col width=25%>
    <col width=35%>
    <col width=40%>
  <tbody>
    <tr class=header>
      <td><%=SystemEnv.getHtmlLabelName(15761,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
      <td><%=SystemEnv.getHtmlLabelName(678,user.getLanguage())%></td>
    </tr>
    <TR class=Line><TD colspan="3" ></TD></TR>
<%
    int line=0;

    ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(17535,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;

   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(8000) ;

   ExcelRow er = null ;
   er = et.newExcelRow() ;
   er.addStringValue(SystemEnv.getHtmlLabelName(15761,user.getLanguage()),"Header");
   er.addStringValue(SystemEnv.getHtmlLabelName(277,user.getLanguage()),"Header");
   er.addStringValue(SystemEnv.getHtmlLabelName(678,user.getLanguage()),"Header");

  String sql = "SELECT distinct t1.resourceid, t2.traindate, t3.name, t3.id FROM HrmTrainActor t1, HrmTrainDay t2, HrmTrain t3 " + sqlwhere +
          "order by traindate desc";
  rs.executeSql(sql);
  while(rs.next()){
    String resourceid = Util.null2String(rs.getString("resourceid"));
    String traindate = Util.null2String(rs.getString("traindate"));
    String name = Util.null2String(rs.getString("name"));
    String id = Util.null2String(rs.getString("id"));

    ExcelRow erres = et.newExcelRow();
    erres.addStringValue(ResourceComInfo.getLastname(resourceid));
    erres.addStringValue(traindate);
    erres.addStringValue(name);
    if(line==0){
    line = 1;
%>
    <tr class=datalight>
<%}else{
  line=0;
%>
    <tr class=datadark>
<%}%>
      <td><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>"><%=ResourceComInfo.getLastname(resourceid)%></a></td>
      <td><%=traindate%></td>
      <td><a href="/hrm/train/train/HrmTrainEdit.jsp?id=<%=id%>"><%=name%></a></td>
    </tr>
<%
  }
%>
  </tbody>
  </table>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
 <script language=vbs>
sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if NOT isempty(id) then
	    if id(0)<> "" then
            document.all(spanname).innerHtml = id(1)
            document.all(inputname).value=id(0)
		else
            document.all(spanname).innerHtml = ""
            document.all(inputname).value=""
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
function submitData() {
 frmmain.submit();
}
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>