
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<STYLE TYPE="text/css">
table.viewform td.line
{
	height:1px!important;
}
table.liststyle tr.line td
{
	height:1px!important;
}

</STYLE>
<script type="text/javascript" src="../workflow/action/checkActionName_busi.js"></script>
<script type="text/javascript" src="/integration/banBackSpace.js"></script><!--QC274140  [80][90]流程流转集成-自定义接口弹出窗口按Backspace会重复插入一条数据-->
</head>
<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23662,user.getLanguage());
String needfav ="1";
String needhelp ="";

String isdialog = Util.null2String(request.getParameter("isdialog"));
String id = Util.null2String(request.getParameter("actionid"));
String pointid = Util.null2String(request.getParameter("pointid"));
String actionshowname = "";
String sql = "";
if(Util.getIntValue(id,0)>0){
	sql = "select * from actionsetting where id="+id;
} else {
    sql = "select * from actionsetting where actionname='"+pointid+"'";
}
RecordSet.executeSql(sql);
if(RecordSet.next()){
	id = RecordSet.getString("id");//qc:296108 299019 299020 299021 298983 299018
	pointid = RecordSet.getString("actionname");
	actionshowname = RecordSet.getString("actionshowname");
}
//System.out.println("actionshowname : "+actionshowname);
if("".equals(actionshowname))
	actionshowname = pointid;
String workflowid = Util.null2String(request.getParameter("workflowid"));
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
//是否节点后附加操作
int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
//出口id
int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);


ArrayList pointArrayList = ActionXML.getPointArrayList();
Hashtable dataHST = ActionXML.getDataHST();

Hashtable datasetHST = ActionXML.getDatasetHST();

Hashtable setvalues = (Hashtable)datasetHST.get(pointid);
if(null!=setvalues&&setvalues.size()>0)
{
    Set set = setvalues.keySet();
    if(null!=set&&set.size()>0)
    {
        for(Iterator it = set.iterator();it.hasNext();)
        {
        	String fieldname = (String)it.next();
            String fieldvalue = (String)setvalues.get(fieldname);
            if("actionname".equalsIgnoreCase(fieldname)&&"".equals(actionshowname))
            {
            	actionshowname = fieldvalue;
            }
		}
    }
}

String actionid = "";
String classname = "";
if(!"".equals(pointid))
{
	actionid = pointid;
	classname = (String)dataHST.get(pointid);
}
String pointids = ",";
for(int i=0;i<pointArrayList.size();i++){
    String temppointid = (String)pointArrayList.get(i);
    if(pointid.equals(temppointid)) continue;
    pointids += temppointid+",";
}
//out.println("pointids : "+pointids);
boolean isused = BaseAction.checkFromActionUsed(""+actionid,"3");

%>

