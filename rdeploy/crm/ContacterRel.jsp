
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
	String customerid = Util.null2String(request.getParameter("customerid"));
	//System.out.println("customerid:"+customerid);
	boolean canedit = Util.null2String(request.getParameter("canedit")).equals("true")?true:false;
	if(!customerid.equals("0")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			return;
		}
		int sharelevel = CrmShareBase.getRightLevelForCRM(user.getUID()+"",customerid);
		//判断是否有查看该客户权限
		if(sharelevel<1){
			return;
		}
		
		//判断是否有编辑该客户权限
		if(sharelevel<2){
			canedit = false;
		}
		if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
			canedit = false;
		}
	}
	String contact = Util.null2String(request.getParameter("contact"));
	
	
	int _pagesize = 20;
	int _total = 0;//总数
	rs.executeSql("select count(id) from CRM_CustomerContacter where customerid="+customerid);
	if(rs.next()){
		_total = rs.getInt(1);
	}
	String sql = "select t2.id,t2.title,t2.firstname,t2.jobtitle,t2.lastname,t2.department,t2.email,t2.phoneoffice,t2.mobilephone,t2.projectrole,t2.attitude,t2.attention,t2.imcode"
			+ " from CRM_CustomerContacter t2 where t2.customerid="
			+ customerid + " order by t2.id";
	rs.executeSql(sql);
%>

<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/CRM/js/jquery.fuzzyquery.min_wev8.js"></script>
<script language="javascript" src="/CRM/js/util_wev8.js"></script>
<script language="javascript" src="/workrelate/js/relateoperate_wev8.js"></script>
<link rel="stylesheet" href="/CRM/css/Base1_wev8.css" />

<style>
td.p-l-0{padding-left:0px !important;}
#reltable td{padding-left:0px;}
.detailtable{
  table-layout: fixed;
}
.detailtable td{border-bottom:0px !important;}
.detailtable td.info{
  text-overflow: ellipsis;
  overflow: hidden;
  vertical-align: middle;
  white-space: nowrap;
}
.rel_input{width:120px;}

.c_del {
	width: 18px;
	text-align: center;
	line-height: 18px;
	height: 18px;
	cursor: pointer;
	float: left;
	margin-left:10px;
	background:url('/CRM/images/icon_cancel_wev8.png') no-repeat;
}

.c_del {
	background:url('/CRM/images/icon_cancel_a_wev8.png') no-repeat;
}
</style>

<div id="ct_select" class="select_div">
<%
	ContacterTitleComInfo.setTofirstRow();
	while(ContacterTitleComInfo.next()){
%>
	<div class="select_item" _val="<%=ContacterTitleComInfo.getContacterTitleid() %>"><%=ContacterTitleComInfo.getContacterTitlename() %></div>
<%  } %>
</div>

