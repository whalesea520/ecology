
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String CustomerID = Util.null2String(request.getParameter("CustomerID"));
	boolean canedit=false;
	int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
	if(sharelevel>1){
		canedit=true;
	}
	RecordSetShare.executeProc("CRM_ShareInfo_SbyRelateditemid",CustomerID);
%>

		<table id="sharetable" class="viewlist" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="30%"/><col width="60%"/><col width="10%"/></colgroup>
		        <tbody>
		<%
			int index=0;
			int sharetype = 0;
			String shareid = "";
			while(RecordSetShare.next()){
				index++;
				shareid = Util.null2String(RecordSetShare.getString("id"));
				sharetype = RecordSetShare.getInt("sharetype");
		%>
				<tr id="sharetr_<%=shareid %>">
		<%
				if(sharetype==1)	{
		%>
		          <td><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
				  <td>
					<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetShare.getString("userid")%>" target="_blank">
						<%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetShare.getString("userid")),user.getLanguage())%>
					</a>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </td>
		<%		}else if(sharetype==2){%>
		          <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
				  <td>
					<a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=RecordSetShare.getString("departmentid")%>" target="_blank"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(RecordSetShare.getString("departmentid")),user.getLanguage())%></a>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </td>
		<%		}else if(sharetype==3){%>
		          <td><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
				  <td>
					<a href="/hrm/roles/HrmRolesShowEdit.jsp?id=<%=RecordSetShare.getString("roleid")%>" target="_blank"><%=Util.toScreen(RolesComInfo.getRolesRemark(RecordSetShare.getString("roleid")),user.getLanguage())%></a>/<% if(RecordSetShare.getInt("rolelevel")==0)%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
					<% if(RecordSetShare.getInt("rolelevel")==1)%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
					<% if(RecordSetShare.getInt("rolelevel")==2)%><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </td>
		<%		}else if(sharetype==4){%>
		          <td><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></TD>
				  <td>
					<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:<%=Util.toScreen(RecordSetShare.getString("seclevel"),user.getLanguage())%>/<% if(RecordSetShare.getInt("sharelevel")==1)%><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
					<% if(RecordSetShare.getInt("sharelevel")>=2)%><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
				  </td>
		<%		}%>
				  <td style="position:relative">
					<%if(canedit){%>
					<a id="delbtn_<%=shareid %>" href="javascript:deleteShare('<%=shareid%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>
					<div id="delload_<%=shareid %>" style="width: 30px;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;display:none;"></div>
					<%}%>
				  </td>
				</tr>
		<%	} %>
			</tbody>
		</table>


