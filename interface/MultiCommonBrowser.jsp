<%@page import="java.net.URLEncoder"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.browser.FormModeBrowserSqlwhere"%>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="com.weaver.formmodel.util.StringHelper" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK REL=stylesheet type=text/css HREF='/js/dragBox/ereportstyle_wev8.css'>

<%
String isreport = Util.getIntValue(request.getParameter("isreport"),0)+"";

String check_per = Util.null2String(request.getParameter("beanids"));
Map<String,String> map = new HashMap<String,String>();
try{
	String tempquerystringGBK =  new String(Util.null2String(request.getQueryString()).getBytes("ISO8859-1"), "GBK");
	tempquerystringGBK = URLDecoder.decode(tempquerystringGBK, "utf-8");
	//map = Util.stringToMap(tempquerystringGBK);
	//check_per = Util.null2String(map.get("beanids"));
	//check_per = URLEncoder.encode(check_per.toString(),"utf-8");
	
	int startIndex = tempquerystringGBK.indexOf("beanids=")+8;
	int endIndex = tempquerystringGBK.indexOf("&splitflag");
	endIndex = endIndex==-1?tempquerystringGBK.lastIndexOf("%26splitflag"):endIndex;
	check_per = tempquerystringGBK.substring(startIndex,endIndex);
	check_per = URLEncoder.encode(check_per,"utf-8");
}catch(Exception e){
	
}
if(check_per.length()==0)check_per = Util.null2String(request.getParameter("selectedids"));
String beanids = "" ;
String name = Util.null2String(request.getParameter("name"));
String type = Util.null2String(request.getParameter("type"));
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
String currenttime = Util.null2String(request.getParameter("currenttime"));
String issearch = Util.null2String(request.getParameter("issearch"));
String othercallback = Util.null2String(request.getParameter("othercallback"));

String bts[] = type.split("\\|");
String frombrowserid = "";
type = bts[0];
if(bts.length>1){
	frombrowserid = bts[1];
}
type = java.net.URLDecoder.decode(type,"UTF-8");
//out.println("type : "+type);
if(type.indexOf("browser.")==-1)
{
	type = "browser."+type;
}
Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String href = Util.null2String(browser.getHref());
href = Util.null2String(browser.getHref(""+user.getUID(),href));
String outpage = Util.null2String(browser.getOutPageURL());
String from = Util.null2String(browser.getFrom());

String showtree = Util.null2String(browser.getShowtree());
if("1".equals(showtree)&& !from.equals("1"))
	outpage = "/interface/CommonTreeCenterBrowser.jsp?ismutil=2&othercallback="+othercallback+"&beanids="+check_per+"&isreport="+isreport;

browser.initBaseBrowser("",type,from);
// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	beanids=","+check_per;
	String[] tempArray = Util.TokenizerString2(beanids, ",");
}

//
Map searchfieldMap = browser.getSearchfieldMap();
Map searchvaluemap = new HashMap();
if(null!=searchfieldMap)
{
	Set keyset = searchfieldMap.keySet();
	int allcolumn = keyset.size();
	int i = 0;
    for(Iterator it = keyset.iterator();it.hasNext();)
    {
    	String keyname = (String)it.next();
    	String keyvalue = Util.null2String(request.getParameter(keyname));
    	//System.out.println("1199991 keyname : "+keyname+" keyvalue : "+keyvalue);
    	if(!"".equals(keyvalue))
    		searchvaluemap.put(keyname,keyvalue);
    }
}
Map paramvalues = browser.getParamvalues();
if(null!=paramvalues)
{
	Set keyset = paramvalues.keySet();
    for(Iterator it = keyset.iterator();it.hasNext();)
    {
    	String keyname = (String)it.next();
    	String keyvalue = Util.null2String(request.getParameter(keyname));
    	//System.out.println("2229966 keyname : "+keyname+" keyvalue : "+keyvalue);
    	if(!"".equals(keyvalue))
    		paramvalues.put(keyname,keyvalue);
    }
    browser.setParamvalues(paramvalues);
}

