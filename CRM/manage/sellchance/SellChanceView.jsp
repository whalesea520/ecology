
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="ProductTypeComInfo" class="weaver.crm.base.ProductTypeComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<%
	String userid = user.getUID()+"";
	String sellchanceid = Util.null2String(request.getParameter("id"));
	if("2".equals(user.getLogintype())){
		response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?id="+sellchanceid);
		return;
	}
	String contact = Util.null2String(request.getParameter("contact"));
	String customerid = "";
	String subject = "";
	String manager = "";
	String agent = "";
	String source = "";
	String predate = "";
	double preyield = 0;
	double probability = 0;
	String fileids = "";
	String fileids2 = "";
	String fileids3 = "";
	String remark = "";
	String sellstatusid = "";
	String endtatusid = "";
	String selltype = "";
	String createuserid = "";
	String createdate = "";
	String createtime = "";
	String updateuserid = "";
	String updatedate = "";
	String updatetime = "";
	String description = "";
	String producttype = "";
	String ploytype = "";
	String ploydesc = "";
	String failopptid = "";
	String failopptname = "";
	boolean isattention = false;
	rs.executeSql("select t.subject,t.customerid,t.creater,t.content,t.source,t.predate,t.preyield,t.probability,t.fileids,t.fileids2,t.fileids3,t.remark,t.sellstatusid,t.endtatusid,t.selltype,t.createuserid,t.createdate,t.createtime,t.updateuserid,t.updatedate,t.updatetime,t.description,t.producttype,t.ploytype,t.ploydesc,t.opptid,t.opptname"
			+",sa.id as att"
			+" from CRM_SellChance t left join CRM_Common_Attention sa on t.id=sa.objid and sa.operatetype=2 and sa.operator="+userid
			+" where t.id="+sellchanceid);
	if(rs.next()){
		customerid = Util.null2String(rs.getString("customerid"));
		subject = Util.null2String(rs.getString("subject"));
		customerid = Util.null2String(rs.getString("customerid"));
		manager = Util.null2String(rs.getString("creater"));
		agent = Util.null2String(rs.getString("content"));
		source = Util.null2String(rs.getString("source"));
		predate = Util.null2String(rs.getString("predate"));
		preyield = Util.getDoubleValue(rs.getString("preyield"),0)/10000;
		probability = Util.getDoubleValue(rs.getString("probability"),0)*100;
		fileids = Util.null2String(rs.getString("fileids"));
		fileids2 = Util.null2String(rs.getString("fileids2"));
		fileids3 = Util.null2String(rs.getString("fileids3"));
		remark = Util.convertDB2Input(rs.getString("remark"));
		sellstatusid = Util.null2String(rs.getString("sellstatusid"));
		endtatusid = Util.null2String(rs.getString("endtatusid"));
		selltype = Util.null2String(rs.getString("selltype"));
		createuserid = Util.null2String(rs.getString("createuserid"));
		createdate = Util.null2String(rs.getString("createdate"));
		createtime = Util.null2String(rs.getString("createtime"));
		updateuserid = Util.null2String(rs.getString("updateuserid"));
		updatedate = Util.null2String(rs.getString("updatedate"));
		updatetime = Util.null2String(rs.getString("updatetime"));
		description = Util.convertDB2Input(rs.getString("description"));
		producttype = Util.null2String(rs.getString("producttype"));
		ploytype = Util.null2String(rs.getString("ploytype"));
		ploydesc = Util.convertDB2Input(rs.getString("ploydesc"));
		failopptid = Util.null2String(rs.getString("opptid"));
		failopptname = Util.null2String(rs.getString("opptname"));
		if(!Util.null2String(rs.getString("att")).equals("")){
			isattention = true;
		}
	}else{
		response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
		return;
	}
	boolean canedit = false;
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有查看该客户商机权限
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,customerid);
		if(sharelevel<1){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		//判断是否有编辑该客户商机权限
		if(sharelevel>1){
			canedit = true;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
			canedit = false;
		}
	}
	
	String docIds1 = "";
	String docIds2 = "";
	String docIds3 = "";
	String docIds4 = "";
	String docIds5 = "";
	String docIds6 = "";
	String mainId = "";
	String subId = "";
	String secId = "";
	String maxsize = "";
	boolean hasPath = false;
	rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44,55,66,111,222,333) order by id "); 
	while(rs.next()){
		if("11".equals(rs.getString("infotype"))) docIds1 = Util.null2String(rs.getString("item"));
		if("22".equals(rs.getString("infotype"))) docIds2 = Util.null2String(rs.getString("item"));
		if("33".equals(rs.getString("infotype"))) docIds3 = Util.null2String(rs.getString("item"));
		if("44".equals(rs.getString("infotype"))) docIds4 = Util.null2String(rs.getString("item"));
		if("55".equals(rs.getString("infotype"))) docIds5 = Util.null2String(rs.getString("item"));
		if("66".equals(rs.getString("infotype"))) docIds6 = Util.null2String(rs.getString("item"));
		if("111".equals(rs.getString("infotype"))) mainId = Util.null2String(rs.getString("item"));
		if("222".equals(rs.getString("infotype"))) subId = Util.null2String(rs.getString("item"));
		if("333".equals(rs.getString("infotype"))) secId = Util.null2String(rs.getString("item"));
	}
	if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
		hasPath = true;
		rs.executeSql("select maxUploadFileSize from DocSecCategory where id=" + secId);
		rs.next();
		maxsize = Util.null2String(rs.getString(1));
	}
	String sql = "";
	String[] otherinfo = {"描述客户方关键需求","请简述系统厂商、使用情况、内部评价、及遇到的问题","请简述相应的外围资源关系情况"
			,"请描述客户方对我方此方面的优势以及你的强化策略","请描述客户方对我方此方面的劣势以及你的弱化策略","友商名称"
			,"请上传你在商机跟进过程中的","请描述客户方对友商此方面的印象及评价","请描述针对友商此方面你该如何应对的策略"
			,"请描述代理商的主营业务，包括主要经营业务、以往及目前代理的品牌、营业收入、老客户数量、业务经营区域","请描述代理商的销售及服务人员构成和数量","请描述代理商负责人对OA的看法、市场的认识、以及已经接触过的OA厂商等信息"
			,"请描述代理商内已参加泛微培训的人员、以及是否通过考核的情况"};
	boolean hasProt = false;
	
	if(!selltype.equals("1")){
		hasProt = true;
	}else{
		if(Util.getIntValue(sellstatusid,0)>4){
			hasProt = true;
		}
	}
	
	String[] titles = {"项目决策人","客户高层","内部向导","技术影响人","需求影响人"};
	
	int nolog = Util.getIntValue(request.getParameter("nolog"),0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>查看销售商机-<%=subject %></title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8"/>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min_wev8.js"></script>
		<script language="javascript" src="../js/util_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
		<link rel="stylesheet" href="../css/Base_wev8.css" />
		<link rel="stylesheet" href="../css/Contact_wev8.css" />
		<style type="text/css">
			<%if(contact.equals("0")){ %>
			.logtxt a,.logtxt a:active,.logtxt a:visited {text-decoration: none;color: #fff;}
			.logtxt a:hover {text-decoration: underline;color: #fff;}
			.btn_operate{background: #F0F0F0;}
			<%}%>
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
			.item_input,.other_input{line-height: 20px;}
		</style>
		<![endif]-->
	</head>
	<body>
		<table id="main" style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div style="<%if(contact.equals("0")){ %>width: 100%;<%}else{ %>width: 98%;<%} %>height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;margin-top: 4px;<%if(contact.equals("0")){%>background:#E46D0A;color:#fff;<%}else{%>background: url('../images/title_bg_wev8.gif') repeat-x;color:#666666;border: 1px #CCCCCC solid;<%}%>">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;float: left;">销售商机：</div>
							<div style="line-height: 28px;margin-left: 0px;float: left;<%if(contact.equals("0")){%>cursor:pointer;<%} %>"
							 <%if(contact.equals("0")){%> onclick="openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id=<%=sellchanceid %>')" <%} %>>
								<%=subject %>
							</div>
							<%if(contact.equals("0")){ %>
							<div class="ci_add" style="width: 18px;height: 18px;background: url('../images/btn_add2_wev8.png') center no-repeat #E46D0A;float:left;margin-left:5px;margin-top:5px;cursor: pointer;" onclick="parent.addContact('<%=sellchanceid %>',1)" title="添加联系记录"></div>
							<%} %>
							<div class="logtxt" style="float: right;margin-right: 5px;overflow: hidden;">
								<div style="line-height: 28px;margin-left: 40px;float: left;"><%=cmutil.getHrm(createuserid) %> <font title="<%=createtime %>"><%=createdate %></font> 创建</div>
								<div id="lastupdate" style="line-height: 28px;margin-left: 20px;float: left;"><%=cmutil.getHrm(updateuserid) %> <font title="<%=updatetime %>"><%=updatedate %></font> 修改</div>
								<%if(canedit){ %>
								<div class="btn_operate" style=""
									onclick="showLog();">日志明细</div>
								<%} %>
								<%if(isattention){%>
									<div id="btnatt_<%=sellchanceid%>" class="btn_operate btn_att" title="取消关注" _special="0" _sellchanceid="<%=sellchanceid%>">取消关注</div>
								<%}else{ %>
									<div id="btnatt_<%=sellchanceid%>" class="btn_operate btn_att" title="标记关注" _special="1" _sellchanceid="<%=sellchanceid%>">标记关注</div>
								<%} %>
								<div class="btn_operate" onclick="doRemind(1)" title="<%
//查找提醒
boolean isremind = false;
rs.executeSql("select operator,operatedate,operatetime from CRM_Common_Remind where operatetype=2 and objid="+sellchanceid+" order by operatedate desc,operatetime desc");
while(rs.next()){isremind = true;
%><%=ResourceComInfo.getLastname(rs.getString("operator")) + " " + Util.null2String(rs.getString("operatedate")) + " " + Util.null2String(rs.getString("operatetime")) %> 提醒过
<%}
%>">提醒<%if(isremind){%><img src="../images/remind_point_wev8.png" style="margin-left: 2px;margin-bottom: 3px;"/><%}%></div>
								<div class="btn_operate " onclick="openFullWindowHaveBar('/CRM/manage/util/SendContactRemind.jsp?sellchanceid=<%=sellchanceid %>')" title="发起联系提醒流程">流程提醒</div>
		</div>
								
						</div>
						<table style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
						<tr>
						<td valign="top" width="*">
						<!-- 左侧商机信息开始 -->
						<div id="leftdiv" style="width: 100%;margin-top: 20px;overflow-x:hidden;position:relative;" class="scroll1">
							<div style="width: auto;height: 100%;position: relative">
							<!-- 基本信息开始 -->
							<table style="width: 100%;margin-top: 0px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon1"></td>
									<td></td>
									<td valign="top">
										<div class="item_title item_title1">基本信息</div>
										<div class="item_line item_line1"></div>
										<table class="item_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px"/><col width="35%"/><col width="145px"/><col width="*"/></colgroup>
											<tr>
												<td class="title">商机名称</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input" id="subject" name="subject" value="<%=subject %>"/>
													<%}else{ %>
													<div class="div_show"><%=subject %></div>
													<%} %>
												</td>
												<td class="title">销售预期</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input" style="width: 100px;cursor: pointer;" id="predate" name="predate" value="<%=predate %>" readonly="readonly"/>
													<%}else{ %>
													<div class="div_show"><%=predate %></div>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">客户名称</td>
												<td class="data">
													<div class="div_show">
														<a href="javascript:openFullWindowHaveBar('/CRM/manage/customer/CustomerBaseView.jsp?CustomerID=<%=customerid %>')">
															<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>
														</a>
													</div>
												</td>
												<td class="title">预期收益(万)</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input item_num" style="width: 40px;" id="preyield" name="preyield" value="<%=preyield %>" onkeypress="ItemNum_KeyPress()" onblur="checknumber('preyield');"/>万
													<%}else{ %>
													<div class="div_show"><%=preyield %></div>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">客户经理</td>
												<td class="data">
													<input type="hidden" id="manager_val" value="<%=manager %>"/>
													<div class="txtlink showcon txtlink<%=manager %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
														<%if(!manager.equals("0") && !manager.equals("")){ %>
														<div style="float: left;"><%=cmutil.getHrm(manager) %></div>
														<%} %>
													</div>
													<%if(canedit){ %>
											  		<input id="manager" name="manager" class="add_input2" _init="1" _searchwidth="80" _searchtype="hrm"/>
											  		<div class="btn_add"></div>
											  		<div class="btn_browser" onclick="onShowResource('manager')"></div>
											  		<%} %>
												</td>
												<td class="title">可能性(%)</td>
												<td class="data">
													<%if(canedit){ %>
													<input type="text" class="item_input item_num" style="width: 40px;" maxlength="3" id="probability" name="probability" value="<%=probability %>" onkeypress="ItemNum_KeyPress()" onblur="checknumber('probability');checkval();"/>%
													<%}else{ %>
													<div class="div_show"><%=probability %></div>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">中介机构</td>
												<td class="data">
													<input type="hidden" id="agent_val" value="<%=agent %>"/>
													<div class="txtlink showcon txtlink<%=agent %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
														<%if(!agent.equals("0") && !agent.equals("")){ %>
														<div style="float: left;"><%=cmutil.getCustomer(agent) %></div>
														<%if(canedit){ %>
														<div class="btn_del" onclick="doDelItem('agent',<%=agent %>)"></div>
														<div class="btn_wh"></div>
														<%} %>
														<%} %>
													</div>
													<%if(canedit){ %>
											  		<input id="agent" name="agent" class="add_input2" _init="1" _searchwidth="160" _searchtype="agent"/>
											  		<div class="btn_add"></div>
											  		<div class="btn_browser" onclick="onShowAgent('agent')"></div>
											  		<%} %>
												</td>
												<td class="title"><%if(selltype.equals("3")){ %>启动代理的原因<%}else{%>启动项目原因及关键需求<%}%></td>
												<td id="td_fileids" class="data">
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
															<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids','<%=fileidList.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		 %>
												</td>
											</tr>
											<tr>
												<td class="title">商机来源</td>
												<td class="data">
											  		<%if(canedit){ %>
														<input type="text" class="item_input input_select" style="width: 120px !important;" id="sourcename" name="sourcename" _selectid="source_select" value="<%=ContactWayComInfo.getContactWayname(source) %>" readonly="readonly"/>
														<input type="hidden" id="source" name="source" value="<%=source %>" _type="num"/>
													<%}else{ %>
														<div class="div_show"><%=ContactWayComInfo.getContactWayname(source) %></div>
													<%} %>
												</td>
												<td class="title" rowspan="2" title="本商机要成功的最关键因素以及可能存在的风险">成功关键因素(风险)</td>
												<td rowspan="2" class="data">
													<%if(canedit){ %>
													<textarea id="remark" name="remark" class="item_input" style="height: auto;resize: none;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"><%=remark %></textarea>
													<%}else{ %>
														<%=Util.toHtml(remark) %>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">产品类型</td>
												<td class="data" id="td_producttype">
													<input type="hidden" id="producttype" value="<%=producttype %>"/>
													<%if(canedit){ %>
														<%
															ProductTypeComInfo.setTofirstRow();
															while(ProductTypeComInfo.next()){
														%>
															<a id="producttype<%=ProductTypeComInfo.getId() %>" class="slink <%if(producttype.equals(ProductTypeComInfo.getId())){%>sdlink<%}%>"
															 href="javascript:setProductType(<%=ProductTypeComInfo.getId() %>)" title="<%=ProductTypeComInfo.getName() %>"><%=ProductTypeComInfo.getName()%></a>
														<%	} %>
											  		<%}else{ %>
											  			<div class="div_show">
											  			<%if(!"".equals(producttype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/><%=ProductTypeComInfo.getName(producttype)%><%}%>
											  			</div>
											  		<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">商机类型</td>
												<td class="data">
													<%if(canedit){ %>
												  		<a id="selltype1" class="slink <%if("1".equals(selltype)){%>sdlink<%}%>" href="javascript:setSellType(1)" title="终端客户商机">终端客户商机</a>
												  		<a id="selltype2" class="slink <%if("2".equals(selltype)){%>sdlink<%}%>" href="javascript:setSellType(2)" title="老客户二次商机">老客户二次商机</a>
												  		<a id="selltype3" class="slink <%if("3".equals(selltype)){%>sdlink<%}%>" href="javascript:setSellType(3)" title="代理压货商机">代理压货商机</a>
											  		<%}else{ %>
											  			<div class="div_show">
											  			<%if("1".equals(selltype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>终端客户商机<%}%>
											  			<%if("2".equals(selltype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>老客户二次商机<%}%>
											  			<%if("3".equals(selltype)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>代理压货商机<%}%>
											  			</div>
											  		<%} %>
												</td>
												<%if(selltype.equals("1")){ %>
											  	<td class="title">打单策略类型</td>	
											  	<td class="data">
												  	<div id="ployselect" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
												  	<%
												  		Map ploytypeMap = new HashMap();
												  		rs.executeSql("select id,item from CRM_SellChance_Set where infotype=7 order by id");
												  		while(rs.next()){
												  			ploytypeMap.put(rs.getString("id"),rs.getString("item"));
												  	%>
												  		<div id="ployitem<%=Util.null2String(rs.getString("id")) %>" class="ploytype" _id="<%=Util.null2String(rs.getString("id")) %>" _name="<%=Util.null2String(rs.getString("item")) %>">
												  			<%=Util.null2String(rs.getString("item")) %></div>
												  	<%	} %>
												  		<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
												  			<a style="width: 50%;text-align: center;" href="javascript:updatePloyType()">确定</a>&nbsp;
												  			<a style="width: 50%;text-align: center;" href="javascript:cancelPloyType()">取消</a>
												  		</div>
												  	</div>
											  		<%
											  			List ploytypeList = Util.TokenizerString(ploytype,",");
											  			String ploynames = "";
											  			for(int i=0;i<ploytypeList.size();i++){
											  				ploynames += "," + ploytypeMap.get(ploytypeList.get(i));
											  		%>
													<div class='txtlink txtlink<%=ploytypeList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<%=ploytypeMap.get(ploytypeList.get(i)) %>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('ploytype','<%=ploytypeList.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		
														}
											  			if(!ploynames.equals("")) ploynames = ploynames.substring(1);
													%>
													<%if(canedit){ %>
														<div id="btn_ploy" class="btn_browser" onclick="showPloySelect(this)"></div>
														<input type="text" class="add_input2" style="display: none"/>
													<%} %>
													<input type="hidden" id="ploytype" name="ploytype" value="<%=ploytype %>"/>
													<input type="hidden" id="ploytypeName" name="ploytypeName" value="<%=ploynames %>"/>
											  	</td>	
											  	<%}else{ %>
											  	<td class="title" rowspan="2" title="<%if(selltype.equals("3")){ %>代理成交的关键策略<%}else{%>打单策略描述<%}%>"><%if(selltype.equals("3")){ %>代理成交的关键策略<%}else{%>打单策略描述<%}%></td>
												<td rowspan="2" class="data">
													<%if(canedit){ %>
													<textarea id="ploydesc" name="ploydesc" class="item_input" style="height: auto;resize: none;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"><%=ploydesc %></textarea>
													<%}else{ %>
														<%=Util.toHtml(ploydesc) %>
													<%} %>
												</td>
											  	<%} %>
											</tr>
											<tr>
												<td class="title">商机状态</td>
												<td class="data">
													<%List opptList = new ArrayList();
													  if(canedit){ %>
														<div id="endtatusdiv" style="float: left;width: auto;height: auto;">
														<a id="endtatusid5" class="slink <%if("4".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(4)">培育</a>
														<a id="endtatusid1" class="slink <%if("0".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(0)">紧跟</a>
												  		<a id="endtatusid4" class="slink <%if("3".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(3)">暂停</a>
												  		<a id="endtatusid2" class="slink <%if("1".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(1)">成功</a>
												  		<a id="endtatusid3" class="slink <%if("2".equals(endtatusid)){%>sdlink<%}%>" href="javascript:setEndStatus(2)">失败</a>
												  		<%if("2".equals(endtatusid)){%>
												  			对手：<%=failopptname %>
												  		<%} %>
												  		</div>
												  		<div id="failopptdiv" style="float: left;width: auto;height: auto;display: none;">
													  		选择对手：
													  		<select id="failopptid" name="failopptid" style="" onchange="showName()">
													  		<%
													  			//查找友商信息
																rs.executeSql("select id,item,doc from CRM_SellChance_Set where infotype=6 order by id");
													  			while(rs.next()){
													  				String[] oppts = {rs.getString("id"),rs.getString("item"),rs.getString("doc")};
													  				opptList.add(oppts);
													  		%>
													  				<option value="<%=rs.getString("id") %>"><%=rs.getString("item") %></option>
													  		<%	} %>
													  		</select>
													  		<input id="failopptname" type="text" class="oppt_input input_blur" style="display: none" _index="5" value="<%=otherinfo[5]%>"/>
												  			<a href="javascript:executeFail()">确定</a>&nbsp;&nbsp;<a href="javascript:cancelFail()">取消</a>
												  		</div>
												  		
											  		<%}else{ %>
											  			<div class="div_show">
											  			<%if("4".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>培育<%}%>
											  			<%if("0".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>紧跟<%}%>
											  			<%if("3".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>暂停<%}%>
											  			<%if("1".equals(endtatusid)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>成功<%}%>
											  			<%if("2".equals(endtatusid)){%>
											  				<img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>失败
												  			对手：<%=failopptname %>
												  		<%}%>
											  			</div>
											  		<%} 
											  			request.getSession().setAttribute("CRM_SC_OPPTLIST",opptList);
											  		%>
												</td>
												<%if(selltype.equals("1")){ %>
												<td class="title" rowspan="2" title="<%if(selltype.equals("3")){ %>代理成交的关键策略<%}else{%>打单策略描述<%}%>"><%if(selltype.equals("3")){ %>代理成交的关键策略<%}else{%>打单策略描述<%}%></td>
												<td rowspan="2" class="data">
													<%if(canedit){ %>
													<textarea id="ploydesc" name="ploydesc" class="item_input" style="height: auto;resize: none;overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"><%=ploydesc %></textarea>
													<%}else{ %>
														<%=Util.toHtml(ploydesc) %>
													<%} %>
												</td>
												<%} %>
											</tr>
											<tr>
												<td class="title" title="对这个商机的成功与否进行复盘描述：我们是如何赢得这个客户的关键点，或者我们丢失这个客户的具体原因和以后的改进点">复盘文件</td>
												<td id="td_fileids2" class="data">
													<%
														List fileidList2 = Util.TokenizerString(fileids2,",");
														if(fileidList2.equals("")) fileids2 = ",";
														for(int i=0;i<fileidList2.size();i++){
															if(!"0".equals(fileidList2.get(i)) && !"".equals(fileidList2.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)fileidList2.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=fileidList2.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList2.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList2.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids2','<%=fileidList2.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv2" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		%>
												</td>
												
											</tr>
										</table>
									</td>
								</tr>
							</table>
							<!-- 基本信息结束 -->
							
							<%if(selltype.equals("3")){ %>
							<!-- 代理商业务情况描述开始 -->
							<%
								sql = "select id,remark,remark2,opptid from CRM_SellChance_Other where sellchanceid="+sellchanceid+ " and type=8 order by id";
								rs.executeSql(sql);
								if(rs.getCounts()==0){
									String[] agentTitles = {"主营业务","人员构成","负责人对OA的看法","已参加培训人员","是否已有OA商机合作"};
									for(int i=0;i<agentTitles.length;i++){
										rs2.executeSql("insert into CRM_SellChance_Other(sellchanceid,type,remark,remark2) values("+sellchanceid+",8,'"+agentTitles[i]+"','')");
									}
									rs.executeSql(sql);
								}
							%>
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon3"></td>
									<td></td>
									<td>
										<div class="item_title item_title3">代理商业务情况描述</div>
										<div class="item_line item_line3"></div>
										<table id="apply_table" class="other_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="*"/></colgroup>
											<%
												int agentindex = 9;
												while(rs.next()){ 
													if(!(rs.getString("remark").trim()).equals("是否已有OA商机合作")){
											%>
												<tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("remark")).trim() %>
													</td>
													<td>
														<%if(canedit){ %>
															<textarea id="agent_<%=rs.getString("id") %>" _item="<%=Util.null2String(rs.getString("remark")).trim() %>" _type="8" _index="<%=agentindex %>" class="other_input <%if(Util.null2String(rs.getString("remark2")).equals("")){ %>input_blur<%} %>" style="overflow: auto;margin-top:2px;margin-bottom:2px;vertical-align: middle"
																><%if(Util.null2String(rs.getString("remark2")).equals("")){ %><%=otherinfo[agentindex] %><%}else{ %><%=Util.convertDB2Input(rs.getString("remark2")) %><%} %></textarea>
														<%}else{ %>
															<%if(Util.null2String(rs.getString("remark2")).equals("")){ %>
																<div class="input_blur"><%=otherinfo[agentindex] %></div>
															<%}else{ %>
																<%=Util.toHtml(Util.convertDB2Input(rs.getString("remark2"))) %>
															<%} %>
														<%} %>
								             		</td>
								             	</tr>
								             <%		}else{    
								             			String haschance = Util.null2String(rs.getString("remark2"));
								             			String chanceid = Util.null2String(rs.getString("opptid"));
								             			String chancename = "";
								             %>
								            	 <tr>
													<td class="title2">
														<%=Util.null2String(rs.getString("remark")).trim() %>
													</td>
													<td>
														<input type="hidden" id="haschance" value="<%=haschance %>"/>
														<div style="float: left;width: auto;height: auto;padding-top: 3px;">
														<%if(canedit){ %>
															<a id="haschance1" class="slink <%if(haschance.equals("有")){%>sdlink<%}%>" href="javascript:setHasChance('有')">有</a>
															<a id="haschance0" class="slink <%if(haschance.equals("无")){%>sdlink<%}%>" href="javascript:setHasChance('无')">无</a>
												  		<%}else{ %>
												  			<div class="div_show">
												  			<%if("有".equals(haschance)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>有<%}%>
												  			<%if("无".equals(haschance)){%><img src="../images/level_01_wev8.png" border="0" align="absMiddle"/>无<%}%>
												  			</div>
												  		<%} %>
												  		</div>
												  		<div id="relchancediv" style="float: left;width: auto;height: auto;margin-left:10px;<%if(!haschance.equals("有")){%>display:none;<%} %>">
												  			<div style="width: auto;line-height: 22px;float: left;font-weight: bold">对应商机：</div>
												  			<%if(canedit){ %><div class="btn_browser3" onclick="onShowSellChance()"></div><%} %>
															<div class="txt_browser" id="chanceSpan">
																<%if(!chanceid.equals("") && !chanceid.equals("0")){
																	rs2.executeSql("select subject from CRM_SellChance where id="+chanceid);
																	if(rs2.next()) chancename = Util.null2String(rs2.getString(1));
																%>
																<a href="javascript:openFullWindowHaveBar('/CRM/manage/data/SellChanceView.jsp?id=<%=chanceid %>')"><%=chancename %></a>
																<%} %>
															</div>
															<input type="hidden" id="chanceid" name="chanceid" value="<%=chanceid %>"/>
															<input type="hidden" id="chancename" name="chancename" value="<%=chancename %>"/>
														</div>
								             		</td>
								             	</tr>
								             <%	 
								             		}
								             		agentindex++;
								             	} 
								             %>
										</table>
									</td>
								</tr>
							</table>
							<!-- 代理商业务情况描述结束 -->
							<%} %>
							
							<%if(selltype.equals("1")){ %>
							<!-- 商机阶段开始 -->
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="10%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/><col width="15%"/></colgroup>
								<tr>
									<td style="white-space: nowrap"><div style="font-family: '微软雅黑';padding-left: 5px;font-weight: bold;font-size: 14px;">商机阶段：</div></td>
									<%
										boolean selected = false;
										String[] titlestrs = {"意向需求确定：必须建立内部向导人支持我们、必须初步建立我们产品和方案优势、必须挖出竞争对手的弱点；请重点要了解客户需求的来源、预算、策略流程、关键需求、目前接触的厂商、客户行业的特点、客户的管理模式、老板的风格、客户方的组织架构、已有信息化情况"
											,"向导人确定阶段：必须赢得关键决策人的支持、必须引导出我方的产品和方案优势、必须挖掘出友商的致命弱点、以及包装好与该客户对标的泛微成功案例。必须明确我们的方案的优势和劣势、友商的动作、友商的竞争优势和劣势"
											,"决策人支持阶段：必须取得决策人的支持、我们产品的亮点和我们方案的优势已经具有明确文档或者DEMO呈现、建立起对手可能存在的弱点的演示关注点；如果决策人无法决定就必须要求高层演示会"
											,"高层演示成功阶段：必须要关注高层他们关心的需求；DEMO必须准备充分；案例必须准备充分；PPT必须精美；演示会需要带好的资料必须完整：书籍、产品资料、会议议程、公司介绍"
											,"商务谈判阶段：必须明确客户方的最高接受价格和对手的商务价格以及竞争对手目前的报价情况"
											,"合同签约阶段：必须明确我们无法实现的功能和服务不能在合同上文字体系"};
										int titleindex=0;
										SellstatusComInfo.setTofirstRow();
											while(SellstatusComInfo.next()){
												if(sellstatusid.equals(SellstatusComInfo.getSellStatusid())){
													selected = true;
												}else{
													selected = false;
												}
									%>
										<td align="center">
											<div class="sellstatus <%if(selected){%>sellstatus_select<%}%>"
												<%if(!selected && canedit){%> style="cursor: pointer;" onclick="setSellStatus('<%=SellstatusComInfo.getSellStatusid() %>','<%=SellstatusComInfo.getSellStatusname() %>')" 
												title="设置为<%=SellstatusComInfo.getSellStatusname()%>
<%=titlestrs[titleindex] %>"
												<%}%>
											>
												<%=SellstatusComInfo.getSellStatusname() %>
											</div>
										</td>
									<%titleindex++;} %>
								</tr>
							</table>
							<!-- 商机阶段结束 -->
							<%} %>
							
							<%if(!contact.equals("0")){ %>
							<!-- 人员关系开始 -->
							<jsp:include page="/CRM/manage/contacter/ContacterRel.jsp">
								<jsp:param value="<%=customerid %>" name="customerid"/>
								<jsp:param value="<%=canedit %>" name="canedit"/>
							</jsp:include>
							<!-- 人员关系结束 -->
							<%} %>
							
							<%if(selltype.equals("1")){ %>
							<!-- 其他信息开始 -->
							<jsp:include page="OtherInfo.jsp">
								<jsp:param value="<%=sellchanceid %>" name="sellchanceid"/>
								<jsp:param value="<%=canedit %>" name="canedit"/>
								<jsp:param value="<%=docIds1 %>" name="docIds1"/>
								<jsp:param value="<%=docIds2 %>" name="docIds2"/>
								<jsp:param value="<%=docIds3 %>" name="docIds3"/>
								<jsp:param value="<%=docIds4 %>" name="docIds4"/>
								<jsp:param value="<%=docIds5 %>" name="docIds5"/>
								<jsp:param value="<%=docIds6 %>" name="docIds6"/>
								<jsp:param value="<%=mainId %>" name="mainId"/>
								<jsp:param value="<%=subId %>" name="subId"/>
								<jsp:param value="<%=secId %>" name="secId"/>
								<jsp:param value="<%=maxsize %>" name="maxsize"/>
								<jsp:param value="<%=hasPath %>" name="hasPath"/>
							</jsp:include>
							<!-- 其他信息结束 -->
							<%} %>
							
							<%if(hasProt){ %>
							<!-- 产品开始 -->
							<%
								sql = "select t1.id as setid,t1.infotype,t1.item,t2.id,t2.remark"
										+" from CRM_SellChance_Set t1 left join CRM_SellChance_Other t2 on t1.id=t2.setid and t2.sellchanceid="+sellchanceid
										+" where t1.infotype=5 order by t1.id";
								//rs.executeSql(sql);
							%>
							<table id="table_product" style="width: 100%;margin-top: 20px;margin-left: 0px;float: left;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon7"></td>
									<td></td>
									<td>
										<div class="item_title item_title7">
											<div style="float: left;font-family: '微软雅黑';font-size: 14px;"><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></div>
											<%if(canedit){ %>
											<div id="btn_product" style="width: 50px;float: right;margin-right: 5px;" class="btn_addoppt" onclick="doAddProduct()" _status="1">
												新增
											</div>
											<%} %>
										</div>
										<div class="item_line item_line7"></div>
										<table id="product_table" class="product_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="125px;"/><col width="15%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="12%"/><col width="*"/></colgroup>
											<%
												sql = "select id,productid,assetunitid,currencyid,salesprice,salesnum,totelprice from CRM_ProductTable where sellchanceid="+sellchanceid+" order by id";
												rs.executeSql(sql);
												while(rs.next()){ 
													String redid = Util.null2String(rs.getString("id"));
											%>
												<tr id="product_<%=redid %>" class="oppttitle">
													<td class="title3" colspan="2">
														<%if(canedit){ %>
														<div class="btn_browser3" onclick="onShowProduct('<%=redid%>')"></div>
														<%} %>
														<div class="txt_browser" id='productidSpan_<%=redid %>'><a href="/lgc/asset/LgcAsset.jsp?paraid=<%=Util.null2String(rs.getString("productid"))%>" target="_blank">
															<%=Util.toScreen(AssetComInfo.getAssetName(rs.getString("productid")),user.getLanguage())%></a>
														</div>
														<input type=hidden id='productid_<%=redid%>' name='productid_<%=redid%>' value='<%=Util.null2String(rs.getString("productid"))%>' />
													</td>
													<td>
														<span id='assetunitidSpan_<%=redid %>'><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(Util.null2String(rs.getString("assetunitid"))),user.getLanguage())%></span>         			
             											<input type=hidden id='assetunitid_<%=redid%>' name='assetunitid_<%=redid%>' value='<%=Util.null2String(rs.getString("assetunitid"))%>' />
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<div class="btn_browser3" onclick="onShowCurrency('currencyid_<%=redid%>','currencyidSpan_<%=redid %>')"></div>
														<%} %>
														<div class="txt_browser" id='currencyidSpan_<%=redid %>'>
															<%=Util.toScreen(CurrencyComInfo.getCurrencyname(Util.null2String(rs.getString("currencyid"))),user.getLanguage())%>
														</div>
														<input type=hidden id='currencyid_<%=redid%>' name='currencyid_<%=redid%>' value='<%=Util.null2String(rs.getString("currencyid"))%>' />
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<input class='pro_input' id='salesprice_<%=redid%>' name='salesprice_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesprice" value='<%=Util.null2String(rs.getString("salesprice"))%>'/>
								             			<%}else{ %>
									             			<%=Util.null2String(rs.getString("salesprice"))%>
									             		<%} %>
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
								             			<input class='pro_input' id='salesnum_<%=redid%>' name='salesnum_<%=redid%>' onkeypress='ItemNum_KeyPress()' onblur="checknumber(this)" _redid="<%=redid %>" _fieldname="salesnum" value='<%=Util.null2String(rs.getString("salesnum"))%>'/>
								             			<%}else{ %>
									             			<%=Util.null2String(rs.getString("salesnum"))%>
									             		<%} %>
								             		</td>
								             		<td>
								             			<%if(canedit){ %>
									             			<span id='totelprice_<%=redid%>' name='totelprice_<%=redid%>'>
									             			<%if(Util.null2String(rs.getString("totelprice")).equals("")){ %>
									             				<font class="input_blur">总价</font>
									             			<%}else{ %>
									             				<%=Util.null2String(rs.getString("totelprice"))%>
									             			<%} %>
									             			</span>
									             		<%}else{ %>
									             			<%=Util.null2String(rs.getString("totelprice"))%>
									             		<%} %>
								             		</td>
								             		<td align="right">
								             			<%if(canedit){ %>
								             				<div class="opptdel" onclick="delProduct('<%=redid %>',this)" title="删除"></div>	
								             			<%} %>
								             		</td>
								             	</tr>
								             <%} %>
								             <%if(canedit){ %>
								             	<tr id="product_add" style="display: none" class="oppttitle">
													<td class="title3" colspan="2">
														<div class="btn_browser3" onclick="onShowProduct('')"></div>
														<div class="txt_browser">
															<font class="input_blur"><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></font>
															<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:0px;'/>
														</div>
													</td>
													<td>
														<font class="input_blur"><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></font>
								             		</td>
								             		<td>
								             			<font class="input_blur"><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></font>
								             		</td>
								             		<td align="right">
								             			<div class="opptdel" onclick="doAddProduct()" title="取消"></div>	
								             		</td>
								             	</tr>
								             <%} %>
								             <tr><td width="125px" style="width: 125px;"></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>
								             <tr>
								             	<td class="title2" width="125px" style="width: 125px;">报价书/合同书</td>
								             	<td id="td_fileids3" colspan="7">
													<%
														List fileidList3 = Util.TokenizerString(fileids3,",");
														for(int i=0;i<fileidList3.size();i++){
															if(!"0".equals(fileidList3.get(i)) && !"".equals(fileidList3.get(i))){
																DocImageManager.resetParameter();
													            DocImageManager.setDocid(Integer.parseInt((String)fileidList3.get(i)));
													            DocImageManager.selectDocImageInfo();
													            DocImageManager.next();
													            String docImagefileid = DocImageManager.getImagefileid();
													            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
													            String docImagefilename = DocImageManager.getImagefilename();
													%>
													<div class='txtlink txtlink<%=fileidList3.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
														<div style='float: left;'>
															<a href="javaScript:openFullWindowHaveBar('/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList3.get(i) %>&sellchanceid=<%=sellchanceid %>')"><%=docImagefilename %></a>
															&nbsp;<a href='/CRM/manage/util/ViewDoc.jsp?id=<%=fileidList3.get(i) %>&sellchanceid=<%=sellchanceid %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
														</div>
														<%if(canedit){ %>
														<div class='btn_del' onclick="doDelItem('fileids3','<%=fileidList3.get(i) %>')"></div>
														<div class='btn_wh'></div>
														<%} %>
													</div>
													<% 		} 
														}
													%>
													<%if(canedit){ 
														if(hasPath){
													%>
											  			<div id="uploadDiv3" class="upload" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
											  		<%	}else{ %>
											  			<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
											  		<%	}
											  		  } 
											  		 %>
												</td>
								             </tr>
										</table>
									</td>
								</tr>
							</table>
							<!-- 产品结束 -->
							<%} %>
							<div style="width: 100%;height: 20px;float: left;"></div>
							</div>
						</div>
						<!-- 左侧商机信息结束 -->
						</td>
						<%if(!contact.equals("0")){ %>
						<td valign="top" width="1%">
						<div id="btn_center" class="btn_center" _status="0" title="收缩"></div>
						</td>
						<td id="righttd" valign="top" width="29%">
						<!-- 右侧联系记录开始 -->
						<div id="rightdiv" style="width: 100%;overflow: auto;">
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon10"></td>
									<td></td>
									<td style="position: relative;">
										<div class="item_title item_title1">联系记录</div>
										<div class="item_line item_line10"></div>
										<div id="contactdiv" style="width: 100%;height: auto;">
											<jsp:include page="DetailView.jsp">
												<jsp:param value="<%=sellchanceid %>" name="sellchanceid"/>
												<jsp:param value="<%=subject %>" name="sellchancename"/>
												<jsp:param value="<%=customerid %>" name="customerid"/>
												<jsp:param value="<%=nolog %>" name="nolog"/>
												<jsp:param value="1" name="hidetitle"/>
											</jsp:include>
										</div>
									</td>
								</tr>
							</table>
						</div>
						<!-- 右侧联系记录结束 -->
						</td>
						<%} %>
						</tr>
						</table>
					</div>
				</td>
			</tr>
		</table>
		<%if(canedit){ %>
			<%if(!contact.equals("0")){ %>
			<!-- 
			<div id="" class="select_div">
				<div class="select_item">项目决策人</div>
				<div class="select_item">客户高层</div>
				<div class="select_item">内部向导</div>
				<div class="select_item">技术影响人</div>
				<div class="select_item">需求影响人</div>
				<div class="select_item">其他</div>
			</div>
			 -->
			<div id="pr_select" style="min-width: 100px;height: auto;overflow: hidden;position: absolute;display: none;background: #fff;
															border: 1px #CACACA solid;padding-left: 0px;padding-right: 0px;
															border-radius: 3px;
															-moz-border-radius: 3px;
															-webkit-border-radius: 3px;
															box-shadow: 0px 0px 3px #CACACA;
															-moz-box-shadow: 0px 0px 3px #CACACA;
															-webkit-box-shadow: 0px 0px 3px #CACACA;">
				<div id="roleitem_项目决策人" class="roletype">项目决策人</div>
				<div id="roleitem_客户高层" class="roletype">客户高层</div>
				<div id="roleitem_内部向导" class="roletype">内部向导</div>
				<div id="roleitem_技术影响人" class="roletype">技术影响人</div>
				<div id="roleitem_需求影响人" class="roletype">需求影响人</div>
				<div id="roleitem_其他" class="roletype">其他</div>
				<div style="width: 100%;text-align: center;height: 22px;line-height: 22px;">
					<a style="width: 50%;text-align: center;" href="javascript:updateRoleType()">确定</a>&nbsp;
					<a style="width: 50%;text-align: center;" href="javascript:cancelRoleType()">取消</a>
				</div>
			</div>
			<div id="at_select" class="select_div">
				<div class="select_item">支持我方</div>
				<div class="select_item">未表态</div>
				<div class="select_item">未反对</div>
				<div class="select_item">反对</div>
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
		<div id="pre_select" class="item_select" _inputid="preyield">
			<div class="item_option" _val="5">5万</div>
			<div class="item_option" _val="10">10万</div>
			<div class="item_option" _val="20">20万</div>
			<div class="item_option" _val="30">30万</div>
			<div class="item_option" _val="50">50万</div>
			<div class="item_option" _val="100">100万</div>
			<div class="item_option" _val="200">200万</div>
		</div>
		<div id="pro_select" class="item_select" _inputid="probability">
			<div class="item_option" _val="30">30%   需求满足且客户联系人对泛微有好印象</div>
			<div class="item_option" _val="50">50%   我方产品方案优势确立并得到内部向导支持</div>
			<div class="item_option" _val="70">70%   对手存在客户方不接受的弱点且决策人已支撑我方</div>
			<div class="item_option" _val="90">90%   客户高层已同意确立合作、商务已经谈妥</div>
			<div class="item_option" _val="100">100% 合同已客户已盖章或提交客户方流转</div>
		</div>
		<div id="source_select" class="item_select" _inputid="source" style="width:150px;height: 250px;overflow-x: hidden;overflow-y: auto;">
			<% 
				ContactWayComInfo.setTofirstRow();
				while(ContactWayComInfo.next()){
			%>
			<div class="item_option" _val="<%=ContactWayComInfo.getContactWayid() %>"><%=ContactWayComInfo.getContactWayname() %></div>
			<%	} %>
		</div>
		
		<!-- 日志明细开始 -->
		<div id="transbg" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/transbg_wev8.png') repeat;display: none;"></div>
		<div id="log_list" style="width: 100%;height: 471px;overflow: hidden;position: absolute;top: 100px;left:0px;display: none;">
			<div style="background: url('../images/log_bg_wev8.png') no-repeat;width: 590px;height: 100%;margin: 0px auto;overflow: hidden;position: relative;">
				<div style="width: 580px;margin-left: 5px;position: relative;">
					<div style="width: 18px;height: 18px;background: url('../images/log_btn_close_wev8.png');position: absolute;top:15px;right: 10px;cursor: pointer;" onclick="closeLog()" title="关闭"></div>
					<div id="log_title" style="line-height: 45px;padding-left: 10px;color: #fff;font-weight: bold;font-size: 14px;font-family: '微软雅黑'">操作日志</div>
					<div id="log_detail" class="scroll2" style="height: 410px;width: 98%;margin: 0px auto;position: relative;">
						<div id="logmore" class="datamore" style="display: none;text-align: center;" 
							onclick="getListLog(this)" _datalist="logtable" 
							_currentpage="0" _pagesize="30" _total="" title="显示更多数据">更多</div>
						<div id="log_load" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;background: url('../images/loading2_wev8.gif') center no-repeat;"></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 日志明细结束 -->
		<%} %>
		
		<!-- 提示信息 -->
		<div id="msg" style="position: fixed;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
			border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
			border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div>	
		
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			<%if(isremind && manager.equals(userid)){%>
				doRemind(0);
			<%}%>
		
			var tempval = "";//用于记录原值
			var foucsobj2 = null;
			var relinfomap = new Map();
			var description = "请描述客户方的决策流程、以及内部关系，和如何赢得这些客户方关键人的支持";
			var otherinfomap = new Map();
			
			$(document).ready(function(){
				
				<%if(canedit){%>
				relinfomap.put("FirstName","姓名");
				relinfomap.put("Title","称呼");
				relinfomap.put("JobTitle","岗位");
				relinfomap.put("textfield1","部门");
				relinfomap.put("Mobile","联系方式");
				relinfomap.put("Mobile","联系方式");
				relinfomap.put("attention","关注点");
				relinfomap.put("attitude","意向判断");

				<%for(int i=0;i<otherinfo.length;i++){%>
					otherinfomap.put("otherinfo<%=i%>","<%=otherinfo[i]%>");
				<%}%>
				
				//日期控件
				$.datepicker.setDefaults( {
					"dateFormat": "yy-mm-dd",
					"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
					"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
					"changeMonth": true,
					"changeYear": true} );
				$("#predate").datepicker({
					"onSelect":function(){
						doUpdate($("#predate"),1);
					}
				});

				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					if(this.id=="preyield"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#pre_select").height())>$(window).height()){
							_top = _top-26-$("#pre_select").height();
						}
						$("#pre_select").css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="probability"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#pro_select").height())>$(window).height()){
							_top = _top-26-$("#pro_select").height();
						}
						$("#pro_select").css({"top":_top,"left":_left}).show();
						$(this).width(100);
					}
					if(this.id=="sourcename"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						if((_top+$("#source_select").height())>$(window).height()){
							_top = _top-26-$("#source_select").height();
						}
						$("#source_select").css({"top":_top,"left":_left}).show();
					}
					if(this.id=="remark" || this.id=="ploydesc" || this.id=="description"){
						$(this).height(70);
					}
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
					if(this.id=="preyield"||this.id=="probability"){
						$(this).width(40);
					}
					if(this.id=="remark" || this.id=="ploydesc" || this.id=="description"){
						setRemarkHeight(this.id);
					}
					if(!$(this).hasClass("input_select")){
						doUpdate(this,1);
					}
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
				
				//表格行背景效果及操作按钮控制绑定
				$("table.item_table").find("td.data").bind("click mouseenter",function(){
					$(".btn_add").hide();$(".btn_browser").hide();
					$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
					$(this).find(".item_input").addClass("item_input_hover");
					//$(this).find(".item_num").width(100);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").show();
						$(this).find("div.btn_browser").show();
					}
					$(this).find("div.btn_add2").show();
					$(this).find("div.btn_browser2").show();
					//$(this).find("div.upload").show();
				}).bind("mouseleave",function(){
					$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
					$(this).find(".item_input").removeClass("item_input_hover");
					//$(this).find(".item_num").width(40);
					if($(this).find("input.add_input2").css("display")=="none"){
						$(this).find("div.btn_add").hide();
						$(this).find("div.btn_browser").hide();
					}
					$(this).find("div.btn_add2").hide();
					$(this).find("div.btn_browser2").hide();
					//$(this).find("div.upload").hide();
				});
				
				//其他相关信息表格事件绑定
				$("table.other_table").find("td").live("click mouseenter",function(){
					$(this).addClass("td_hover").find(".other_input").addClass("other_input_hover");
					$(this).prev("td.title2").addClass("td_hover");
					//$(this).find("div.upload").show();
				}).live("mouseleave",function(){
					$(this).removeClass("td_hover").find(".other_input").removeClass("other_input_hover");
					$(this).prev("td.title2").removeClass("td_hover");
					//$(this).find("div.upload").hide();
				});
				$(".other_input").live("focus",function(){
					$(this).addClass("other_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
					var _index = $(this).attr("_index");
					if(this.value == otherinfomap.get("otherinfo"+_index)){
						this.value = "";
						$(this).removeClass("input_blur");
					}
					$(this).height(70);
				}).live("blur",function(){
					$(this).removeClass("other_input_focus");
					setRemarkHeight(this.id);
					doUpdateOther(this);
				}).each(function(){
					setRemarkHeight(this.id);
				});

				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					var _inputid = $(this).parent().attr("_inputid");
					var obj = $("#"+_inputid);
					tempval = obj.val();
					obj.val($(this).attr("_val"));
					if(_inputid=="source"){
						$("#"+_inputid+"name").val($(this).html());
					}
					doUpdate(obj,1);
				});
				
				$("div.ploytype").bind("mouseover",function(){
					$(this).addClass("ploytype_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("ploytype_hover");
				}).bind("click",function(){
					if($(this).hasClass("ploytype_select")){
						$(this).removeClass("ploytype_select");
					}else{
						$(this).addClass("ploytype_select");
					}
				});


				//联想输入框事件绑定
				$("input.add_input2").bind("focus",function(){
					if($(this).attr("_init")==1 && $(this).attr("id")!="source"){
						$(this).FuzzyQuery({
							url:"/CRM/manage/util/GetData.jsp",
							record_num:5,
							filed_name:"name",
							searchtype:$(this).attr("_searchtype"),
							divwidth: $(this).attr("_searchwidth"),
							updatename:$(this).attr("id"),
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

				//人员关系应对策略输入框事件绑定
				$("input.detailinput").bind("mouseover",function(){
					$(this).addClass("detailinput_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("detailinput_hover");
				}).bind("focus",function(){
					$(this).removeClass("detailinput_hover").addClass("detailinput_focus");
					tempval = $(this).val();
					foucsobj2 = this;
				}).bind("blur",function(){
					$(this).removeClass("detailinput_focus");
					doUpdateDetail(this);
				});


				$("div.datamore").live("mouseover",function(){
					$(this).addClass("datamore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("datamore_hover");
				});


				$("#addtable").find("input.info_input").bind("focus",function(){
					var _keyword = relinfomap.get(this.id);
					if(this.value == _keyword){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				}).bind("blur",function(){
					var _keyword = relinfomap.get(this.id);
					if(this.value == ""){
						this.value = _keyword;
						$(this).addClass("input_blur");
					}
				});
				
				if($("#description").val()=="") $("#description").val(description).addClass("input_blur");
				$("#description").bind("focus",function(){
					if(this.value == description){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				});

				//选择友商部分事件绑定
				$("div.btn_addoppt").bind("mouseover",function(){
					$(this).addClass("btn_addoppt_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_addoppt_hover");
				});
				$("div.selectitem").bind("mouseover",function(){
					$(this).addClass("selectitem_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("selectitem_hover");
				});
				$("#btn_oppt").bind("click",function(){
					$("#opptselect").css({
						"left":$(this).position().left+"px",
						"top":$(this).position().top+21+"px"
					}).show();
				});
				$("input.oppt_input").live("mouseover",function(){
					$(this).addClass("oppt_input_hover");
				}).live("mouseout",function(){
					$(this).removeClass("oppt_input_hover");
				}).live("focus",function(){
					$(this).addClass("oppt_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
					var _index = $(this).attr("_index");
					if(this.value == otherinfomap.get("otherinfo"+_index)){
						this.value = "";
						$(this).removeClass("input_blur");
					}
				}).live("blur",function(){
					$(this).removeClass("oppt_input_focus");
					if($(this).attr("id")!="failopptname"){
						doUpdateOpptname(this);
					}
				});
				$("tr.oppttitle").live("mouseenter",function(){
					$(this).find("div.opptdel").show();
				}).live("mouseleave",function(){
					$(this).find("div.opptdel").hide();
				});
				$("tr.opptitem").live("mouseenter",function(){
					var trtitle = $(this).prevAll("tr.oppttitle")[0];
					$(trtitle).find("div.opptdel").show();
				}).live("mouseleave",function(){
					var trtitle = $(this).prevAll("tr.oppttitle")[0];
					$(trtitle).find("div.opptdel").hide();
				});
				

				$("#leftdiv").scroll(function(){
					$("#pre_select").hide();
					$("#pro_select").hide();
					$("#source_select").hide();
					$("#opptselect").hide();
					$("div.select_div").hide();
					$("#pr_select").hide();
				});

				<%if(canedit && hasPath){%>
					bindUploaderDiv($("#uploadDiv"),"fileids","<%=sellchanceid%>");
					bindUploaderDiv($("#uploadDiv2"),"fileids2","<%=sellchanceid%>");
					<%if(hasProt){%>
						bindUploaderDiv($("#uploadDiv3"),"fileids3","<%=sellchanceid%>");
					<%}%>
				<%}%>

				<%if(hasProt){ %>
				//产品明细输入框事件绑定
				$("input.pro_input").live("focus",function(){
					$(this).removeClass("pro_input_hover").addClass("pro_input_focus");
					tempval = $(this).val();
					foucsobj2 = this;
				}).live("blur",function(){
					$(this).removeClass("pro_input_focus");

					var redid = $(this).attr("_redid");
					var fieldname = $(this).attr("_fieldname");
					var fieldval = eval(toFloat($(this).val(),0))
					if(fieldval=="" || toFloat(fieldval)==toFloat(tempval)){
						$(this).val(tempval);
						return;
					}
			    	var salesprice = eval(toFloat($("#salesprice_"+redid).val(),0));
			    	var salesnum = eval(toFloat($("#salesnum_"+redid).val(),0));
			        var totelprice = toFloat(salesprice) * toFloat(salesnum);
			    	$("#totelprice_"+redid).html(toPrecision(totelprice,4));
					
					doUpdatePro(fieldname,fieldval,redid,fieldval,toPrecision(totelprice,4));
				});
				$("#product_table").find("tr").live("click mouseenter",function(){
					$(this).find("td").addClass("td_hover").find("input.pro_input").addClass("pro_input_hover");
					//$(this).find("div.upload").show();
				}).live("mouseleave",function(){
					$(this).find("td").removeClass("td_hover").find("input.pro_input").removeClass("pro_input_hover");
					//$(this).find("div.upload").hide();
				});
				$("#table_product").bind("mouseenter",function(){
					$(this).find("div.btn_addoppt").show();
				}).bind("mouseleave",function(){
					$(this).find("div.btn_addoppt").hide();
				});
				<%}%>

				//页面点击及回车事件绑定
				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if($(target).attr("id")!="pre_select" && $(target).attr("id")!="preyield"){
						$("#pre_select").hide();
					}
					if($(target).attr("id")!="pro_select" && $(target).attr("id")!="probability"){
						$("#pro_select").hide();
					}
					if($(target).attr("id")!="source_select" && $(target).attr("id")!="sourcename"){
						$("#source_select").hide();
					}
					if($(target).attr("id")!="btn_oppt"){
						$("#opptselect").hide();
					}
					if($(target).attr("id")!="btn_ploy" && !$(target).hasClass("ploytype")){
						$("#ployselect").hide();
					}
				}).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).hasClass("item_input") && $(target).attr("id")!="remark" && $(target).attr("id")!="ploydesc"){
				    		$(foucsobj2).blur();  
				    		$("div.item_select").hide();
				    	}
						if($(target).hasClass("detailinput") || $(target).hasClass("oppt_input") || $(target).hasClass("pro_input")){
				    		$(foucsobj2).blur();  
				    	}
				    }
				});

				$("#table_other").bind("mouseenter",function(){
					$(this).find("div.btn_addoppt").show();
				}).bind("mouseleave",function(){
					$(this).find("div.btn_addoppt").hide();
				});

				<%if(!contact.equals("0")){ %>cancelAddContacter();<%}%>
				<%}%>

				//关注事件绑定
				$("div.btn_att").bind("click",function() {
					var attobj = $(this);
					var _special = attobj.attr("_special");
					var sellchanceid =  attobj.attr("_sellchanceid");
					$.ajax({
						type: "post",
						url: "/CRM/manage/util/Operation.jsp",
					    data:{"operation":"do_attention","operatetype":2,"objid":sellchanceid,"settype":_special}, 
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
				});

				//收缩展开绑定
				$("#btn_center").bind("mouseover",function(){
					$(this).addClass("btn_right");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_right");
				}).bind("click",function(){
					var _status = $(this).attr("_status");
					if(_status==0){
						$(this).attr("_status",1).attr("title","展开联系记录").addClass("btn_left");
						$("#righttd").width(0).hide();
						//$("#leftdiv").width("99%");
					}else{
						$(this).attr("_status",0).attr("title","收缩联系记录").removeClass("btn_left");
						$("#righttd").width("29%").show();
						//$("#leftdiv").width("70%");
					}
					setPosition();
				});

				setPosition();
				setRemarkHeight("remark");
				setRemarkHeight("ploydesc");
				setRemarkHeight("description");
			});

			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});

			function setPosition(){
				
				<%if(!contact.equals("0")){%>
					if($(window).width()<1000){
						$("#main").width(1000);
					}else{
						$("#main").width("100%");
					}
				
					//var wh = document.body.clientHeight;
					var wh = $(window).height();
					//if(wh2<wh){wh=wh2;}
					$("#main").height(wh);
					$("#btn_center").height(wh);
					
					var _top = $("#contactdiv").offset().top;
					$("#contactdiv").height(wh-_top-5);
	
					var _top2 = $("#leftdiv").offset().top;
					$("#leftdiv").height(wh-_top2-5);
				<%}else{%>
					var wh = $(document).height();
					if(parent!=null && parent.setFrameHeight!= null) parent.setFrameHeight(<%=sellchanceid%>,wh);
				<%}%>

				//if(_relid!="") onAddContacter(_relid);
				//$("#maininfo").height($("#main").height()-_top-$("#fbmain").height()-5);
			}
			function setRemarkHeight(remarkid){
				if($("#"+remarkid).length>0){
					$("#"+remarkid).height("auto");
					var h= document.getElementById(remarkid).scrollHeight; 
					//h = $("#"+remarkid).height();
					//alert(h);alert(document.getElementById(remarkid).clientHeight);
					//alert($("#"+remarkid).val().indexOf("\n"))
					if(h>70){
						$("#"+remarkid).height(70);
						//$("#"+remarkid).height(textarea.scrollHeight);
					}else if(h<20 || ($("#"+remarkid).val().indexOf("\n")<0 && h==34)){
						$("#"+remarkid).height(20);
					}else{
						$("#"+remarkid).height(h);
					}
				}
			}

			//提醒操作
			function doRemind(settype){
				$.ajax({
					type: "post",
					url: "/CRM/manage/util/Operation.jsp",
				    data:{"operation":"do_remind","operatetype":2,"objid":"<%=sellchanceid%>","settype":settype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    if(settype==1) showMsg();
				    }
			    });
			}
			function setLastUpdate(){
				
				var currentdate = new Date();
				var datestr = currentdate.format("yyyy-MM-dd");
				var timestr = currentdate.format("hh:mm:ss");
				$("#lastupdate").html("<a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> <font title='"+timestr+"'>"+datestr+"</font> 修改");
				
				<%if(contact.equals("0")){%>
					if(parent!=null && parent.showMsg!= null) parent.showMsg();
				<%}else{%>
					var _left = Math.round(($(window).width()-$("#msg").width())/2);
					$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
						$(this).fadeOut(800);
					});
				<%}%>
			}
			function showMsg(){
				var _left = Math.round(($(window).width()-$("#msg").width())/2);
				$("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
					$(this).fadeOut(800);
				});
			}

			<%if(canedit){%>
			//显示日志
			function showLog(){
				<%if(contact.equals("0")){%>
				if(parent!=null && parent.showLog!= null) parent.showLog("<%=sellchanceid%>","<%=subject%>");
				<%}else{%>
				
					$("#transbg").show();
					$("#log_list").show();
					$("#log_load").show();
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"get_log_count","sellchanceid":<%=sellchanceid%>}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
					    	$("#logmore").attr("_total",txt).attr("_currentpage","0").click();
						}
				    });
				<%}%>
			}
			//关闭日志
			function closeLog(){
				$("#transbg").hide();
				$("#log_list").hide();
				$("div.logitem").remove();
			}
			//读取日志更多记录
			function getListLog(obj){
				var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
				var _pagesize = $(obj).attr("_pagesize");
				var _total = $(obj).attr("_total");
				$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"get_log_list","sellchanceid":<%=sellchanceid%>,"currentpage":_currentpage,"pagesize":_pagesize,"total":_total}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	var records = $.trim(data.responseText);
				    	$("#log_load").hide();
				    	$(obj).before(records);
				    	if(_currentpage*_pagesize>=_total){
				    		$(obj).hide();
					    }else{
					    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
						}
					}
			    });
			}
			//添加友商信息
			function doAddOppt(obj){
				var opptid = $(obj).attr("_id");
				var opptname = $(obj).attr("_name");
				if(opptname!="其他" && $("tr.opptid"+opptid).length>0){
					alert("已存在"+opptname+"的相关信息!");
					return;
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"add_oppt","sellchanceid":<%=sellchanceid%>,"opptid":opptid,"opptname":filter(encodeURI(opptname)),"default1":filter(encodeURI("<%=otherinfo[7]%>")),"default2":filter(encodeURI("<%=otherinfo[8]%>"))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var recd = txt.split("$")[0];
					    var _batchid = txt.split("$")[1];
					    var _opptid = $(obj).attr("_id");
					    var _opptname = $(obj).attr("_name");
					    var docstr = $(obj).find("div").html();

					    var trstr = "<tr class='oppttitle oppt"+_batchid+" opptid"+_opptid+"'>"
							+"<td class='oppttd'>"+_opptname;
					    if(_opptname=="其他"){
					    	trstr += "<input type='text' class='oppt_input input_blur' _index='5' _batchid='"+_batchid+"' value='"+otherinfomap.get("otherinfo5")+"'/>"
						}
					    trstr +="</td>"
							+"<td colspan='3'>"+docstr+"<div class='opptdel' onclick=delOppt('"+_batchid+"','"+_opptname+"') title='删除'></div></td>"
							+"</tr>";
					    
						$("#oppt_table").append(trstr).append(recd);
				    	setLastUpdate();
				    	//$("#logdiv").prepend(log);
					}
			    });
			}
			//删除友商信息
			function delOppt(batchid,opptname){
				if(confirm("确认删除友商信息？")){
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    data:{"operation":"del_oppt","sellchanceid":<%=sellchanceid%>,"batchid":batchid,"opptname":filter(encodeURI(opptname))}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
						    $("tr.oppt"+batchid).remove();
					    	setLastUpdate();
						}
				    });
				}
			}

			//输入框保存方法
			function doUpdate(obj,type){
				var fieldname = $(obj).attr("id");
				var fieldvalue = "";
				if(type==1){
					if($(obj).val()==tempval) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="preyield"||fieldname=="probability"){
					if($(obj).val()-tempval==0) return;
					fieldvalue = $(obj).val();
				}
				if(fieldname=="subject"||fieldname=="preyield"||fieldname=="probability"||fieldname=="predate"){
					if($.trim(fieldvalue)==""){
						$(obj).val(tempval);
						return;
					}
				}
				if(fieldname=="description" && ($.trim(fieldvalue)==description || $.trim(fieldvalue)=="")){
					$(obj).val(description);
					$(obj).addClass("input_blur");
					if(tempval==description) return;
				}
				if(fieldname=="description" && tempval==description){ tempval = ""; }
				exeUpdate(fieldname,fieldvalue,"str");
			}
			//删除选择性内容
			function doDelItem(fieldname,fieldvalue,setid){
				if(fieldname=="ploytype"){
					var selectids = $("#ploytype").val();
					var ids = selectids.split(",");
					$("div.ploytype").removeClass("ploytype_select");
					for(var i=0;i<ids.length;i++){
						if(ids[i]!="" && ids[i]!=fieldvalue){
							$("#ployitem"+ids[i]).addClass("ploytype_select");
						}
					}
					updatePloyType();
					return;
				}
				var _fieldvalue = fieldvalue;
				var _setid = getVal(setid);
				if(fieldname!="fileids"&&fieldname!="fileids2"&&fieldname!="fileids3"&&setid==""){
					tempval = $("#"+fieldname+"_val").val();
					_fieldvalue = "0";
					$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
				}
				if(fieldname=="agent") _fieldvalue = "";
				var fieldtype = "num";
				if(fieldname=="agent") fieldtype = "str"; 
				if(fieldname=="fileids"||fieldname=="fileids2"||fieldname=="fileids3"||_setid!=""){
					 fieldtype = "del";
					 $("div.txtlink"+fieldvalue).find("div.btn_del").css("background","url('../images/loading2_wev8.gif') center no-repeat").unbind("click");
				} 
				exeUpdate(fieldname,_fieldvalue,fieldtype,'','',_setid);
			}
			//选择内容后执行更新
			function doSelectUpdate(fieldname,id,name){
				var addtxt = doTransName(fieldname,id,name);
				$("#"+fieldname).prev("div.txtlink").remove();
				$("#"+fieldname).before(addtxt);
				tempval = $("#"+fieldname+"_val").val();
				if(tempval==id) return;
				var fieldtype = "num";
				if(fieldname=="agent") fieldtype = "str"; 
				exeUpdate(fieldname,id,fieldtype);
			}
			//执行编辑
			function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
				var _tempval = tempval;
				if(typeof(delvalue)=="undefined") delvalue = "";
				if(typeof(addvalue)=="undefined") addvalue = "";
				<%if(selltype.equals("3")){%>
					if(fieldname=="ploydesc"){
						fieldname = "ploydesc_";
					}
				<%}%>
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_field","sellchanceid":<%=sellchanceid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
				    	if(fieldname=="fileids" || fieldname=="fileids2" || fieldname=="fileids3"){
				    		$("#td_"+fieldname).find(".txtlink").remove();
				    		$("#td_"+fieldname).prepend(txt);
					    }
					    if(setid!=""){
					    	$("#filetd_"+setid).find(".txtlink").remove();
							$("#filetd_"+setid).prepend($.trim(txt));
							if($.trim(txt)==""){
								var titlename = $("#filetd_"+setid).prev("td.title2").html();
								$("#filetd_"+setid).prepend("<div class='txtlink input_blur' style='margin-right: 5px'><%=otherinfo[6] %>"+titlename+"文件</div>");
							}
							
						}
				    	if(fieldname=="selltype"||fieldname=="endtatusid"||fieldname=="sellstatusid"){
					    	<%if(contact.equals("0")){%>
								if(fieldname=="endtatusid" && (fieldvalue==1 || fieldvalue==2)){
									if(parent!=null && parent.remveFrame!= null) parent.remveFrame("<%=sellchanceid%>");
								}else{
									setLastUpdate();
									window.location = "SellChanceView.jsp?id=<%=sellchanceid%>&contact=<%=contact%>&nolog=1";
								}
					    	<%}else{%>
					    		setLastUpdate();
					    		window.location = "SellChanceView.jsp?id=<%=sellchanceid%>&contact=<%=contact%>&nolog=1";
					    	<%}%>
				    	}
				    	if(fieldname=="producttype"){
				    		$("#td_producttype").children("a.slink").removeClass("sdlink");
							$("#producttype"+fieldvalue).addClass("sdlink");
							$("#producttype").val(fieldvalue);
					    }
				    	if(fieldname=="ploytype"){
				    		$("#ploytype").val(fieldvalue);
				    		$("#ploytypeName").val(delvalue);
				    		$("#btn_ploy").prevAll("div.txtlink").remove();
				    		$("#btn_ploy").before(txt);
					    }
				    	setLastUpdate();
				    	//$("#logdiv").prepend(log);
					}
			    });
				tempval = fieldvalue;
			}
			
			//显示打单策略类型选择项
			function showPloySelect(obj){
				var selectids = $("#ploytype").val();
				var ids = selectids.split(",");
				$("div.ploytype").removeClass("ploytype_select");
				for(var i=0;i<ids.length;i++){
					if(ids[i]!=""){
						$("#ployitem"+ids[i]).addClass("ploytype_select");
					}
				}
				var _left = $(obj).position().left;
				if($("#leftdiv").width()<_left+$("#ployselect").width()){
					_left = $("#leftdiv").width()-$("#ployselect").width()-20;
				}
				var _top = $(obj).position().top + $(obj).height()+5;
				$("#ployselect").css({"top":_top,"left":_left}).show();
			}
			//修改打单策略类型
			function updatePloyType(){
				var selectids = "";
				var selectnames = "";
				$("div.ploytype_select").each(function(){
					selectids += "," + $(this).attr("_id");
					selectnames += "," + $(this).attr("_name");
				});
				if(selectids!=""){
					selectids = selectids+",";
					selectnames = selectnames.substring(1);
				}
				if(selectids!=$("#ploytype").val()){
					tempval = $("#ploytypeName").val();
					exeUpdate("ploytype",selectids,"str",selectnames);
				}
			}
			function cancelPloyType(){
				$("div.ployselect").hide();
			}
			//修改产品类型
			function setProductType(value){
				tempval = $("#producttype").val();
				exeUpdate("producttype",value,"num");
			}
			//修改销售类型
			function setSellType(value){
				var typestr = "";	
				if(value==1){
					$.post(
							"/CRM/sellchance/CheckType.jsp",
							{'customerId':<%=customerid%>,"sellchanceId":<%=sellchanceid%>}, 
							function(data){
								data=jQuery.trim(data);
								if(data=="false"){
									alert("此客户已存在进行中的终端客户商机！");
									return;
								}else{
									if(confirm("确定将商机类型更改为终端客户商机?")){
										tempval = "<%=selltype%>";
										exeUpdate("selltype",value,"num");
									}
								}
							}
					);
				}else{
					var confirmstr = "确定将商机类型更改为老客户二次商机?";
					if(value==3) confirmstr = "确定将商机类型更改为代理压货商机?";
					if(confirm(confirmstr)){
						tempval = "<%=selltype%>";
						exeUpdate("selltype",value,"num");
					}
				}
			}
			//修改商机状态
			function setEndStatus(value){
				var msgstr = "";
				var typestr = "";	
				if(value==0){
					typestr = "紧跟";
				}else if(value==1){
					typestr = "成功";
				}else if(value==2){
					typestr = "失败";
				}else if(value==3){
					typestr = "暂停";
				}else if(value==4){
					typestr = "培育";
				}
				if((value==1||value==2) && $("#td_fileids2").find("div.txtlink").length==0){
					msgstr += "未上传商机复盘文件\n";
					//alert("请上传商机复盘文件!");
					//return;
				}
				if(value==2){
					$("#endtatusdiv").hide();
					$("#failopptdiv").show();
					return;
				}
				if(confirm(msgstr+"确定将商机状态更改为"+typestr+"?")){
					tempval = "<%=endtatusid%>";
					exeUpdate("endtatusid",value,"num");
				}
			}
			function executeFail(){
				tempval = "<%=endtatusid%>";
				var itemname = $("#failopptid").find(":selected").text();
				var failopptid = $("#failopptid").val();
				var failopptname = "";
				if(itemname=="其他"){
					if($("#failopptname").val()=="<%=otherinfo[5]%>" || $("#failopptname").val()==""){
						alert("请填写其他友商名称");
						return;
					}
					failopptname = $("#failopptname").val();
				}else{
					failopptname = itemname;
				}
				exeUpdate("endtatusid",2,"num",failopptid,failopptname);
			}
			function cancelFail(){
				$("#endtatusdiv").show();
				$("#failopptdiv").hide();
			}
			function showName(){
				var itemname = $("#failopptid").find(":selected").text();
				if(itemname=="其他"){
					$("#failopptname").show();
				}else{
					$("#failopptname").hide();
				}
			}
			//修改是否已有OA商机合作
			function setHasChance(value){
				var _oldvalue = $("#haschance").val();
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_relchance","updatetype":1,"newvalue":filter(encodeURI(value)),"sellchanceid":<%=sellchanceid%>,"oldvalue":filter(encodeURI(_oldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	$("#haschance").val(value);
				    	if(value=="有"){
							$("#relchancediv").show();
							$("#haschance1").addClass("sdlink");
							$("#haschance0").removeClass("sdlink");
					    }else{
					    	$("#relchancediv").hide();
					    	$("#haschance1").removeClass("sdlink");
							$("#haschance0").addClass("sdlink");
						}
				    	setLastUpdate();
					}
			    });
			}
			function onShowSellChance(){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/sellchance/SellChanceBrowser.jsp");
			    if (datas) {
				    var _newvalue = datas.id;
			    	var _oldvalue = $("#chancename").val();
				    if(_newvalue!=_oldvalue){
					    if(_newvalue=="") _newvalue = "0";
				    	$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    data:{"operation":"edit_sellchance_relchance","updatetype":2,"newvalue":filter(encodeURI(_newvalue)),"sellchanceid":<%=sellchanceid%>,"oldvalue":filter(encodeURI(_oldvalue)),"newvalue_":filter(encodeURI(datas.name))}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
						    	$("#chanceid").val(datas.id);
						    	$("#chancename").val(datas.name);
						    	$("#chanceSpan").html("<a href=javascript:openFullWindowHaveBar('/CRM/manage/sellchance/SellChanceView.jsp?id="+datas.id+"')>"+datas.name+"</a>");
						    	setLastUpdate();
							}
					    });
					}
			    }
			}
			//调整商机阶段
			function setSellStatus(value,title){
				var msgstr = "";
				<%if(selltype.equals("1")){%>
						var _val = parseInt(value);
						if(_val>1){
							if($("#apply_table").find("textarea.input_blur").length==$("#apply_table").find("textarea").length){
								msgstr += "未填写客户方关键需求分析\n";
								//alert("请填写客户方关键需求分析！");
								//return;
							}
							if($("#match_table").find("textarea.input_blur").length==$("#match_table").find("textarea").length){
								msgstr += "未填写我方的竞争优劣势分析\n";
								//alert("请填写我方的竞争优劣势分析！");
								//return;
							}
							if($("#oppt_table").find("textarea.input_blur").length==$("#oppt_table").find("textarea").length){
								msgstr += "未填写友商的竞争优劣势分析\n";
								//alert("请填写友商的竞争优劣势分析！");
								//return;
							}
							if($("#info_table").find("textarea.input_blur").length==$("#info_table").find("textarea").length){
								msgstr += "未填写客户方信息化情况\n";
								//alert("请填写客户方信息化情况！");
								//return;
							}
							//if($("#res_table").find("textarea.input_blur").length==$("#res_table").find("textarea").length){
							//	alert("请填写外围资源关系情况！");
							//	return;
							//}
						}
						<%if(contact.equals("0")){%>
							msgstr += parent.checkss(_val);
							//if(!parent.checkss(_val)){
							//	return;
							//}
						<%}else{%>
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
								//return;
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
								//return;
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
								//return;
							}
						}
						<%}%>
						//检测标书合同是否关联
						if(_val>6){//正式系统中没有ID为5的
							if($("#td_fileids3").find("div.txtlink").length==0){
								msgstr += "未上传客户报价书或者合同书\n";
								//alert("请上传客户报价书或者合同书！");
								//return;
							}
						}
				<%}%>
				if(confirm(msgstr+"确定将商机阶段更改为"+title+"?")){
					tempval = "";
					exeUpdate("sellstatusid",value,"num");
				}
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

			function checkval(){
				var _val = $("#probability").val();
				if(parseInt(_val)>100 || parseInt(_val)<0){
					$("#probability").val("");
				}
			}

			//明细输入框保存方法
			function doUpdateDetail(obj){
				var fieldvalue = $(obj).val();
				_reltitle = $(obj).attr("_item");
				if(fieldvalue==tempval) return;
				if($(obj).hasClass("ployinput") && ($.trim(fieldvalue)=="应对策略" || $.trim(fieldvalue)=="")){
					$(obj).val("应对策略");
					$(obj).addClass("input_blur");
					if(tempval=="应对策略") return;
				}
				var _oldvalue = tempval;
				if($(obj).hasClass("ployinput") && $.trim(_oldvalue)=="应对策略"){
					_oldvalue = "";
				}
				
				var _type = $(obj).attr("_type");
				var _relid = $(obj).attr("_relid");
				var _batchid = getVal($(obj).attr("_batchid"));
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_detail","relid":_relid,"batchid":_batchid,"reltitle":filter(encodeURI(_reltitle)),"sellchanceid":<%=sellchanceid%>,"type":_type,"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	if($(obj).hasClass("ployinput")){
				    		$(obj).parent().attr("title","应对策略:"+$(obj).val());
					    }
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			//其他信息输入框保存方法
			function doUpdateOther(obj){
				var fieldvalue = $(obj).val();
				if(fieldvalue==tempval) return;
				var _setid = $(obj).attr("_setid");
				var _type = $(obj).attr("_type");
				var _item = $(obj).attr("_item");
				var _index = $(obj).attr("_index");
				var _batchid = getVal($(obj).attr("_batchid"));
				var _oldvalue = tempval;
				if($.trim(fieldvalue)=="" && tempval!=otherinfomap.get("otherinfo"+_index)){
					$(obj).val(tempval);
					return;
				}
				if($.trim(fieldvalue)==otherinfomap.get("otherinfo"+_index) || $.trim(fieldvalue)==""){
					$(obj).val(otherinfomap.get("otherinfo"+_index));
					$(obj).addClass("input_blur");
					if(tempval==otherinfomap.get("otherinfo"+_index)) return;
				}
				if(_oldvalue == otherinfomap.get("otherinfo"+_index)){
					_oldvalue = "";
				}
				
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_sellchance_other","setid":_setid,"batchid":_batchid,"index":_index,"sellchanceid":<%=sellchanceid%>,"type":_type,"item":filter(encodeURI(_item)),"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			//友商名称输入框保存方法
			function doUpdateOpptname(obj){
				var fieldvalue = $(obj).val();
				if(fieldvalue==tempval) return;
				var _batchid = $(obj).attr("_batchid");
				var _index = $(obj).attr("_index");
				if($.trim(fieldvalue)==otherinfomap.get("otherinfo"+_index) || $.trim(fieldvalue)==""){
					$(obj).val(otherinfomap.get("otherinfo"+_index));
					$(obj).addClass("input_blur");
					if(tempval==otherinfomap.get("otherinfo"+_index)) return;
				}
				var _oldvalue = tempval;
				if(_oldvalue == otherinfomap.get("otherinfo"+_index)){
					_oldvalue = "";
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_opptname","batchid":_batchid,"sellchanceid":<%=sellchanceid%>,"oldvalue":filter(encodeURI(_oldvalue)),"newvalue":filter(encodeURI(fieldvalue))}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
					    var txt = $.trim(data.responseText);
					    var log = txt;
				    	setLastUpdate();
					}
			    });
			}
			function onShowAgent(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25,19)");
			    if (datas) {
				    if(datas.id!=""){
					    doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			function onShowResource(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
			    if (datas) {
			    	if(datas.id!=""){
			    		doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			function onShowSource(fieldname) {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	doSelectUpdate(fieldname,datas.id,datas.name);
					}
			    }
			}
			
			function doAddProduct(){
				var _status = $("#btn_product").attr("_status");
				if(_status==1){
					$("#product_add").show();
					$("#btn_product").attr("_status","0").html("取消");
				}else{
					delProduct("");
					$("#btn_product").attr("_status","1").html("新增");
				}
			}
			function delProduct(redid,obj){
				if(redid==""){
					$("#product_add").hide();
				}else{
					if(confirm("确定删除产品明细？")){
						var newvalue = $("#productidSpan_"+redid).find("a").html();
						$(obj).css("background","url('../images/loading2_wev8.gif') center no-repeat").unbind("click");
						$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    data:{"operation":"del_product_detail","sellchanceid":<%=sellchanceid%>
				    			,"redid":redid,"newvalue":filter(encodeURI(newvalue))
					    	}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    $("#product_"+redid).remove();
						    	setLastUpdate();
							}
					    });
					}
				}
			}
			
			function onShowProduct(redid){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp");
			    if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
				    	var salenum = "1";
				    	var oldname = "";
				    	if(redid!=""){
				    		$("#productid_"+redid).val(datas.id);
					    	$("#productidSpan_"+redid).html("<a href='/lgc/asset/LgcAsset.jsp?paraid="+datas.id+"' target='_blank'>"+$.trim(datas.name)+"</a>");
					    	$("#assetunitid_"+redid).val(datas.other1);
					    	$("#assetunitidSpan_"+redid).html(datas.other2);
					    	$("#currencyid_"+redid).val(datas.other3);
					    	$("#currencyidSpan_"+redid).html(datas.other4);
					    	$("#salesprice_"+redid).val(datas.other5);
					    	var salesprice = eval(toFloat(datas.other5,0));
					    	salenum = eval(toFloat($("#salesnum_"+redid).val(),0));
					        var totelprice = toFloat(salesprice) * toFloat(salenum);
					    	$("#totelprice_"+redid).html(toPrecision(totelprice,4));
					    	oldname = $("#productidSpan_"+redid).find("a").html();
					    }

				    	$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    data:{"operation":"edit_product_detail","sellchanceid":<%=sellchanceid%>
				    			,"redid":redid
				    			,"productid":datas.id,"assetunitid":datas.other1,"currencyid":datas.other3,"salesprice":datas.other5,"salesnum":salenum
				    			,"oldvalue":filter(encodeURI(oldname)),"newvalue":filter(encodeURI($.trim(datas.name)))
					    	}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    if(redid==""){
							    	$("#product_add").before(txt).hide();
							    	$("#btn_product").click();
								}
						    	setLastUpdate();
							}
					    });
			    	}
			    }
			}
			function onShowCurrency(redid){
				var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp");
			    if (datas) {
			    	if(datas.id!="" && datas.id!="0"){
					    if($("#currencyid_"+redid).val()!=datas.id){
					    	tempval = $("#currencyidSpan_"+redid).html();
					    	$("#currencyid_"+redid).val(datas.id);
						    $("#currencyidSpan_"+redid).html(datas.name);
					    	doUpdatePro(fieldname,datas.id,redid,datas.name);
						}
			    	}
			    }
			}
			function doUpdatePro(fieldname,fieldvalue,redid,newvalue,totalvalue){
				var _totalvalue = getVal(totalvalue);
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_product_field","sellchanceid":<%=sellchanceid%>
		    			,"redid":redid
		    			,"fieldname":fieldname,"fieldvalue":fieldvalue,"totalvalue":_totalvalue
		    			,"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(newvalue))
			    	}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				    	setLastUpdate();
					}
			    });
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
				restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
				restr += "<div style='float: left;'>";
					
				if(fieldname=="manager"){
					restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
				}else if(fieldname=="agent"){
					restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
				}else if(fieldname=="source"){
					restr += name;
				}
				
				restr +="</div>";
				if(fieldname=="source"||fieldname=="agent")
				restr += "<div class='btn_del' onclick=\"doDelItem('"+delname+"','"+id+"')\"></div>"
					   + "<div class='btn_wh'></div>";
				restr += "</div>";
				return restr;
			}
			<%}%>

			<%if(contact.equals("0")){%>
			$(document).bind("contextmenu",function(e){
				var evt = e?e:(window.event?window.event:null);
				parent.showRightClickMenu2(e,evt.clientX,evt.clientY,<%=sellchanceid%>);
				evt.cancelBubble = true;
				evt.returnValue = false; 
				return false;
			});
			//document.oncontextmenu = parent.showRightClickMenu;
			document.body.onclick = parent.hideRightClickMenu;
			<%}%>
		</script>
	</body>
</html>
<%@ include file="/CRM/manage/util/uploader.jsp" %>