<table id="table_contacter" style="width:100%;" cellpadding="0" cellspacing="0" border="0">
	<colgroup>
		<%if(contact.equals("0")){%>
		<col width="0px" />
		<%}else{ %>
		<col width="6px" />
		<%} %>
		<col width="*" />
	</colgroup>
	<tr>
		<td></td>
		<td>
			<table id="reltable" class="rel_table ListStyle" cellpadding="0" cellspacing="0" border="0">
				
				<%while (rs.next()) {
				String contacterid = Util.null2String(rs.getString("id"));%>
				<tr id="tr_<%=contacterid%>" class="DataLight contacterTr">
					
					<td class="p-l-0">
						<table style="width:100%;" class="detailtable">
							<colgroup>
								<col width="30px" />
								<col width="135px" />
								<col width="30px" />
								<col width="135px" />
								<col width="30px" />
								<col width="135px" />
								<col width="50px" />
							</colgroup>
							<tr _contacterid="<%=contacterid%>">
								<td>姓名</td>
								<td class="info" title="姓名:<%=Util.toScreen(rs.getString("firstname"), user
									.getLanguage())%>">
									<%if (canedit) {%>
									<input _fieldname="firstname" _contacterid="<%=contacterid %>"
										class="rel_input" _def="姓名" _value="<%=Util.null2String(rs.getString("firstname")) %>"
										value="<%=Util.null2String(rs.getString("firstname")) %>" />
									<%} else {%>
										<a href="###"
										onclick="openFullWindowHaveBar('/CRM/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')"
										target="_self"> <%=Util.toScreen(rs.getString("firstname"), user.getLanguage())%> </a>
									<%}%>
								</td>
								
								<td>称呼</td>
								<td class="info"
									title="称呼:<%=Util.toScreen(ContacterTitleComInfo
									.getContacterTitlename(rs.getString("title")), user
									.getLanguage())%>">
									<%if (canedit) {%>
									<input _fieldname="title" _contacterid="<%=contacterid %>" readonly="readonly" _select="ct_select" _val="<%=Util.null2String(rs.getString("title")) %>"
										class="rel_input <%if (Util.null2String(rs.getString("title"))
										.equals("")) {%>input_blur<%}%>"
										_def="称呼"  _value="<%=Util.toScreen(ContacterTitleComInfo
											.getContacterTitlename(rs.getString("title")),
											user.getLanguage()) %>"
										value="<%=Util.null2String(rs.getString("title"))
										.equals("") ? "称呼" : Util.toScreen(ContacterTitleComInfo
												.getContacterTitlename(rs.getString("title")),
												user.getLanguage())%>" />
									<%} else {%>
									<%if (Util.null2String(rs.getString("title"))
										.equals("")) {%>
									<div class="input_blur">
										称呼
									</div>
									<%} else {%>
									<%=Util.toScreen(ContacterTitleComInfo.getContacterTitlename(rs.getString("title")), user.getLanguage())%>
									<%}%>
									<%}%>
								</td>
								
								<td>岗位</td>
								<td class="info" title="岗位:<%=Util.null2String(rs.getString("jobtitle"))%>">
									<%if (canedit) {%>
									<input _fieldname="jobtitle" _contacterid="<%=contacterid %>"
										class="rel_input <%if (Util.null2String(rs.getString("jobtitle")).equals("")) {%>input_blur<%}%>"
										_def="岗位" _value="<%=Util.null2String(rs.getString("jobtitle")) %>"
										value="<%=Util.null2String(rs.getString("jobtitle"))
										.equals("") ? "岗位" : Util.null2String(rs
										.getString("jobtitle"))%>" />
									<%} else {%>
									<%if (Util.null2String(rs.getString("jobtitle")).equals("")) {%>
									<div class="input_blur">
										岗位
									</div>
									<%} else {%>
									<%=Util.null2String(rs.getString("jobtitle"))%>
									<%}%>
									<%}%>
								</td>
								<%if(canedit){ %>
								<td rowspan="2">
									<div class="c_view" onclick="openFullWindowHaveBar('/CRM/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')" title="明细"></div>
									<div class="c_del" onclick="delContacter(this,'<%=contacterid %>')" title="删除"></div>
									<%if(contact.equals("0")&&false){ %>
									<div class="ci_add" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
									<%} %>
									<!-- <div class="c_del" onclick="delContacter('<%=contacterid %>')" title="删除"></div> -->
								</td>
								<%} %>
							</tr>
							
							<tr>
								<td>电话</td>
								<td class="info" title="电话:<%=Util.null2String(rs.getString("phoneoffice"))%>">
									<%if (canedit) {%>
									<input _fieldname="phoneoffice" _contacterid="<%=contacterid %>"
										class="rel_input <%if (Util.null2String(rs.getString("phoneoffice"))
										.equals("")) {%>input_blur<%}%>"
										_def="办公电话" _value="<%=Util.null2String(rs.getString("phoneoffice")) %>"
										value="<%=Util.null2String(rs.getString("phoneoffice"))
										.equals("") ? "办公电话" : Util.null2String(rs
										.getString("phoneoffice"))%>" />
									<%} else {%>
									<%if (Util.null2String(rs.getString("phoneoffice"))
										.equals("")) {%>
									<div class="input_blur">
										电话
									</div>
									<%} else {%>
									<%=Util.null2String(rs.getString("phoneoffice"))%>
									<%}%>
									<%}%>
								</td>
								
								<td>手机</td>
								<td class="info" title="手机:<%=Util.null2String(rs.getString("mobilephone"))%>">
									<%if (canedit) {%>
									<input _fieldname="mobilephone" _contacterid="<%=contacterid %>"
										class="rel_input <%if (Util.null2String(rs.getString("mobilephone"))
										.equals("")) {%>input_blur<%}%>"
										_def="移动电话" _value="<%=Util.null2String(rs.getString("mobilephone")) %>"
										value="<%=Util.null2String(rs.getString("mobilephone"))
										.equals("") ? "移动电话" : Util.null2String(rs
										.getString("mobilephone"))%>" />
									<%} else {%>
									<%if (Util.null2String(rs.getString("mobilephone"))
										.equals("")) {%>
									<div class="input_blur">
										手机
									</div>
									<%} else {%>
									<%=Util.null2String(rs.getString("mobilephone"))%>
									<%}%>
									<%}%>
								</td>
								
								<td>邮箱</td>
								<td class="info" title="邮箱:<%=Util.null2String(rs.getString("email"))%>">
									<%if (canedit) {%>
									<input _fieldname="email" _contacterid="<%=contacterid %>"
										class="rel_input <%if (Util.null2String(rs.getString("email")).equals("")) {%>input_blur<%}%>"
										_def="邮箱" _value="<%=Util.null2String(rs.getString("email")) %>"
										value="<%=Util.null2String(rs.getString("email"))
										.equals("") ? "邮箱" : Util.null2String(rs
										.getString("email"))%>" />
									<%} else {%>
									<%if (Util.null2String(rs.getString("email")).equals("")) {%>
									<div class="input_blur">
										邮箱
									</div>
									<%} else {%>
									<%=Util.toScreenToEdit(rs.getString("email"),user.getLanguage())%>
									<%}%>
									<%}%>
								</td>
							</tr>
					
						</table>
					</td>
					
				</tr>
				<%}%>
				<%if(canedit){ %>
				<!-- 快速新建联系人开始 -->
				<tr id="addContacter" style="display:<%=customerid.equals("0")?"":"none"%>;">
					
					<td class="p-l-0 e8Selected">
						<form id="quickaddform" name="quickaddform" action="/CRM/contacter/ContacterOperation.jsp" method=post target="quickaddframe">
						<input type="hidden" name="CustomerID" value="<%=customerid %>"/>
						<input type="hidden" name="quickadd" value="1"/>
						<input type="hidden" name="method" value="addContacter"/>
						<input type="hidden" name="Manager" value="<%=user.getUID()+"" %>"/>
						<input type="hidden" name="status" value="1"/>
						<input type="hidden" name="isneedcontact" value="1"/>
						<input type="hidden" name="Language" value="<%=user.getLanguage() %>"/>
						
						<table id="contacterList" style="width:100%;">
							<colgroup>
								<col width="30px" />
								<col width="135px" />
								<col width="30px" />
								<col width="135px" />
								<col width="30px" />
								<col width="135px" />
								<col width="50px" />
							</colgroup>
							<tbody>
							<tr _contacterid="2602" class="">
								
								<td>姓名</td>
								<td class="info">
									<input type="hidden" name="contacterid" value="0">
									<input id="FirstName" _fieldname="FirstName" name="FirstName" _contacterid="" onchange='checkinput("FirstName","FirstNameimage")'
										class="rel_input rel_input2 input_blur" _def="姓名" value="姓名"/>
									<span id=FirstNameimage><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
                              	</td>
								
								<td>称呼</td>
								<td class="info">
									<input _fieldname="title" name="" _contacterid="" _select="ct_select" readonly="readonly" 
										class="rel_input rel_input2 input_blur" _def="称呼" value="称呼"/>
									<span id="titleImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
									<input type="hidden" id="Title" name="Title" _def="称呼"/>
								</td>
								
								<td>岗位</td>
								<td class="info">
									<input id="JobTitle" _fieldname="JobTitle" name="JobTitle" _contacterid="" onchange="checkinput('JobTitle','JobTitleimage')"
										class="rel_input rel_input2 input_blur" _def="岗位" value="岗位"/>
									<span id="JobTitleimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
								</td>
								
								<td rowspan="2" nowrap="nowrap">
									<button id="quickreset" type="reset" style="display: none"/></button>
									<%if(!customerid.equals("0")){%>
							        <div class="btn_save"  onclick="saveContacter()"></div>
							        <div class="btn_cancel"  onclick="addContacter()"></div>
							        <%}%>
									<div id="contact_load" class="load" style="background-color: transparent;"></div>
								</td>
								
							</tr>
							
							<tr>
								<td>电话</td>
								<td class="info e8Selected">
									<input id="PhoneOffice" _fieldname="phoneoffice" name="PhoneOffice" _contacterid=""
									class="rel_input rel_input2 input_blur" _def="电话" value="电话" />
								</td>
								
								<td>手机</td>
								<td class="info">
									<input id="mobilephone" _fieldname="mobilephone" name="mobilephone" _contacterid=""
									class="rel_input rel_input2 input_blur" _def="手机" value="手机" />
								</td>
								
								<td class="">邮箱</td>
								<td class="info">
									<input id="CEmail" _fieldname="email" name="email" _contacterid=""
									class="rel_input rel_input2 input_blur" _def="邮箱" value="邮箱" />
								</td>
							</tr>	
						</table>
						</form>	
						<iframe id="quickaddframe" name="quickaddframe" style="display: none"></iframe>
					</td>
				
				<!-- 暂时关闭删除功能
				<form id="quickdelform" name="quickdelform" action="/CRM/data/ContacterOperation.jsp" method=post enctype="multipart/form-data" target="quickaddframe">
					<input type="hidden" id="ContacterID" name="ContacterID" value=""/>
					<input type="hidden" name="quickdel" value="1"/>
					<input type="hidden" name="method" value="delete"/>
				</form>
				 -->
				
				</tr>
				<!-- 快速新建联系人结束 -->
				<%} %>
			</table>
			<%if(_total>_pagesize&&false){ %>
			<div id="btnmore" style="cursor: pointer;width: 70px;height: 21px;line-height: 19px;margin-right: 0px;text-align: center;
				float: right;color: #696969;background: url('../images/morebg_wev8.png') top no-repeat;" 
				onclick="getMoreContacter(this)" _currentpage="1" _pagesize="<%=_pagesize %>" _total="<%=_total %>" _querysql="" 
				title="显示更多数据">更多</div>
			<%} %>	
		</td>
	</tr>
