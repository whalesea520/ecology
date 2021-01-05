
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
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
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:datasourcesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23660,user.getLanguage());
String needfav ="1";
String needhelp ="";

String dataname = Util.null2String(request.getParameter("dataname"));
//DataSourceXML.initData();//初始化datasource.xml文件
String moduleid = DataSourceXML.getModuleId();
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
Hashtable dataHST = DataSourceXML.getDataHST();
String dsOPTIONS = "";
String thisType = "";
String thisIscluster = "";
String thistypename = "";
String thisUrl = "";
String thisHost = "";
String thisPort = "";
String thisDBname = "";
String thisUser = "";
String thisPassword = "";
String thisMinconn = "";
String thisMaxconn = "";
String thisiscode = "";

String checkString = "";
String tiptitle = SystemEnv.getHtmlLabelName(32355,user.getLanguage())+"<br/>"+SystemEnv.getHtmlLabelName(124995,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(124996,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(125535,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(125536,user.getLanguage());
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(dataname.equals("")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onNew(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(82 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onNew()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onDelete()"/>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="datasourcesetting.jsp">
<input type="hidden" id="operation" name="operation">
<input type="hidden" id="method" name="method">
<input type="hidden" id="dsnums" name="dsnums" value="<%=pointArrayList.size()%>">
<div id="loading" style="display:none;">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle">&nbsp;<%=SystemEnv.getHtmlLabelName(25496, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25007, user.getLanguage())%></span>
</div>

  <TABLE class="ListStyle" cellspacing=1>
	<COLGROUP> 
		<COL width="4%">
		<COL width="10%"> 
		<COL width="10%">
		<COL width="5%"> 
		<COL width="10%"> 
		<COL width="4%">
		<COL width="10%"> 
		<COL width="9%">
		<COL width="8%"> 
		<COL width="8%">
		<COL width="8%">
		<COL width="3%">
	</COLGROUP>
	<TBODY>
	<TR class=header>
	  <TH><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this)"></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(126687,user.getLanguage())%></nobr></TH><!-- 集群/多实例 -->
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>IP</nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(23671,user.getLanguage())%></nobr></TH>
	  <TH><nobr><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></nobr></TH>
	  <TH>&nbsp;</TH>
	</TR>
	
	<%
	int colorindex = 0;
	int rowindex = 0;
	for(int i=0;i<pointArrayList.size();i++){
	    String pointid = (String)pointArrayList.get(i);
	    if(pointid.equals("")) continue;
	    if(!dataname.equals("") && !dataname.equals(pointid)) continue;
	    checkString += "datasource_"+rowindex+",";
	    //String datasourceusedstr = Util.null2String(DataSourceXML.getDataSourceUsed(pointid,user)).trim();
	    Hashtable thisDetailHST = (Hashtable)dataHST.get(pointid);
	    if(thisDetailHST!=null){
	        thisType = Util.null2String((String)thisDetailHST.get("type"));
	        thisIscluster = Util.null2String((String)thisDetailHST.get("iscluster"));
	        thisIscluster = thisIscluster.equals("")?"1":thisIscluster;
	        if(!thisType.equals("oracle")&&!thisType.equals("oracle12c")&&!thisType.equals("mysql")&&!thisType.equals("sqlserver")&&!thisType.equals("sqlserver2005")&&!thisType.equals("sqlserver2008"))
	        {
	        	thisIscluster = "1";
	        }
	        thisUrl = Util.null2String((String)thisDetailHST.get("url"));
	        thisHost = Util.null2String((String)thisDetailHST.get("host"));
	        thisPort = Util.null2String((String)thisDetailHST.get("port"));
	        thisDBname = Util.null2String((String)thisDetailHST.get("dbname"));
	        thisUser = Util.null2String((String)thisDetailHST.get("user"));
	        thisPassword = Util.null2String((String)thisDetailHST.get("password"));
	        thisMinconn = Util.null2String((String)thisDetailHST.get("minconn"));
			if(thisMinconn.equals("")) thisMinconn = "5";
	        thisMaxconn = Util.null2String((String)thisDetailHST.get("maxconn"));
			if(thisMaxconn.equals("")) thisMaxconn = "10";
	        thisiscode = Util.null2String((String)thisDetailHST.get("iscode"));
	        thistypename = Util.null2String((String)thisDetailHST.get("typename"));
	        
	        if("1".equals(thisiscode))
	        {
	        	thisUser = SecurityHelper.decrypt("ecology",thisUser);
	        	thisPassword = SecurityHelper.decrypt("ecology",thisPassword);
	        }
     
	    }
	    if(colorindex==0){
	    %>
	    <TR class="DataDark">
	    <%
	        colorindex=1;
	    }else{
	    %>
	    <TR class="DataLight">
	    <%
	        colorindex=0;
	    }%>
	    
	    <TD><input type="checkbox" id="del_<%=rowindex%>" name="del_<%=rowindex%>" value="0" onclick="if(this.checked){this.value=1;}else{this.value=0;}"><input type=hidden id="iscode_<%=rowindex%>" name="iscode_<%=rowindex%>" value="1"></TD>
	    <TD><input class="InputStyle" type=text size=8 style="width:90%;" id="datasource_<%=rowindex%>" name="datasource_<%=rowindex%>" value="<%=pointid%>" onChange="checkinput('datasource_<%=rowindex%>','datasourcespan_<%=rowindex%>')" onblur="checkDSName(this.value,<%=rowindex%>)"><span id="datasourcespan_<%=rowindex%>"></span><input class="InputStyle" type=hidden size=12 id="olddatasource_<%=rowindex%>" name="olddatasource_<%=rowindex%>" value="<%=pointid%>"></TD>
	    <TD class=Field>
			<select id="dbtype_<%=rowindex%>" name="dbtype_<%=rowindex%>" onchange="javascript:changeCluster('<%=rowindex%>');" style="width:120px;">
				<option title="sqlserver"  value="sqlserver" <%if(thisType.equals("sqlserver")){%>selected<%}%>>sqlserver2000</option>
				<option title="sqlserver2005" value="sqlserver2005" <%if(thisType.equals("sqlserver2005")){%>selected<%}%>>sqlserver2005</option>
				<option title="sqlserver2008" value="sqlserver2008" <%if(thisType.equals("sqlserver2008")){%>selected<%}%>>sqlserver2008</option>
				<option title="oracle" value="oracle" <%if(thisType.equals("oracle")){%>selected<%}%>>oracle</option>
				<option title="oracle12c" value="oracle12c" <%if(thisType.equals("oracle12c")){%>selected<%}%>>oracle12c</option>
				<option title="mysql" value="mysql" <%if(thisType.equals("mysql")){%>selected<%}%>>mysql</option>
				<option title="db2" value="db2" <%if(thisType.equals("db2")){%>selected<%}%>>db2</option>
				<option title="sybase" value="sybase" <%if(thisType.equals("sybase")){%>selected<%}%>>sybase</option>
				<option title="informix" value="informix" <%if(thisType.equals("informix")){%>selected<%}%>>informix</option>
				<option title="hana" value="hana" <%if(thisType.equals("hana")){%>selected<%}%>>hana</option>
			</select>
		</TD>
		<TD class=Field>
			<input type="checkbox" id="iscluster_<%=rowindex%>" name="iscluster_<%=rowindex%>" value="<%=thisIscluster%>" <%if(thisIscluster.equals("2")){%>checked<%}%> <%if(thisIscluster.equals("2")){%>title=<%=SystemEnv.getHtmlLabelName(24897,user.getLanguage())%><%}else{%>title=<%=SystemEnv.getHtmlLabelName(24898,user.getLanguage())%><%} %> onclick="if(this.checked){this.value=2;this.title='<%=SystemEnv.getHtmlLabelName(24897,user.getLanguage())%>';}else{this.value=1;this.title='<%=SystemEnv.getHtmlLabelName(24898,user.getLanguage())%>';};changeCluster('<%=rowindex%>');">
			<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN><input type=hidden id="typename_<%=rowindex%>" name="typename_<%=rowindex%>" value="<%=thistypename %>">
		</TD>
		<TD id="url_<%=rowindex%>_td" colSpan=3 <%if(thisIscluster.equals("1")||(thisIscluster.equals("2")&&(!thisType.equals("oracle")&&!thisType.equals("oracle12c")&&!thisType.equals("mysql")&&!thisType.equals("sqlserver")&&!thisType.equals("sqlserver2005")&&!thisType.equals("sqlserver2008")))){%>style="display:none;"<%} %> title="<%=SystemEnv.getHtmlLabelName(32357,user.getLanguage())%>">
			<input class="InputStyle" title="<%=SystemEnv.getHtmlLabelName(32357,user.getLanguage())%>" type=text size=36 id="url_<%=rowindex%>" style="width:100%;" name="url_<%=rowindex%>" value="<%=thisUrl %>">					
		</TD>
		
	    <TD id="HostIP_<%=rowindex%>_td" <%if(thisIscluster.equals("2")&&(thisType.equals("oracle")||thisType.equals("oracle12c")||thisType.equals("mysql")||thisType.equals("sqlserver")||thisType.equals("sqlserver2005")||thisType.equals("sqlserver2008"))){%>style="display:none;"<%}%>><input class="InputStyle" type=text size=16 style="width:100%;" id="HostIP_<%=rowindex%>" name="HostIP_<%=rowindex%>" value="<%=thisHost%>"></TD>
	    <TD id="Port_<%=rowindex%>_td" <%if(thisIscluster.equals("2")&&(thisType.equals("oracle")||thisType.equals("oracle12c")||thisType.equals("mysql")||thisType.equals("sqlserver")||thisType.equals("sqlserver2005")||thisType.equals("sqlserver2008"))){%>style="display:none;"<%}%>><input class="InputStyle" type=text size=4 style="width:100%;" id="Port_<%=rowindex%>" name="Port_<%=rowindex%>" value="<%=thisPort%>" onpaste="return false" onkeyup="this.value=this.value.replace(/[^\d]/g,'');" onBlur="checkNumber3(<%=rowindex%>);"></TD>
	    <TD id="DBname_<%=rowindex%>_td" <%if(thisIscluster.equals("2")&&(thisType.equals("oracle")||thisType.equals("oracle12c")||thisType.equals("mysql")||thisType.equals("sqlserver")||thisType.equals("sqlserver2005")||thisType.equals("sqlserver2008"))){%>style="display:none;"<%}%>><input class="InputStyle" type=text size=10 style="width:100%;" id="DBname_<%=rowindex%>" name="DBname_<%=rowindex%>" value="<%=thisDBname%>"></TD>
	    
	    <TD><input class="InputStyle" type=text size=10 style="width:100%;" id="user_<%=rowindex%>" name="user_<%=rowindex%>" value="<%=thisUser%>"></TD>
	    <TD><input class="InputStyle" type="password" size=10 style="width:100%;" id="password_<%=rowindex%>" name="password_<%=rowindex%>" value="<%=thisPassword%>"></TD>
	    <TD><input class="InputStyle" type=text size=7 style="width:100%;" id="minconn_<%=rowindex%>" name="minconn_<%=rowindex%>" value="<%=thisMinconn%>" onblur="vaidDataminconn(<%=rowindex%>);"></TD>
	    <TD><input class="InputStyle" type=text size=7 style="width:100%;" id="maxconn_<%=rowindex%>" name="maxconn_<%=rowindex%>" value="<%=thisMaxconn%>" onblur="vaidDatamaxconn(<%=rowindex%>);"></TD>
	    <TD><SPAN class="testspan" style="BORDER-BOTTOM: medium none; TEXT-ALIGN: center; BORDER-LEFT: medium none; LINE-HEIGHT: 21px; WIDTH: 38px; DISPLAY: inline-block; BACKGROUND: url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat; HEIGHT: 21px; BORDER-TOP: medium none; CURSOR: pointer; MARGIN-RIGHT: 5px; BORDER-RIGHT: medium none" onclick='javascript:getTest(<%=rowindex%>);'><%=SystemEnv.getHtmlLabelName(25496, user.getLanguage())%></SPAN></TD>
	    </tr>
	<% 
	    rowindex++;       
	}
	%>
	</TBODY>
	</TABLE>
	<br/>
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		  <wea:item attributes="{'colspan':'2'}">
			1.<%=SystemEnv.getHtmlLabelName(23960,user.getLanguage())%>；
			<BR>
			2.<%=SystemEnv.getHtmlLabelName(23961,user.getLanguage())%>：
			<BR>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;weaver.interfaces.datasource.DataSource ds = (weaver.interfaces.datasource.DataSource) StaticObj.getServiceByFullname(("datasource.<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%>"), weaver.interfaces.datasource.DataSource.class)；
			<BR>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;java.sql.Connection conn = ds.getConnection()；
			<BR>
			3.<%=SystemEnv.getHtmlLabelName(23962,user.getLanguage())%>。
		</wea:item>
		</wea:group>
	</wea:layout>
  </FORM>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	jQuery(".e8tips").wTooltip({html:true});
});
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}
//新建子目录
function openDialog(url,title){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = 550;
	dialog.Height = 596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function chkAllClick(obj)
{
    var dsnums = document.getElementById("dsnums").value;
    for(var i=0;i<dsnums;i++){
        var chk = document.getElementById("del_"+i);;
        if(chk)
        {
	        chk.checked = obj.checked;
	        if(chk.checked)
	        {
	        	chk.value = "1";
	        }
	        else
	        {
	        	chk.value = "0";
	        }
	        try
           	{
           		if(chk.checked)
           			jQuery(chk.nextSibling).addClass("jNiceChecked");
           		else
           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
           	}
           	catch(e)
           	{
           	}
        }
    }
}
function changeCluster(rowindex)
{
	var iscluster = document.getElementById("iscluster_"+rowindex).value;
	var dbtype = document.getElementById("dbtype_"+rowindex).value;
	if(iscluster=="2"&&(dbtype=='oracle'||dbtype=='oracle12c'||dbtype=='mysql'||dbtype=='sqlserver'||dbtype=='sqlserver2005'||dbtype=='sqlserver2008'))
	{
		document.getElementById("url_"+rowindex+"_td").style.display = "";
		
		document.getElementById("HostIP_"+rowindex+"_td").style.display = "none";
		document.getElementById("Port_"+rowindex+"_td").style.display = "none";
		document.getElementById("DBname_"+rowindex+"_td").style.display = "none";
	}
	else
	{
		document.getElementById("url_"+rowindex+"_td").style.display = "none";
		
		document.getElementById("HostIP_"+rowindex+"_td").style.display = "";
		document.getElementById("Port_"+rowindex+"_td").style.display = "";
		document.getElementById("DBname_"+rowindex+"_td").style.display = "";
	}
}
function onNew()
{
	var url = "/integration/integrationTab.jsp?urlType=11&isdialog=1";
	var title = "<%=SystemEnv.getHtmlLabelName(23660,user.getLanguage())%>";
	openDialog(url,title);
}
function onSubmit(){
	/*var check = true;
	dsnums = document.getElementById("dsnums").value;
	for(var i=0;i<dsnums;i++){
		var thisvalue = document.getElementById("datasource_"+i).value;
		var ck = checkDSName(thisvalue,i);
		if(check && !ck){
			check = false;
		}
	}
	if(check){*/
    if(check_form(frmMain,"<%=checkString%>")){
        frmMain.action="XMLFileOperation.jsp";
        frmMain.operation.value="datasource";
        frmMain.method.value="edit";
        frmMain.submit();
    }
	//}
}

function onDelete(){
	var dsnums = document.getElementById("dsnums").value;
	//var hascandel = false;
	var hascandel = true;
	var hasselect = false;
    for(var i=0;i<dsnums;i++){
        var chk = document.getElementById("del_"+i);
        //var datasourceused = document.getElementById("datasourceused_"+i).value;
        var datasource = document.getElementById("datasource_"+i).value;
        if(chk)
        {
	        if(chk.checked)
	        {
	        	hasselect = true;
				//以ajax方式获取数据源被引用情况 start
				var pointid = document.getElementById("datasource_"+i).value;
				var params = {operation:"datasource",method:"getDataSourceUsed",pointid:pointid};
				var datasourceused = "";
				jQuery.ajax({
					type: "POST",
					url: "/servicesetting/XMLFileOperation.jsp",
					data: params,
					async: false,
					dataType: "json",
					success: function(msg){
						datasourceused = msg.datasourceused;
					}
				});
				
				//以ajax方式获取数据源被引用情况 end
	        	if(datasourceused!="")
	        	{
	        		datasourceused = datasourceused.substr(0,datasourceused.length-1)+" ";
	        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>"+datasource+" <%=SystemEnv.getHtmlLabelName(18805,user.getLanguage())%>"+datasourceused+"<%=SystemEnv.getHtmlLabelName(16330,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(22688,user.getLanguage())%>");
	        		/*chk.checked = false;
	        		chk.value = "0";
			        try
		           	{
		           		if(chk.checked)
		           			jQuery(chk.nextSibling).addClass("jNiceChecked");
		           		else
		           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
		           	}
		           	catch(e)
		           	{
		           	}*/
		           	for(var j=0;j<dsnums;j++){
    					var chkj = document.getElementById("del_"+j);
    					chkj.checked = false;
						chkj.value = "0";
				        try
			           	{
			           		if(chkj.checked)
			           			jQuery(chkj.nextSibling).addClass("jNiceChecked");
			           		else
			           			jQuery(chkj.nextSibling).removeClass("jNiceChecked");
			           	}
			           	catch(e)
			           	{
			           	}
    				}
    				hascandel = false;
		           	return;
	        	}
	        	/*else
	        	{
	        		hascandel = true;
	        	}*/
	        }
        }
    }
    if(!hasselect)
   	{
   		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
   	}
    if(hascandel)
    {
	    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        frmMain.action="XMLFileOperation.jsp";
	        frmMain.operation.value="datasource";
	        frmMain.method.value="delete";
	        frmMain.submit();
	    }, function () {}, 320, 90);
    }
}
function getTest(idx)
{
    //alert("test : "+idx);
    var dbtype = jQuery("#dbtype_"+idx).val();
    var iscluster = jQuery("#iscluster_"+idx).val();
    var url = jQuery("#url_"+idx).val();
    var HostIP = jQuery("#HostIP_"+idx).val();
    var Port = jQuery("#Port_"+idx).val();
    var DBname = jQuery("#DBname_"+idx).val();
    var user = jQuery("#user_"+idx).val();
    var password = jQuery("#password_"+idx).val();
    
    
    
    if(iscluster=="2"&&(dbtype=='oracle'||dbtype=='oracle12c'||dbtype=='mysql'||dbtype=='sqlserver'||dbtype=='sqlserver2005'||dbtype=='sqlserver2008')&&(user==""||password==""||url==""))
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32358,user.getLanguage())%>");//数据不完成，请填写完整!
    	return;
    }
    else if((iscluster=="2"&&(dbtype!='oracle'&&dbtype!='oracle12c'&&dbtype!='mysql'&&dbtype!='sqlserver'&&dbtype!='sqlserver2005'&&dbtype!='sqlserver2008')&&(user==""||password==""||HostIP==""||Port==""||DBname==""))||(iscluster=="1"&&(user==""||password==""||HostIP==""||Port==""||DBname=="")))
    {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32358,user.getLanguage())%>");
    	return;
    }
    /*if (password != null && password != "")  
    {
        password = password.replace(/%/g, "%25");
		password = password.replace(/\&/g, "%26");
		password = password.replace(/\+/g, "%2B");
    }
    if (DBname != null && DBname != "")  
    {
        DBname = DBname.replace(/%/g, "%25");
		DBname = DBname.replace(/\&/g, "%26");
		DBname = DBname.replace(/\+/g, "%2B");
    }*/
    var timestamp = (new Date()).valueOf();
    //var params = "operation=datasource&method=test&dbtype="+dbtype+"&iscluster="+iscluster+"&url="+url+"&HostIP="+HostIP+"&Port="+Port+"&DBname="+DBname+"&user="+user+"&password="+password+"&ts="+timestamp;
	var params = {operation:"datasource",method:"test",dbtype:dbtype,iscluster:iscluster,url:url,HostIP:HostIP,Port:Port,DBname:DBname,user:user,password:password,ts:timestamp};
    //alert(params);
    jQuery("#loading").show();
    
    jQuery(".testspan").attr("disabled","true");
    jQuery.ajax({
        type: "POST",
        url: "/servicesetting/XMLFileOperation.jsp",
        data: params,
        success: function(msg){
            if(jQuery.trim(msg)=="0")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32359,user.getLanguage())%>")//测试连接通过，连接配置正确!
            }
            else if(jQuery.trim(msg)=="4")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32285,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>！")//驱动类测试不通过，请检查设置
            }
            else if(jQuery.trim(msg)=="2")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(2072,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(21695,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(409,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//用户名或者密码测试不通过，请检查设置
            }
            else if(jQuery.trim(msg)=="1")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15038,user.getLanguage()) %>IP<%=SystemEnv.getHtmlLabelName(21695,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//服务器IP或者端口号测试不通过，请检查设置
            }
            else if(jQuery.trim(msg)=="3")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15026,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//数据库名称测试不通过，请检查设置
            }
            else if(jQuery.trim(msg)=="5")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32357,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//连接字符串测试不通过，请检查设置
            }
            else if(jQuery.trim(msg)=="7")
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32357,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//连接字符串测试不通过，请检查设置
            }
            else
            {
            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32296,user.getLanguage())%>")//测试不通过，请检查设置
            }
            jQuery("#loading").hide();
            jQuery(".testspan").removeAttr("disabled");
        }
    });
}
function checkDSName(thisvalue,rowindex){
    dsnums = document.getElementById("dsnums").value;
    if(thisvalue!=""){
		/*if(isSpecialChar(thisvalue)){
			//数据源名称包含特殊字段，请重新输入！
			top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelName(127370,user.getLanguage())%>");
			document.getElementById("datasource_"+rowindex).value = "";
			document.getElementById("datasourcespan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			
			return false;
		}
		if(isChineseChar(thisvalue)){
			//数据源名称包含中文，请重新输入！
			top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelName(127371,user.getLanguage())%>");
			document.getElementById("datasource_"+rowindex).value = "";
			document.getElementById("datasourcespan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			
			return false;
		}
		if(isFullwidthChar(thisvalue)){
			//数据源名称包含全角符号，请重新输入！
			top.Dialog.alert(thisvalue+"<%=SystemEnv.getHtmlLabelName(127372,user.getLanguage())%>");
			document.getElementById("datasource_"+rowindex).value = "";
			document.getElementById("datasourcespan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			
			return false;
		}*/
		
        for(var i=0;i<dsnums;i++){
            if(i!=rowindex){
                otherdsname = document.getElementById("datasource_"+i).value;
                if(thisvalue==otherdsname){
                    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23993,user.getLanguage())%>");//该数据源已存在！
                    document.getElementById("datasource_"+rowindex).value = "";
                    document.getElementById("datasourcespan_"+rowindex).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
							
					return false;
                }
            }
        }
    }
	
	return true;
}

