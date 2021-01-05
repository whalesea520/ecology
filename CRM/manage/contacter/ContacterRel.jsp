
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ContacterTitleComInfo" class="weaver.crm.Maint.ContacterTitleComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<%
	String customerid = Util.null2String(request.getParameter("customerid"));
	boolean canedit = Util.null2String(request.getParameter("canedit")).equals("true")?true:false;
	if(!customerid.equals("")){
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
	String sql = "select top "+_pagesize+" t2.id,t2.title,t2.firstname,t2.jobtitle,t2.lastname,t2.department,t2.email,t2.phoneoffice,t2.mobilephone,t2.projectrole,t2.attitude,t2.attention,t2.imcode"
			+ " from CRM_CustomerContacter t2 where t2.customerid="
			+ customerid + " order by t2.id";
	rs.executeSql(sql);
%>
<table id="table_contacter" style="width: 100%;" cellpadding="0" cellspacing="0" border="0">
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
				<colgroup>
					<col width="5%" />
					<col width="5%" />
					<col width="8%" />
					<col width="8%" />
					<col width="10%" />
					<col width="10%" />
					<col width="12%" />
					<col width="10%" />
					<col width="10%" />
					<col width="*" />
					<%if(canedit){ %>
						<%if(contact.equals("0")){ %>
					<col width="60px" />
						<%}else{ %>
					<col width="24px" />
						<%} %>
					<%} %>
				</colgroup>
				
				<thead>
					<tr class="HeaderForXtalbe">
						<th>姓名</th>
						<th>称呼</th>
						<th>岗位</th>
						<th>部门</th>
						<th>办公电话</th>
						<th>移动电话</th>
						<th>邮箱</th>
						<th>IM号码</th>
						<th>意向判断</th>
						<th>关键点</th>
						<th></th>
					</tr>
				</thead>
				
				<%while (rs.next()) {
				String contacterid = Util.null2String(rs.getString("id"));%>
				<tr id="tr_<%=contacterid%>" class="DataLight">
				
					<td class="info" title="姓名:<%=Util.toScreen(rs.getString("firstname"), user
						.getLanguage())%>">
						<%if (canedit) {%>
						<input _fieldname="firstname" _contacterid="<%=contacterid %>"
							class="rel_input" _def="姓名" _value="<%=Util.null2String(rs.getString("firstname")) %>"
							value="<%=Util.null2String(rs.getString("firstname")) %>" />
						<%} else {%>
							<div style="float: left;"><a href="###"
							onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')"
							target="_self"> <%=Util.toScreen(rs.getString("firstname"), user.getLanguage())%> </a></div>
							<%if(contact.equals("0")){ %>
								<div class="c_view ci_add" style="display:block;margin-top:1px;background: url('../images/btn_add2_wev8.png') center no-repeat;" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
							<%} %>
						<%}%>
					</td>
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
					<td class="info" title="部门:<%=Util.null2String(rs.getString("department"))%>">
						<%if (canedit) {%>
						<input _fieldname="department" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("department")).equals("")) {%>input_blur<%}%>"
							_def="部门" _value="<%=Util.null2String(rs.getString("department")) %>"
							value="<%=Util.null2String(rs.getString("department"))
							.equals("") ? "部门" : Util.null2String(rs
							.getString("department"))%>" />
						<%} else {%>
						<%if (Util.null2String(rs.getString("department")).equals("")) {%>
						<div class="input_blur">
							部门
						</div>
						<%} else {%>
						<%=Util.null2String(rs.getString("department"))%>
						<%}%>
						<%}%>
					</td>
					<td class="info" title="办公电话:<%=Util.null2String(rs.getString("phoneoffice"))%>">
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
							办公电话
						</div>
						<%} else {%>
						<%=Util.null2String(rs.getString("phoneoffice"))%>
						<%}%>
						<%}%>
					</td>
					<td class="info" title="移动电话:<%=Util.null2String(rs.getString("mobilephone"))%>">
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
							移动电话
						</div>
						<%} else {%>
						<%=Util.null2String(rs.getString("mobilephone"))%>
						<%}%>
						<%}%>
					</td>
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
					<td class="info" title="IM号码:<%=Util.null2String(rs.getString("imcode"))%>">
						<%if (canedit) {%>
						<input _fieldname="imcode" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("imcode")).equals("")) {%>input_blur<%}%>"
							_def="IM号码" _value="<%=Util.null2String(rs.getString("imcode")) %>"
							value="<%=Util.null2String(rs.getString("imcode"))
							.equals("") ? "IM号码" : Util.null2String(rs
							.getString("imcode"))%>" style="width:70%"/>
						<a id="imlink_<%=contacterid %>" class="imlink"  href="tencent://message/?uin=<%=Util.null2String(rs.getString("imcode")) %>&Site=&Menu=yes" title="点击发起QQ会话" style="display: none;"></a>
						<%} else {%>
						<%if (Util.null2String(rs.getString("imcode")).equals("")) {%>
						<div class="input_blur">
							IM号码
						</div>
						<%} else {%>
						<a href="tencent://message/?uin=<%=Util.null2String(rs.getString("imcode")) %>&Site=&Menu=yes" title="点击发起QQ会话">
							<%=Util.toScreenToEdit(rs.getString("imcode"),user.getLanguage())%>
						</a>
						<%}%>
						<%}%>
					</td>
					<td class="info" title="意向判断:<%=Util.null2String(rs.getString("attitude"))%>">
						<%if (canedit) {%>
						<input _fieldname="attitude" _contacterid="<%=contacterid %>" readonly="readonly" _select="at_select"
							class="rel_input <%if (Util.null2String(rs.getString("attitude")).equals("")) {%>input_blur<%}%>"
							_def="意向判断" _value="<%=Util.null2String(rs.getString("attitude")) %>"
							value="<%=Util.null2String(rs.getString("attitude"))
							.equals("") ? "意向判断" : Util.null2String(rs
							.getString("attitude"))%>" />
						<%} else {%>
						<%if (Util.null2String(rs.getString("attitude")).equals("")) {%>
						<div class="input_blur">
							意向判断
						</div>
						<%} else {%>
						<%=Util.null2String(rs.getString("attitude"))%>
						<%}%>
						<%}%>
					</td>
					<td class="info" title="关注点及应对策略:<%=Util.null2String(rs.getString("attention"))%>">
						<%if (canedit) {%>
						<input _fieldname="attention" _contacterid="<%=contacterid %>"
							class="rel_input <%if (Util.null2String(rs.getString("attention")).equals("")) {%>input_blur<%}%>"
							_def="关注点及应对策略" _value="<%=Util.null2String(rs.getString("attention")) %>"
							value="<%=Util.null2String(rs.getString("attention"))
							.equals("") ? "关注点及应对策略" : Util.null2String(rs
							.getString("attention"))%>" />
						<%} else {%>
						<%if (Util.null2String(rs.getString("attention")).equals("")) {%>
						<div class="input_blur">
							关注点及应对策略
						</div>
						<%} else {%>
						<%=Util.null2String(rs.getString("attention"))%>
						<%}%>
						<%}%>
					</td>
					<%if(canedit){ %>
					<td class="info">
						<div class="c_view" onclick="openFullWindowHaveBar('/CRM/manage/contacter/ContacterView.jsp?ContacterID=<%=contacterid%>')" title="明细"></div>
						<%if(contact.equals("0")&&false){ %>
						<div class="ci_add" onclick="addContact('<%=contacterid %>',2)" title="添加联系记录"></div>
						<%} %>
						<!-- <div class="c_del" onclick="delContacter('<%=contacterid %>')" title="删除"></div> -->
					</td>
					<%} %>
				</tr>
				<%}%>
				<%if(canedit){ %>
				<!-- 快速新建联系人开始 -->
				<tr id="addContacter" style="display: none;">
				<form id="quickaddform" name="quickaddform" action="/CRM/manage/contacter/ContacterOperation.jsp" method=post enctype="multipart/form-data" target="quickaddframe">
					<input type="hidden" name="CustomerID" value="<%=customerid %>"/>
					<input type="hidden" name="quickadd" value="1"/>
					<input type="hidden" name="method" value="add"/>
					<input type="hidden" name="Manager" value="<%=user.getUID()+"" %>"/>
					<input type="hidden" name="status" value="1"/>
					<input type="hidden" name="isneedcontact" value="1"/>
					<input type="hidden" name="Language" value="<%=user.getLanguage() %>"/>
					
					<td class="info">
						<input id="FirstName" _fieldname="FirstName" name="FirstName" _contacterid="" onchange='checkinput("FirstName","FirstNameimage")'
							class="rel_input rel_input2 input_blur" _def="姓名" value="姓名" style="width: 80%"/>
						<span id=FirstNameimage><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
					</td>
					<td class="info">
						<input _fieldname="title" name="" _contacterid="" _select="ct_select" readonly="readonly" 
							class="rel_input rel_input2 input_blur" _def="称呼" value="称呼"  style="width: 80%"/>
						<span id="titleImage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
						<input type="hidden" id="Title" name="Title" _def="称呼"/>
					</td>
					<td class="info">
						<input id="JobTitle" _fieldname="jobtitle" name="JobTitle" _contacterid="" onchange="checkinput('JobTitle','JobTitleimage')"
							class="rel_input rel_input2 input_blur" _def="岗位" value="岗位"  style="width: 80%"/>
						<span id="JobTitleimage"><img src="/images/BacoError_wev8.gif" align=absMiddle /></span>
					</td>
					<td class="info">
						<input id="department" _fieldname="department" name="department" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="部门" value="部门" />
					</td>
					<td class="info">
						<input id="PhoneOffice" _fieldname="phoneoffice" name="PhoneOffice" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="办公电话" value="办公电话" />
					</td>
					<td class="info">
						<input id="Mobile" _fieldname="mobilephone" name="Mobile" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="移动电话" value="移动电话" />
					</td>
					<td class="info">
						<input id="CEmail" _fieldname="email" name="CEmail" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="邮箱" value="邮箱" />
					</td>
					<td class="info">
						<input id="imcode" _fieldname="imcode" name="imcode" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="IM号码" value="IM号码" />
					</td>
					<td class="info">
						<input id="attitude" _fieldname="attitude" name="attitude" _contacterid="" _select="at_select" readonly="readonly"
							class="rel_input rel_input2 input_blur" _def="意向判断" value="意向判断" />
					</td>
					<td class="info">
						<input id="attention" _fieldname="attention" name="attention" _contacterid=""
							class="rel_input rel_input2 input_blur" _def="关注点及应对策略" value="关注点及应对策略" />
					</td>
					<td class="info">
						<button id="quickreset" type="reset" style="display: none"/></button>
				        <div class="btn_save"  onclick="saveContacter()"></div>
				        <div class="btn_cancel"  onclick="addContacter()"></div>
						<div id="contact_load" class="load" style="background-color: transparent;"></div>
					</td>
				</form>
				<!-- 暂时关闭删除功能
				<form id="quickdelform" name="quickdelform" action="/CRM/data/ContacterOperation.jsp" method=post enctype="multipart/form-data" target="quickaddframe">
					<input type="hidden" id="ContacterID" name="ContacterID" value=""/>
					<input type="hidden" name="quickdel" value="1"/>
					<input type="hidden" name="method" value="delete"/>
				</form>
				 -->
				<iframe id="quickaddframe" name="quickaddframe" style="display: none"></iframe>
				</tr>
				<!-- 快速新建联系人结束 -->
				<%} %>
			</table>
			<%if(_total>_pagesize){ %>
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
				var _t = $(this).offset().top+$(this).height()+3;
				var _selectid = $(this).attr("_select");
				if((_t+$("#"+_selectid).height())>$(window).height()){
					_t = _t-26-$("#"+_selectid).height();
				}
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
		    url: "/CRM/manage/contacter/Operation.jsp",
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
			alert("必要信息不完整!");
			return;
		}
		if($("#projectrole").val()== $("#projectrole").attr("_def")) $("#projectrole").val("");
		if($("#department").val()== $("#department").attr("_def")) $("#department").val("");
		if($("#PhoneOffice").val()== $("#PhoneOffice").attr("_def")) $("#PhoneOffice").val("");
		if($("#Mobile").val()== $("#Mobile").attr("_def")) $("#Mobile").val("");
		if($("#CEmail").val()== $("#CEmail").attr("_def")) $("#CEmail").val("");
		if($("#imcode").val()== $("#imcode").attr("_def")) $("#imcode").val("");
		if($("#attitude").val()== $("#attitude").attr("_def")) $("#attitude").val("");
		if($("#attention").val()== $("#attention").attr("_def")) $("#attention").val("");
		$("#contact_load").show();
		$("div.btn_save").hide();
		$("div.btn_cancel").hide();
		newname = $("#FirstName").val();
		$("#quickaddform").submit();
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
		    url: "/CRM/manage/contacter/Operation.jsp",
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
		    url: "/CRM/manage/contacter/Operation.jsp",
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
	function delContacter(contacterid){
		if(confirm("确定删除此联系人？")){
			$("#ContacterID").val(contacterid);
			$("#quickdelform").submit();
		}
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
</script>
<%}%>