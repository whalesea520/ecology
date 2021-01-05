
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>

<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser(request , response);
if(user == null)  return ;

int detailid = Util.getIntValue((String)request.getParameter("detailid"));
String from = Util.null2String((String)request.getParameter("from"));
String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>按组织查询</title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
</head>
<body>

<div id="view_page">

	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width: 100%; height: 40px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						返回
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title">按组织查看</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>

	<div id="orglist" style="width:100%;height:100%;background:#E0E0E0;">
	
	</div>

</div>

<div id="loading">正在加载数据，请稍等...</div>
<div id="loadingmask" class="ui-widget-overlay"></div>

<script type="text/javascript">
$(document).ready(function() {
	
	$.ajaxSetup({ cache: false });
	
	clickOrg(0,0);
	
	$( "#loading" ).hide();
	$( "#loadingmask" ).hide();
	
});

function clickOrg(type,id) {
	if(type==0&&id==0) {
		$("#orglist").html('<div style="position:relative;height:35px;line-height:38px;padding-left:30px;"><div style="position:absolute;top:8px;height:20px;line-height:20px;"><img height="20" src="/mobile/plugin/6/images/waiting_wev8.gif"></div><div style="position:absolute;top:4px;left:50px;height:30px;line-height:30px;">正在读取数据...</div></div>');

		var url = "/mobile/plugin/6/get.jsp?module=<%=module%>&scope=<%=scope%>&from=<%=from%>&detailid=<%=detailid%>&unit=1&ot="+type+"&o="+id;
		$.get(url, function(data) {
	    	
			if(data.indexOf('{"error":')==0) {
				var errormsg = eval('(' + data + ')').error;
				if(errormsg&&errormsg.length>0) {
					alert(errormsg);
					location = "/login.do";
					return;
				}
			}
			
			if(data.trim().length>0) {
			
				var doms = $(data);
				
				$("#orglist").html("");
				
		    	for(var i=0;i<doms.length;i++) {
		    		var dom = doms[i];
		   			
		    		if(dom && dom.tagName) {
		    			if(dom.tagName=="META") {
		    			} else if(dom.tagName=="TITLE") {
		    			} else if(dom.tagName=="SCRIPT") {
		    			} else if(dom.tagName=="LINK") {
		    			} else if(dom.tagName=="STYLE") {
		    			} else if(dom.tagName && dom.outerHTML) {
		    				$("#orglist").append(dom.outerHTML);
		    			}
		    		}
		    	}
			} else {
				$("#orglist").html("");
			}
		});

	} else if(type==3&&id>0) {
		
	} else {
		if($("#t_"+type+"_"+id).attr("expand")==1){
			$("#s_"+type+"_"+id).hide();
			$("#t_"+type+"_"+id).attr("expand","0");
			if($("#t_"+type+"_"+id).find("img").length>1) $("#t_"+type+"_"+id).find("img")[1].src="/mobile/plugin/6/images/icon4_wev8.png";
		} else {
			$("#s_"+type+"_"+id).show();
			$("#t_"+type+"_"+id).attr("expand","1");
			if($("#t_"+type+"_"+id).find("img").length>1) $("#t_"+type+"_"+id).find("img")[1].src="/mobile/plugin/6/images/icon5_wev8.png";
			if($("#t_"+type+"_"+id).attr("isload")==0) {
				
				var ileft = parseInt($("#i_"+type+"_"+id).css("left"),0);
				var lleft = parseInt($("#l_"+type+"_"+id).css("left"),0);
				
				$("#s_"+type+"_"+id).html('<div style="position:relative;height:35px;line-height:38px;padding-left:30px;"><div style="position:absolute;top:8px;height:20px;line-height:20px;"><img height="20" src="/mobile/plugin/6/images/waiting_wev8.gif"></div><div style="position:absolute;top:4px;left:50px;height:30px;line-height:30px;">正在读取数据...</div></div>');

				var url = "/mobile/plugin/6/get.jsp?module=<%=module%>&scope=<%=scope%>&from=<%=from%>&detailid=<%=detailid%>&unit=1&ot="+type+"&o="+id;
				$.get(url, function(data) {
			    	
					if(data.indexOf('{"error":')==0) {
						var errormsg = eval('(' + data + ')').error;
						if(errormsg&&errormsg.length>0) {
							alert(errormsg);
							location = "/login.do";
							return;
						}
					}
					
					if(data.trim().length>0) {
					
						var doms = $(data);
						
						$("#s_"+type+"_"+id).html('');
						
				    	for(var i=0;i<doms.length;i++) {
				    		var dom = doms[i];
				   			
				    		if(dom && doms[i].tagName) {
				    			
				    			if(dom.tagName=="META") {
				    			} else if(dom.tagName=="TITLE") {
				    			} else if(dom.tagName=="SCRIPT") {
				    			} else  if(dom.tagName=="LINK") {
				    			} else if(dom.tagName=="STYLE") {
				    			} else if(dom.tagName && dom.outerHTML) {
				    				$("#s_"+type+"_"+id).append(dom.outerHTML);
				    			}

				    			if($("#i"+dom.id.substring(1)).length>0) 
				    				$("#i"+dom.id.substring(1)).css("left",(ileft+20)+"px");
				    			if($("#l"+dom.id.substring(1)).length>0) 
				    				$("#l"+dom.id.substring(1)).css("left",(lleft+20)+"px");
				    			if($("#b"+dom.id.substring(1)).length>0) 
				    				$("#b"+dom.id.substring(1)).css("left",(ileft+0)+"px");
				    			

				    		}
				    	}
				    	
				    	$("#t_"+type+"_"+id).attr("isload","1");
					} else {
						$("#s_"+type+"_"+id).html('');
					}
				});
				
			}
		}
	}
}

function goBack() {
	location = "/list.do?module=<%=module%>&scope=<%=scope%>";
}

</script>

</BODY>
</HTML>