function vaidDataminconn(obj) {
	var minconn = "minconn_" + obj;
	var maxconn = "maxconn_" + obj;
	var minval = $.trim(document.getElementById(minconn).value);
	var maxval = $.trim(document.getElementById(maxconn).value);
	
	if(minval == "") {
		document.getElementById(minconn).value = "";
		document.getElementById(minconn).focus();
	} else {
		var reg = /^[0-9]*$/;
		if(!reg.test(minval)) {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("23671,24475",user.getLanguage())%>");
			document.getElementById(minconn).value = "";
			document.getElementById(minconn).focus();
		} else {
			if(parseInt(minval) > parseInt(maxval)) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83609,user.getLanguage())%>");
     			document.getElementById(minconn).value = "";
     			document.getElementById(maxconn).value = "";
     			document.getElementById(minconn).focus();
			} else {
				document.getElementById(minconn).value = parseInt(minval);
			}
		}
	}
}

function vaidDatamaxconn(obj) {
	var minconn = "minconn_" + obj;
	var maxconn = "maxconn_" + obj;
	var minval = $.trim(document.getElementById(minconn).value);
	var maxval = $.trim(document.getElementById(maxconn).value);
	
	if(maxval == "") {
		document.getElementById(maxconn).value = "";
		document.getElementById(maxconn).focus();
	} else {
		var reg = /^[0-9]*$/;
		if(!reg.test(maxval)) {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("20522,24475",user.getLanguage())%>");
			document.getElementById(maxconn).value = "";
			document.getElementById(maxconn).focus();
		} else {
			if(parseInt(maxval) < parseInt(minval)) {
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83609,user.getLanguage())%>");
     			document.getElementById(minconn).value = "";
     			document.getElementById(maxconn).value = "";
     			document.getElementById(minconn).focus();
			} else {
				document.getElementById(maxconn).value = parseInt(maxval);
			}
		}
	}
}

//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//是否含有中文（也包含日文和韩文）
function isChineseChar(str){   
   var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
   return reg.test(str);
}
//是否含有全角符号的函数
function isFullwidthChar(str){
   var reg = /[\uFF00-\uFFEF]/;
   return reg.test(str);
}

function checkNumber3(obj) {
	var port = "Port_" + obj;
	var value = $.trim(document.getElementById(port).value);
	
	if(value == "") {
		document.getElementById(port).value = "";
	} else {
		if(isNaN(value)) {
			document.getElementById(port).value = "";
		} else {
			document.getElementById(port).value = parseInt(value) == 0 ? "" : parseInt(value);
		}
	}
}

</script>

</HTML>
