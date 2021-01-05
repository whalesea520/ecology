<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="selectRs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="customSearchService" class="weaver.formmode.service.CustomSearchService" scope="page" />
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="FormModeConfig" class="weaver.formmode.FormModeConfig" scope="page" />
<%@ page import="weaver.formmode.data.FieldInfo"%>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/formmode/js/modebrow_wev8.js"></script>

<STYLE TYPE="text/css">
*, textarea{
	font: 12px Microsoft YaHei;
}
a{
	color: #333;
}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 2px;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
td.btnTd{background-color:#fff;}
/*CustomSearch ProgressBar*/
.csProgressBar{ 
	position: relative;
	width: 100px;
	border: 1px solid #eee; 
	padding: 1px; 
} 
.csProgressBar div{ 
	display: block; 
	position: relative;
	height: 18px;
	background-color: #99b433;
}
.csProgressBar div span{ 
	position: absolute; 
	width: 100px;
	text-align: center; 
	font: 10px Verdana;
	line-height: 18px;
	color: #000;
}
.csProgressBarGold div{
	background-color: #e3a21a;
}
.csProgressBarRed div{
	background-color: #da532c;
}
</style>
</HEAD>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(83146,user.getLanguage());//查询列表高级搜索条件
String needfav ="1";
String needhelp ="";
boolean isEnabled = FormModeConfig.isEnabled();
String enabled = Util.null2String(request.getParameter("enabled"),"0");
boolean issimple= true;
int isresearch=1;
Hashtable conht=new Hashtable();

int customid = Util.getIntValue(request.getParameter("customid"),0);
int viewtype=Util.getIntValue(request.getParameter("viewtype"),0);
Map m = customSearchService.getCustomSearchById(customid);
String isbill = "1";
int formID = Util.getIntValue(Util.null2String(m.get("formid")),0);
titlename = Util.null2String(m.get("customname"));
int templateid = Util.getIntValue(request.getParameter("templateid"),0);
int sourcetype = Util.getIntValue(request.getParameter("sourcetype"),0);

rs.execute("select modeid from mode_customsearch a where a.id="+customid);
String modeid = "0";
if(rs.next()){
    modeid=""+Util.getIntValue(rs.getString("modeid"),0);
}
String sql = "";
if(RecordSet.getDBType().equals("oracle")){
	sql = "select workflow_billfield.id as id"+
	",workflow_billfield.fieldname as name,to_char(workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield"+
	",workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid, workflow_billfield.type as type,viewtype,"+
	" topt,topt1,tvalue,tvalue1,tname" + 
	" from workflow_billfield,mode_TemplateDspField,mode_TemplateInfo where mode_TemplateDspField.templateid=mode_TemplateInfo.id and workflow_billfield.id=mode_TemplateDspField.fieldid and mode_TemplateInfo.customid="+customid;
	sql += " AND mode_TemplateDspField.templateid="+templateid+" order by fieldorder";
} else {
	sql = "select workflow_billfield.id as id"+
	",workflow_billfield.fieldname as name,convert(varchar,workflow_billfield.fieldlabel) as label,workflow_billfield.fielddbtype as dbtype,workflow_billfield.selectitem as selectitem,workflow_billfield.linkfield as linkfield"+
	",workflow_billfield.fieldhtmltype as httype,workflow_billfield.childfieldid as childfieldid, workflow_billfield.type as type,viewtype,"+
	" topt,topt1,tvalue,tvalue1,tname" + 
	" from workflow_billfield,mode_TemplateDspField,mode_TemplateInfo where mode_TemplateDspField.templateid=mode_TemplateInfo.id and workflow_billfield.id=mode_TemplateDspField.fieldid and mode_TemplateInfo.customid="+customid;
	sql += " AND mode_TemplateDspField.templateid="+templateid+" order by fieldorder";
}
RecordSet.executeSql(sql);
while (RecordSet.next()) {
	String tmpid = RecordSet.getString("id");
	String topt = RecordSet.getString("topt");
	String topt1 = RecordSet.getString("topt1");
	String tvalue = RecordSet.getString("tvalue");
	String tvalue1 = RecordSet.getString("tvalue1");
	String tname = RecordSet.getString("tname");
	conht.put("con_"+tmpid,"1");
	conht.put("con_"+tmpid+"_opt",topt);
	conht.put("con_"+tmpid+"_opt1",topt1);
	conht.put("con_"+tmpid+"_value",tvalue);
	conht.put("con_"+tmpid+"_value1",tvalue1);
	conht.put("con_"+tmpid+"_name",tname);
}

int sharelevel = 0 ;

FormInfoService formInfoService = new FormInfoService();
List<Map<String, Object>> detailTables = formInfoService.getAllDetailTable(formID);
Map detailtableMap = new HashMap();
int tabIndex = 1;
for(int i=0;i<detailTables.size();i++){
	Map map = detailTables.get(i);
	String tablename = Util.null2String(map.get("tablename"));
	if(!detailtableMap.containsKey(tablename)){
		detailtableMap.put(tablename,tabIndex);
		tabIndex++;
	}
}
String initselectfield = "";
List iframeList = new ArrayList();
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022 ,user.getLanguage())+",javascript:onClear(),_self} " ;//重置
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveTempalte(),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onReturn(),_self} " ;//返回
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="onClear();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>"><!-- 重置 -->
			<input type="button" class="e8_btn_top" name="savetmp" onclick="onSaveTempalte();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/><!-- 保存 -->
			<input type="button" class="e8_btn_top" name="return" onclick="onReturn();" value="<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
	
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/formmode/template/SaveTemplateOperation.jsp" method="post">
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<input type="hidden" value="saveTemplateValue" name="method">
<input type="hidden" value="<%=formID%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=customid value="<%=customid%>">
<input type=hidden name=templateid value="<%=templateid%>">
<input type=hidden name=searchname value="<%=titlename%>">
<input type=hidden name=sourcetype value="<%=sourcetype%>">
<input type=hidden name=operation>


