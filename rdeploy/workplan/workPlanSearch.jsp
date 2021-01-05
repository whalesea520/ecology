<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
    String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
	String createrId = Util.null2String(request.getParameter("createrid"));  //提交人
	String receiveType = Util.null2String(request.getParameter("receiveType"));  //接受类型  1：人力资源 5：分部 2：部门
	String receiveID = Util.null2String(request.getParameter("receiveID"));  //接收ID
	String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<base href="<%=basePath%>">

		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/lang/weaver_lang_<%=user.getLanguage()%>_wev8.js"></script>
		<script type="text/javascript" src="/rdeploy/assets/js/jquery.enplaceholder_wev8.js"></script>
		<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
		<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" rel="stylesheet" type="text/css">
		<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" rel="stylesheet" type="text/css">
		
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		
		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
		
		<link rel="stylesheet" type="text/css" href="/js/poshytip-1.2/tip-yellowsimple/tip-yellowsimple_wev8.css" />
		<link rel="stylesheet" type="text/css" href="/rdeploy/assets/css/search.css" />
		
		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
		<script language="javascript" type="text/javascript" src="/js/init_wev8.js"></script>
		
		
		<!-- 日历控件 -->
		<link href="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.css" rel="stylesheet">
      	
      	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs3.css" />
	  	<link rel="stylesheet" type="text/css" media="all" href="/wui/common/jquery/plugin/daterangepicker/daterangepicker-bs4.css" />
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/bootstrap.min.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/moment.js"></script>
      	<script type="text/javascript" src="/wui/common/jquery/plugin/daterangepicker/daterangepicker.js"></script>
		
		<script>
			$(function () {
				$("#planname")[0].focus();
				//$('input').placeholder({isUseSpan:true});
				__jNiceNamespace__.beautySelect();
				$("span[id^=sbHolderSpan_]").css("max-width", "95%");
				
				$("#date").daterangepicker({separator : " - "}, function(start, end, label) {
                    //console.log(start, end, label);
                    $("#begindate").val(start);
                    $("#enddate").val(end);
                });
                
                $(".rowtitle").on("click", function (e) {
                	var inputobj = $(this).next().children("input");
                	var sltobj = $(this).next().children("span[id^=sbHolderSpan_]").find("[id^=sbToggle_]");
                	var browobj = $(this).next().find("div[id^=inner][id$=div]");
                	if (!!browobj[0]) {
                		browobj[0].click();
                	}
                	inputobj.trigger("focus");
                	sltobj.trigger("click");
                	if (!!inputobj[0]) {
                		inputobj[0].click();
                	}
                	e.stopPropagation();
                });
			});
			
			function doSearch() {
				/*
				if (!checkDateValid("begindate", "enddate")) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(54,user.getLanguage())%>");
					return;
				}
				*/
				document.frmmain.submit();
			}
			
			
			/**
			*清空搜索条件
			*/
			function resetCondtionAVS(){
				$("#begindate, #enddate").val("");
				$("select").val("");
				$("select").trigger("change");
				$("select").selectbox('detach');
				$("select").selectbox('attach');
				$("span[id^=sbHolderSpan_]").css("max-width", "95%");
				//清空文本框
				$("input[type='text']").val("");
				//清空浏览按钮及对应隐藏域
				$(".Browser").siblings("span").html("");
				$(".Browser").siblings("input[type='hidden']").val("");
				$(".e8_os").find("input[type='hidden']").val("");
				$(".e8_outScroll .e8_innerShow span").html("");
				
				$("#planname")[0].focus();
				
			}
		</script>
	</head>

	<body style="margin:0px;padding:0px;">
	
	<FORM id="frmmain" name="frmmain" method="post" action="/workplan/search/WorkPlanSearchResult.jsp">
		<input type="hidden" name="isFirst" id="isFirst" value="0"/>
		<input type="hidden" name="simpleSearch" id="isFirst" value="1"/>
		<input type="hidden" name="simpleSearch" id="isFirst" value="1"/>
		<input type="hidden" name="timeSag" id="isFirst" value="6"/>
		<div id="content" style="position:absolute;left:50%;width:560px;margin-top:33px;margin-left:-280px;">
			

			<div class="rowbock rowwidth1">
				<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></span>
				<div class="rowinputblock rowinputblockleft1">
					<INPUT type="text" class="rowinputtext" name="planname" id="planname" tabindex="0">
				</div>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock2cell">
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="237px"><col width="20px"><col width="*">
					</colgroup>
					<tr>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft2">
									<select name="urgentlevel" style="width:100%;">
										<OPTION value="" <%if(!"1".equals(urgentLevel) && !"2".equals(urgentLevel) && !"3".equals(urgentLevel)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
										<OPTION value="1" <%if("1".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
										<OPTION value="2" <%if("2".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
										<OPTION value="3" <%if("3".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
									</SELECT>
								</div>
							</div>
						</td>
						<td></td>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft2">
									<SELECT name="plantype" style="width:100%;">
										<OPTION value="" <%if("".equals(planType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
										<%
											RecordSet rs = new RecordSet();
								  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
								  			while(rs.next())
								  			{
								  		%>
								  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" <%if(planType.equals(rs.getString("workPlanTypeID"))) {%>selected<%}%>><%= rs.getString("workPlanTypeName") %></OPTION>
								  		<%
								  			}
								  		%>
									</SELECT>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			
			
			
			<div class="searchline"></div>
			
			
			
			<div class="rowbock2cell">
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="237px"><col width="20px"><col width="*">
					</colgroup>
					<tr>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft3">
									<SELECT name="planstatus" style="width:100%;">
										<OPTION value="" <%if(!"1".equals(planStatus) && !"2".equals(planStatus) && !"0".equals(planStatus)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
										<OPTION value="0" <%if("0".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(16658,user.getLanguage())%></OPTION>
										<OPTION value="1" <%if("1".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></OPTION>
										<OPTION value="2" <%if("2".equals(planStatus) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></OPTION>		
									</SELECT>
								</div>
							</div>
						</td>
						<td></td>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
									<span id="createid" style="">
										<brow:browser viewType="0" name="createrid" browserValue="<%=createrId%>" 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
										completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
										browserSpanValue="<%= Util.toScreen(resourceComInfo.getResourcename(createrId),user.getLanguage()) %>"></brow:browser>
									</span>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div class="searchline"></div>
			
			<div class="rowbock2cell">
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="237px"><col width="20px"><col width="*">
					</colgroup>
					<tr>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle" style="cursor:pointer;"><%=SystemEnv.getHtmlLabelName(96,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft3">
									<input class="rowinputtext" type="text" id="date" readonly="readonly" style="cursor:pointer;">
									<INPUT type="hidden" name="begindate" id="begindate" value="">  
								    <INPUT type="hidden" name="enddate" id="enddate" value="">
								</div>
							</div>
						</td>
						<td></td>
						<td>
							<div class="rowbock rowwidth2" style="float:left;">
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft4 rowinputblock-brow-ie8">
									<span id="recid" style="">
										<INPUT type="hidden" name="receiveType" value="1" />
										<brow:browser viewType="0" name="receiveID" browserValue="<%=receiveID%>" 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
										completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
										browserSpanValue="<%= Util.toScreen(resourceComInfo.getResourcename(receiveID),user.getLanguage()) %>"></brow:browser>
									</span>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			
			<div style="width:495px;margin-top:40px;">
				<span class="searchbtn searchbtn_cl" onclick="resetCondtionAVS()">
					<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>
				</span>
				
				<span class="searchbtn searchbtn_rht" onclick="doSearch();">
					<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>	
				</span>
			</div>
		</div>
		
		</FORM>
		
	</body>
</html>
