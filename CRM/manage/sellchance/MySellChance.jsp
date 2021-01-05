
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.docs.docs.DocComInfo" %>
<%@ page import="weaver.workflow.request.RequestComInfo" %>
<%@ page import="weaver.crm.Maint.CustomerInfoComInfo" %>
<%@ page import="weaver.proj.Maint.ProjectTaskApprovalDetail" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<%
	rs.executeSql("select t1.id,t1.subject,t1.customerid from CRM_SellChance t1 where endtatusid=0 and t1.creater="+user.getUID()+" order by t1.createdate desc");
%>
<HTML>
	<HEAD>
		<title>我的商机</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<style type="text/css">
			.listtable{width: 98%;background: #E0E0E0;margin-top: 2px;margin-left: 1%;margin-right: 1%;}
			.listtable td{line-height:22px;background: #fff;}
			.listtable td.title{font-weight:bold;padding-left:3px;}
		</style>
	</head>
	<BODY style="overflow-x: hidden;">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div style="width: 100%;height: 100%;overflow-y: auto;">
			<%
				String contactsql = "";
				String contactid = "";
				String contactstr = "";
				if(rs.getCounts()==0){
			%>
				<div style='color:#C6C6C6;padding-left:3px;'>暂无进行中商机!</div>
			<%		
					
				}else{
			%>
		<table class="listtable" border="0" cellspacing="1" cellpadding="0">
			<colgroup><col width="200px;"/><col width="*"/><col width="30px;"/></colgroup>
			<tr>
				<td class="title">主题</td>
				<td class="title">联系记录</td>
				<td class="title">操作</td>
			</tr>	
			<%
				while(rs.next()){
					contactstr = "";
					contactsql = " SELECT DISTINCT top 1 a.id,a.begindate,a.begintime,a.resourceid,convert(varchar(2000),a.description) as description,a.name,a.status,a.createrid,a.createrType,a.taskid,a.crmid,a.requestid,a.docid FROM WorkPlan a,  WorkPlanShareDetail b WHERE a.id = b.workid" 
						+ " AND (',' + a.crmid + ',') LIKE '%," + rs.getString("customerid") + ",%'" 
						+ " AND b.usertype = 1 AND a.createrType=1 AND b.userid = " + user.getUID()
						+ " AND a.type_n = '3' order by a.begindate desc,a.begintime desc";
					rs2.executeSql(contactsql);
					if(rs2.next()){
						contactid = Util.null2String(rs2.getString("id"));
						contactstr += "<div style='width:100%;'><div style='width:100%;height:22px;;text-align:left;background-color:#FAFAFA;padding:0px;'><div style='float:left;'>"+getHrmname(rs2.getString("createrid"))+" "+rs2.getString("begindate")+" "+rs2.getString("begintime")+"</div>"
							+"<div style='float:right;white-space: nowrap'><a href=javascript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?activeId=crmContract&log=n&CustomerID="+rs.getString("customerid")+"')>更多>></a></div></div>"
							+"<div style='width:100%;text-align:left;padding:0px;'>"+Util.toScreen(Util.null2String(rs2.getString("description")),user.getLanguage())+"</div>";
						if(!Util.null2String(rs2.getString("taskid")).equals("")&&!Util.null2String(rs2.getString("taskid")).equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关项目："+getProjectName(rs2.getString("taskid"))+"</div>";
						if(!Util.null2String(rs2.getString("crmid")).equals("")&&!Util.null2String(rs2.getString("crmid")).equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关客户："+getCrmName(rs2.getString("crmid"))+"</div>";
						if(!Util.null2String(rs2.getString("requestid")).equals("")&&!Util.null2String(rs2.getString("requestid")).equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关流程："+getRequestName(rs2.getString("requestid"))+"</div>";
						if(!Util.null2String(rs2.getString("docid")).equals("")&&!Util.null2String(rs2.getString("docid")).equals("0")) contactstr += "<div style='width:100%;text-align:left;padding:0px;'>相关文档："+getDocName(rs2.getString("docid"))+"</div>";
						contactstr += "</div>";
					}
			%>
				<tr>
					<td style="padding-left: 3px;">
						<a href="javascript:openFullWindowHaveBar('/CRM/sellchance/ViewSellChance.jsp?frombase=1&id=<%=rs.getString("id")%>&CustomerID=<%=rs.getString("customerid")%>')">
		          			<%=Util.toScreen(rs.getString("subject"),user.getLanguage()) %>
		          		</a>
					</td>
					<td>
					<%if(contactid.equals("")){ %>
						<div style='color:#C6C6C6;'>暂无相关联系记录!</div>
					<%}else{ %>
						<%=contactstr %>
					<%} %>
					</td>
					<td style="padding-left: 3px;">
						<a href=javascript:openFullWindowForXtable("AddContactLog.jsp?customerId=<%=rs.getString("customerid")%>")>添加</a>
					</td>
				</tr>
			<%	}} %>
		</table>
		</div>
		<script language=javascript>  
			function onSearch(){
				window.location.reload();
			}
		</script>
	</BODY>
</HTML>
<%!
	public String getHrmname(String ids) {
		String names = "";
		try{
			ResourceComInfo rc = new ResourceComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					names += "<a href='javaScript:openhrm("+ idList.get(i)+ ");' onclick='pointerXY(event);'>"+ rc.getResourcename((String)idList.get(i)) + "</a> ";
				}
			}	
		}catch(Exception e){
				
		}
		return names;
	}
	public String getDocName(String ids) {
		String docNames = "";
		try{
			DocComInfo doc = new DocComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					docNames += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id=" + idList.get(i)+"') >"+ doc.getDocname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return docNames;
	}	
	public String getRequestName(String ids) {
		String requestNames = "";
		try{
			RequestComInfo request = new RequestComInfo();
			if(ids != null && !"".equals(ids.trim())){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					requestNames += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=" + idList.get(i)+"') >"+ request.getRequestname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return requestNames;
	}
	public String getCrmName(String ids) {
		String crmNames = "";
		try{
			CustomerInfoComInfo ci = new CustomerInfoComInfo();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					crmNames += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID=" + (String)idList.get(i)+"')>"+ ci.getCustomerInfoname((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return crmNames;
	}
	public String getProjectName(String ids) {
		String projectNames = "";
		try{
			ProjectTaskApprovalDetail ptad = new ProjectTaskApprovalDetail();
			if(ids != null && !"".equals(ids)){
				List idList = Util.TokenizerString(ids, ",");
				for (int i = 0; i < idList.size(); i++) {
					projectNames += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid=" + (String)idList.get(i)+"')>"+ ptad.getTaskSuject((String)idList.get(i))+"</a> ";
				}
			}
		}catch(Exception e){
				
		}
		return projectNames;
	}
%>