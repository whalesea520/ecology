<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.outter.OutterDisplayHelper" %>
<jsp:useBean id="rs_Setting" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_Setting2" class="weaver.conn.RecordSet" scope="page" />
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<wea:layout type="2Col">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
ArrayList nameList = new ArrayList();
ArrayList valueList = new ArrayList();

nameList.add("coreMailList");// 显示未读列表
nameList.add("coreMailPerpage");// 显示条数
nameList.add("coreMailLinkMode");// 链接方式
nameList.add("coreMailTitle");// 主题
nameList.add("coreMailUser");// 发件人
nameList.add("coreMailTime");// 发件时间

nameList.add("coreMailPrompt");// 显示提示信息
nameList.add("coreMailText");// 提示文字
nameList.add("coreMailNumberColor");// 未读邮件数量颜色
nameList.add("coreMailLinkColor");// 单点登录链接颜色
nameList.add("coreMailSysid");// 单点登录

String coreMailList = "";
String coreMailPerpage = "";
String coreMailLinkMode = "";
String coreMailTitle = "";
String coreMailUser = "";
String coreMailTime = "";

String coreMailPrompt = "";
String coreMailText = "";
String coreMailNumberColor = "";
String coreMailLinkColor = "";
String coreMailSysid = "";
%>

<%
String strSettingSql = "select * from hpElementSetting where eid = " + eid;
rs_Setting.execute(strSettingSql);
if(!rs_Setting.next()) {
	valueList.add("1");
	valueList.add("5");
	valueList.add("2");
	valueList.add("1");
	valueList.add("1");
	valueList.add("1");
	
	valueList.add("1");
	valueList.add(SystemEnv.getHtmlLabelName(129934, user.getLanguage()));
	valueList.add("#ff0000");
	valueList.add("#009aff");
	valueList.add("");
	
	int maxId = 0;
	strSettingSql = "select count(1) as maxId from hpElementSetting ";
	rs_Setting.execute(strSettingSql);
	if(rs_Setting.next()) {
		maxId = rs_Setting.getInt("maxId");
	}
	maxId ++;
	
	String insertStr = "";
	for(int i = 0; i < nameList.size(); i++) {
		insertStr = "insert into hpElementSetting(id,eid,name,value) values("+(maxId+i)+","+eid+",'"+nameList.get(i)+"','"+valueList.get(i)+"')";
		rs_Setting.execute(insertStr);
	}
} else {
	String selectStr = "";
	for(int i = 0; i < nameList.size(); i++) {
		selectStr = "select * from hpElementSetting where eid="+eid+" and name='"+nameList.get(i)+"'";
		rs_Setting.execute(selectStr);
		if(rs_Setting.next()) {
			valueList.add(rs_Setting.getString("value"));
		}
	}
}

