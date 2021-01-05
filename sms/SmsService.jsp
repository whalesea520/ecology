
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.sms.annotation.AnnotationUtils"%>
<%@page import="java.lang.reflect.Field"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.InputStream"%>

<%@page import="weaver.sms.annotation.SmsField"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.sms.SMSManager,weaver.rtx.RTXConfig,weaver.servicefiles.SMSXML,weaver.servicefiles.DataSourceXML" %>
<%@ page import="weaver.servicefiles.ResetXMLFileCache,net.sf.json.JSONArray,net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rtxConfig" class="weaver.rtx.RTXConfig" scope="page"/>
<jsp:useBean id="SystemComInfo" class="weaver.system.SystemComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<HTML><HEAD>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<style>
	.check{
		margin-left:5px;
		display:inline-block;
		min-width:25px;
		height:20px;
		background:#FFF;
		padding-left:10px;
		padding-right:10px;
		color:#1098ff;
		border:1px solid #aecef1;
		font-size:12px;
		cursor: pointer;
	}
	.gingerimg{
		position: relative;
		background:#FFF;
		border:1px solid #E6E6E6;
		width:400px;
		height:300px;
		z-index: 1;
		position: absolute;
		top:20px;
		left:40px;
	}
	.downloaddrivebtn{
		margin-left:5px;
		display:inline-block;
		cursor:pointer;
		vertical-align:middle;
		width:20px;
		height:20px;
	}
