
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<html>
	<head>
		<title>sap<%=SystemEnv.getHtmlLabelName(26267,user.getLanguage()) %></title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String closeDialog=Util.null2String(request.getParameter("closeDialog"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30664,user.getLanguage());
		String opera="save";
		String hpid=Util.null2String(request.getParameter("hpid"));
		String dataname="";    
		String poolname="";    
		String hostname1="";
		String systemnum="";
		String saprouter="";
		String client="";
		String language="";
		String username="";
		String password="";
		String maxconnnum="";
		String datasourcedes="";
		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(30666,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from sap_datasource where id='"+id+"'");
			if(RecordSet.next())
			{
				 hpid=RecordSet.getString("hpid");    
				 dataname=RecordSet.getString("dataname");    
				 poolname=RecordSet.getString("poolname");    
				 hostname1=RecordSet.getString("hostname");    
				 systemnum=RecordSet.getString("systemNum");    
				 saprouter=RecordSet.getString("saprouter");    
				 client=RecordSet.getString("client");    
				 language=RecordSet.getString("language");    
				 username=RecordSet.getString("username");    
				 password=RecordSet.getString("password");    
				 maxconnnum=RecordSet.getString("maxConnNum");   
				 datasourcedes= RecordSet.getString("datasourcedes");  
			}
		}
		String needhelp ="";
	%>
	<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value='<%="SAP "+SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>'/> 
</jsp:include>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowDatasource("3",id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this);">
			<%if("1".equals(isNew)&&(SapUtil.IsShowDatasource("3",id)==false)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this,'<%=id%>')" />
			<%}%>&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			
			<form action="/integration/dateSource/dataSAPOperation.jsp" method="post" name="sapnew" id="sapnew">
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="style" value="0">
				<input type="hidden" name="hpid" value="<%=hpid%>">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item>SAP <%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <wea:required id="poolnamespan" required="true" value='<%=poolname%>'>
			<input type="text" name="poolname" style="width:200px;" value="<%=poolname%>" onchange='checkinput("poolname","poolnamespan")'  maxlength="50">
        </wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30636,user.getLanguage())%></wea:item>
    <wea:item>
        <%=SapUtil.getHeteProductsSelect("","3","hideimg(this,hidspan)",hpid,"selectmax_width","     ")%>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="hostnamespan" required="true" value='<%=hostname1%>'>
			<input type="text" name="hostname" style="width:200px;" value="<%=hostname1%>"  onchange='checkinput("hostname","hostnamespan")'   maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="systemnumspan" required="true" value='<%=systemnum%>'>
			<input type="text" name="systemnum" style="width:200px;"  value="<%=systemnum%>"  onchange='checkinput("systemnum","systemnumspan")' maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item>SAP&nbsp;Router</wea:item>
	<wea:item>
        <input type="text" name="saprouter" style="width:200px;" value="<%=saprouter%>"  maxlength="80" >
    </wea:item>
	<wea:item>SAP <%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="clientspan" required="true" value='<%=client %>'>
			<input type="text" name="client" style="width:200px;" value="<%=client%>" onchange='checkinput("client","clientspan")'  maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(108,user.getLanguage())%></wea:item>
    <wea:item>
        <select name="language"  id="language"  style="width:200px;">
			<option value="ZH" <% if("ZH".equals(language))  {%> selected="selected" <%} %>><%=SystemEnv.getHtmlLabelName(1997,user.getLanguage())%></option>
			<option value="EN" <% if("EN".equals(language))  {%> selected="selected" <%} %>><%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%></option>
		</select>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="usernamespan" required="true" value='<%=username %>'>
			<input type="text" name="username" style="width:200px;" value="<%=username%>" onchange='checkinput("username","usernamespan")' maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="passwordspan" required="true" value='<%=password %>'>
			<input type="password" name="password" style="width:200px;" value="<%=password%>" onchange='checkinput("password","passwordspan")' maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30673,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <textarea rows="5" cols="100" name="datasourcedes"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"   style="height: 80px"><%=datasourcedes%></textarea>
    </wea:item>
	</wea:group>
</wea:layout>

			</form>
<style>
	.huotu_dialog_overlay
	{
		z-index:99991;
		position:fixed;
		filter:alpha(opacity=30); BACKGROUND-COLOR: #000;
		width:100%;
		bottom:0px;
		height:100%;
		top:0px;
		right:0px;
		left:0px;
		opacity:.9;
		_position:absolute;		
		margin: 0px;
		padding: 0px;
		overflow: hidden;
		display: none;
	}
	.bd_dialog_main
	{	
		z-index:99992;
		position:fixed;
		_position:absolute;	
		color: white;	
	}
</style>	
 	
<DIV class=huotu_dialog_overlay id="test">
		<div style="width:200;height:100" id="test2" class="bd_dialog_main">
				<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>
		</div>
</DIV>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
<script type="text/javascript">
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}

		$(document).ready(function() {  
			if("<%=closeDialog%>"=="close"){			
				var parentWin = parent.getParentWindow(window);
				parentWin.location.reload();
				onCancel();
			}
			
			$("#onsave").click (function(){
				//newServer.submit();
				//网页正文全文高
				var temp=document.body.scrollHeight;
				$("#test").css("height",temp);
				var h2=$("#test2").css("height");
				var w2=$("#test2").css("width");
				var a=(document.body.clientWidth)/2-100; 
				var b=(document.body.clientHeight)/2-50;
				$("#test2").css("left",a);
				$("#test2").css("top",b);
				$("#test").show();
			});
			
		});
		
		function doSubmit()
		{
			var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0)
			{
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>");
				return;
			}
			var hostname = $("input[name='hostname']").attr("value");
			var systemnum = $("input[name='systemnum']").attr("value");
			var saprouter = $("input[name='saprouter']").attr("value");
			var client = $("input[name='client']").attr("value");
			var language = $("#language").val();
			var username = $("input[name='username']").attr("value");
			var password = $("input[name='password']").attr("value");
			enableAllmenu();
			$.post("/integration/dateSource/checkSAPDataSourceAjax.jsp",{hostname:hostname,saprouter:saprouter,systemnum:systemnum,client:client,language:language,username:username,password:password},function(data){
				if(data["content"]=="0"){
					//31407
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(31407,user.getLanguage())%>?")){
						$("#sapnew").submit();
					}else{
						displayAllmenu();
					}
				}else  if(data["content"]=="1"){
					//31408
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(31408,user.getLanguage())%>?")){
						$("#sapnew").submit();
					}else{
						displayAllmenu();
					}
				}else if(data["content"]=="2"||data["content"]==-1){
					//31409
					window.alert("<%=SystemEnv.getHtmlLabelName(31409,user.getLanguage())%>!");
					displayAllmenu();
				}else{
					//31410
					alert("<%=SystemEnv.getHtmlLabelName(31410,user.getLanguage())%>!");
					displayAllmenu();
				}
				
			},"json");
			
		}
		function doGoBack()
		{
			window.location.href="/integration/dateSource/dataSAPlist.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
			{
				window.location.href="/integration/dateSource/dataSAPOperation.jsp?isDialog=1&opera=delete&ids="+id+"&hpid=<%=hpid%>";
			}
		}
		function hideimg(obj,objspan)
		{
			if(obj.value)
			{
				$(objspan).html("");
			}else
			{
				$(objspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
			}
			
		}
		//限制文本域的长度
		function checkLength(obj,maxlength){
		    if(obj.value.length > maxlength){
		        obj.value = obj.value.substring(0,maxlength);
		    }
		}
</script>
</html>

