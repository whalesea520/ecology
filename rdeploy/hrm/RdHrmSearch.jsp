<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    
    /*用户验证*/
    User user = HrmUserVarify.getUser (request , response) ;
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
    String imagefilename = "/images/hdDOC_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(179,user.getLanguage());
    int isIncludeToptitle =1;
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
		
		<script>
			$(function () {
				//$('input').placeholder({isUseSpan:true});
				__jNiceNamespace__.beautySelect();
				$("span[id^=sbHolderSpan_]").css("max-width", "100%");
			});
		</script>
	</head>

	<body style="margin:0px;padding:0px;overflow: hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:commit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
	<form class=ViewForm id="resource" name="resource" method="post" action="/hrm/search/HrmResourceSearchTmp.jsp">
	<input name=searchForm type="hidden" value="hrmResource">
		<div id="content" style="position:absolute;left:50%;width:560px;margin-top:33px;margin-left:-280px;">
			

			
			<div class="rowbock2cell">
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="237px"><col width="20px"><col width="*">
					</colgroup>
					<tr>
						<td>
							<div class="rowbock rowwidth2">
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft1">
									<input class="rowinputtext" type="text" name="resourcename" id="resourcename">
								</div>
							</div>
						</td>
						<td></td>
						<td>
							<div class="rowbock rowwidth2">
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(125238,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft1">
									<input class="rowinputtext" type="text" name="mobile" id="mobile">
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1" >
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft1">
									<span id="createid" style=""> <brow:browser
											viewType="0" name="department" browserValue="" width="470px!important"
											browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
											hasInput="true" isSingle="false" hasBrowser="true"
											isMustInput='1' completeUrl="/data.jsp?type=4"
											temptitle=""></brow:browser>
									</span>
								</div>
			</div>
			
			
			
			
			<div class="searchline"></div>
			
			
			
			<div class="rowbock rowwidth1" >
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft1">
									<span id="createid" style=""> <brow:browser
											viewType="0" name="jobtitle" browserValue="" width="470px!important"
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput='1' completeUrl="/data.jsp?type=hrmjobtitles"
											temptitle=""></brow:browser>
									</span>
								</div>
			</div>
			
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1" >
								<span class="rowtitle"><%=SystemEnv.getHtmlLabelName(15709 ,user.getLanguage())%></span>
								<div class="rowinputblock rowinputblockleft2">
									<span id="createid" style=""> <brow:browser
											viewType="0" name="manager" browserValue="" width="457px!important"
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?selectedids="
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput='1' completeUrl="/data.jsp"
											linkUrl=""
											temptitle=""></brow:browser>
									</span>
								</div>
			</div>
			
			<div class="searchline"></div>
			
			<div class="rowbock rowwidth1">
				<span class="rowtitle" style=""><%=SystemEnv.getHtmlLabelName(125239,user.getLanguage())%></span>
				<div class="rowinputblock rowinputblockleft2">
					<input class="rowinputtext" type="text" name="telephone" id="telephone">
				</div>
			</div>
			
			
			<div class="rowbock2cell">
				<div style="width:495px;margin-top:40px;">
				<span class="searchbtn searchbtn_cl" onclick="reset()">
					<%=SystemEnv.getHtmlLabelName(125240,user.getLanguage())%>
				</span>
				
				<span class="searchbtn searchbtn_rht" onclick="commit()">
					<%=SystemEnv.getHtmlLabelName(125241,user.getLanguage())%>		
				</span>
			</div>
			</div>
			
		</div>
		</form>
		<script type="text/javascript">
			function reset(){
			  $("#resourcename").val("");
			  $("#mobile").val("");
			  $("#telephone").val("");
			  _writeBackData('department','1',{'id':'','name':''});
			  _writeBackData('jobtitle','1',{'id':'','name':''});
			  _writeBackData('manager','1',{'id':'','name':''});
			}
			
			function commit(){
				resource.submit();
			}
		</script>
	</body>
</html>
