<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<!DOCTYPE HTML>
<HTML>
<HEAD>
<TITLE><%=SystemEnv.getHtmlLabelNames("674,34182",7) %></TITLE>
<META NAME="Generator" CONTENT="EditPlus">
<META NAME="Author" CONTENT="">
<META NAME="Keywords" CONTENT="">
<META NAME="Description" CONTENT="">
<%
RTXConfig rtxConfig = new RTXConfig();
String gopage = request.getParameter("gopage");
String rtxLoginToOA = rtxConfig.getPorp("rtxLoginToOA");
%>


<SCRIPT language="JavaScript">
function on_body_load()
{
	
		var objApi = new ActiveXObject("RTXClient.RTXAPI")
		var objKernal = objApi.GetObject("KernalRoot")
		var Account = objKernal.Account
		if(Account == ""){
		  alert("您未登录RTX，请先登录RTX");
		}
		else
		{
		 
		  getUrl(Account);
		}
	
}
	
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    	ajax = new XMLHttpRequest();
    }
    return ajax;
}
function getUrl(obj){
	var ajax = ajaxinit();
	var gopage = "<%=gopage%>";
    ajax.open("POST", "/login/VerifyRtxClientLogin.jsp?gopage="+gopage, true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("loginid="+obj);
    //获取执行状态
    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里
        if (ajax.readyState == 4 && ajax.status == 200) {
            try {
            	var nurl= ajax.responseText;
            	if((ajax.responseText).replace(/^\s+|\s+$/g, "") == 'false'){
            		nurl = "/notice/noright.jsp";
            	}
                window.location = nurl;                
            }catch(e){}
        }
    }
}
</SCRIPT>
</HEAD>
<BODY 
<%
if("1".equals(rtxLoginToOA)){
%>
onLoad="on_body_load()"
<%	
}
%>

>
<OBJECT classid=clsid:5EEEA87D-160E-4A2D-8427-B6C333FEDA4D id=RTXCLIENT></OBJECT>
</BODY>
</HTML>