String needChangeFieldString = Util.null2String((String)session.getAttribute("needChangeFieldString_"+workflowid+"_"+currenttime));
HashMap allField = (HashMap)session.getAttribute("allField_"+workflowid+"_"+currenttime);
ArrayList allFieldList = (ArrayList)session.getAttribute("allFieldList_"+workflowid+"_"+currenttime);
if(allField==null){
	allField = new HashMap();
}
if(allFieldList==null){
	allFieldList = new ArrayList();
}
String fieldids[] = needChangeFieldString.split(",");
HashMap valueMap = new HashMap();
for(int i=0;i<fieldids.length;i++){
	String fieldid = Util.null2String(fieldids[i]);
	if(!fieldid.equals("")){
		String fieldvalue = Util.null2String(request.getParameter(fieldid));
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
		//System.out.println(fieldid+"	"+fieldvalue);
		valueMap.put(fieldid,fieldvalue);
	}
}
if(issearch.equals("1")){
	valueMap = (HashMap)session.getAttribute("valueMap_"+workflowid+"_"+currenttime);
	if(valueMap==null){
		valueMap = new HashMap();
	}
}else{
	session.setAttribute("valueMap_"+workflowid+"_"+currenttime,valueMap);
}
String tempname = browser.getName();
if("".equals(tempname))
	tempname = SystemEnv.getHtmlLabelName(83327 ,user.getLanguage());//自定义浏览框
String userid = user.getUID()+"";
String Search = browser.getSearch(userid);//.toLowerCase();//
String SearchByName = browser.getSearchByName();//.toLowerCase();// 

for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(!fieldname.equals("")){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
		//System.out.println(fieldname +"	@	"+fieldid+"	@	"+fieldvalue);
		//add by liaodong for qc84542 in 20130911 start
		if("".equals(fieldvalue)){
		  fieldvalue = "''";
		}//end
		//Search = Search.replace(fieldname,fieldvalue);
		//SearchByName = SearchByName.replace(fieldname,fieldvalue);
		Search = Util.replaceString2(Search, fieldname.replace("$","\\$"), fieldvalue.replace("$","\\$").replace("\\","\\\\"));
		SearchByName = Util.replaceString2(SearchByName, fieldname.replace("$","\\$"), fieldvalue.replace("$","\\$").replace("\\","\\\\"));
	}
}

if(!outpage.equals("")){
	if(from.equals("1")){//表单建模生成的自定义浏览按钮，多选页面替换成单选页面
		String modesingle = "/formmode/browser/CommonSingleBrowser.jsp";
		String modemulti = "/formmode/browser/CommonMultiBrowser.jsp";
		outpage = outpage.replace(modesingle,modemulti);
	}

	//重新计算where和sqlcondition
	String formmodefieldid = Util.null2String(request.getParameter("formmodefieldid"));
	String sqlwhereTemp = "";
	String sqlconditionTemp = "";
	if(!"".equals(formmodefieldid)){
		RecordSet rs = new RecordSet();
		rs.executeSql("select expendattr from ModeFormFieldExtend where fieldid="+formmodefieldid);
		if(rs.next()){
			String expendattr = rs.getString(1);
			expendattr = expendattr.replace("&lt;","<");
			expendattr = expendattr.replace("&gt;",">");
			FormModeBrowserSqlwhere fbs = new FormModeBrowserSqlwhere();
			Map<String,Map<String,String>> expendMap = fbs.get(expendattr, formmodefieldid);
			if(expendMap.containsKey("sqlcondition")){
				Map<String,String> tempMap = expendMap.get("sqlcondition");
				Iterator<String> it = tempMap.keySet().iterator();
				while(it.hasNext()){
					String key = it.next();
					sqlconditionTemp += key+"="+Util.null2String(request.getParameter(key))+" and ";
				}
			}
			if(expendMap.containsKey("sqlwhere")){
				Map<String,String> tempMap = expendMap.get("sqlwhere");
				sqlwhereTemp =FormModeBrowserSqlwhere.decode(tempMap.get("sql"));
				Map<String,String> fieldHtmlTypeMap = expendMap.get("fieldHtmlTypeMap");
				Iterator<String> it = fieldHtmlTypeMap.keySet().iterator();
				String rowIndex = frombrowserid.replace(formmodefieldid,"");
				while(it.hasNext()){
					String key = it.next();
					String value = Util.null2String(request.getParameter(key));
					if(!"".equals(rowIndex)){
						String valueTemp = Util.null2String(request.getParameter(key+rowIndex));
						if(!"".equals(valueTemp)){
							value = valueTemp;
						}
					}
					sqlwhereTemp = sqlwhereTemp.replace("$"+key+"$",value);
				}
			}
		}
	}

	String sqlwhere="";
	if(Search.toLowerCase().indexOf("where")!=-1){
		sqlwhere = Search.substring(Search.toLowerCase().indexOf("where")+5);
	}
	String _sqlwhere = sqlwhereTemp;

	if(!_sqlwhere.equals("")){
		if(!sqlwhere.equals("")){
			sqlwhere += " and "+_sqlwhere;
		}else{
			sqlwhere = _sqlwhere;
		}
	}

	//多参数sqlcondition拼接时将最后一个 and 去掉
    String sqlcondition = sqlconditionTemp.replaceAll("^(.+)\\s*and\\s*$", "$1");
	if(!"".equals(sqlwhere)){
		sqlwhere = xssUtil.put(sqlwhere);
	}
	if(!"".equals(sqlcondition)){
		sqlcondition = xssUtil.put(sqlcondition);
	}
	type = URLEncoder.encode(type);
	sqlwhere=URLEncoder.encode(sqlwhere,"utf-8");
	sqlcondition=URLEncoder.encode(sqlcondition,"utf-8");
	if(outpage.indexOf("?")>=0){
		outpage += "&browsertype="+URLEncoder.encode(type)+"&beanids="+check_per+"&sqlwhere="+sqlwhere+"&workflowid="+workflowid+"&currenttime="+currenttime+"&sqlcondition="+sqlcondition;
	}else{
		outpage += "?browsertype="+URLEncoder.encode(type)+"&beanids="+check_per+"&sqlwhere="+sqlwhere+"&workflowid="+workflowid+"&currenttime="+currenttime+"&sqlcondition="+sqlcondition;
	}
	response.sendRedirect(outpage);
	return;
}
String srcheads = "[";
int fieldsize = 2;

