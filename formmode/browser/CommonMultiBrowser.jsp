<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ page import="weaver.formmode.excel.ModeCacheManager"%>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@page import="weaver.formmode.data.FieldInfo"%>
<jsp:useBean id="FormModeBrowserSqlwhere" class="weaver.formmode.browser.FormModeBrowserSqlwhere" scope="page"/>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//============================================重要参数====================================
String istree = Util.null2String(request.getParameter("istree"));//是否树的组合查询
String treeid = Util.null2String(request.getParameter("treeid"));
String treenodeid = Util.null2String(request.getParameter("treenodeid"));

String beanids = Util.null2String(request.getParameter("beanids"));

String browsertype = Util.null2String(request.getParameter("browsertype"));
String customid=Util.null2String(request.getParameter("customid"));

//先加载下缓存
ModeCacheManager.getInstance().loadCacheNow("", "", customid);

String browserhref = "";
if(!StringHelper.isEmpty(browsertype)){
	Browser browser=ModeCacheManager.getInstance().getBrowserSetMap(browsertype);
	browserhref = Util.null2String(browser.getHref());
}
//============================================一般参数====================================
String nodetype=Util.null2String(request.getParameter("nodetype"));
int during=Util.getIntValue(request.getParameter("during"),0);
int isdeleted=Util.getIntValue(request.getParameter("isdeleted"));
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
//链接地址中sqlwhere
String sqlwhereparam=Util.null2String(request.getParameter("sqlwhere"));

String tempquerystring = Util.null2String(request.getQueryString());
String[] tempquerystrings = tempquerystring.split("&");
for(int i=0;i<tempquerystrings.length;i++){
	String tmpqs = tempquerystrings[i];
	if(StringHelper.isEmpty(tmpqs)){
		continue;
	}
}

//是否为预览
boolean isview="1".equals(Util.null2String(request.getParameter("isview")));

//============================================browser框基础数据====================================
if("".equals(customid)){
	out.println(SystemEnv.getHtmlLabelName(81939,user.getLanguage()));//browser框id不能为空！
	return;
}

String userid = ""+user.getUID();
boolean issimple=true;
String isbill="1";
String formID="0";
String workflowname="";
String customname=SystemEnv.getHtmlLabelName(21003,user.getLanguage());//自定义多选
String titlename ="";

rs.execute("select a.formid,a.customname from mode_custombrowser a  where a.id="+customid);
if(rs.next()){
    formID=Util.null2String(rs.getString("formid"));
    customname=Util.null2String(rs.getString("customname"));
    titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+":"+customname;//搜索
}

//加上自定以字段
List<String> showfieldLabelList=new ArrayList<String>();

String sql = "select workflow_billfield.id as id,workflow_billfield.fieldname as name,workflow_billfield.fieldlabel as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.fieldhtmltype as httype, workflow_billfield.type as type,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle" +
          " from workflow_billfield,mode_custombrowserdspfield,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
          " and mode_custombrowserdspfield.isshow='1' and workflow_billfield.billid="+formID+"  and   workflow_billfield.id=mode_custombrowserdspfield.fieldid" +
          " union select mode_custombrowserdspfield.fieldid as id,'1' as name,2 as label,'3' as dbtype, '4' as httype,5 as type ,mode_custombrowserdspfield.showorder,mode_custombrowserdspfield.istitle" +
          " from mode_custombrowserdspfield ,Mode_CustomBrowser where mode_custombrowserdspfield.customid=Mode_CustomBrowser.id and Mode_CustomBrowser.id="+customid+
          " and mode_custombrowserdspfield.isshow='1'  and mode_custombrowserdspfield.fieldid<0" +
          " order by istitle desc,showorder asc,id asc";
RecordSet.executeSql(sql);
while (RecordSet.next()){
	String id=Util.null2String(RecordSet.getString("id"));
	String label = RecordSet.getString("label");
	label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
	if(id.equals("-1")){
	    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
	}else if(id.equals("-2")){
	    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());//创建人
	}
	showfieldLabelList.add(label);
}
String initselectfield = "";
List iframeList = new ArrayList();
String multiselectid="";
ArrayList<String> ldselectfieldid=new ArrayList<String>();
String sqlcondition = Util.null2String(request.getParameter("sqlcondition"));

