<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.conn.RecordSet" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		
	</HEAD>
	<%
	    String customerid = Util.null2String(request.getParameter("CustomerID"));
	    rs.executeProc("CRM_CustomerInfo_SelectByID", customerid);
	    if (rs.getCounts() <= 0) {
	        response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	        return;
	    }
	    rs.first();
	    
	    String customerName = Util.null2String(rs.getString("name"));//后期通过客户id得到客户名称
	    String businessInfoData = "";
	    String url = "";
	    //查询应用设置
	    String isopen = "0";
	    String cacheday = "0";
	    String isCache = "0";
	    String serviceurl = "";
	    String appkey = "";
	    String crmtype = "";
        RecordSet brs = new RecordSet();
        brs.executeSql("select * from crm_busniessinfosettings where id  = 1 ");
        if(brs.first()) 
            isopen = Util.null2String(brs.getString("isopen"));
            isCache = Util.null2String(brs.getString("iscache"));
            cacheday = Util.null2String(brs.getString("cacheday"));
            serviceurl = Util.null2String(brs.getString("serviceurl"));
            appkey = Util.null2String(brs.getString("appkey"));
            crmtype = Util.null2String(brs.getString("crmtype"));
        if("1".equals(isopen)) {//开启了
        	List a = Util.TokenizerString(crmtype,",");
        	if(!a.contains(Util.null2String(rs.getString("type")))){
                response.sendRedirect("CRMBusinessInfoMsg.jsp?msg="+130765);
            }
            String currentDate = TimeUtil.getCurrentDateString();//当前日期
            String sDate = TimeUtil.dateAdd(currentDate,-Integer.parseInt(cacheday));//当前日期-缓存天数=缓存开始日期
            //默认从缓存表查询数据，如果没有数据，则调接口，同时把数据保存到缓存表中（用缓存日期过滤）
            brs.executeSql("select * from crm_busniessinfoeache where crmname='"+customerName+"' and modifydate>='"+sDate+"'");
           	if(brs.first()) {
				businessInfoData =  Util.null2String(brs.getString("data"));
			}else {//缓存里没有
				url = serviceurl+"?appkey="+appkey+"&keyword="+customerName;
			}
        } else {
            response.sendRedirect("CRMBusinessInfoMsg.jsp?msg="+130766);
        }  
       
	%>

	<BODY id="body1">
		<FORM >
			<input type="hidden" id= "customerid" name="" value="<%=customerName %>">
			<input type="hidden" id= "qxbUrl" name="" value="<%=url %>">
		</FORM>
		<div id="mainid" style="display:none;">
		<table id="main" style="width: 100%; height: 100%; overflowX: hidden"
			cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center" valign="top">
					<div
						style="width: 100%; height: 100%; margin: 0px auto; text-align: left;">
						<div id="baseinfo"
							style="width: 100%; height: auto; overflow: hidden;">
							<table style="width: 100%;" cellpadding="0" cellspacing="0"
								border="0">
								<tr>
									<td valign="top" width="*">
										<div id="leftdiv"
											style="width: 100%; margin-top: 0px; overflow: hidden; position: relative;"
											class="scroll1 content_2">
											<div id="leftinfo" class="scroll1"
												style="width: 100%; height: 100%; position: relative; overflow: auto;">
												<!-- 基本信息开始 -->
												<table style="width: 100%; height: auto; margin-top: 0px;"
													cellpadding="0" cellspacing="0" border="0">
													<colgroup>
														<col width="0px" />
														<col width="0px" />
														<col width="*" />
													</colgroup>
													<tr>
														<td valign="top">
															<!-- 一般信息开始 -->
															<wea:layout type="2col">
	
																<wea:group context='<%=SystemEnv.getHtmlLabelName(81711,user.getLanguage()) %>'>
																	<wea:item><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="name"></div>
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(30976,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="econ_kind"></div>
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(20668,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="regist_capi"></div>
	
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="address"></div>
																		<div id=""></div>
	
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(130767,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="reg_no"></div>
																	</wea:item>
	
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(31031,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="scope"></div>
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(130768,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="term_start"></div>
	
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(130769,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="term_end"></div>
																	</wea:item>
	
																	<wea:item><%=SystemEnv.getHtmlLabelName(130770,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="belong_org"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="oper_name"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(27319,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="start_date"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130771,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="end_date"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130772,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="check_date"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130773,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="status"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130774,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="org_no"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130775,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="credit_no"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130776,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="province"></div>
																	</wea:item>
																	<wea:item><%=SystemEnv.getHtmlLabelName(130777,user.getLanguage())%></wea:item>
																	<wea:item>
																		<div id="id"></div>
																	</wea:item>
																</wea:group>
															</wea:layout>
															<wea:layout type="4col">
																<wea:group context='<%=SystemEnv.getHtmlLabelName(130761,user.getLanguage())%>'>
																	<wea:item attributes="{'colspan':'full'}">
																		<table id="reltable" class="rel_table ListStyle"
																			cellpadding="0" cellspacing="0" border="0">
																			<colgroup>
																				<col width="50%" />
																				<col width="50%" />
																			</colgroup>
																			<thead>
																				<tr class="HeaderForXtalbe">
																					<th>
																						<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>
																					</th>
																				</tr>
																			</thead>
																			<tbody id="employees">
	
																			</tbody>
																		</table>
																	</wea:item>
																</wea:group>
															</wea:layout>
															<wea:layout type="4col">
																<wea:group context='<%=SystemEnv.getHtmlLabelName(130762,user.getLanguage())%>'>
																	<wea:item attributes="{'colspan':'full'}">
																		<table id="reltable" class="rel_table ListStyle"
																			cellpadding="0" cellspacing="0" border="0">
																			<colgroup>
																				<col width="90%" />
																			</colgroup>
																			<thead>
																				<tr class="HeaderForXtalbe">
																					<th>
																						<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>
																					</th>
																				</tr>
																			</thead>
																			<tbody id="branches">
	
																			</tbody>
																		</table>
																	</wea:item>
																</wea:group>
															</wea:layout>
	                                                           <!-- 变更信息 -->
															<wea:layout type="4col">
																<wea:group context='<%=SystemEnv.getHtmlLabelName(130764,user.getLanguage())%>'>
																	<wea:item attributes="{'colspan':'full'}">
																		<table id="reltable" class="rel_table ListStyle"
																			cellpadding="0" cellspacing="0" border="0">
																			<colgroup>
																				<col width="25%" />
																				<col width="25%" />
																				<col width="25%" />
																				<col width="24%" />
																			</colgroup>
																			<thead>
																				<tr class="HeaderForXtalbe">
																					<th>
																						<%=SystemEnv.getHtmlLabelName(30284,user.getLanguage())%>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130778,user.getLanguage())%>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130779,user.getLanguage())%>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130781,user.getLanguage())%>
																					</th>
																				</tr>
																			</thead>
																			<tbody id="changerecords">
	
																			</tbody>
																		</table>
																	</wea:item>
																</wea:group>
															</wea:layout>
	                                                           <!-- 股东信息 -->
															<wea:layout type="4col">
																<wea:group context='<%=SystemEnv.getHtmlLabelName(27342,user.getLanguage()) %>'>
																	<wea:item attributes="{'colspan':'full'}">
																		<table id="reltable" class="rel_table ListStyle"
																			cellpadding="0" cellspacing="0" border="0">
																			<colgroup>
																				<col width="50%" />
																				<col width="49%" />
																			</colgroup>
																			<thead>
																				<tr class="HeaderForXtalbe">
																					<th>
																						<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
																					</th>
																				</tr>
																			</thead>
																			<tbody id="partners">
	
																			</tbody>
																			</table>
																	</wea:item>
																</wea:group>
															</wea:layout>
	
															<wea:layout type="4col">
																<wea:group context='<%=SystemEnv.getHtmlLabelName(130763,user.getLanguage()) %>'>
																	<wea:item attributes="{'colspan':'full'}">
																		<table id="reltable" class="rel_table ListStyle"
																			cellpadding="0" cellspacing="0" border="0">
																			<colgroup>
																				<col width="35%" />
																				<col width="20%" />
																				<col width="20%" />
																				<col width="24%" />
																			</colgroup>
																			<thead>
																				<tr class="HeaderForXtalbe">
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130784,user.getLanguage()) %>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130785,user.getLanguage()) %>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130786,user.getLanguage()) %>
																					</th>
																					<th>
																						<%=SystemEnv.getHtmlLabelName(130787,user.getLanguage()) %>
																					</th>
																				</tr>
																			</thead>
																			<tbody id="abnormal_items">
	
																			</tbody>
																		</table>
																	</wea:item>
																</wea:group>
															</wea:layout>
													</td>
												</tr>
											</table>
										</div>
									</td>
								</tr>
							</table>
						</div>
					</div>
	
				</td>
			</tr>
		</table>
	</div>
	<div id="disp" style="width:100%;position:absolute;top:20%;text-align:center;vertical-align:middle;display:none;">
        <img src="/images/ecology8/noright_wev8.png" width="162px" height="162px"/>
        <div style="color:rgb(255,187,14);" id="msg"></div>
    </div>
	<SCRIPT LANGUAGE="JavaScript">
	jQuery(document).ready(function(){
	    var url = '<%=url%>';
	    var businessInfoData = '<%=businessInfoData%>';
	    var isCache = '<%=isCache%>';
	    if(businessInfoData != '') {
	        getEacheData(businessInfoData);
	    }
	    if(url!='') {
	        getQxbData(url,isCache);
	    }
	})
	function getEacheData(businessInfoData) {
		$("#mainid").show();
		var models = eval("("+businessInfoData+")");
		$("#name").html(models.data.name);
		$("#econ_kind").html(models.data.econ_kind);
		$("#regist_capi").html(models.data.regist_capi);
		$("#address").html(models.data.address);
		$("#reg_no").html(models.data.reg_no);
		$("#scope").html(models.data.scope);
		$("#term_start").html(models.data.term_start);
		$("#term_end").html(models.data.term_end);
		$("#belong_org").html(models.data.belong_org);
		$("#oper_name").html(models.data.oper_name);
		$("#start_date").html(models.data.start_date);
		$("#end_date").html(models.data.end_date);
		$("#check_date").html(models.data.check_date);
		$("#status").html(models.data.status);
		$("#org_no").html(models.data.org_no);
		$("#credit_no").html(models.data.credit_no);
		$("#province").html(models.data.province);
		$("#id").html(models.data.id);
		var employees = models.data.employees;//主要人员
		if(employees!='') {
			var tbody = "";
			var employees = eval(employees);
			for(var e=0;e<employees.length;e++){
				var name = employees[e].name;
             	var job_title = employees[e].job_title;
             	var trs = "<tr class='DataLight'><td>" + name + "</td> <td>" + job_title + "</td></tr>";
             	tbody+=trs;
	       	}
           	$("#employees").append(tbody);
       	}else{
        	 $("#employees").append("<tr class='e8EmptyTR'><td colspan='2' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
        }
       	
	   	var branches = models.data.branches;//分支机构
		if(branches!='') {
	        var tbody = "";
	        var branches = eval(branches);
	        for(var b=0;b<branches.length;b++){
	          	var name = branches[b].name;
	          	var trs = "<tr class='DataLight'><td>" + name + "</td></tr>";
	          	tbody += trs;
	        }
	        $("#branches").append(tbody);
        }else{
        	 $("#branches").append("<tr class='e8EmptyTR'><td colspan='1' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
        }
	   
		var changerecords = models.data.changerecords;//变更信息
		if(changerecords!='') {
		var tbody = "";
		var changerecords = eval(changerecords);
       	for(var c=0;c<changerecords.length;c++){
            var change_item = changerecords[c].change_item;
            var change_date = changerecords[c].change_date;
            var before_content = changerecords[c].before_content;
            var after_content = changerecords[c].after_content;
                var trs = "";
               trs += "<tr class='DataLight'><td>" + change_item + "</td> <td>" + change_date + "</td><td>" + before_content + "</td> <td>" + after_content + "</td></tr>";
               tbody += trs;
           }
            $("#changerecords").append(tbody);
       	}else{
        	 $("#changerecords").append("<tr class='e8EmptyTR'><td colspan='4' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
        }
       	
       	
	   	var partners =  models.data.partners;//股东信息
		if(partners!='') {
			var tbody = "";
       		var partners = eval(partners);
           	for(var p=0;p<partners.length;p++) {
           	var name = partners[p].name;
           	var stock_type = partners[p].stock_type;
           	var trs = "";
               	trs += "<tr class='DataLight'><td>" + name + "</td> <td>" + stock_type + "</td></tr>";
               	tbody += trs;
           	}
           	$("#partners").append(tbody);
       	}else{
        	 $("#partners").append("<tr class='e8EmptyTR'><td colspan='2' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
        }
       	
	   	var abnormal_items =  models.data.abnormal_items;//经营信息
      	if(abnormal_items!='') {
      		var tbody = "";
      		var abnormal_items = eval(abnormal_items);
          	for(var ai=0;ai<abnormal_items.length;ai++) {
          		var in_reason = abnormal_items[ai].in_reason;  
          		var in_date = abnormal_items[ai].in_date;  
          		var out_reason = abnormal_items[ai].out_reason;  
          		var out_date = abnormal_items[ai].out_date; 
          		var trs = "";
               	trs += "<tr class='DataLight'><td>" + in_reason + "</td> <td>" + in_date + "</td><td>" + out_reason + "</td> <td>" + out_date + "</td></tr>";
               	tbody += trs; 
          	}
           	$("#abnormal_items").append(tbody);
      	}else{
        	 $("#abnormal_items").append("<tr class='e8EmptyTR'><td colspan='4' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
        }
      	requestLog('1');
	}
	
	
	function getQxbData(url,iscache) {
	    var ajax = $.ajax({
	        url : encodeURI(url),
	        data:'{}',
	        cache : false, 
	        async : true,
	        type : "GET",
	        dataType: "jsonp",
	        timeout:1000
	    });
		ajax.done(function(models){
			if(models.status==200) {
		        	$("#mainid").show();
		          	$("#name").html(models.data.name);
		          	$("#econ_kind").html(models.data.econ_kind);
		          	$("#regist_capi").html(models.data.regist_capi);
		          	$("#address").html(models.data.address);
		          	$("#reg_no").html(models.data.reg_no);
		          	$("#scope").html(models.data.scope);
		          	$("#term_start").html(models.data.term_start);
		          	$("#term_end").html(models.data.term_end);
		          	$("#belong_org").html(models.data.belong_org);
		          	$("#oper_name").html(models.data.oper_name);
		          	$("#start_date").html(models.data.start_date);
		          	$("#end_date").html(models.data.end_date);
		          	$("#check_date").html(models.data.check_date);
		          	$("#status").html(models.data.status);
		          	$("#org_no").html(models.data.org_no);
		          	$("#credit_no").html(models.data.credit_no);
		          	$("#province").html(models.data.province);
		          	$("#id").html(models.data.id);
		          	var employees = models.data.employees;//主要人员
					if(employees!='') {
						var tbody = "";
						var employees = eval(employees);
						for(var e=0;e<employees.length;e++){
							var name = employees[e].name;
			             	var job_title = employees[e].job_title;
			             	var trs = "<tr class='DataLight'><td>" + name + "</td> <td>" + job_title + "</td></tr>";
			             	tbody+=trs;
				       	}
			           	$("#employees").append(tbody);
			       	}else{
			        	 $("#employees").append("<tr class='e8EmptyTR'><td colspan='2' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
			        }
		       	
				   	var branches = models.data.branches;//分支机构
					if(branches!='') {
				        var tbody = "";
				        var branches = eval(branches);
				        for(var b=0;b<branches.length;b++){
				          	var name = branches[b].name;
				          	var trs = "";
				          	trs += "<tr class='DataLight'><td>" + name + "</td></tr>";
				          	tbody += trs;
				        }
				        $("#branches").append(tbody);
			        }else{
			        	 $("#branches").append("<tr class='e8EmptyTR'><td colspan='1' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
			        }
			   
					var changerecords = models.data.changerecords;//变更信息
					if(changerecords!='') {
					var tbody = "";
					var changerecords = eval(changerecords);
			           for(var c=0;c<changerecords.length;c++){
			            var change_item = changerecords[c].change_item;
			            var change_date = changerecords[c].change_date;
			            var before_content = changerecords[c].before_content;
			            var after_content = changerecords[c].after_content;
			                var trs = "";
			               trs += "<tr class='DataLight'><td>" + change_item + "</td> <td>" + change_date + "</td><td>" + before_content + "</td> <td>" + after_content + "</td></tr>";
			               tbody += trs;
			           }
			            $("#changerecords").append(tbody);
			       	}else{
			        	 $("#changerecords").append("<tr class='e8EmptyTR'><td colspan='4' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
			        }
		       	
				   	var partners =  models.data.partners;//股东信息
					if(partners!='') {
						var tbody = "";
			       		var partners = eval(partners);
			           	for(var p=0;p<partners.length;p++) {
			           	var name = partners[p].name;
			           	var stock_type = partners[p].stock_type;
			           	var trs = "";
			               	trs += "<tr class='DataLight'><td>" + name + "</td> <td>" + stock_type + "</td></tr>";
			               	tbody += trs;
			           	}
			           	$("#partners").append(tbody);
			       	}else{
			        	 $("#partners").append("<tr class='e8EmptyTR'><td colspan='2' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
			        }
		       	
			   		var abnormal_items =  models.data.abnormal_items;//经营信息
			      	if(abnormal_items!='') {
			      		var tbody = "";
			      		var abnormal_items = eval(abnormal_items);
			          	for(var ai=0;ai<abnormal_items.length;ai++) {
			          		var in_reason = abnormal_items[ai].in_reason;  
			          		var in_date = abnormal_items[ai].in_date;  
			          		var out_reason = abnormal_items[ai].out_reason;  
			          		var out_date = abnormal_items[ai].out_date; 
			          		var trs = "";
			               	trs += "<tr class='DataLight'><td>" + in_reason + "</td> <td>" + in_date + "</td><td>" + out_reason + "</td> <td>" + out_date + "</td></tr>";
			               	tbody += trs; 
			          	}
			           	$("#abnormal_items").append(tbody);
			      	}else{
			        	 $("#abnormal_items").append("<tr class='e8EmptyTR'><td colspan='4' style='text-align: center; height: 30px; color: rgb(0, 0, 0);'><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage()) %></td></tr>");
			        }
		            if(iscache==1) {//开启缓存时，保存工商信息到表CRM_BusniessInfoEache中
		                eacheData(JSON.stringify(models));//缓存
		            }
	            	requestLog('0');
				}else {
		           	$("#disp").css("display","");
		           	$("#msg").html(models.message);
				}
		});
		ajax.fail(function(){
			window.location.href="CRMBusinessInfoMsg.jsp?msg=130800";
		});
	}
	//缓存数据
	function eacheData(data) {
	   $.ajax({
		  type: 'POST',
		  url: '/CRM/Maint/CRMBusinessInfoSettingsOperation.jsp',
		  data: {"data":data,"method":"eacheData","crmname":"<%=customerName%>"}
	   });            
	}
	//记录日志
	function requestLog(requesttype) {
       $.ajax({
          type: 'POST',
          url: '/CRM/Maint/CRMBusinessInfoSettingsOperation.jsp',
          data: {"requesttype":requesttype,"method":"requestLog","crmid":"<%=customerid%>"}
       });            
    }
    
	</SCRIPT>
	<script type="text/javascript" src="/mobile/plugin/crm_new/js/jquery.1.7.2.min.js"></script>
	</BODY>
</HTML>