if("2".equals(from))
{
	if(null!=browser.getShowfieldMap())
	{
		fieldsize = browser.getShowfieldMap().size();
	}
}
if(fieldsize>0)
{
    if(!from.equals("2")){
    	srcheads += "[".equals(srcheads)?("'"+Util.null2String(browser.getNameHeader())+"'"):(",'"+Util.null2String(browser.getNameHeader())+"'");
    	srcheads += "[".equals(srcheads)?("'"+Util.null2String(browser.getDescriptionHeader())+"'"):(",'"+Util.null2String(browser.getDescriptionHeader())+"'");
	}else{
		Map showfieldMap = browser.getShowfieldMap();
		Set keyset = showfieldMap.keySet();
        for(Iterator it = keyset.iterator();it.hasNext();)
        {
           	String keyname = (String)it.next();
           	String showname = Util.null2String((String)showfieldMap.get(keyname));
           	if("".equals(showname))
           		continue;
           	srcheads += "[".equals(srcheads)?("'"+showname+"'"):(",'"+showname+"'");
       	}
    }
}
srcheads += "]";
String requestjson = weaver.interfaces.workflow.browser.BaseBrowserDataSource.requestToSpitParam1(request);
requestjson = URLEncoder.encode(requestjson);//qc:311744[80][缺陷]数据展现集成-多选选择了主键带双引号的数据，再打开，显示 服务器正在处理，请稍候，加载不出数据
%>

</HEAD>

<BODY>

<div class="zDialog_div_content">
<script language=javascript >
var href="<%=href%>";
var parentWin = parent.parent.getParentWindow(parent);
$(function(){
	try{
		window.parent.setTabObjName("<%=tempname %>");
	}catch(e){
		//alert("ddddddddddddd");
	}
});
</script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowser_wev8.js"></script>
<script type="text/javascript" src="/interface/js/mutilCommonBrowser_wev8.js"></script>
<style>
.e8_box_topmenu{
	vertical-align: middle;
	text-align: left;
	border-bottom: 1px solid #f3f2f2;
	height: 35px;
	line-height:35px;
	white-space: nowrap;
	color: #929393;
	overflow: hidden;
	text-overflow: ellipsis;
}
</style>
	<%--QC295666 [80][90]数据展现集成-解决自定义浏览按钮收藏/帮助两个按钮无效的问题--%>
	<%
		String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());
	%>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MultiCommonBrowser.jsp" method=post onsubmit="return false;">
