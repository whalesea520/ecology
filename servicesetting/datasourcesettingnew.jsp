
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:datasourcesetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String typename=Util.null2String(request.getParameter("typename"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String from = Util.null2String(request.getParameter("from"));
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23660,user.getLanguage());
String needfav ="1";
String needhelp ="";

String typepointid = "";
String dbtype = "";
String iscluster = "";
String url = "";
String HostIP = "";
String Port = "";
String DBname = "";
String username = "";
String password = "";
String minconn = "5";
String maxconn = "10";
String iscode = "";
if("1".equals(iscode))
{
	username = SecurityHelper.encrypt("ecology",username);
	password = SecurityHelper.encrypt("ecology",password);
}

ArrayList pointArrayList = DataSourceXML.getPointArrayList();
Hashtable dataHST = DataSourceXML.getDataHST();
Hashtable thisDetailHST = null;
if(!"".equals(typename))
{
	for(int i=0;i<pointArrayList.size();i++){
		String pointid = Util.null2String((String)pointArrayList.get(i));
		thisDetailHST = (Hashtable)dataHST.get(pointid);
	    if(thisDetailHST!=null)
	    {
	        String temptypename = Util.null2String((String)thisDetailHST.get("typename"));
	        if(typename.equals(temptypename))
	        {
	        	typepointid = pointid;
	        	
	        	dbtype = Util.null2String((String)thisDetailHST.get("type"));
		        iscluster = Util.null2String((String)thisDetailHST.get("iscluster"));
		        iscluster = iscluster.equals("")?"1":iscluster;
		        url = Util.null2String((String)thisDetailHST.get("url"));
		        HostIP = Util.null2String((String)thisDetailHST.get("host"));
		        Port = Util.null2String((String)thisDetailHST.get("port"));
		        DBname = Util.null2String((String)thisDetailHST.get("dbname"));
		        username = Util.null2String((String)thisDetailHST.get("user"));
		        password = Util.null2String((String)thisDetailHST.get("password"));
		        minconn = Util.null2String((String)thisDetailHST.get("minconn"));
				if(minconn.equals("")) minconn = "5";
		        maxconn = Util.null2String((String)thisDetailHST.get("maxconn"));
				if(maxconn.equals("")) maxconn = "10";
		        iscode = Util.null2String((String)thisDetailHST.get("iscode"));
		        
		        if("1".equals(iscode))
		        {
		        	username = SecurityHelper.decrypt("ecology",username);
		        	password = SecurityHelper.decrypt("ecology",password);
		        }
		        
	        	break;
	        }
	    }
    }
}

String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
	String pointid = Util.null2String((String)pointArrayList.get(i));
	if(!"".equals(typepointid))
	{
		if(pointid.equals(typepointid))
			continue;
	}
    pointids += pointid+",";
}
//String tiptitle = "填写完整的url连接串，oracle集群url举例:jdbc:oracle:thin:@(description=(address_list= (address=(host=地址) (protocol=tcp)(port=1521))(address=(host=地址)(protocol=tcp) (port=1521)) (load_balance=yes)(failover=yes))(connect_data=(service_name= 服务名)))；sqlserver集群使用偏移地址即可；mysql集群举例：jdbc:mysql:replication://127.0.0.1:3309,127.0.0.1:3306/core。";//SystemEnv.getHtmlLabelName(32355,user.getLanguage())
String tiptitle = SystemEnv.getHtmlLabelName(32355,user.getLanguage())+"<br/>"+SystemEnv.getHtmlLabelName(124995,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(124996,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(125535,user.getLanguage())+"<br/>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(125536,user.getLanguage());
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
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
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="datasource">
<input type="hidden" id="method" name="method" value="add">
<input type=hidden id="iscode" name="iscode" value="1">
<input type=hidden id="typename" name="typename" value="<%=typename %>">
<input type=hidden id="from" name="from" value="<%=from %>">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
<div id="loading" style="display:none;">
	<span><img src="/images/loading2_wev8.gif" align="absmiddle">&nbsp;<%=SystemEnv.getHtmlLabelName(25496, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(25007, user.getLanguage())%></span>
</div>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21955,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<wea:required id="datasourcespan" required="true" value='<%=typepointid %>'>
	  		<input style='width:160px!important;' class="inputstyle" type=text id="datasource" name="datasource" onChange="checkinput('datasource','datasourcespan')" value="<%=typepointid %>" onblur="isExist(this.value)">
	  	</wea:required>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></wea:item>
	  <wea:item>
			<select style='width:120px!important;' id="dbtype" name="dbtype" onchange="javascript:changeCluster();">
				<option value="sqlserver" <%if(dbtype.equals("sqlserver")){%>selected<%}%>>sqlserver2000</option>
				<option value="sqlserver2005" <%if(dbtype.equals("sqlserver2005")){%>selected<%}%>>sqlserver2005</option>
				<option value="sqlserver2008" <%if(dbtype.equals("sqlserver2008")){%>selected<%}%>>sqlserver2008</option>
				<option value="oracle" <%if(dbtype.equals("oracle")){%>selected<%}%>>oracle</option>
				<option value="oracle12c" <%if(dbtype.equals("oracle12c")){%>selected<%}%>>oracle12c</option>
				<option value="mysql" <%if(dbtype.equals("mysql")){%>selected<%}%>>mysql</option>
				<option value="db2" <%if(dbtype.equals("db2")){%>selected<%}%>>db2</option>
				<option value="sybase" <%if(dbtype.equals("sybase")){%>selected<%}%>>sybase</option>
				<option value="informix" <%if(dbtype.equals("informix")){%>selected<%}%>>informix</option>
				<option value="hana" <%if(dbtype.equals("hana")){%>selected<%}%>>hana</option>
			</select>
	  </wea:item>
	  <wea:item attributes="{'samePair':'isclustertr'}"><div id="isclusterDiv"><%=SystemEnv.getHtmlLabelName(126687,user.getLanguage())%></div></wea:item><!-- 集群/多实例 -->
	  <wea:item attributes="{'samePair':'isclustertr'}">
		<input type="checkbox" id="iscluster" name="iscluster" value="<%=iscluster%>" <%if(iscluster.equals("2")){%>checked<%}%> <%if(iscluster.equals("2")){%>title=<%=SystemEnv.getHtmlLabelName(24897,user.getLanguage())%><%}else{%>title=<%=SystemEnv.getHtmlLabelName(24898,user.getLanguage())%><%} %> onclick="if(this.checked){this.value=2;this.title='<%=SystemEnv.getHtmlLabelName(24897,user.getLanguage())%>';}else{this.value=1;this.title='<%=SystemEnv.getHtmlLabelName(24898,user.getLanguage())%>';};changeCluster();">
		<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=tiptitle %>"><IMG align=absMiddle src="/images/remind_wev8.png"></SPAN>
	  </wea:item>
	  <wea:item attributes="{'samePair':'urltr'}"><%=SystemEnv.getHtmlLabelName(32357,user.getLanguage())%></wea:item><!-- 连接字符串 -->
	  <wea:item attributes="{'samePair':'urltr'}">
	  	<input class="inputstyle" type=text size=100 style='width:400px!important;' id="url" name="url" value="<%=url %>">
	  </wea:item>
	
	  <wea:item attributes="{'samePair':'HostIPtr'}"><%=SystemEnv.getHtmlLabelName(15038,user.getLanguage())%>IP</wea:item>
	  <wea:item attributes="{'samePair':'HostIPtr'}">
	  	<input style='width:120px!important;' class="inputstyle" type=text id="HostIP" name="HostIP" value="<%=HostIP %>">
	  </wea:item>
	  <wea:item attributes="{'samePair':'Porttr'}"><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
	  <wea:item attributes="{'samePair':'Porttr'}">
		<input style='width:70px!important;ime-mode:disabled;' class="inputstyle" type=text size=10 maxlength="10" id="Port" name="Port" value="<%=Port %>" onpaste="return false" 
			onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onBlur="checkNumber3(this.value)"><!-- 306919 修复端口号不能输入数字 -->
	  </wea:item>
	  <wea:item attributes="{'samePair':'DBnametr'}"><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></wea:item>
	  <wea:item attributes="{'samePair':'DBnametr'}">
	  	<input style='width:120px!important;' class="inputstyle" type=text id="DBname" name="DBname" value="<%=DBname %>">
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(2072,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<input style='width:120px!important;' class="inputstyle" type=text id="user" name="user" value="<%=username %>">
	  </wea:item>
	
	  <wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<input style='width:120px!important;' class="inputstyle" type=password id="password" name="password" value="<%=password %>">
	  </wea:item>
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(23671,user.getLanguage())%></wea:item>
	  <wea:item>
  		<input style='width:70px!important;ime-mode:disabled;' class="inputstyle" type=text size="10" maxlength="10" id="minconn" name="minconn" value="<%=minconn %>" onpaste="return false" 
  			onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onBlur="checkNumber2('min',this.value)">
  	  </wea:item>
  	  <wea:item><%=SystemEnv.getHtmlLabelName(20522,user.getLanguage())%></wea:item>
  	  <wea:item>
  		<input style='width:70px!important;ime-mode:disabled;' class="inputstyle" type=text size="10" maxlength="10" id="maxconn" name="maxconn" value="<%=maxconn %>" onpaste="return false" 
  			onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" onBlur="checkNumber2('max',this.value)">
  	  </wea:item>
	  
	  <wea:item>&nbsp;</wea:item>
	  <wea:item>
	  	<SPAN class="testspan" style="BORDER-BOTTOM: medium none; TEXT-ALIGN: center; BORDER-LEFT: medium none; LINE-HEIGHT: 21px; WIDTH: 38px; DISPLAY: inline-block; BACKGROUND: url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat; HEIGHT: 21px; BORDER-TOP: medium none; CURSOR: pointer; MARGIN-RIGHT: 5px; BORDER-RIGHT: medium none" onclick="getTest();"><%=SystemEnv.getHtmlLabelName(25496, user.getLanguage())%></SPAN>
	  </wea:item>
	</wea:group>
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
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>

<script language="javascript">
$(document).ready(function(){
	changeCluster();
	jQuery(".e8tips").wTooltip({html:true});
});
function changeCluster()
{
	var iscluster = document.getElementById("iscluster").value;
	var dbtype = document.getElementById("dbtype").value;
	//alert("iscluster : "+iscluster+" dbtype : "+dbtype);
	if(dbtype=='oracle'||dbtype=='oracle12c'||dbtype=='mysql'||dbtype=='sqlserver'||dbtype=='sqlserver2005'||dbtype=='sqlserver2008')
	{
		/*if(dbtype=='sqlserver'||dbtype=='sqlserver2005'||dbtype=='sqlserver2008')
		{
			jQuery("#isclusterDiv").text("<%=SystemEnv.getHtmlLabelName(125534,user.getLanguage())%>");
		}else{
			jQuery("#isclusterDiv").text("<%=SystemEnv.getHtmlLabelName(32356,user.getLanguage())%>");
		}*/
		try
		{
			showEle("isclustertr");
		}
		catch(e)
		{
		}
		if(iscluster=='2')
		{
			//alert("1 iscluster : "+iscluster+" dbtype : "+dbtype);
			showEle("urltr");
		
			hideEle("HostIPtr");
			hideEle("Porttr");
			hideEle("DBnametr");
		}
		else
		{
			//alert("2 iscluster : "+iscluster+" dbtype : "+dbtype);
			hideEle("urltr");
		
			showEle("HostIPtr");
			showEle("Porttr");
			showEle("DBnametr");
		}
	}
	else
	{
		hideEle("isclustertr");
		hideEle("urltr");
		
		showEle("HostIPtr");
		showEle("Porttr");
		showEle("DBnametr");
	}
	jQuery(".e8tips").wTooltip({html:true});
}
function getTest()
{
    //alert("test : "+idx);
    var dbtype = jQuery("#dbtype").val();
    var iscluster = jQuery("#iscluster").val();
    if(iscluster == "") {
		iscluster = "1";
    }
    var url = jQuery("#url").val();
    var HostIP = jQuery("#HostIP").val();
    var Port = jQuery("#Port").val();
    var DBname = jQuery("#DBname").val();
    var user = jQuery("#user").val();
    var password = jQuery("#password").val();
    
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
function onSubmit(){
	var min = document.getElementById("minconn").value;
    var max = document.getElementById("maxconn").value;
   
    if(parseInt(max)<parseInt(min))
    {
     top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83609,user.getLanguage())%>");
     document.getElementById("maxconn").focus();
     document.getElementById("maxconn").select();
     return ;
    }
	if(isExist(frmMain.datasource.value))
	{
    	if(check_form(frmMain,"datasource")) frmMain.submit();
    }
}
function onBack()
{
	parentWin.closeDialog();
}
function isExist(newvalue){
	newvalue = $.trim(newvalue);
	if(isSpecialChar(newvalue)){
		//数据源名称包含特殊字段，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127370,user.getLanguage())%>");
        document.getElementById("datasource").value = "";
        document.getElementById("datasourcespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isChineseChar(newvalue)){
		//数据源名称包含中文，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127371,user.getLanguage())%>");
        document.getElementById("datasource").value = "";
        document.getElementById("datasourcespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isFullwidthChar(newvalue)){
		//数据源名称包含全角符号，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127372,user.getLanguage())%>");
        document.getElementById("datasource").value = "";
        document.getElementById("datasourcespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>-1){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23993,user.getLanguage())%>");
        document.getElementById("datasource").value = "";
        document.getElementById("datasourcespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
    }
    return true;
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

function checkNumber2(type, value) {
	value = $.trim(value);
	var val = parseInt(value);
	
	if(type == "min") {
		if(value == "") {
			$("#minconn").val(<%=minconn %>);
		} else {
			if(isNaN(value)) {
				$("#minconn").val(<%=minconn %>);
			} else {
				$("#minconn").val(val == 0 ? <%=minconn %> : val);
			}
		}
	} else {
		if(value == "") {
			$("#maxconn").val(<%=maxconn %>);
		} else {
			if(isNaN(value)) {
				$("#maxconn").val(<%=maxconn %>);
			} else {
				$("#maxconn").val(val == 0 ? <%=maxconn %> : val);
			}
		}
	}
}

function checkNumber3(value) {
	value = $.trim(value);
	if(value == "") {
		$("#Port").val("");
	} else {
		if(isNaN(value)) {
			$("#Port").val("");
		} else {
			$("#Port").val(parseInt(value) == 0 ? "" : parseInt(value));
		}
	}
}

</script>
</HTML>
