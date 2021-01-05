
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file ="common.jsp" %>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
	<%
	String openlinksel1 = "",openlinksel2="";
	if("1".equals(openlink)) openlinksel1="selected";
	else openlinksel2="selected";
	%>		
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(19494,user.getLanguage())%><!--链接方式--></wea:item>
	<wea:item>
		<select id="select_open_<%=eid%>" name="select_open_<%=eid%>">
			<option value='1' <%=openlinksel1%>><%=SystemEnv.getHtmlLabelName(19497,user.getLanguage())%></option>
			<option value='2' <%=openlinksel2%>><%=SystemEnv.getHtmlLabelName(19498,user.getLanguage())%></option>
		</select>
	</wea:item>
	<%
	boolean canSync = false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)){
		canSync = true;
	}else{
		List<String> hplist = pu.getUserMaintHpidListPublic(Util.getIntValue(hpid));
		if(hplist.contains(hpid)){
			canSync = true;
		}
	}
	
	
	if(canSync){
	%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(32328,user.getLanguage())%><!--同步内容--></wea:item>
	<wea:item>
		<input id="sync_datacenter_<%=eid %>" name="sync_datacenter_<%=eid %>" value="1" type="checkbox" tzcheckbox="true">
		<input id="usertype_datacenter_<%=eid %>" name="usertype_datacenter_<%=eid %>"  type="hidden" value="3">
	</wea:item>
	<%} %>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%><!--显示内容--></wea:item>
	<wea:item>
		
		<TABLE class="viewform" width="100%">
			<TBODY>
				<TR>
					<TD style="position:relative;">
						<table style="width:100%;">
						
						<%
						for(int i=0;i<list.size();i++){
							String[] msg = ((String)list.get(i)).split(",");
							String item = msg[0];
							String itemChk = "on".equals(msg[1])? "checked":"";
							String color = msg[2];
							int label = Integer.parseInt(msg[3]);
						%>
							<tr>
								<td style="height:25px !important;">
									<INPUT name="<%=item%>_<%=eid%>" id="<%=item%>_<%=eid%>" type="checkbox" <%=itemChk%>/><span><%=SystemEnv.getHtmlLabelName(label,user.getLanguage())%></span>
									&nbsp;<span id="<%=item%>" onclick="chooseColor(this)" class="colorspan" style="background:<%=color%>;"></span>
									<input type='hidden' id="<%=item%>color_<%=eid%>" name="<%=item%>color_<%=eid%>" value="<%=color%>"/>
								</td>
							</tr>
						<%}%>							
						</table>
						<div class="chooseColor" onmouseleave="$(this).hide();" item="" style="position:absolute;display:none;border:1px solid #DBDBDB;z-index:999;background:#fff;">
							<ul class="colorul">
								<li onclick="colorCheck(this,<%=eid%>)" color="#33A3FF" style="background:#33A3FF;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#FFD200" style="background:#FFD200;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#FD9000" style="background:#FD9000;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#CB61FE" style="background:#CB61FE;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#6871E3" style="background:#6871E3;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#56DE73" style="background:#56DE73;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#FD2677" style="background:#FD2677;"></li>
								<li onclick="colorCheck(this,<%=eid%>)" color="#FF66FF" style="background:#FF66FF;"></li>
							</ul>
						</div>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</wea:item>
	</wea:group>
</wea:layout>
<SCRIPT LANGUAGE="JavaScript">
	
	
	
	function   CheckNum() 
	{ 
		if (Window.event.keyCode==39) 
			{ 
			window.event.keyCode=0; 
			} 
	} 
	
	
	
	/*
	function chooseColor(obj){
		$(".chooseColor").hide();
		$(".chooseColor").attr("item","");
		var item = $(obj).attr("id");
		var top = $(obj).position().top;
		var left = $(obj).position().left+20;
		$(".chooseColor").attr("item",item);
		$(".chooseColor").css("top",top);
		$(".chooseColor").css("left",left);
		//$(".chooseColor").show();
		$(".chooseColor").fadeIn(600);
	}
	
	$(document).ready(function(){
		$(".colorul li").bind("click",function(){
			var item = $(".chooseColor").attr("item");
			var color = $(this).attr("color");
			$("#"+item+"color_"+<%=eid%>).val(color);
			$("#"+item).css("background",color);
			$(".chooseColor").hide();
		})
		$(".chooseColor").bind("mouseleave",function(){
			$(".chooseColor").hide();
		})
	})
	*/
</SCRIPT>
<Style type="text/css">

</Style>

	
