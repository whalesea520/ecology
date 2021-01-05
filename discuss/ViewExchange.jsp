
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<%
String types=Util.null2String(request.getParameter("types"));
String sortid=Util.null2String(request.getParameter("sortid"));
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
boolean isLight = false;
String types_prj=Util.null2String(request.getParameter("types_prj"));
%>
<HTML><HEAD>
<%if(isfromtab) {%>
<base target='_blank'/>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(2251,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(types.equals("PP")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/data/ViewProject.jsp?ProjID="+sortid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;};

%>
<%
if(types.equals("CC")){
if(!isfromtab){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/CRM/data/ViewCustomer.jsp?CustomerID="+sortid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep;;
%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>	
<%}
}else{
	%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%
}

%>
<%
if(types.equals("PT")&&types_prj.equals("1")) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/ViewTask.jsp?taskrecordid="+sortid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;};



%>
<%
if(types.equals("PT")&&types_prj.equals("2")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/process/ViewTask.jsp?taskrecordid="+sortid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;};



%>

<%
if(types.equals("MP")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/meeting/data/ProcessMeeting.jsp?meetingid="+sortid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;};



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
		<%if(!isfromtab){ %>
		<TABLE class=Shadow>
		<%}else{ %>
		<TABLE width='100%'>
		<%} %>
		<tr>
		<td valign="top">

  <TABLE class=ListStyle>
        <COLGROUP>
		<COL width="15%">
  		<COL width="15%">
  		<COL width="70%">
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
          
	    </TR>
		<TR class=Line ><TD colSpan=3 style="padding: 0px"></TD></TR> 
<%
 isLight = false;
char flag0=2;

RecordSetEX.executeProc("ExchangeInfo_SelectBID",sortid+flag0+types);
while(RecordSetEX.next())
{

		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD><%=RecordSetEX.getString("createDate")%></TD>
          <TD><%=RecordSetEX.getString("createTime")%></TD>
          <TD>
			<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
			<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
			<%}else{%>
			<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
			<%}%>
		  </TD>
        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toHtml(RecordSetEX.getString("remark"))%></TD>

        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  "";
		docids_0 = "2".equals(types_prj) ? Util.null2String(RecordSetEX.getString("relateddoc")) : Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();

            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" ";               
            }
        }
        
 %>
     <td ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>: </td> <td  colSpan=2> <%=docsname%></td>
         </TR>
        
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
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

</BODY>
</HTML>