</style>
</head>
<%!
public static List fileList(String folderPath) {
	List list=new ArrayList();
	if(!folderPath.endsWith("/") && !folderPath.endsWith("\\")){
		folderPath+="/sms/drive";
	}else{
		   folderPath+="drive";
	}
	File file = new File(folderPath);
    File[] fileList = file.listFiles();
    for (int i = 0; i < fileList.length; i++) {
        if (fileList[i].isDirectory()) {
            File fileSon = fileList[i];
            list.add(fileSon.getName());
        }
    }
    return list;
}
%>
<%
if(!HrmUserVarify.checkUserRight("Sms:Set", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String method=Util.null2String(request.getParameter("method"));
boolean showAll="1".equals(RecordSet.getPropValue("smsService","isAll"));
String path = GCONST.getRootPath()+File.separator+"sms"+File.separator;

String operate=Util.null2String(request.getParameter("operate"));
String serverType="";
boolean isValid=true;
SMSXML smsxml=null;
boolean constructclassExist=true;
if("save".equals(operate)){
	serverType=Util.null2String(request.getParameter("serverType"));
	
	if(RTXConfig.CUR_SMS_SERVER_MODEN.equals(serverType)){//只保存短信猫地址
		String smsserver=Util.null2String(request.getParameter("smsserver"));
		RecordSet.executeSql("update SystemSet set smsserver='"+smsserver+"'");
		SystemComInfo.removeSystemCache();
	}else if(RTXConfig.CUR_SMS_SERVER_CUS.equals(serverType)){//第三方接口
		//允许编辑第三方接口
		if(showAll){
			String interfacetype = Util.null2String(request.getParameter("interfacetype"));
		    String constructclass = Util.null2String(request.getParameter("constructclass"));
		    ArrayList propertyArr = new ArrayList();
		    ArrayList valueArr = new ArrayList();
		    if(interfacetype.equals("1")){//通用短信接口
		        constructclass = "weaver.sms.JdbcSmsService";
		        String type = Util.null2String(request.getParameter("type"));
		        String host = Util.null2String(request.getParameter("host"));
		        String port = Util.null2String(request.getParameter("port"));
		        String dbname = Util.null2String(request.getParameter("dbname"));
		        String username = Util.null2String(request.getParameter("username"));
		        String password = Util.null2String(request.getParameter("password"));
		        String sql = Util.null2String(request.getParameter("sql"));
		        String dbcharset=Util.null2String(request.getParameter("dbcharset"));
		        propertyArr.add("type");
		        propertyArr.add("host");
		        propertyArr.add("port");
		        propertyArr.add("dbname");
		        propertyArr.add("username");
		        propertyArr.add("password");
		        propertyArr.add("sql");
		        if("mysql".equals(type)){
		        	 propertyArr.add("dbcharset");
		        }
		        
		        valueArr.add(type);
		        valueArr.add(host);
		        valueArr.add(port);
		        valueArr.add(dbname);
		        valueArr.add(username);
		        valueArr.add(password);
		        valueArr.add(sql);
		         if("mysql".equals(type)){
		        	 valueArr.add(dbcharset);
		        }
		        
		    }else if(interfacetype.equals("3")){
		    	
		    	constructclass= "weaver.sms.JdbcSmsServiceNew";
		    	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
		        String sql = Util.null2String(request.getParameter("sql"));
		        String dbcharset4ds = Util.null2String(request.getParameter("dbcharset4ds"));
		        propertyArr.add("datasourceid");
		        propertyArr.add("sql");
		        propertyArr.add("dbcharset");
		        
		        valueArr.add(datasourceid);
		        valueArr.add(sql);
		        valueArr.add(dbcharset4ds);
		    }else{//自定义短信接口
		    	String CommonSmsInterface=Util.null2String(request.getParameter("CommonSmsInterface"));
		    	if("1".equals(CommonSmsInterface)){
		    		constructclass=request.getParameter("smsClazzName");
			    	int propertynum = Util.getIntValue(Util.null2String(request.getParameter("clazz_rowcount")),0);
		    		for(int i=0;i<propertynum;i++){
			            String propertyS = Util.null2String(request.getParameter("attrP_"+i));
			            String valueS = Util.null2String(request.getParameter("attrV_"+i));
			            propertyArr.add(propertyS);
			            valueArr.add(valueS);
			        }
		    	}else{
			    	int propertynum = Util.getIntValue(Util.null2String(request.getParameter("rowcount")),0);
			        for(int i=0;i<propertynum;i++){
			        	int rowid_tmp = Util.getIntValue(request.getParameter("rowid_"+i), -1);
			        	if(rowid_tmp <= 0){
							continue;
						}
			            String propertyS = Util.null2String(request.getParameter("property_"+i));
			            if(propertyS.equals("")) continue;
			            String valueS = Util.null2String(request.getParameter("value_"+i));
			            propertyArr.add(propertyS);
			            valueArr.add(valueS);
			        }
		    	}
		    }
		    smsxml=new SMSXML();
		    smsxml.writeToSMSXML(constructclass,propertyArr,valueArr);
		    ResetXMLFileCache.resetCache();
		    //判断接口类是否存在
		    try{
	   			Class.forName(constructclass);
	   		}catch(Throwable e){
	   			constructclassExist=false;
	   		}
		}
	}
	SMSManager smsManager = new SMSManager();
	isValid = smsManager.changeServerType(serverType);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"短信服务设置","短信应用设置-服务设置","316","2",0,Util.getIpAddr(request));
}else if("change2DS".equals(operate)){
	serverType=Util.null2String(request.getParameter("serverType"));
	
	if(RTXConfig.CUR_SMS_SERVER_CUS.equals(serverType)){//第三方接口
		//允许编辑第三方接口
		if(showAll){
		    ArrayList propertyArr = new ArrayList();
		    ArrayList valueArr = new ArrayList();
		    Hashtable dataHST = new Hashtable();
		    //第一步生成数据源
		    String pointids = ",";
		    DataSourceXML dsxml=new DataSourceXML();
		    ArrayList pointArrayList = dsxml.getPointArrayList();
		    for(int i=0;i<pointArrayList.size();i++){
		    	String pointid = Util.null2String((String)pointArrayList.get(i));
		        pointids += pointid+",";
		    }
		    String pointid="SMS"+TimeUtil.getCurrentDateString();
		    pointid=pointid.replace("-","");
	        String sql = Util.null2String(request.getParameter("sql"));
		    if(pointids.indexOf(","+pointid+",")==-1){//不存在
			    String customid = "";
		   		String typename = "";
		   		String type = Util.null2String(request.getParameter("type"));
		        String host = Util.null2String(request.getParameter("host"));
		        String port = Util.null2String(request.getParameter("port"));
		        String dbname = Util.null2String(request.getParameter("dbname"));
		        String username = Util.null2String(request.getParameter("username"));
		        String password = Util.null2String(request.getParameter("password"));
		        String iscluster = "";
		        String minconn = "5";
		        String maxconn = "20";
		        String iscode = "1";
	        
		        if("1".equals(iscode))
		        {
		        	username = SecurityHelper.encrypt("ecology",username);
		        	password = SecurityHelper.encrypt("ecology",password);
		        }
		        dataHST.put("type",type);
		        dataHST.put("datasourcename",pointid);
		        dataHST.put("iscluster",iscluster);
		        dataHST.put("url","");
		        dataHST.put("host",host);
		        dataHST.put("port",port);
		        dataHST.put("dbname",dbname);
		        dataHST.put("user",username);
		        dataHST.put("password",password);
		        dataHST.put("minconn",minconn);
		        dataHST.put("maxconn",maxconn);
		        dataHST.put("iscode",iscode);
		        dataHST.put("typename",typename);
		        dataHST.put("customid",customid);
	        
		        dsxml.writeToDataSourceXMLAdd(pointid,dataHST);
		    } 
		    //第二步,保存数据源存储结构
		    String constructclass= "weaver.sms.JdbcSmsServiceNew";//
	        propertyArr.add("datasourceid");
	        propertyArr.add("sql");
	        propertyArr.add("dbcharset");
	        
	        valueArr.add("datasource."+pointid);
	        valueArr.add(sql);
	        valueArr.add("");
		     
		    smsxml=new SMSXML();
		    smsxml.writeToSMSXML(constructclass,propertyArr,valueArr);
		    ResetXMLFileCache.resetCache();
		}
	}
	SMSManager smsManager = new SMSManager();
	isValid = smsManager.changeServerType(serverType);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.insSysLogInfo(user,0,"短信服务设置","短信应用设置-通用接口迁移至数据源","316","2",0,Util.getIpAddr(request));
}
//短信猫 服务器地址
RecordSet.executeSql("select smsserver from SystemSet");
RecordSet.next();
String smsserver = Util.null2String(RecordSet.getString("smsserver"));
//短信服务方式
serverType = new RTXConfig().getPorp(RTXConfig.CUR_SMS_SERVER);
serverType = serverType == null?"":serverType;

//读取第三方短信接口
smsxml=new SMSXML();
String constructclass = Util.null2String(smsxml.getConstructClass());
ArrayList propertyArr = smsxml.getPropertyArr();
ArrayList valueArr = smsxml.getValueArr();
Hashtable dataHST = new Hashtable();
for(int i=0;i<propertyArr.size();i++){
    String propertyS = (String)propertyArr.get(i);
    String valueS = (String)valueArr.get(i);
    dataHST.put(propertyS,valueS);
}
boolean isSystemClazz=false;
boolean isGenaral = true;
int otherType=2;//非通用模式下的其他模式(2:自定义接口 3:数据源)

String type = "";
String host = "";
String port = "";
String dbname = "";
String username = "";
String password = "";
String sql = "";
String dbcharset="";
String mysqlcharset="";
String datasourceid = "";
String smsClazzId="";
String dbcharset4ds="";
if(constructclass.equals("weaver.sms.JdbcSmsService")){
    isGenaral = true;
    type = Util.null2String(dataHST.get("type"));
    host = Util.null2String(dataHST.get("host"));
    port = Util.null2String(dataHST.get("port"));
    dbname = Util.null2String(dataHST.get("dbname"));
    username = Util.null2String(dataHST.get("username"));
    password = Util.null2String(dataHST.get("password"));
    sql = Util.null2String(dataHST.get("sql"));
    if("mysql".equals(type)){
    	dbcharset=(String)dataHST.get("dbcharset");
    }
}else{
    isGenaral = false;
    if(constructclass.equals("weaver.sms.JdbcSmsServiceNew")){
    	otherType=3;
    	datasourceid=Util.null2String(dataHST.get("datasourceid"));
    	sql = Util.null2String(dataHST.get("sql"));
    	dbcharset4ds=Util.null2String(dataHST.get("dbcharset"));
    }else{
    	//判断当前选择类是否是常用短信接口
    	if(!"".equals(constructclass)){
    		RecordSet.execute("select id,clazzname from sms_interface where clazzname='"+constructclass+"'");
    		if(RecordSet.next()){
    			if(constructclass.equals(RecordSet.getString("clazzname"))){
	    			isSystemClazz=true;
    			}else{
			   		constructclassExist=false;
    			}
    			//加载时需要加载2份...
    			smsClazzId=RecordSet.getString("id");
    		}
    	}
    	
    }
}


String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23664,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<form id="frmmain" name="frmmain" method="post" action="SmsService.jsp">
<input type="hidden" id="operate" name="operate" value="save">
<input type="hidden" name="method" value="<%=method %>">
<input type="hidden" id="smsClazzName" name="smsClazzName" value="<%=constructclass%>">
<input type="hidden" id="smsClazzId" value="<%=smsClazzId%>">
<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<wea:layout type="2Col">
			     
			     <!-- 短信方式 -->
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage()) %>'  >
				      <wea:item><%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%></wea:item>
				      <wea:item>
				      		<select id="serverType" name="serverType" onchange="changeSMSType()">
				      			<option value="<%=RTXConfig.CUR_SMS_SERVER_RTX%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_RTX)?"selected":""%>>RTX&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%></option>
				      			<option value="<%=RTXConfig.CUR_SMS_SERVER_MODEN%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_MODEN)?"selected":""%>>Modem&nbsp;<%=SystemEnv.getHtmlLabelName(18635,user.getLanguage())%></option>
				      			<%if(showAll){ %>
				      			<option value="<%=RTXConfig.CUR_SMS_SERVER_CUS%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_CUS)?"selected":""%>><%=SystemEnv.getHtmlLabelName(22752,user.getLanguage())%></option>
				      			<%} %>
				      			<option value="<%=RTXConfig.CUR_SMS_SERVER_NO%>" <%=serverType.equals(RTXConfig.CUR_SMS_SERVER_NO)?"selected":""%>><%=SystemEnv.getHtmlLabelName(18636,user.getLanguage())%></option>
				      		</select>
				      </wea:item>
			      
				      <wea:item attributes="{'samePair':'Modemtd'}"><%=SystemEnv.getHtmlLabelName(16953,user.getLanguage())%>IP</wea:item>
				      <wea:item attributes="{'samePair':'Modemtd'}">
				      		<input type="text" id="smsserver" name="smsserver"  value="<%=Util.toScreenToEdit(smsserver,user.getLanguage())%>" maxlength="50" class="InputStyle"> <span><img class="remindImg" src="/wechat/images/remind_wev8.png" align="absMiddle" title="IP<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%> 127.0.0.1  <%=SystemEnv.getHtmlLabelName(127660,user.getLanguage())%> 127.0.0.1:<%=SystemEnv.getHtmlLabelName(84629,user.getLanguage())%>"></span><span class="check" onclick="check()"><%=SystemEnv.getHtmlLabelName(22011,user.getLanguage())%></span>
				      </wea:item>
				      <wea:item attributes="{'samePair':'Modemtd'}"><%=SystemEnv.getHtmlLabelName(127668,user.getLanguage())%></wea:item>
				      <wea:item attributes="{'samePair':'Modemtd'}">
				      		http://ecology IP:ecology Port/sms/iSMSEvent.jsp <span style="margin-left:10px"><img class="remindImg" src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(127659,user.getLanguage())%>"></span><a href="/sms/images/ginger_wev8.png" target="blank"><span class="check" style="position: relative;" ><%=SystemEnv.getHtmlLabelName(82159,user.getLanguage())%></span></a></span>
				      </wea:item>
				      </wea:group>
				      
				      <wea:group context='<%=SystemEnv.getHtmlLabelNames("127667,82620",user.getLanguage()) %>' attributes="{'samePair':'SmsServiceDriver','groupOperDisplay':'none','groupDisplay':'none'}" >
				      
				      <wea:item attributes="{'samePair':'Modemtd','colspan':'2'}"><span style="margin-left:5px;color:red"> <%=SystemEnv.getHtmlLabelName(127657,user.getLanguage())%></span>
				      </wea:item>
				      <%List list=fileList(path);
				      		if(list.size()>0){
				      			for(int i=0;i<list.size();i++){
				      				%> <wea:item attributes="{'samePair':'Modemtd','colspan':'2'}">
				      					<a style="color:#018efb" href="javascript:downloadDrive('<%=list.get(i)%>')" title="<%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><%=list.get(i)%>"><%=SystemEnv.getHtmlLabelName(258,user.getLanguage())%><%=list.get(i)%></a>
				      				 </wea:item>
				      				<%
				      			}
				      		}
				      %>
			     </wea:group>
			     <%if(showAll){ %>
			     <!-- 短信接口 -->
			     <wea:group context='<%=titlename%>'  attributes="{'samePair':'SmsServiceGroup','itemAreaDisplay':'inline-block'}">
				      <wea:item><%=SystemEnv.getHtmlLabelName(599,user.getLanguage())%></wea:item>
				      <wea:item>
				      		<select id="interfacetype" name="interfacetype" onchange="changeInterface()">
						  		<option value=1 <%if(isGenaral){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23684,user.getLanguage())%></option>
						  		<option value=3 <%if(!isGenaral&&otherType==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%></option>
						  		<option value=2 <%if(!isGenaral&&otherType==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(23685,user.getLanguage())%></option>
						  	</select>
						  	
						  	<span id="Genaral2DSSms" class="e8_browserSpan " style="display:none">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(126230,user.getLanguage())%>" onClick="change2DS();" class="e8_btn_submit"/>
				      		</span>
				      		
				      		<span id="CommonSmsInterfaceSpan" style="display:none">
				      			<input type="checkbox" id="CommonSmsInterface" name="CommonSmsInterface" value="1" <%=isSystemClazz?"checked":"" %> onclick="doCommonSmsInterface()"><%=SystemEnv.getHtmlLabelName(126231,user.getLanguage())%>&nbsp;&nbsp;
				      		</span>
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(23683,user.getLanguage())%></wea:item>
				      <wea:item>
				      		<span id="constructclassSpan" style="display:<%=isSystemClazz?"none":"block" %>"> 
				      			<input class="InputStyle" type="text" id="constructclass" name="constructclass" size="50" value="<%=constructclass%>" >
				      		</span>
				      		
				      		<span id="SmsCatalogSpan" style="display:<%=isSystemClazz?"block":"none" %>"">
								<input type="button" value="<%=SystemEnv.getHtmlLabelName(126232,user.getLanguage())%>" onClick="openSmsCatalog()" class="e8_btn_submit"/>
								<span id="SmsCatalogShowSpan"><%=isSystemClazz?constructclass:"" %></span>
				      		</span>
						      
				      </wea:item>
				      
					
					  <wea:item attributes="{'isTableList':'true','samePair':'SmsServiceDBGroup','colspan':'full'}" >
						<wea:layout type="2Col">
							<wea:group context='<%=SystemEnv.getHtmlLabelName(23684,user.getLanguage())+SystemEnv.getHtmlLabelName(561,user.getLanguage())%>'  attributes="{'groupOperDisplay':'none','groupDisplay':'none'}">
							      <wea:item attributes="{'samePair':'SmsServiceDB'}"><%=SystemEnv.getHtmlLabelName(15025,user.getLanguage())%></wea:item>
							      <wea:item attributes="{'samePair':'SmsServiceDB'}">
							      		<select id="type" name="type" onchange="changeDBType()">
											<option value="sqlserver" <%if(type.equals("sqlserver")){%>selected<%}%>>sqlserver2000</option>
											<option value="sqlserver2005" <%if(type.equals("sqlserver2005")){%>selected<%}%>>sqlserver2005</option>
											<option value="sqlserver2008" <%if(type.equals("sqlserver2008")){%>selected<%}%>>sqlserver2008</option>
											<option value="oracle" <%if(type.equals("oracle")){%>selected<%}%>>oracle</option>
											<option value="mysql" <%if(type.equals("mysql")){%>selected<%}%>>mysql</option>
											<option value="db2" <%if(type.equals("db2")){%>selected<%}%>>db2</option>
										</select>
							      </wea:item>
							      
							      <wea:item><%=SystemEnv.getHtmlLabelName(2071,user.getLanguage())%>ip</wea:item>
							      <wea:item>
							      		<input class="InputStyle" type="text" size="50" id="host" name="host" value="<%=host%>">
							      </wea:item>
							      
							      <wea:item><%=SystemEnv.getHtmlLabelName(18782,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<input class="InputStyle" type="text" size="50" id="port" name="port" value="<%=port%>">
							      </wea:item>
							      
							      <wea:item><%=SystemEnv.getHtmlLabelName(15026,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<input class="InputStyle" type="text" size="50" id="dbname" name="dbname" value="<%=dbname%>">
							      </wea:item>
							      
							      <wea:item><%=SystemEnv.getHtmlLabelName(2024,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<input class="InputStyle" type="text" size="50" id="username" name="username" value="<%=username%>">
							      </wea:item>
							      
							      <wea:item><%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<input class="InputStyle" type="password" size="50" id="password" name="password" value="<%=password%>">
							      </wea:item>
							      
							      <wea:item  attributes="{'samePair':'mysqltd'}"><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item>
							      <wea:item  attributes="{'samePair':'mysqltd'}">
							      		<input class="inputstyle" type="text" size="50" id="dbcharset" name="dbcharset" value="<%=dbcharset%>">
							      </wea:item>
						     </wea:group>
						</wea:layout>
					   </wea:item>
					   
					   <wea:item attributes="{'isTableList':'true','samePair':'datasource','colspan':'full'}" >
						<wea:layout type="2Col">
							<wea:group context='<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>'  attributes="{'groupOperDisplay':'none','groupDisplay':'none'}">
							      <wea:item ><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></wea:item>
								  <wea:item >
										<select id="datasourceid" name="datasourceid" style='width:160px!important;'>
											<option></option>
											<%	
												DataSourceXML dsxml1=new DataSourceXML();
											    List datasourceList = dsxml1.getPointArrayList();
												for (int i = 0; i < datasourceList.size(); i++)
												{
													String pointid = Util.null2String((String) datasourceList.get(i));
											%>
											<option value="datasource.<%=pointid%>" <%if(("datasource."+pointid).equals(datasourceid)){ %>selected<%} %>><%=pointid%></option>
											<%
												}
											%>
										</select>
										<input type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage()) %>" onClick="setDataSource();" class="e8_btn_submit"/>
								  </wea:item>
				       			  
				       			  <wea:item><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<input class="inputstyle" type="text" size="50" id="dbcharset4ds" name="dbcharset4ds" value="<%=dbcharset4ds%>">
							      </wea:item>
						     </wea:group>
						</wea:layout>
					   </wea:item>
					   
					   <wea:item attributes="{'isTableList':'true','samePair':'SmsServiceSQL','colspan':'full'}" >
						<wea:layout type="2Col">
							<wea:group context='<%=SystemEnv.getHtmlLabelName(23686,user.getLanguage())%>'  attributes="{'groupOperDisplay':'none','groupDisplay':'none'}">
							      <wea:item><%=SystemEnv.getHtmlLabelName(23686,user.getLanguage())%></wea:item>
							      <wea:item>
							      		<textarea style="width:80%" rows="5" id="sql" name="sql" value="<%=sql %>"><%=sql%></textarea>
							      </wea:item>
				       
						     </wea:group>
						</wea:layout>
					   </wea:item>
					   
					   <wea:item attributes="{'isTableList':'true','samePair':'SmsServiceCusGroup'}">
					   <div id="sysListDiv" style="width:100%;display:none">
					   <div class="optiongroup"><div class="optionhead"><div class="optionToolbar"></div></div>
						  <div class="tablecontainer"> 
						  <table class="grouptable">
						  <colgroup>
						  	  <col width='1%'>
							  <col width='20%'>
		        			  <col width='40%'>
		        			  <col width='30%'>
						  </colgroup>
						  <thead>
							  <tr class="">
							  		<th></th>
							   		<th><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></th>
			        				<th><%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%></th>
			        				<th><%=SystemEnv.getHtmlLabelName(82159,user.getLanguage())%></th>
			        		  </tr>
						  </thead>
						  <tbody>
					   <%   if(isSystemClazz&&(!isGenaral&&otherType==2)){
						     Class clazz=null;
				   		 	try{
					   			clazz=Class.forName(constructclass);
					   		 }catch(Throwable e){
					   			constructclassExist=false;
					   		 }  	
							int row=0;
								if(isSystemClazz){//正常读取数据.从配置文件读取
									//加载类反射信息
							   		Map<String,Field> map=new HashMap<String, Field>();
							   		if(clazz!=null){
							   			map= AnnotationUtils.getFieldsMap(clazz);
							   		}
									for(int i=0;i<propertyArr.size();i++){
									    String nameS = (String)propertyArr.get(i);
									    String valueS = (String)valueArr.get(i);
									    String nameDesc="";
									    String example="";
									    if(map.containsKey(nameS)){
									    	Field field=map.get(nameS);
									    	SmsField smsField=AnnotationUtils.getFieldAnnotations(field);
									    	nameDesc = AnnotationUtils.getDesc(smsField);
										    example = AnnotationUtils.getExample(smsField);	
									    }else{
										    example = SystemEnv.getHtmlLabelName(126233,user.getLanguage());	
									    }
									    
									    //展示历史数据
				        				out.println("<tr  class='contenttr'>\n"); 
				            			out.println("<td></td><td><span>"+nameS+(!"".equals(nameDesc)?"&nbsp;&nbsp;("+nameDesc+")":"")+"</span><input class='InputStyle' type='hidden' name='attrP_"+row+"' value='"+nameS+"'></td>\n");
				            			out.println("<td><input class='InputStyle' type='text' name='attrV_"+row+"' value='"+valueS+"'></td>\n");
				            			out.println("<td><span>"+example+"</span>\n");
				        				out.println("</tr>\n"); 
				        				out.println("<tr style='height:1px'><td colspan='4' style='height: 1px'><div class='linesplit' ></div></td></tr>\n"); 
				        				row++;
									}
								}else{//从类反射读取
									if(clazz!=null){
										Field[] fields= AnnotationUtils.getFields(clazz);
										for(Field field:fields){
											SmsField smsField=AnnotationUtils.getFieldAnnotations(field);
											if(AnnotationUtils.isHide(smsField)) continue;
										    String nameS = field.getName();
										    String nameDesc = AnnotationUtils.getDesc(smsField);
										    String valueS = AnnotationUtils.getDefValueDesc(smsField);
										    String example = AnnotationUtils.getExample(smsField);								    
										    boolean must=AnnotationUtils.isMust(smsField);
							        		//展示历史数据
					        				out.println("<tr  class='contenttr'>\n"); 
					            			out.println("<td></td><td><span>"+nameS+(!"".equals(nameDesc)?"&nbsp;&nbsp;("+nameDesc+")":"")+"</span><input class='InputStyle' type='hidden' name='attrP_"+row+"' value='"+nameS+"'></td>\n");
					            			out.println("<td><input class='InputStyle' type='text' name='attrV_"+row+"' value='"+valueS+"'></td>\n");
					            			out.println("<td><span>"+example+"</span>\n");
					        				out.println("</tr>\n"); 
					        				out.println("<tr style='height:1px'><td colspan='4' style='height: 1px'><div class='linesplit' ></div></td></tr>\n"); 
					        				row++;
							        	}
									}
								}
								out.println("<input type='hidden'  name='clazz_rowcount' id='clazz_rowcount' value='"+row+"' >");
					   		}
					   %>
					   </tbody></table></div></div></div>
					   <%	//加载自定义接口信息
							JSONArray root = new JSONArray();
							if(!isGenaral&&otherType==2){
								for(int i=0;i<propertyArr.size();i++){
								    String propertyS = (String)propertyArr.get(i);
								    String valueS = (String)valueArr.get(i);
								     
								    JSONArray node = new JSONArray();
									JSONObject nodeChld = new JSONObject();
									nodeChld.put("name","property");
									nodeChld.put("value",propertyS);
									nodeChld.put("iseditable","true");
									nodeChld.put("type","input");
									node.add(nodeChld);
									 
									nodeChld = new JSONObject();
									nodeChld.put("name","value");
									nodeChld.put("value",valueS);
									nodeChld.put("iseditable","true");
									nodeChld.put("type","input");
									node.add(nodeChld);
									 
									root.add(node);
								}
							}
						%>
						
						<input type="hidden"  name="rowcount" id="rowcount" value="" >
						<div id="cusListDiv" class="listdiv"  style="width:100%;display:none"></div>
						<script>
							var rowindex = 0;
							var items=[
								{width:"15%",colname:"<%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>",itemhtml:"<input class='inputStyle' id='property' name='property' value=''"},
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelName(19113,user.getLanguage())%>",itemhtml:"<input class='inputStyle' id='value' name='value' value=''"}
							];
							var option= {
								 basictitle:"",
								 toolbarshow:true,
								 colItems:items,
								 openindex:true,
								 addrowtitle:true,
								 deleterowstitle:true,
								 copyrowtitle:false,
								 usesimpledata:true,
								 initdatas:eval('(<%=root.toString()%>)'),
								 addrowCallBack:function() {
									// alert("回调函数!!!");
									rowindex++;
									jQuery("#rowcount").val(rowindex);
								 },
								configCheckBox:true,
								checkBoxItem:{"itemhtml":"<input type='checkbox' class='groupselectbox'><input type='hidden'  name='rowid' value='1' >",width:"3%"}
							};
							var group=new WeaverEditTable(option);
							$(".listdiv").append(group.getContainer());
						</script>
					</wea:item>
					
			     </wea:group>
			     
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>'  attributes="{'samePair':'SmsServiceGroup','itemAreaDisplay':'inline-block'}">
				        <wea:item>
						1、<%=SystemEnv.getHtmlLabelName(126228,user.getLanguage())%>；
						<BR>
						2、<%=SystemEnv.getHtmlLabelName(23965,user.getLanguage())%>；
						<BR>
						3、<%=SystemEnv.getHtmlLabelName(23966,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23967,user.getLanguage())%>；
						<BR>
						4、<%=SystemEnv.getHtmlLabelName(23968,user.getLanguage())%>；
						<BR>
						5、<%=SystemEnv.getHtmlLabelName(23969,user.getLanguage())%>；
						<BR>
						6、<%=SystemEnv.getHtmlLabelName(126229,user.getLanguage())%>。
						</wea:item>
			     </wea:group>
			     <%} %>
			</wea:layout>	
		</td>
		</tr>
		</TABLE>
	</td>
</tr>
</table>
</form>
<iframe id="iframeDownload" style="display: none"></iframe>
 
</BODY>
<script language="javascript">

$(document).ready(function() {
       changeSMSType();
       if("<%=isValid%>"=="false"){
       	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23270,user.getLanguage())%>!");
       }
       if("<%=constructclassExist%>"=="false"&&"<%=serverType.equals(RTXConfig.CUR_SMS_SERVER_CUS)%>"=="true"){
       	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("23683,23084",user.getLanguage())%>!");
       }
});


//改变短信接口方式
function changeSMSType(){
	var type=$('#serverType').val();
    hideEle('Modemtd');
    hideGroup('SmsServiceGroup');
	hideGroup('SmsServiceDriver');
    if(type=="<%=RTXConfig.CUR_SMS_SERVER_MODEN%>"){
		showEle('Modemtd');
		showGroup('SmsServiceDriver');
	}else if(type=="<%=RTXConfig.CUR_SMS_SERVER_CUS%>"){
	    showGroup('SmsServiceGroup');
	    changeInterface();
	} 
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function closeRefDialog(){
	if(dialog){
		dialog.close();
		setSelectOption();
	}
}

function setSelectOption(){
	$.post("/sms/AjaxSmsOperation.jsp", 
		{"method":"getDS"},
	   	function(data){
        	if(data != ''){
				var jsonData=eval('('+data+')');
				var selectObj = $('#datasourceid');
				jQuery(selectObj).empty();
				jQuery(selectObj).selectbox("detach");
				jQuery(selectObj).append("<option value=''></option>"); 
				for(var obj in jsonData){
					if(isNaN(obj)) continue;
					var dataSourceObj=jsonData[obj];
					jQuery(selectObj).append("<option value='"+dataSourceObj.id+"'>"+dataSourceObj.name+"</option>"); 
				}
				jQuery(selectObj).selectbox();
			}
        }
    );
}

function setDataSource()
{
	var url = "/integration/integrationTab.jsp?urlType=11&isdialog=1&from=sms";
	var title = "<%=SystemEnv.getHtmlLabelName(23660,user.getLanguage())%>";
	openDialog(url,title);
}

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

function change2DS(){//迁移至数据源
	//判断参数是否满足
	if($('#host').val()==''||$('#port').val()==''||$('#dbname').val()==''||$('#username').val()==''||$('#password').val()==''){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126234,user.getLanguage())%>");
		return;
	} 
	$('#operate').val("change2DS");
	forbiddenPage();
	$('#frmmain').submit();
}

//改变接口方式
function changeInterface(){
	hideEle('SmsServiceDBGroup');
    hideEle('SmsServiceCusGroup');
    hideEle('datasource');
    hideEle('SmsServiceSQL');
    
    $('#Genaral2DSSms').hide();
    $('#SmsCatalogSpan').hide();
    $('#CommonSmsInterfaceSpan').hide();
	var changeValue=$('#interfacetype').val();
	

	//$("#constructclass").removeAttr("disabled");   
	//$("#constructclass").attr("disabled","true");  
	
	$("#constructclass").attr("readonly","readonly");
    $("#constructclass").css("background-color","#EBEBE4");
     
    if(changeValue==1){//通用接口
        $("#constructclass").val("weaver.sms.JdbcSmsService");
        showEle('SmsServiceDBGroup');
        showEle('SmsServiceSQL');
        changeDBType();
        $('#Genaral2DSSms').show();
        $("#constructclassSpan").show();
        $("#constructclassSpan").show();
    }else if(changeValue==2){//自定义
        if(<%=isGenaral%>||<%=otherType==3%>){
        	$("#constructclass").val("");
        }else{
        	$("#constructclass").val("<%=constructclass%>");
        }
        $("#constructclass").removeAttr("readonly");   
        $("#constructclass").css("background-color","#fff");
        showEle('SmsServiceCusGroup');
        $('#CommonSmsInterfaceSpan').show();
        doCommonSmsInterface();
        
    }else if(changeValue==3){//数据源
        $("#constructclass").val("weaver.sms.JdbcSmsServiceNew");
        showEle('datasource');
        showEle('SmsServiceSQL');
        $("#constructclassSpan").show();
    }
}

function doCommonSmsInterface(){
	$('#sysListDiv').hide();
	$('#cusListDiv').hide();
	if($('#CommonSmsInterface').attr("checked")==true){
		$('#sysListDiv').show();
		$("#constructclassSpan").hide();
        $('#SmsCatalogSpan').show();
	}else{
		$('#cusListDiv').show();
		$("#constructclassSpan").show();
        $('#SmsCatalogSpan').hide();
	}
}

//改变数据库方式
function changeDBType(){
	var type=$('#type').val();
	hideEle('mysqltd');
	if(type=="mysql"){
		showEle('mysqltd');
	}
}

function onSubmit(){
    var interfacetype = $("#interfacetype").val();
    if(interfacetype==2){
        var constructclass = $("#constructclass").val();
        if(constructclass=="weaver.sms.JdbcSmsService"){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83349,user.getLanguage())%>");
           $("#constructclass").val("")
           return;
       }else if(constructclass=="weaver.sms.JdbcSmsServiceNew"){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126235,user.getLanguage())%>");
           $("#constructclass").val("")
           return;
       }
    }
    forbiddenPage();
    $('#frmmain').submit();
}
 
function openSmsCatalog(){

     __browserNamespace__.showModalDialogForBrowser(event,'/systeminfo/BrowserMain.jsp?url=/sms/SmsCatalog.jsp?id='+$('#smsClazzId').val(),'#','constructclass',true,1,'0',{dialogWidth:700,name:'constructclass',zDialog:true,_callback:showCalaogCallBk});
	
}

function showCalaogCallBk(event,datas,name,ismand){
	if (datas != null) {
        if (datas.id> 0){
          if($('#smsClazzName').val()!=datas.name){
	          $('#SmsCatalogShowSpan').html(datas.name);
	          $('#smsClazzName').val(datas.name);
	          $('#smsClazzId').val(datas.id);
		      getSmsClazz();
	      }
        }else{//恢复之前配置
        	 $('#SmsCatalogShowSpan').html("");
          	 $('#smsClazzName').val("");
          	 $('#smsClazzId').val("");
          	 getSmsClazzHead();
        }
    }
}

function getSmsClazz(){
	forbiddenPage();
	$.post("/sms/AjaxSmsOperation.jsp", 
		{"method":"getClass","smsClazzName":$('#smsClazzName').val()},
	   	function(data){
        	if(data != ''){
        		releasePage();
        		$('#sysListDiv').html(data);
			}
        }
    );
}

function getSmsClazzHead(){
	forbiddenPage();
	$.post("/sms/AjaxSmsOperation.jsp", 
		{"method":"getClass","smsClazzName":$('#smsClazzName').val(),"justhead":"true"},
	   	function(data){
        	if(data != ''){
        		releasePage();
        		$('#sysListDiv').html(data);
			}
        }
    );
}

function forbiddenPage(){
	$("<div class=\"datagrid-mask\" style=\"position:fixed;z-index:2;opacity:0.4;filter:alpha(opacity=40);BACKGROUND-COLOR:#fff;\"></div>").css({display:"block",width:"100%",height:"100%",top:0,left:0}).appendTo("body");   
    $("<div class=\"datagrid-mask-msg\" style=\"background:#fff;position:fixed;z-index:3;padding: 10px;padding-top: 6px;padding-bottom: 6px;border: 1px solid;\"></div>").html("<%=SystemEnv.getHtmlLabelName(25666,user.getLanguage())%>").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});  
} 

function releasePage(){  
    $(".datagrid-mask,.datagrid-mask-msg").hide();  
}

function downloadDrive(id){
	document.getElementById("iframeDownload").src = "/sms/drive/"+id+"/iSMSClient2000.class";
}

function check(){
	forbiddenPage();
	$.post("/sms/AjaxSmsOperation.jsp", 
		{"method":"checkModem","smsServer":$('#smsserver').val()},
	   	function(data){
        	if(data=="true"){
        		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("16953,16746",user.getLanguage())%>");
        		releasePage();
			}else{
			window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(127658,user.getLanguage())%>');
				releasePage();
			}
        }
    );
}
</script>

</HTML>
