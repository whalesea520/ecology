<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(369,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean CanEdit = HrmUserVarify.checkUserRight("HrmResouceScheduleEdit:Edit", user);
String id=Util.null2String(request.getParameter("id"));
String totaltime="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/hrm/schedule/HrmResouceScheduleEdit.jsp?id="+id+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(370,user.getLanguage())+SystemEnv.getHtmlLabelName(371,user.getLanguage())+",/hrm/schedule/HrmPubHoliday.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmResouceScheduleList.jsp,_self} " ;
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
<%
RecordSet.executeProc("HrmSchedule_Select_ByID",id);
while(RecordSet.next()){
%>
<TABLE class=ListStyle cellspacing=1 >
	<COLGROUP>
  	<COL width="30%">
  	<COL width="35%">
  	<COL width="35%">
	<TR class=Title> 
          <TH width="30%"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TH>
          <%
          int Resouce_id=RecordSet.getInt("relatedid");
          String Resouce_name=Util.toScreen(ResourceComInfo.getResourcename(Resouce_id+""),user.getLanguage());
          String dept_id = ResourceComInfo.getDepartmentID(Resouce_id+"");
          String dept_name=Util.toScreen(DepartmentComInfo.getDepartmentname(dept_id),user.getLanguage());
          %>
          <TH width="70%" colspan=2><%=Resouce_name%> - <%=dept_name%></TH>
        </TR>
        <TR class=Header>
    	  <TD><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%></TD>
    	  <TD><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></TD>
    	  <TD><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></TD>
  	</TR>
  	<TR class=datalight>
    	<td><%=SystemEnv.getHtmlLabelName(392,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("monstarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("monendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("monstarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("monendtime2"),user.getLanguage())%></TD>
  	</TR>
  	<TR class=datadark>
    	<td><%=SystemEnv.getHtmlLabelName(393,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("tuestarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("tueendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("tuestarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("tueendtime2"),user.getLanguage())%></TD>
  	</TR>
  	<TR class=datalight>
    	<td><%=SystemEnv.getHtmlLabelName(394,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("wedstarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("wedendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("wedstarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("wedendtime2"),user.getLanguage())%></TD>
  	</TR>
  	<TR class=datadark>
    	<td><%=SystemEnv.getHtmlLabelName(395,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("thustarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("thuendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("thustarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("thuendtime2"),user.getLanguage())%></TD>
  	</TR>
  	<TR class=datalight>
    	<td><%=SystemEnv.getHtmlLabelName(396,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("fristarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("friendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("fristarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("friendtime2"),user.getLanguage())%></TD>
  	</TR>	
  	<TR class=datadark>
    	<td><%=SystemEnv.getHtmlLabelName(397,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("satstarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("satendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("satstarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("satendtime2"),user.getLanguage())%></TD>
  	</TR>
  	<TR class=datalight>
    	<td><%=SystemEnv.getHtmlLabelName(398,user.getLanguage())%></td>
    	<TD><%=Util.toScreen(RecordSet.getString("sunstarttime1"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("sunendtime1"),user.getLanguage())%></TD>
    	<TD><%=Util.toScreen(RecordSet.getString("sunstarttime2"),user.getLanguage())%> - <%=Util.toScreen(RecordSet.getString("sunendtime2"),user.getLanguage())%></TD>
  	</TR>
  	
  	<TR class=TOTAL style="FONT-WEIGHT: bold; COLOR: red">
    	<TD><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></TD>
<!--    	<TD>&nbsp;</TD>-->
    <%
    totaltime=RecordSet.getString("totaltime");
    %>
    	<TD class=FIELD  colspan=2 align=right><%=Util.toScreen(totaltime,user.getLanguage())%></TD>	
  </tr>
</table>
<%
}
%>
<table class=viewform>
  <COLGROUP>
  <COL width="30%">
  <COL width="35%">
  <COL width="35%">
  <TR class=Section> <TH colspan=3><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TH></tr>
  <TR class=Spacing> <TD class=Line1 colspan=3></TD></tr>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(97,user.getLanguage()) +SystemEnv.getHtmlLabelName(16253,user.getLanguage())%></td>
     <%
     	String deftotaltime="";
     	RecordSet.executeProc("HrmSchedule_Select_Default","");
     	RecordSet.next();
     	deftotaltime=RecordSet.getString("totaltime");
     %>
     <td class=field><%=Util.toScreen(deftotaltime,user.getLanguage())%></td>
     <td>&nbsp;</td>
  </tr>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(565,user.getLanguage())%></td>
     <%
        float parameter=1;
        if(!deftotaltime.equals("00:00")){
     	ArrayList timearray =Util.TokenizerString(totaltime,":");
        ArrayList deftimearray =Util.TokenizerString(deftotaltime,":");
        int min=Util.getIntValue((String)timearray.get(1),0);
        int hour=Util.getIntValue((String)timearray.get(0),0);
        int defmin=Util.getIntValue((String)deftimearray.get(1),0);
        int defhour=Util.getIntValue((String)deftimearray.get(0),0);
        parameter=(float)(hour+min/60)/(defhour+defmin/60);
        }
        parameter=(float)((int)(parameter*100))/(float)100;
     %>
     <td class=field><%=parameter%></td>
     <td>&nbsp;</td>
  </tr>    
  
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage()) +SystemEnv.getHtmlLabelName(16253,user.getLanguage())%></td>
     <%
     	String deftotaltimedep="";
     	RecordSet.executeProc("HrmSchedule_Select_DepTotal",ResourceComInfo.getDepartmentID(id));
     	RecordSet.next();
     	deftotaltimedep=Util.null2String(RecordSet.getString("totaltime"));
     	   	
     %>
     <td class=field><%=Util.toScreen(deftotaltimedep,user.getLanguage())%></td>
     <td>&nbsp;</td>
  </tr>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(565,user.getLanguage())%></td>
     <%
        float parameterdep= 1;
        if(!deftotaltimedep.equals("00:00")&&!deftotaltimedep.equals("")){
     	ArrayList timearraydep =Util.TokenizerString(totaltime,":");
        ArrayList deftimearraydep =Util.TokenizerString(deftotaltimedep,":");
        int mindep=Util.getIntValue((String)timearraydep.get(1),0);
        int hourdep=Util.getIntValue((String)timearraydep.get(0),0);
        int defmindep=Util.getIntValue((String)deftimearraydep.get(1),0);
        int defhourdep=Util.getIntValue((String)deftimearraydep.get(0),0);
        parameterdep=(float)(hourdep+mindep/60)/(defhourdep+defmindep/60);
        }
        parameterdep=(float)((int)(parameterdep*100))/(float)100;
        
     %>
     <td class=field><%=parameterdep%></td>
     <td>&nbsp;</td>
  </tr>          
<TR><TD class=Line colSpan=2></TD></TR> 
</table>
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
</body>
</html>