<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.pr.util.TransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
	//所有经理及模板制定人、考核方案确认人有权限查看
	String userid = user.getUID()+"";
	String programid = Util.null2String(request.getParameter("programid"));
	if(programid.equals("0")){
		programid = "";
	}
	String resourceid = Util.null2String(request.getParameter("resourceid"));
	int resourcetype = Util.getIntValue(request.getParameter("resourcetype"),4);
	String managerid = "";
	String managername = "";
	String programtype = Util.null2String(request.getParameter("programtype"));
	String isrefresh = Util.null2String(request.getParameter("isrefresh"));
	if(programtype.equals("")) programtype = Util.null2String((String)request.getSession().getAttribute("PR_PROGRAM_TYPE"));
	boolean self = false;
	boolean manager = false;
	boolean canview = false;
	boolean canedit = false;
	if(userid.equals("1")&&resourcetype==4&&resourceid.equals("")){//如果是管理员点击自己的模板设置 则取默认的模板
		programid = "0";
	}
	String auditids = "";
	if(!programid.equals("")&&!programid.equals("0")){
		rs.executeSql("select userid,programtype,auditids from PR_PlanProgram where id="+programid);
		if(rs.next()){
			programtype = Util.null2String(rs.getString("programtype"));
			resourceid = Util.null2String(rs.getString("userid"));
			auditids = Util.null2String(rs.getString("auditids"));
		}else{
			response.sendRedirect("../util/Message.jsp?type=1");
		    return ;
		}
	}else if(resourceid.equals("")){
		resourceid = userid;
		//response.sendRedirect("../util/Message.jsp?type=1");
	    //return ;
	}
	//查询基础设置
	int isweek = 0;       
	int ismonth = 0;      
	
	String programcreate = "";
	int isself = 0;           
	int ismanager = 0;  
	if(!programid.equals("0")){//不是修改默认模板才去判断该用户所在的分部是否开启计划报告
		String subCompanyId = "";
	    String departmentids = "";
		if(resourcetype==2){//分部
			subCompanyId = resourceid;
		}else if(resourcetype==3){//部门
			subCompanyId = DepartComInfo.getSubcompanyid1(resourceid);
			departmentids = resourceid;
		}else if(resourcetype==4){
			subCompanyId = ResourceComInfo.getSubCompanyID(resourceid);
			departmentids = ResourceComInfo.getDepartmentID(resourceid);
		}
		if(resourcetype==3 || resourcetype==4){
			rs.executeSql("select programcreate,isself,ismanager from PR_BaseSetting where resourceid=" +departmentids+ " and resourcetype=3");
			if(rs.next()){
				programcreate = Util.null2String(rs.getString("programcreate"));  
				isself = Util.getIntValue(rs.getString("isself"),0);         
				ismanager = Util.getIntValue(rs.getString("ismanager"),0);
				RecordSet rs1 = new RecordSet();
				rs1.executeSql("select isweek,ismonth from PR_BaseSetting where resourceid=" +subCompanyId+ " and resourcetype=2");
				if(rs1.next()){
					isweek = Util.getIntValue(rs1.getString("isweek"),0);      
					ismonth = Util.getIntValue(rs1.getString("ismonth"),0);   
				}
			}else{
				rs.executeSql("select isweek,ismonth,programcreate,isself,ismanager from PR_BaseSetting where resourceid=" +subCompanyId+ " and resourcetype=2");
				if(rs.next()){
					isweek = Util.getIntValue(rs.getString("isweek"),0);      
					ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
					programcreate = Util.null2String(rs.getString("programcreate"));  
					isself = Util.getIntValue(rs.getString("isself"),0);         
					ismanager = Util.getIntValue(rs.getString("ismanager"),0);
				}
			}
		}else{
			rs.executeSql("select isweek,ismonth,programcreate,isself,ismanager from PR_BaseSetting where resourceid=" +subCompanyId+ " and resourcetype=2");
			if(rs.next()){
				isweek = Util.getIntValue(rs.getString("isweek"),0);      
				ismonth = Util.getIntValue(rs.getString("ismonth"),0);   
				programcreate = Util.null2String(rs.getString("programcreate"));  
				isself = Util.getIntValue(rs.getString("isself"),0);         
				ismanager = Util.getIntValue(rs.getString("ismanager"),0);
			}
		}
		if(isweek!=1 && ismonth!=1) {
			response.sendRedirect("../util/Message.jsp?type=2") ;
			return;//未启用
		}
	}
	String mbName = "",mbTitle="";
	int rtype = resourcetype;
	if(programid.equals("")){
		if(isweek!=1 && programtype.equals("2")) programtype = "";
		if(ismonth!=1 && programtype.equals("1")) programtype = "";
		
		if(programtype.equals("")){
			if(isweek==1) programtype = "2";
			if(ismonth==1) programtype = "1";
		}
		//查看最新的方案
		String subCompanyId2 = "";
		String departmentId = "";
		String companyId = "";
		if(resourcetype==4){//人员
			subCompanyId2 = ResourceComInfo.getSubCompanyID(resourceid);
			departmentId = ResourceComInfo.getDepartmentID(resourceid);
			companyId = SubComInfo.getCompanyid(subCompanyId2);
		}else if(resourcetype==3){//部门
			departmentId = resourceid;
			subCompanyId2 = DepartComInfo.getSubcompanyid1(resourceid);
			companyId = SubComInfo.getCompanyid(subCompanyId2);
		}else if(resourcetype==2){//分部
			subCompanyId2 = resourceid;
			companyId = SubComInfo.getCompanyid(subCompanyId2);
		}
		if(null==subCompanyId2||subCompanyId2.equals("")){
			subCompanyId2 = "0";
		}
		if(null==departmentId||departmentId.equals("")){
			departmentId = "0";
		}
		if(null==companyId||companyId.equals("")){
			companyId = "0";
		}
		String sql_pp = "select id,userid,auditids,shareids,programtype,resourcetype from PR_PlanProgram where ("+
		" (userid="+resourceid+" and (resourcetype=4 or resourcetype is null))"+
		" or (userid="+subCompanyId2+" and resourcetype = 2)"+
		" or (userid="+departmentId+" and resourcetype = 3)"+
		" or (userid="+companyId+" and resourcetype =1 )"+
		" ) and programtype="+programtype+" order by resourcetype desc";
		rs.executeSql(sql_pp);
		if(rs.next()){
			programid = Util.null2String(rs.getString("id"));
			String rid = Util.null2String(rs.getString("userid"));
			auditids = Util.null2String(rs.getString("auditids"));
			rtype = Util.getIntValue(rs.getString("resourcetype"),4);
			if(rtype!=resourcetype) {
				if(rtype==3){
					mbName = DepartComInfo.getDepartmentname(rid);
					mbTitle = "未单独设置模板,当前使用部门"+mbName+"设置的模板";
				}else if(rtype==2){
					mbName = SubComInfo.getSubcompanyname(rid);
					mbTitle = "未单独设置模板,当前使用分部"+mbName+"设置的模板";
				}else if(rtype==1){
					mbName = CompanyComInfo.getCompanyname(rid);
					mbTitle = "未单独设置模板,当前使用公司"+mbName+"设置的模板";
				}
			}
		}else{
			mbName = "默认";
		}
	}
	if(programid.equals("0")){
		mbName = "默认";
	}
	
	managerid = ResourceComInfo.getManagerID(resourceid);
	managername = "直接上级";
	if(resourcetype==4){
		managername +="-"+cmutil.getPerson(managerid);
	}
	String auditnames = "";
	if(auditids.equals("-1")){
		auditnames = managername;
	}else{
		auditnames = cmutil.getPerson(auditids);
	}
	if(user.getUID()==1&&programid.equals("0")){
		canview = true;
		canedit = true;
	}else if(resourcetype==4){
		if(resourceid.equals(userid)){
			self = true;
			canview = true;
		}else if(ResourceComInfo.isManager(user.getUID(),resourceid)){
			manager = true;
			canview = true;
		}
		
		if((self && isself==1) || (manager && ismanager==1)){
			canedit = true;
		}else if((","+programcreate+",").indexOf(","+userid+",")>-1){
			canview = true;
			canedit = true;
		}
	}else{
		if((","+programcreate+",").indexOf(","+userid+",")>-1){
			canview = true;
			canedit = true;
		}
	}
	if(!canview){
		response.sendRedirect("/workrelate/plan/util/Message.jsp?type=1");
	    return ;
	}
	
	int indexnum = 0;
	
	request.getSession().setAttribute("PR_PROGRAM_TYPE",programtype);
	//总结特有的字段
	List sfields = new ArrayList();
	sfields.add("begindate2");
	sfields.add("enddate2");
	sfields.add("days2");
	sfields.add("result");
	sfields.add("finishrate");
	
	String showName = "";
	if(resourcetype==2){//分部
		showName = SubComInfo.getSubcompanyname(resourceid);
	}else if(resourcetype==3){//部门
		showName = DepartComInfo.getDepartmentname(resourceid);
	}else if(resourcetype==4){
		showName = cmutil.getPerson(resourceid);
	}
	String programid2 = programid;
	if(rtype!=resourcetype){
		//当前查看的模板和数据库取出的模板对应的type不一样,比如:查看的是个人的模板,但是取出的是部门的模板
		//这种情况将ID置为空,表示不能修改带出的其他模板,只能保存
		programid2 = "";
	}
	if(programid.equals("")) {//为空则取默认的模板展示
		programid = "0";
	}
	boolean canReference = false;
	String subCompanyids_refence = "";//当前人员所能指定的分部列表
	//查看的模板ID不为空并且当前人员是模板制定人(任何分部的制定人都可以)并且当前查看的模板是对应类型的模板
	if(!programid.equals("")&&!programid.equals("0")&&rtype==resourcetype){
		String sql = "select resourceid from PR_BaseSetting where programcreate like '%,"+userid+",%'";
		if(programtype.equals("1")){//月报
			sql+=" and ismonth = 1";
		}else if(programtype.equals("2")){
			sql+=" and isweek = 1";
		}
		//判断是否是分部模板指定人 并且是否开启了当前类型的报告
		rs.executeSql(sql);
		while(rs.next()){
			canReference = true;
			String rid = Util.null2String(rs.getString("resourceid"));
			if(!rid.equals("")){
				subCompanyids_refence+=","+rid;
			}
		}
		if(!subCompanyids_refence.equals("")){
			subCompanyids_refence +=",";
		}
	}
	String titlename = showName+"计划报告模板设置";
