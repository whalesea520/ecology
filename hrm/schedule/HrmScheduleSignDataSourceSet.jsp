
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.schedule.HrmScheduleSignImport,java.math.*"%>
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="ScheduleXML" class="weaver.servicefiles.ScheduleXML" scope="page" />
	<%
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
	
})

function checkData(){
	var datasourceids = document.getElementsByName("datasourceid"); 
	var tablenames = document.getElementsByName("tablename"); 
	var workcodes = document.getElementsByName("workcode"); 
	var lastnames = document.getElementsByName("lastname"); 
	var signdates = document.getElementsByName("signdate"); 
	var signtimes = document.getElementsByName("signtime"); 
	var error = false;
	var isWNError = false;
	var isFieldError = false;
	for(var i=0;datasourceids!=null&&i<datasourceids.length;i++){
		var datasourceid = datasourceids[i].value; 
		if(datasourceid=="")continue;
		var tablename = tablenames[i].value; 
		var workcode = workcodes[i].value; 
		var lastname = lastnames[i].value;  
		var signdate = signdates[i].value;  
		var signtime = signtimes[i].value;
		if(tablename==""){
			error = true;
			break;
		}else if(workcode==""&&lastname==""){
			error = true;
			isWNError = true;
			break;
		}else if(signdate==""){
			error = true;
			break;
		//}else if(signtime==""){
			//error = true;
			//break;
		}else if(signdate==signtime){
			isFieldError = true;
			break;
		}
	}
	
	if(isWNError){
		window.Dialog.alert('<%=SystemEnv.getHtmlLabelName(33616,user.getLanguage())%>');
		return false;
	}else if(error){
		window.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>');
		return false;
	}else if(isFieldError){
		window.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83470,user.getLanguage())%>');
		return false;
	}
	return true;
}

function jsSave(){
	if(!checkData())return;
	jQuery("#cmd").val("save");
	jQuery("#weaver").submit();
}

function jsSyn(){
	var fromdate = jQuery("#fromdate").val();
	var enddate = jQuery("#enddate").val();
	if(fromdate==""||enddate==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,33542",user.getLanguage())%>");
		return;
	}
	var _check = ajaxSubmit(encodeURI(encodeURI("/js/hrm/getdata.jsp?cmd=cehckScheduleSignDataSourceSet&fromdate="+fromdate+"&enddate="+enddate)));
	if(_check != "true"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
		return;
	}
	
	jQuery("#cmd").val("syn");
	showPrompt("<%=SystemEnv.getHtmlLabelName(32327,user.getLanguage())%>");
	$("#btnSyn").attr("disabled","disabled");
	jQuery("#weaver").submit();
}  
function showPrompt(content){
     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     //message_table_Div.style.posTop=pTop;
     //message_table_Div.style.posLeft=pLeft;
     message_table_Div.style.top = pTop;
     message_table_Div.style.left = pLeft;
     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
</script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33459,user.getLanguage());
String needfav ="1";
String needhelp ="";

String cmd = Util.null2String(request.getParameter("cmd"));
String sql = "";
String message = "";

