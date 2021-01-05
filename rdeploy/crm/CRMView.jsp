
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.crm.util.CrmFieldComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCustomer" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerDescComInfo" class="weaver.crm.Maint.CustomerDescComInfo" scope="page" />
<jsp:useBean id="CustomerSizeComInfo" class="weaver.crm.Maint.CustomerSizeComInfo" scope="page" />
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="SectorInfoComInfo" class="weaver.crm.Maint.SectorInfoComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CitytwoComInfo" class="weaver.hrm.city.CitytwoComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="EvaluationLevelComInfo" class="weaver.crm.Maint.EvaluationLevelComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CustomerModifyLog" class="weaver.crm.data.CustomerModifyLog" scope="page"/>
<jsp:useBean id="CoworkDAO" class="weaver.cowork.CoworkDAO" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<%@page import="weaver.crm.customer.CustomerShareUtil"%>
<%@page import="java.net.URLEncoder"%>
<%
	String customerid = Util.null2String(request.getParameter("CustomerID"));
	rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
	if(rs.getCounts()<=0)
	{
		response.sendRedirect("/base/error/DBError.jsp?type=FindData");
		return;
	}
	rs.first();

	boolean canview=false;
	boolean canedit=false;
	boolean canunfreeze=false;
	boolean canmailmerge=false;
	//boolean canapprove=false;
	boolean isCustomerSelf=false;
	boolean canApply=false; //是否可以申请级别状态的变化
	boolean canApplyPortal=false; //是否可以申请门户状态的变化
	boolean canApplyPwd=false; //是否可以申请门户密码变化
	boolean canApproveLevel=false; //是否可以批准级别变化
	boolean canApprovePortal=false; //是否可以批准门户状态变化
	boolean canApprovePwd=false; //是否可以批准门户密码变化
	
	String levelMsg = ""; //级别申请中的显示信息
	String portalMsg = ""; //门户申请中的显示信息
	String portalPwdMsg = ""; //门户密码申请中的显示信息
	
	String country = Util.toScreenToEdit(rs.getString("country"),user.getLanguage());
	String province = Util.toScreenToEdit(rs.getString("province"),user.getLanguage());
	String isrequest = Util.null2String(request.getParameter("isrequest")); //客户审批描述
	String requestid = Util.null2String(request.getParameter("requestid")); //客户审批描述
	requestid = requestid.equals("")?requestid="-1":requestid;
	boolean hasApply = false;
	boolean hasApplyPortal = false;
	boolean hasApplyPwd = false;
	boolean isCreater=false;
	
	String levelstatus = "";
	String portalstatus = "";
	String portalstatus2 = "";
	String portalpwdstatus = "";
	String levelMenu = "";
	String portalMenu = "";
	String portalpwdMenu = "";
	
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=1 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    levelMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    levelstatus = RecordSetV.getString("status");
	    hasApply = true;
	}
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=2 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    portalMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    portalstatus = RecordSetV.getString("status");
	    hasApplyPortal = true;
	}
	RecordSetV.executeSql("select approvedesc,status from bill_ApproveCustomer where approvetype=3 and status<>'1' and status<>'0' and approveid="+customerid);
	if(RecordSetV.next()){
	    portalPwdMsg = "（"+RecordSetV.getString("approvedesc")+"）";
	    portalpwdstatus = RecordSetV.getString("status");
	    hasApplyPwd = true;
	}


	if(isrequest.equals("1")){
		canApproveLevel=hasApply;
	   	canApprovePortal=hasApplyPortal;
	   	canApprovePwd=hasApplyPwd;
	}

	//取得客户审批工作流的信息
	String approveid= "" ;
	String approvetype= "" ;
	String approvevalue = "";
	String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
	RecordSetV.executeSql(sql);
	if(RecordSetV.next()){
		approveid=RecordSetV.getString("approveid");
	    approvetype=RecordSetV.getString("approvetype");
	    approvevalue = RecordSetV.getString("approvevalue");
	}
	
	
	String userid = user.getUID()+"";
	String logintype = ""+user.getLogintype();
	boolean isattention = false;
	boolean isdelete = false;
	String name = Util.toScreenToEdit(rs.getString("name"),user.getLanguage());
	String email = Util.toScreenToEdit(rs.getString("email"),user.getLanguage());
	
	String type = Util.null2String(rs.getString("type"));
	String rating = Util.null2String(rs.getString("rating"));
	String manager = Util.toScreenToEdit(rs.getString("manager"),user.getLanguage());
	
	String evaluation = Util.null2String(rs.getString("evaluation"));
	int deleted = Util.getIntValue(rs.getString("deleted"),0);
	
	int status = rs.getInt("status");
	
	
	//判断是否为个人用户
	if(type.equals("19")){
		//response.sendRedirect("/CRM/data/ViewPerCustomer.jsp?CustomerID="+customerid);
		//return;
	}
	
	String usertype = "0";
	if(logintype.equals("2"))
		usertype="1";
	
	if(user.getLogintype().equals("2") && customerid.equals(user.getUID()+"")){
		isCustomerSelf = true ;
	}
	//判断是否有查看该客户权限
	int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid,""+usertype);
	if(sharelevel>0){
        canview=true;
        canmailmerge=true;
        if(sharelevel==2) canedit=true;
        if(sharelevel==3||sharelevel==4){
            canedit=true;
            //canapprove=true;
        }
    }else{
    	if(isCustomerSelf){
    		CustomerShareUtil.addCustomerShare(userid,customerid,"1",userid,1,"1");
    	}
    }	
	if(status==7 || status==8 || status==10){
		if(canedit) canunfreeze=true;
		canedit = false;
	}
    //if(manager.equals(ResourceComInfo.getManagerID(manager))){
    //	canapprove=true;
    //}

    if(manager.equals(userid)){
        if(!hasApply){
            canApply=true; //只有客户的经理才可以申请升级、降级以及冻结和解冻操作
        }
        if(!hasApplyPortal){
            canApplyPortal = true; //只有客户的经理才可以申请开放门户、以及冻结和解冻操作
        }
        if(!hasApplyPwd){
            canApplyPwd = true; //只有客户的经理才可以申请重新生成密码
        }
        
        isCreater=true;
        isdelete = true;
        //客户经理为本人时删除新客户标记
    	CustomerModifyLog.deleteCustomerLog(Util.getIntValue(customerid,-1),user.getUID());
    }

    /*check right end*/

    portalstatus2 =  Util.getIntValue(rs.getString("PortalStatus"),0)+"";
    boolean onlyview=false;
    if(!canview && !isCustomerSelf){
    	String moduleid=Util.null2String(request.getParameter("moduleid"));
    	Map<String,String> params=new HashMap<String,String>();
    	params.put("logintype",logintype);
    	
    	Enumeration enu=request.getParameterNames();
    	while(enu.hasMoreElements()){
    		String paraName=(String)enu.nextElement();
    		String value=request.getParameter(paraName);
    	    
    		params.put(paraName, value);
    	}
    	if(CustomerShareUtil.customerRightCheck(""+userid,customerid,moduleid,params)){
    		onlyview=true;
    	}else{
    		response.sendRedirect("/notice/noright.jsp") ;
            return ;
    	}
    }
	
	
	int nolog = Util.getIntValue(request.getParameter("nolog"),0);
	
	rs2.executeSql("select 1 from CRM_Common_Attention where objid="+customerid+" and operatetype=1 and operator="+userid);
	if(rs2.next()){
		isattention = true;
	}
	
	String Creater = "";
	String CreateDate = "";
	String CreateTime = "";
	rs2.executeSql("select top 1 submiter,submitdate,submitertype,submittime from CRM_Log where customerid ='" + customerid + "' and logtype = 'n' order by submitdate desc,submittime desc");
	if(rs2.first()){
		Creater = Util.toScreen(rs2.getString("submiter"),user.getLanguage());
		CreateDate = rs2.getString("submitdate");
		CreateTime = rs2.getString("submittime");
	}

	String Modifier = "";
	String ModifyDate = "";
	String ModifyTime = "";
	rs2.executeSql("select top 1 submiter,submitdate,submitertype,submittime from CRM_Log where customerid ='" + customerid + "' and logtype <> 'n' and logtype <> 'v' order by submitdate desc,submittime desc");
	if(rs2.first()){
		Modifier = Util.toScreen(rs2.getString("submiter"),user.getLanguage());
		ModifyDate = rs2.getString("submitdate");
		ModifyTime = rs2.getString("submittime");
	}
	
	String topage= URLEncoder.encode("/CRM/data/ViewCustomer.jsp?CustomerID="+customerid);
	
	String titlestr = SystemEnv.getHtmlLabelName(136,user.getLanguage())+"-"+name+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+" "+ResourceComInfo.getLastname(Creater)+" "+SystemEnv.getHtmlLabelName(84243,user.getLanguage())+"  "+CreateDate+" "+CreateTime+" "+SystemEnv.getHtmlLabelName(83443,user.getLanguage());
	String updatestr = SystemEnv.getHtmlLabelName(136,user.getLanguage())+" "+ResourceComInfo.getLastname(Modifier)+" "+SystemEnv.getHtmlLabelName(623,user.getLanguage())+"  "+ModifyDate+" "+ModifyTime+" "+SystemEnv.getHtmlLabelName(84094,user.getLanguage());
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title><%=titlestr+updatestr %></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/> 
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/CRM/js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="/CRM/js/util_wev8.js"></script>
		<script language="javascript" src="/workrelate/js/relateoperate_wev8.js"></script>
		
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		
		<link rel="stylesheet" href="/CRM/css/Base1_wev8.css" />
		<link rel="stylesheet" href="/CRM/css/Contact1_wev8.css" />
		
		
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
		<%@ include file="/CRM/data/uploader.jsp" %>
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		String mailAddress = "";
		
	/**
	 * 修改密码，前提条件：客户开启了客户门户且操作者为客户经理
	 **/
	String customerInfoSql = "SELECT PortalStatus  , Manager FROM CRM_CustomerInfo WHERE id = "+customerid;
	RecordSetCustomer.executeSql(customerInfoSql);
	RecordSetCustomer.next();
	int PortalStatus = RecordSetCustomer.getInt("PortalStatus");
	int Manager = RecordSetCustomer.getInt("Manager");

	if(2 == PortalStatus &&  user.getUID() == Manager){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(17993,user.getLanguage())+",javascript:editPassword(0),_top} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
		
	boolean crmmanager = false;
	rs2.executeSql("select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + user.getUID());
	if(rs2.next()) {
		crmmanager = true;
	}	
		
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="customer"/>
		   <jsp:param name="navName" value="客户信息"/>
		</jsp:include>


		<wea:layout attributes="{layoutTableId:topTitle}">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
				</wea:item>
			</wea:group>
		</wea:layout>


		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="width:100%;height: 100%;margin: 0px auto;text-align: left;">
						<div id="baseinfo" style="width: 100%;height: auto;overflow: hidden;">
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td valign="top" width="*">
						<!-- 左侧信息开始 -->
						
						<div id="leftdiv" style="width: 100%;margin-top: 0px;overflow:hidden;" class="scroll1 content_2">
							<div id="leftinfo" class="scroll1" style="width:100%;height: 100%;overflow:auto;">
							<!-- 基本信息开始 -->
							<table style="width: 100%;height:auto;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="0px"/><col width="0px"/><col width="*"/></colgroup>
								<tr>
									<td valign="top">
										<!-- 一般信息开始 -->
												<wea:layout type="2col" attributes="{'expandAllG	roup':'true'}">
												
												<wea:group context="<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>">
	
														<wea:item>客户名称</wea:item> <!-- 允许申请关注 -->
														<wea:item>
															<input datatype='text' type='text'  class='item_input' maxlength='100' id=name name=name onChange='checkinput("name","namespan")' onblur='' value='<%=rs.getString("name")%>' isMustInput='1'><span id='namespan'><img src='/images/BacoError_wev8.gif' align=absmiddle></span><script>checkinput("name","namespan")</script>
														</wea:item>
														
														<wea:item>客户经理</wea:item>
														<wea:item>
															<span class='browser' id='fieldmanager_span_n'></span><script type='text/javascript'>$('#fieldmanager_span_n').e8Browser({name:'manager',viewType:'0',browserValue:'<%=rs.getString("manager")%>',isMustInput:'2',browserSpanValue:'<%=ResourceComInfo.getLastname(rs.getString("manager"))%>',hasInput:'true',linkUrl:'/hrm/resource/HrmResource.jsp?id=',isSingle:true,completeUrl:'/data.jsp?type=1',browserUrl:'/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp',width:'250px;',hasAdd:false,_callback:'callBackSelectUpdate',_callbackParams:'67',afterDelCallback:'callBackSelectDelete',afterDelParams:'67'});</script>
															<div class='e8_txt' id='txtdiv_manager'><%=ResourceComInfo.getLastname(rs.getString("manager"))%></div>
														</wea:item>
														
														<wea:item>状态</wea:item>
														<wea:item>
															<span class='browser' id='fieldstatus_span_n'></span><script type='text/javascript'>$('#fieldstatus_span_n').e8Browser({name:'status',viewType:'0',browserValue:'<%=rs.getString("status")%>',isMustInput:'2',browserSpanValue:'<%=CustomerStatusComInfo.getCustomerStatusname(rs.getString("status"))%>',hasInput:'true',linkUrl:'/CRM/Maint/CustomerStatusBrowser.jsp',isSingle:true,completeUrl:'/data.jsp?type=264',browserUrl:'/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp',width:'250px;',hasAdd:false,_callback:'callBackSelectUpdate',_callbackParams:'1',afterDelCallback:'callBackSelectDelete',afterDelParams:'1'});</script>
															<div class='e8_txt' id='txtdiv_status'><%=CustomerStatusComInfo.getCustomerStatusname(rs.getString("status"))%></div>
														</wea:item>
														
														<wea:item>网站</wea:item>
														<wea:item>
															<input datatype='text' type='text'  class='item_input' maxlength='150' id=website name=website onChange='' onblur='' value='<%=rs.getString("website")%>' isMustInput='0'/>
														</wea:item>
														<wea:item>电子邮件</wea:item>
														<wea:item>
															<input datatype='text' type='text'  class='item_input' maxlength='150' id=email name=email onblur='checkEmailFormate(this)' value='<%=rs.getString("email")%>' isMustInput='1'/>
														</wea:item>
														
													</wea:group>
													
													<wea:group context='<%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%>'>
														<%if(canedit){ %>
														<wea:item type="groupHead">
															<input type="button" id="btn_contacter" class="addbtn" onclick="addContacter()" _status="1"/>
														</wea:item>
														<%}%>
														<wea:item attributes="{'colspan':'full'}">
															<!-- 人员关系开始 -->
															<div id="contacterList">
																<jsp:include page="ContacterRel.jsp">
																	<jsp:param value="<%=customerid %>" name="customerid"/>
																	<jsp:param value="<%=canedit%>" name="canedit"/>
																	<jsp:param value="0" name="contact"/>
																</jsp:include>
															</div>
															<!-- 人员关系结束 -->
														</wea:item>
													</wea:group>
													
													<wea:group context='客户联系' attributes="{'id':'xxxxxxxx'}">
														<wea:item attributes="{'colspan':'full','id':'contactLog_tr'}">
															<iframe src="/CRM/data/ViewContactLog.jsp?CustomerID=<%=customerid%>&isfromtab=true&from=rdViewCrm" id="contaceLogFrame" name="contaceLogFrame" frameborder="0" height="100%" width="100%"></iframe>
														</wea:item>
													</wea:group>
													
													
										        </wea:layout>
									</td>
								</tr>
							</table>
							<!-- 基本信息结束 -->
							</div>
							
						</div>
						<!-- 左侧商机信息结束 -->
						</td>
						<td id="righttd" valign="top" width="0px" style="width:0px;display:none;">
						
						</td>
						</tr>
						</table>
						</div>
					</div>
					
				</td>
			</tr>
		</table>
		
		<%if(canedit){ %>
		
			<div id="pr_select" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
				<div id="roleitem_项目决策人" class="roletype"><%=SystemEnv.getHtmlLabelName(124914,user.getLanguage())%></div>
				<div id="roleitem_客户高层" class="roletype"><%=SystemEnv.getHtmlLabelName(84246,user.getLanguage())%></div>
				<div id="roleitem_内部向导" class="roletype"><%=SystemEnv.getHtmlLabelName(84248,user.getLanguage())%></div>
				<div id="roleitem_技术影响人" class="roletype"><%=SystemEnv.getHtmlLabelName(84249,user.getLanguage())%></div>
				<div id="roleitem_需求影响人" class="roletype"><%=SystemEnv.getHtmlLabelName(84251,user.getLanguage())%></div>
				<div id="roleitem_其他" class="roletype"><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></div>
				<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
					<a style="width: 50%;text-align: center;" href="javascript:updateRoleType()"><%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></a>&nbsp;
					<a style="width: 50%;text-align: center;" href="javascript:cancelRoleType()"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></a>
				</div>
			</div>
			<div id="at_select" class="select_div">
				<div class="select_item"><%=SystemEnv.getHtmlLabelName(84253,user.getLanguage())%></div>
				<div class="select_item"><%=SystemEnv.getHtmlLabelName(84254,user.getLanguage())%></div>
				<div class="select_item"><%=SystemEnv.getHtmlLabelName(84256,user.getLanguage())%></div>
				<div class="select_item"><%=SystemEnv.getHtmlLabelName(84257,user.getLanguage())%></div>
			</div>
			<div id="ct_select" class="select_div">
			<%
				ContacterTitleComInfo.setTofirstRow();
				while(ContacterTitleComInfo.next()){
			%>
				<div class="select_item" _val="<%=ContacterTitleComInfo.getContacterTitleid() %>"><%=ContacterTitleComInfo.getContacterTitlename() %></div>
			<%  } %>
			</div>
		
		<%} %>
		
		<!-- 提示信息 -->
		<div id="warn">
			<div class="title"></div>
		</div>
		
		
		<style>
			
			.sbHolder{
				display:none;
			}
			
			.e8_os{
				display:none;
				height:28px;
			}
			.browser{
				display:none;
				height:28px;
			}
			.calendar{
				display: none;
			}
			.e8_txt{
				height:28px;
				line-height:28px;
			}
			#contactLog_tr{
				padding-left:0px !important;
			}
		</style>
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			
			$(document).ready(function(){
				//绑定附件上传功能
				jQuery("div[name=uploadDiv]").each(function(){
			        bindUploaderDiv($(this),"<%=customerid%>"); 
			        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
			        if(jQuery(this).attr("ismust")== 1 && jQuery(this).parent("td").find(".txtlink").length != 0){
		    			jQuery("#"+$(this).attr("fieldNameSpan")).html("");
		    		}
		    	});
				
				//绑定checkbox事件
				jQuery(".item_checkbox").bind("click",function(){
					exeUpdate(jQuery(this).attr("name"),jQuery(this).is(":checked")?"1":"0","num");
				});
				
				$("div.tagitem").live("mouseover",function(){
					$(this).find("div.tagdel").show();
				}).live("mouseout",function(){
					$(this).find("div.tagdel").hide();
				});

				$("#tagaddbtn").bind("mouseover",function(){
					$(this).addClass("tagaddbtn_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("tagaddbtn_hover");
				});

				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).attr("id")=="addtag"){
				    		$("#tagsavebtn").click();
				    	}
				    }
				});

				<%if(canedit){%>
				
				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					var _selectid = getVal($(this).attr("_selectid"));
					if(_selectid!=""){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#"+_selectid).height())>$(window).height()){
							_top = _top-26-$("#"+_selectid).height();
						}
						$("#"+_selectid).css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="introduction"){
						$(this).height(70);
					}
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
					if(this.id=="introduction"){
						setRemarkHeight(this.id);
					}
					if(!$(this).hasClass("input_select")){
						doUpdate(this,1);
					}
				}).hover(function(){
					$(this).addClass("item_input_hover");
				},function(){
					$(this).removeClass("item_input_hover");
				});
				
				
					
				//表格行背景效果及操作按钮控制绑定
				$("table.LayoutTable").find("td.field").bind("click mouseenter",function(){
					$(".btn_add").hide();
					$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					
					$(this).find("div.e8_os").show();
					$(this).find("span.browser").show();
					$(this).find(".calendar").show();
					$(this).find("div.e8_txt").hide();
					
					//对select框进行处理
					$(this).find(".sbHolder").parent().show();
					$(this).find("div.e8_select_txt").hide();
					
					//$(this).find(".item_num").width(100);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					if($(this).attr("id")=="websitetd") $("#websitelink").show();
					if($(this).attr("id")=="emailtd") $("#emaillink").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					
					//对浏览框进行处理
					if($(this).find("div.e8_os").length>0){
						
						var isSelectHidden=true;
						$(".ac_results").each(function(){
							if(!$(this).is(":hidden"))
								isSelectHidden=false;
						});
						//$("#e8_autocomplete_div").is(":hidden")
						if(isSelectHidden){
							$(this).find("div.e8_os").hide();
							$(this).find("span.browser").hide();
						}
					}
					//对时间控件进行处理
					if($(this).find(".calendar").length>0){
						var databox=$("#_my97DP");
						var databoxLeft=databox.offset().left;
						if(!$("#_my97DP").is(":visible")||databoxLeft<0){
							$(this).find(".calendar").hide();
						}
					}
					$(this).find("div.e8_txt").show();
					
					//对select框进行处理
					if($(this).find(".sbHolder").length>0){
						var sb=$(this).find("select").attr("sb");
						var e=event?event:window.event;
						if($("#sbOptions_"+sb).parent().is(":hidden")){
							$(this).find(".sbHolder").parent().hide();
							$(this).find("div.e8_select_txt").show();
						}	
					}	
					
					//$(this).find(".item_num").width(40);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					if($(this).attr("id")=="websitetd") $("#websitelink").hide();
					if($(this).attr("id")=="emailtd") $("#emaillink").hide();
					//$(this).find("div.upload").hide();
				});
				
				$(".sbHolder").parent().hide();
				
				
				
				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var _inputid = $(this).parent().attr("_inputid")
					var obj = $("#"+_inputid);
					var _val = $(this).attr("_val");
					<%if(!crmmanager){%>
					if(_inputid=="source" && (_val==2||_val==8||_val==19||_val==20||_val==30||_val==31||_val==32)){
						if(!confirm("<%=SystemEnv.getHtmlLabelName(124915,user.getLanguage())%>?")){
							return;
						}
					}
					<%}%>
					if(_inputid=="status" && (_val==7 || _val==8 ||  _val==10)){
						if(!confirm("<%=SystemEnv.getHtmlLabelName(124916,user.getLanguage())%>?")){
							return;
						}
					}
					
					tempval = obj.val();
					obj.val(_val);
					$("#"+_inputid+"name").val($(this).html());
					
					doUpdate(obj,1);
				});

				
				//输入添加按钮事件绑定
				$("div.btn_add").bind("click",function(){
					$(this).hide();
					$(this).nextAll("div.btn_browser").hide();
					$(this).prevAll("div.showcon").hide();
					$(this).prevAll("input.add_input").show().focus();
					$(this).prevAll("input.add_input2").show().focus();
					$(this).prevAll("div.btn_select").show();
				});
				//联想输入框事件绑定
				$("input.add_input2").bind("focus",function(){
					if($(this).attr("_init")==1){
						$(this).FuzzyQuery({
							url:"/CRM/manage/util/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
							operate:"select",
							updatetype:"str"
						});
						$(this).attr("_init",0);
					}
					foucsobj2 = this;
				}).bind("blur",function(e){
					$(this).val("");
					$(this).hide();
					$(this).nextAll("div.btn_add").show();
					$(this).nextAll("div.btn_browser").show();
					$(this).prevAll("div.showcon").show();
				});

				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});
				
				$("#leftdiv").scroll(function(){
					$("div.item_select").hide();
					$("div.select_div").hide();
				});

				//页面点击及回车事件绑定
				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("item_select")){
						$("div.item_select").hide();
						if($(target).hasClass("input_select")){
							var _selectid = $(target).attr("_selectid");
							$("#"+_selectid).show();
						}
					}
				}).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input") && $(target).attr("id")!="introduction"){
				    		$(foucsobj2).blur();  
				    		$("div.item_select").hide();
				    	}
				    }
				});

				cancelAddContacter();
				<%}%>

				//收缩展开绑定
				$(".btn_center").bind("mouseover",function(){
					//$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					//$(this).removeClass("btn_right");
				}).bind("click",function(){
					$(this).show();
					var _status = $(this).attr("_status");
					if(_status==0){
						$(".btn_center").attr("_status",1).attr("title","<%=SystemEnv.getHtmlLabelName(124917,user.getLanguage())%>");
						$("#righttd").animate({width:0},200,null,function(){
							$(this).hide();
						});
						
					}else{
						$(".btn_center").attr("_status",0).attr("title","<%=SystemEnv.getHtmlLabelName(124918,user.getLanguage())%>");
						$("#righttd").animate({width:'35%'},200,null,function(){
							$(this).show();
						}).show();
						if(jQuery("#contactNum",parent.document).length==1){ //更新客户联系数量
							jQuery.post("/CRM/data/ViewContactOperation.jsp",
								{"operation":"workPlanViewLog","customerid":"<%=customerid%>"},function(){
									jQuery("#contactNum",parent.document).remove();
							});
						}
					}
					$(".btn_center").show();
					$(this).hide();
					$("#contentframe")[0].contentWindow.initMainHeight();
					setPosition();
				});

				$("div.csmenu").bind("mouseover",function(){
					var _top = $(this).offset().top + 26;
					var _left = $(this).offset().left;
					$("div.menu_select").css({"top":_top,"left":_left}).show();
				}).bind("mouseout",function(){
					$("div.menu_select").hide();
				});
				$("div.menu_select").bind("mouseover",function(){
					$(this).show();
				}).bind("mouseout",function(){
					$(this).hide();
				});
				$("div.menu_option").bind("mouseover",function(){
					$(this).addClass("menu_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("menu_option_hover");
				}).bind("click",function(){
					var _frameid = $(this).attr("_frameid");
					var _url = $(this).attr("_url"); 
					if($("#"+_frameid).attr("src")==""){
						$("#"+_frameid).attr("src",_url);
					}
					$("#baseinfo").hide();
					$(".infoframe").hide();
					$("#"+_frameid).show();
					$("div.tabmenu").removeClass("tabmenu_click");
					$("div.menu_select").hide();
				});

				

				setPosition();
				setRemarkHeight("introduction");

				//$("#btn_center2").click();
				
				/**
				var hh = $("#leftdiv").height();
				$("#leftdiv").mCustomScrollbar({
					scrollInertia:500,
					mouseWheelPixels:200,
					scrollEasing:"easeOutQuint",
					scrollButtons:{
						enable:false,
						scrollType:"pixels",
						scrollSpeed:20
					},
					advanced:{
						updateOnBrowserResize:true, 
						updateOnContentResize:true, 
						autoExpandHorizontalScroll:false, 
						autoScrollOnFocus:true 
					}
				});*/
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});
			
			function onShowDate1(spanname,inputname,mand){
			  tempval = $ele4p(inputname).value;
			  var fieldName = jQuery($ele4p(inputname)).parent("td").find("input").attr("name");
			  
			  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
					$dp.$(inputname).value = dp.cal.getDateStr();
					$dp.$(spanname).innerHTML = dp.cal.getDateStr();
				   	if($ele4p(inputname).value!=tempval){
				   		$("#"+fieldName).parents("td:first").mouseleave();
				   		exeUpdate(fieldName,$ele4p(inputname).value,"str");
				   	}
					
			 },oncleared:function(){
			 	//日期必填
			 	if(mand == 1){
					 	$ele4p(spanname).innerHTML = tempval;
					 	$ele4p(inputname).value = tempval;
				}else{
					  	$ele4p(spanname).innerHTML = '';
					  	exeUpdate(fieldName,"","str");
				}
			 }});
			   
			   
			   
			   if(mand == 1){
			     var hidename = $ele4p(inputname).value;
				 if(hidename != ""){
					$ele4p(inputname).value = hidename; 
					$ele4p(spanname).innerHTML = hidename;
				 }else{
				   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				 }
			   }
			}
			
			function setPosition(){
				return;
				var ww = document.body.clientWidth;
				if(ww<1000){
					$("#main").width(1000);
				}else{
					$("#main").width("100%");
				}
				//var wh = document.body.clientHeight;
				var wh = $(window).height();
				//if(wh2<wh){wh=wh2;}
				//alert(wh);
				
				$("#main").height(wh);
				$(".infoframe").height(wh-50);
				
				var _top = $("#contactdiv").offset().top;
				$("#contactdiv").height(wh-_top-5);

				var _top2 = $("#leftdiv").offset().top;
				$("#leftdiv").height(wh-_top2-5+"px");
				
				$("#leftinfo").height(wh-_top2-5+"px");
				
				

				//if(_relid!="") onAddContacter(_relid);
				//$("#maininfo").height($("#main").height()-_top-$("#fbmain").height()-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					if(h>70){
						$("#"+remarkid).height(70);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			function setLastUpdate(){
				
				var currentdate = new Date();
				var datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
				//var timestr = currentdate.format("hh:mm:ss");
				//$("#lastupdate").html("由 <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> 于 <font title='"+timestr+"'>"+datestr+"</font> 最后修改");

				showMsg();
			}
			
			function moreInfo(obj){
				var _status = $(obj).attr("_status");
				var _hh = $("#moretable").height();
				if(_status==1){
					$("#moreinfo").animate({height:_hh},300,null,function(){});
					$(obj).attr("_status",0).attr("title","点击收缩").css("background","url('../images/btn_up2_wev8.png')");
				}else{
					$("#moreinfo").animate({height:0},300,null,function(){});
					$(obj).attr("_status",1).attr("title","点击展开").css("background","url('../images/btn_down2_wev8.png')");
				}
			}

			function setFrameHeight(sellchanceid,height){
				$("#sellchance_"+sellchanceid).height(height);
			}
			function remveFrame(sellchanceid){
				$("#div_sellchance_"+sellchanceid).remove();
			}
			function addContact(objid,type){
				if(type==1){
					$("#sellchanceid").val(objid);
					$("#contacterid").val("");
				}else{
					$("#contacterid").val(objid);
					$("#sellchanceid").val("");
				}
				var _status = $("#btn_center").attr("_status");
				if(_status==1){
					$("#btn_center").click();
				}
				$("#ContactInfo").focus();
			}

			<%if(canedit){%>
			//商机卡片中调整阶段是调用
			function checkss(_val){
				var msgstr = "";
				//检测向导人是否关联
				if(_val>2){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("内部向导")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定内部向导\n";
						//alert("请确定内部向导！");
						//return false;
					}
				}
				//检测决策人是否关联
				if(_val>3){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("项目决策人")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定项目决策人\n";
						//alert("请确定项目决策人！");
						//return false;
					}
				}
				//检测高层是否关联
				if(_val>4){
					var temp=0;
					$("input.rel_pr").each(function(){
						if($(this).val().indexOf("客户高层")>-1){
							temp = 1;
							return;
						}
					});
					if(temp==0){
						msgstr += "未确定客户高层\n";
						//alert("请确定客户高层！");
						//return false;
					}
				}
				return msgstr;
			}
			
			//输入框保存方法
			function doUpdate(obj,type){
				var fieldname = $(obj).attr("id");
				var fieldtype = getVal($(obj).attr("_type"));
				if(fieldtype=="") fieldtype="str";
				var fieldvalue = "";
				var isMustInput=$(obj).attr("isMustInput");
				
				if(type==1){
					if($(obj).val()==tempval) return;
					fieldvalue = $(obj).val();
				}
				//必填
				if(isMustInput=="1"){
					if(fieldvalue=="") {
						$(obj).val(tempval);
						checkinput(fieldname,fieldname+"span");
						return;
					}
				}
				if(fieldname=="email"){
					var emailStr = $(obj).val().replace(" ","");
					if (!checkEmail(emailStr)) {
						$(obj).val(tempval);
						return;
					}
				}
				if(obj.nodeName=="SELECT"){
					$("#txtdiv_"+fieldname).html($(obj).find("option[value="+fieldvalue+"]").text()).show();
					var sb=$(obj).attr("sb");
					$("#sbHolderSpan_"+sb).hide();
				}
				exeUpdate(fieldname,fieldvalue,fieldtype);
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				if(fieldname=="exploiterIds" || fieldname=="principalIds"){
					var vals = ","+$("#"+fieldname+"_val").val()+",";
					var _index = vals.indexOf(","+fieldvalue+",")
					if(_index>-1 && $.trim(fieldvalue)!=""){
						vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
						if(vals!="" && vals!=","){
							vals = vals.substring(1,vals.length-1);
						}else{
							vals = "";
						}
						$("#"+fieldname+"_val").val(vals);
						exeUpdate(fieldname,vals,'',fieldvalue);
					}
				}else{
					exeUpdate(fieldname,'0','num');
				}
			}
			
			function callBackSelectUpdate(event,data,fieldid,oldid){
				
				if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
					oldid = jQuery("#"+fieldid).data("oldid");
				}
				
				// 防止多浏览框，每次动态添加
				var name = "";
				var id = jQuery("#"+fieldid).val();
				
				jQuery("#"+fieldid+"span").find("a").each(function(){
					name += jQuery(this).html()+",";
				});
				if("" != name){
					name = name.substring(0,name.length-1);
				}
				
				doSelectUpdate(fieldid,id,name,oldid);
			}
			
			function callBackSelectDelete(text,fieldid,oldid){
				
				if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
					oldid = jQuery("#"+fieldid).data("oldid");
				}
				
				var name = "";
				var id = jQuery("#"+fieldid).val();
				jQuery("#"+fieldid+"span").find("a").each(function(){
					if(-1 != (","+id+",").indexOf(","+jQuery(this).next("span").attr("id")+",")){
						name += jQuery(this).html()+",";
					}
				});
				if("" != name){
					name = name.substring(0,name.length-1);
				}
				doSelectUpdate(fieldid,id,name,oldid);
			}
			
			//选择内容后执行更新
			function doSelectUpdate(fieldname,id,name,oldid){
				var addtxt = "";
				var fieldtype = "num";
				
				if(fieldname=="exploiterIds" || fieldname=="principalIds"){
					var sumids = "";
					var addids = "";
					var ids = id.split(",");
					var names = name.split(",");
					var vals = $("#"+fieldname+"_val").val();
					for(var i=0;i<ids.length;i++){
						if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
							addids += "," + ids[i];
							addtxt += doTransName(fieldname,ids[i],names[i]);
						}
					}
					if(addids==""){
						return;
					}else{
						addids = addids.substring(1);
						sumids = addids;
						if(vals!="") sumids = vals+","+addids;
						$("#"+fieldname).before(addtxt);
						$("#"+fieldname+"_val").val(sumids);
						exeUpdate(fieldname,sumids,"","",addids);
					}
				}else{
					tempval = oldid;
					if(tempval==id) return;
					
					var fieldObj=$("#"+fieldname);
					var isMustInput=fieldObj.attr("isMustInput");
					if(isMustInput=="2"){ //必填则不允许为空
						jQuery("#"+fieldname+"span").html(jQuery("#"+fieldname+"span").html());
						if(id=="") return;
					}
					
					if(fieldname=="manager"){
						window.top.Dialog.confirm("提示：修改客户经理后将会失去此客户的默认权限!确定修改?",function(){
							$("#minfo").hide();
							$("#mload").show();
							$("#txtdiv_"+fieldname).html(name);
							exeUpdate(fieldname,id,"num");
						});
						jQuery("#managerspan").find("a").html(jQuery("#txtdiv_manager").html());
						return;
					}else{
						exeUpdate(fieldname,id,"num");
					}
					//addtxt = doTransName(fieldname,id,name);
					//$("#"+fieldname).prev("div.txtlink").remove();
					//$("#"+fieldname).before(addtxt);
				}
				
				//$("#"+fieldName).parents("td:first").mouseleave();
				$("#txtdiv_"+fieldname).html(name);
				jQuery("#"+fieldname).data("oldid",id);
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

			function onShowBrowser(fieldname,url){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			
			function mailValid() {
				var emailStr = jQuery("#CEmail").val();
				emailStr = emailStr.replace(" ","");
				if (!checkEmail(emailStr)) {
					alert("<%=SystemEnv.getHtmlLabelName(18779,user.getLanguage())%>");
					jQuery("#CEmail").focus();
					return;
				}
			}
					
			function doTransName(fieldname,id,name){
				var delname = fieldname;
				if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
				var restr = "";
				restr += "<div class='txtlink ";
				if(fieldname=="manager" || fieldname=="agent" || fieldname=="parentid" || fieldname=="documentid" || fieldname=="introductionDocid"){restr += "showcon";}
				restr += " txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager" || fieldname=="exploiterIds" || fieldname=="principalIds"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="agent"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
				}else if(fieldname=="documentid" || fieldname=="introductionDocid"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
				}else{
					restr += name;
				}
				restr +="</div>";
				if(fieldname!="manager" && fieldname!="city" && fieldname!="type" && fieldname!="description" && fieldname!="size_n"
					&& fieldname!="source" && fieldname!="sector"){
					restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   		+ "<div class='btn_wh'></div>";
				}
				restr += "</div>";
				return restr;
			}
			<%}%>
			
			
			<%if(canedit || canunfreeze){%>
			//执行编辑
			function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
				var _tempval = tempval;
				if(typeof(delvalue)=="undefined") delvalue = "";
				if(typeof(addvalue)=="undefined") addvalue = "";
				if(fieldtype == "attachment"){
					var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
		    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 1){
		    			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
		    			return;
		    		}
				}
				
				
				$.ajax({
					type: "post",
				    url: "/CRM/customer/Operation.jsp",
				    data:{"operation":"edit_customer_field","customerid":<%=customerid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    //var txt = $.trim(data.responseText);
					    setLastUpdate();
				    	if(fieldname=="manager"){
				    		$("#minfo").show();
							$("#mload").hide();
							window.location = "/CRM/data/ViewCustomerBase.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
				    	if(fieldname=="website"){
							$("#websitelink").attr("href",fieldvalue);
					    }
				    	if(fieldname=="email"){
							$("#emaillink").attr("href","mailto:"+fieldvalue);
					    }
				    	if(fieldname=="type" && fieldvalue=="19"){//个人用户
				    		// window.location = "ViewPerCustomer.jsp?CustomerID=<%=customerid%>";
					    }
				    	if(fieldname=="type" && (fieldvalue=="26" || _tempval=="26")){//人脉
				    		window.location = "/CRM/data/ViewCustomerBase.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
					    }
				    	<%if(!crmmanager){%>
				    	if(fieldname=="source" && (fieldvalue==2||fieldvalue==8||fieldvalue==19||fieldvalue==20||fieldvalue==30||fieldvalue==31||fieldvalue==32)){
							$("#sourcetd").html("<div class='div_show'>"+$("#sourcename").val()+"</div>");
						}
						<%}%>
						if(fieldname=="status" && (_tempval=="4" || _tempval=="5" || _tempval=="6" || _tempval=="7" || _tempval=="8" || _tempval=="10")){
							window.location = "/CRM/data/ViewCustomerBase.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
						if(fieldname=="status" && (fieldvalue==7||fieldvalue==8||fieldvalue==10)){
							window.location = "/CRM/data/ViewCustomerBase.jsp?CustomerID=<%=customerid%>&isrequest=<%=isrequest%>&requestid=<%=requestid%>&nolog=1";
				    	}
				    	
				    	if(fieldtype == "attachment"){
				    		jQuery(".txtlink"+delvalue).remove();
				    		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
				    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 0){
				    			var fieldNameSpan = jQuery("div[fieldName='"+fieldname+"']").attr("fieldNameSpan");
				    			jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
				    		}
				    	}
					}
			    });
				tempval = fieldvalue;
			}
			<%}%>
			
			function urlSubmit(obj,url){
			    obj.disabled= true;
    			location=url;
			}

			//显示相关流程
			var relatewftag = 0;
			var dialog=null;
			//关闭共享
			
			function doAddWorkPlan() {
				window.open("/workplan/data/WorkPlan.jsp?crmid=<%=customerid%>&add=1");
			}
			
			//门户申请
			var applyPortalUrl = null;
			var applyPortalObj = null;
			function applyPortalManager(obj ,url){
			
				applyPortalUrl = url;
				applyPortalObj = obj;
				editPassword(1);//先进行密码设定，然后进行门户申请
			}
			
			
			/***
			*修改密码
			* state 为1表示需要调用门户申请，为0表示不需要
			**/
			var dialog = null;
			function editPassword(state){
				
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/email/MailAccountAdd.jsp";
				dialog.Title = "<%=SystemEnv.getHtmlLabelNames("68,409",user.getLanguage()) %>";
				dialog.Width = 400;
				dialog.Height = 200;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = "/CRM/data/ManagerUpdatePassword.jsp?crmid=<%=customerid%>&type=manager&state="+state;
				dialog.show();
				jQuery("body").trigger("click");
			}
			
			function applyPortalManagerInfo(){
				urlSubmit(applyPortalObj , applyPortalUrl);
				if(null != dialog){
					dialog.close();
				}
			}

			function doAddWorlFlow(){
				window.open("/workflow/request/RequestType.jsp?topage=<%=topage%>&crmid=<%=customerid%>");
			}
			
			function doAddCowork(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/cowork/AddCoWork.jsp?CustomerID=<%=customerid%>";
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(27411,user.getLanguage()) %>";
				dialog.Width = 680;
				dialog.Height = 520;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
				document.body.click();
			}
			function doAddEmail(){
				window.open("/email/MailAdd.jsp?to=<%=Util.convertInput2DB(mailAddress)%>");
			}
			function exportContact(){
				window.open("/docs/docs/DocList.jsp?crmid=<%=customerid%>&isExpDiscussion=y");
			}
			function doAddSellChance(){
				openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceAdd.jsp?CustomerID=<%=customerid%>');
			}
		
			function doWSearch(){
				openFullWindowHaveBar('/system/QuickSearchOperation.jsp?searchtype=9&searchvalue=<%=name%>');
			}
			function openKS(){
				openFullWindowHaveBar('/knowledgeshare/data/DataFrame.jsp?issearch=1&searchtype=&searchname=<%=name%>');
			}
			<%if(canunfreeze){%>
			function doUnfreeze(){
				if(confirm("确定解冻客户?")){
					tempval = "<%=status%>";
					exeUpdate("status","4","num");
				}
			}
			<%}%>

			function doSaveTag(){
				var tagstr = $.trim($("#addtag").val());
				if(tagstr!=""){
					var hastag = false;
					$("div.tagitem").each(function(){
						if($(this).attr("_val")==tagstr){
							hastag = true;
							return;
						}
					});
					if(hastag){
						$("#addtag").val("");
						alert("已存在此标签！");
						$("#addtag").focus();
						return;
					}
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    data:{"operation":"save_tag","customerid":"<%=customerid%>","tag":filter(encodeURI(tagstr))}, 
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
						    $.trim($("#addtag").val(""));
						    //$("#tagdiv").append(txt);
						    $("#tagaddbtn").before(txt);
						    cancelTag();
						}
				    });
				}else{
					alert("请输入标签内容！");
					$("#addtag").focus();
					return;
				}
			}
			function doAddTag(){
				$("#tagaddbtn").hide();
				$("#tagpanel").show();
				$("#addtag").focus();
			}
			function cancelTag(){
				$("#addtag").val("");
				$("#tagaddbtn").show();
				$("#tagpanel").hide();
			}
			function doDelTag(tagstr,obj){
				if(tagstr!=""){
					if(confirm("确定删除此标签?")){
						$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    data:{"operation":"del_tag","customerid":"<%=customerid%>","tag":filter(encodeURI(tagstr))}, 
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    $(obj).parent().remove();
							}
					    });
					}
				}
			}
			
			function markAttention(obj){
				var attobj = $(obj);
				var _special = attobj.attr("_special");
				var customerid =  attobj.attr("_customerid");
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_attention","operatetype":1,"objid":customerid,"settype":_special}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if(_special==1){
							attobj.attr("title","取消关注").attr("_special","0").html("取消关注");
						}else{
							attobj.attr("title","标记关注").attr("_special","1").html("标记关注");
						}
				    	showMsg();
				    }
			    });
			}
			
			function getCrmDate(i){
			   WdatePicker({el:'datespan'+i,onpicked:function(dp){
				   $dp.$('dff0'+i).value = dp.cal.getDateStr()},oncleared:function(dp){$dp.$('dff0'+i).value = ''}});
			}
			
			function UniteCustomer(){
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/CRM/data/UniteCustomer.jsp?CustomerID=<%=customerid%>&isfromCrmTab=true";
				dialog.Title = "客户合并";
				dialog.Width = 420;
				dialog.Height =200;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function UniteCallback(CustomerID){
				window.top.location.href="/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID;
			}
			
			function UniteCallback(CustomerID){
				window.top.location.href="/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID;
			}
			
			//消息提醒
		  function showMsg(msg){
		   
			jQuery("#warn").find(".title").html("操作成功！");
			jQuery("#warn").css("display","block");
			setTimeout(function (){
				jQuery("#warn").css("display","none");
			},1500);
			
		  }
		  
		  function selectchange(obj, fieldName, fieldNameSpan, ismust) {
		  		var fieldvalue = $(obj).val();
		  		checkinput(fieldName,fieldNameSpan);
		  		if(ismust == "1") {
		  			if(fieldvalue == "" || typeof(fieldvalue) == 'undefinede') return;
		  			doUpdate(obj,1); 
		  		}else {
			  		doUpdate(obj,1); 
		  		}
		  }
		
		  function deletecrm(obj, crmid) {
		    var crmids = crmid+",";
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125293,user.getLanguage())%>",function(){
				jQuery.post("/CRM/search/SearchResultOperation.jsp",{"customerids":crmids ,"method":"delete","userid":"<%=user.getUID()%>",
					"logintype":"<%=user.getLogintype()%>","loginid":"<%=user.getLoginid()%>"},function(){
					 window.parent.close();
				})
			});		  
		  
		  }
		  
		  function checkEmailFormate(obj){
		  	var emailStr=$(obj).val();
		  	if(!checkEmail(emailStr)){
		  		$(obj).val("");
		  	}
		  }
		  
		  function checklength(obj, len) {
		  	 var fieldvalue = $(obj).val();
		  	 if(fieldvalue != null) {
			  	 if(fieldvalue.length >= len) {
			  	 	window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83666,user.getLanguage())%>'+len);
			  	 }else {
			  	 	doUpdate(obj,1); 
			  	 }
		  	 }
		  
		  }	
		  
		</script>
	</body>
</html>