<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage()) %>' attributes=""><!--搜索条件  -->
		<%//以下开始列出自定义查询条件
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
int field_viewtype=RecordSet.getInt("viewtype");

String browsertype = type;
if (type.equals("0")) browsertype = "";
String completeUrl = "javascript:getajaxurl('"+browsertype+"','"+dbtype+"','"+id+"','1')";

if(id.equals("-1")){
    id="_3";
    name="modedatacreatedate";
    label=SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
    htmltype="3";
    type="2";
}else if(id.equals("-2")){
    id="_4";
    name="modedatacreater";
    label=SystemEnv.getHtmlLabelName(882,user.getLanguage());// 创建人
    htmltype="3";
    type="1";
}
String namestr = "con"+id+"_value";
String display="display:'';";
if(issimple) display="display:none;";
String checkstr="checked";
String tmpvalue="";
String tmpvalue1="";
String tmpname="";
if(isresearch==1){
    tmpvalue=Util.null2String((String)conht.get("con_"+id+"_value"));
    tmpvalue1=Util.null2String((String)conht.get("con_"+id+"_value1"));
    tmpname=Util.null2String((String)conht.get("con_"+id+"_name"));
}
%>
		<wea:item><!-- 是否作为查询条件 -->
			<input type='checkbox' name='check_con' title="<%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%>" value="<%=id%>" style="display:none" <%=checkstr%>> <%=label%>
			<input type=hidden name="con<%=id%>_htmltype" value="<%=htmltype%>">
			<input type=hidden name="con<%=id%>_type" value="<%=type%>">
			<input type=hidden name="con<%=id%>_colname" value="<%=name%>">
			<input type=hidden name="con<%=id%>_viewtype" value="<%=field_viewtype%>">
		</wea:item>
		<wea:item>
<%
//=========================================================================================文本框
if((htmltype.equals("1")&& type.equals("1"))||htmltype.equals("2")){
    int tmpopt=3;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),3);
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
<%
//=========================================================================================数字   <!--大于,大于或等于,小于,小于或等于,等于,不等于-->
}else if(htmltype.equals("1")&& !type.equals("1")){  
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value" onblur="checknumber('con<%=id%>_value');" value="<%=tmpvalue%>" style="width:75px;">
<select class=inputstyle  name="con<%=id%>_opt1" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt1==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt1==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt1==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt1==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt1==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt1==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%><%}%>
<input type=text class=InputStyle size=10 name="con<%=id%>_value1"  onblur="checknumber('con<%=id%>_value1');" value="<%=tmpvalue1%>" style="width:75px;">
<%
//=========================================================================================check类型
}
else if(htmltype.equals("4")){   
%>
<input type=checkbox value=1 name="con<%=id%>_value" <%if(tmpvalue.equals("1")){%>checked<%}%>>
<%
//=========================================================================================选择框	
}
else if(htmltype.equals("5")){  //
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%
String selectchange = "";
if(!childfieldid.equals("")&&!childfieldid.equals("0")){//子字段联动
	selectchange = "changeChildField(this,'"+id+"','"+childfieldid+"');";
	initselectfield += "changeChildField(jQuery('#con"+id+"_value')[0],'"+id+"','"+childfieldid+"');";
}
%>
<select notBeauty=true class=inputstyle  name="con<%=id%>_value" id="con<%=id%>_value"  onchange="<%=selectchange%>" >
<option value="" ></option>
<%
char flag=2;
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
<%
}
%>
</select>

