<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>

<!-- 日期弹出框 -->
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>

<%
		String pt_id=Util.null2String(request.getParameter("pt_id"));//项目类型id
		String plog_qf=Util.null2String(request.getParameter("plog_qf"));//日志类型
		String plog_desc=Util.null2String(request.getParameter("plog_desc"));//操作描述
		String plog_coding=Util.null2String(request.getParameter("plog_coding"));//编号
		//公司id
		String companyid=Util.null2String(request.getParameter("companyid"));
		String fromdate2=Util.null2String(request.getParameter("fromdate2"));
		String todate2=Util.null2String(request.getParameter("todate2"));
		
%>

<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelNames("527",user.getLanguage())+",javascript:onQuery(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
	<jsp:param name="mouldID" value="cpcompany"/>
	<jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>'/>
</jsp:include>

<form name="weoa"  id="weoa"  method="post" action="/cpcompanyinfo/CPLog.jsp">
	<input type="hidden" value="<%=pt_id%>" name="pt_id">
	<input type="hidden" value="<%=plog_qf%>" name="plog_qf">
	<input type="hidden" name="plog_desc_in" id="plog_desc_in" value="<%=plog_desc%>" />
	<input type="hidden" value="<%=companyid%>" name="companyid">	

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("527",user.getLanguage())%>" onclick="onQuery()" />
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		

	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>' attributes="">
			<wea:item><%=SystemEnv.getHtmlLabelName(15503,user.getLanguage()) %></wea:item>		
			<wea:item>
				 <select name="plog_desc" id="plog_desc" onchange='onSelected()' >
					<option value=""  ></option>
					<option value="1" <%if("1".equals(plog_desc)){out.println("selected");} %>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage()) %></option>
					<option value="2" <%if("2".equals(plog_desc)){out.println("selected");} %>><%=SystemEnv.getHtmlLabelName(103,user.getLanguage()) %></option>
					<option value="4" <%if("4".equals(plog_desc)){out.println("selected");} %>><%=SystemEnv.getHtmlLabelName(367,user.getLanguage()) %></option>		
				 </select>
			</wea:item>
			
			<wea:item> <%=SystemEnv.getHtmlLabelName(31131,user.getLanguage()) %></wea:item>
			<wea:item>
				<BUTTON  class="Clock"  type="button"   style="margin-top: 2px"  onclick="gettheDate(document.getElementById('fromdate2'),document.getElementById('fromdatespan2'))"></BUTTON>
			  	<input type="hidden" name="fromdate2"  id="fromdate2"  value="<%=fromdate2%>">
			    <SPAN id=fromdatespan2 ><%=fromdate2%>&nbsp;</SPAN>
			   <BUTTON  class="Clock"  type="button"    onclick="gettheDate(document.getElementById('todate2'),document.getElementById('todatespan2'))"></BUTTON>
			   <input type="hidden" name="todate2"  id="todate2"   value="<%=todate2%>">
			   <SPAN id=todatespan2 ><%=todate2%>&nbsp;</SPAN>
			</wea:item>
			
		</wea:group>
	</wea:layout>
</form>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("33046",user.getLanguage())%>' attributes="">
		<wea:item  attributes="{'isTableList':'true'}">
				
				<%
        		int language=user.getLanguage();
				String refComlog = "column:language";				
					
        		String tableString="";	
				String pagesize="5";
				String backfields=" plog_id,plog_coding,plog_proname,plog_desc,plog_data,plog_time,plog_person,"+language+" as language";
				String fromSql="from  pro_taskLog";
				String sqlorderby="plog_data,plog_time";
				String sqlsortway="desc";
				String sqlwhere=" plog_qf = '3' ";//1，2状态的内容表示是项目管理的日志内容，其他表示其他模块的日志内容
				
				if(!"".equals(companyid)){
					sqlwhere+=" and plog_protaskid='"+companyid+"'";
				}
				
				if(!"".equals(fromdate2)){
					sqlwhere+=" and plog_data >='"+fromdate2+"'";
				}
				if(!"".equals(todate2)){
					sqlwhere+=" and plog_data <='"+todate2+"'";
				}
		
				if(!"".equals(plog_qf))
				{
					sqlwhere+=" and plog_qf='"+plog_qf+"'";
				}
				if(!"".equals(plog_desc))
				{
					sqlwhere+=" and plog_desc='"+plog_desc+"'";
				}
				
				if(!"".equals(plog_coding))
				{
					sqlwhere+=" and plog_coding like '%"+plog_coding+"%'";
				}
				
				tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pagesize=\""+pagesize+"\" width=\"100%\" isfixed=\"true\" isnew= \"true\"   > "+
			    "<checkboxpopedom  popedompara=\"column:plog_id\"  showmethod=\"weaver.promanage.ProTransMethod.getIsShowBox\"/>"+
			    "<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  sqlorderby=\""+sqlorderby+"\"  sqlprimarykey=\"plog_id\" sqlsortway=\""+sqlsortway+"\" sqlisdistinct=\"true\" />"+
			    "<head>"; 	 
			    tableString+=" 	<col   text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage()) +"\" column=\"plog_coding\"    align=\"center\"   	orderkey=\"plog_coding\"			 />";       
		        tableString+="	<col   text=\""+SystemEnv.getHtmlLabelName(31130,user.getLanguage()) +"\"   column=\"plog_proname\"     align=\"center\"   	 	 />";
		        tableString+="	<col   text=\""+SystemEnv.getHtmlLabelName(30585,user.getLanguage()) +"\" otherpara=\""+refComlog+"\"   column=\"plog_desc\"  orderkey=\"plog_desc\"  align=\"center\"     transmethod=\"weaver.cpcompanyinfo.ProTransMethod.getPlog_desc\"  />";        
		        tableString+="	<col   text=\""+SystemEnv.getHtmlLabelName(31131,user.getLanguage()) +"\"   column=\"plog_data\"     align=\"center\"  orderkey=\"plog_data\" />";  
		        tableString+="	<col   text=\""+SystemEnv.getHtmlLabelName(25130,user.getLanguage()) +"\"   column=\"plog_time\"     align=\"center\"   />";  
		        tableString+="	<col   text=\""+SystemEnv.getHtmlLabelName(17482,user.getLanguage()) +"\"   column=\"plog_person\"     align=\"center\"    transmethod=\"weaver.cpcompanyinfo.ProTransMethod.getPlog_person\" />";        
		        tableString+=" </head> </table>";     
				%>
				
			<div style="">
				<wea:SplitPageTag   tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowBottomInfo="true"/>	
			</div>
			
		</wea:item>
	</wea:group>
</wea:layout>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="doCancel(this)">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
	function onQuery(){
		document.getElementById('weoa').submit();
	}
	function doCancel(){
		parentDialog.close();
		//window.close();
	}
	
	function onSelected(){
		var desc = jQuery("#plog_desc").find("option:selected").val();
		jQuery("#plog_desc_in").val(desc);
	}
</script>

<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
</body>
</html>