List<String> checkconlist = new ArrayList<String>();
Hashtable conht=new Hashtable();
if(!sqlcondition.equals("")){
	String[] sqlconditions = sqlcondition.split(" and ");
	for(String condition:sqlconditions){
		String tmpcolname = "",htmltype="",type="",tmpopt="",tmpvalue="",tmpname="",tmpopt1="",tmpvalue1="";//,multiselectValue="";
		int dindex = condition.indexOf("=");
		if(dindex==-1){
			continue;
		}
		String key = condition.substring(0,dindex);
		String value = condition.substring(dindex+1);
		String tmpid = key+"|"+value;
		tmpcolname = tmpid.split("\\|",-1)[0];
		htmltype = tmpid.split("\\|",-1)[2];
		type = tmpid.split("\\|",-1)[3];
		String _value = tmpid.split("\\|",-1)[4];
		tmpvalue = _value;
		tmpname = _value;
		tmpvalue1 = _value;
		//multiselectValue = _value;
		tmpid = tmpid.split("\\|",-1)[1];
		if("1".equals(htmltype)&& type.equals("1")){
			tmpopt = "3";
		}else if("2".equals(htmltype)){
			tmpopt = "3";
		}else if(htmltype.equals("1")
			&&(type.equals("2")||type.equals("3")||type.equals("4")||type.equals("5"))){
			tmpopt="2";
   			tmpopt1="4";
   			if(_value.split("-",-1).length==2){
   				tmpvalue = _value.split("-",-1)[0];
   				tmpvalue1 = _value.split("-",-1)[1];
   			}else{
   				tmpvalue1 = "";
   			}
		}else if(htmltype.equals("3")){
			tmpopt = "1";
			if(type.equals("24")){
				tmpopt1="3";
			}else if(type.equals("2") || type.equals("19")){
				tmpopt="2";
   				tmpopt1="4";
			}
		}else if(htmltype.equals("4")){
		
		}else if(htmltype.equals("5")){
			tmpopt = "1";
		}
		if("".equals(tmpvalue)&&"".equals(tmpvalue1))continue;
		conht.put("con_"+tmpid,"1");
		conht.put("con_"+tmpid+"_opt",tmpopt);
		conht.put("con_"+tmpid+"_opt1",tmpopt1);
		conht.put("con_"+tmpid+"_value",tmpvalue);
		conht.put("con_"+tmpid+"_value1",tmpvalue1);
		conht.put("con_"+tmpid+"_name",tmpname);
		//conht.put("multiselectValue_con"+tmpid+"_value", multiselectValue);
	}
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.widget.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.core.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.mouse.min_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery.ui.sortable.min_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js?v=1"></script>
<script type="text/javascript" src="/formmode/js/CommonMultiBrowser_wev8.js?v=1"></script>
<script language=javascript src="/formmode/js/modebrow_wev8.js?v=1"></script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<LINK href="/js/jquery/plugins/multiselect/jquery.multiselect_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/jquery/plugins/multiselect/style_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery-ui_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
<script language="javascript" src="/js/jquery/plugins/multiselect/jquery.multiselect.min_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<style>
.ui-multiselect-menu{
	z-index:9999999;
}
.ui-multiselect-displayvalue{
	background-image:none;
}
.ui-widget-content label{
	background-color:rgb(255, 255, 255);
	font-weight:normal;
}

.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default{
	background-image:none;
	background-color: rgb(255,255,255);
}

.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-header .ui-state-hover, .ui-state-focus, .ui-widget-content .ui-state-focus, .ui-widget-header .ui-state-focus{
	background-image:none;
	background-color: rgb(255,255,255);
	font-weight:normal;
}

.ui-widget-header {
	background-image:none;
	font-weight:normal;
}
</style>
<script type="text/javascript">
<%if(!istree.equals("1")){%>
	try{
		parent.setTabObjName("<%=customname%>");
	}catch(e){
		if(window.console)console.log(e);
	}
<%}%>	
<%if(istree.equals("1")){%>
	var dialog;
	var parentWin;
	try{
		parentWin = window.parent.parent.parent.getParentWindow(parent);
		dialog = window.parent.parent.parent.getDialog(parent);
		if(!dialog){
			parentWin = parent.parentWin;
			dialog = parent.dialog;
		}
	}catch(e){
		
	}
<%}else if(isview){%>
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.getParentWindow(window);
		dialog = parent.getDialog(window);
	}catch(e){}
<%}else{%>
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
<%}%>
</script>
<script>
var srchead=new Array();
<%
for(int i=0;i<showfieldLabelList.size();i++){
	%>
	srchead[<%=i%>]="<%=showfieldLabelList.get(i)%>";
	<%
}
%>
</script>
</head>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnsearch_onclick(),_self}" ;//搜索
RCMenuHeight += RCMenuHeightStep ;
if(!isview){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;//确定
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_top} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;//清除
RCMenuHeight += RCMenuHeightStep ;
%>
<div class="zDialog_div_content">
<form id="frmmain" name="frmmain" method="post" action="" onsubmit="return false;">
<input name="src" type=hidden value="multi">
<input name=customid type=hidden value="<%=customid%>">
<input name=browsertype type=hidden value="<%=browsertype%>">
<input name="browserhref" id="browserhref" type=hidden value="<%=browserhref%>">
<input type=hidden name=formid id="formid" value="<%=formID%>">
<input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhereparam)%>">
<input type="hidden" name="isCustomPageSize" id="isCustomPageSize" value="">
<%if(istree.equals("1")){%>
	<input type="hidden" name="istree" id="istree" value="<%=istree %>">
	<input type="hidden" name="treeid" id="treeid" value="<%=treeid %>">
	<input type="hidden" name="treenodeid" id="treenodeid" value="<%=treenodeid %>">
<%}%>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="btnsearch1" class="e8_btn_top" onclick="javascript:btnsearch_onclick();" ><!-- 搜索 -->
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea"><!-- 新版自定义多选框微调增加div start -->
<wea:layout type="4col">
	<!-- 查询条件 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}"><!-- attributes属性，新版自定义多选框微调增加 -->