</table>
<%if(canedit){ %>
<script type="text/javascript">
	var focusinput = null;
	$(document).ready(function(){
		//联系人部分事件绑定
		$("table.rel_table").find("tr").live("click mouseenter",function(){
			$("table.rel_table").find("div.btn_add2").hide();
			$("table.rel_table").find("div.btn_browser2").hide();
			$(this).find("div.btn_add2").show();
			$(this).find("div.btn_browser2").show();
			$(this).find(".rel_input").addClass("rel_input_hover");
			$(this).find("div.c_del").show();
			$(this).find("div.c_view").show();
			$(this).find("a.imlink").show();
			$(this).find("div.ci_add").show();
		}).live("mouseleave",function(){
			$(this).find("div.btn_add2").hide();
			$(this).find("div.btn_browser2").hide();
			$(this).find(".rel_input").removeClass("rel_input_hover");
			$(this).find("div.c_del").hide();
			$(this).find("div.c_view").hide();
			$(this).find("a.imlink").hide();
			$(this).find("div.ci_add").hide();
		});
		$("input.rel_input").live("focus",function(){
			focusinput = this;
			var _def = $(this).attr("_def");
			if(this.value == _def){
				this.value = "";
				$(this).removeClass("input_blur");
			}
			tempval = this.value;
			$(this).addClass("rel_input_focus");

			if($(this).attr("_fieldname")=="projectrole" || $(this).attr("_fieldname")=="attitude" || $(this).attr("_fieldname")=="title"){
				if($(this).attr("_fieldname")=="projectrole"){
					var selectids = $(this).val();
					var ids = selectids.split(",");
					$("div.roletype").removeClass("roletype_select");
					for(var i=0;i<ids.length;i++){
						if(ids[i]!=""){
							$("#roleitem_"+ids[i]).addClass("roletype_select");
						}
					}
				}
				var _l = $(this).offset().left;
				//alert($(this).offset().top);
				//alert($(this).height());
				var _t = $(this).offset().top+$(this).height()+3;
				var _selectid = $(this).attr("_select");
				//if((_t+$("#"+_selectid).height())>$(window).height()){
					//_t = _t-26;
				//}
				$("#"+_selectid).css({"left":_l,"top":_t}).show();
			}
		}).live("blur",function(){
			$(this).removeClass("rel_input_focus");
			var _def = $(this).attr("_def");
			var newvalue = this.value;
			if(this.value == "" || this.value == _def){
				if($(this).attr("_fieldname")=="firstname" || $(this).attr("_fieldname")=="jobtitle"){//名字、岗位为必填
					this.value = tempval;
					return;
				}else{
					this.value = _def;
					newvalue = "";
					$(this).addClass("input_blur");
				}
			}else if($(this).attr("_fieldname")=="email"){
				var emailStr = this.value.replace(" ","");
				if (!checkEmail(emailStr)) {
					if(tempval==""){
						this.value = _def;
						$(this).addClass("input_blur");
					}else{
						this.value = tempval;
					}
					return;
				}
			}
			if($(this).attr("_contacterid")!=""){
				if(newvalue!=tempval){
					editContacter($(this).attr("_contacterid"),$(this).attr("_fieldname"),newvalue,tempval,_def);
					$(this).attr("_value",newvalue).parent("td").attr("title",_def+":"+newvalue);
				}
			}
		});

		$("div.select_item").bind("mouseover",function(){
			$(this).addClass("select_item_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("select_item_hover");
		}).bind("click",function(){
			var oldvalue = $(focusinput).val();
			var selectvalue = $(this).html();
			if($(focusinput).attr("_contacterid")==""){
				if($(focusinput).attr("_fieldname")=="title"){
					$("#Title").val($(this).attr("_val"));
					$("#titleImage").html("");
				}
				$(focusinput).val(selectvalue).removeClass("input_blur")
			}else{
				if(oldvalue!=selectvalue){
					if($(focusinput).attr("_fieldname")=="title"){
						editContacter($(focusinput).attr("_contacterid"),$(focusinput).attr("_fieldname"),$(this).attr("_val"),$(focusinput).attr("_val"),$(focusinput).attr("_def"));
						$(focusinput).attr("_val",$(this).attr("_val"));
					}else{
						editContacter($(focusinput).attr("_contacterid"),$(focusinput).attr("_fieldname"),selectvalue,oldvalue,$(focusinput).attr("_def"));
					}
					$(focusinput).val(selectvalue).attr("_value",selectvalue).removeClass("input_blur").parent("td").attr("title",$(focusinput).attr("_def")+":"+selectvalue);
				}
			}
		});
		$("#table_contacter").bind("mouseenter",function(){
			//$(this).find("div.btn_addoppt").show();
		}).bind("mouseleave",function(){
			//$(this).find("div.btn_addoppt").hide();
		});
		$(document).bind("click",function(e){
			e = e ? e : event;   
			var target=$.event.fix(e).target;
			if(getVal($(target).attr("_fieldname"))!="projectrole" && $(target).parent().attr("id") != "pr_select"){
				$("#pr_select").hide();
		    }
			if(getVal($(target).attr("_fieldname"))!="attitude"){
				$("#at_select").hide();
		    }
			if(getVal($(target).attr("_fieldname"))!="title"){
				$("#ct_select").hide();
		    }
		}).bind("keydown",function(e){
			e = e ? e : event;   
		    if(e.keyCode == 13){
				var target=$.event.fix(e).target;
				if($(target).hasClass("rel_input")){
					$(target).blur();  
					$("div.select_div").hide();
		    	}
		    }
		});

		$("div.roletype").bind("mouseover",function(){
			$(this).addClass("roletype_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("roletype_hover");
		}).bind("click",function(){
			if($(this).hasClass("roletype_select")){
				$(this).removeClass("roletype_select");
			}else{
				$(this).addClass("roletype_select");
			}
		});
		
		orderList();
	});

	function editContacter(contacterid,fieldname,newvalue,oldvalue,showname){
		var fieldtype = "str";
		if(fieldname=="title") fieldtype="num";
		$.ajax({
			type: "post",
		    url: "/CRM/contacter/Operation.jsp",
		    data:{"operation":"edit_contacter_field","customerid":<%=customerid%>,"contacterid":contacterid,"fieldname":fieldname,"newvalue":filter(encodeURI(newvalue)),"oldvalue":filter(encodeURI(oldvalue)),"showname":filter(encodeURI(showname))
		   		,"fieldtype":fieldtype}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    //var txt = $.trim(data.responseText);
		    	setLastUpdate(0);
		    	if(fieldname=="projectrole") orderList();
		    	if(fieldname=="imcode"){
					$("#imlink_"+contacterid).attr("href","tencent://message/?uin="+newvalue+"&Site=&Menu=yes");
			    }
			}
	    });
	}
	function addContacter(){
		var _status = $("#btn_contacter").attr("_status");
		if(_status==1){
			$("#addContacter").show();
			$("#btn_contacter").attr("_status","0");
		}else{
			cancelAddContacter();
			$("#btn_contacter").attr("_status","1");
		}
	}
	var newname = "";
	function saveContacter(){
     	
     	
     	if($("#Title").val()=="" || $("#Title").val()== $("#Title").attr("_def")
				|| $("#FirstName").val()=="" || $("#FirstName").val()==$("#FirstName").attr("_def") 
				|| $("#JobTitle").val()=="" || $("#JobTitle").val()==$("#JobTitle").attr("_def") ){
			window.top.Dialog.alert("必要信息不完整!");
			return;
		}
     	
     	if($("#PhoneOffice").val()== $("#PhoneOffice").attr("_def")) $("#PhoneOffice").val("");
     	if($("#mobilephone").val()== $("#mobilephone").attr("_def")) $("#mobilephone").val("");
		if($("#CEmail").val()== $("#CEmail").attr("_def")) $("#CEmail").val("");
		
		var FirstName=$("#FirstName").val();
		var JobTitle=$("#JobTitle").val();
		var Title=$("#Title").val();
		var PhoneOffice=$("#PhoneOffice").val();
		var mobilephone=$("#mobilephone").val();
		var email=$("#CEmail").val();
		
		var manager=$("#manager").val();
		var params={"FirstName":FirstName,"JobTitle":JobTitle,"Title":Title,"PhoneOffice":PhoneOffice,"mobilephone":mobilephone,"email":email}
		$.post("CRMOperation.jsp?method=addContacter&CustomerID=<%=customerid%>&manager="+manager,params,function(data){
			$.post("ContacterRel.jsp?customerid=<%=customerid%>&canedit=<%=canedit%>",function(data){
				$("#contacterList").html(data);
			});
     	});
	}
	function cancelAddContacter(){
		$("#contact_load").hide();
		$("div.btn_save").show();
		$("#addContacter").hide();
		$("#quickreset").click();

		$("input.rel_input2").each(function(){
			$(this).addClass("input_blur").val($(this).attr("_def"));
		});
		$("#Title").val("");
		$("#titleImage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle />");
		$("#FirstNameimage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle />");
		$("#JobTitleimage").html("<img src='/images/BacoError_wev8.gif' align=absMiddle />");
	}
	function quickcomplete(contacterId){
		$("#contact_load").hide();
		$.ajax({
			type: "post",
		    url: "/CRM/contacter/Operation.jsp",
		    data:{"operation":"get_contacter","contacterid":contacterId,"contact":"<%=contact%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
			    var txt = $.trim(data.responseText);
			    $("#contacterid").append("<option value='"+contacterId+"'>"+newname+"</option>");
			    $("#addContacter").before(txt);
			    orderList();
		    	setLastUpdate(0);
			}
	    });
		$("#btn_contacter").click();
		//cancelAddContacter();
	}
	//读取更多联系人
	function getMoreContacter(obj){
		var _datalist = $(obj).attr("_datalist");
		var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
		var _pagesize = $(obj).attr("_pagesize");
		var _total = $(obj).attr("_total");
		//var _querysql = $(obj).attr("_querysql");
		$(obj).html("<img src='../images/loading3_wev8.gif' align='absMiddle'/>");
		$.ajax({
			type: "post",
		    url: "/CRM/contacter/Operation.jsp",
		    data:{"operation":"get_more_contacter","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"contact":"<%=contact%>","customerid":"<%=customerid%>","canedit":"<%=canedit%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	var txt = $.trim(data.responseText);
			    $("#addContacter").before(txt);
		    	if(_currentpage*_pagesize>=_total){
		    		$(obj).hide();
			    }else{
			    	$(obj).attr("_currentpage",_currentpage).html("更多").show();
				}
			}
	    });
	}
	function delContacter(obj,contacterid){
		if($(".contacterTr").length<2){
			window.top.Dialog.alert("至少要保留一个联系人");
			return ;
		}
		window.top.Dialog.confirm("确定删除此联系人？",function(){
			$.post("/CRM/contacter/ContacterOperation.jsp?method=delete&CustomerID=<%=customerid%>&ContacterID="+contacterid,function(){
				$(obj).parents(".contacterTr:first").remove();
			});
		});
	}
	function quickcomplete2(contacterId){
		$("#tr_"+contacterId).remove();
		setLastUpdate(0);
	}
	//修改项目角色
	function updateRoleType(){
		var selectnames = "";
		var oldvalue = $(focusinput).val();
		$("div.roletype_select").each(function(){
			selectnames += "," + $(this).html();
		});
		if(selectnames!=""){
			selectnames = selectnames.substring(1);
		}

		if($(focusinput).attr("_contacterid")==""){
			$(focusinput).val(selectnames).removeClass("input_blur")
		}else{
			if(oldvalue!=selectnames){
				editContacter($(focusinput).attr("_contacterid"),$(focusinput).attr("_fieldname"),selectnames,oldvalue,$(focusinput).attr("_def"));
				$(focusinput).val(selectnames).attr("_value",selectnames).removeClass("input_blur").parent("td").attr("title",$(focusinput).attr("_def")+":"+selectnames);
				if(selectnames=="") $(focusinput).addClass("input_blur");
			}
		}
	}
	function cancelRoleType(){
		$("#pr_select").hide();
	}
	function orderList(){
		var trstr1 = "";var trstr2 = "";var trstr3 = "";var trstr4 = "";var trstr5 = "";var trstr6 = "";
		$("#reltable").find("tr.tr_contacter").each(function(){
			var pr = $(this).find("input.rel_pr");
			//alert($(this).html());
			if(pr.val().indexOf("项目决策人")==0){
				trstr1 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}else if(pr.val().indexOf("客户高层")==0){
				trstr2 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}else if(pr.val().indexOf("内部向导")==0){
				trstr3 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}else if(pr.val().indexOf("技术影响人")==0){
				trstr4 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}else if(pr.val().indexOf("需求影响人")==0){
				trstr5 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}else{
				trstr6 += "<tr id='"+$(this).attr("id")+"' class='tr_contacter'>"+$(this).html()+"</tr>";
			}
		});
		$("#reltable").find("tr.tr_contacter").remove();
		var strs = trstr1+trstr2+trstr3+trstr4+trstr5+trstr6;
		$("#addContacter").before(strs);
		$("input.rel_input").each(function(){
			if(getVal($(this).attr("_value"))!=$(this).attr("_def") && getVal($(this).attr("_value"))!=""){
				$(this).val($(this).attr("_value"));
			}else if(getVal($(this).attr("_value"))==""){
				$(this).val($(this).attr("_def"));
			}
		});
	}
	
	function setLastUpdate(){
		var currentdate = new Date();
		var datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
		showMsg();
	}
	
	function showMsg(msg){
		jQuery("#warn").find(".title").html("操作成功！");
		jQuery("#warn").css("display","block");
		setTimeout(function (){
			jQuery("#warn").css("display","none");
		},1500);
		
	  }
	
</script>
<%}%>