%>
<HTML>
	<HEAD>
		<title><%=showName %>计划报告模板设置</title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="../../js/util.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="../js/jquery.sorted.js"></script>
		<link rel="stylesheet" type="text/css" href="../css/tab.css" />
		<style type="text/css">
			.input{height: 28px;}
			.area_txt{width:98%;height: 70px;margin-top: 2px;margin-bottom: 2px;overflow-x: hidden;overflow-y: auto;}
		
			.maintable{width: 100%;border-collapse: collapse;}
			.maintable td{min-height: 28px;line-height: 28px;padding-left: 0px;border-bottom: 1px #EAEAEA solid;}
			.maintable td.title{background: #DDD9C3;}
			.maintable tr.header td{color: #999999;}
			.tr_field_hover td {background: #F6F6F6 !important;}
			.tdshow td{background: #F8F8F8;}
			
			.title_panel{width: 100%;height: 30px;margin-top: 10px;}
			.title_txt{width: auto;line-height: 30px;float: left;font-weight: bold;font-size: 13px;color: #fff;margin-left: 10px;}
			
			.btn_con{width: auto;;height: 20px;position: absolute;right: 4px;top:4px;}
			.btn_add{width: 20px;height: 20px;background: url('../images/add.png');cursor: pointer;float: left;margin-right: 5px;}
			.btn_add_hover{background: url('../images/add_hover.png');}
			.btn_del{width: 20px;height: 20px;background: url('../images/delete.png');cursor: pointer;float: left;}
			.btn_del_hover{background: url('../images/delete_hover.png');}
			.btn1{width: 55px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;color:#808080;cursor: pointer;margin-left: 5px;float: left;font-weight: normal !important;font-size: 12px !important;}
			.btn2{width: 40px;line-height: 20px;height: 20px;text-align: center;border: 1px #B0B0B0 solid;color:#808080;cursor: pointer;margin-left: 5px;float: left;}
			
			.btn_browser{width:22px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.btn_browser2{width:20px;height:20px;float: left;margin-left: 0px;margin-top: 2px;margin-right: 2px;cursor: pointer;
				background: url('../images/btn_browser.png') center no-repeat !important;}
			.txt_browser{width:200px;height:22px;line-height:22px;float: left;margin-top: 2px;}
			.txt_browser2{width:80px;height:20px;line-height:18px;float: left;margin-top: 2px;}
			.btn_manager{width:60px;height: 20px;line-height: 20px;text-align: center;border:1px #B0B0B0 solid;color:#808080;float: right;cursor: pointer;margin-top: 1px;margin-right: 2px;}
			.btn_hover{background: #5581DA;color: #fff;border-color: #5581DA;}
				
			.status{width: 30px;height: 20px;margin-right: 10px;display:-moz-inline-box;display:inline-block;float: left;}
			.status0{background: url('../images/pstatus0.png') center no-repeat;}
			.status1{background: url('../images/pstatus1.png') center no-repeat;}
			.status2{background: url('../images/pstatus2.png') center no-repeat;}
			.status3{background: url('../images/pstatus3.png') center no-repeat;}
			.status4{background: url('../images/pstatus4.png') center no-repeat;}
			.status_txt{line-height: 20px;display:-moz-inline-box;display:inline-block;float: left;}
			.status_link{cursor: pointer;}
			
			.input_txt{width: 96%;border: 0px;border-bottom: 1px #F8F8F8 solid;background: none;height: 24px;padding-left: 0px;margin-left: 0px;outline: none;}
			.input_txt_hover{border-bottom-color: #D1D1D1 !important;}
			.input_txt_focus{border-bottom-color: #FF8040 !important;}
			.table_item{width: 100%;background: #fff;}
			.table_item td{}
			.field_item{}
			.field_title{width:100%;border-bottom: 1px #59D445 solid;height: 30px;line-height: 30px;empty-cells: show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow: ellipsis;}
			.field_value{width:100%;min-height:30px;height: auto;border-bottom: 1px #DCDCDC solid;line-height: 28px;<%if(canedit){%>height:28px;<%}%>color:#999999 !important;background: #fff !important;}
			.field_value .input_txt{color:#999999 !important;}
			.field_check{height: 28px;}
			.table_item td .icheck{margin-bottom: 5px;vertical-align: middle;}
			
			.btn_set{width: 150px;height: 22px;background: #fff;border: 1px #C3C3C3 solid;text-align: center;line-height: 22px;margin-top: 10px;margin-bottom: 10px;cursor: pointer;}
			.btn_set_hover{background: #4F95E4;color: #fff;border-color: #4F95E4;}
			.btn_set_select{background: #4F95E4;color: #fff;border-color: #4F95E4;}
			button.Calendar{height: 22px !important;background-position: bottom left;}
			.loadstr{
				display:none;
				position: absolute;
				top: 0px;right: 0px;
				bottom: 0px;left: 0px;
				background: url(/workrelate/task/images/bg_ahp.png) repeat;
				z-index:3;
			}
			.loadstr2{
				position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;
				background:url(/workrelate/task/images/loading1.gif) center no-repeat;
				z-index:4;
			}
			.loadtext{
				position: absolute;
				top:50%;
				left:50%;
				height:30px;
				line-height:30px;
				width:200px;
				margin-left:-100px;
				margin-top: -45px;
			}
		</style>
	<%@ include file="/secondwev/common/head.jsp" %>
	<SCRIPT language="javascript" src="/workrelate/js/pointout.js"></script>
	</head>
	<%
		
	%>
	<BODY style="overflow: auto">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
			if(canedit){
				RCMenu += "{保存,javascript:doSave(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
				
				if(!programid2.equals("")&&!programid2.equals("0")){
					RCMenu += "{删除,javascript:doDelete(this),_self}";
					RCMenuHeight += RCMenuHeightStep ;
				}
			}
			if(canReference){
				RCMenu += "{同步,javascript:doReference(this),_self}";
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
		<div id="loadstr" class="loadstr" align='center'>
			<div class="loadstr2"></div>
			<div class="loadtext">正在同步，请稍等...</div>
		</div>
		<form id="form1" name="form1" action="ProgramOperation.jsp" method="post">
			<input type="hidden" name="programid" value="<%=programid2 %>">
			<input type="hidden" name="resourceid" value="<%=resourceid %>">
			<input type="hidden" name="resourcetype" value="<%=resourcetype %>">
			<input type="hidden" name="programtype" value="<%=programtype %>">
			<input type="hidden" id="operation" name="operation" value="">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<td height="1" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<div class="tabpanel">
							<%if(isweek==1){%><div class="tab <%if(programtype.equals("2")){ %>tab_click<%} %>" onclick="changeType(2)">周报</div><%} %>
							<%if(ismonth==1){ %><div class="tab <%if(programtype.equals("1")){ %>tab_click<%} %>" onclick="changeType(1)">月报</div><%} %>
							<div class="tab2_panel" style="width: 1px;border-right: 0px;"></div>
							<div class="maintitle"><%=showName %>计划报告模板设置<%if(!mbName.equals("")){ %><font style="font-size: 12px;font-weight: normal;font-style: italic" title="<%=mbTitle%>"> [<%=mbName %>]</font><%} %></div>
							<%if(canedit||canReference){%>
							<div id="operate_panel" style="width: auto;height: 28px;float: right;margin-top: 4px;">
								<%if(canReference){ %>
								<div class="btn1 btn" onclick="doReference();" title="同步该模板给其他人员">同步</div>
								<%} %>
								<%if(canedit){ %>
								<div class="btn1 btn" onclick="doSave();" title="保存模板">保存</div>
								<%if(!programid2.equals("")&&!programid2.equals("0")){ %><div class="btn1 btn" onclick="doDelete();" title="删除自定义模板">删除</div><%} %>
								<%} %>
							</div>
							<%} %>
						</div>
						
						<div id="tableset" style="width:100%;overflow: hidden;display: none;">
						<div style="width: 100%;height: 20px;background: url('../images/line_up.png') center no-repeat;"></div>
						<table class="maintable" cellspacing="0" cellpadding="0" border="0">
							<colgroup>
								<col width="20%"/><col width="20%"/><col width="20%"/><col width="20%"/><col width="*"/>
							</colgroup>
							<tr class="header">
								<td>字段</td>
								<td class="tdtype1"><%if(canedit){ %><input id="checkall1" type="checkbox" id="" onclick="checkAll(1)"/><%} %>是否显示</td><td class="tdtype1"><%if(canedit){ %><input id="checkmustall1" type="checkbox" onclick="checkMustAll(1)"/><%} %>是否必填</td><td class="tdtype1">排序</td><td class="tdtype1">宽度比例</td>
								<td class="tdtype2"><%if(canedit){ %><input id="checkall2" type="checkbox" id="" onclick="checkAll(2)"/><%} %>是否显示</td><td class="tdtype2"><%if(canedit){ %><input id="checkmustall2" type="checkbox" onclick="checkMustAll(2)"/><%} %>是否必填</td><td class="tdtype2">排序</td><td class="tdtype2">宽度比例</td>
								<td>自定义名称</td>
							</tr>
							<%
								List fieldlist = new ArrayList();
								int index = 0;
								String fieldname = "";
								rs.executeSql("select showname,fieldname,customname,isshow,showorder,showwidth,isshow2,showorder2,showwidth2,ismust,ismust2 from PR_PlanProgramDetail where programid="+programid+" order by showorder");
								while(rs.next()){
									fieldname = Util.null2String(rs.getString("fieldname"));
									fieldlist.add(new String[]{fieldname,Util.null2String(rs.getString("showname"))
											,Util.null2String(rs.getString("customname")),Util.null2String(rs.getString("isshow"))
											,Util.null2String(rs.getString("showorder")),Util.null2String(rs.getString("showwidth"))
											,Util.null2String(rs.getString("isshow2")),Util.null2String(rs.getString("showorder2"))
											,Util.null2String(rs.getString("showwidth2")),Util.null2String(rs.getString("ismust")),Util.null2String(rs.getString("ismust2"))});
							%>
							<tr class="tr_field<%if(sfields.indexOf(fieldname)>-1){ %> sfield<%} %>">
								<td>
									<%=Util.null2String(rs.getString("showname")) %>
									<input type="hidden" id="fieldname_<%=index %>" name="fieldname_<%=index %>" value="<%=fieldname %>"/>
									<input type="hidden" id="<%=fieldname %>_showname" name="<%=fieldname %>_showname" value="<%=Util.null2String(rs.getString("showname")) %>"/>
								</td>
								<!-- 总结 -->
								<td class="tdtype1"><input <%if(!fieldname.equals("name")){ %>class="isshow1 isshow"<%} %> type="checkbox" id="<%=fieldname %>_isshow" name="<%=fieldname %>_isshow" 
									<%if("1".equals(rs.getString("isshow"))||fieldname.equals("name")){ %> checked="checked"  value="1"<%} %>
									<%if(!canedit || fieldname.equals("name")){ %> disabled="disabled" <%} %> _fieldname="<%=fieldname %>"/></td>
								
								<td class="tdtype1"><input <%if(!fieldname.equals("name")){ %>class="ismust1 ismust"<%} %> type="checkbox" id="<%=fieldname %>_ismust" name="<%=fieldname %>_ismust" 
									<%if("1".equals(rs.getString("ismust"))||fieldname.equals("name")){ %> checked="checked"  value="1"<%} %>
									<%if(!canedit || fieldname.equals("name") || "0".equals(rs.getString("isshow"))){ %> disabled="disabled" <%} %> _fieldname="<%=fieldname %>"/></td>
								
								<td class="tdtype1">
									<%if(canedit){ %>
										<input type="text" class="input_txt" id="<%=fieldname %>_showorder" name="<%=fieldname %>_showorder" value="<%=Util.null2String(rs.getString("showorder")) %>"
											onKeyPress="ItemNum_KeyPress('<%=fieldname %>_showorder')" onBlur="checknumber('<%=fieldname %>_showorder')" onchange="setitem('')" maxlength="10"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("showorder")) %>
										<input type="hidden" id="<%=fieldname %>_showorder" name="<%=fieldname %>_showorder" value="<%=Util.null2String(rs.getString("showorder")) %>"/>
									<%} %>
								</td>
								<td class="tdtype1">
									<%if(canedit){ %>
										<input type="text" class="input_txt" id="<%=fieldname %>_showwidth" name="<%=fieldname %>_showwidth" value="<%=Util.null2String(rs.getString("showwidth")) %>"
											onKeyPress="ItemCount_KeyPress()" onBlur="checkcount('<%=fieldname %>_showwidth')" onchange="setitem('')" maxlength="10"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("showwidth")) %>
										<input type="hidden" id="<%=fieldname %>_showwidth" name="<%=fieldname %>_showwidth" value="<%=Util.null2String(rs.getString("showwidth")) %>"/>
									<%} %>		
								</td>
								<!-- 计划 -->
								<td class="tdtype2"><input <%if(!fieldname.equals("name")){ %>class="isshow2"<%} %> type="checkbox" id="<%=fieldname %>_isshow2" name="<%=fieldname %>_isshow2"  
									<%if("1".equals(rs.getString("isshow2"))||fieldname.equals("name")){ %> checked="checked" value="1"<%} %>
									<%if(!canedit || fieldname.equals("name")){ %> disabled="disabled" <%} %> _fieldname="<%=fieldname %>"/></td>
									
								<td class="tdtype2"><input <%if(!fieldname.equals("name")){ %>class="ismust2"<%} %> type="checkbox" id="<%=fieldname %>_ismust2" name="<%=fieldname %>_ismust2"  
									<%if("1".equals(rs.getString("ismust2"))||fieldname.equals("name")){ %> checked="checked" value="1"<%} %>
									<%if(!canedit || fieldname.equals("name")|| "0".equals(rs.getString("isshow2"))){ %> disabled="disabled" <%} %> _fieldname="<%=fieldname %>"/></td>
									
								<td class="tdtype2">
									<%if(canedit){ %>
										<input type="text" class="input_txt" id="<%=fieldname %>_showorder2" name="<%=fieldname %>_showorder2" value="<%=Util.null2String(rs.getString("showorder2")) %>"
											onKeyPress="ItemNum_KeyPress('<%=fieldname %>_showorder2')" onBlur="checknumber('<%=fieldname %>_showorder2')" onchange="setitem('2')" maxlength="10"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("showorder2")) %>
										<input type="hidden" id="<%=fieldname %>_showorder2" name="<%=fieldname %>_showorder2" value="<%=Util.null2String(rs.getString("showorder2")) %>"/>
									<%} %>	
								</td>
								<td class="tdtype2">
									<%if(canedit){ %>
										<input type="text" class="input_txt" id="<%=fieldname %>_showwidth2" name="<%=fieldname %>_showwidth2" value="<%=Util.null2String(rs.getString("showwidth2")) %>"
											onKeyPress="ItemCount_KeyPress()" onBlur="checkcount('<%=fieldname %>_showwidth2')" onchange="setitem('2')" maxlength="10"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("showwidth2")) %>
										<input type="hidden" id="<%=fieldname %>_showwidth2" name="<%=fieldname %>_showwidth2" value="<%=Util.null2String(rs.getString("showwidth2")) %>"/>
									<%} %>
								</td>
								<td>
									<%if(canedit){ %>
										<input type="text" class="input_txt" id="<%=fieldname %>_customname" name="<%=fieldname %>_customname" value="<%=Util.null2String(rs.getString("customname")) %>" onchange="setitem('');setitem('2');"/>
									<%}else{ %>
										<%=Util.null2String(rs.getString("customname")) %>
										<input type="hidden" id="<%=fieldname %>_customname" name="<%=fieldname %>_customname" value="<%=Util.null2String(rs.getString("customname")) %>"/>
									<%} %>	
								</td>
							</tr>
							<%	index++;} %>
						</table>
						<div style="width: 100%;height: 20px;background: url('../images/line_down.png') center no-repeat;"></div>
						</div>
						<div class="title_panel" style="background: #45A435;">
							<div class="title_txt">工作总结预览</div>
						</div>
						<table style="width: 100%;border: 1px #45A435 solid;" cellpadding="0" cellspacing="0" border="0">
							<tr class="tdshow">
								<td width="12px;"></td>
								<td width="*" style="padding-bottom: 4px;">
									<table class="table_item" cellpadding="0" cellspacing="0" bgcolor="0">
										<tr id="itemdiv">
													
										<%
											String[] fieldss = null;
											String showname = "";
											for(int i=0;i<fieldlist.size();i++){
												fieldss = (String[])fieldlist.get(i);
												fieldname = fieldss[0];
												showname = fieldss[1];
												if(fieldss[2]!=null && !fieldss[2].equals("")) showname = fieldss[2];
										%>
											<td id="item_<%=fieldname %>" class="field_item" _showorder="<%=fieldss[7] %>" width="" valign="top">
												<div class="field_title"><%=showname %></div>
											</td>
										<%	} %>
										</tr>
									</table>
								</td>
							</tr>
							<%if(canedit){%>
							<tr class="tdshow">
								<td></td>
								<td align="center">
									<div class="btn_set" align="center" onclick="showTableSet(1)">自定义总结列字段</div>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><div id="customset1" style="width: 100%;height: auto;font-size: 0px;"></div></td>
							</tr>
							<%} %>
						</table>
						<div class="title_panel" style="background: #5895DA;position: relative;">
							<div class="title_txt">工作计划预览</div>
							<%if(canedit){%>
								<div class="btn_con" >
									<div class="btn_add" onclick="doAddRow1()" title="添加"></div>
									<div class="btn_del" onclick="doDelRow1()" title="删除"></div>
								</div>
							<%} %>
						</div>
						<table style="width: 100%;border: 1px #5895DA solid;" cellpadding="0" cellspacing="0" border="0">
							<tr class="tdshow">
								<td width="12px;"></td>
								<td valign="top" width="*" style="padding-bottom: 4px;">
									<%
										rs.executeSql("select id,name,cate,begindate1,enddate1,begindate2,enddate2,days1,days2,finishrate,target,result,custom1,custom2,custom3,custom4,custom5 from PR_PlanReportDetail where programid="+programid+" order by id");
										indexnum = rs.getCounts();	
										String[][] datass = new String[16][indexnum];
										int count = 0;
										while(rs.next()){
											datass[0][count] = Util.null2String(rs.getString("cate"));
											datass[1][count] = Util.null2String(rs.getString("name"));
											datass[2][count] = Util.null2String(rs.getString("begindate1"));
											datass[3][count] = Util.null2String(rs.getString("enddate1"));
											datass[4][count] = Util.null2String(rs.getString("days1"));
											datass[5][count] = Util.null2String(rs.getString("target"));
											datass[6][count] = Util.null2String(rs.getString("begindate2"));
											datass[7][count] = Util.null2String(rs.getString("enddate2"));
											datass[8][count] = Util.null2String(rs.getString("days2"));
											datass[9][count] = Util.null2String(rs.getString("finishrate"));
											datass[10][count] = Util.null2String(rs.getString("result"));
											datass[11][count] = Util.null2String(rs.getString("custom1"));
											datass[12][count] = Util.null2String(rs.getString("custom2"));
											datass[13][count] = Util.null2String(rs.getString("custom3"));
											datass[14][count] = Util.null2String(rs.getString("custom4"));
											datass[15][count] = Util.null2String(rs.getString("custom5"));
											count++;
										}
									%>
									<table class="table_item" cellpadding="0" cellspacing="0" bgcolor="0">
										<tr>
											<%if(canedit){%>
												<td id="item_check" width="30px" valign="top">
													<div class="field_title" style="border-color: #5895DA"></div>
													<%for(int i=0;i<indexnum;i++){ %>
													<div class="field_value field_check field_value_<%=i %>">
														<input class="icheck" type="checkbox" _index="<%=i %>" />
													</div>
													<%} %>
												</td>
											<%} %>
											<td width="*" valign="top">
												<table class="table_item" cellpadding="0" cellspacing="0" bgcolor="0">
													<tr id="itemdiv2">
													
													<%
														//String[] fieldss = null;
														//String showname = "";
														for(int i=0;i<fieldlist.size();i++){
															fieldss = (String[])fieldlist.get(i);
															fieldname = fieldss[0];
															showname = fieldss[1];
															if(fieldss[2]!=null && !fieldss[2].equals("")) showname = fieldss[2];
															if(fieldname.equals("name") && canedit) showname += "(必填)";
													%>
														<td id="item2_<%=fieldname %>" class="field_item2" _showorder="<%=fieldss[7] %>" width="" valign="top">
															<div class="field_title" style="border-color: #5895DA"><%=showname %></div>
															<%for(int j=0;j<indexnum;j++){ %>
																<div class="field_value field_value_<%=j %>">
																<%if(canedit){%>
																<%if(fieldname.indexOf("date")>-1){ %>
																<button type="button" class="Calendar" onclick="gettheDate('<%=fieldname %>_value_<%=j %>','<%=fieldname %>_span_<%=j %>')">
																</button><span id="<%=fieldname %>_span_<%=j %>" class="datespan"><%=Util.null2String(rs.getString(fieldname)) %></span>
			              										<input type="hidden" id="<%=fieldname %>_value_<%=j %>" name="<%=fieldname %>_value_<%=j %>" value="<%=datass[i][j] %>">
																<%}else{ %>
																	<input class="input_txt" type="text" id="<%=fieldname %>_value_<%=j %>" name="<%=fieldname %>_value_<%=j %>" value="<%=datass[i][j] %>"
																	<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
																	onkeypress="ItemNum_KeyPress('<%=fieldname %>_value_<%=j %>')" onblur="checknumber('<%=fieldname %>_value_<%=j %>')"<%} %>/>
																<%} %>	
																<%}else{ %>
																	<%=datass[i][j] %>
																<%} %>
																</div>
															<%} %>
														</td>
													<%	} %>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<%if(canedit){%>
							<tr class="tdshow">
								<td></td>
								<td align="center">
									<table>
										<tr>
											<td><div class="btn_set" align="center" onclick="showTableSet(2)">自定义计划列字段</div></td>
											<td><div class="btn_set btn_set2" align="center" onclick="doAddRow1()">增加默认计划内容</div></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td></td>
								<td><div id="customset2" style="width: 100%;height: auto;font-size: 0px;"></div></td>
							</tr>
							<%} %>
						</table>
						
						<div class="title_panel" style="background: #FF9968;">
							<div class="title_txt">报告审批</div>
						</div>
						<table style="width: 100%;border: 1px #FF9968 solid;" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<td width="12px;"></td>
								<td width="*">
									<table class="maintable" cellspacing="0" cellpadding="0" border="0">
										<tr>
											<td width="50%" style="height: 30px;border: 0px;">
												<%if(canedit){%>
												<div class="btn_browser" onclick="onShowMutiHrm('auditids','auditidsSpan')"></div>
												<div class="txt_browser" id="auditidsSpan"><%=auditnames %></div>
												<div class="btn_manager btn" onclick="selectManager('auditids','auditidsSpan')">直接上级</div>
												<input type="hidden" id="auditids" name="auditids" value="<%=auditids %>"/>
												<%}else{ %>
													<%=auditnames %>
													<%if(auditnames.equals("")){ %><font style="color: #808080;font-style: italic;">无</font><%} %>
												<%} %>
											</td>
											<td width="50%"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<div style="width: 100%;height: 10px;font-size: 0px;"></div>
						<%if(!programid.equals("")){  %>
						<div style="width: 50%;float: left;">
						<%
							rs.executeSql("select operator,operatedate,operatetime,operatetype from PR_PlanProgramLog where programid="+programid+" order by operatedate desc,operatetime desc,id desc");
							if(rs.getCounts()>0){
						%>
							<div class="title_panel">
								<div class="title_txt" style="color: #808080;">操作日志</div>
							</div>
						<%		String logoperator = "";
								while(rs.next()){
									logoperator = Util.null2String(rs.getString("operator"));
									if(logoperator.equals("0")){
										logoperator = "系统";
									}else{
										logoperator = cmutil.getPerson(logoperator);
									}
						%>
							<div style="color: #808080;margin-left: 10px;"><%=logoperator %>&nbsp;&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatedate")) %>&nbsp;&nbsp;<%=Util.null2String(rs.getString("operatetime")) %>&nbsp;&nbsp;&nbsp;<%=cmutil.getProgramOperateType(rs.getString("operatetype")) %></div>
						<%		}
							}
						%>
						</div>
						<%} %>
						
					</td>
					<td></td>
				</tr>
			</table>
			<input type="hidden" id="indexnum" name="indexnum" value="<%=indexnum %>" />
			<input type="hidden" id="index" name="index" value="<%=index %>" />
		</form>
		<script type="text/javascript" defer="defer">
			var loadstr = "<img src='../images/loading2.gif'/>";
			jQuery(document).ready(function(){
				<%if(isrefresh.equals("1")){%>
					refreshOpener();
				<%}%>

				jQuery("div.btn").live("mouseover",function(){
					jQuery(this).addClass("btn_hover");
				}).live("mouseout",function(){
					jQuery(this).removeClass("btn_hover");
				});

				<%if(canedit){ %>
				jQuery("div.btn_set").bind("mouseover",function(){
					jQuery(this).addClass("btn_set_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_set_hover");
				}).bind("click",function(){
					if(!jQuery(this).hasClass("btn_set2")){
						if(jQuery(this).hasClass("btn_set_select")){
							jQuery(this).removeClass("btn_set_select");
						}else{
							jQuery("div.btn_set").removeClass("btn_set_select");
							jQuery(this).addClass("btn_set_select");
						}
					}
				});
				jQuery("div.btn_add").bind("mouseover",function(){
					jQuery(this).addClass("btn_add_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_add_hover");
				});
				jQuery("div.btn_del").bind("mouseover",function(){
					jQuery(this).addClass("btn_del_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("btn_del_hover");
				});
				
				jQuery(".input_txt").live("mouseover",function(){
					jQuery(this).addClass("input_txt_hover");
				}).live("mouseout",function(){
					jQuery(this).removeClass("input_txt_hover");
				}).live("focus",function(){
					jQuery(this).addClass("input_txt_focus");
				}).live("blur",function(){
					jQuery(this).removeClass("input_txt_focus");
				});

				jQuery("tr.tr_field").bind("mouseover",function(){
					jQuery(this).addClass("tr_field_hover");
					jQuery(this).find(".input_txt").addClass("input_txt_hover");
				}).bind("mouseout",function(){
					jQuery(this).removeClass("tr_field_hover");
					jQuery(this).find(".input_txt").removeClass("input_txt_hover");
				});
				

				jQuery("input.isshow1").bind("click",function(){
					setitem("");
					var _tr1 = $(this).parent().parent().parent();
					if($(this).attr("checked")){
					   disOrEnableCheckbox(_tr1.find(".ismust1"),false);
					}else{
					   disOrEnableCheckbox(_tr1.find(".ismust1"),true);
					}
				});
				jQuery("input.isshow2").bind("click",function(){
					setitem("2");
					var _tr2 = $(this).parent().parent().parent();
					if($(this).attr("checked")){
					   disOrEnableCheckbox(_tr2.find(".ismust2"),false);
					}else{
					   disOrEnableCheckbox(_tr2.find(".ismust2"),true);
					}
				});
				<%}%>
				setitem("");
				setitem("2");
			});
			jQuery(window).resize(function(){
				<%if(!canedit){ %>setheight();<%}%>
			});

			function setheight(){
				var rows = <%=indexnum%>;
				var maxh = 0;
				for(var i=0;i<rows;i++){
					maxh = 0;
					jQuery("div.field_value_"+i).height("auto");
					jQuery("div.field_value_"+i).each(function(){
						if(jQuery(this).parent().css("display")!="none"){
							var dh = jQuery(this).height();
							//alert(dh+jQuery(this).html());
							if(dh>maxh) maxh = dh;
						}
					});
					jQuery("div.field_value_"+i).height(maxh+1);
				}
			}
			function setitem(type){
				//总宽度比例
				var sumwidth = getFloatVal(jQuery("#name_showwidth"+type).val());
				jQuery("input.isshow"+type+":checked").each(function(){
					sumwidth += getFloatVal(jQuery("#"+jQuery(this).attr("_fieldname")+"_showwidth"+type).val());
				});
				var sumrate = 0;
				var lastid = "";
				var lastrate = 0;
				for(var i=0;i<<%=index%>;i++){
					var fieldname = jQuery("#fieldname_"+i).val();
					if(jQuery("#"+fieldname+"_isshow"+type).attr("checked")){
						var cwidth = getFloatVal(jQuery("#"+fieldname+"_showwidth"+type).val());
						var cscort = getFloatVal(jQuery("#"+fieldname+"_showorder"+type).val());
						var rate = 0;
						if(sumwidth!=0) rate = (getFloatVal(cwidth/sumwidth*100)).toFixed(0);
						sumrate += getIntVal(rate);
						//if(sumrate>100) rate = 100 - (sumrate-rate);
						//alert(sumrate);
						lastid = "item"+type+"_"+fieldname;
						lastrate = getIntVal(rate);
						jQuery("#"+lastid).attr({"_showorder":cscort,"width":(rate+"%")}).show();
						if(fieldname.indexOf("custom")==0){
							if(jQuery("#"+fieldname+"_customname").val()==""){
								jQuery("#item"+type+"_"+fieldname).children("div.field_title").html(jQuery("#"+fieldname+"_showname").val());
							}else{
								jQuery("#item"+type+"_"+fieldname).children("div.field_title").html(jQuery("#"+fieldname+"_customname").val());
							}
						}
					}else{
						jQuery("#item"+type+"_"+fieldname).hide();
					}
				}
				//if(sumrate!=100){
				lastrate = 100 - (sumrate-lastrate);
				jQuery("#"+lastid).attr("width",lastrate+"%");
				//} 
				jQuery("#itemdiv"+type).html(
					jQuery("td.field_item"+type).sorted({
						by: function(v) {
							return parseInt(v.attr('_showorder'));
						}
					})
				);


				<%if(!canedit){ %>if(type=="2") setheight();<%}%>
			}
			
			
			<%if(canedit){ %>
			var setindex = null;
			function showTableSet(_index){
				if(_index==1){
					jQuery("td.tdtype1").show();
					jQuery("td.tdtype2").hide();
					jQuery("tr.sfield").show();
				}else{
					jQuery("td.tdtype2").show();
					jQuery("td.tdtype1").hide();
					jQuery("tr.sfield").hide();
				}
				if(setindex==_index){
					jQuery("#tableset").slideToggle(100);
				}else{
					jQuery("#customset"+_index).append(jQuery("#tableset"));
					jQuery("#tableset").hide().slideDown(100);
					setindex = _index;
				}
				
				//jQuery("#tableset").css({"top":_t,"left":12}).animate({ height:'auto'},200,null,null);
			}
			function checkAll(type){
				var _obj = jQuery("#checkall"+type);
				if(_obj.attr("checked")){
					//jQuery(".isshow"+type).attr("checked",true);
					changeCheckboxStatus($(".isshow"+type),true);
					disOrEnableCheckbox($(".ismust"+type),false);
				}else{
					//jQuery(".isshow"+type).attr("checked",false);
					changeCheckboxStatus($(".isshow"+type),false);
					disOrEnableCheckbox($(".ismust"+type),true);
				}
				if(type==1) setitem("");
				if(type==2) setitem("2");
			}
			function checkMustAll(type){
			   var _obj = jQuery("#checkmustall"+type);
				if(_obj.attr("checked")){
					changeCheckboxStatus($(".ismust"+type),true);
				}else{
					changeCheckboxStatus($(".ismust"+type),false);
				}
			}
			function doSave(obj) {
				if(checkmust()){
					confirmStyle("提示：未填写标题的明细项将不会保存，确定继续执行操作？",function(){
			           jQuery("input:checked").val(1);
					   jQuery("#operation").val("save");
					   if(obj!=null && typeof(obj)!="undefined"){
						   obj.disabled = true;
					   }
					   showload();
					   jQuery("#form1").submit();
			        });
				}else{
				    jQuery("input:checked").val(1);
					jQuery("#operation").val("save");
					if(obj!=null && typeof(obj)!="undefined"){
						obj.disabled = true;
					}
					showload();
					jQuery("#form1").submit();
				}
			}
			var rowindex = <%=indexnum%>;
			function doAddRow1(){
				var htmlstr = "";
				htmlstr ="<div class=\"field_value field_check field_value_"+rowindex+"\">"
						+"	<input type=\"checkbox\" _index=\""+rowindex+"\" />"
						+"</div>";
				jQuery("#item_check").append(htmlstr);
			<%
				for(int i=0;i<fieldlist.size();i++){
					fieldss = (String[])fieldlist.get(i);
					fieldname = fieldss[0];
					
			%>
				htmlstr ="<div class=\"field_value field_value_"+rowindex+"\">";
			<%if(fieldname.indexOf("date")>-1){ %>
				htmlstr +="<button type=\"button\" class=\"Calendar\" onclick=\"gettheDate('<%=fieldname %>_value_"+rowindex+"','<%=fieldname %>_span_"+rowindex+"')\">";
				htmlstr +="</button><span id=\"<%=fieldname %>_span_"+rowindex+"\" class=\"datespan\"></span>";
				htmlstr +="<input type=\"hidden\" id=\"<%=fieldname %>_value_"+rowindex+"\" name=\"<%=fieldname %>_value_"+rowindex+"\" value=\"\">";
			<%}else{%>		
				htmlstr +="<input class=\"input_txt\" type=\"text\" id=\"<%=fieldname %>_value_"+rowindex+"\" name=\"<%=fieldname %>_value_"+rowindex+"\" value=\"\" ";
				<%if(fieldname.equals("days1")||fieldname.equals("days2")||fieldname.equals("finishrate")){%>
				htmlstr +="onkeypress=\"ItemNum_KeyPress('<%=fieldname %>_value_"+rowindex+"')\" onblur=\"checknumber('<%=fieldname %>_value_"+rowindex+"')\"";
				<%} %>
				htmlstr +="/>";
			<%}%>
				htmlstr +="</div>";
				jQuery("#item2_<%=fieldname %>").append(htmlstr);	
			<%	} %>
				
				rowindex++;
				jQuery("#indexnum").val(rowindex);
				
			}
			function doDelRow1(){
				var checks = jQuery("#item_check").find("input:checked");
				if(checks.length>0){
					confirmStyle("确定删除选择明细项?",function(){
					    checks.each(function(){
							var _index = jQuery(this).attr("_index");
							jQuery("div.field_value_"+_index).remove();
						});
					});
					//if(confirm("确定删除选择明细项?")){
						//checks.each(function(){
							//var _index = jQuery(this).attr("_index");
							//jQuery("div.field_value_"+_index).remove();
						//});
					//}
				}else{
					alertStyle("请选择删除项!");
				}
			}
			function checkmust(){
				var noname = false;
				for(var i=0;i<rowindex;i++){
					var nameobj = jQuery("#name_value_"+i);
					if(nameobj.length>0 && nameobj.val()==""){
						noname = true;
						break;
					}
				}
				return noname;
			}
			function onShowMutiHrm(inputid,inputspan) {
				var resourceids = $("#"+inputid).val();
				if(resourceids=="-1") resourceids = "<%=managerid%>";
			    var diag;
				    try{
						var _parentWin = window;
					    while (_parentWin != _parentWin.parent) {
						   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
							     _parentWin = _parentWin.parent;
						   }
						   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
							    diag = new Dialog();
						   }else{
							    diag = new _parentWin.Dialog();
						   }
				    }catch(e){
						diag = new Dialog();
				    }
				    diag.Title = "选择审批人员";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceids;
					diag.Width = 660;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	if(datas.id!=""){
				    		$("#"+inputid).val(datas.id);
						    $("#"+inputspan).html(datas.name);
						}else{
							$("#"+inputid).val("");
						    $("#"+inputspan).html("");
						}
				      }
					};
					diag.show();
			}
			function selectManager(inputid,inputspan){
				$("#"+inputid).val(-1);
	    		$("#"+inputspan).html("<%=managername%>");
			}
			function targetKeyPress(_index){
				var itemid = $("#accessitemid_"+_index).val();
				var itemtype = itemMap.get(itemid);
				if(itemtype==2){
					ItemNum_KeyPress("target_"+_index);
				}
			}
			<%if(!programid2.equals("")&&!programid2.equals("0")){%>
			function doDelete(obj){
				confirmStyle("确定删除此自定义模板?",function(){
					    jQuery("#operation").val("delete");
						if(obj!=null && typeof(obj)!="undefined"){
							obj.disabled = true;
						}
						showload();
						jQuery("#form1").submit();
					});
			}
			<%}%>
			<%}%>
			<%if(canReference){%>
			function doReference(obj){
				if(obj!=null && typeof(obj)!="undefined"){
					obj.disabled = true;
				}
				//var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
				var diag;
				    try{
						var _parentWin = window;
					    while (_parentWin != _parentWin.parent) {
						   if (_parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0 && _parentWin == _parentWin.parent) break;
							     _parentWin = _parentWin.parent;
						   }
						   if(_parentWin.document.getElementsByTagName("FRAMESET").length > 0){
							    diag = new Dialog();
						   }else{
							    diag = new _parentWin.Dialog();
						   }
				    }catch(e){
						diag = new Dialog();
				    }
				    diag.Title = "选择同步人员";
					diag.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
					diag.Width = 660;
					diag.Height = 600;
					diag.callback=function(datas){
					  if (datas) {
				    	$("#loadstr").show();
						$.ajax({
							url:"ProgramOperation.jsp",
							type:"post",
							dataType:"json",
							data:{"ids":datas.id,"names":datas.name,"subCompanyids_refence":"<%=subCompanyids_refence%>",
								"programid":"<%=programid%>","operation":"doReference","programtype":"<%=programtype%>"},
							success:function(data){
								if(data.msg!=""){
									alertStyle(data.msg);
								}else{
									alertStyle("同步成功");
								}
							},
							complete:function(){
								$("#loadstr").hide();
								if(obj!=null && typeof(obj)!="undefined"){
									obj.disabled = false;
								}
							}
						});
				      }
					};
					diag.show();
			}
			<%}%>
			function changeType(type){
				window.location = "ProgramView.jsp?resourceid=<%=resourceid%>&resourcetype=<%=resourcetype%>&programtype="+type;
			}
			function showload(){
				jQuery("#operate_panel").html(loadstr);
			}
		</script>
	</BODY>
</HTML>