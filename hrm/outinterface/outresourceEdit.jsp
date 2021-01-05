<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<head>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
  <script language="javascript" src="/js/ecology8/hrm/e8Common_wev8.js?r=2"></script>
</head>
<%
String id = request.getParameter("id");

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="dosave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM name=outresourceinfo id=outresourceinfo action="outresourceOperation.jsp" method=post>
<input type=hidden id="operation" name="operation" value="">
<input type=hidden id="id" name="id" value="<%=id%>">
<%
  String sql = "";
	String customid = "";
  sql = " select a.lastname,a.loginid,a.password,a.mobile,a.email,a.seclevel,b.wxname,"+ 
  			"	b.wxopenid,b.wxuuid,b.country,b.province,b.city,b.customid,b.customfrom,b.isoutmanager " +
  			" from HrmResource a, hrmresourceout b " +
  			" WHERE a.id=b.resourceid and a.id = "+Util.getIntValue(id,-1);
  String lastname = "";
  rs.executeSql(sql);
  if(rs.next()){
    lastname = Util.null2String(rs.getString("lastname"));
    lastname = lastname.endsWith("\\")&&!lastname.endsWith("\\\\") == true ? lastname+ "\\" :lastname;
    String loginid = Util.null2String(rs.getString("loginid"));
    String password = Util.null2String(rs.getString("password"));
    String seclevel = Util.null2String(rs.getString("seclevel"));
    String isoutmanager = Util.null2String(rs.getString("isoutmanager"));
    String mobile = Util.null2String(rs.getString("mobile"));
    String email = Util.null2String(rs.getString("email"));
		String wxname = Util.null2String(rs.getString("wxname"));
    String wxopenid = Util.null2String(rs.getString("wxopenid"));
    String wxuuid = Util.null2String(rs.getString("wxuuid"));
		String country = Util.null2String(rs.getString("country"));
		String province = Util.null2String(rs.getString("province"));
    String city = Util.null2String(rs.getString("city"));
    customid = Util.null2String(rs.getString("customid"));
    String customfrom = Util.null2String(rs.getString("customfrom"));
    String departmentid = CustomerInfoComInfo.getCustomerInfoDepartmentid(customid);
%>
	<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">     
	<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
		<wea:item>
			<input maxLength=30 size=30 id="lastname" name="lastname" value="<%=lastname%>" onchange='checkinput("lastname","lastnamespan");this.value=trim(this.value)' style="width: 300px;">
			<SPAN id=lastnamespan><%if(lastname.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item><%=DepartmentVirtualComInfo.getDepartmentname(departmentid)%>
		<!-- 
			<brow:browser viewType="0" name="departmentid" browserValue="<%=departmentid %>"
			 	browserurl="/systeminfo/BrowserMain.jsp?url=/hrm/companyvirtual/DepartmentBrowser.jsp"
			  hasInput="true" isSingle="true" hasBrowser="true" isMustInput='2'
			  completeUrl="/data.jsp?type=4" width="165px"
			  browserSpanValue="<%=DepartmentVirtualComInfo.getDepartmentname(departmentid)%>">
			</brow:browser>
		 -->
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></wea:item>
		<wea:item><input type="text" name="mobile" value="<%=mobile%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="email" name="email" value="<%=email%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125933,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="wxname" name="wxname" value="<%=wxname%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125934,user.getLanguage())%>OpenId</wea:item>
		<wea:item><input type="text" id="wxopenid" name="wxopenid" value="<%=wxopenid%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125934,user.getLanguage())%>UUID</wea:item>
		<wea:item><input type="text" id="wxuuid" name="wxuuid" value="<%=wxuuid%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125935,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="country" name="country" value="<%=country%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125936,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="province" name="province" value="<%=province%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125937,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="city" name="city" value="<%=city%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(25542,user.getLanguage())%></wea:item>
		<wea:item><input type="text" id="customfrom" name="customfrom" value="<%=customfrom%>" style="width: 300px"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(27382,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customid" browserValue="<%=customid %>"
				browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			  hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
			  completeUrl="/data.jsp?type=4" width="330px"
			  browserSpanValue="<%=CustomerInfoComInfo.getCustomerInfoname(customid)%>">
			</brow:browser>
		</wea:item>
	</wea:group>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" id="loginid" name="loginid" value="<%=loginid%>" onchange='checkinput("loginid","loginidspan");this.value=trim(this.value)' style="width: 300px;">
			<SPAN id=loginidspan><%if(loginid.length()==0){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="password" id="password1" name="password1" value="<%=password.length()==0?"":"aaaaaa" %>" onchange='checkinput("password1","password1span");' style="width: 300px;">
			<SPAN id=password1span><%if(password.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(501,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="password" id="password2" name="password2" value="<%=password.length()==0?"":"aaaaaa" %>" onchange='checkinput("password2","password2span");' style="width: 300px;">
			<SPAN id=password2span><%if(password.equals("")) {%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></SPAN>
			<input type="hidden" id="password" name="password" value="<%=password %>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" id="seclevel" name="seclevel" value="<%=seclevel %>" style="width: 300px;">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(125939,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" id="isoutmanager" name="isoutmanager" value="1" <%=isoutmanager.equals("1")?"checked":"" %> onclick="jsCheckOutManager()" >
		</wea:item>
	</wea:group>
	</wea:layout>
	<%} %>
  </FORM>
<script type="text/javascript">
function jsCheckOutManager(){
	if(jQuery("#isoutmanager").attr("checked")){
		jQuery.ajax({
				url:"/hrm/ajaxData.jsp",
				type:"POST",
				dataType:"json",
				async:true,
				data:{
					cmd:"checkOutManager",
					resourceid:jQuery("#id").val(),
					customid:jQuery("#customid").val()
				},
				success:function(data){
					if(data=="1"){
						try{
								window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126017,user.getLanguage())%>",function(){
								//确定
							},function(){//取消
								changeCheckboxStatus(jQuery("#isoutmanager"),false);
							});
						}catch(e){
							Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126017,user.getLanguage())%>",function(){
								//确定
							},function(){//取消
								changeCheckboxStatus(jQuery("#isoutmanager"),false);
							});
						}
					}
				}
		});
	}
}

function dosave(obj){
	if(!chkMail()) return false;
		
	var reg = /^\-\d+\.?\d*$/;
	if(!reg.test(jQuery("#seclevel").val())){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128198,user.getLanguage())%>");
		return false;
	}
	
	if(jQuery("#password1").val()!=jQuery("#password2").val()){
		try{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125288,user.getLanguage())%>");
		}catch(e){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(125288,user.getLanguage())%>");
		}
		return false;
	}
	
	if(!jQuery("#isoutmanager").attr("checked")){
  	jQuery("#isoutmanager").val("");
  }
  