<%//以下开始列出自定义查询条件
sql="";
if(RecordSet.getDBType().equals("oracle")){
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield,workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid,workflow_billfield.type as type,mode_CustombrowserDspField.conditionTransition as conditionTransition from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}else{
    sql = "select * from (select mode_CustombrowserDspField.queryorder ,mode_CustombrowserDspField.showorder ,workflow_billfield.id as id,workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype ,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield,workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid,workflow_billfield.type as type,mode_CustombrowserDspField.conditionTransition as conditionTransition from workflow_billfield,mode_CustombrowserDspField,mode_custombrowser where mode_CustombrowserDspField.customid=mode_custombrowser.id and mode_custombrowser.id="+customid+" and mode_CustombrowserDspField.isquery='1' and workflow_billfield.billid='"+formID+"' and workflow_billfield.id=mode_CustombrowserDspField.fieldid ";
}
    sql+=" union select queryorder,showorder,fieldid as id,'' as name,'' as label,'' as dbtype,0 as selectitem,0 as linkfield,'' as httype,0 as childfieldid,0 as type,0 as conditionTransition from mode_CustombrowserDspField where isquery='1' and fieldid in(-1,-2,-3,-4,-5,-6,-7,-8,-9) and customid="+customid;
    sql+=") a order by a.queryorder,a.showorder,a.id";
int i=0;
RecordSet.execute(sql);
while (RecordSet.next())
{
i++;
String name = RecordSet.getString("name");
String label = RecordSet.getString("label");
String htmltype = RecordSet.getString("httype");
String type = RecordSet.getString("type");
String id = RecordSet.getString("id");
String dbtype = Util.null2String(RecordSet.getString("dbtype"));
int selectitem =Util.getIntValue(Util.null2String(RecordSet.getString("selectitem")),0);
int linkfield = 0;
rs.execute("select id from workflow_billfield where linkfield="+id);
if(rs.next()){
	linkfield = Util.getIntValue(rs.getString("id"), 0);
}
label = SystemEnv.getHtmlLabelName(Util.getIntValue(label),user.getLanguage());
String childfieldid = Util.null2String(RecordSet.getString("childfieldid"));
int conditionTransition = Util.getIntValue(Util.null2String(RecordSet.getString("conditionTransition")),0);

String namestr = "con"+id+"_value";
String browserType = type;
if ("0".equals(type)) browserType = "";
String completeUrl = "javascript:getajaxurl('" + browserType + "','"+dbtype+"','"+id+"','1')";
if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="-2";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());//创建人
    htmltype="3";
    type="1";
}
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";