<%
//=========================================================================================浏览框单人力资源  条件为多人力 (like not lik)
} else if(htmltype.equals("3") && type.equals("1")){////浏览框单人力资源 
    int tmpopt=1;
    String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    if(!tmpvalue.equals("")){
    	FieldInfo fieldInfo = new FieldInfo();
    	tmpname = fieldInfo.getFieldName(tmpvalue,1);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90">
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================浏览框单文挡  条件为多文挡 (like not lik)
} else if(htmltype.equals("3") && type.equals("9")){//浏览框单文挡  
    int tmpopt=1;
    String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("4")){//浏览框单部门  
    int tmpopt=1;
    String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
	<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("7")){//浏览框单客户 
        int tmpopt=1;
        String browserOnClick = "onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("8")){//浏览框单项目
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	
//=========================================================================================
} else if(htmltype.equals("3") && type.equals("16")){//浏览框单请求
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18987,user.getLanguage())%></option><!-- 被包含于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18988,user.getLanguage())%></option><!-- 不被包含于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
	
//=========================================================================================
}else if(htmltype.equals("3") && type.equals("24")){//职位的安全级别
    int tmpopt=1;
    int tmpopt1=3;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),3);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90"  >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%><%}%><!-- 大于 -->
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!-- 大于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!-- 大于或等于 -->
<option value="3" <%if(tmpopt==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!-- 小于 -->
<option value="4" <%if(tmpopt==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!-- 小于或等于 -->
<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<%if(issimple){%><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%><%}%><!-- 小于 -->
<input type=text class=InputStyle size=10 name="con<%=id%>_value1" value="<%=tmpvalue1%>" >
<%
//=========================================================================================	
}//职位安全级别end

else if(htmltype.equals("3") &&( type.equals("2") || type.equals("19"))){    //日期
    int tmpopt=2;
    int tmpopt1=4;
    if(isresearch==1) {
        tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),2);
        tmpopt1=Util.getIntValue((String)conht.get("con_"+id+"_opt1"),4);
    }
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
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_valuespan,con<%=id%>_value,con<%=id%>_value1)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value" value="<%=tmpvalue%>">
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
<button type=button  class=calendar
<%if(type.equals("2")){%>
 onclick="onSearchWFQTDate(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)"
<%}else{%>
 onclick ="onSearchWFQTTime(con<%=id%>_value1span,con<%=id%>_value1,con<%=id%>_value)"
<%}%>
 ></button>