<BODY>
<%if("1".equals(isdialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!isused&&!"".equals(pointid))
{
	RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/integration/formactionlist.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			<%
			if(!isused&&!"".equals(pointid))
			{
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
			<%
			}
			%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="XMLFileOperation.jsp">
<input type="hidden" id="operation" name="operation" value="action">
<input type="hidden" id="method" name="method" value="add">
<input type="hidden" id="id" name="id" value="<%=id %>">
<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid %>">
<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>">
<input type="hidden" id="oldactionid" name="oldactionid" value="<%=actionid %>">
<input type="hidden" id="ispreoperator" name="ispreoperator" value="<%=ispreoperator %>">
<input type="hidden" id="nodelinkid" name="nodelinkid" value="<%=nodelinkid %>">
<%if("1".equals(isdialog)){ %>
<input type="hidden" name="isdialog" value="<%=isdialog%>">
<%} %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
	  <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></wea:item>
	  <wea:item>
	  	<wea:required id="actionnamespan" required="true" value='<%=actionshowname %>'>
	  	<!--QC274140  [80][90]流程流转集成-自定义接口弹出窗口按Backspace会重复插入一条数据 autofocus="autofocus"-->
		<!--QC282800  [80][90]流程流转集成-注册自定义接口新建/编辑页面【接口动作名称】前后空格问题 增加onblur事件-->
	  	<input class="inputstyle" type=text style='width:280px!important;' id="actionname" autofocus="autofocus" name="actionname" onblur="trimActionName(this.value)" onChange="checkinput('actionname','actionnamespan')" value="<%=actionshowname %>">
	  	</wea:required>
	  </wea:item>
	  <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
	 
	  <% 
	  if(!actionid.equals("")){
	  %>
	   <wea:item>
	   <span style="font-size:10pt"><%=actionid%></span>
	    <input class="inputstyle" type='hidden'  id="actionid" name="actionid" value="<%=actionid %>"  >
	  </wea:item>
	  <% 
	  }else{
	  %>
	   <wea:item>
	  	<wea:required id="actionidspan" required="true" value='<%=actionid %>'>
	  	<input class="inputstyle" type=text style='width:280px!important;' id="actionid" name="actionid" onChange="checkinput('actionid','actionidspan')" value="<%=actionid %>" onblur="isExist(this.value)"  >
	  	</wea:required>
	  </wea:item>
	  <% 
	  }

	  %>
	  
	  <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(23681,user.getLanguage())%></wea:item>
	   <wea:item>
	   	<wea:required id="classnamespan" required="true" value='<%=classname %>'>
	  	<input class="inputstyle" type=text style='width:380px!important;' id="classname" name="classname" value="<%=classname %>" size=80 onChange="checkinput('classname','classnamespan')">
	  	</wea:required>
	  </wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
	  <wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow()" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow()" class="delbtn"/>
		  </div>
	  </wea:item>
	  <wea:item attributes="{'colspan':'2','isTableList':'true'}">
	  	<div id="outtersetting"></div>
	  </wea:item>
	</wea:group>
</wea:layout>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
	  <wea:item attributes="{'colspan':'2'}">
		1.<%=SystemEnv.getHtmlLabelName(23951,user.getLanguage())%>;
		<BR>
		2.<%=SystemEnv.getHtmlLabelName(23952,user.getLanguage())%>.
	</wea:item>
  </wea:group>
</wea:layout>
 </FORM>
 <%if("1".equals(isdialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
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
<%
String tempajaxdata = "";
StringBuffer ajaxdata = new StringBuffer();
if(Util.getIntValue(id,0)>0){
	sql = "select * from actionsettingdetail where actionid="+id+" order by id";
}else {
	sql = "select * from actionsettingdetail t1 left join actionsetting t2 on t1.actionid=t2.id where t2.actionname='"+pointid+"' order by t1.id";
}	
RecordSet.executeSql(sql);
if(RecordSet.next()) {
		RecordSet.beforFirst();
		while(RecordSet.next())
		{
			String fieldname = RecordSet.getString("attrname");
			String fieldvalue = RecordSet.getString("attrvalue");
			String isdatasource = RecordSet.getString("isdatasource");
			
	        ajaxdata.append("[");
	        ajaxdata.append("{name:'paramid',value:'',iseditable:true,type:'input'},");
	        ajaxdata.append("{name:'paramids',value:'',iseditable:true,type:'input'},");
	        ajaxdata.append("{name:'fieldname',value:'"+StringEscapeUtils.escapeJavaScript(fieldname)+"',iseditable:true,type:'input'},");
	        ajaxdata.append("{name:'fieldvalue',value:'"+StringEscapeUtils.escapeJavaScript(fieldvalue)+"',iseditable:true,type:'input'},");
	        ajaxdata.append("{name:'isdatasource',value:'"+isdatasource+"',iseditable:true,type:'select'}");
	        ajaxdata.append("],");
		}
	}
tempajaxdata = ajaxdata.toString();

if(!"".equals(tempajaxdata))
{
	tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
}
tempajaxdata = "["+tempajaxdata+"]";

//System.out.println("tempajaxdata=="+StringEscapeUtils.escapeJavaScript(tempajaxdata).replaceAll("\\\\","\\\\\\\\\\\\\\\\"));
	//System.out.println("tempajaxdata : "+tempajaxdata);
%>
var items=[
    {width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(23481,user.getLanguage())%>",itemhtml:"<input class='inputstyle' type=text size=15 id='fieldname' name='fieldname' value=''>"},
    {width:"40%",colname:"<%=SystemEnv.getHtmlLabelName(17637,user.getLanguage())%>",itemhtml:"<input class='inputstyle' type=text size=15 id='fieldvalue' name='fieldvalue' value=''>"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("83023,18076",user.getLanguage())%>",itemhtml:"<select class=InputStyle id='isdatasource' name='isdatasource' style='width:120px!important;'><option value='0'><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option><option value='1'><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option></select>"}
    ]

var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:false,
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   addrowCallBack:function() {
   },
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid' value=1><INPUT type='hidden' name='paramids' value='1'>","width":"6%"},
   initdatas:eval("<%=StringEscapeUtils.escapeJavaScript(tempajaxdata)%>")
};

var group=null;
jQuery(document).ready(function(){
	//alert(jQuery("#encrypttype").val());
	group=new WeaverEditTable(option);
    jQuery("#outtersetting").append(group.getContainer());
    var params=group.getTableSeriaData();
    reshowCheckBox();
    jQuery(".optionhead").hide();
    jQuery(".tablecontainer").css("padding-left","0px");
});
function onSubmit(){

if(! checkActionName("action",$("#actionname").val(),$("#id").val())){
           	top.Dialog.alert("名称已存在,请重新填写!");
return;
}
	frmMain.actionid.value = jQuery.trim(frmMain.actionid.value);
	frmMain.classname.value = jQuery.trim(frmMain.classname.value);
	frmMain.actionname.value = jQuery.trim(frmMain.actionname.value);
    if(check_form(frmMain,"actionid,classname,actionname")) frmMain.submit();
}
function deleteData()
{
   	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>?", function (){
		document.frmMain.method.value="deletesingle1";
       	document.frmMain.submit();
	}, function () {}, 320, 90);
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

function isExist(newvalue){
	newvalue = jQuery.trim(newvalue);
	
    var pointids = "<%=pointids%>";
    if(pointids.indexOf(","+newvalue+",")>-1){
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(23991,user.getLanguage())%>");
        document.getElementById("actionid").value = "";
        checkinput('actionid','actionidspan');
    }
    if(isSpecialChar(newvalue)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128458,user.getLanguage())%>");
        document.getElementById("actionid").value = "";
        document.getElementById("actionidspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isChineseChar(newvalue)){
		//标识包含中文，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128459,user.getLanguage())%>");
        document.getElementById("actionid").value = "";
        document.getElementById("actionidspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isFullwidthChar(newvalue)){
		//标识包含全角符号，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128460,user.getLanguage())%>");
        document.getElementById("actionid").value = "";
        document.getElementById("actionidspan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}


}

jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function onClose()
{
	parent.parent.getDialog(parent).close();
}
function doBack()
{
	document.location.href="/integration/formactionlist.jsp";
}
function addRow()
{
	if(null!=group)
	{
		group.addRow(null);
	}
}
function removeRow()
{
	if(null!=group)
	{
		group.deleteRows();
	}
}

//QC 282800  [80][90]流程流转集成-注册自定义接口新建/编辑页面【接口动作名称】前后空格问题 Start
function trimActionName(value){
    value =  $.trim(value);
    document.getElementById("actionname").value = value;
    if(isSpecialChar(value)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		document.getElementById("actionname").value = "";
		document.getElementById("actionnamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		
		return false;
	}
}
//QC 282800  [80][90]流程流转集成-注册自定义接口新建/编辑页面【接口动作名称】前后空格问题 End
</script>

</HTML>
