
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util,weaver.file.ExcelSheet,weaver.file.ExcelRow,weaver.secondary.file.ExcelStyle" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SecExcelFile" class="weaver.secondary.file.ExcelFile" scope="session" />
<%
	//权限判断 CRM管理员具有查询权限
	String sql = "select id from HrmRoleMembers where roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID();
	rs.executeSql(sql);
	if(!rs.next() && user.getUID()!=897){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	String titlename = "客户滚动及商机覆盖情况分析";
	
	int stattype = Util.getIntValue(request.getParameter("stattype"),1);
	String province = Util.null2String(request.getParameter("province"));
	String provincename = "";
	String hrmids = Util.null2String(request.getParameter("hrmids"));
	String hrmnames = "";
	String departmentids = Util.null2String(request.getParameter("departmentids"));
	String departmentnames = "";
	String addDateFrom = Util.null2String(request.getParameter("addDateFrom"));
	String addDateTo = Util.null2String(request.getParameter("addDateTo"));
	String addDateFrom2 = Util.null2String(request.getParameter("addDateFrom2"));
	String addDateTo2 = Util.null2String(request.getParameter("addDateTo2"));
	
	String caddDateFrom = Util.null2String(request.getParameter("caddDateFrom"));
	String caddDateTo = Util.null2String(request.getParameter("caddDateTo"));
	String caddDateFrom2 = Util.null2String(request.getParameter("caddDateFrom2"));
	String caddDateTo2 = Util.null2String(request.getParameter("caddDateTo2"));
	
	String saddDateFrom = Util.null2String(request.getParameter("saddDateFrom"));
	String saddDateTo = Util.null2String(request.getParameter("saddDateTo"));
	String saddDateFrom2 = Util.null2String(request.getParameter("saddDateFrom2"));
	String saddDateTo2 = Util.null2String(request.getParameter("saddDateTo2"));
	
	String ncontactDateFrom = Util.null2String(request.getParameter("ncontactDateFrom"));
	String ncontactDateTo = Util.null2String(request.getParameter("ncontactDateTo"));
	
	Map csum = new HashMap();
	Map psum = new HashMap();
	Map cadd = new HashMap();
	Map cadd2 = new HashMap();
	Map padd = new HashMap();
	Map padd2 = new HashMap();
	Map ccontact = new HashMap();
	Map pcontact = new HashMap();
	
	Map ssum = new HashMap();
	Map sadd = new HashMap();
	Map sadd2 = new HashMap();
	Map scontact = new HashMap();
	Map ssuccess = new HashMap();
	
	List idList = new ArrayList();
	String dhrmids = "";
	
	String fieldname = "t.city";
	String fieldname2 = "t.city";
	String where = "t.province in ("+province+")";
	String where2 = "t.province in ("+province+")";
	if(stattype==2 || stattype==3){
		fieldname = "t.manager";
		fieldname2 = "t2.creater";
		where = "t.manager in ("+hrmids+")";
		where2 = "t2.creater in ("+hrmids+")";
		
		if(stattype==3){
			rs.executeSql("select id from hrmresource where departmentid in ("+departmentids+") and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) order by departmentid,id");
			while (rs.next()) {
				dhrmids += "," + Util.null2String(rs.getString("id"));
				idList.add(Util.null2String(rs.getString("id")));
			}
			if(!dhrmids.equals("")) dhrmids = dhrmids.substring(1);
			//where = "t.manager in ("+dhrmids+")";
			//where2 = "t2.creater in ("+dhrmids+")";
			
			where = "exists (select 1  from hrmresource h where t.manager=h.id and h.departmentid in ("+departmentids+") and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3))";
			where2 = "exists (select 1  from hrmresource h where t2.creater=h.id and h.departmentid in ("+departmentids+") and h.loginid is not null and (h.status =0 or h.status = 1 or h.status = 2 or h.status = 3))";
		}
	}
	
	List provincelist = Util.TokenizerString(province,",");
	List hrmidlist = Util.TokenizerString(hrmids,",");
	List departmentidlist = Util.TokenizerString(departmentids,",");
	for(int i=0;i<provincelist.size();i++){
		provincename += ProvinceComInfo.getProvincename(((String)provincelist.get(i)).trim()) + "&nbsp;"; 
	}
	for(int i=0;i<hrmidlist.size();i++){
		hrmnames += "<A href='javaScript:openhrm("+hrmidlist.get(i)+")' onclick='pointerXY(event)'>"+ResourceComInfo.getLastname((String)hrmidlist.get(i))+"</A>" + "&nbsp;"; 
	}
	for(int i=0;i<departmentidlist.size();i++){
		departmentnames += DepartmentComInfo.getDepartmentname(((String)departmentidlist.get(i)).trim()) + "&nbsp;"; 
	}
	boolean cansearch = false;
	if((stattype==1 && !province.equals("")) || (stattype==2 && !hrmids.equals("")) || (stattype==3 && !dhrmids.equals(""))){
		cansearch = true;
		//查询客户总量
		sql = "select "+fieldname+" as mainid,count(t.id) as amount from CRM_CustomerInfo t where "+where+" and (t.deleted=0 or t.deleted is null)"
			+ " and t.type in (1,3,4,5) and t.status<>13"
			+ " group by "+fieldname;
		//System.out.println(sql);
		rs.executeSql(sql);
		while(rs.next()){
			csum.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
		}
		//查询人脉总量
		sql = "select "+fieldname+" as mainid,count(c.id) as amount from CRM_CustomerInfo t,CRM_CustomerContacter c where "+where+" and c.customerid=t.id and (t.deleted=0 or t.deleted is null) "
			+ " and t.type=26 and t.status<>13"
			+ " group by "+fieldname;
		rs.executeSql(sql);
		while(rs.next()){
			psum.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
		}
		
		//查询新增客户总量
		if(!addDateFrom.equals("") && !addDateTo.equals("")){
			sql = "select "+fieldname+" as mainid,count(t.id) as amount from CRM_CustomerInfo t where "+where+" and (t.deleted=0 or t.deleted is null) "
				+ " and t.type in (1,3,4,5) and t.status<>13"
				+ " and t.createdate >='"+addDateFrom+"' and t.createdate<='"+addDateTo+"'"
				+ " group by "+fieldname;
			rs.executeSql(sql);
			while(rs.next()){
				cadd.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		if(!addDateFrom2.equals("") && !addDateTo2.equals("")){
			sql = "select "+fieldname+" as mainid,count(t.id) as amount from CRM_CustomerInfo t where "+where+" and (t.deleted=0 or t.deleted is null) "
				+ " and t.type in (1,3,4,5) and t.status<>13"
				+ " and t.createdate >='"+addDateFrom2+"' and t.createdate<='"+addDateTo2+"'"
				+ " group by "+fieldname;
			rs.executeSql(sql);
			while(rs.next()){
				cadd2.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		//客户未联系查询
		if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){
			sql = "select "+fieldname+" as mainid,count(t.id) as amount from CRM_CustomerInfo t where "+where+" and (t.deleted=0 or t.deleted is null) "
				+ " and t.type in (1,3,4,5) and t.status<>13"
				+ " and t.createdate <='"+ncontactDateTo+"'"
				+ " and not exists (select 1 from WorkPlan w where w.type_n=3 and convert(varchar,w.crmid)=convert(varchar,t.id) and w.begindate is not null and w.begindate>='"+ncontactDateFrom+"' and w.begindate<='"+ncontactDateTo+"')"
				+ " group by "+fieldname;
			//out.println(sql);
			rs.executeSql(sql);
			while(rs.next()){
				ccontact.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		//查询新增人脉总量
		if(!caddDateFrom.equals("") && !caddDateTo.equals("")){
			sql = "select "+fieldname+" as mainid,count(c.id) as amount from CRM_CustomerInfo t,CRM_CustomerContacter c where "+where+" and c.customerid=t.id and (t.deleted=0 or t.deleted is null) "
				+ " and t.type=26 and t.status<>13"
				+ " and c.createdate >='"+caddDateFrom+"' and c.createdate<='"+caddDateTo+"'"
				+ " group by "+fieldname;
			rs.executeSql(sql);
			while(rs.next()){
				padd.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		if(!caddDateFrom2.equals("") && !caddDateTo2.equals("")){
			sql = "select "+fieldname+" as mainid,count(c.id) as amount from CRM_CustomerInfo t,CRM_CustomerContacter c where "+where+" and c.customerid=t.id and (t.deleted=0 or t.deleted is null) "
				+ " and t.type=26 and t.status<>13"
				+ " and c.createdate >='"+caddDateFrom2+"' and c.createdate<='"+caddDateTo2+"'"
				+ " group by "+fieldname;
			rs.executeSql(sql);
			while(rs.next()){
				padd2.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		/**
		//人脉未联系查询
		if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){
			//未联系查询
			sql = "select "+fieldname+" as mainid,count(c.id) as amount from CRM_CustomerInfo t,CRM_CustomerContacter c where "+where+" and c.customerid=t.id and (t.deleted=0 or t.deleted is null) "
				+ " and t.type=26 and t.status<>13"
				+ " and c.createdate<='"+ncontactDateTo+"'"
				+ " and not exists (select 1 from WorkPlan w where w.type_n=3 and convert(varchar,w.crmid)=convert(varchar,c.customerid)"
				+ " and (w.contacterid=c.id or (w.sellchanceid is null and w.contacterid is null))"
				+ " and w.begindate>='"+ncontactDateFrom+"' and w.begindate<='"+ncontactDateTo+"')"
				+ " group by "+fieldname;
			//out.println("-----"+sql);
			rs.executeSql(sql);
			while(rs.next()){
				pcontact.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}*/
		
		//查询商机总量
		sql = "select "+fieldname2+" as mainid,count(t2.id) as amount from CRM_CustomerInfo t,CRM_SellChance t2 where t.id=t2.customerid and "+where2+" and (t.deleted=0 or t.deleted is null) and t2.endtatusid=0"
			+ " group by "+fieldname2;
		rs.executeSql(sql);
		while(rs.next()){
			ssum.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
		}
		//查询新增商机量
		if(!saddDateFrom.equals("") && !saddDateTo.equals("")){
			sql = "select "+fieldname2+" as mainid,count(t2.id) as amount from CRM_CustomerInfo t,CRM_SellChance t2 where t.id=t2.customerid and "+where2+" and (t.deleted=0 or t.deleted is null) and t2.endtatusid=0"
				+ " and t2.createdate >='"+saddDateFrom+"' and t2.createdate<='"+saddDateTo+"'"
				+ " group by "+fieldname2;
			rs.executeSql(sql);
			while(rs.next()){
				sadd.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		if(!saddDateFrom2.equals("") && !saddDateTo2.equals("")){
			sql = "select "+fieldname2+" as mainid,count(t2.id) as amount from CRM_CustomerInfo t,CRM_SellChance t2 where t.id=t2.customerid and "+where2+" and (t.deleted=0 or t.deleted is null) and t2.endtatusid=0"
				+ " and t2.createdate >='"+saddDateFrom2+"' and t2.createdate<='"+saddDateTo2+"'"
				+ " group by "+fieldname2;
			rs.executeSql(sql);
			while(rs.next()){
				sadd2.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
			
			
			//成功商机量
			sql = "select "+fieldname2+" as mainid,count(t2.id) as amount from CRM_CustomerInfo t,CRM_SellChance t2 where t.id=t2.customerid and "+where2+" and (t.deleted=0 or t.deleted is null) "
				+ " and t2.endtatusid=1"
				+ " and t2.createdate >='"+saddDateFrom2+"' and t2.createdate<='"+saddDateTo2+"'"
				+ " group by "+fieldname2;
			rs.executeSql(sql);
			while(rs.next()){
				ssuccess.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
		//商机未联系查询
		if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){
			//未联系查询
			sql = "select "+fieldname2+" as mainid,count(t2.id) as amount from CRM_CustomerInfo t,CRM_SellChance t2 where t.id=t2.customerid and "+where2+" and t2.endtatusid=0 and (t.deleted=0 or t.deleted is null) "
				+ " and t2.createdate <='"+ncontactDateTo+"'"
				+ " and not exists (select 1 from WorkPlan w where w.type_n=3 and convert(varchar,w.crmid)=convert(varchar,t2.customerid)"
				+ " and (w.sellchanceid=t2.id or (w.sellchanceid is null and w.contacterid is null))"
				+ " and w.begindate>='"+ncontactDateFrom+"' and w.begindate<='"+ncontactDateTo+"')"
				+ " group by "+fieldname2;
			//out.println("---"+sql);
			rs.executeSql(sql);
			while(rs.next()){
				scontact.put(Util.null2String(rs.getString("mainid")),Util.null2String(rs.getString("amount")));
			}
		}
	}
	//System.out.println(provincename);
%>
<HTML>
	<HEAD>
		<title><%=titlename %></title>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<style type="text/css">
			html,body{-webkit-text-size-adjust: none;}
			body{margin: 0px;}
			.maintable{width: 100%;table-layout: fixed;background: #EBEBEB;}
			.maintable th{line-height: 18px;background: #F6F6F6;width: 100px;text-align: center;}
			.Header2 th{background: #F9F9F9;}
			.maintable th.th1{background: #EFEFEF;}
			.maintable th.th2{background: #F6F6F6;}
			.maintable th.th3{background: #EFEFEF;}
			.maintable td{line-height: 24px;text-align: center;background: #fff;padding: 2px;}
			.maintable td.title{background: #DDD9C3;}
			tr.dark td{background: #FDFDFD}
 			
			.detailtable{width:100%;table-layout: fixed;border-collapse: collapse;}
			.detailtable td{line-height: 28px;padding-left: 5px !important;background: #fff;border-left: 0px #EBEBEB solid;border-top: 1px #EBEBEB solid;}
			
			.input_txt{width: 180px;height:22px;border: 1px #C1C1C1 solid;margin-left: 10px;background: none;padding-top: 0px;outline:none;}
			.input_focus{border-color: #3BBAD9;}
			.input_blur{color: #C3C3C3;font-style: italic;}
			
			
			.searchtable{width:100%;border-collapse: collapse;margin-bottom:10px;}
			.searchtable td{height:30px;padding-left:4px !important;padding-right:4px !important;background:#fff;border:1px #E9E9E9 solid;}
			.searchtable td.title{background:#F3F3F3;color:#333333;}
			.searchtable td .input{background-image:none !important;padding-top:0px !important;}
			.innertable{width:auto;height:30px;float:left;}
			.innertable td{border:0px;padding:0px !important;}
			
			.tab{float: left;width: 50px;line-height: 28px;text-align: center;cursor: pointer;font-weight: normal;}
			.tab_click{background: #CAE8EA;}
			
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
			.scroll2 {
				overflow: auto;
				SCROLLBAR-DARKSHADOW-COLOR: #CDCDCD;
				SCROLLBAR-ARROW-COLOR: #E2E2E2;
				SCROLLBAR-3DLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-SHADOW-COLOR: #CDCDCD;
				SCROLLBAR-HIGHLIGHT-COLOR: #CDCDCD;
				SCROLLBAR-FACE-COLOR: #CDCDCD;
				scrollbar-track-color: #E2E2E2;
			}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.maintable{width:auto;}
		</style>
		<![endif]-->
	</HEAD>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:onSearch();,_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(cansearch){
				RCMenu += "{"+"Excel,javascript:exportExcel(),_top} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="frmMain" name="frmMain" action="SearchReport.jsp" method="post">
		<input type="hidden" id="stattype" name="stattype" value="<%=stattype %>"/>
		<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			</colgroup>
			<tr>
				<td height="5" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<TABLE class=Shadow>
						<tr>
							<td valign="top">
								<div style="width: 100%;height: 28px;border-bottom:2px #CAE8EA solid;font-size: 14px;font-weight: bold;margin-bottom: 10px;">
									<div style="width: auto;line-height: 28px;float: left;margin-right: 5px;"><%=titlename %></div>
									<div class="tab <%if(stattype==1){%>tab_click<%} %>" _tdclass="cond_p" _index="1">选省份</div>
									<div class="tab <%if(stattype==2){%>tab_click<%} %>" _tdclass="cond_h" _index="2">选人员</div>
									<div class="tab <%if(stattype==3){%>tab_click<%} %>" _tdclass="cond_d" _index="3">选部门</div>
								</div>
								<TABLE id="searchTable" class="searchtable" cellpadding="0" cellspacing="0" border="0">
									<COLGROUP>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="12%"/>
										<COL width="22%"/>
									</COLGROUP>
									<TBODY>
										<TR>
											<TD class="title cond cond_p" <%if(stattype!=1){ %> style="display: none" <%} %>>省份</TD>
											<TD class="value cond cond_p" <%if(stattype!=1){ %> style="display: none" <%} %> colspan="3">
												<input class="wuiBrowser" type=hidden _displayText="<%=provincename%>" 
													_url="/systeminfo/BrowserMain.jsp?url=/CRM/manage/util/ProvinceMutiBrowser.jsp" id="province" name="province" _param="resourceids" 
													value="<%=province%>" />
											</TD>
											<TD class="title cond cond_h" <%if(stattype!=2){ %> style="display: none" <%} %>>人员</TD>
											<TD class="value cond cond_h" <%if(stattype!=2){ %> style="display: none" <%} %> colspan="3">
												<INPUT class="wuiBrowser" type="hidden" id="hrmids" name="hrmids" value="<%=hrmids %>"
													_displayTemplate="<A href='javaScript:openhrm(#b{id})' onclick='pointerXY(event)'>#b{name}</A>" 
					          	 					_displayText="<%=hrmnames %>" _param="resourceids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp" />
											</TD>
											<TD class="title cond cond_d" <%if(stattype!=3){ %> style="display: none" <%} %>>部门</TD>
											<TD class="value cond cond_d" <%if(stattype!=3){ %> style="display: none" <%} %> colspan="3">
												<INPUT class="wuiBrowser" type="hidden" id="departmentids" name="departmentids" value="<%=departmentids %>"
					          	 					_displayText="<%=departmentnames %>" _param="selectedids" 
					          	 					_url="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" />
											</TD>
											<TD class="title">未联系日期范围</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(ncontactDateFrom,ncontactDateFromSpan)"></BUTTON>
												<SPAN id="ncontactDateFromSpan"><%=ncontactDateFrom%></SPAN>
												<input class=inputstyle type="hidden" name="ncontactDateFrom" value="<%=ncontactDateFrom%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(ncontactDateTo,ncontactDateToSpan)"></BUTTON>
												<SPAN id="ncontactDateToSpan"><%=ncontactDateTo%></SPAN>
												<input class=inputstyle type="hidden" name="ncontactDateTo" value="<%=ncontactDateTo%>" />
											</TD>
										</TR>
										<TR>
											<TD class="title">客户日期范围1</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(addDateFrom,addDateFromSpan)"></BUTTON>
												<SPAN id="addDateFromSpan"><%=addDateFrom%></SPAN>
												<input class=inputstyle type="hidden" name="addDateFrom" value="<%=addDateFrom%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(addDateTo,addDateToSpan)"></BUTTON>
												<SPAN id="addDateToSpan"><%=addDateTo%></SPAN>
												<input class=inputstyle type="hidden" name="addDateTo" value="<%=addDateTo%>" />
											</TD>
											<TD class="title">客户日期范围2</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(addDateFrom2,addDateFrom2Span)"></BUTTON>
												<SPAN id="addDateFrom2Span"><%=addDateFrom2%></SPAN>
												<input class=inputstyle type="hidden" name="addDateFrom2" value="<%=addDateFrom2%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(addDateTo2,addDateTo2Span)"></BUTTON>
												<SPAN id="addDateTo2Span"><%=addDateTo2%></SPAN>
												<input class=inputstyle type="hidden" name="addDateTo2" value="<%=addDateTo2%>" />
											</TD>
											<TD class="title">人脉日期范围1</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(caddDateFrom,caddDateFromSpan)"></BUTTON>
												<SPAN id="caddDateFromSpan"><%=caddDateFrom%></SPAN>
												<input class=inputstyle type="hidden" name="caddDateFrom" value="<%=caddDateFrom%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(caddDateTo,caddDateToSpan)"></BUTTON>
												<SPAN id="caddDateToSpan"><%=caddDateTo%></SPAN>
												<input class=inputstyle type="hidden" name="caddDateTo" value="<%=caddDateTo%>" />
											</TD>
										</TR>
										<TR>
											<TD class="title">人脉日期范围2</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(caddDateFrom2,caddDateFrom2Span)"></BUTTON>
												<SPAN id="caddDateFrom2Span"><%=caddDateFrom2%></SPAN>
												<input class=inputstyle type="hidden" name="caddDateFrom2" value="<%=caddDateFrom2%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(caddDateTo2,caddDateTo2Span)"></BUTTON>
												<SPAN id="caddDateTo2Span"><%=caddDateTo2%></SPAN>
												<input class=inputstyle type="hidden" name="caddDateTo2" value="<%=caddDateTo2%>" />
											</TD>
											<TD class="title">商机日期范围1</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(saddDateFrom,saddDateFromSpan)"></BUTTON>
												<SPAN id="saddDateFromSpan"><%=saddDateFrom%></SPAN>
												<input class=inputstyle type="hidden" name="saddDateFrom" value="<%=saddDateFrom%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(saddDateTo,saddDateToSpan)"></BUTTON>
												<SPAN id="saddDateToSpan"><%=saddDateTo%></SPAN>
												<input class=inputstyle type="hidden" name="saddDateTo" value="<%=saddDateTo%>" />
											</TD>
											<TD class="title">商机日期范围2</TD>
											<TD class="value">
												<BUTTON type="button" class=Calendar onclick="gettheDate(saddDateFrom2,saddDateFrom2Span)"></BUTTON>
												<SPAN id="saddDateFrom2Span"><%=saddDateFrom2%></SPAN>
												<input class=inputstyle type="hidden" name="saddDateFrom2" value="<%=saddDateFrom2%>" />
												－&nbsp;
												<BUTTON type="button" class=Calendar onclick="gettheDate(saddDateTo2,saddDateTo2Span)"></BUTTON>
												<SPAN id="saddDateTo2Span"><%=saddDateTo2%></SPAN>
												<input class=inputstyle type="hidden" name="saddDateTo2" value="<%=saddDateTo2%>" />
											</TD>
										</TR>
									</TBODY>
								</TABLE>
								<%if(cansearch){ 
									ExcelSheet es = new ExcelSheet();
									ExcelRow title = es.newExcelRow();
									title.setHight(30);
									
									es.addColumnwidth(1500);
									title.addStringValue("序号", "title");
									if(stattype==1){
										es.addColumnwidth(5000);
										title.addStringValue("省份", "title");
										es.addColumnwidth(5000);
										title.addStringValue("城市", "title");
									}else{
										es.addColumnwidth(5000);
										title.addStringValue("部门", "title");
										es.addColumnwidth(5000);
										title.addStringValue("人员", "title");
									}
									es.addColumnwidth(5000);
									title.addStringValue("现有客户总量", "title");
								%>
								<div id="divdata" class="scroll2" style="width: 100%;height:auto;overflow: auto;">
								<table class="maintable" cellspacing=1 cellpadding="0" border="0">
									<TBODY>
										<tr class=Header>
											<th style="width: 50px">序号</th>
											<%if(stattype==1){ %>
											<th>省份</th>
											<th>城市</th>
											<%}else{ %>
											<th style="width: 120px">部门</th>
											<th style="width: 110px">人员</th>
											<%} %>
											<th class="th1">现有客户总量</th>
											<%if(!addDateFrom.equals("") && !addDateTo.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(addDateFrom+"-"+addDateTo+"新增客户量", "title");
											%>
												<th class="th1"><%=addDateFrom %><br>-<%=addDateTo %><br>新增客户量</th>
											<%}%>
											<%if(!addDateFrom2.equals("") && !addDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(addDateFrom2+"-"+addDateTo2+"新增客户量", "title");
											%>
												<th class="th1"><%=addDateFrom2 %><br>-<%=addDateTo2 %><br>新增客户量</th>
											<%}%>
											<%if(!addDateFrom.equals("") && !addDateTo.equals("") && !addDateFrom2.equals("") && !addDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue("新增客户比例", "title");
											%>
												<th class="th1">新增客户比例</th>
											<%}%>
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(ncontactDateFrom+"-"+ncontactDateTo+"未联系客户总数", "title");
												es.addColumnwidth(5000);
												title.addStringValue("客户滚动占比情况", "title");
											%>
												<th class="th1"><%=ncontactDateFrom %><br>-<%=ncontactDateTo %><br>未联系客户总数</th>
												<th class="th1">客户滚动占比情况</th>
											<%} %>
											<th class="th2">现有人脉总量</th>
											<%
												es.addColumnwidth(5000);
												title.addStringValue("现有人脉总量", "title");
											%>
											<%if(!caddDateFrom.equals("") && !caddDateTo.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(caddDateFrom+"-"+caddDateTo+"新增人脉量", "title");
											%>
												<th class="th2"><%=caddDateFrom %><br>-<%=caddDateTo %><br>新增人脉量</th>
											<%}%>
											<%if(!caddDateFrom2.equals("") && !caddDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(caddDateFrom2+"-"+caddDateTo2+"新增人脉量", "title");
											%>
												<th class="th2"><%=caddDateFrom2 %><br>-<%=caddDateTo2 %><br>新增人脉量</th>
											<%}%>
											<%if(!caddDateFrom.equals("") && !caddDateTo.equals("") && !caddDateFrom2.equals("") && !caddDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue("新增人脉比例", "title");
											%>
												<th class="th2">新增人脉比例</th>
											<%}%>
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("") && 1==2){
												es.addColumnwidth(5000);
												title.addStringValue(ncontactDateFrom+"-"+ncontactDateTo+"未联系人脉总数", "title");
												es.addColumnwidth(5000);
												title.addStringValue("人脉滚动占比情况", "title");
											%>
												<th class="th2"><%=ncontactDateFrom %><br>-<%=ncontactDateTo %><br>未联系人脉总数</th>
												<th class="th2">人脉滚动占比情况</th>
											<%} %>
											<th class="th3">现有商机总量</th>
											<%
												es.addColumnwidth(5000);
												title.addStringValue("现有商机总量", "title");
											%>
											<%if(!saddDateFrom.equals("") && !saddDateTo.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(saddDateFrom+"-"+saddDateTo+"新增商机量", "title");
											%>
												<th class="th3"><%=saddDateFrom %><br>-<%=saddDateTo %><br>新增商机量</th>
											<%}%>
											<%if(!saddDateFrom2.equals("") && !saddDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(saddDateFrom2+"-"+saddDateTo2+"新增商机量", "title");
											%>
												<th class="th3"><%=saddDateFrom2 %><br>-<%=saddDateTo2 %><br>新增商机量</th>
											<%}%>
											<%if(!saddDateFrom.equals("") && !saddDateTo.equals("") && !saddDateFrom2.equals("") && !saddDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue("新增商机比例", "title");
											%>
												<th class="th3">新增商机比例</th>
											<%}%>
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(ncontactDateFrom+"-"+ncontactDateTo+"未联系商机总数", "title");
											%>
												<th class="th3"><%=ncontactDateFrom %><br>-<%=ncontactDateTo %><br>未联系商机总数</th>
											<%} %>
											<%if(!saddDateFrom2.equals("") && !saddDateTo2.equals("")){
												es.addColumnwidth(5000);
												title.addStringValue(saddDateFrom2+"-"+saddDateTo2+"成功商机量", "title");
												//es.addColumnwidth(5000);
												//title.addStringValue(saddDateFrom2+"-"+saddDateTo2+"商机结案率", "title");
											%>
												<th class="th3"><%=saddDateFrom2 %><br>-<%=saddDateTo2 %><br>成功商机量</th>
												<!--th class="th3"><%=saddDateFrom2 %><br>-<%=saddDateTo2 %><br>商机结案率</th-->
											<%} %>
										</tr>
										<%
											String mainid = "";
											String statname1 = "";
											String statname2 = "";
										
											int csumcount = 0;
											int caddcount = 0;
											int caddcount2 = 0;
											int ccontactcount = 0;
											String caddrate = "";
											String ccontactrate = "";
											
											int psumcount = 0;
											int paddcount = 0;
											int paddcount2 = 0;
											int pcontactcount = 0;
											String paddrate = "";
											String pcontactrate = "";
											
											int ssumcount = 0;
											int saddcount = 0;
											int saddcount2 = 0;
											int scontactcount = 0;
											int ssuccesscount = 0;
											String saddrate = "";
											String ssuccessrate = "";
											
											if(stattype==1){
												rs.executeSql("select id,cityname,provinceid from HrmCity where provinceid in ("+province+") order by provinceid,id");
												while (rs.next()) {
													idList.add(Util.null2String(rs.getString("id")));
												}
											}else if(stattype==2){
												idList = hrmidlist;
											}
											//rs.executeSql("select id,cityname,provinceid from HrmCity where provinceid in ("+province+") order by provinceid,id");
											int index = 1;
											for(int i=0;i<idList.size();i++) {
												mainid = (String)idList.get(i);
												
												ExcelRow er = es.newExcelRow();
												er.setHight(20);
												er.addStringValue(index+"", "normal");
												if(stattype==1){
													statname1 = ProvinceComInfo.getProvincename(CityComInfo.getCityprovinceid(mainid));
													statname2 = CityComInfo.getCityname(mainid);
												}else{
													statname1 = DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(mainid));
													statname2 = ResourceComInfo.getLastname(mainid);
												}
												er.addStringValue(statname1, "normal");
												er.addStringValue(statname2, "normal");
										%>
										<tr <%if(index%2==0){ %>class="dark"<%} %>>
											<td><%=index %></td>
											<td><%=statname1 %></td>
											<td><%=statname2 %></td>
											<%
												//客户统计部分
												csumcount = Util.getIntValue((String)csum.get(mainid),0);
												er.addStringValue(csumcount+"", "normal");
											%>
											<td><%=csumcount %></td>
											<%if(!addDateFrom.equals("") && !addDateTo.equals("")){ 
												caddcount = Util.getIntValue((String)cadd.get(mainid),0);
												er.addStringValue(caddcount+"", "normal");
											%>
												<td><%=caddcount %></td>
											<%} %>
											<%if(!addDateFrom2.equals("") && !addDateTo2.equals("")){ 
												caddcount2 = Util.getIntValue((String)cadd2.get(mainid),0);
												er.addStringValue(caddcount2+"", "normal");
											%>
												<td><%=caddcount2 %></td>
											<%} %>	
											<%if(!addDateFrom.equals("") && !addDateTo.equals("") && !addDateFrom2.equals("") && !addDateTo2.equals("")){ 
												if(caddcount==0){
													caddrate = "-";
												}else{
													caddrate = this.round((caddcount2-caddcount)*1.00/caddcount*100+"",0)+"%";
												}
												er.addStringValue(caddrate+"", "normal");
											%>
												<td><%=caddrate %></td>
											<%} %>	
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){ 
												ccontactcount = Util.getIntValue((String)ccontact.get(mainid),0);
												if(csumcount==0){
													ccontactrate = "-";
												}else{
													ccontactrate = this.round((csumcount-ccontactcount)*1.00/csumcount*100+"",0)+"%";
												}
												er.addStringValue(ccontactcount+"", "normal");
												er.addStringValue(ccontactrate+"", "normal");
											%>
												<td><%=ccontactcount %></td>
												<td><%=ccontactrate %></td>
											<%} %>
											
											
											<%
												//伙伴统计部分
												psumcount = Util.getIntValue((String)psum.get(mainid),0);
												er.addStringValue(psumcount+"", "normal");
											%>
											<td><%=psumcount %></td>
											<%if(!caddDateFrom.equals("") && !caddDateTo.equals("")){ 
												paddcount = Util.getIntValue((String)padd.get(mainid),0);
												er.addStringValue(paddcount+"", "normal");
											%>
												<td><%=paddcount %></td>
											<%} %>
											<%if(!caddDateFrom2.equals("") && !caddDateTo2.equals("")){ 
												paddcount2 = Util.getIntValue((String)padd2.get(mainid),0);
												er.addStringValue(paddcount2+"", "normal");
											%>
												<td><%=paddcount2 %></td>
											<%} %>	
											<%if(!caddDateFrom.equals("") && !caddDateTo.equals("") && !caddDateFrom2.equals("") && !caddDateTo2.equals("")){ 
												if(paddcount==0){
													paddrate = "-";
												}else{
													paddrate = this.round((paddcount2-paddcount)*1.00/paddcount*100+"",0)+"%";
												}
												er.addStringValue(paddrate+"", "normal");
											%>
												<td><%=paddrate %></td>
											<%} %>	
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")  && 1==2){ 
												pcontactcount = Util.getIntValue((String)pcontact.get(mainid),0);
												if(psumcount==0){
													pcontactrate = "-";
												}else{
													pcontactrate = this.round((psumcount-pcontactcount)*1.00/psumcount*100+"",0)+"%";
												}
												er.addStringValue(pcontactcount+"", "normal");
												er.addStringValue(pcontactrate+"", "normal");
											%>
												<td><%=pcontactcount %></td>
												<td><%=pcontactrate %></td>
											<%} %>
											
											
											<%
												//商机统计部分
												ssumcount = Util.getIntValue((String)ssum.get(mainid),0);
												er.addStringValue(ssumcount+"", "normal");
											%>
											<td><%=ssumcount %></td>
											<%if(!saddDateFrom.equals("") && !saddDateTo.equals("")){ 
												saddcount = Util.getIntValue((String)sadd.get(mainid),0);
												er.addStringValue(saddcount+"", "normal");
											%>
												<td><%=saddcount %></td>
											<%} %>
											<%if(!saddDateFrom2.equals("") && !saddDateTo2.equals("")){ 
												saddcount2 = Util.getIntValue((String)sadd2.get(mainid),0);
												er.addStringValue(saddcount2+"", "normal");
											%>
												<td><%=saddcount2 %></td>
											<%} %>	
											<%if(!saddDateFrom.equals("") && !saddDateTo.equals("") && !saddDateFrom2.equals("") && !saddDateTo2.equals("")){ 
												if(saddcount==0){
													saddrate = "-";
												}else{
													saddrate = this.round((saddcount2-saddcount)*1.00/saddcount*100+"",0)+"%";
												}
												er.addStringValue(saddrate+"", "normal");
											%>
												<td><%=saddrate %></td>
											<%} %>	
											<%if(!ncontactDateFrom.equals("") && !ncontactDateTo.equals("")){ 
												scontactcount = Util.getIntValue((String)scontact.get(mainid),0);
												er.addStringValue(scontactcount+"", "normal");
											%>
												<td><%=scontactcount %></td>
											<%} %>
											<%if(!saddDateFrom2.equals("") && !saddDateTo2.equals("")){ 
												ssuccesscount = Util.getIntValue((String)ssuccess.get(mainid),0);
												/**
												if(ssumcount==0){
													ssuccessrate = "-";
												}else{
													ssuccessrate = this.round(ssuccesscount*1.00/ssumcount*100+"",0)+"%";
												}*/
												er.addStringValue(ssuccesscount+"", "normal");
												//er.addStringValue(ssuccessrate+"", "normal");
											%>
												<td><%=ssuccesscount %></td>
												<!-- td><%=ssuccessrate %></td -->
											<%} %>
										</tr>
										<%		index++;
											}
										%>
								</TABLE>
								</div>
								<%
									SecExcelFile.init();

									ExcelStyle titleStyle = SecExcelFile.newExcelStyle("title");
									titleStyle.setGroundcolor(ExcelStyle.GREY_25_PERCENT_Color);
									//titleStyle.setFontcolor(ExcelStyle.WHITE_Color);
									titleStyle.setFontbold(ExcelStyle.Strong_Font);
									//titleStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
									titleStyle.setAlign(ExcelStyle.ALIGN_CENTER);
									titleStyle.setWrapText(true);
									
									ExcelStyle normalStyle = SecExcelFile.newExcelStyle("normal");
									normalStyle.setValign(ExcelStyle.VALIGN_CENTER);
									normalStyle.setAlign(ExcelStyle.ALIGN_CENTER);
									
									ExcelStyle detailStyle = SecExcelFile.newExcelStyle("detail");
									detailStyle.setWrapText(true);
									detailStyle.setFontheight(9);
	
									SecExcelFile.setFilename(ProvinceComInfo.getProvincename(province) + titlename);
									SecExcelFile.addSheet(ProvinceComInfo.getProvincename(province) + titlename, es);
								} %>
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
		<iframe id="searchexport" style="display:none"></iframe>
		<script type="text/javascript">
			$(document).ready(function() {
				setSize();

				$("div.tab").bind("click",function(){
					$("div.tab").removeClass("tab_click");
					$(this).addClass("tab_click");
					$("td.cond").hide();
					var _index = $(this).attr("_index");
					var _tdclass = $(this).attr("_tdclass");
					$("td."+_tdclass).show();
					$("#stattype").val(_index);
				});
			});
			$(window).resize(function(){
				setSize();
			});
			function onSearch(){
				jQuery("#frmMain").submit();   
			}
			document.onkeydown=keyListener;
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){    
			    	onSearch();   
			    }    
			}
			function setSize(){
				var w = $(window).width()-20;
				var h = $(window).height()-160;
				$("#divdata").width(w).height(h);
			}
			function exportExcel(){
			    jQuery("#searchexport").attr("src","/weaver/weaver.secondary.file.ExcelOut");
			}
		</script>
	</BODY>
</HTML>
<%!
/**
 * 对金额进行四舍五入
 * @param s 金额字符串
 * @param len 小数位数
 * @return
 */
public static String round(String s,int len){
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}
	return formater.format(num);
}
%>