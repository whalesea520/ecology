
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetI" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
RecordSetShare.executeProc("CRM_ShareInfo_SbyRelateditemid",CustomerID);
boolean canedit=false;
int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){

     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
        
     }
}

%>

			  <TABLE class=ViewForm>
		        <COLGROUP>
				<COL width="30%">
		  		<COL width="60%">
		  		<COL width="10%">
		  		</COLGROUP>
		        <TBODY>
		<%
		int index=0;
		if(RecordSetShare.first()){
		do{
			index++;
			if(RecordSetShare.getInt("sharetype")==1)	{
		%>
		        <TR>
		          <TD><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></TD>
				  <TD class=Field>
					<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%></a>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </TD>
				  <TD class=Field  id="tdDel_<%=index%>">
					<%if(canedit){%>
					<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
				<%}%>
				  </TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=3 style="padding:0px !important;"></td></tr>
			<%}else if(RecordSetShare.getInt("sharetype")==2)	{%>
		        <TR>
		          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
				  <TD class=Field>
					<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </TD>
				  <TD class=Field id="tdDel_<%=index%>">
					<%if(canedit){%>
					<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
					<%}%>
				  </TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=3 style="padding:0px !important;"></td></tr>
			<%}else if(RecordSetShare.getInt("sharetype")==3)	{%>
		        <TR>
		          <TD><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></TD>
				  <TD class=Field>
					<a href="/hrm/roles/HrmRolesShowEdit.jsp?id=<%=RecordSetShare.getString("roleid")%>" target="_blank"><%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%></a>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </TD>
				  <TD class=Field id="tdDel_<%=index%>">
					<%if(canedit){%>
					<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
					<%}%>
				  </TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=3 style="padding:0px !important;"></td></tr>
			<%}else if(RecordSetShare.getInt("sharetype")==4)	{%>
		        <TR>
		          <TD><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
				  <TD class=Field>
					<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </TD>
				  <TD class=Field id="tdDel_<%=index%>">
					<%if(canedit){%>
					<a href="#" onClick="onDel('/CRM/data/ShareOperation.jsp?method=delete&id=<%=RecordSetShare.getString("id")%>&CustomerID=<%=CustomerID%>',this,<%=index%>)" target="_self"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
					<%}%>
				  </TD>
		        </TR><tr style="height: 1px"><td class=Line colspan=3 style="padding:0px !important;"></td></tr>
			<%}%>
		 <%}while(RecordSetShare.next());
		}
		%>
		        </TBODY>
			  </TABLE>

<!--共享信息end-->
</body>
</html>