<input type=hidden id='isreport' name='isreport' value="<%=isreport%>">
<input type="hidden" name="type" value='<%=type%>'>
<input type=hidden id='curpage' name='curpage' value="1">
<input type=hidden id='workflowid' name='workflowid' value="<%=workflowid%>">
<input type=hidden id='currenttime' name='currenttime' value="<%=currenttime%>">
<input type=hidden id='issearch' name='issearch' value="1">
<input type=hidden id='requestjson' name='requestjson' value="<%=requestjson %>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:myfun1Click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
</DIV>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="btnOnSearch()"/>
			
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"></span>
</div>

<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<!-- 搜索-->
<wea:layout type="4col" attributes="{'layoutTableId':'SearchBaseInfo'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20550,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','groupSHBtnDisplay':'none'}">
		<%if(!from.equals("2")){ %>
		<wea:item><%=Util.null2String(browser.getNameHeader())%></wea:item>
		<wea:item attributes="{'colspan':'3'}"><input name='name' value='<%=name%>' class="InputStyle" ></wea:item>
		<%}else{
	if(null!=searchfieldMap)
	{
		Set keyset = searchfieldMap.keySet();
		int allcolumn = keyset.size();
		int i = 0;
           for(Iterator it = keyset.iterator();it.hasNext();)
           {
           	
           	String keyname = (String)it.next();
           	String showname = (String)searchfieldMap.get(keyname);
           	String serchvalue = Util.null2String((String)searchvaluemap.get(keyname));
           	if("".equals(showname))
            	continue;
            i++;
           //	System.out.println(keyname+"   "+showname+"  "+i+"   "+allcolumn);
      %>
          	<wea:item><%=showname%></wea:item>
			<wea:item><input name='<%=keyname %>' value='<%=serchvalue%>' class="InputStyle" ></wea:item>
      <%
      	}
    }
}%>
	</wea:group>

</wea:layout>
</div>

</FORM>
<div id="dialog">
	<div id='colShow' ></div>
</div>


</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="padding:0px!important;">
<div style="padding:5px 0px;">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
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
<SCRIPT LANGUAGE=VBS>
Sub returnData(returnstr)
   window.parent.returnvalue = returnstr
   window.parent.Close
End Sub
</SCRIPT>
<script type="text/javascript">
function myfun1Click() {
	//document.getElementById('myfun1').click()
	//岗位多选 自定义浏览按钮 页面的 右键重新设置不会清空 输入的值 下面改为 2012-08-27 ypc 修改
	//document.getElementById("InputStyle").value="";
	jQuery(".InputStyle").val("");
}
var config = null;
jQuery(document).ready(function(){
	config = showMultiBrowserDialog("<%=beanids%>","<%=srcheads%>",'<%=othercallback%>','<%=isreport%>');
});
function getData(config1,destMap,datas)
{
	if(config1!=null)
	{
	     //returnData(datas);
	     returnData("{'id':'"+datas.id+"','name':'"+datas.name+"'}");
     }
}
function clearData(config1,destMap,datas)
{
	returnData("{'id':'','name':''}");
}
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
var btnok_onclick = function(){

	jQuery("#btnok").click();
}

var btnclear_onclick = function(){
	jQuery("#btnclear").click();
}

function onClose(){
	 if(dialog){
	 
    	dialog.close()
    }else{
	    window.parent.close();
	}
}

function __returnValue(config,ids,names,type,destMap,destMapKeys){//覆盖rightspluingForBrowser_wev8.js的同名方法：用来修改返回值
	

	if(href && href!=''){///interface/js/mutilCommonBrowser_wev8.js中声明的重写后的方法
	 
		mutilreturnValue(config,ids,names,type,destMap,destMapKeys);
	}else{
		
		rightsplugingForBrowser.__returnValue(config,ids,names,type,destMap,destMapKeys);
	}
}
//回车即搜索
$(function(){
	document.onkeydown = function(e){
		var ev = document.all ? window.event : e;
		if(ev.keyCode==13) {
			btnOnSearch();
		}
	}
});  

</SCRIPT>
</BODY>
</HTML>
<%
//添加自定义浏览框使用记录
weaver.interfaces.workflow.browser.BrowserLogService BrowserLogService = new weaver.interfaces.workflow.browser.BrowserLogService();
BrowserLogService.save(type);
%>