//String multiselectvalue = "";
tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
//multiselectvalue = Util.null2String(conht.get("multiselectValue_con"+id+"_value"));
%>
<wea:item>
<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
<input type=hidden name="con<%=id%>_type" value="<%=type%>">
<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
<input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" checked="checked"> <%=label%><!-- 是否作为查询条件 -->
</wea:item>
<wea:item>
<%
if(!tmpvalue.equals("")){
	FieldInfo fieldInfo = new FieldInfo();
	tmpname = fieldInfo.getFieldName(tmpvalue,Util.getIntValue(type),dbtype);
}
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){  //文本框
    int tmpopt=3;
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<%if(!htmltype.equals("2")){//TD9319 屏蔽掉多行文本框的“等于”和“不等于”操作，text数据库类型不支持该判断%>
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>     <!--等于-->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>   <!--不等于-->
<%}%>
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>   <!--包含-->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>   <!--不包含-->

</select>
<input type=text class=InputStyle style="width:50%" name="con<%=id%>_value" value="<%=tmpvalue%>">

<SPAN id=remind style='cursor:hand' title='<%=SystemEnv.getHtmlLabelName(82346,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82347,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82348,user.getLanguage())%>&#10;<%=SystemEnv.getHtmlLabelName(82349,user.getLanguage())%>'>
<IMG src='/images/remind_wev8.png' align=absMiddle>
</SPAN>

<%}
else if(htmltype.equals("1")&& !type.equals("1")){  //数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
    int tmpopt=2;
    int tmpopt1=4;
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><!-- 大于或等于 -->
<input type=text style="width:50%;" class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value')" value="<%=tmpvalue%>">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<div>
<%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><!-- 小于或等于 -->
<input type=text style="width:50%;" class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1')" value="<%=tmpvalue1%>">
</div>
<%
}
else if(htmltype.equals("4")){   //check类型
%>
<input type=checkbox value=1 name="con<%=id%>_value" <%if(tmpvalue.equals("1")){%>checked<%}%>>

<%}
else if(htmltype.equals("5")){  //选择框
    int tmpopt=1;
	String multiselect="";
	if(conditionTransition==1){
		multiselect="multiple=\"multiple\"";
		multiselectid+="con"+id+"_value,";
	}
%>
<input type="hidden" name="multiselectValue_con<%=id%>_value" id="multiselectValue_con<%=id%>_value" value="<%="" %>" />
<select class=inputstyle <%=multiselect %> name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){//子字段联动
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
	ldselectfieldid.add(id+"");
}
%>
<select class=inputstyle <%=multiselect %> name="con<%=id%>_value" id="con<%=id%>_value" <%if(!id.equals("_6") && !id.equals("_2") && !id.equals("_8")){%>onchange="<%=selectchange%>"<%}%>>
<%
if(conditionTransition!=1){
 %>
<option value="" ></option>
<%
}
char flag=2;
if(id.equals("_6")){
%>
    <option value="0" <%if (nodetype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125,user.getLanguage())%></option><!-- 创建 -->
    <option value="1" <%if (nodetype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></option><!-- 批准 -->
    <option value="2" <%if (nodetype.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(725,user.getLanguage())%></option><!-- 提交 -->
    <option value="3" <%if (nodetype.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option><!-- 归档 -->
<%
}else if(id.equals("_2")){
%>
    <option value="0" <%if (requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option><!-- 正常 -->
	<option value="1" <%if (requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option><!-- 重要 -->
	<option value="2" <%if (requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option><!-- 紧急 -->
<%
}else if(id.equals("_8")){
%>
    <option value="0" <%if (isdeleted==0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2246,user.getLanguage())%></option><!-- 有效 -->
    <option value="1" <%if (isdeleted==1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%></option><!-- 无效 -->
    <option value="2" <%if (isdeleted==2) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option><!-- 全部 -->
<%
}else{
rs.executeProc("workflow_SelectItemSelectByid",""+id+flag+isbill);
while(rs.next()){
	int tmpselectvalue = rs.getInt("selectvalue");
	String tmpselectname = rs.getString("selectname");
	String tempcancel = rs.getString("cancel");
	if("1".equals(tempcancel)){
		continue;
	}
%>
<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
<%}
}%>
</select>


<%}else if (htmltype.equals("8")){
	int tmpopt=1;
    %>
    <select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
    <option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
    <option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
    </select>
    <%
    String selectchange = "";
    if(linkfield!=0){//公共子字段联动
    	if(!iframeList.contains(id)){
    		iframeList.add(id);
    	}
    	selectchange = "changeChildSelectItemField(this,'"+id+"','"+linkfield+"');";
   	  	int selflinkfieldid = 1;
   		String selfSql = "select linkfield from workflow_billfield where id="+id;
   		selectRs.executeSql(selfSql);
   		if(selectRs.next()){
   			selflinkfieldid = selectRs.getInt("linkfield");
   			if(selflinkfieldid<1){
		    	initselectfield += "changeChildSelectItemField(0,'"+id+"','"+linkfield+"',1); \n ";
   			} 
   		}
    }
  
	
    %>
    <select initvalue="<%=tmpvalue %>" childsel="<%=linkfield %>" notBeauty=true class=inputstyle style="width:175px;"  name="con<%=id%>_value" id="con<%=id%>_value"  onchange="<%=selectchange%>" >
    <option value="" ></option>
   <%
	char flag=2;
	rs.executeSql("select id,name,defaultvalue from mode_selectitempagedetail where mainid = "+selectitem+" and statelev = 1  and (cancel=0 or cancel is null)  order by disorder asc,id asc");
	while(rs.next()){
		int tmpselectvalue = rs.getInt("id");
		String tmpselectname = rs.getString("name");
		String isdefault = rs.getString("defaultvalue");
		%>
		<option value="<%=tmpselectvalue%>" <%if (tmpvalue.equals(""+tmpselectvalue)) {%>selected<%}%>><%=Util.toScreen(tmpselectname,user.getLanguage())%></option>
		<%
	}%>
	</select>
	<%
} else if(htmltype.equals("3") && type.equals("1")){//浏览框单人力资源  like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡 (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门   (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


	<%} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户   (like not lik)
        int tmpopt=1;
        //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
         String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目  条件为多项目 (like not lik)
    int tmpopt=1;
    //String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求  (like not lik)
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/RequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%//=========================================================================================
}else if(htmltype.equals("3") && type.equals("24")){//职位
    int tmpopt=5;
    int tmpopt1=3;
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
}//职位end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期

	int tmpopt=2;
    int tmpopt1=4;
    String classStr = "";
	if(type.equals("2")){ //日期
		display = "display:none;";
		String datetype_opt_span_display = "display:none;";
		classStr = "calendar";
		int datetype_opt = Util.getIntValue(Util.null2String(request.getParameter("datetype_"+id+"_opt")),6);
		if(datetype_opt == 6){
			datetype_opt_span_display = "display:;";
		}
		%>
		<select name="datetype_<%=id%>_opt" id="datetype_<%=id%>_opt" style="display: block;" onchange="changeDateType(this,'datetype_<%=id%>_opt_span','con<%=id%>_value','con<%=id%>_valuespan','con<%=id%>_value1','con<%=id%>_value1span')">
		<option value="1" <%if(datetype_opt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
		<option value="2" <%if(datetype_opt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
		<option value="3" <%if(datetype_opt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
		<option value="7" <%if(datetype_opt==7){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(27347,user.getLanguage())%></option><!-- 上个月 -->
		<option value="4" <%if(datetype_opt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
		<option value="5" <%if(datetype_opt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
		<option value="8" <%if(datetype_opt==8){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(31276,user.getLanguage())+SystemEnv.getHtmlLabelName(25201,user.getLanguage())%></option><!-- 上一年 -->
		<option value="6" <%if(datetype_opt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
		</select>
		<span name="datetype_<%=id%>_opt_span" id="datetype_<%=id%>_opt_span" style="<%=datetype_opt_span_display%>">
			<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
			<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
			<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
			<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
			<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
			<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
			<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
			<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
			<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
			<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
			<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
			</select>
			<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
			<button type=button  class="<%=classStr %>" onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
			<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
			<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		</span>
		<%
	}else{ //时间
		int isresearch = 1;
		if(isresearch==1) {
	        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
	        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
	    }
		classStr = "Clock";
		%>
		<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
		<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%><%}%><!-- 从 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)" ></button>
		<input type=hidden name="con<%=id%>_value" id="con<%=id%>_value" value="<%=tmpvalue%>">
		<span name="con<%=id%>_valuespan" id="con<%=id%>_valuespan"><%=tmpvalue%></span>
		<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
		<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
		<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
		<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
		<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
		<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
		<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
		</select>
		<%if(issimple){%><%=SystemEnv.getHtmlLabelName(349,user.getLanguage())%><%}%><!-- 到 -->
		<button type=button  class="<%=classStr %>" onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)" ></button>
		<input type=hidden name="con<%=id%>_value1" id="con<%=id%>_value1" value="<%=tmpvalue1%>">
		<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
		<%
	}

} else if(htmltype.equals("3") && type.equals("37")){//浏览框   (多文挡)
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("57")){//（多部门）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowserByOrder.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("135")){//浏览框  多选筐条件为单选筐（多项目 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("152")){//浏览框  多选筐条件为单选筐（多请求 ）
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=browserUrl%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp";
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    //String browserOnClick = "onShowResourceRole('"+id+"', '/systeminfo/BrowserMain.jsp?url=/hrm/resource/RoleResourceBrowser.jsp?selectids=', '', '160', '0', '')";
    String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp";
    int tmpopt=1;
    //String browserOnClick="onShowBrowser2('"+id+"','"+urls+"','"+type+"')";
    String browserUrl = urls;
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}
else if(htmltype.equals("3") && (type.equals("56")||type.equals("27")||type.equals("118")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    //String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    String browserUrl = urls;
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}else if(htmltype.equals("3") && type.equals("65")){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
   // String browserOnClick = "onShowResourceRole('"+id+"', '"+urls+"?selectedids=', '', '65', '0', '')";
   String browserUrl = urls;
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%= browserUrl %>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%
}
else if("3".equals(htmltype) && "141".equals(type)){
	String url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceConditionBrowser.jsp";
	String browserOnClick = "onShowResourceConditionBrowserForCondition('"+namestr+"','"+url+"','','141',0)";
    int tmpopt=1;
	%>
	
	<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
	<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
	<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
	</select>
	
	<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
	</brow:browser>
	<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
	<%
}
else if(htmltype.equals("3") && id.equals("_5")){//工作流浏览框
    tmpname="";
    ArrayList tempvalues=Util.TokenizerString(tmpvalue,",");
    for(int k=0;k<tempvalues.size();k++){
        if(tmpname.equals("")){
            tmpname=WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }else{
            tmpname+=","+WorkflowComInfo.getWorkflowname((String)tempvalues.get(k));
        }
    }
%>

<input type=hidden  name="con<%=id%>_opt" value="1">
<%if(customid.equals("")){
String browserOnClick="onShowWorkFlowSerach('workflowid','workflowspan')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<span id=workflowspan>
	<%=workflowname%>
</span>

<%}else{
	String browserOnClick="onShowCQWorkFlow('con"+id+"_value','con"+id+"_valuespan','"+type+"')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}%>

<%} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
	String browserOnClick = "onShowBrowserCustom('"+id+"','"+urls+"','"+type+"')";
    int tmpopt=1;
    String isSingleStr = "true";//单选
    if(type.equals("162")){
    	isSingleStr = "false";
    }
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>' 
	hasInput="true" isSingle='<%=isSingleStr %>' hasBrowser="true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">


<%} else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type;     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String isSingle = "";
    String browserOnClick="onShowBrowserCustom('"+id+"','"+urls+"','"+type+"')";
    if(type.equals("256")){
    	isSingle = "true";
    }else{
    	isSingle = "false";
    }
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name="<%=namestr%>" browserValue="<%=tmpvalue %>" 
	browserUrl="<%=urls %>" 
	hasInput="true" isSingle="<%=isSingle%>" hasBrowser = "true" isMustInput='1' 
	completeUrl="<%=completeUrl%>" width="135px" 
	browserSpanValue="<%=tmpname%>">
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
	String browserOnClick="onShowBrowser('"+id+"','"+urls+"','"+type+"')";
    int tmpopt=1;
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl='<%=urls%>'
	hasInput="true" isSingle='<%=type.equals("194")?"false":"true" %>' hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
	String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1','"+type+"')";
    int tmpopt=1;
%>

<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"   >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">

<%}%>
</wea:item>
<%}%>
	</wea:group>
</wea:layout>
</div><!-- 新版自定义多选框微调增加div end -->
<%for(int i=0;i<iframeList.size();i++){%>
<iframe id="selectChange_<%=iframeList.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</form>
<div id="dialog">
	<div id='colShow'></div>
</div>
</div>
<div style="display:none;">
<!-- 此搜索按钮不能去掉，隐藏掉 -->
	<input  type="button" class=zd_btn_submit accessKey=S  id=btnsearch  value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"><!-- 搜索 -->
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
			<%
			if(!isview){
			%>
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok  value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"><!-- 确定 -->
			<%
			}
			%>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear  value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"><!-- 清除 -->
			<input type="button" class=zd_btn_submit accessKey=T  id=btncancel  value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
</wea:item>
</wea:group>
</wea:layout>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
jQuery(document).ready(function(){
	var hasSetDDCHeight = setDialogDivContentHeight();
	if(hasSetDDCHeight){
		//showMultiDocDialog("<%=beanids%>",srchead);
		showMultiDocDialog("<%=URLEncoder.encode(beanids,"UTF-8") %>",srchead);
	}
	<%=initselectfield%>
	<%
	String[] multiselectidArray = multiselectid.split(",");
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
		jQuery("#<%=multiselectidArray[m]%>").multiselect({
			multiple: true,
			noneSelectedText: '',
			checkAllText: "<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>",
	        uncheckAllText: "<%=SystemEnv.getHtmlLabelName(84355,user.getLanguage())%>",
	        selectedList:100,
	        minWidth:180,
	        close: function(){
				var tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  			jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv.join(","));
	  			var selectObj = jQuery("#<%=multiselectidArray[m]%>");
				var onchangeStr = selectObj.attr('onchange');
				if(onchangeStr&&onchangeStr!=""){
					var selObj = selectObj.get(0);
					if (selObj.fireEvent){
						selObj.fireEvent('onchange');
					}else{
						selObj.onchange();
					}
				}
			}
	  	});
	  	jQuery("#<%=multiselectidArray[m]%>").val(jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val().split(","));
	  	jQuery("#<%=multiselectidArray[m]%>").multiselect("refresh");
	<%}%>
	
	document.body.onclick = function (e){//浏览框里面 让链接点击无效
	 	var e=e||event;
	  		var target=e.srcElement||e.target;
	 	var tagName = target.tagName;
	 	if(tagName=="A" || tagName=="a"){
	 		return false;
	 	}
	}
	pageSizeChage();
	
	window.setTimeout(setContentHeight,600);
});

function pageSizeChage(){
	var srcpagesize = jQuery("#srcpagesize");
	if(srcpagesize.length==0){
		setTimeout(function(){pageSizeChage()},500);
		return;
	}
	srcpagesize.get(0).onchange = function(){
		jQuery("#isCustomPageSize").val("1");
	};
}

function setDialogDivContentHeight(){
	var zDialog_div_bottom = jQuery(".zDialog_div_bottom:first");
	var zDialog_div_content = jQuery(".zDialog_div_content:first");
	var bottomheight = zDialog_div_bottom.height();
	var paddingBottom = zDialog_div_bottom.css("padding-bottom");
	var paddingTop = zDialog_div_bottom.css("padding-top");
	var headHeight = 0;
	var e8Box = zDialog_div_content.closest(".e8_box");
	if(e8Box.length>0){
		headHeight = e8Box.children(".e8_boxhead").height();
	}
	if(!!paddingBottom && paddingBottom.indexOf("px")>0){
		paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf("px"));
	}
	if(!!paddingTop && paddingTop.indexOf("px")>0){
		paddingTop = paddingTop.substring(0,paddingTop.indexOf("px"));
	}
	if(isNaN(paddingBottom)){
		paddingBottom = 0;
	}else{
		paddingBottom = parseInt(paddingBottom);
	}
	if(isNaN(paddingTop)){
		paddingTop = 0;
	}else{
		paddingTop = parseInt(paddingTop);
	}
	var bodyheight = jQuery(window).height();
	var dialogDivContentHeight = bodyheight-bottomheight-paddingTop-headHeight-7;
	zDialog_div_content.height(dialogDivContentHeight);
	return true;
}

//设置中间内容的高度
function setContentHeight(){
	var searchAreaHeight = jQuery("#frmmain").height();
	var e8_box_topmenu = jQuery(".e8_box_topmenu").height();
  	var contentHeight = jQuery("div.zDialog_div_content").height();
  	var height = contentHeight - e8_box_topmenu - searchAreaHeight - 2;
  	var currentHeight = $("#src_box_middle").height();
  	if(currentHeight<height){
  		$("#src_box_middle").height(height);
  		$("#dest_box_middle").height(height);
  	}
}

function changeDateType(obj,spanid,dateid,datespan,dateid1,datespan1){
   if(jQuery(obj).val()=='6'){
      jQuery("#"+spanid).css("display","inline");
   }else{
      jQuery("#"+spanid).css("display","none");
   }
   if(obj.value=="0"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}else if(obj.value=="1"){
		jQuery("#"+dateid).val(getTodayDate());
		jQuery("#"+datespan).html(getTodayDate());
		jQuery("#"+dateid1).val(getTodayDate());
		jQuery("#"+datespan1).html(getTodayDate());
	}else if(obj.value=="2"){
		jQuery("#"+dateid).val(getWeekStartDate());
		jQuery("#"+datespan).html(getWeekStartDate());
		jQuery("#"+dateid1).val(getWeekEndDate());
		jQuery("#"+datespan1).html(getWeekEndDate());
	}else if(obj.value=="3"){
		jQuery("#"+dateid).val(getMonthStartDate());
		jQuery("#"+datespan).html(getMonthStartDate());
		jQuery("#"+dateid1).val(getMonthEndDate());
		jQuery("#"+datespan1).html(getMonthEndDate());
	}else if(obj.value=="7"){//上个月
		jQuery("#"+dateid).val(getLastMonthStartDate());
		jQuery("#"+datespan).html(getLastMonthStartDate());
		jQuery("#"+dateid1).val(getLastMonthEndDate());
		jQuery("#"+datespan1).html(getLastMonthEndDate());
	}else if(obj.value=="4"){
		jQuery("#"+dateid).val(getQuarterStartDate());
		jQuery("#"+datespan).html(getQuarterStartDate());
		jQuery("#"+dateid1).val(getQuarterEndDate());
		jQuery("#"+datespan1).html(getQuarterEndDate());
	}else if(obj.value=="5"){
		jQuery("#"+dateid).val(getYearStartDate());
		jQuery("#"+datespan).html(getYearStartDate());
		jQuery("#"+dateid1).val(getYearEndDate());
		jQuery("#"+datespan1).html(getYearEndDate());
	}else if(obj.value=="8"){//上一年
		jQuery("#"+dateid).val(getLastYearStartDate());
		jQuery("#"+datespan).html(getLastYearStartDate());
		jQuery("#"+dateid1).val(getLastYearEndDate());
		jQuery("#"+datespan1).html(getLastYearEndDate());
	}else if(obj.value=="6"){
		jQuery("#"+dateid).val("");
		jQuery("#"+datespan).html("");
		jQuery("#"+dateid1).val("");
		jQuery("#"+datespan1).html("");
	}
}

function changeChildField(obj, fieldid, childfieldid){
	var multiselectflag="0";
	if("<%=multiselectid%>".indexOf(fieldid)>-1){
		multiselectflag="1";
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value+"&isSearch=1&browserid=<%=customid%>&multiselectflag="+multiselectflag+"&multiselectvalue="+jQuery("#multiselectValue_con"+fieldid+"_value").val();
    document.getElementById("selectChange_"+fieldid).src = "/formmode/search/SelectChange.jsp?"+paraStr;
}

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//缂栬緫鏃跺垵濮嬪寲
		obj = $G("con"+fieldid+"_value");
	}
	if(!obj){
		obj = $G("con"+fieldid+"_value");
	}
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    if(isinit&&isinit==1){
    	paraStr = paraStr + "&isinit="+isinit;
    }
    var iframe = jQuery("#selectChange_"+fieldid);
    if(iframe.length==0){
    	iframe = jQuery("#selectChange");
    }
    iframe.get(0).src = "/formmode/search/SelectItemChangeByQuery.jsp?"+paraStr;
}

function nextSelectRefreshMultiSelect(selectid){
	var tmpmsv = jQuery("#"+selectid).multiselect("getChecked").map(function(){return this.value;}).get();
	jQuery("#multiselectValue_"+selectid).val(tmpmsv.join(","));
	jQuery("#"+selectid).val(jQuery("#multiselectValue_"+selectid).val().split(","));
	jQuery("#"+selectid).multiselect("refresh");
}

//多选下拉框赋值
function multselectSetValue(){
	var tmpmsv="";
    <%
	for(int m=0;m<multiselectidArray.length;m++){
		if(Util.null2String(multiselectidArray[m]).trim().equals(""))
			continue;
	%>
	  tmpmsv = jQuery("#<%=multiselectidArray[m]%>").multiselect("getChecked").map(function(){return this.value;}).get();
	  
	  jQuery("#multiselectValue_<%=multiselectidArray[m]%>").val(tmpmsv);
	<%}%>

}

function btnsearch_onclick(){
	multselectSetValue();
	jQuery("#btnsearch").click();
}
function btnok_onclick(){
	jQuery("#btnok").click();
}
function btnclear_onclick(){
	jQuery("#btnclear").click();
}
function btncancel_onclick(){
	jQuery("#btncancel").click();
}

function onSearchWFQTDate(spanname,inputname,inputname1){
    WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
	     },oncleared:function(){
		      spanname.innerHTML = '';
		      inputname.value = '';
		 }
	});	
}
function onSearchWFQTTime(spanname,inputname,inputname1){
    var dads  = document.all.meizzDateLayer2.style;
    setLastSelectTime(inputname);
	var th = spanname;
	var ttop  = spanname.offsetTop;
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft;
	var ttyp  = spanname.type;
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop;
		tleft += spanname.offsetLeft;
	}
	var t = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
	dads.top = t+"px";
	dads.left = tleft+"px";
	$(document.all.meizzDateLayer2).css("z-index",99999);
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
    CustomQuery=1;
    outValue1 = inputname1;
}

function onShowBrowser(id,url) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
}

