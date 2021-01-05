
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- added by wcd 2014-09-25 [自定义设置] -->
<%@ include file="/hrm/header.jsp" %>
<%@page import="weaver.hrm.chart.domain.*"%>
<jsp:useBean id="HrmChartSetManager" class="weaver.hrm.chart.manager.HrmChartSetManager" scope="page" />
<%
    String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(32470,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isDialog = Util.null2String(request.getParameter("isdialog"),"1");
	String fromid = Util.null2String(request.getParameter("fromid"));
	String cmd = Util.null2String(request.getParameter("cmd"));
	int showtype = Util.getIntValue(request.getParameter("showtype"),0);
	int shownum = Util.getIntValue(request.getParameter("shownum"),1);
	String showmode = Util.null2String(request.getParameter("showmode"),"down");
	showmode = showmode.equals("mfchart") ? "down" : showmode;
	Map map = new HashMap();
	map.put("is_sys",1);
	HrmChartSet bean = HrmChartSetManager.get(map);
	boolean isNew = false;
	if(bean == null){
		bean = new HrmChartSet();
		bean.setIsSys(1);
		isNew = true;
	}
    if(cmd.equals("save") && fromid.equals("system")){
		bean.setAuthor(user.getUID());
		bean.setShowType(showtype);
		bean.setShowNum(shownum);
		bean.setShowMode(showmode);
		if(isNew){
			HrmChartSetManager.insert(bean);
		}else{
			HrmChartSetManager.update(bean);
		}
	} else if(cmd.length()==0 || !fromid.equals("resource")){
		if(!isNew){
			showtype = bean.getShowType();
			shownum = bean.getShowNum();
			showmode = bean.getShowMode();
		}
	}
	shownum = shownum <= 0 ? 1 : shownum;
%>

<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css"/>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=cmd%>"=="save"){
				parentWin.shownum = "<%=shownum%>";
				parentWin.showtype = "<%=showtype%>";
				parentWin.showmode = "<%=showmode%>";
				parentWin.closeDialog();
			}
			
			function changeType(showtype){
				$GetEle("shownum").style.display = showtype == 1 ? "block" : "none";
			}
			
			function doSave(){
				$GetEle("formmain").submit();
			}
		</script>
	</head>
	<body>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<iframe id="checkHas" style="display:none"></iframe>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM ID=formmain name=formmain action="OrgChartSet.jsp" METHOD=POST >
			<input type="hidden" name="cmd" value="save">
			<input type="hidden" name="fromid" value="<%=fromid%>">
			<input type=hidden name=operationType>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
						<%--<wea:item><%=SystemEnv.getHtmlLabelNames("89,1818",user.getLanguage())%></wea:item>
						<wea:item>
							<table style="width:100%"><tr>
								<td style="width:30%">
									<select class="InputStyle" id="showmode" name="showmode" style="width:100px">
										<option value="down" <%=showmode.equals("down")?"selected":""%>><%=SystemEnv.getHtmlLabelName(23010,user.getLanguage())%></option>
										<option value="right" <%=showmode.equals("right")?"selected":""%>><%=SystemEnv.getHtmlLabelName(22988,user.getLanguage())%></option>
									</select>
								</td>
								<td style="width:70%"></td>
							</tr></table>
						</wea:item>--%>
						<wea:item><%=SystemEnv.getHtmlLabelNames("89,15836",user.getLanguage())%></wea:item>
						<wea:item>
							<table style="width:100%"><tr>
								<td style="width:30%">
									<select class="InputStyle" id="showtype" name="showtype" onchange="changeType(this.value);" style="width:100px">
										<option value="0" <%=showtype==0?"selected":""%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="1" <%=showtype==1?"selected":""%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%></option>
									</select>
								</td>
								<td style="width:70%">
									<input class="InputStyle" type="text" id="shownum" name="shownum" value="<%=shownum%>" size="2" maxLength="2" style="display:<%=showtype==1?"block":"none"%>;" onkeypress="if(event.keyCode==13){doSubmit();}" onBlur='checknumber("shownum");'/>
								</td>
							</tr></table>
						</wea:item>
					</wea:group>
			</wea:layout>
		</FORM>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	</body>
</html>
