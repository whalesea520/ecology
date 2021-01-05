
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/integration/integrationinit.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<html>
	<head>
		<title>sap<%=SystemEnv.getHtmlLabelName(26267,user.getLanguage()) %></title>
	</head>
	<%
	
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String closeDialog=Util.null2String(request.getParameter("closeDialog"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30639,user.getLanguage());
		String opera="save";
		String hpid=Util.null2String(request.getParameter("hpid"));
		String sourcename="";
		String DBtype="";
		String serverip="";
		String port="";
		String dbname="";
		String username="";
		String password="";
		String minConnNum="";
		String maxConnNum="";
		String datasourceDes="";
		if("1".equals(isNew))
		{
			titlename =  SystemEnv.getHtmlLabelName(30641,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from dml_datasource where id='"+id+"'");
			if(RecordSet.next())
			{
				 hpid=RecordSet.getString("hpid");
				 sourcename=RecordSet.getString("sourcename");
				 DBtype=RecordSet.getString("DBtype");
				 serverip=RecordSet.getString("serverip");
				 port=RecordSet.getString("port");
				 dbname=RecordSet.getString("dbname");
				 username=RecordSet.getString("username");
				 password=RecordSet.getString("password");
				 minConnNum=RecordSet.getString("minConnNum");
				 maxConnNum=RecordSet.getString("maxConnNum");
				 datasourceDes=RecordSet.getString("datasourceDes");
			}
		}
		String needhelp ="";
	%>
	<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(30632,user.getLanguage())%>"/> 
</jsp:include>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowDatasource("1",id)==false))
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
			<%if("1".equals(isNew)&&(SapUtil.IsShowDatasource("1",id)==false)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this,'<%=id%>')" />
			<%}%>&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			
			<form action="/integration/dateSource/dataDMLOperation.jsp" method="post" name="datadml" id="datadml">
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="hpid" value="<%=hpid%>">
<wea:layout type="4Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <wea:required id="sourcenamespan" required="true" value='<%=sourcename%>'>
         <input type="text" name="sourcename"  value="<%=sourcename%>" onchange='checkinput("sourcename","sourcenamespan")'  maxlength="50">
        </wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30636,user.getLanguage())%></wea:item>
    <wea:item>
        <%=SapUtil.getHeteProductsSelect("hpid","1","hideimg(this,sernamespan)",hpid,"selectmax_width","     ")%>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></wea:item>
    <wea:item>
        <%=SapUtil.getDBtypeSelect("DBtype","",DBtype,"selectmax_width","")%>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="serveripspan" required="true" value='<%=serverip%>'>
			<input type="text" name="serverip" value="<%=serverip%>"  onchange='checkinput("serverip","serveripspan")'  maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="portspan" required="true" value='<%=port%>'>
			<input type="text" name="port" value="<%=port%>" onchange='checkinput("port","portspan")'  maxlength="10">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <wea:required id="dbnamespan" required="true" value='<%=dbname%>'>
			<input type="text" name="dbname" value="<%=dbname%>" onchange='checkinput("dbname","dbnamespan")'  maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
    <wea:item>
		<wea:required id="usernamespan" required="true" value='<%=username %>'>
			<input type="text" name="username" value="<%=username %>" onchange='checkinput("username","usernamespan")' maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="passwordspan" required="true" value='<%=password %>'>
			<input type="password" name="password" value="<%=password %>" onchange='checkinput("password","passwordspan")' maxlength="50">
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30646,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text" name="minConnNum" value="<%=minConnNum %>"  maxlength="3">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30647,user.getLanguage())%></wea:item>
    <wea:item>
        <input type="text" name="maxConnNum" value="<%=maxConnNum %>" maxlength="3">
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30650,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <textarea rows="5" cols="80" name="datasourceDes"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);" ><%=datasourceDes %></textarea>
    </wea:item>
	</wea:group>
</wea:layout>

			</form>
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
		
		$(document).ready(function(){
			if("<%=closeDialog%>"=="close"){			
				var parentWin = parent.getParentWindow(window);
				parentWin.location.reload();
				onCancel();
			}
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
			$("#datadml").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/dateSource/dataDMLlist.jsp?hpid=<%=hpid%>";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>!"))
			{
				window.location.href="/integration/dateSource/dataDMLOperation.jsp?isDialog=1&opera=delete&ids="+id+"&hpid=<%=hpid%>";
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

