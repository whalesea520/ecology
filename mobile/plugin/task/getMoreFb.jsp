<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	try{
		FileUpload fu = new FileUpload(request);
		String taskId = Util.null2String(fu.getParameter("taskId"));
		int pageNum = Util.getIntValue(fu.getParameter("pageNum"),1);
		String sql = " from TM_TaskFeedback where taskid="+taskId;
		String orderBySql = " order by createdate desc,createtime desc";
		String orderBySql2 = " order by createdate,createtime";
		int iTotal = 0;
		rs.executeSql("select count(*)"+sql);
		if(rs.next()){
			iTotal = rs.getInt(1);
		}
		int totalpage = 1;
		if(iTotal>0){
			int _pagesize = 5;
			totalpage = iTotal / _pagesize;
			if(iTotal % _pagesize >0) totalpage += 1;
			int iNextNum = pageNum * _pagesize;
			int ipageset = _pagesize;
			if(iTotal - iNextNum + _pagesize < _pagesize) ipageset = iTotal - iNextNum + _pagesize;
			if(iTotal < _pagesize) ipageset = iTotal;
			if(rs.getDBType().equals("oracle")){
				sql = "select *"+ sql+orderBySql;
				sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + iNextNum;
				sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - _pagesize);
			}else{
				sql = "select top " + ipageset +" A.* from (select top "+ iNextNum + "*"+ sql +orderBySql+") A "+orderBySql2;
				sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderBySql;
			}
			rs.execute(sql);
			while(rs.next()){
				int id = rs.getInt("id");
				String replyid = Util.null2String(rs.getString("replyid"));
%>				
<tr>
	<td>
		<div class="feedbackshow">
			<table width="100%" class="fbShowTable">
			<tr>
				<td width="40%" class="date"><%=rc.getLastname(rs.getString("hrmid")) %></td>
				<td width="60%" class="date" style="text-align:right;">
					<%=Util.null2String(rs.getString("createdate")) %>&nbsp;
					<%=Util.null2String(rs.getString("createtime")) %>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="feedbackrelate">
						<div><%=Util.null2String(rs.getString("content")) %></div>
						<%if(!"".equals(rs.getString("docids"))){ %>
						<div class="relatetitle">相关文档：<%=cmutil.getDocNameForMobile(rs.getString("docids")) %></div>
						<%} %>
						<%if(!"".equals(rs.getString("wfids"))){ %>
						<div class="relatetitle">相关流程：<%=cmutil.getRequestNameForMobile(rs.getString("wfids")) %></div>
						<%} %>
						<%if(!"".equals(rs.getString("crmids"))){ %>
						<div class="relatetitle">相关客户：<%=cmutil.getCustomerForMobile(rs.getString("crmids")) %></div>
						<%} %>
						<%if(!"".equals(rs.getString("projectids"))){ %>
						<div class="relatetitle">相关项目：<%=cmutil.getProjectForMobile(rs.getString("projectids")) %></div>
						<%} %>
						<%if(!"".equals(rs.getString("fileids"))){ %>
						<div class="relatetitle">相关附件：<%=cmutil.getFileNameForMobile(rs.getString("fileids")) %></div>
						<%} %>
						<%
						  //读取回复信息
						  if(!replyid.equals("")){ 
							rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
							if(rs2.next()){
						%>
						<div class="fbreply">
							<div class="feedbackinfo2">@ <%=rc.getLastname(rs2.getString("hrmid")) %> <%=Util.null2String(rs2.getString("createdate")) %> <%=Util.null2String(rs2.getString("createtime")) %></div>
							<div class="feedbackrelate2">
								<div><%=Util.null2String(rs2.getString("content")) %></div>
								<%if(!"".equals(rs2.getString("docids"))){ %>
								<div class="relatetitle2">相关文档：<%=cmutil.getDocNameForMobile(rs2.getString("docids")) %></div>
								<%} %>
								<%if(!"".equals(rs2.getString("wfids"))){ %>
								<div class="relatetitle2">相关流程：<%=cmutil.getRequestNameForMobile(rs2.getString("wfids")) %></div>
								<%} %>
								<%if(!"".equals(rs2.getString("crmids"))){ %>
								<div class="relatetitle2">相关客户：<%=cmutil.getCustomerForMobile(rs2.getString("crmids")) %></div>
								<%} %>
								<%if(!"".equals(rs2.getString("projectids"))){ %>
								<div class="relatetitle2">相关项目：<%=cmutil.getProjectForMobile(rs2.getString("projectids")) %></div>
								<%} %>
								<%if(!"".equals(rs2.getString("fileids"))){ %>
								<div class="relatetitle2">相关附件：<%=cmutil.getFileNameForMobile(rs2.getString("fileids")) %></div>
								<%} %>
							</div>
						</div>
						<%	} %>
						<%} %>
						
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="text-align:right;">
					<a href="javascript:doReply('<%=id %>')">回复</a>
					</td>
				</tr>
			</table>
		</div>
	</td>
</tr>

<%			}
		}
		if(pageNum==1){
%>	
	<input type="hidden" id="fbTotalPage" value="<%=totalpage%>"/>	
	<%	
		}
	}catch(Exception e){
		out.print("<tr id='gettr'><td class='data' align='center'>获取更多反馈失败</td></tr>");	
	}
%>