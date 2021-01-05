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
		String sql = " from TM_TaskLog where taskid="+taskId;
		String orderBySql = " order by operatedate desc,operatetime desc";
		String orderBySql2 = " order by operatedate,operatetime";
		int iTotal = 0;
		rs.executeSql("select count(*)"+sql);
		if(rs.next()){
			iTotal = Util.getIntValue(rs.getString(1),0);
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
			Map fn = new HashMap();
			fn.put("name","名称");
			fn.put("level","紧急程度");
			fn.put("remark","描述");
			fn.put("risk","风险点");
			fn.put("difficulty","难度点");
			fn.put("assist","需协助点");
			fn.put("tag","任务标签");
			fn.put("principalid","责任人");
			fn.put("partnerid","参与人");
			fn.put("sharerid","分享者");
			fn.put("begindate","开始日期");
			fn.put("enddate","结束日期");
			fn.put("taskids","相关任务");
			fn.put("docids","相关文档");
			fn.put("wfids","相关流程");
			fn.put("crmids","相关客户");
			fn.put("projectids","相关项目");
			fn.put("fileids","相关附件");
			fn.put("date","任务日期");
			fn.put("parentid","上级任务");
			fn.put("showallsub","是否开放下级任务");
			while(rs.next()){
				int id = rs.getInt("id");
				int type = Util.getIntValue(rs.getString("type"),0);
				String field = rs.getString("operatefiled");
				String value = rs.getString("operatevalue");
				String valtxt = "";
				if("taskids".equals(field) || "parentid".equals(field)){
					valtxt = cmutil.getTaskName(value);
				}else if("level".equals(field)){
					if("1".equals(value)) valtxt = "重要紧急";
					if("2".equals(value)) valtxt = "重要不紧急";
					if("3".equals(value)) valtxt = "不重要紧急";
					if("4".equals(value)) valtxt = "不重要不紧急";
				}else if("showallsub".equals(field)){
					if("1".equals(value)) valtxt = "是";
					if("0".equals(value)) valtxt = "否";
				}
				if(type==11){
					if("4".equals(value)){
						valtxt = "取消标记";
					}else if("1".equals(value)){
						valtxt = "标记为今天";
					}else if("2".equals(value)){
						valtxt = "标记为明天";
					}else if("3".equals(value)){
						valtxt = "标记为即将";
					}else if("5".equals(value)){
						valtxt = "标记为备注";
					}
				}else if(type==12){
					if("0".equals(value)){
						valtxt = "添加关注";
					}else if("1".equals(value)){
						valtxt = "取消关注";
					}
				}
				String logtxt = "";
				switch(type){
					case 0:logtxt+="查看任务";break;
					case 1:logtxt+="新建任务";break;
					case 2:logtxt+="更新"+fn.get(field)+"为&nbsp;&nbsp;"+valtxt;break;
					case 3:logtxt+="添加"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
					case 4:logtxt+="删除"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
					case 5:logtxt+="设置为进行中";break;
					case 6:logtxt+="设置为完成";break;
					case 7:logtxt+="设置为撤销";break;
					case 8:logtxt+="删除任务";break;
					case 9:logtxt+="上传"+fn.get(field)+"&nbsp;&nbsp;"+valtxt;break;
					case 10:logtxt+="反馈任务";break;
					case 11:logtxt+=valtxt;break;
					case 12:logtxt+=valtxt;break;
					case 13:logtxt+="删除反馈";break;
					case 14:logtxt+="微信提醒-"+value;break;
				}
%>				
<tr>
	<td>
		<div class="feedbackshow">
			<table width="100%" class="fbShowTable">
			<tr>
				<td width="40%" class="date"><%=rc.getLastname(rs.getString("operator")) %></td>
				<td width="60%" class="date" style="text-align:right;">
					<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;
					<%=Util.null2String(rs.getString("operatetime")) %>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<div class="feedbackrelate">
						<div>
						<%=logtxt%>
						</div>
					</div>
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
	<input type="hidden" id="logTotalPage" value="<%=totalpage%>"/>	
	<%	
		}
	}catch(Exception e){
		out.print("<tr id='gettr'><td class='data' align='center'>获取更多日志失败</td></tr>");	
	}
%>