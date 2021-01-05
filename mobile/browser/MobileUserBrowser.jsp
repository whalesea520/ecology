
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.mobile.webservices.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.systeminfo.setting.*" %>
<%
String username = request.getParameter("username");
String password = request.getParameter("password");

String onlyselectuser = Util.null2String(request.getParameter("onlyselectuser"));

String flag = request.getParameter("flag");

RecordSet rs = new RecordSet() ;

User user = null;//HrmUserVarify.checkUser (request , response) ;
if(user == null){

	int logintype = 0;
	rs.execute("select * from mobileconfig where mc_type = 7");
	if(rs.next()) {
		logintype = Util.getIntValue(rs.getString("mc_value"),0);
	}
	
	MobileService ms = new MobileServiceImpl();
	if(ms.checkUserLogin(username, password, logintype)==1) {
		user = new User() ;
		rs.execute("SELECT id,firstname,lastname,systemlanguage,seclevel FROM HrmResourceManager WHERE loginid='"+username+"'");
		if(rs.next()){
			user.setUid(rs.getInt("id"));
			user.setLoginid(username);
			user.setFirstname(rs.getString("firstname"));
			user.setLastname(rs.getString("lastname"));
			user.setLanguage(Util.getIntValue(rs.getString("systemlanguage"),0));
			user.setSeclevel(rs.getString("seclevel"));
			user.setLogintype("1");
			request.getSession(true).setAttribute("weaver_user@bean",user) ;
		}
	} else {
		out.println("Login Error !");
		return;
	}
}
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>

<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/ext-all_wev8.css' />
<link rel='stylesheet' type='text/css' href='/css/weaver-ext_wev8.css' />
<link rel='stylesheet' type='text/css' href='/js/extjs/resources/css/xtheme-gray_wev8.css'/>
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
<SCRIPT language="javascript" src="/js/init_wev8.js"></SCRIPT>
<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/jquery_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/adapter/jquery/ext-jquery-adapter_wev8.js'></script>
<script type='text/javascript' src='/js/extjs/ext-all_wev8.js'></script>
</head>
<%
	if (!HrmUserVarify.checkUserRight("Mobile:Setting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>

<script type="text/javascript">
	$(document).ready(function() {
		showUserFrom();
	});
	
	function showUserFrom(){
		var win;
		if(!win){
			win = new Ext.Window({
		           contentEl:"userwin",
		           x: 0,
		           y: 0,
		           width:500,
		           height:400,
		           modal:true,
		           closable:false,
		           resizable:false,
		           closeAction:"hide",
		           buttons:[{text:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",handler:function(){onUserOk();win.hide();}},{text:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",handler:function(){onUserCancel();win.hide();}}],
		           buttonAlign:"center",
		           title:"<%=SystemEnv.getHtmlLabelName(18454,user.getLanguage())%>"
		        });
		}
        win.show();
	}

	function onUserOk(){
		
	 	var sharetype = document.getElementsByName("sharetype")[0].value;
	 	var seclevel = document.getElementsByName("seclevel")[0].value;
	 	var rolelevel = document.getElementsByName("rolelevel")[0].value;
	 	var relatedshareids = document.getElementsByName("relatedshareid")[0].value;

	 	if(sharetype=="5") relatedshareids = "0";
	 	
	 	var geturl = "MobileCrossFrameProxy.jsp?method=returnAddUser"+
		"&flag=<%=flag%>"+
		"&sharetype="+sharetype+
		"&seclevel="+seclevel+
		"&rolelevel="+rolelevel+
		"&relatedshareids="+relatedshareids+
		"&click=ok"+
		"&callback=doClear()";
		
		$.getScript(geturl,function(data){
			eval(data);
		});
	}

	function onUserCancel() {
		var geturl="MobileCrossFrameProxy.jsp?method=returnAddUser"+
		"&flag=<%=flag%>"+
		"&click=cancel"+
		"&callback=doClear()";
		
		$.getScript(geturl,function(data){
			eval(data);
		});
	}
	
	function doClear() {
		
		try {
		
		document.getElementsByName("sharetype")[0].value = "1";
	 	document.getElementsByName("seclevel")[0].value = "";
	 	document.getElementsByName("rolelevel")[0].value = "";
	 	document.getElementsByName("relatedshareid")[0].value = "";
	 	document.getElementById("showrelatedsharename").innerHTML = "";
	 	onChangeSharetype();
	 	
		} catch(err) {
	 		
	 	}
	 	
	 	window.parent.close();
	}

	function onChangeSharetype(){
		
		var thisvalue=document.getElementsByName("sharetype")[0].value;
		document.getElementsByName("relatedshareid")[0].value="";
		if(document.getElementsByName("showseclevel")[0]) document.getElementsByName("showseclevel")[0].style.display='';
		if(document.getElementsByName("showseclevel_line")[0]) document.getElementsByName("showseclevel_line")[0].style.display='';
		if(thisvalue==1){
			document.getElementsByName("showresource")[0].style.display='';
			document.getElementsByName("showseclevel")[0].style.display='none';
		    document.getElementsByName("showseclevel_line")[0].style.display='none';
		    document.getElementsByName("seclevel")[0].value=0;
		} else {
			document.getElementsByName("showresource")[0].style.display='none';
		}
		if(thisvalue==2){
	 		document.getElementsByName("showsubcompany")[0].style.display='';
	 		document.getElementsByName("seclevel")[0].value=10;
		} else {
			document.getElementsByName("showsubcompany")[0].style.display='none';
			document.getElementsByName("seclevel")[0].value=10;
		}
		if(thisvalue==3){
		 	document.getElementsByName("showdepartment")[0].style.display='';
		 	document.getElementsByName("seclevel")[0].value=10;
		} else {
			document.getElementsByName("showdepartment")[0].style.display='none';
			document.getElementsByName("seclevel")[0].value=10;
		}
		if(thisvalue==4){
		 	document.getElementsByName("showrole")[0].style.display='';
			document.getElementsByName("showrolelevel")[0].style.display='';
		    document.getElementsByName("showrolelevel_line")[0].style.display='';
		    document.getElementsByName("rolelevel")[0].style.display='';
			document.getElementsByName("seclevel")[0].value=10;
		} else {
			document.getElementsByName("showrole")[0].style.display='none';
			document.getElementsByName("showrolelevel")[0].style.display='none';
		    document.getElementsByName("showrolelevel_line")[0].style.display='none';
		    document.getElementsByName("rolelevel")[0].style.display='none';
			document.getElementsByName("seclevel")[0].value=10;
	    }
		if(thisvalue==5){
		 	document.getElementsByName("seclevel")[0].value=0;
		} else {
			document.getElementsByName("seclevel")[0].value=0;
		}
		
	}

	function onShowResource(input,span) {
		var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids="+document.getElementById(input).value, "", "dialogHeight=600px");
		
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+" "+dummynames[k]+"";
				}
				document.getElementById(input).value=dummyidArray;
				document.getElementById(span).innerHTML=sHtml;
				
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
		
		
	}

	function onShowSubcompany(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+document.getElementById(input).value);
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
				for(var k=0;k<dummyidArray.length;k++){
					if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
						sHtml = sHtml+" "+dummynames[k]+"";
				}
				document.getElementById(input).value=dummyidArray;
				document.getElementById(span).innerHTML=sHtml;
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
		
	}

	function onShowDepartment(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.getElementById(input).value);
	    if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				dummyidArray=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				dummynames=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
				var sHtml = "";
			for(var k=0;k<dummyidArray.length;k++){
				if(dummyidArray[k]&&dummynames[k]&&dummyidArray[k]!=""&&dummynames[k]!="")
					sHtml = sHtml+" "+dummynames[k]+"";
			}
			document.getElementById(input).value=dummyidArray;
			document.getElementById(span).innerHTML=sHtml;
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
	}

	function onShowRole(input,span) {
	    var vbid = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
		if (vbid != null) {
			if (wuiUtil.getJsonValueByIndex(vbid, 0) != ""&&wuiUtil.getJsonValueByIndex(vbid, 1) != "") {
				document.getElementById(input).value=wuiUtil.getJsonValueByIndex(vbid, 0).split(",");
				document.getElementById(span).innerHTML=wuiUtil.getJsonValueByIndex(vbid, 1).split(",");
			}
		}else {			
			document.getElementById(input).value="";
			document.getElementById(span).innerHTML="";
		}
	}
	
