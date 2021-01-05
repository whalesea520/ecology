
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet"type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet" type="text/css" />

<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery_wev8.js"></script>

</head>
<%

	if(!HrmUserVarify.checkUserRight("License:manager", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	
	String sql = " SELECT * FROM CPCOMPANYTIMEOVER ";
	rs.execute(sql);
	String toid = "";
	String tofaren = "";
	String todsh = "";
	String tozhzh ="";
	String tozhch = "";
	String tonjian = "";
	String chzhzh = "";
	String chgd = "";
	String chdsh = "";
	String chzhch = "";
	String chxgs ="";
	if(rs.next()){
		toid = rs.getString("id");
		tofaren = rs.getString("tofaren");
		todsh = rs.getString("todsh");
		tozhzh = rs.getString("tozhzh");
		tozhch = rs.getString("tozhch");
		tonjian = rs.getString("tonjian");
		chzhzh = rs.getString("chzhzh");
		chgd = rs.getString("chgd");
		chdsh = rs.getString("chdsh");
		chzhch = rs.getString("chzhch");
		chxgs = rs.getString("chxgs");
	}

String flag=Util.null2String(request.getParameter("flag"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(18818,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(30986,user.getLanguage())+",javascript:onSave(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="action/CPCompanySetOperate.jsp">
	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(HrmUserVarify.checkUserRight("EditProjectType:Edit", user)){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" class="e8_btn_top"  onclick="onSave()"/>
			<%
		}
		%>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

 <input type=hidden name=method value="overtime2Save">
 <input type=hidden name="toid" value="<%=toid %>"/>
	<wea:layout type="2Col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="">
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31090,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17548,user.getLanguage()) %> <input type="text" name="tofaren" value="<%=tofaren %>" class="BoxW60"    onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31091,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31092,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17548,user.getLanguage()) %>  <input type="text" name="todsh" value="<%=todsh %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31091,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31093,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17548,user.getLanguage()) %> <input type="text" name="tozhzh" value="<%=tozhzh %>" class="BoxW60"  onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31091,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31094,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17548,user.getLanguage()) %> <input type="text" name="tozhch" value="<%=tozhch %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')" style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/>
				  	<%=SystemEnv.getHtmlLabelName(31091,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31095,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(17548,user.getLanguage()) %> <input type="text" name="tonjian" value="<%=tonjian %>" class="BoxW60"  onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"   style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31096,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31758,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31097,user.getLanguage()) %>
				  	 	<input type="text" name="chzhzh" value="<%=chzhzh %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"   style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/>
				  	 <%=SystemEnv.getHtmlLabelName(31098,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31759,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31097,user.getLanguage()) %> <input type="text" name="chgd" value="<%=chgd %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"   style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/>
				  	<%=SystemEnv.getHtmlLabelName(31099,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31070,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31097,user.getLanguage()) %> <input type="text" name="chdsh" value="<%=chdsh %>" class="BoxW60"  onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  style="width:100px"   onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31100,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31071,user.getLanguage()) %>
				</wea:item>
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31097,user.getLanguage()) %> <input type="text" name="chzhch" value="<%=chzhch %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  style="width:100px"   onpaste="javascript: return false;"  maxlength="5"/> 
				  	<%=SystemEnv.getHtmlLabelName(31101,user.getLanguage()) %>
				</wea:item>
				
				<wea:item>
					<%=SystemEnv.getHtmlLabelName(31072,user.getLanguage()) %>
				</wea:item>
				<wea:item>
						<%=SystemEnv.getHtmlLabelName(31593,user.getLanguage()) %> <input type="text" name="chxgs" value="<%=chxgs %>" class="BoxW60" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"   style="width:100px"  onpaste="javascript: return false;"  maxlength="5"/> 
				  		<%=SystemEnv.getHtmlLabelName(31102,user.getLanguage()) %>
				</wea:item>
			</wea:group>
	</wea:layout>
  </FORM>
</BODY>

<script language="javascript">
	jQuery(document).ready(function(){
			<%
				if(!"".equals(flag)){
				out.println("alert('"+SystemEnv.getHtmlLabelName(30992,user.getLanguage())+"')");
				}
			%>
		});
	function onSave(){
		frmMain.submit();
	}
	
	$(function(){
		try{
			window.parent.hideLeftTree();
			parent.rebindNavEvent(null,null,null,null,{_window:window,hasLeftTree:false});
		}catch(e){}
	});
</script>
<style>
.Nav{
	cursor: pointer;
}
</style>
</HTML>
