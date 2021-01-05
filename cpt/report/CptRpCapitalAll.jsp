<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rsouter" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsinner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalAssortmentRoots" class="weaver.cpt.report.CapitalAssortmentRoots" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String userid =""+user.getUID();

/*权限判断,资产管理员以及其所有上级*/
boolean canView = false;
ArrayList allCanView = new ArrayList();
String sql = "select resourceid from HrmRoleMembers where roleid = 7 ";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	String tempid = RecordSet.getString("resourceid");
	allCanView.add(tempid);
	AllManagers.getAll(tempid);
	while(AllManagers.next()){
		allCanView.add(AllManagers.getManagerID());
	}
}// end while

for (int i=0;i<allCanView.size();i++){
	if(userid.equals((String)allCanView.get(i))){
		canView = true;
	}
}

if(!canView) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1438,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>


<TABLE class=ListShort>
  <COLGROUP>
  <COL width="9%"><COL width="9%"><COL width="9%"><COL width="9%"><COL width="9%">
  <COL width="9%"><COL width="9%"><COL width="9%"><COL width="9%"><COL width="9%"><COL width="10%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=11><%=SystemEnv.getHtmlLabelName(1438,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=11 ></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(1443,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1444,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1445,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1446,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1447,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1448,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1449,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(1450,user.getLanguage())%></TD>  
  </TR>
 <% 
 CapitalAssortmentRoots.setRootAssortmentList();
 
 boolean outer = false;
 boolean inner = false;
  rsouter.executeProc("CptCapitalAssortment_SRoot","") ;
  while(rsouter.next()){
  	String tempidouter = Util.null2String(rsouter.getString("id"));
// 	out.print("tempidouter:"+tempidouter);
 	ArrayList leafArray = CapitalAssortmentRoots.getAllLeafIds(tempidouter);
// 	out.print("leafArray:"+leafArray);
 	for(int i=0;i<leafArray.size();i++){
 		String tempidinner = (String)leafArray.get(i);
 		rsinner.executeProc("CptCapital_SByCapitalGroupID",tempidinner);
 		while(rsinner.next()){
 		    String tempcapitalid = Util.null2String(rsinner.getString("id"));
 		    String tempcapitalmark = Util.toScreen(rsinner.getString("mark"),user.getLanguage());
 		    String tempcapitalname = Util.toScreen(rsinner.getString("name"),user.getLanguage());
 		    String tempcapitalspec = Util.toScreen(rsinner.getString("capitalspec"),user.getLanguage());
 		    String tempcapitalprice = Util.toScreen(rsinner.getString("startprice"),user.getLanguage());
 		    String tempcapitalnum = Util.toScreen(rsinner.getString("capitalnum"),user.getLanguage());
 		    String tempcapitalstate = Util.toScreen(rsinner.getString("stateid"),user.getLanguage());
 		    String tempresourceid = Util.toScreen(rsinner.getString("resourceid"),user.getLanguage());
 		    
 		    String temptotal = ""+Util.getFloatValue(tempcapitalprice)*Util.getIntValue(tempcapitalnum,0);
 		    
 %>
 <TR class=DataLight>
 	<TD class=Field valign="top" <%if(false){%>style="display:none"<%}%>>
 	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(tempidouter),user.getLanguage())%>
 	</TD>
 	<TD class=Field valign="top" <%if(false){%>style="display:none"<%}%>>
 	<%if(!tempidinner.equals(tempidouter)){%>
 	<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(tempidinner),user.getLanguage())%>
 	<%}%>
 	</TD>
    <TD class=Field><%=tempcapitalmark%></TD>
    <TD class=Field><A href="../capital/CptCapital.jsp?id=<%=tempcapitalid%>"><%=tempcapitalname%></TD>
    <TD class=Field><%=tempcapitalspec%></TD>
    <TD class=Field><%=tempcapitalprice%></TD>
    <TD class=Field><%=tempcapitalnum%></TD>
    <TD class=Field><%=temptotal%></TD>
    <TD class=Field><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(tempcapitalstate),user.getLanguage())%></TD>
    <TD class=Field><A href="../../hrm/resource/HrmResource.jsp?id=<%=tempresourceid%>">
		<%=Util.toScreen(ResourceComInfo.getResourcename(tempresourceid),user.getLanguage())%>
		</A>
	</TD>
    <TD class=Field><%=temptotal%></TD>
 </TR>
 <%
 		}//end of rsinner
	  }//end of leaf for
	}//end of rsouter
 %>
  
 </TBODY>
</TABLE>
 
</BODY></HTML>
