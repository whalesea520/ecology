<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RightUtil" class="weaver.pr.util.RightUtil" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
	int fromplan = Util.getIntValue(request.getParameter("fromplan"),0);
	String eid = Util.null2String(request.getParameter("eid"));
	String plandetailid = Util.null2String(request.getParameter("plandetailid"));
	if(plandetailid.equals("")){ 
		response.sendRedirect("../util/Message.jsp?type=1") ;
		return;
	}
	String sql = "";
	if("oracle".equals(rs.getDBType())){
		sql = "select t1.userid,t1.planid,t1.planid2,t1.datatype,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.begindate2,t1.enddate2,t1.days1,t1.days2,t1.finishrate,t1.target,t1.result,t1.custom1,t1.custom2,t1.custom3,t1.custom4,t1.custom5"
				+",t1.taskids,t1.goalids,t1.crmids,t1.docids,t1.wfids,t1.projectids,t1.fileids"
				+",t2.id as pid,t2.planname as pname,t3.id as sid,t3.planname as sname"
				+",(select v.viewdate from (select CONCAT(CONCAT(tlog.operatedate,' '),tlog.operatetime) as viewdate,planid from PR_PlanReportLog tlog where tlog.operatetype=0 and tlog.operator="+user.getUID()+" order by tlog.operatedate desc,tlog.operatetime desc) v where (v.planid=t1.planid or v.planid=t1.planid2) and rownum=1) as viewdate"
				+" from PR_PlanReportDetail t1"
				+" left join PR_PlanReport t2 on t1.planid=t2.id and t2.isvalid=1"
				+" left join PR_PlanReport t3 on t1.planid2=t3.id and t3.isvalid=1 where t1.id="+plandetailid;
	}else{
		sql = "select t1.userid,t1.planid,t1.planid2,t1.datatype,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.begindate2,t1.enddate2,t1.days1,t1.days2,t1.finishrate,t1.target,t1.result,t1.custom1,t1.custom2,t1.custom3,t1.custom4,t1.custom5"
				+",t1.taskids,t1.goalids,t1.crmids,t1.docids,t1.wfids,t1.projectids,t1.fileids"
				+",t2.id as pid,t2.planname as pname,t3.id as sid,t3.planname as sname"
				+",(select top 1 tlog.operatedate+' '+tlog.operatetime from PR_PlanReportLog tlog where (tlog.planid=t1.planid or tlog.planid=t1.planid2) and tlog.operatetype=0 and tlog.operator="+user.getUID()+" order by tlog.operatedate desc,tlog.operatetime desc) as viewdate"
				+" from PR_PlanReportDetail t1"
				+" left join PR_PlanReport t2 on t1.planid=t2.id and t2.isvalid=1"
				+" left join PR_PlanReport t3 on t1.planid2=t3.id and t3.isvalid=1 where t1.id="+plandetailid;
	}
	rs.executeSql(sql);
	rs.next();
	String planid = Util.null2String(rs.getString("planid"));
	String planid2 = Util.null2String(rs.getString("planid2"));
	String pname = Util.null2String(rs.getString("pname"));
	String sname = Util.null2String(rs.getString("sname"));
	String resourceid = Util.null2String(rs.getString("userid"));
	//System.out.println("planid:"+planid);
	String currentuserid = user.getUID()+"";
	boolean canedit = false;
	boolean canedit1 = planid.equals("0")?false:RightUtil.isCanEditPlan(planid,currentuserid);//是否能编辑计划字段
	boolean canedit2 = planid2.equals("0")?false:RightUtil.isCanEditPlan(planid2,currentuserid);//是否能编辑总结字段
	boolean canview = false;
	boolean editbase = false;
	if(planid.equals("0") && planid2.equals("0") && resourceid.equals(currentuserid)) {
		canview = true;
		canedit1 = true;
		canedit2 = true;
	}else{
		if(canedit1 || canedit2) canview = true;
		else canview = (RightUtil.isCanViewPlan(planid,currentuserid) || RightUtil.isCanViewPlan(planid2,currentuserid));
	}
	if(!canview){
		response.sendRedirect("../util/Message.jsp?type=1");
	    return ;
	}
	if(canedit1 || canedit2) canedit = true;
	
	
	String name = Util.toScreen(rs.getString("name"),user.getLanguage());
	String cate = Util.toScreen(rs.getString("cate"),user.getLanguage());
	String begindate1 = Util.null2String(rs.getString("begindate1"));
	String enddate1 = Util.null2String(rs.getString("enddate1"));
	String begindate2 = Util.null2String(rs.getString("begindate2"));
	String enddate2 = Util.null2String(rs.getString("enddate2"));
	String days1 = Util.null2String(rs.getString("days1"));
	String days2 = Util.null2String(rs.getString("days2"));
	String finishrate = Util.null2String(rs.getString("finishrate"));
	String target = Util.null2String(rs.getString("target"));
	String result = Util.null2String(rs.getString("result"));
	
	
	String createdate = "";
	String createtime = "";

	String taskids = Util.null2String(rs.getString("taskids"));
	String docids = Util.null2String(rs.getString("docids"));
	String wfids = Util.null2String(rs.getString("wfids"));
	String meetingids = Util.null2String(rs.getString("meetingids"));
	String crmids = Util.null2String(rs.getString("crmids"));
	String projectids = Util.null2String(rs.getString("projectids"));
	String fileids = Util.null2String(rs.getString("fileids"));
	

	String status = Util.null2String(rs.getString("status"));
	String statusstr = cmutil.getPlanStatus(status);
	
	String viewdate = Util.null2String(request.getParameter("viewdate"));
	if(viewdate.equals("")) viewdate = Util.null2String(rs.getString("viewdate"));
	
	String docsecid = "";
	boolean canupload = false;
	String subid = "";
	String mainid = "";
	String maxsize = "";
	rs2.executeSql("select docsecid from PR_BaseSetting where resourceid=" + ResourceComInfo.getSubCompanyID(resourceid) + " and resourcetype=2");
	if(rs2.next()){
		docsecid = Util.null2String(rs2.getString("docsecid")); 
		if(!docsecid.equals("")&&!docsecid.equals("0")){
			subid = SecCategoryComInfo.getSubCategoryid(docsecid);
			mainid = SubCategoryComInfo.getMainCategoryid(subid);
			maxsize = "0";
			rs2.executeSql("select maxUploadFileSize from DocSecCategory where id=" + docsecid);
			if(rs2.next()) maxsize = Util.null2String(rs2.getString(1));
			canupload = true;
		}
	}
	
	boolean showtask = weaver.workrelate.util.TransUtil.istask();
