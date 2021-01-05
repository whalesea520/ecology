
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="ContactWayComInfo" class="weaver.crm.Maint.ContactWayComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%@ include file="/common/swfupload/uploader.jsp" %>
<%
	String userid = user.getUID()+"";
	String CustomerID = Util.null2String(request.getParameter("CustomerID"));
	String manager = userid;
	String agent = "";
	String source = "";
	if(!CustomerID.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
		if(!rs.next()){
			response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
			return;
		}
		//判断是否有新建该客户商机权限
		if(rs.getInt("status")==7 || rs.getInt("status")==8){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		int sharelevel = CrmShareBase.getRightLevelForCRM(userid,CustomerID);
		if(sharelevel<2){
			response.sendRedirect("/notice/noright.jsp") ;
			return;
		}
		manager = Util.null2String(rs.getString("manager"));
		agent = Util.null2String(rs.getString("agent"));
		source = Util.null2String(rs.getString("source"));
	}
	
	String mainId = "";
	String subId = "";
	String secId = "";
	String maxsize = "";
	boolean hasPath = false;
	rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (111,222,333) order by id "); 
	while(rs.next()){
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
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>新建销售商机</title>
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.widget_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker_wev8.js"></script>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all_wev8.css" />
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
			*{font-size: 12px;font-family: Arial,'宋体';outline:none;}
			.clickRightMenu{position: absolute;}
			
			.item_title{width: auto;height: 20px;font-size: 14px;font-weight: bold;margin-left: 4px;}
			.item_table{width: 100%;}
			.item_table td{line-height: 30px;padding-left: 8px;}
			.item_table td.title{background: #F6F6F6;}
			
			.item_line{width: 100%;height: 2px;font-size: 0px;}
			.item_icon1,.item_line1{background: #5A95D1}
			
			.item_input{width: 90%;height: 26px;border: 1px #CCCCCC solid;border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;}
			.item_input_focus{border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;}
			.btn_browser{width:25px;height:22px;float: left;margin-left: 0px;margin-top: 2px;cursor: pointer;
				background: url('../images/btn_browser_wev8.png') center no-repeat !important;}
			.txt_browser{width:auto;line-height:22px;float: left;margin-left: 4px;margin-top: 2px;}
			
			.item_select{position: absolute;display: none;overflow: hidden;background: #F0F0FF;}
			.item_option{line-height: 24px;padding-left: 5px;padding-right: 5px;cursor: pointer;}
			.item_option_hover{background: #0000FF;color: #fff;}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			input{line-height: 180%;}
		</style>
		<![endif]-->
	</head>
	<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top}";
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form id="weaver" name="weaver" action="Operation.jsp" method="post">
		<input type="hidden" name="operation" value="add_sellchance"/>
		<table style="width: 100%;height: 100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="center">
					<div style="width: 98%;height: 100%;margin: 0px auto;text-align: left;">
						<div style="width: 100%;height: 28px;border: 1px #CCCCCC solid;margin-top: 4px;background: url('../images/title_bg_wev8.gif') repeat-x;">
							<div style="line-height: 28px;margin-left: 10px;font-weight: bold;">销售商机</div>
						</div>
						
						<div style="width: 100%;">
							<table style="width: 100%;margin-top: 20px;" cellpadding="0" cellspacing="0" border="0">
								<colgroup><col width="7px"/><col width="6px"/><col width="*"/></colgroup>
								<tr>
									<td class="item_icon1"></td>
									<td></td>
									<td>
										<div class="item_title item_title1">基本信息</div>
										<div class="item_line item_line1"></div>
										<table class="item_table" cellpadding="0" cellspacing="0" border="0">
											<colgroup><col width="15%"/><col width="35%"/><col width="15%"/><col width="35%"/></colgroup>
											<tr>
												<td class="title">商机名称</td>
												<td>
													<input type="text" class="item_input" name="subject" onchange="checkinput('subject','subjectImage')"/>
													<span id="subjectImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												</td>
												<td class="title">销售预期</td>
												<td>
													<input type="text" class="item_input" style="width: 100px;cursor: pointer;" id="preselldate" name="preselldate" readonly="readonly"/>
													<span id="preselldateImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												</td>
											</tr>
											<tr>
												<td class="title">客户名称</td>
												<td>
													<div class="btn_browser" onclick="onShowCRM()"></div>
													<div class="txt_browser" id="customerSpan"><%if(!CustomerID.equals("")){%><%=cmutil.getCustomer(CustomerID)%><%}else{%><img src="/images/BacoError_wev8.gif" align=absMiddle style="margin-top: 4px;"/><%} %></div>
													<input type="hidden" id="customer" name="customer" value="<%=CustomerID %>"/>
												</td>
												<td class="title">预期收益</td>
												<td>
													<input type="text" class="item_input" style="width: 100px;" id="preyield" name="preyield" onkeypress="ItemNum_KeyPress()" onblur="checknumber('preyield');checkinput('preyield','preyieldImage')"/>万
													<span id="preyieldImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												</td>
											</tr>
											<tr>
												<td class="title">客户经理</td>
												<td>
													<div class="btn_browser" onclick="onShowHrm()"></div>
													<div class="txt_browser" id="createrSpan"><%=cmutil.getHrm(manager) %></div>
													<input type="hidden" id="creater" name="creater" value="<%=manager %>"/>
												</td>
												<td class="title">可能性</td>
												<td>
													<input type="text" class="item_input" style="width: 100px;" maxlength="3" id="probability" name="probability" onkeypress="ItemNum_KeyPress()" onblur="checknumber('probability');checkval();checkinput('probability','probabilityImage');"/>%
													<span id="probabilityImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
												</td>
											</tr>
											<tr>
												<td class="title">中介机构</td>
												<td>
													<div class="btn_browser" onclick="onShowAgent()"></div>
													<div class="txt_browser" id="agentSpan"><%=cmutil.getCustomer(agent) %></div>
													<input type="hidden" id="agent" name="agent" value="<%=agent %>"/>
												</td>
												<td class="title">启动项目原因及关键需求</td>
												<td>
													<%if(hasPath){ %>
														<div id="uploadDiv" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
													<%}else{ %>
														<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
													<%} %>
												</td>
											</tr>
											<tr>
												<td class="title">商机来源</td>
												<td>
													<div class="btn_browser" onclick="onShowSource()"></div>
													<div class="txt_browser" id="sourceSpan"><%=ContactWayComInfo.getContactWayname(source) %></div>
													<input type="hidden" id="source" name="source" value="<%=source %>"/>
												</td>
												<td class="title" rowspan="3">成功关键因素(风险)</td>
												<td rowspan="3"><textarea name="remark" class="item_input" style="height: 70px"></textarea></td>
											</tr>
											<tr>
												<td class="title">商机类型</td>
												<td>
													<select id="selltype" name="selltype">
														<option value="1">新签</option>
														<option value="2">二次</option>
													</select>
												</td>
											</tr>
											<tr>
												<td class="title">商机状态</td>
												<td>
													进行中
												</td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</div>
					</div>
				</td>
			</tr>
		</table>
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
		</form>
		<script type="text/javascript">
			$(document).ready(function(){
				//日期控件
				$.datepicker.setDefaults( {
					"dateFormat": "yy-mm-dd",
					"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
					"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
					"changeMonth": true,
					"changeYear": true} );
				$("#preselldate").datepicker({
					"onSelect":function(){
						var preselldate = $("#preselldate").val();
						if(preselldate==""){
							$("#preselldateImage").show();
						}else{
							$("#preselldateImage").hide();
						}
					}
				});

				$(".item_input").bind("focus",function(){
					$(this).addClass("item_input_focus");
					if(this.id=="preyield"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						$("#pre_select").css({"top":_top,"left":_left}).show();
					}
					if(this.id=="probability"){
						var _top = $(this).offset().top + 26;
						var _left = $(this).offset().left;
						$("#pro_select").css({"top":_top,"left":_left}).show();
					}
				}).bind("blur",function(){
					$(this).removeClass("item_input_focus");
				});

				$("div.item_option").bind("mouseover",function(){
					$(this).addClass("item_option_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("item_option_hover");
				}).bind("click",function(){
					$("#"+$(this).parent().attr("_inputid")).val($(this).attr("_val"));
					$("#"+$(this).parent().attr("_inputid")+"Image").html("");
				});

				$(document).bind("click",function(e){
					var target=$.event.fix(e).target;
					if($(target).attr("id")!="pre_select" && $(target).attr("id")!="preyield"){
						$("#pre_select").hide();
					}
					if($(target).attr("id")!="pro_select" && $(target).attr("id")!="probability"){
						$("#pro_select").hide();
					}
				});

				<%if(hasPath){%>
					bindUploaderDiv(jQuery("#uploadDiv"),"newrelatedacc");
				<%}%>
			});

			function doSave(obj){
				if(check_form(document.weaver,'subject,customer,creater,preselldate,preyield,probability')){
					var selltype = jQuery("#selltype").val();
					if(selltype==1){
						$.post(
								"/CRM/sellchance/CheckType.jsp",
								{'customerId':jQuery("#customer").val()}, 
								function(data){
									data=jQuery.trim(data);
									if(data=="false"){
										alert("此客户已存在进行中的新签销售机会！");
										return;
									}else{
										obj.disabled=true;
										$("#weaver").submit();
									}
								}
						);
					}else{
						obj.disabled=true;
						$("#weaver").submit();
					}
				}
			}
			function doCancel(){
				if(confirm("确定取消新建商机？")){
					window.close();
				}
			}

			function checkval(){
				var _val = $("#probability").val();
				if(parseInt(_val)>100 || parseInt(_val)<0){
					$("#probability").val("");
				}
			}
			function onShowCRM() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/sellchance/manage/util/CustomerBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	$("#customer").val(datas.id);
					    $("#customerSpan").html(datas.name);
					    $("#creater").val(datas.manager);
					    $("#createrSpan").html("<a href='/hrm/resource/HrmResource.jsp?id="+datas.manager+"' target='_blank'>"+datas.managername+"</a>");
					    $("#agent").val(datas.agent);
					    $("#agentSpan").html("<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+datas.agent+"'>"+datas.agentname+"</a>");
					    $("#source").val(datas.source);
					    $("#sourceSpan").html(datas.sourcename);
					}else{
						$("#customer").val("");
					    $("#customerSpan").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
					    $("#creater").val("<%=userid%>");
					    $("#createrSpan").html("<%=cmutil.getHrm(userid)%>");
					    $("#agent").val("");
					    $("#agentSpan").html("");
					    $("#source").val("");
					    $("#sourceSpan").html("");
					}
			    }
			}
			function onShowAgent() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)");
			    if (datas) {
				    if(datas.id!=""){
				    	$("#agent").val(datas.id);
					    $("#agentSpan").html(datas.name);
					}else{
						$("#agent").val("");
					    $("#agentSpan").html("");
					}
			    }
			}
			function onShowHrm() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
			    if (datas) {
			    	if(datas.id!=""){
				    	$("#creater").val(datas.id);
					    $("#createrSpan").html(datas.name);
					}else{
						$("#creater").val("");
					    $("#createrSpan").html("<img src='/images/BacoError_wev8.gif' align=absMiddle style='margin-top:4px;'/>");
					}
			    }
			}
			function onShowSource() {
			    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/Maint/ContactWayBrowser.jsp");
			    if (datas) {
				    if(datas.id!=""){
				    	$("#source").val(datas.id);
					    $("#sourceSpan").html(datas.name);
					}else{
						$("#source").val("");
					    $("#sourceSpan").html("");
					}
			    }
			}


			function check_form(thiswins,items)
			{
				var isconn = false;
				try {
					var xmlhttp;
				    if (window.XMLHttpRequest) {
				    	xmlhttp = new XMLHttpRequest();
				    }  
				    else if (window.ActiveXObject) {
				    	xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
				    }
				    var URL = "/systeminfo/CheckConn.jsp?userid=<%=user.getUID()%>&time="+new Date();
				    xmlhttp.open("GET",URL, false);
				    xmlhttp.send(null);
				    var result = xmlhttp.status;
				    if(result==200) {
					    isconn = true;
				    	var response_flag = xmlhttp.responseText;
				    	if(response_flag!='0') {
				    		var flag_msg = '';
				    		if(response_flag=='1') {
				    			var diag = new Dialog();
								diag.Width = 300;
								diag.Height = 180;
								diag.ShowCloseButton=false;
								diag.Title = "<%=SystemEnv.getHtmlLabelName(26263,user.getLanguage())%>";
								diag.URL = "/wui/theme/ecology7/page/loginSmall.jsp?username=<%=user.getLoginid()%>";
								diag.show();
						        return false;
				    		}
				    		else if(response_flag=='2') {
				    			flag_msg = '<%=SystemEnv.getHtmlLabelName(21403,user.getLanguage())%>';
				    		}
				    		if(response_flag=='3') {
				    			flag_msg = '<%=SystemEnv.getHtmlLabelName(23670,user.getLanguage())%>';
				   
				    			return false;
				    		}
				    		flag_msg += '\r\n\r\n<%=SystemEnv.getHtmlLabelName(21791,user.getLanguage())%>';
				        	return confirm(flag_msg);
				        }
				    }
				    xmlhttp = null;

				    <%if(new weaver.conn.RecordSet().getDBType().equals("oracle")){%>
				    try {
					    var lenck = true;
					    var tempfieldvlaue = document.getElementById("htmlfieldids").value;
					    while(true) {
						    var tempfield = tempfieldvlaue.substring(0, tempfieldvlaue.indexOf(","));
						    tempfieldvlaue = tempfieldvlaue.substring(tempfieldvlaue.indexOf(",")+1);
						    var fieldid = tempfield.substring(0, tempfield.indexOf(";"));
						    var fieldname = tempfield.substring(tempfield.indexOf(";")+1);
						    if(fieldname=='') break;
						    if(!checkLengthOnly(fieldid,'4000',fieldname,'<%=SystemEnv.getHtmlLabelName(524,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')) {
							    lenck = false;
							    break;
						    }
					    }
					    if(lenck==false) return false;
				    }
				    catch(e) {}
				    <%}%>
				}
				catch(e) {
					return check_conn();
				}
				if(!isconn)
					return check_conn();
				
				thiswin = thiswins
				items = ","+items + ",";
				
				var tempfieldvlaue1 = "";
				try{
					tempfieldvlaue1 = document.getElementById("htmlfieldids").value;
				}catch (e) {
				}

				for(i=1;i<=thiswin.length;i++){
					tmpname = thiswin.elements[i-1].name;
					tmpvalue = thiswin.elements[i-1].value;
				    if(tmpvalue==null){
				        continue;
				    }

					if(tmpname!="" && items.indexOf(","+tmpname+",")!=-1){
						if(tempfieldvlaue1.indexOf(tmpname+";") == -1){
							while(tmpvalue.indexOf(" ") >= 0){
								tmpvalue = tmpvalue.replace(" ", "");
							}
							while(tmpvalue.indexOf("\r\n") >= 0){
								tmpvalue = tmpvalue.replace("\r\n", "");
							}

							if(tmpvalue == ""){
								if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
									alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
									return false;
								}else{
									alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>!");
									return false;
								}
							}
						} else {
							var divttt=document.createElement("div");
							divttt.innerHTML = tmpvalue;
							var tmpvaluettt = jQuery.trim(jQuery(divttt).text());
							if(tmpvaluettt == ""){
								if(thiswin.elements[i-1].getAttribute("temptitle")!=null){
									alert("\""+thiswin.elements[i-1].getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
									return false;
								}else{
									alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>!");
									return false;
								}
							}
						}
					}
				}
				return true;
			}
		</script>
	</body>
</html>