function onShowBrowser2(id, url, type1) {
	var tmpids = "";
	var id1 = null;
	if (type1 == 8) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?projectids=" + tmpids);
	} else if (type1 == 9) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?documentids=" + tmpids);
	} else if (type1 == 1) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 4) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?selectedids=" + tmpids
				+ "&resourceids=" + tmpids);
	} else if (type1 == 16) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 7) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
	} else if (type1 == 142) {
		tmpids = $G("con" + id + "_value").value;
		id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
	}
	//id1 = window.showModalDialog(url)
	if (id1 != null) {
		resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
		resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			if(resourceids!=""&&resourceids.indexOf(",")==0){
				resourceids = resourceids.substr(1);
			}
			if(resourcename!=""&&resourcename.indexOf(",")==0){
				resourcename = resourcename.substr(1);
			}
			$G("con" + id + "_valuespan").innerHTML = resourcename;
			jQuery("input[name=con" + id + "_value]").val(resourceids);
			jQuery("input[name=con" + id + "_name]").val(resourcename);
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowBrowserCustom_old(id, url, type1) {
	url+="&iscustom=1";
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}
	var id1 = window.showModalDialog(url, window, 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				descs = names;
				$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
}

function onShowBrowserCustom(id, url, type1) {
	if (type1 == 256|| type1==257) {
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
		url+="&iscustom=1";
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		url+="&iscustom=1";
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = dialogurl;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var sHtml = "";
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				if(href == undefined || href=="" ){
					sHtml +=  wrapshowhtml("<a title='" + names + "' >" + names + "</a>&nbsp",curid,1);
				}else{
					var onclickstr="onclick=\"javascript:window.open('"+href+ids+"');\"";
					sHtml +=  wrapshowhtml("<a "+onclickstr+" title='" + names + "' >" + names + "</a>&nbsp",curid,1);
				}
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var sHtml = "";
				var href = wuiUtil.getJsonValueByIndex(id1, 3);

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");

				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					if(curdesc==''||curdesc=='undefined'||curdesc==null){
						curdesc = curname;
					}
					if(curdesc){
						curdesc = curname;
					}
					if(href == undefined || href=="" ){
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}else{
						var onclickstr="onclick=\"javascript:window.open('"+href+curid+"');\"";
						sHtml +=  wrapshowhtml("<a "+onclickstr+" title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
			}
			if (type1 == 256||type1 == 257) {
				$G("con" + id + "_valuespan").innerHTML =  names ;
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = names;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
	}
		
	hoverShowNameSpan(".e8_showNameClass");
	   
	};
	
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
	dialog.Width = 550 ;
	if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
		dialog.Width=648; 
	}
	dialog.Height = 600;
	dialog.Drag = true;
	dialog.show();

}
function onShowWorkFlowSerach(inputname, spanname) {

	retValue = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	temp = $G(inputname).value;
	if(retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "0" && wuiUtil.getJsonValueByIndex(retValue, 0) != "") {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0);
			
			if (temp != wuiUtil.getJsonValueByIndex(retValue, 0)) {
				$G("frmmain").action = "WFCustomSearchBySimple.jsp";
				$G("frmmain").submit();
			}
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
			$G("frmmain").action = "WFSearch.jsp";
			$G("frmmain").submit();

		}
	}
}

function onShowCQWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
</script>
<%for(int i=0;i<ldselectfieldid.size();i++){%>
<iframe id="selectChange_<%=ldselectfieldid.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</body>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js?v=1"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</html>
<script>
/**
 * 角色人员
 */
function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("con" + id+"_value").value;
	url = url + tmpids;
	//id1 = window.showModalDialog(url);
	var dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	//dialog.callbackfunParam = null;
	dialog.URL = url;
	dialog.callbackfun = function (paramobj, id1) {
		if (id1) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
					&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
	
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = "";
				if (resourceids.indexOf(",") == 0) {
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
				}
				$GetEle("con" + id+"_value").value = resourceids;
				var idArray = resourceids.split(",");
				var nameArray = resourcename.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml = sHtml + "<a href=" + linkurl + curid
							+ " target='_new'>" + curname + "</a>&nbsp";
				}
				$GetEle("con" + id + "_valuespan").innerHTML = sHtml;
	
			} else {
				if (ismand == 0) {
					$GetEle("con" + id + "_valuespan").innerHTML = "";
				} else {
					$GetEle("con" + id + "_valuespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}
				$GetEle("con" + id+"_value").value = "";
			}
		}
	
	};
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage()) %>";
	dialog.Width = 550 ;
	dialog.Height = 600;
	dialog.Drag = true;
	//dialog.maxiumnable = true;
	dialog.show();
}

</script>