%>
<html> 
	<head>
		<title><%=name %></title>
		<link rel="stylesheet" href="../css/main.css" />
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="/workrelate/plan/js/jquery.fuzzyquery.min.js"></script>
		<script src="/workrelate/js/jquery.ui.core.js"></script>
		<script src="/workrelate/js/jquery.ui.widget.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker.js"></script>
		<script src="/workrelate/js/jquery.dragsort.js"></script>
		<script src="/workrelate/js/jquery.textarea.autoheight.js"></script>
		<script src="/workrelate/js/util.js"></script>
		<style type="text/css">
			.dtitle{width: 100%;height: 36px;line-height: 36px;border-bottom: 1px #DADAD9 solid;font-weight: bold;}
			.datatable{width: 100%;border-collapse: collapse;}	
			.datatable td{padding-left: 2px;padding-top:2px;padding-bottom:2px;text-align: left;font-family: 微软雅黑;}
			.datatable td.title{color: #999999;vertical-align: top;padding-top: 8px;padding-bottom: 8px;padding-right: 10px;text-align: right;border-bottom: 1px #FCFCFC solid;}
			.datatable td.data{vertical-align: top;border-bottom: 1px #EAEAEA solid;}
			.feedrelate td.title{text-align: left;padding-left: 6px;}
			.feedrelate td.data{padding-right: 5px;border-bottom-color: #FCFCFC;}
			.btn_addfb{width: 20px;height: 20px;position: absolute;top:8px;right: 5px;background: url('../images/add.png') center no-repeat;cursor: pointer;}
			.btn_close{width: 20px;height: 20px;position: absolute;top:8px;right: 5px;background: url('../images/delete.png') center no-repeat;cursor: pointer;}
			.btn_close_hover{background: url('../images/delete_hover.png') center no-repeat;}
			.txtlink{padding-top: 3px;}
			.btn_add,.btn_browser,.add_input{margin-top: 3px;padding-top:2px;padding-bottom:2px;}
			.add_input{height: 23px;}
			.upload{margin-top: 5px;}
			
			.scroll{
				SCROLLBAR-DARKSHADOW-COLOR: #EBEBEB;
				SCROLLBAR-ARROW-COLOR: #F7F7F7;
				SCROLLBAR-3DLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-SHADOW-COLOR: #EBEBEB;
				SCROLLBAR-HIGHLIGHT-COLOR: #EBEBEB;
				SCROLLBAR-FACE-COLOR: #EBEBEB;
				scrollbar-track-color: #F7F7F7;
				background: #FCFCFC;
				overflow-x: hidden; 
			}
			
			::-webkit-scrollbar-track-piece {
				background-color: #E2E2E2;
				-webkit-border-radius: 0;
			}
			
			::-webkit-scrollbar {
				width: 12px;
				height: 8px;
			}
			
			::-webkit-scrollbar-thumb {
				height: 50px;
				background-color: #CDCDCD;
				-webkit-border-radius: 1px;
				outline: 0px solid #fff;
				outline-offset: -2px;
				border: 0px solid #fff;
			}
			
			::-webkit-scrollbar-thumb:hover {
				height: 50px;
				background-color: #BEBEBE;
				-webkit-border-radius: 1px;
			}
			<%if(!editbase){%>.datatable1 td{border-bottom-color: #FCFCFC !important;}<%}%>
			<%if(!canedit){%>.datatable2 td{border-bottom-color: #FCFCFC !important;}<%}%>
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput,.subdisinput{line-height: 28px !important;height: 28px !important;}
			.input_inner{line-height: 26px !important;}
		</style>
		<![endif]-->
		
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body class="scroll">
<div id="rightinfo" style="width: 100%;height: auto;">
	<input type="hidden" id="plandetailid" name="plandetailid" value="<%=plandetailid %>"/>
	<input type="hidden" id="planid" name="planid" value="<%=planid %>"/>
	<div id="main" style="width:100%;height: auto;border-top:1px #E8E8E8 solid;" align="center">
		<div id="dtitle1" class="dtitle"><div class="dtxt">基本信息</div></div>
		<table class="datatable contenttable datatable1" cellpadding="0" cellspacing="0" border="0" align="center">
			<colgroup><col width="25%" /><col width="75%" /></colgroup>
				<tbody>		
				<tr>
					<td class="title">标题</td>
					<td class="data">
						<%if(editbase){ %>
				  			<textarea class="input_def" id="name" style="font-weight: bold;font-size: 14px;overflow: hidden;resize:none;"><%=name %></textarea>
				  		<%}else{ %>
				  			<div class="div_show" style="font-weight: bold;font-size: 14px;height: auto;overflow: hidden;"><%=Util.toHtml(name) %></div>
				  		<%} %>
				  	</td>
				</tr>
				<%if(!planid.equals("") && fromplan!=1){ 
		  		%>
		  		<tr>
					<td class="title">所属计划报告</td>
					<td class="data">
						<div class="div_show">
						<%if(!planid.equals("")&&!planid.equals("0")){ %>
						<a href="javaScript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?planid=<%=planid %>')"><%=pname %></a>
						<%} %>
						<%if(!planid.equals("")&&!planid.equals("0")&&!planid2.equals("")&&!planid2.equals("0")){ %><br/><%} %>
						<%if(!planid2.equals("")&&!planid2.equals("0")){ %>
						<a href="javaScript:openFullWindowHaveBar('/workrelate/plan/data/PlanView.jsp?planid=<%=planid2 %>')"><%=sname %></a>
						<%} %>
						</div>
				  	</td>
				</tr>
		  		<%} %>
				<tr>
				  	<td class="title">分类</td>
				  	<td class="data">
				  		<%if(editbase){ %>
				  			<div class="content_def" contenteditable="true" id="cate"><%=cate %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=cate %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">计划开始日期</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="begindate1" name="begindate1" value="<%=begindate1 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=begindate1 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">计划结束日期</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="enddate1" name="enddate1" value="<%=enddate1 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=enddate1 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">计划天数</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="days1" name="days1" value="<%=days1 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=days1 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
				  	<td class="title">计划目标</td>
				  	<td class="data">
				  		<%if(editbase){ %>
				  			<div class="content_def" contenteditable="true" id="target"><%=target %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=Util.toHtml(target) %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">实际开始日期</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="begindate2" name="begindate2" value="<%=begindate2 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=begindate2 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">实际结束日期</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="enddate2" name="enddate2" value="<%=enddate2 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=enddate2 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">实际天数</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="days2" name="days2" value="<%=days2 %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=days2 %></div>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">完成比例</td>
					<td class="data">
						<%if(editbase){ %>
						<input type="text" class="input_def" style="width: 100px;" id="finishrate" name="finishrate" value="<%=finishrate %>" size="30"/>
						<%}else{ %>
							<div class="div_show"><%=finishrate %></div>
						<%} %>
					</td>
				</tr>
				<tr>
				  	<td class="title">完成情况</td>
				  	<td class="data">
				  		<%if(editbase){ %>
				  			<div class="content_def" contenteditable="true" id="result"><%=result %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=Util.toHtml(result) %></div>
				  		<%} %>
				  	</td>
				</tr>
				<%
					//读取自定义字段
					String fieldname = "";
					String customname = "";
					rs2.executeSql("select fieldname,showname,customname from PR_PlanProgramDetail where fieldname like 'custom%' and (isshow=1 or isshow=2) and (planid="+planid+" or planid="+planid2+")");
					while(rs2.next()){
						fieldname = Util.null2String(rs2.getString("fieldname"));
						customname = Util.null2String(rs2.getString("customname"));
						if(customname.equals("")) customname = Util.null2String(rs2.getString("showname"));
				%>
				<tr>
				  	<td class="title"><%=customname %></TD>
				  	<td class="data">
				  		<%if(editbase){ %>
				  			<div class="content_def" contenteditable="true" id="<%=fieldname %>"><%=Util.null2String(rs.getString(fieldname)) %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=Util.toHtml(rs.getString(fieldname)) %></div>
				  		<%} %>
				  	</td>
				</tr>
				<%	} %>
				</tbody>
  		</table>
  		<div id="dtitle2" class="dtitle"><div class="dtxt">相关信息</div></div>
  		<table class="datatable contenttable datatable2" cellpadding="0" cellspacing="0" border="0" align="center">
			<colgroup><col width="25%" /><col width="75%" /></colgroup>
			<tbody>
				<%if(showtask){ %>
				<tr>
					<td class="title">相关任务</td>
					<td class="data">
						<%
							List taskidList = Util.TokenizerString(taskids,",");
							if(taskids.equals("")) taskids = ",";
							for(int i=0;i<taskidList.size();i++){
								if(!"0".equals(taskidList.get(i)) && !"".equals(taskidList.get(i))){
						%> 
						<div class="txtlink txtlink<%=taskidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getTaskName((String)taskidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('taskids','<%=taskidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="taskids" name="taskids" class="add_input" _init="1" _searchwidth="160" _searchtype="task"/>
				  		<div class="btn_add"></div>
				  		<input type="hidden" id="taskids_val" value="<%=taskids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<%} %>
				<tr>
					<td class="title">相关文档</td>
					<td class="data">
						<%
							List docidList = Util.TokenizerString(docids,",");
							if(docids.equals("")) docids = ",";
							for(int i=0;i<docidList.size();i++){
								if(!"0".equals(docidList.get(i)) && !"".equals(docidList.get(i))){
						%>
						<div class="txtlink txtlink<%=docidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getDocName((String)docidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('docids','<%=docidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="docids" name="docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_doc" onClick="onShowDoc('docids')"></div>
				  		<input type="hidden" id="docids_val" value="<%=docids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">相关流程</td>
					<td class="data">
						<%
							List wfidList = Util.TokenizerString(wfids,",");
							if(wfids.equals("")) wfids = ",";
							for(int i=0;i<wfidList.size();i++){
								if(!"0".equals(wfidList.get(i)) && !"".equals(wfidList.get(i))){
						%>
						<div class="txtlink txtlink<%=wfidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getRequestName((String)wfidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('wfids','<%=wfidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="wfids" name="wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_wf" onClick="onShowWF('wfids')"></div>
				  		<input type="hidden" id="wfids_val" value="<%=wfids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">相关客户</td>
					<td class="data">
						<%
							List crmidList = Util.TokenizerString(crmids,",");
							if(crmids.equals("")) crmids = ",";
							for(int i=0;i<crmidList.size();i++){
								if(!"0".equals(crmidList.get(i)) && !"".equals(crmidList.get(i))){
						%>
						<div class="txtlink txtlink<%=crmidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getCustomer((String)crmidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('crmids','<%=crmidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="crmids" name="crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_crm" onClick="onShowCRM('crmids')"></div>
				  		<input type="hidden" id="crmids_val" value="<%=crmids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">相关项目</td>
					<td class="data">
						<%
							List projectidList = Util.TokenizerString(projectids,",");
							if(projectids.equals("")) projectids = ",";
							for(int i=0;i<projectidList.size();i++){
								if(!"0".equals(projectidList.get(i)) && !"".equals(projectidList.get(i))){
						%>
						<div class="txtlink txtlink<%=projectidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getProject((String)projectidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('projectids','<%=projectidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="projectids" name="projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_proj" onClick="onShowProj('projectids')"></div>
				  		<input type="hidden" id="projectids_val" value="<%=projectids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">相关附件</td>
					<td id="filetd" class="data">
						<%
							List fileidList = Util.TokenizerString(fileids,",");
							if(fileidList.equals("")) fileids = ",";
							for(int i=0;i<fileidList.size();i++){
								if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
									DocImageManager.resetParameter();
						            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
						            DocImageManager.selectDocImageInfo();
						            DocImageManager.next();
						            String docImagefileid = DocImageManager.getImagefileid();
						            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
						            String docImagefilename = DocImageManager.getImagefilename();
						%>
						<div class='txtlink txtlink<%=fileidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
							<div style='float: left;'>
								<a href="javaScript:openFullWindowHaveBar('/workrelate/plan/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&plandetailid=<%=plandetailid %>')"><%=docImagefilename %></a>
								&nbsp;<a href='/workrelate/plan/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&plandetailid=<%=plandetailid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
							</div>
							<%if(canedit){ %>
							<div class='btn_del' onclick="delItem('fileids','<%=fileidList.get(i) %>')"></div>
							<div class='btn_wh'></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){
							if(canupload){
						%>
							<div id="uploadDiv" class="upload" mainId="<%=mainid%>" subId="<%=subid%>" secId="<%=docsecid%>" maxsize="<%=maxsize%>"></div>
						<%	}else{ %>
							<font color="red">未设置附件上传目录!</font>
						<%	} %>
				  		<%} %>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="dtitle" _click="0"><div class="dtxt">反馈信息</div></div>
  		<table id="feedbacktable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				<tr id="feedbacktr">
					<td class="data" align="center" style="border-bottom: 1px #EAEAEA solid;">
						<div id="feedbackdiv" style="width: 98%;height: 32px;overflow: hidden;margin-top: 5px;">
							<div class="feedback_def" style="margin-left: 0px;margin-top: 0px;" contenteditable="true" id="content"></div>
							<div id="feedbackbtn" style="width: 100%;height: 30px;display: none;">
								<div onclick="doFeedback()" class="btn_feedback" title="Ctrl+Enter">提交</div>
								<div onclick="doCancel()" class="btn_feedback" style="margin-left: 10px;">取消</div>
								<div id="submitload" style="float:left;margin-top: 5px;margin-left: 5px;display: none;"><img src='/images/loadingext.gif' align=absMiddle /></div>
								<div id="fbrelatebtn" style="width:70px;line-height:18px;float:right;margin-top: 5px;margin-right:0px;
									background: url('../images/rel_down.png') right no-repeat;color: #004080;cursor: pointer;" _status="0">附加信息</div>
							</div>
						</div>
						
						<table class="datatable feedrelate" cellpadding="0" cellspacing="0" border="0" align="center" style="display: none">
							<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
							<TBODY>
								<tr>
									<td class="title">相关文档</TD>
									<td class="data">
								  		<input id="_docids" name="_docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_doc" onClick="onShowDoc('_docids')"></div>
								  		<input type="hidden" id="_docids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关流程</TD>
									<td class="data">
								  		<input id="_wfids" name="_wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_wf" onClick="onShowWF('_wfids')"></div>
								  		<input type="hidden" id="_wfids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关客户</TD>
									<td class="data">
								  		<input id="_crmids" name="_crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_crm" onClick="onShowCRM('_crmids')"></div>
								  		<input type="hidden" id="_crmids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关项目</TD>
									<td class="data">
								  		<input id="_projectids" name="_projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_proj" onClick="onShowProj('_projectids')"></div>
								  		<input type="hidden" id="_projectids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关附件</TD>
									<td class="data">
									<%if(canupload){%>
										<div id="fbUploadDiv" class="upload" mainId="<%=mainid%>" subId="<%=subid%>" secId="<%=docsecid%>" maxsize="<%=maxsize%>"></div>
									<%	}else{ %>
										<font color="red">未设置附件上传目录!</font>
									<%	} %>
								  	</td>
								</tr>
							</TBODY>
						</table>
						<div id="fbbottom" style="width: 1px;height: 1px;font-size: 0px;"></div>
					</td>
				</tr>
				<%
					int feedbackcount = 0;
					String lastid = "";
					rs.executeSql("select count(id) from PR_PlanFeedback where plandetailid="+plandetailid);
					if(rs.next()){
						feedbackcount = Util.getIntValue(rs.getString(1),0);
					}
					boolean hasnewfb = false;
					if(feedbackcount>0){
						if("oracle".equals(rs.getDBType())){
							sql = "select t.* from (select id,remark,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from PR_PlanFeedback where plandetailid=" + plandetailid +" order by createdate desc,createtime desc) t where rownum<=5";
						}else{
							sql = "select top 5 id,remark,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from PR_PlanFeedback where plandetailid=" + plandetailid +" order by createdate desc,createtime desc";
						}
						rs.executeSql(sql);
						while(rs.next()){
							lastid = Util.null2String(rs.getString("id"));
							
				%>
				<tr>
					<td class="data fbdata" align="center">
						<div class="feedbackshow">
							<div class="feedbackinfo"><%=cmutil.getPerson(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
								<%if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
									hasnewfb = true;
								%>
					 			<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font><%} %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.convertDB2Input(rs.getString("remark")) %></div>
								<%if(!"".equals(rs.getString("docids"))){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(rs.getString("docids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("wfids"))){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(rs.getString("wfids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("crmids"))){ %>
								<div class="relatetitle">相关客户：<%=cmutil.getCustomer(rs.getString("crmids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("projectids"))){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(rs.getString("projectids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("fileids"))){ %>
								<div class="relatetitle">相关附件：<%=this.getFileDoc(rs.getString("fileids"),plandetailid) %></div>
								<%} %>
							</div>
						</div>
					</td>
				</tr>
				<%
						}
					}
					int lastcount = feedbackcount-5;
					if(lastcount>0){
				%>
				<tr id="gettr">
					<td class="data" align="center">
						<a href="javascript:getFeedbackRecord(<%=lastid %>)" style="margin-left: 20px;line-height: 25px;font-style: italic;font-weight: bold;float: left;">
							显示剩余<%=lastcount %>条记录
						</a>
					</td>
				</tr>
				<%		
						
					}
					
				%>
		</table>
		<div style="width: 100%;height: 20px;"></div>
	</div>
</div>
<div id="floattitle" class="dtitle" style="position: absolute;top: 0px;left: 0px;display: none;background: #FCFCFC;"></div>
<div id="btn_addfb" class="btn_addfb" style="<%if(fromplan==1){ %>right:35px;<%} %>" title="反馈" onclick="showFeedback()"></div>
<%if(fromplan==1){ %><div id="btn_close" class="btn_close" onclick="parent.closeDetail<%=eid %>()" title="关闭"></div><%}%>
<script language=javascript defer>
	
</script>
<script language="javascript">
	var tempval = "";
	var tempbdate1 = "<%=begindate1%>";
	var tempedate1 = "<%=enddate1%>";
	var tempbdate2 = "<%=begindate2%>";
	var tempedate2 = "<%=enddate2%>";
	var uploader;
	var oldname = "";
	var foucsobj2 = null;
	var plandetailid = "<%=plandetailid%>";
	$(document).ready(function(){

		<%if(editbase){%>
		$("#name").textareaAutoHeight({ minHeight:25 });
		var textarea= document.getElementById("name"); 
		//alert(textarea.clientHeight);
		$("#name").height(textarea.scrollHeight);
		
		//日期控件绑定
		$.datepicker.setDefaults( {
			"dateFormat": "yy-mm-dd",
			"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
			"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
			"changeMonth": true,
			"changeYear": true} );
		$( "#begindate1" ).datepicker({
			"onSelect":function(){
				if($("#begindate1").val()!="" && $("#enddate1").val()!="" && !compdate($("#begindate1").val(),$("#enddate1").val())){
					alert("开始日期不能大于结束日期!");
					$("#begindate1").val(tempbdate1);
					return;
				}else{
					tempbdate = $("#begindate1").val();
					doUpdate(this,1);
				}
			}
		}).datepicker("setDate","<%=begindate1%>");
		$( "#enddate1" ).datepicker({
			"onSelect":function(){
				if($("#begindate1").val()!="" && $("#enddate1").val()!="" && !compdate($("#begindate1").val(),$("#enddate1").val())){
					alert("结束日期不能小于开始日期!");
					$("#enddate1").val(tempedate1);
					return;
				}else{
					tempedate = $("#enddate1").val();
					doUpdate(this,1);
				}
			}
		}).datepicker("setDate","<%=enddate1%>");
		$( "#begindate2" ).datepicker({
			"onSelect":function(){
				if($("#begindate1").val()!="" && $("#enddate2").val()!="" && !compdate($("#begindate2").val(),$("#enddate2").val())){
					alert("开始日期不能大于结束日期!");
					$("#begindate2").val(tempbdate2);
					return;
				}else{
					tempbdate = $("#begindate2").val();
					doUpdate(this,1);
				}
			}
		}).datepicker("setDate","<%=begindate2%>");
		$( "#enddate2" ).datepicker({
			"onSelect":function(){
				if($("#begindate2").val()!="" && $("#enddate2").val()!="" && !compdate($("#begindate2").val(),$("#enddate2").val())){
					alert("结束日期不能小于开始日期!");
					$("#enddate2").val(tempedate2);
					return;
				}else{
					tempedate = $("#enddate2").val();
					doUpdate(this,1);
				}
			}
		}).datepicker("setDate","<%=enddate2%>");
		<%}%>

		//分类信息收缩展开动作绑定
		/**
		$("div.dtitle").bind("click",function(){
			if($(this).attr("_click")!=0){
				var table = $(this).next("table.contenttable");
				table.toggle();
				if(table.css("display")=="none"){
					$(this).attr("title","点击展开");
				}else{
					$(this).attr("title","点击收缩");
				}
			}
		});*/

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();$(".btn_browser").hide();
			$(this).addClass("tr_over");
			$(this).find(".input_def").addClass("input_over");
			$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			$(this).removeClass("tr_over");
			$(this).find(".input_def").removeClass("input_over");
			$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			$(this).nextAll("div.btn_browser").hide();
			$(this).prevAll("div.showcon").hide();
			$(this).prevAll("input.add_input").show().focus();
			$(this).prevAll("div.btn_select").show()
		});

		//单行文本输入框事件绑定
		$(".input_def").bind("mouseover",function(){
			$(this).addClass("input_over");
		}).bind("mouseout",function(){
			$(this).removeClass("input_over");
		}).bind("focus",function(){
			$(this).addClass("input_focus");
			tempval = $(this).val();
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
			if($(this).attr("id")=="name"){
				oldname = $(this).val();
				//document.onkeyup=keyListener4;
			}
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
			doUpdate(this,1);
			//document.onkeydown=null;
			//document.onkeyup=null;
		});
		$("#tag").bind("focus",function(){
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(){
			//document.onkeydown=null;
		});
		//多行文本输入框事件绑定
		$("div.content_def").bind("mouseover",function(){
			$(this).addClass("content_over");
		}).bind("mouseout",function(){
			$(this).removeClass("content_over");
		}).bind("focus",function(){
			$(this).addClass("content_focus");
			tempval = $(this).html();
		}).bind("blur",function(){
			$(this).removeClass("content_focus");
			doUpdate(this,2);
		});
		$("div.feedback_def").bind("mouseover",function(){
			$(this).addClass("feedback_over");
		}).bind("mouseout",function(){
			$(this).removeClass("feedback_over");
		}).bind("focus",function(){
			var doscroll = false;
			if(!$(this).hasClass("feedback_focus")) doscroll = true;
			$(this).addClass("feedback_focus");
			//$("div.btn_feedback").show();
			//$("#fbrelatebtn").show();
			$("#feedbackbtn").show();
			$("#feedbackdiv").height("auto");

			if(doscroll) setFBP();
		});

		//联想输入框事件绑定
		$("input.add_input").bind("focus",function(){
			if($(this).attr("_init")==1){
				$(this).FuzzyQuery({
					url:"/workrelate/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:$(this).attr("_searchtype"),
					divwidth: $(this).attr("_searchwidth"),
					updatename:$(this).attr("id"),
					updatetype:"str",
					currentid:""
				});
				$(this).attr("_init",0);
			}
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(e){
			if($(this).attr("id")=="tag" && $(this).val()!=""){
				var target=$.event.fix(e).target;
				//alert($(target).attr("id"));
				//selectUpdate("tag",$(this).val(),$(this).val(),"str");
			}else{
				$(this).val("");
			}
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
			//document.onkeydown=null;
		});

		<%if(fromplan==1){ %>
		$("#btn_close").bind("mouseover",function(){
			$(this).addClass("btn_close_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("btn_close_hover");
		});
		<%}%>

		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("table.feedrelate").show();
				$(this).attr("_status",1).css("background", "url('../images/rel_up.png') right no-repeat");
			}else{
				$("table.feedrelate").hide();
				$(this).attr("_status",0).css("background", "url('../images/rel_down.png') right no-repeat");
			}
			//setFBP();
		});

		<%if(canupload){%>
			bindUploaderDiv($("#uploadDiv"),"relatedacc","<%=plandetailid%>");
			setTimeout(function(){
				bindUploaderDiv($("#fbUploadDiv"),"fbfileids","");
			},1000);
		<%}%>
	});

	$(window).scroll(function(){
		setposition();
	});
	function setposition(){
		var scrollh = document.body.scrollTop;
		$("#floattitle").css("top",scrollh);
		$("#btn_addfb").css("top",scrollh+8);
		<%if(fromplan==1){ %>$("#btn_close").css("top",scrollh+8);<%}%>
		var tp2 = $("#dtitle2").offset().top;
		//alert(tp2);
		if(tp2<0){
			$("#floattitle").html($("#dtitle2").html()).show();
		}else if(scrollh>0){
			$("#floattitle").html($("#dtitle1").html()).show();
		}else{
			$("#floattitle").hide();
		}
	}
	<%if(canedit){%>
	//输入框保存方法
	function doUpdate(obj,type){
		var fieldname = $(obj).attr("id");
		var fieldvalue = "";
		if(type==1){
			if($(obj).val()==tempval) return;
			fieldvalue = $(obj).val();
		}
		if(type==2){
			if($(obj).html()==tempval) return;
			fieldvalue = $(obj).html();
		}
		if(fieldname=="name"){
			if($.trim(fieldvalue)==""){
				$("#"+taskid).val(oldname);
				$(obj).val(oldname);
				return;
			}
			$("#"+taskid).val(fieldvalue);
		}
		exeUpdate(fieldname,fieldvalue,"str");
	}
	//执行编辑
	function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue){
		if(typeof(delvalue)=="undefined") delvalue = "";
		if(typeof(addvalue)=="undefined") addvalue = "";
		$.ajax({
			type: "post",
		    url: "/workrelate/plan/data/Operation.jsp",
		    data:{"operation":"edit_field","plandetailid":plandetailid,"fieldname":fieldname,"fieldvalue":filter(encodeURIComponent(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURIComponent(delvalue),"addvalue":encodeURIComponent(addvalue)}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    var txt = $.trim(data.responseText);
			    var log = txt;
		    	if(fieldname=="fileids"){
		    		$("#filetd").find(".txtlink").remove();
		    		$("#filetd").prepend(txt);
			    }
			}
	    });
	}
	//删除选择性内容
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		if(fieldname=="docids"||fieldname=="wfids"||fieldname=="meetingids"||fieldname=="crmids"||fieldname=="projectids"||fieldname=="taskids"||fieldname=="tag"||startWith(fieldname,"_")){
			var vals = $("#"+fieldname+"_val").val();
			var _index = vals.indexOf(","+fieldvalue+",")
			if(_index>-1 && $.trim(fieldvalue)!=""){
				vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
				$("#"+fieldname+"_val").val(vals);
				if(!startWith(fieldname,"_")){
					exeUpdate(fieldname,vals,'str',fieldvalue);
				}
			}
		}else{
			exeUpdate(fieldname,fieldvalue,'del');
		}
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		if(id==null || typeof(id)=="undefined") return;
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += ids[i] + ",";
				addvalue += ids[i] + ",";
				addtxt += transName(fieldname,ids[i],names[i]);
			}
		}
		$("#"+fieldname+"_val").val(vals+addids);
		addids = vals+addids;
		$("#"+fieldname).before(addtxt);
		if(!startWith(fieldname,"_")){
			exeUpdate(fieldname,addids,type,"",addvalue);
		}
	}
	<%}%>
	function transName(fieldname,id,name){
		var delname = fieldname;
		if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
		var restr = "";
		if(fieldname=="principalid"){
			restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}else{
			restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}
		restr += "<div style='float: left;'>";
			
		if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
			restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
		}else if(fieldname=="docids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
		}else if(fieldname=="wfids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
		}else if(fieldname=="crmids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
		}else if(fieldname=="projectids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
		}else if(fieldname=="taskids"){
			restr += "<a href=javaScript:showTask("+id+") >"+name+"</a>";
		}else if(fieldname=="tag"){
			restr += name;
		}
		
		restr +="</div>"
			+ "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>"
			+ "<div class='btn_wh'></div>"
			+ "</div>";
		return restr;
	}
	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}

	function onShowDoc(fieldname) {
	    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowWF(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowCRM(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowProj(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}

	function setFBP(){
		var st = document.body.scrollTop;
		jQuery("html, body").scrollTop(st+100);
	}
	function showFeedback(){
		$("#content").focus();
	}
	//反馈
	function doFeedback(){
		if($("#content").html()==""||$("#content").html()=="<br>"){
			alert("请输入内容!");
			return;
		}
		try{
			var oUploader=window[$("#fbUploadDiv").attr("oUploaderIndex")];
			if(oUploader.getStats().files_queued==0){ //如果没有选择附件则直接提交
				exeFeedback();  //提交
			}else{ 
					oUploader.startUpload();
			}
		}catch(e) {
			exeFeedback();
	  	}
	}
	function exeFeedback(){
		//$("div.btn_feedback").hide();
		$("#submitload").show();
		$.ajax({
			type: "post",
		    url: "/workrelate/plan/data/Operation.jsp",
		    data:{"operation":"add_feedback","plandetailid":plandetailid,"content":filter(encodeURIComponent($("#content").html())),"docids":$("#_docids_val").val(),"wfids":$("#_wfids_val").val(),"crmids":$("#_crmids_val").val(),"projectids":$("#_projectids_val").val(),"fileids":$("input[name=fbfileids]").val()}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    /**
		    	data=$.trim(data.responseText);
		    	if(data!=""){
		    		$("#feedbacktable").prepend(data);
			    }*/
			    if(data!=""){
			    	var txt = $.trim(data.responseText);
			    	$("#feedbacktr").after(txt);
			    }
		    	$("#submitload").hide();
		    	deffeedback = "";
		    	doCancel();
			}
	    });
	}
	//取消反馈
	function doCancel(){
		$("#_crmids_val").val("");$("#_docids_val").val("");$("#_wfids_val").val("");$("#_projectids_val").val("");$("input[name=fbfileids]").val("");

		$("div.feedback_def").html("").removeClass("feedback_focus");
		//$("div.btn_feedback").hide();
		if($("#fbrelatebtn").attr("_status")==1){$("#fbrelatebtn").click();}
		//$("#fbrelatebtn").hide();
		$("#feedbackbtn").hide();
		$("#feedbackdiv").height(32);

		setposition();
	}
	//获取反馈记录
	function getFeedbackRecord(lastid){
		$("#gettr").children("td").html("<img src='../images/loading3.gif' align='absMiddle' />");
		$.ajax({
			type: "post",
		    url: "/workrelate/plan/data/Operation.jsp",
		    data:{"operation":"get_feedback","plandetailid":plandetailid,"lastId":lastid,"viewdate":"<%=viewdate%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	data=$.trim(data.responseText);
		    	$("#gettr").before(data).remove();
			}
	    });
	}
</script>
</body>
</html>
<%@ include file="/workrelate/plan/util/uploader2.jsp" %>
<%!
	public String getFileDoc(String ids,String plandetailid) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/plan/util/ViewDoc.jsp?id="+docid+"&plandetailid="+plandetailid+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/plan/util/ViewDoc.jsp?id="+docid+"&plandetailid="+plandetailid+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
	public String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	
%>
