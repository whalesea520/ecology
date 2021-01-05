<%@ page language="java" contentType="text/html; charset=GBK"%>
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils"%>
<%@ include file="/systeminfo/init.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String logid = StringUtils.null2String(request.getParameter("logid"));
	String loglevel = StringUtils.null2String(request.getParameter("loglevel"));
%>
<html>
  <head>
  	<LINK REL=stylesheet type=text/css HREF=/css/Weaver.css>
	    <SCRIPT language="javascript" src="/js/weaver.js"></script>
		<style>
			#loading{
			    position:absolute;
			    left:45%;
			    background:#ffffff;
			    top:40%;
			    padding:8px;
			    z-index:20001;
			    height:auto;
			    border:1px solid #ccc;
			}
		</style>
  </head>
  <%
 	String imagefilename = "/images/hdSystem.gif";
  	String titlename = "日志明细";
  	String needhelp = "";
  %>
  <body>
  	<%@ include file="/systeminfo/TopTitle.jsp"%>
	<%@ include file="/systeminfo/RightClickMenuConent.jsp"%>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSubmit(),_top} " ;//搜索
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82176,user.getLanguage())+",javascript:doClear(),_top} " ;//清空条件
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu.jsp"%>
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
			<col width="10">
			<col width="">
			<col width="10">
		</colgroup>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
				<TABLE class=Shadow>
					<tr>
						<td valign="top">
						    <form name="frmSearch" method="post" action="/formmode/exttools/impexplogdetail7.jsp">
							    <input type="hidden" name="logid" value="<%=logid %>">
								<table class="ViewForm">
									<colgroup>
										<col width="8%">
										<col width="18%">
									</colgroup>
									<tr>
										<td><%=SystemEnv.getHtmlLabelName(31702,user.getLanguage())%><!-- 日志类型 --></td>
										<td class="Field">
											<select style="width: 100px;" id="loglevel" name="loglevel">
												<option></option>
												<option <%if("0".equals(loglevel)){%>selected="selected"<%} %> value="0">提示</option>
												<!-- <option <%if("1".equals(loglevel)){%>selected="selected"<%} %> value="1">警告</option> -->
												<option <%if("2".equals(loglevel)){%>selected="selected"<%} %> value="2">错误</option>
											</select>
										</td>
									</tr>
								</table>
							</form>
						<%
						String perpage = "15";
						String backFields = "a.id,a.tablename,a.logtype,a.message";
						String sqlFrom = " from mode_impexp_logdetail a ";
						String SqlWhere = " where logid='"+logid+"' ";
						if(!"".equals(loglevel)){
							SqlWhere += " and logtype='"+loglevel+"' ";
						}
						SqlWhere += " and logtype<>1";
						String tableString = ""+
							"<table  pagesize=\""+perpage+"\" tabletype=\"none\" >"+
								"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(SqlWhere)+"\"/>"+
									"<head>"+           
										//相关表名    
										"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(522,user.getLanguage())+SystemEnv.getHtmlLabelName(21900,user.getLanguage())+"\" column=\"tablename\" orderkey=\"tablename\"  />"+
										//日志信息
										"<col width=\"60%\"  text=\""+SystemEnv.getHtmlLabelName(32940,user.getLanguage())+"\" column=\"message\" />"+
										//日志级别
										"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"logtype\" orderkey=\"logtype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.formmode.exttools.impexp.log.LogTransferService.getLogLevel\"/>"+
									"</head>"+
							"</table>";
						%>
						<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>
						</td>
					</tr>
				</TABLE>
			</td>
			<td></td>
		</tr>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
	</table>
  </body>
</html>
<script>
	function doClear(){
		$(".sbSelector").html('');
		$("#loglevel").val('');
	}
	
	function doSubmit(){
	    enableAllmenu();
	    document.frmSearch.submit();
	}
</script>