if(check_form(outresourceinfo,'lastname,loginid,password1,password2,departmentid,customid')){
		//校验姓名、登录名是否重复
		jQuery.ajax({
			url:"/hrm/ajaxData.jsp",
			type:"POST",
			dataType:"json",
			async:true,
			data:{
				cmd:"checkLastname",
				resourceid:jQuery("#id").val(),
				lastname:jQuery("#lastname").val()
			},
			success:function(data){
				if(data=="1"){
					try{
						window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21445,user.getLanguage())%>",function(){
							jQuery.ajax({
								url:"/hrm/ajaxData.jsp",
								type:"POST",
								dataType:"json",
								async:true,
								data:{
									cmd:"checkLoginid",
									resourceid:jQuery("#id").val(),
									loginid:jQuery("#loginid").val()
								},
								success:function(data){
									if(data=="1"){
										window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>");
										jQuery("#loginid").focus();	
										return;
									}else{
										if(jQuery("#password2").val()!=""&&jQuery("#password2").val()!="aaaaaa")jQuery("#password").val(jQuery("#password2").val());
										jQuery("#operation").val("edit");
										obj.disabled = true;
										outresourceinfo.submit();
									}
								}
							});
						},function(){
							jQuery("#lastname").focus();
						});
					}catch(e){
							Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21445,user.getLanguage())%>",function(){
							jQuery.ajax({
								url:"/hrm/ajaxData.jsp",
								type:"POST",
								dataType:"json",
								async:true,
								data:{
									cmd:"checkLoginid",
									resourceid:jQuery("#id").val(),
									loginid:jQuery("#loginid").val()
								},
								success:function(data){
									if(data=="1"){
										Dialog.alert("<%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>");
										jQuery("#loginid").focus();	
										return;
									}else{
										if(jQuery("#password2").val()!=""&&jQuery("#password2").val()!="aaaaaa")jQuery("#password").val(jQuery("#password2").val());
										jQuery("#operation").val("edit");
										obj.disabled = true;
										outresourceinfo.submit();
									}
								}
							});
						},function(){
							jQuery("#lastname").focus();
						});
					}
				}else{
					jQuery.ajax({
						url:"/hrm/ajaxData.jsp",
						type:"POST",
						dataType:"json",
						async:true,
						data:{
							cmd:"checkLoginid",
							resourceid:jQuery("#id").val(),
							loginid:jQuery("#loginid").val()
						},
						success:function(data){
							if(data=="1"){
								try{
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>");
								}catch(e){
									Dialog.alert("<%=SystemEnv.getHtmlLabelName(16128,user.getLanguage())%>");
								}
								jQuery("#loginid").focus();	
								return;
							}else{
								if(jQuery("#password2").val()!=""&&jQuery("#password2").val()!="aaaaaa")jQuery("#password").val(jQuery("#password2").val());
								jQuery("#operation").val("edit");
								obj.disabled = true;
								outresourceinfo.submit();
							}
						}
					});
				}
			}
		});	
	}
}

function chkMail(){
	var email = jQuery("#email").val();
	if(email=="")return true;
	var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
	if(pattern.test(email)){
		return true;
	}else{
		try{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
		}catch(e){
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage())%>");
		}
		jQuery("#email").focus()
		return false;
	}
}

jQuery(document).ready(function(){
	controlNumberCheck_jQuery("seclevel", false, 0, true, 3);
})
</script>
</body>
</html>