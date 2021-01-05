
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.mobile.webservices.workflow.soa.RequestStatusLog" %>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

//2015/12/07 获取次账号信息
//User user = HrmUserVarify.getUser(request , response) ;
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

int workflowid =  Util.getIntValue(request.getParameter("workflowid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int desrequestid = Util.getIntValue(request.getParameter("desrequestid"), 0);
String isurger = Util.null2String(request.getParameter("isurger"));
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);

RequestStatusLog reqstatusLog = new RequestStatusLog(String.valueOf(workflowid), String.valueOf(requestid));
reqstatusLog.setUser(user);
reqstatusLog.setDesrequestid(desrequestid);
reqstatusLog.setIsurger(isurger);

List<Map<String, String>> statuslogs = reqstatusLog.getStatusLog();
//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<style type="text/css">
		#header {
			width:100%;
			background: -moz-linear-gradient(top, white, #ECECEC);
			filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
			background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
			background: -moz-linear-gradient(top, white, #ECECEC);
			border-bottom: #CCC solid 1px;
			/*filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;*/
			position:relative;
		}
		.TableListStyle TH { 
			color: #4f6b72; 
			border-right: 1px solid #C1DAD7; 
			border-bottom: 1px solid #C1DAD7; 
			border-top: 1px solid #C1DAD7; 
			letter-spacing: 2px; 
			text-transform: uppercase; 
			text-align: left; 
			padding: 6px 6px 6px 12px; 
			background: #CAE8EA  no-repeat; 
			font-size:12px;
		} 
		
		.TableListStyle TD { 
			background: #fff; 
			padding: 6px 6px 6px 12px; 
			color: #4f6b72; 
			border-right: 1px solid #C1DAD7; 
			border-bottom: 1px solid #C1DAD7;
		} 
		
		.TableListStyle TR.rowf TD {
		}
		
		.TableListStyle TR.rowt TD {
		}
		
		.TableListStyle TR.datadark TD {
			background-color:#F5FAFA;
		}
		
		body{
			background: white!important;
		}
		</style>
<script type="text/javascript">

    var f_weaver_belongto_userid = '<%=f_weaver_belongto_userid%>';
    var f_weaver_belongto_usertype = '<%=f_weaver_belongto_usertype%>';
	function goWfForm() {
		//window.location.href = "/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
		
	    var locationHref = "/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
	    
	    try{
	        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	    }catch(e){
	    }
	    window.location.href = locationHref;
	}
	function goWfPic() {
		//window.location.href = "/mobile/plugin/1/workflowPicture.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
		
        var locationHref = "/mobile/plugin/1/workflowPicture.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
        
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        window.location.href = locationHref;
	}
	
	function doLeftButton() {
		if(<%=fromRequestid%> > 0 || "<%=fromES%>"=="true"){
			goBack();
			return 1;
		}
	}

	function goBack() {
		if(<%=fromRequestid%> > 0){
			//location = "/mobile/plugin/1/view.jsp?requestid=<%=fromRequestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
			
	        var locationHref = "/mobile/plugin/1/view.jsp?requestid=<%=fromRequestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
	        
	        try{
	            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	        }catch(e){
	        }
	        location = locationHref;
		} else {
			var fromES="<%=fromES%>";
			if(fromES=="true"){
				 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
			}else{
				location = "/list.do?module=<%=module%>&scope=<%=scope%>";
			}
		}
	}
</script>
	</head>
	
	<body style="margin:0px;">


<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width:100%;height:40px;font-size:13px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						<%-- 返回 --%>
                        <%=SystemEnv.getHtmlLabelName(83823,user.getLanguage()) %>
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title">
					
					<%-- 流程状态 --%>
                        <%=SystemEnv.getHtmlLabelName(19061,user.getLanguage()) %>
					</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>


	<div id="header" style="height:30px;padding-top:3px;">
		
		<div style="width:182px;height:25px;margin-right:auto;margin-left:auto;-webkit-border-radius:3px;-moz-border-radius:3px;text-align:center;color:#000;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#FEFEFE',endColorstr='#D1D1D1' );background: -webkit-gradient(linear, left top, left bottom, from(#FEFEFE),to(#D1D1D1) );background: -moz-linear-gradient(top, #FEFEFE, #D1D1D1);border: #A4A4A4 solid 1px;">
			<a href="javascript:goWfForm();">
			<div style="float:left;width:60px;height:25px;line-height:25px;border-right: #A4A4A4 solid 1px;">
			
            <%-- 表单 --%>
            <%=SystemEnv.getHtmlLabelName(31923,user.getLanguage()) %>
			</div>
			</a>
			<a href="javascript:goWfPic();">
			<div style="float:left;width:60px;height:25px;line-height:25px;">
			
            <%-- 流程图 --%>
            <%=SystemEnv.getHtmlLabelName(18912,user.getLanguage()) %>
			</div>
			</a>
			
			<div style="float:right;width:60px;height:25px;line-height:25px;border-left: #A4A4A4 solid 1px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#D1D1D1',endColorstr='A4A4A4' );background: -webkit-gradient(linear, left top, left bottom, from(#D1D1D1),to(#A4A4A4) );background: -moz-linear-gradient(top, #D1D1D1, #A4A4A4);">
			
            <%-- 状态 --%>
            <%=SystemEnv.getHtmlLabelName(126034,user.getLanguage()) %>
			</div>
					
		</div>
	
	</div>


		<div id="content">
			<table cellpadding="0" cellSpacing="0" border="0" width="100%" class="TableListStyle">
				<colgroup>
					<col width="20%"/><col width="20%"/><col width="20%"/><col width="40%"/>
				</colgroup>
				<tr class="Header">
				    <th rowspan="2">
			            <%-- 节点 --%>
			            <%=SystemEnv.getHtmlLabelName(33417,user.getLanguage()) %>
				    </th>
				    <th>
                        <%-- 操作者 --%>
                        <%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %>
				    </th>
				    <th>
				        
                        <%-- 状态 --%>
                        <%=SystemEnv.getHtmlLabelName(602,user.getLanguage()) %>
				    </th>
				    <th>
                        <%-- 接收时间 --%>
                        <%=SystemEnv.getHtmlLabelName(18002,user.getLanguage()) %>
				    </th>
				</tr>
				<tr class="Header">
				    <th colspan="2">
                        <%-- 操作耗时 --%>
                        <%=SystemEnv.getHtmlLabelName(18003,user.getLanguage()) %>
				    </th>
				    <th>
                        <%-- 操作时间 --%>
                        <%=SystemEnv.getHtmlLabelName(15502,user.getLanguage()) %>
				    </th>
				</tr>
				
				<%
				boolean lineflag = true;
				String oldNodeName = "";
				for (Iterator<Map<String, String>> it=statuslogs.iterator(); it.hasNext();) {
					Map<String, String> statuslog = it.next();
					String nodeName = statuslog.get("nodeName");
					
					if (nodeName.equals(oldNodeName)) {
						nodeName = "";
					}
					
					lineflag = !lineflag;
					oldNodeName = nodeName;
					
				%>
					<tr class="rowf <%=lineflag ? "DataLight" : "datadark" %>">
						<td rowspan="2"><%=nodeName %></td>
						<td><%=statuslog.get("username") %></td>
						<td><span style="color:<%=statuslog.get("color") %>"><%=statuslog.get("status") %></span></td>
						<td><%=Util.null2String(statuslog.get("receivingTime")) %></td>
					</tr>
					<tr class="rowt <%=lineflag ? "DataLight" : "datadark" %>">
						<td colspan="2"><%=statuslog.get("intervel") %></td>
						<td><%=Util.null2String(statuslog.get("operateTime")) %></td>
					</tr>
				
				<%
				}
				%>
			</table>
		</div>
		
</div>
</body>
</html>