String fromdate = Util.null2String(request.getParameter("fromdate")); 
String enddate = Util.null2String(request.getParameter("enddate"));
if(cmd.equals("syn")){
	//手工同步
	HrmScheduleSignImport hrmScheduleSignImport = new HrmScheduleSignImport();
	hrmScheduleSignImport.importData(fromdate, enddate,true);
	message = SystemEnv.getHtmlLabelName(30109,user.getLanguage());
}else if(cmd.equals("save")){
	//保存是否启用
	String isVaild = Util.null2String(request.getParameter("isVaild"));
	ArrayList pointArrayList = ScheduleXML.getPointArrayList();
	ArrayList hstarr = new ArrayList();
	Hashtable dataHST = ScheduleXML.getDataHST();
	int idx = pointArrayList.indexOf("HrmScheduleSignImport");
	for(Object pointid : pointArrayList){
		hstarr.add(dataHST.get(pointid));
	}

	if(isVaild.equals("1")){
		//启用
		if(idx==-1){
			Hashtable datadetailHST = new Hashtable();
			datadetailHST.put("construct","weaver.hrm.schedule.HrmScheduleSignImportJob");
			datadetailHST.put("cronExpr","0 0 1 * * ?");
			ScheduleXML.writeToScheduleXMLAdd("HrmScheduleSignImport",datadetailHST);
			pointArrayList.add("HrmScheduleSignImport");
		}
	}else{
		//停用
		if(idx!=-1){
			ArrayList parapointids = new ArrayList();
			parapointids.add("HrmScheduleSignImport");
			ScheduleXML.deleteSchedule(parapointids);
			pointArrayList.remove("HrmScheduleSignImport");
		}
	}
	
	String[] datasourceids = request.getParameterValues("datasourceid"); 
	String[] tablenames = request.getParameterValues("tablename"); 
	String[] workcodes = request.getParameterValues("workcode");  
	String[] lastnames = request.getParameterValues("lastname"); 
	String[] signdates = request.getParameterValues("signdate");  
	String[] signtimes = request.getParameterValues("signtime");  
	String[] clientaddresss = request.getParameterValues("clientaddress"); 
	
	rs.executeSql("delete from HrmScheduleSignSet");
	for(int i=0;datasourceids!=null&&i<datasourceids.length;i++){
		String datasourceid = Util.null2String(datasourceids[i]); 
		if(datasourceid.length()==0)continue;
		String tablename = Util.null2String(tablenames[i]);  
		String workcode = Util.null2String(workcodes[i]);  
		String lastname = Util.null2String(lastnames[i]); 
		String usertype = "1";//Util.null2String(usertypes[i]);  
		String signtype = null;  
		String signdate = Util.null2String(signdates[i]);  
		String signtime = Util.null2String(signtimes[i]);  
		String clientaddress = Util.null2String(clientaddresss[i]);
		sql = " insert into HrmScheduleSignSet " 
				+ " (datasourceid, tablename, workcode, lastname, usertype, signtype, signdate, signtime, clientaddress) " 
				+ " values('"+datasourceid+"','"+tablename+"','"+workcode+"','"+lastname+"','"+usertype+"','"+signtype+"','"+signdate+"','"+signtime+"','"+clientaddress+"')";
		rs.executeSql(sql);
	}
	message = SystemEnv.getHtmlLabelName(18758,user.getLanguage());
}