<input type=hidden name="con<%=id%>_value1" value="<%=tmpvalue1%>">
<span name="con<%=id%>_value1span" id="con<%=id%>_value1span"><%=tmpvalue1%></span>
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("17")){ //人力资源 多选框
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    if(!tmpvalue.equals("")){
    	FieldInfo fieldInfo = new FieldInfo();
    	tmpname = fieldInfo.getFieldName(tmpvalue,17);
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("37")){//浏览框 (多文挡)
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?isworkflow=1')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("57")){//浏览框（多部门）
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/company/MultiDepartmentBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("135")){//浏览框（多项目 ）
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("152")){//浏览框（多请求 ）
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option><!-- 包含 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option><!-- 不包含 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("18")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
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
//=========================================================================================	
}
else if(htmltype.equals("3") && type.equals("160")){//浏览框  多选筐条件为单选筐
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
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
//=========================================================================================	
} else if(htmltype.equals("3") && type.equals("142")){//浏览框多收发文单位
String urls = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp";
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
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
//=========================================================================================	
}
else if(htmltype.equals("3") && (type.equals("141")||type.equals("56")||type.equals("27")||type.equals("118")||type.equals("65")||type.equals("64")||type.equals("137"))){//浏览框
String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
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
//=========================================================================================	
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
<%if(customid==0){
String browserOnClick="onShowWorkFlowSerach('workflowid','workflowspan')";
%>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<span id=workflowspan></span>
<%}else{
String browserOnClick="onShowCQWorkFlow('con"+id+"_value','con"+id+"_valuespan')";
%>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%}%>
<%
//=========================================================================================	
} else if (htmltype.equals("3") && (type.equals("161") || type.equals("162"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype;     // 浏览按钮弹出页面的url
	String browserOnClick = "onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
	String method2 = "setName('"+id+"')";
    int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
    String isSignle = "true";
    String width = "135px";
    if (type.equals("162")) {
    	isSignle = "false";
    	width = "270px";
    }
    Browser browser=(Browser)StaticObj.getServiceByFullname(dbtype, Browser.class);
    if(!tmpvalue.equals("")){
	    tmpname = "";
	    String[] tmpvalueArr = tmpvalue.split(",");
	    for(int m1=0;m1<tmpvalueArr.length;m1++){
	    	if(!tmpvalueArr[m1].equals("")){
		    	BrowserBean bb=browser.searchById(tmpvalueArr[m1]);
				String tname=Util.null2String(bb.getName());
				String href=Util.null2String(bb.getHref());
				String hrefStr="";
				if(!href.equals("")){
					hrefStr=" href='"+href+"' target='_blank' ";
				}
				tmpname += "<a "+hrefStr+"  >"+tname+"</a>&nbsp;";
	    	}
	    }
    }
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>
<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick %>' browserUrl='<%=urls%>' onPropertyChange='<%=method2%>' 
	hasInput="true" isSingle='<%=isSignle%>' hasBrowser="true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width='<%=width%>' nameSplitFlag='&nbsp;'
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if (htmltype.equals("3") && (type.equals("256") || type.equals("257"))){
	String urls=BrowserComInfo.getBrowserurl(type)+"?type="+dbtype+"_"+type;     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowserCustomNew('"+id+"','"+urls+"','"+type+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" nameSplitFlag='&nbsp;'
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%} else if (htmltype.equals("3")){
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','"+urls+"')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
%>
<select class=inputstyle  name="con<%=id%>_opt" style="<%=display%>width:90" >
<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!-- 等于 -->
<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!-- 不等于 -->
</select>

<brow:browser viewType="0" name='<%=namestr%>' browserValue='<%=tmpvalue %>' 
	browserOnClick='<%=browserOnClick%>'
	hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	completeUrl='<%=completeUrl%>' width="135px" 
	browserSpanValue='<%=tmpname%>'>
</brow:browser>
<input type=hidden name="con<%=id%>_name" value="<%=tmpname%>">
<%
//=========================================================================================	
} else if (htmltype.equals("6")){   //附件上传同多文挡
	String urls=BrowserComInfo.getBrowserurl(type);     // 浏览按钮弹出页面的url
    int tmpopt=1;
    String browserOnClick="onShowBrowser('"+id+"','/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp?isworkflow=1')";
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
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
<%}else if (htmltype.equals("8")){
	int tmpopt=1;
    if(isresearch==1) tmpopt=Util.getIntValue((String)conht.get("con_"+id+"_opt"),1);
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
}%>
</wea:item>
<%}%>
	</wea:group>
</wea:layout>

<%for(int i=0;i<iframeList.size();i++){%>
<iframe id="selectChange_<%=iframeList.get(i) %>" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<%} %>
</FORM>

<script language="javascript">
function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=1&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "/formmode/search/SelectChange.jsp?"+paraStr;
}

function changeChildSelectItemField(obj, fieldid, childfieldid,isinit){
	if(isinit&&isinit==1){//编辑时初始化
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
function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function onShowCQWorkFlow(inputname, spanname) {
	var tmpids = $G(inputname).value;
	var url = uescape("?customid=<%=customid%>&value=<%=isbill%>_<%=formID%>_"
			+ tmpids);
	url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp"
			+ url;

	disModalDialogRtnM(url, inputname, spanname);
}

jQuery(document).ready(function(){
	<%=initselectfield%>;
});
function onClear(){
	$("#fromdatespan").html("");
	$("#todatespan").html("");
	$("#modedatacreaterspan").html("");
	$("span[name$='_valuespan']").html("");
	$("span[name$='_value1span']").html("");
	$("input[name$='_value']").val("");
	$("input[name$='_value1']").val("");
	$("input[name$='_name']").val("");
	//清除checkbox
	changeCheckboxStatus(jQuery("input[type='checkbox'][name^='con'],input[type='checkbox'][name='check_con']") ,false);
	var selects = $("select");
	for(var i=0;i<selects.length;i++){
		var objSelect = selects.get(i);
		var text = "";
		if(objSelect.options.length>0){
			objSelect.options[0].selected = true;
			text = objSelect.options[0].text;
		}
		var selshow = $(objSelect).next().find(".sbSelector");
		selshow.attr("title",text);
		selshow.html(text);
	}
}

function onSearchWFQTDate(spanname,inputname,inputname1){
	var oncleaingFun = function(){
		  $(spanname).innerHTML = '';
		  inputname.value = '';
		}
		WdatePicker({el:spanname,onpicked:function(dp){
			var returnvalue = dp.cal.getDateStr();
			$dp.$(inputname).value = returnvalue;
			},oncleared:oncleaingFun});
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
function uescape(url){
    return escape(url);
}
function mouseover(){
	this.focus();
}

function modeopenFullWindowHaveBar(url,obj){
	$("[id=span"+obj+"]").remove();
	openFullWindowHaveBar(url);
}

function modeopenFullWindowHaveBarForWFList(url,requestid,obj){
	$("[id=span"+obj+"]").remove();
	openFullWindowHaveBarForWFList(url,requestid);
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
function submit(){
	document.SearchForm.submit();
}

function onShowBrowser(id,url) {
	var url = url + "?selectedids=" + $G("con" + id + "_value").value;
	disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
	$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
}

function onShowBrowserCustom(id, url, type1, funFlag) {
	var urltemp = url;
	var tmpids = $G("con" + id + "_value").value;
	url = url + "|" + id + "&beanids=" + tmpids;
	url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
	url+="&iscustom=1";
	if(type1==256||type1==257){
		url = urltemp+"&selectedids="+tmpids;
	}
	var id1 = window.showModalDialog(url, window, 
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
			var names = wuiUtil.getJsonValueByIndex(id1, 1);
			var descs = wuiUtil.getJsonValueByIndex(id1, 2);
			if (type1 == 161) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				if(href==''){
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "'>" + names + "</a>&nbsp";
				}else{
					$G("con" + id + "_valuespan").innerHTML = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
					$G("con" + id + "_name").value = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
				}
				//$G("con" + id + "_valuespan").innerHTML = "<a title='" + ids + "'>" + names + "</a>&nbsp";
				$G("con" + id + "_value").value = ids;
				//$G("con" + id + "_name").value = names;
			}
			if (type1 == 162) {
				var href = wuiUtil.getJsonValueByIndex(id1, 3);
				var sHtml = "";
				names = names.substr(0);
				descs = descs.substr(0);

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
					if(href==''){
						sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					}else{
						sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
					}
					//sHtml = sHtml + "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
				}
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				//$G("con" + id + "_name").value = wuiUtil.getJsonValueByIndex(id1, 1);
				$G("con" + id + "_name").value = sHtml;
			}
			if (type1 == 256||type1==257) {
				var sHtml = "";
				sHtml = names;
				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = sHtml;
			}
		} else {
			$G("con" + id + "_valuespan").innerHTML = "";
			$G("con" + id + "_value").value = "";
			$G("con" + id + "_name").value = "";
		}
		hoverShowNameSpan(".e8_showNameClass");
	}
}

function onShowBrowserCustomNew(id, url, type1) {
	
	if (type1 == 256|| type1==257) {
		url+="&iscustom=1";
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "&selectedids=" + tmpids;
	}else{
		tmpids = $GetEle("con"+id+"_value").value;
		url = url + "|" + id + "&beanids=" + tmpids;
		url = url.substring(0,url.indexOf("?")+1)+"iscustom=1&"+url.substring(url.indexOf("url="), url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
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
				var href = "";
				if(id1.href&&id1.href!=""){
					href = id1.href+ids;
				}else{
					href = "";
				}
				var hrefstr="";
				if(href!=''){
					hrefstr=" href='"+href+"' target='_blank' ";
				}
				var sHtml = "<a "+hrefstr+" title='" + names + "'>" + names + "</a>";
				$G("con" + id + "_valuespan").innerHTML = wrapshowhtml(sHtml,ids,1);
				$G("con" + id + "_value").value = ids;
				$G("con" + id + "_name").value = sHtml;
			}
			if (type1 == 162) {
				var sHtml = "";

				var idArray = ids.split(",");
				var curnameArray = names.split("~~WEAVERSplitFlag~~");
				if(curnameArray.length < idArray.length){
					curnameArray = names.split(",");
				}
				var curdescArray = descs.split(",");
				var showname = "";
				for ( var i = 0; i < idArray.length; i++) {
					var curid = idArray[i];
					var curname = curnameArray[i];
					var curdesc = curdescArray[i];
					showname += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
					sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
				}

				$G("con" + id + "_valuespan").innerHTML = sHtml;
				$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				$G("con" + id + "_name").value = showname;
			}
			if (type1 == 256||type1 == 257) {
				names = names.replace(/<\/a>(__|,)/g,"</a>&nbsp;");//qc370946 逗号分隔问题
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

function onShowBrowser1(id,url,type1) {
	//var url = "/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp";
	if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con" + id + "_valuespan").innerHTML = id1;
		$G("con" + id + "_value").value=id1
	} else if (type1 == 1) {
		id1 = window.showModalDialog(url,"","dialogHeight:320px;dialogwidth:275px")
		$G("con"+id+"_value1span").innerHTML = id1;
		$G("con"+id+"_value1").value=id1;
	}
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
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
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

function onShowMutiHrm(spanname, inputename) {
	tmpids = $G(inputename).value;
	id1 = window
			.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1 != null) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$G(inputename).value = resourceids;

			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for ( var i = 0; i < resourceidArray.length(); i++) {
				var curid = resourceidArray[i];
				var curname = resourcenameArray[i];
				sHtml = sHtml + curname + "&nbsp";
			}

			$G(spanname).innerHTML = sHtml;
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = true;
			} else {
				$G("flownextoperator")[0].checked = false;
				$G("flownextoperator")[1].checked = true;
			}
		} else {
			$G(spanname).innerHTML = "";
			$G(inputename).value = "";
			if (spanname.indexOf("remindobjectidspan") != -1) {
				$G("isother").checked = false;
			} else {
				$G("flownextoperator")[0].checked = true;
				$G("flownextoperator")[1].checked = false;
			}
		}
	}
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

function disModalDialogRtnM(url, inputname, spanname) {
	var id = window.showModalDialog(url);
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			var ids = wuiUtil.getJsonValueByIndex(id, 0);
			var names = wuiUtil.getJsonValueByIndex(id, 1);
			
			if (ids.indexOf(",") == 0) {
				ids = ids.substr(1);
				names = names.substr(0);
			}
			$G(inputname).value = ids;
			var sHtml = "";
			
			var ridArray = ids.split(",");
			var rNameArray = names.split(",");
			
			for ( var i = 0; i < ridArray.length; i++) {
				var curid = ridArray[i];
				var curname = rNameArray[i];
				if (i != ridArray.length - 1) sHtml += curname + "，"; 
				else sHtml += curname;
			}
			
			$G(spanname).innerHTML = sHtml;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

function clickThisDate(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisdate']").attr("checked",false);
	obj.checked = checked;
}
function clickThisOrg(obj){
	var checked = obj.checked; 
	jQuery("input[name='thisorg']").attr("checked",false);
	obj.checked = checked;
}
function quickSearchDate(index){
	jQuery("input[name='thisdate']").attr("checked",false);
	jQuery("input[name='thisdate']")[index-1].checked=true;
}
function quickSearchOrg(index){
	jQuery("input[name='thisorg']").attr("checked",false);
	jQuery("input[name='thisorg']")[index-1].checked=true;
}
function clickEnabled(obj){
	var checked = obj.checked; 
	jQuery("input[name='enabled']").attr("checked",false);
	obj.checked = checked;
}
function onSaveTempalte(){
	document.SearchForm.action = "/formmode/template/SaveTemplateOperation.jsp";
	document.SearchForm.submit();
}
function onReturn() {
	document.SearchForm.action="/formmode/template/TemplateManageIframe.jsp?customid=<%=customid%>&sourcetype=<%=sourcetype%>";
	document.SearchForm.submit();
}
function onBtnSearchClick(){
	
}
function setName(id) {
	var name = $("#con"+id+"_valuespan a").text();
	$G("con" + id + "_name").value = name;
}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<!-- browser 相关 -->
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
</BODY></HTML>
