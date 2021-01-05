
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="java.io.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!DOCTYPE html>
<%
	if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
%>
<%@ include file="/workflow/request/CommonUtils.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+ $label(86,user.getLanguage()) +",javascript:doSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
	RecordSet.executeSql("select * from crm_customerSettings where id=-1");
	RecordSet.first();
	//创建客户时，是否提醒
	String CRM_addRemind=Util.null2String(RecordSet.getString("crm_rmd_create"));//是否开启创建客户提醒。             Y：开启，    N：关闭
    String CRM_addRemindTo=Util.null2String(RecordSet.getString("crm_rmd_create2"));//创建客户提醒对象。            1：直接上级，2：所有上级
  	//创建商机时，是否提醒
	String Sell_addRemind=Util.null2String(RecordSet.getString("sell_rmd_create"));//是否开启创建商机提醒。             Y：开启，    N：关闭
    String Sell_addRemindTo=Util.null2String(RecordSet.getString("sell_rmd_create2"));//创建商机提醒对象。            1：直接上级，2：所有上级
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>

		<script>
			function doSave(){
				$('#weaver').submit();
			}
		</script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="customer"/>
		   <jsp:param name="navName" value="<%=$label(84236,user.getLanguage()) + $label(31811,user.getLanguage())%>"/>
		</jsp:include>

		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">				
					<input id="btnSave" type="button" value="<%=$label(86,user.getLanguage()) %>" class="e8_btn_top" onclick="doSave()" />
					<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>

		<form id="weaver" name="frmmain" action="CustomerSettingsOperation.jsp" method="post" >
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(21946,user.getLanguage())%>' attributes="{'class':'e8_title e8_title_1'}">
					<!-- 客户提醒 -->
					<wea:item>
						<%=$label(15006,user.getLanguage())+$label(21946,user.getLanguage())%>
					</wea:item>				
					<wea:item>
					    <script>
					       $(function(){
					       	checkImgStatus()
					       });
					       function checkImgStatus(){
					          if($("#CRM_addRemind").is(":checked")){
					          	showEle("noImg");
					          	$("#signbtn").show();
					          }else{
					            hideEle("noImg");
					            $("#signbtn").hide();
					          }
					       }
					    </script>
						<input type="checkbox" id='CRM_addRemind' onclick="checkImgStatus()" name="CRM_addRemind" <%if(null != CRM_addRemind&&CRM_addRemind.equals("Y")){%>checked<%}%> value="Y" tzCheckbox="true">
					</wea:item>
					
					<wea:item attributes="{'samePair':'noImg'}">
						<%=$label(15006,user.getLanguage())+$label(18013,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<select id='CRM_addRemindTo' name="CRM_addRemindTo">
						  <option value="2" <%if(null!=CRM_addRemindTo&&CRM_addRemindTo.equals("2")){%>selected<%}%>><%=$label(15762,user.getLanguage()) %></option>
						  <option value="1" <%if(null!=CRM_addRemindTo&&CRM_addRemindTo.equals("1")){%>selected<%}%>><%=$label(15709,user.getLanguage()) %></option>
						</select>
					</wea:item>
					<div><br/></div>
					<!-- 商机提醒 -->
					<wea:item>
						<%=$label(124910,user.getLanguage())+$label(21946,user.getLanguage())%>
					</wea:item>				
					<wea:item>
					    <script>
					       $(function(){
					       	checkSellImgStatus()
					       });
					       function checkSellImgStatus(){
					          if($("#Sell_addRemind").is(":checked")){
					          	showEle("sellNoImg");
					          	$("#signbtn").show();
					          }else{
					            hideEle("sellNoImg");
					            $("#signbtn").hide();
					          }
					       }
					    </script>
						<input type="checkbox" id='Sell_addRemind' onclick="checkSellImgStatus()" name="Sell_addRemind" <%if(null != Sell_addRemind&&Sell_addRemind.equals("Y")){%>checked<%}%> value="Y" tzCheckbox="true">
					</wea:item>
					
					<wea:item attributes="{'samePair':'sellNoImg'}">
						<%=$label(124910,user.getLanguage())+$label(18013,user.getLanguage())%>
					</wea:item>
					<wea:item attributes="{'samePair':'sellNoImg'}">
						<select id='Sell_addRemindTo' name="Sell_addRemindTo">
						  <option value="2" <%if(null!=Sell_addRemindTo&&Sell_addRemindTo.equals("2")){%>selected<%}%>><%=$label(15762,user.getLanguage()) %></option>
						  <option value="1" <%if(null!=Sell_addRemindTo&&Sell_addRemindTo.equals("1")){%>selected<%}%>><%=$label(15709,user.getLanguage()) %></option>
						</select>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
	</body>
</html>