</script>

<body>

<div id="userwin" class="x-hidden">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">    
        <tr>
            <td valign="top">
                <TABLE width=100% height=100%>
                    <tr>
                        <td valign="top">  
                              <TABLE class=ViewForm>
                                <COLGROUP>
                                <COL width="30%">
                                <COL width="70%">
                                <TBODY>            
                                    <TR>
                                        <TD>
                                        <% if("1".equals(onlyselectuser)) { %>
                                        	<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>
                                        <% } else { %>
                                           <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
                                        <% } %>
                                        </TD>
                                            
                                        <TD class="field">
                                            <SELECT class=InputStyle name="sharetype" id="sharetype" onChange="onChangeSharetype()" style="display:<% if("1".equals(onlyselectuser)) { %>none<% } %>;">   
                                                <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option> 
                                                <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
                                                <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
                                                <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>    
                                                <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>    
                                            </SELECT>
                                            &nbsp;&nbsp;
                                            <BUTTON class=Browser style="display:''" onClick="onShowResource('relatedshareid','showrelatedsharename');" name=showresource></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowSubcompany('relatedshareid','showrelatedsharename');" name=showsubcompany></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowDepartment('relatedshareid','showrelatedsharename');" name=showdepartment></BUTTON> 
                                            <BUTTON class=Browser style="display:none" onClick="onShowRole('relatedshareid','showrelatedsharename');" name=showrole></BUTTON>
                                            <INPUT type=hidden name=relatedshareid  id="relatedshareid" value="">
                                            <span id=showrelatedsharename name=showrelatedsharename></span>                                            
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD class=Line colSpan=2></TD>
                                    </TR>

                                    <TR id=showrolelevel name=showrolelevel style="display:none">
                                        <TD>
                                            <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <SELECT id="rolelevel" name="rolelevel">
                                                    <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                                                    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                                                    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                                             </SELECT>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2  id=showrolelevel_line name=showrolelevel_line style="display:none"></TD>
                                     </TR>

                                      <TR id=showseclevel name=showseclevel style="display:none">
                                        <TD>
                                             <%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
                                        </TD>
                                        <td class="field">
                                             <INPUT type=text name="seclevel" class=InputStyle size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onKeyPress="ItemCount_KeyPress()">
                                             <span id=seclevelimage></span>
                                        </td>
                                    </TR>
                                     <TR>
                                        <TD class=Line colSpan=2 id=showseclevel_line name=showseclevel_line style="display:none"></TD>
                                     </TR>
                                </TBODY>
                            </TABLE>
                        </td>
                    </tr>
                </TABLE>
            </td>
        </tr>
        </table>
</div>


</body>
</html>