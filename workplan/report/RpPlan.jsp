
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.teechart.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language=javascript src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>
<%
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String userid =""+user.getUID();


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15524,user.getLanguage());
String needfav ="1";
String needhelp ="";

//modify this file in 2004.05.21 by lupeng for TD489.
String resourceId = Util.null2String(request.getParameter("resourceid"));
String accepterId = Util.null2String(request.getParameter("accepterid"));
String begindate = Util.null2String(request.getParameter("begindate"));
String enddate = Util.null2String(request.getParameter("enddate"));
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(15353,user.getLanguage())+",javascript:onSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM method="post" name="frmain">

<TABLE width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
<TR>
	<TD></TD>
	<TD valign="top">
		<TABLE class="Shadow">
		<TR>
		<TD valign="top">


  <TABLE border="0" cellPadding="0" cellSpacing="0" width="100%">
    <TBODY> 
    <TR> 
 <TD vAlign="top" width="84%">
         <TABLE class="viewform">
          <TR> 
            <TD vAlign="top"> 
              <TABLE width="100%">
                <COLGROUP> <COL width="30%"> <COL width="70%"> <TBODY> 
               
                <TR style="height:2px"> 
                  <TD class="Line1" colSpan="2"></TD>
                </TR>
                <TR> 
                  <TD><%=SystemEnv.getHtmlLabelName(787,user.getLanguage())%></TD>
                  <TD class="Field"> 
				    	<INPUT class=wuiBrowser type="hidden" name="resourceid" id="resourceid" value="<%=resourceId%>"
				    	_displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
				    	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				    	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(resourceId),user.getLanguage())%>"
				    	>
    	        </TD>
     
                </TR>  <TR style="height:2px"> 
                  <TD class="Line" colSpan="2"></TD>
                </TR>
                <TR> 
                  <TD><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></TD>
                  <TD class="Field"> 
			    	<INPUT class=wuiBrowser type="hidden" name="accepterid" id="accepterid" value="<%=accepterId%>"
			    	_displayTemplate="<A  target='_blank' href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name} </a>"
			    	_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			    	_displayText="<%=Util.toScreen(ResourceComInfo.getResourcename(accepterId),user.getLanguage())%>"
			    	>
    	         </TD>
     
                </TR><TR style="height:2px"> 
                  <TD class="Line" colSpan="2"></TD>
                </TR>
                <TR> 
                  <TD><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></TD>
                  <TD class="Field"> 
         <BUTTON type=button class="calendar" onClick="getDate(begindatespan,begindate)"></BUTTON> 
         <SPAN class="Inputstyle" id="begindatespan"><%=begindate%></SPAN> 
    	<INPUT type="hidden" name="begindate" id="begindate" value="<%=begindate%>">
    	</TD>
     
                </TR><TR style="height:2px"> 
                  <TD class="Line" colSpan="2"></TD>
                </TR>
                <TR> 
                  <TD><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></TD>
                  <TD class="Field"> 
        <BUTTON type=button class="calendar" onClick='getDate(enddatespan,enddate)'></BUTTON> 
         <SPAN class="Inputstyle" id="enddatespan"><%=enddate%></SPAN> 
    	<INPUT type="hidden" name="enddate" id="enddate"  value="<%=enddate%>"></TD>
     
                </TR><TR style="height:2px"> 
                  <TD class="Line1" colSpan="2"></TD>
                </TR>
                </TBODY> 
              </TABLE>
            </TD>
          </TR>
          </TBODY> 
        </TABLE>
      </TD>
    </TR>
    </TBODY>
  </TABLE>

   <BR>
 <%
/*
   GraphFile.init ();
   GraphFile.setPicwidth ( 500 ); 
   GraphFile.setPichight ( 350 );
   GraphFile.setLeftstartpos ( 30 );
   GraphFile.setHistogramwidth ( 15 );
   GraphFile.setPicquality( (new Float("10.0")).floatValue() ) ;
   GraphFile.setPiclable (SystemEnv.getHtmlLabelName(407,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage()));
   GraphFile.newLine ();
   GraphFile.addPiclinecolor("#660033") ;
   GraphFile.addPiclinelable("Line") ;
*/
	String sql = "" ;
	String sqlwhere = "" ;
	int resultcount = 0 ;
	ArrayList labelname = new ArrayList() ;
	labelname.add(Util.null2String(SystemEnv.getHtmlLabelName(16658,user.getLanguage())));
	labelname.add(Util.null2String(SystemEnv.getHtmlLabelName(555,user.getLanguage())));

	if (!resourceId.equals(""))
		sqlwhere += " AND createrid = " + resourceId;
	
	if (!accepterId.equals("")) {
		if ((rs.getDBType()).equals("oracle"))  
			sqlwhere += " AND ( concat(concat(',',TO_CHAR(resourceid)),',') ) LIKE '%"+(","+accepterId+",")+"%'";
		else
			sqlwhere += " AND (','+CONVERT(varchar(2000), resourceid)+',') LIKE '%"+(","+accepterId+",")+"%'";
	}	
/****************************/
	PieTeeChart pie=TeeChartFactory.createPieChart(Util.null2String(SystemEnv.getHtmlLabelName(16541,user.getLanguage())),550,400,PieTeeChart.SMS_LabelPercent);
	//pie.isDebug();
/****************************/
	if (!begindate.equals("")) sqlwhere += " AND begindate >= '" + begindate + "' " ;
	if (!enddate.equals("")) sqlwhere += " AND begindate <= '" + enddate + "' " ;
    String colors=GraphFile.red;
	for (int i = 0; i < labelname.size(); i++) {
		sql = "SELECT COUNT(id) resultcount FROM WorkPlan " ;
		sql += " WHERE status ='" + i +"' " ;  
		sql += sqlwhere ;
	//if(i>0) colors=GraphFile.orange;
		rs.executeSql(sql);
		if (rs.next()) {
			resultcount = Util.getIntValue(rs.getString("resultcount"),0);
			if (resultcount > 0) {
				//GraphFile.addConditionlable((String)labelname.get(i)) ;
				//GraphFile.addPiclinevalues ( ""+resultcount , (String)labelname.get(i) , colors , null  );
				/**************************************/
				pie.addSeries((String)labelname.get(i),resultcount);
			}
		}
	}
 %>
<!--<TABLE class="form">
  <TBODY>     
  <TR> 
    <TD align="center">
        <IMG src="/weaver/weaver.file.GraphOut?pictype=3">
    </TD>
  </TR> 
  <TR> 
    <TD align="center">
        <IMG src="/weaver/weaver.file.GraphOut?pictype=4">
    </TD>
  </TR>    
  </TBODY> 
</TABLE> -->
<div class="chart">
<%
if ("true".equals(isIE)){
	if(pie!=null)pie.print(out);
}else{   %>
<p height="100%" width="100%" align="center" style="color:red;font-size:14px;">
			<%=SystemEnv.getHtmlLabelName(127876,user.getLanguage())%>
</p>
<%} %>	
</div>
<br/>
  </TD>
		</TR>
		</TABLE>
	</TD>
	<TD></TD>
</TR>
<TR>
	<TD height="10" colspan="3"></TD>
</TR>
</TABLE>

</FORM>
<SCRIPT language="javascript">
function onSearch() {
	document.frmain.action = "RpPlan.jsp";
	document.frmain.submit();
}
</SCRIPT>

<SCRIPT language="VBS">
sub onShowResource(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub
</SCRIPT>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>