boolean oldisinvald = false;
if(ScheduleXML.getPointArrayList().indexOf("HrmScheduleSignImport")>-1) oldisinvald = true;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:jsSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(33543,user.getLanguage())+",javascript:jsSyn();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		<br></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="jsSave();" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="jsSyn();" value="<%=SystemEnv.getHtmlLabelName(33543, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="weaver" name="weaver" action="HrmScheduleSignDataSourceSet.jsp" method="post">
<input id="cmd" name="cmd" type="hidden" value="">
<wea:layout type="2col">
	<wea:group context="<%=SystemEnv.getHtmlLabelName(33537,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></wea:item>
		<wea:item><input name="isVaild" <%=oldisinvald?"checked":"" %> tzCheckbox="true" type="checkbox" value="1">
		<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(125962,user.getLanguage())%>" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33542,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON class=Calendar style="vertical-align: middle;" type="button" id=selectFromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON>
      <SPAN id=fromdatespan ><%=fromdate%></SPAN>－
      <BUTTON class=Calendar style="vertical-align: middle" type="button" id=selectEnddate onclick="getDate(enddatespan,enddate)"></BUTTON>
      <SPAN id=enddatespan ><%=enddate%></SPAN>
      <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>">
      <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">
     	&nbsp;&nbsp;
     	<input style="vertical-align: middle;" id="btnSyn" type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(33543,user.getLanguage())%>" onclick="jsSyn()">
     	<img src="/wechat/images/remind_wev8.png" align="absMiddle" title="<%=SystemEnv.getHtmlLabelName(33544,user.getLanguage())%>" />
		</wea:item>
		<wea:item>
			<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;padding-left:-100px;text-align: center;' valign='top'>
			</div>
		</wea:item>
	</wea:group>
</wea:layout>
<div id="datasourceset" class="groupmain" style="width:100%"></div>
<script>
<%
ArrayList pointArrayList = DataSourceXML.getPointArrayList();
String options = "";
for(int i=0;pointArrayList!=null&&i<pointArrayList.size();i++){
	options += "<option value="+pointArrayList.get(i)+">"+pointArrayList.get(i)+"</option>";
}
%>
var items=[
{width:"10%",colname:"<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%>",itemhtml:"<select style='width:80px' name='datasourceid'><%=options%></select>"},
{width:"18%",colname:"<%=SystemEnv.getHtmlLabelName(23574,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='tablename'><span class=mustinput></span>"},
{width:"14%",colname:"<%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='workcode'>"},
{width:"14%",colname:"<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='lastname'>"},
{width:"14%",colname:"<%=SystemEnv.getHtmlLabelName(33563,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='signdate'><span class=mustinput></span>"},
{width:"14%",colname:"<%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='signtime'>"},
{width:"16%",colname:"<%=SystemEnv.getHtmlLabelName(20045,user.getLanguage())%>",itemhtml:"<input type=text style='width:90%' name='clientaddress'>"}];
<%
	sql = "select datasourceid, tablename, workcode, lastname, signdate, signtime, clientaddress " 
			+ "from HrmScheduleSignSet " 
			+ "order by datasourceid desc ";
	rs.executeSql(sql);
	StringBuffer ajaxData = new StringBuffer();
	ajaxData.append("[");
	boolean hasData=false;
  while(rs.next()){
  	String datasourceid = Util.null2String(rs.getString("datasourceid")); 
  	String tablename = Util.null2String(rs.getString("tablename"));  
  	String workcode = Util.null2String(rs.getString("workcode"));  
  	String lastname = Util.null2String(rs.getString("lastname"));    
  	String signdate = Util.null2String(rs.getString("signdate"));  
  	String signtime = Util.null2String(rs.getString("signtime"));  
  	String clientaddress = Util.null2String(rs.getString("clientaddress"));  

  	if(!ajaxData.toString().equals("["))ajaxData.append(",");
		ajaxData.append("[{name:\"datasourceid\",value:\""+datasourceid+"\",iseditable:true,type:\"select\"},");
		ajaxData.append("{name:\"tablename\",value:\""+tablename+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"workcode\",value:\""+workcode+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"lastname\",value:\""+lastname+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"signdate\",value:\""+signdate+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"signtime\",value:\""+signtime+"\",iseditable:true,type:\"input\"},");
		ajaxData.append("{name:\"clientaddress\",value:\""+clientaddress+"\",iseditable:true,type:\"input\"}]");
  }
  ajaxData.append("]");
%>
var ajaxdata=<%=ajaxData.toString()%>;
var option= {
              basictitle:"<%=SystemEnv.getHtmlLabelName(33538,user.getLanguage())%>",
              toolbarshow:true,
              openindex:false,
              colItems:items,
              usesimpledata: true,
              initdatas: ajaxdata,
              addrowCallBack:function() {
								rownum=this.count;
              },
              copyrowsCallBack:function() {
								rownum=this.count;
              },
             	configCheckBox:true,
             	checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
            };
           var group=new WeaverEditTable(option);
           $("#datasourceset").append(group.getContainer());
           
var msg = '<%=message%>';
if(msg!="")window.Dialog.alert(msg);   

</script>
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<wea:group context="<%=SystemEnv.getHtmlLabelName(33587,user.getLanguage())%>">
	<wea:item><%=SystemEnv.getHtmlLabelName(32203,user.getLanguage())%></wea:item>
	<wea:item>
		<input name="interfaceName" type="text" value="">
	</wea:item>
</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelNames("33538,85",user.getLanguage())%>' attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'full'}">
			1、<%=SystemEnv.getHtmlLabelName(23963,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124881,user.getLanguage())%><br>
			2、<%=SystemEnv.getHtmlLabelName(23574,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124882,user.getLanguage())%><br>
			3、<%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124883,user.getLanguage())%><br>
			4、<%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124884,user.getLanguage())%><br>
			5、<%=SystemEnv.getHtmlLabelName(33563,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124885,user.getLanguage())%> <br>
			6、<%=SystemEnv.getHtmlLabelName(20035,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124886,user.getLanguage())%> <br>
			7、<%=SystemEnv.getHtmlLabelName(20045,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(124887,user.getLanguage())%><br>
			8、<%=SystemEnv.getHtmlLabelName(130152,user.getLanguage())%>
		</wea:item>
	</wea:group>
<wea:group context='<%=SystemEnv.getHtmlLabelNames("33587,85",user.getLanguage())%>' attributes="{'groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item attributes="{'colspan':'full'}">
			<%=SystemEnv.getHtmlLabelName(124888,user.getLanguage())%>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>