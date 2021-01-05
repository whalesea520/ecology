<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocDetailLog" class="weaver.docs.DocDetailLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String subname="";

String subject= Util.null2String(request.getParameter("docsubject"));	
	
String sqlwhere="";
sqlwhere = Util.fromScreen(request.getParameter("sqlwhere"),user.getLanguage());

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<TABLE class=ListShort>
  <COLGROUP>
  <COL width="15%">
  <COL width="8%">
  <COL width="8%">
  <COL width="10%">
  <COL width="20%">
  <COL width="9%">
  <COL width="10%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=6><%=SystemEnv.getHtmlLabelName(95,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=7 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(110,user.getLanguage())%></TD>
    </TR>
  <%
  DocDetailLog.setSqlWhere(sqlwhere);
  DocDetailLog.setStart(pagenum);
  DocDetailLog.getDocLogInfo();
  int i=0;
  int totalline=0;
  while(DocDetailLog.next()){
  	totalline+=1;
  	if(totalline>perpage)	break;
  	
  	int docid=DocDetailLog.getDocId();
  	int create=DocDetailLog.getDocCreater();
  	String object = DocDetailLog.getDocSubject();
  	String typeid = DocDetailLog.getOperateType();
  	String type="";
  	if(typeid.equals("0"))
  		type=SystemEnv.getHtmlLabelName(260,user.getLanguage());
  	else if(typeid.equals("1"))
  		type=SystemEnv.getHtmlLabelName(82,user.getLanguage());
  	else if(typeid.equals("2"))
  		type=SystemEnv.getHtmlLabelName(103,user.getLanguage());
  	else if(typeid.equals("3"))
  		type=SystemEnv.getHtmlLabelName(91,user.getLanguage());
  	else if(typeid.equals("4"))
  		type=SystemEnv.getHtmlLabelName(142,user.getLanguage());
	else if(typeid.equals("5"))  		
  		type=SystemEnv.getHtmlLabelName(236,user.getLanguage());
  	else if(typeid.equals("6"))  		
  		type=SystemEnv.getHtmlLabelName(244,user.getLanguage());
  	else if(typeid.equals("7"))  		
  		type=SystemEnv.getHtmlLabelName(251,user.getLanguage());
  	else if(typeid.equals("8"))  		
  		type=SystemEnv.getHtmlLabelName(256,user.getLanguage());
  	else if(typeid.equals("9"))  		
  		type=SystemEnv.getHtmlLabelName(220,user.getLanguage());
  	else if(typeid.equals("10"))  		
  		type=SystemEnv.getHtmlLabelName(117,user.getLanguage());
  		
  		
  	int userid = DocDetailLog.getOperateUserid();
  	String logdate = DocDetailLog.getOperateDate() + " " +DocDetailLog.getOperateTime();
  	String clientip = DocDetailLog.getClientAddress();
  	if(i==0){
  		i=1;
  %>  
  <TR class=datalight>
  <%}else{
  		i=0;
  %>
  <TR class=datadark>
  <%}%>
    <TD><%=logdate%></TD>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage())%></TD>
    <TD><%=type%></TD>
    <TD><%=Util.add0(docid,12)%></TD>
    <TD><%=object%></TD>
    <TD><%=Util.toScreen(ResourceComInfo.getResourcename(""+create),user.getLanguage())%></TD>
    <TD><%=clientip%></TD>
    </TR>
   <%}
   RecordSet.executeSql("drop table searchtemp");
   %>
   <tr style="display:none">
   <td colspan=4 >&nbsp;</td>
   <td><%if(pagenum>1){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>    
   <button type='button' class=btn accessKey=P id=prepage onclick="location.href='DocDetailLog.jsp?sqlwhere=<%=sqlwhere%>&pagenum=<%=pagenum-1%>'"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button><%}%></td>
   <td><%if(totalline>perpage){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>     
<button type='button' class=btn accessKey=N id=nextpage onclick="location.href='DocDetailLog.jsp?sqlwhere=<%=sqlwhere%>&pagenum=<%=pagenum+1%>'"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button><%}%></td>
   </tr>
    </TBODY></TABLE>
    </BODY></HTML>