if("2".equals(esharelevel)) {
	coreMailList = (String) valueList.get(nameList.indexOf("coreMailList"));
	coreMailPerpage = (String) valueList.get(nameList.indexOf("coreMailPerpage"));
	coreMailLinkMode = (String) valueList.get(nameList.indexOf("coreMailLinkMode"));
	coreMailTitle = (String) valueList.get(nameList.indexOf("coreMailTitle"));
	coreMailUser = (String) valueList.get(nameList.indexOf("coreMailUser"));
	coreMailTime = (String) valueList.get(nameList.indexOf("coreMailTime"));
	
	coreMailPrompt = (String) valueList.get(nameList.indexOf("coreMailPrompt"));
	coreMailText = (String) valueList.get(nameList.indexOf("coreMailText"));
	coreMailNumberColor = (String) valueList.get(nameList.indexOf("coreMailNumberColor"));
	coreMailLinkColor = (String) valueList.get(nameList.indexOf("coreMailLinkColor"));
	coreMailSysid = (String) valueList.get(nameList.indexOf("coreMailSysid"));
%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("25426,320",user.getLanguage()) %>'>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelNames("89,25426,320",user.getLanguage()) %></wea:item><!-- 显示未读列表 -->
		<wea:item>
			<input class="inputstyle" type="checkbox" tzCheckbox="true" name="coreMailList_<%=eid %>" value="1" <% if(coreMailList.equals("1")) out.println("checked"); %>>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19493,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="inputstyle" type="text" style='width:80px!important;' maxLength="6" name="coreMailPerpage_<%=eid %>" value="<%=coreMailPerpage %>" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onblur="checkNumber(this.value)">
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%></wea:item>
	   	<wea:item>
			<select style='width:80px!important;' name="coreMailLinkMode_<%=eid %>" >
				<option value="1" <% if("1".equals(coreMailLinkMode)) out.println("selected"); %>>
					<%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%><!--当前页-->
				</option>
				<option value="2" <% if("2".equals(coreMailLinkMode)) out.println("selected"); %>>
					<%=SystemEnv.getHtmlLabelName(19498,user.getLanguage())%><!--弹出页-->
				</option>
			</select>
	    </wea:item>
	    
	    <wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(126789,user.getLanguage())%></wea:item>
		<wea:item>
			<select style='width:200px!important;' id="coreMailSysid_<%=eid %>" name="coreMailSysid_<%=eid %>" >
				<option value="" <% if(coreMailSysid.equals("")) out.println("selected"); %>></option>
				<%
				// 得到有权限查看的集成登录
				OutterDisplayHelper ohp = new OutterDisplayHelper();
				String sqlright = ohp.getShareOutterSql(user);
				rs_Setting2.executeSql("select sysid, name from outter_sys a where a.typename = '8' and EXISTS (select 1 from (" + sqlright + ") b where a.sysid = b.sysid) order by a.sysid desc ");
			    while(rs_Setting2.next()) {
			    	String sysid = Util.null2String(rs_Setting2.getString("sysid"));
			    	String sysname = Util.null2String(rs_Setting2.getString("name"));
				%>
			  	<option value="<%=sysid %>" <% if(coreMailSysid.equals(sysid)) out.println("selected"); %>><%=sysname %></option>
				<% } %>
			</select>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(82754,user.getLanguage())%></wea:item>
		<wea:item>
			<br/>
			<input type="checkbox" value="1" name="coreMailTitle_<%=eid %>" onclick="change1(this);" <% if(coreMailTitle.equals("1")) out.print("checked"); else out.print(""); %>/> <%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%>
			<br/>
			<input type="checkbox" value="1" name="coreMailUser_<%=eid %>" onclick="change2(this);" <% if(coreMailUser.equals("1")) out.print("checked"); else out.print(""); %>/> <%=SystemEnv.getHtmlLabelName(129935,user.getLanguage())%>
			<br/>
			<input type="checkbox" value="1" name="coreMailTime_<%=eid %>" onclick="change3(this);" <% if(coreMailTime.equals("1")) out.print("checked"); else out.print(""); %>/> <%=SystemEnv.getHtmlLabelName(129936,user.getLanguage())%>
			<br/>&nbsp;
		</wea:item>
	</wea:group>
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(24960,user.getLanguage()) %>'>
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelNames("89,24960",user.getLanguage()) %></wea:item><!-- 显示提示信息 -->
		<wea:item>
			<input class="inputstyle" type="checkbox" tzCheckbox="true" name="coreMailPrompt_<%=eid %>" value="1" <% if(coreMailPrompt.equals("1")) out.println("checked"); %>>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(129937,user.getLanguage())%></wea:item>
		<wea:item>
			<textarea class="inputstyle" type="text" style='width:360px!important;' rows="4" name="coreMailText_<%=eid %>"><%=coreMailText %></textarea>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(129938,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="inputstyle" style="background:<%=coreMailNumberColor %>;width:60px;" name="coreMailNumberColor_<%=eid %>" value="<%=coreMailNumberColor %>"></input>
			<img class="color" id="color1" src="/js/jquery/plugins/farbtastic/color_wev8.png" style="cursor:hand;margin-left:5px;margin-top:3px;" align="absmiddle" border="0"/>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(129939,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="inputstyle" style="background:<%=coreMailLinkColor %>;width:60px;" name="coreMailLinkColor_<%=eid %>" value="<%=coreMailLinkColor %>"></input>
			<img class="color" id="color2" src="/js/jquery/plugins/farbtastic/color_wev8.png" style="cursor:hand;margin-left:5px;margin-top:3px;" align="absmiddle" border="0"/>
		</wea:item>
		
		<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
		<wea:item>
			<br/>
			$NoReadCnt$ : <%=SystemEnv.getHtmlLabelName(129940,user.getLanguage())%>
			<br/>
		  	$LoginLinkStart$ : <%=SystemEnv.getHtmlLabelName(129941,user.getLanguage())%>
		  	<br/>
		  	$LoginLinkEnd$ : <%=SystemEnv.getHtmlLabelName(129942,user.getLanguage())%>
		  	<br/>&nbsp;
		</wea:item>
	</wea:group>
<%
}
%>	
</wea:layout>

<script language=javascript>
$(document).ready(function(){
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox") == "true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
});

jQuery(function() {
    var language = "<%=user.getLanguage() %>";
    var color = $("[name=coreMailNumberColor_<%=eid %>]").val();
    $("#color1").spectrum({
		showPalette:true,
		showInput:true,
		allowEmpty:false,
		preferredFormat: "hex",
		chooseText:SystemEnv.getHtmlNoteName(3451,language),
		cancelText:SystemEnv.getHtmlNoteName(3516,language),
		color:color,
		noclickhide:true,
		hide: function(color) {
			color = color.toHexString();
			$("[name=coreMailNumberColor_<%=eid %>]").css("backgroud-color",color);
			$("[name=coreMailNumberColor_<%=eid %>]").val(color);
		},
		move: function(color) {
			color = color.toHexString();
			$("[name=coreMailNumberColor_<%=eid %>]").css("background-color",color);
			$("[name=coreMailNumberColor_<%=eid %>]").val(color);
		},
		palette: [
			["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
			["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
			["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
			["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
			["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
			["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
			["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
			["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
		]
	});
});

jQuery(function() {
    var language = "<%=user.getLanguage() %>";
    var color = $("[name=coreMailLinkColor_<%=eid %>]").val();
    $("#color2").spectrum({
		showPalette:true,
		showInput:true,
		allowEmpty:false,
		preferredFormat: "hex",
		chooseText:SystemEnv.getHtmlNoteName(3451,language),
		cancelText:SystemEnv.getHtmlNoteName(3516,language),
		color:color,
		noclickhide:true,
		hide: function(color) {
			color = color.toHexString();
			$("[name=coreMailLinkColor_<%=eid %>]").css("backgroud-color",color);
			$("[name=coreMailLinkColor_<%=eid %>]").val(color);
		},
		move: function(color) {
			color = color.toHexString();
			$("[name=coreMailLinkColor_<%=eid %>]").css("background-color",color);
			$("[name=coreMailLinkColor_<%=eid %>]").val(color);
		},
		palette: [
			["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
			["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
			["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
			["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
			["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
			["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
			["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
			["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
		]
	});
});

function change1(obj) {
	var temp = obj.checked;
	if(temp) {
		$("[name=coreMailTitle_<%=eid %>]").val("1");
	} else {
		$("[name=coreMailTitle_<%=eid %>]").val("0");
	}
}

function change2(obj) {
	var temp = obj.checked;
	if(temp) {
		$("[name=coreMailUser_<%=eid %>]").val("1");
	} else {
		$("[name=coreMailUser_<%=eid %>]").val("0");
	}
}

function change3(obj) {
	var temp = obj.checked;
	if(temp) {
		$("[name=coreMailTime_<%=eid %>]").val("1");
	} else {
		$("[name=coreMailTime_<%=eid %>]").val("0");
	}
}

function checkNumber(value) {
	value = $.trim(value);
	if(value == "") {
		$("[name=coreMailPerpage_<%=eid %>]").val(5);
	} else {
		if(isNaN(value)) {
			$("[name=coreMailPerpage_<%=eid %>]").val(5);
		} else {
			$("[name=coreMailPerpage_<%=eid %>]").val(parseInt(value));
		}
	}
}

</script>
