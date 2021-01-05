<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %> 
<%@ include file="/docs/common.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="DocNewsManager" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="DocNewsComInfo" class="weaver.docs.news.DocNewsComInfo" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="JavaScript">
<!--
function change(obj) {
  if(obj.selectedIndex == 0) { return false; }
  urlhtml=obj.options[obj.selectedIndex].value;
  window.location=urlhtml;
  obj.selectedIndex=0;
  return true;
}
//-->
</script>   
</head>
<%
String resourceid = ""+user.getUID();

int userid=user.getUID();
boolean islight=true;
String userseclevel=user.getSeclevel();
String username=Util.toScreen(ResourceComInfo.getResourcename(userid+""),user.getLanguage());
String logintype = ""+user.getLogintype();
String seclevel =  user.getSeclevel() ;
String usertype = ""+user.getType() ;

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1500,user.getLanguage())+"- <a href='/hrm/resource/HrmResource.jsp?id="+userid+"'>"+username+"</a>";
String needfav ="1";
String needhelp ="";

char flag = Util.getSeparator();
int count=0;
String sql="";
String sql1="";
 if(!logintype.equals("2"))  usertype="1" ;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(6062,user.getLanguage())+",/system/homepage/DesignHomePage.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name=frmmain method=post action="HomePage.jsp">
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
			<!--table>
			<tr>
			<%if (!software.equals("ALL")){%>
			<td  width="30" align=center nowrap>
					<a href = "/docs/news/NewsDsp.jsp?id=1"><%=SystemEnv.getHtmlLabelName(316,user.getLanguage())%></a>
			</td>
			<%}%>

			<td  width="90" align=center nowrap>
					<a href = "/workplan/data/WorkPlan.jsp?resourceid=<%=resourceid%>"><%=SystemEnv.getHtmlLabelName(15010,user.getLanguage())%></a>
			</td>
			<td nowrap>
			<%
			Calendar newsnow = Calendar.getInstance();
			String today=Util.add0(newsnow.get(Calendar.YEAR), 4) +"-"+
				Util.add0(newsnow.get(Calendar.MONTH) + 1, 2) +"-"+
					Util.add0(newsnow.get(Calendar.DAY_OF_MONTH), 2) ;
			int year=newsnow.get(Calendar.YEAR);
			int month=newsnow.get(Calendar.MONTH);
			int day=newsnow.get(Calendar.DAY_OF_MONTH);
			//newsnow.clear();
			newsnow.add(Calendar.DATE, -1);

			String yesterday=Util.add0(newsnow.get(Calendar.YEAR), 4) +"-"+
				Util.add0(newsnow.get(Calendar.MONTH) + 1, 2) +"-"+
					Util.add0(newsnow.get(Calendar.DAY_OF_MONTH), 2) ;

			int doccount = 0;
			int doccountMy = 0;
			int doccountNoRead = 0;
			String whereclause = "";

					if(!logintype.equals("2")) {
					   
							whereclause=" where t1.id=t2.sourceid  t1.docstatus in('1','2','5') ";
					}
					else {
							whereclause=" where t1.id=t2.sourceid   and t1.docstatus in('1','2','5') ";
					}

					sql = "select count( t1.id) from DocDetail  t1, "+tables+"  t2 " ;
					sql += whereclause ;
					RecordSet.executeSql(sql);
					if(RecordSet.next())
					doccount=RecordSet.getInt(1);
					
					if(!logintype.equals("2")) {
					   
							whereclause=" where doccreaterid="+userid+" and usertype=1 and docstatus in('1','2','5')  ";
					}
					else {
							whereclause=" where doccreaterid="+userid+" and usertype=9 and docstatus in('1','2','5') ";
					}

					sql1 = "select count(distinct id) from DocDetail " ;
					sql1 += whereclause ;
					//out.print(sql);
					RecordSet.executeSql(sql1);
					if(RecordSet.next())
					doccountMy=RecordSet.getInt(1);	
					
					if(!logintype.equals("2")) {
					   
							whereclause=" where t1.id=t2.sourceid  and t1.docstatus in('1','2','5') and ( t1.doccreaterid != "+userid+" or t1.usertype !='1') and  NOT EXISTS (select 1 from docReadTag where userid="+userid+" and usertype=1 AND docid=T1.ID)";
					}
					else {
							whereclause=" where t1.id=t2.sourceid  and t1.docstatus in('1','2','5') and ( t1.doccreaterid != "+userid+" or t1.usertype !='2') and  NOT EXISTS (select 1 from docReadTag where userid="+userid+" and usertype=2 AND docid=T1.ID)";
					}

					sql = "select count(distinct t1.id) from DocDetail  t1, "+tables+"  t2 " + whereclause ;

					//out.print(sql);

					RecordSet.executeSql(sql);
					if(RecordSet.next())
					doccountNoRead=RecordSet.getInt(1);

			%>

			<%=SystemEnv.getHtmlLabelName(15011,user.getLanguage())%>&nbsp;<IMG src="/images_face/ecologyFace_1/new_wev8.gif" align="middle">:&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15012,user.getLanguage())%><a href="/docs/search/DocSearchTemp.jsp?list=all">(<%=doccount%>)</a><%=SystemEnv.getHtmlLabelName(15013,user.getLanguage())%>,
			&nbsp;<%=SystemEnv.getHtmlLabelName(15014,user.getLanguage())%><a href="/docs/search/DocSearchTemp.jsp?list=all&doccreaterid=<%=userid%>&usertype=<%=usertype%>">(<%=doccountMy%>)</a><%=SystemEnv.getHtmlLabelName(15015,user.getLanguage())%>,&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(15016,user.getLanguage())%><a href="/docs/search/DocSearchTemp.jsp?list=all&isNew=yes&loginType=<%=logintype%>">(<%=doccountNoRead%>)</a><%=SystemEnv.getHtmlLabelName(15015,user.getLanguage())%>
			</td>
			</tr>
			</table-->

			<table class=ViewForm>
				<col width=32%><col width=2><col width=32%><col width=2><col width=32%>
				<tr><td colspan = 5 height = 10></td></tr>
				<tr>
				<td valign=top>
				<%
				sql = "select * from PersonalHomePageDesign where hrmid = " + userid;
				RecordSet.executeSql(sql);
				if (!RecordSet.next()) RecordSet.executeProc("PersonalHPDesign_Duplicate",""+userid);

				sql = "select * from HomePageDesign t1,PersonalHomePageDesign t2 where t2.homepageid = t1.id and t2.hrmid = " + userid + " and t2.ischecked = 0 order by t2.orderid";
				RecordSet.executeSql(sql);
				int iframeheight = 0 ;
				ArrayList iframe =new ArrayList();	
				ArrayList height =new ArrayList();
				ArrayList url =new ArrayList();

				while (RecordSet.next()) 
					{		
			if( !( ((software.equals("HRM") || software.equals("KM")) && (RecordSet.getInt("name")==6059 || RecordSet.getInt("name")==1211 || RecordSet.getInt("name")==6060 || RecordSet.getInt("name")==6061))  ) ){

					iframe.add(RecordSet.getString("iframe"));
					height.add(RecordSet.getString("height"));
					url.add(RecordSet.getString("url"));
			}

					}
				 for(int i=0;i<iframe.size();i+=3){
				%>
				<table width="100%" border = 1 class=ViewForm>
					<tr>
					<td width="100%">		
					<IFRAME 
			name="<%=iframe.get(i)%>" src="<%=url.get(i)%>" width="100%" 
			height="<%=height.get(i)%>" scrolling="<%if (Util.getIntValue((String)height.get(i),0)>30) {%>YES<%} else {%>NO<%}%>" FRAMEBORDER=no>
						<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
				
					</td>
					</tr>		
					</table><BR>
				<%
				}
				%>
				</td>

				<td>&nbsp;</td>

				<td valign=top>
				<%
				for(int i=1;i<iframe.size();i+=3){
				%>
				<table width="100%" border = 1 class=ViewForm>
					<tr>
					<td width="100%">		
					<IFRAME 
			name="<%=iframe.get(i)%>" src="<%=url.get(i)%>" width="100%" 
			height="<%=height.get(i)%>" scrolling="<%if (Util.getIntValue((String)height.get(i),0)>30) {%>YES<%} else {%>NO<%}%>" FRAMEBORDER=no>
						<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
				
					</td>
					</tr>		
					</table><BR>
				<%
				}
				%>

				</td>

				<td>&nbsp;</td>

				<td valign=top>
				<%
				for(int i=2;i<iframe.size();i+=3){
				%>
				<table width="100%" border = 1 class=ViewForm>
					<tr>
					<td width="100%">		
					<IFRAME 
			name="<%=iframe.get(i)%>" src="<%=url.get(i)%>" width="100%" 
			height="<%=height.get(i)%>" scrolling="<%if (Util.getIntValue((String)height.get(i),0)>30) {%>YES<%} else {%>NO<%}%>" FRAMEBORDER=no>
						<%=SystemEnv.getHtmlLabelName(15017,user.getLanguage())%></IFRAME>
				
					</td>
					</tr>		
					</table><BR>
				<%
				}
				%>
				</td>
				</tr>	
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
</form>
</body>
</html>