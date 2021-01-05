<%@page import="java.net.URLEncoder"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.interfaces.workflow.browser.BrowserBean" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.formmode.browser.FormModeBrowserSqlwhere"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.formmode.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<HTML><HEAD> 
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String isreport = Util.getIntValue(request.getParameter("isreport"),0)+"";

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
String userid = user.getUID()+"";
Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String outpage = Util.null2String(browser.getOutPageURL());
String href = Util.null2String(browser.getHref());
href = Util.null2String(browser.getHref(""+userid,href));
String from = Util.null2String(browser.getFrom());
String showtree = Util.null2String(browser.getShowtree());
if("1".equals(showtree) && !from.equals("1"))
	outpage = "/interface/CommonTreeCenterBrowser.jsp?ismutil=1&othercallback="+othercallback+"&isreport="+isreport;

//if(from.equals("2")){
	browser.initBaseBrowser("",type,from);
//}

Map searchfieldMap = browser.getSearchfieldMap();
Map searchvaluemap = new HashMap();
if(null!=searchfieldMap)
{
	Set keyset = searchfieldMap.keySet();
    for(Iterator it = keyset.iterator();it.hasNext();)
    {
    	String keyname = (String)it.next();
    	String keyvalue = Util.null2String(request.getParameter(keyname));
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
    	//System.out.println("111 keyname : "+keyname+" keyvalue : "+keyvalue);
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
		//System.out.println(fieldid+"	"+fieldvalue);
		if(fieldid.split("_").length==2){
			fieldid = fieldid.split("_")[0];
		}
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
session.setAttribute("isreport_"+workflowid+"_"+currenttime,isreport);
String tempname = browser.getName();
if("".equals(tempname))
	tempname = SystemEnv.getHtmlLabelName(83325, user.getLanguage());//自定义浏览框
String Search = browser.getSearch(userid);//.toLowerCase();//
String SearchByName = browser.getSearchByName();//.toLowerCase();// 

for(int i=0;i<allFieldList.size();i++){
	String fieldname = Util.null2String((String)allFieldList.get(i));
	if(!fieldname.equals("")){
		String fieldid = Util.null2String((String)allField.get(fieldname));
		String fieldvalue = Util.null2String((String)valueMap.get(fieldid));
		//System.out.println("hahha:=====		"+fieldname +"	@	"+fieldid+"	@	"+fieldvalue);
		//add by liaodong for qc43173 in 20130911 start
		if("".equals(fieldvalue)){
		  fieldvalue = "''";
		}//end
		//Search = Search.replace(fieldname,fieldvalue);
		//SearchByName = SearchByName.replace(fieldname,fieldvalue);
		Search = Util.replaceString2(Search, fieldname.replace("$","\\$"), fieldvalue.replace("$","\\$").replace("\\","\\\\"));
		SearchByName = Util.replaceString2(SearchByName, fieldname.replace("$","\\$"), fieldvalue.replace("$","\\$").replace("\\","\\\\"));
		//System.out.println("Search=="+Search);
		//System.out.println("SearchByName=="+SearchByName);
	}
}
if(!outpage.equals("")){
	if(from.equals("1")){//表单建模生成的自定义浏览按钮，多选页面替换成单选页面
		String modesingle = "/formmode/browser/CommonSingleBrowser.jsp";
		String modemulti = "/formmode/browser/CommonMultiBrowser.jsp";
		outpage = outpage.replace(modemulti, modesingle);
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
				Map<String,String> map = expendMap.get("sqlcondition");
				Iterator<String> it = map.keySet().iterator();
				while(it.hasNext()){
					String key = it.next();
					sqlconditionTemp += key+"="+Util.null2String(request.getParameter(key))+" and ";
				}
			}
			if(expendMap.containsKey("sqlwhere")){
				Map<String,String> map = expendMap.get("sqlwhere");
				sqlwhereTemp =FormModeBrowserSqlwhere.decode(map.get("sql"));
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
		outpage += "&browsertype="+URLEncoder.encode(type)+"&sqlwhere="+sqlwhere+"&workflowid="+workflowid+"&currenttime="+currenttime+"&sqlcondition="+sqlcondition;
	}else{
		outpage += "?browsertype="+URLEncoder.encode(type)+"&sqlwhere="+sqlwhere+"&workflowid="+workflowid+"&currenttime="+currenttime+"&sqlcondition="+sqlcondition;
	}
	System.out.println("******"+outpage);
	response.sendRedirect(outpage);
	return;
}

%>
<BODY>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%--QC295666 [80][90]数据展现集成-解决自定义浏览按钮收藏/帮助两个按钮无效的问题--%>
<%
    String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());
 %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;


RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CommonBrowser.jsp" method=post>
<input type=hidden id='isreport' name='isreport' value="<%=isreport%>">
<input type=hidden id='type' name='type' value="<%=type%>">
<input type=hidden id='workflowid' name='workflowid' value="<%=workflowid%>">
<input type=hidden id='currenttime' name='currenttime' value="<%=currenttime%>">
<input type=hidden id='issearch' name='issearch' value="1">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="onSubmit()"/>
			
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
<%
	Map showfieldMap = browser.getShowfieldMap();
	int fieldsize = 2;
	if("2".equals(from))
	{
		if(null!=browser.getShowfieldMap())
		{
			fieldsize = browser.getShowfieldMap().size();
		}
	}
	String PageConstId = PageIdConst.CommonBrowser+"_"+type;
	String tableString="";
	if(fieldsize>0)
	{
		String requestjson = weaver.interfaces.workflow.browser.BaseBrowserDataSource.requestToSpitParam1(request);
		
		
		int colwidth = 100/(fieldsize);
		if(!from.equals("2")){
			tableString=""+
			"<table instanceid=\"BrowseTable\" pageId=\"\" pagesize=\"10\"  datasource=\"weaver.interfaces.workflow.browser.BaseBrowserDataSource.getDataResourceList3\" sourceparams=\""+Util.toHtmlForSplitPage(requestjson)+"\" tabletype=\"none\" pageBySelf=\"true\">"+
				"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
				"<head>";
					tableString+=	 "<col width=\"0%\" hide=\"true\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"ids\" orderkey=\"ids\"/>";
					tableString+=	 "<col width=\""+colwidth+"%\"  text=\""+Util.null2String(browser.getNameHeader())+"\" column=\"names\" orderkey=\"names\"/>";
					tableString += "<col width=\""+colwidth+"%\"  text=\""+Util.null2String(browser.getDescriptionHeader())+"\" column=\"descs\" orderkey=\"descs\"/>"+
				"</head>"+
			"</table>";
		}
		else
		{
			Set keyset = showfieldMap.keySet();
			tableString = "<table instanceid=\"BrowseTable\" pageId=\"\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\"  datasource=\"weaver.interfaces.workflow.browser.BaseBrowserDataSource.getDataResourceList3\" sourceparams=\""+Util.toHtmlForSplitPage(requestjson)+"\" tabletype=\"none\" pageBySelf=\"true\">"+
							"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
							"<head>";
			tableString+=	"<col width=\"0%\" hide=\"true\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"ids\" orderkey=\"ids\"/>";
	        for(Iterator it = keyset.iterator();it.hasNext();)
	        {
	        	String keyname = (String)it.next();
	        	String showname = Util.null2String((String)showfieldMap.get(keyname));
	        	//System.out.println("keyname : "+keyname+" showname : "+showname);
	        	
	        	if("".equals(showname))
	        		continue;
	        	tableString += "<col width=\""+colwidth+"%\"  text=\""+Util.null2String(showname)+"\" column=\""+keyname+"s\" orderkey=\""+keyname+"s\"/>";
	    	}
	        tableString += "</head>"+
						   "</table>";
		}
		//System.out.println("tableString : "+tableString+" from : "+from);
	}
%>
		<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20550,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none','groupSHBtnDisplay':'none'}">
		<%if(!from.equals("2")){ %>
		<wea:item><%=Util.null2String(browser.getNameHeader())%></wea:item>
		<wea:item attributes="{'colspan':'3'}"><input name='name' value='<%=name%>' class="InputStyle" onchange="changeCurpage(1)" onkeydown="enterSearch()"></wea:item>
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
	            	//System.out.println(keyname+"   "+showname+"  "+i+"   "+allcolumn);
          %>
            	<wea:item><%=showname%></wea:item>
				<wea:item><input name='<%=keyname %>' value='<%=serchvalue%>' class="InputStyle" onchange="changeCurpage(1)" onkeydown="enterSearch()"></wea:item>
        <%
        		}
        	}
		%>
		<%} %>
		</wea:group>
	</wea:layout>

<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 

</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick='onClear();'></input>
	        		<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick='onClose();'></input>
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
</BODY></HTML>


<script type="text/javascript">
//<!--


//-->
</script>
<!-- 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array(0,"")
     window.parent.close
End Sub
Sub BrowseTable_onclick()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then   	
     window.parent.returnvalue = Array(e.parentelement.cells(0).innerText,e.parentelement.cells(1).innerText,e.parentelement.cells(2).innerText)
    //  window.parent.returnvalue = e.parentelement.cells(0).innerText
      window.parent.Close
   ElseIf e.TagName = "A" Then
      window.parent.returnvalue = Array(e.parentelement.parentelement.cells(0).innerText,e.parentelement.parentelement.cells(1).innerText,e.parentelement.parentelement.cells(2).innerText)
     // window.parent.returnvalue = e.parentelement.parentelement.cells(0).innerText
      window.parent.Close
   End If

End Sub
Sub BrowseTable_onmouseover()
   Set e = window.event.srcElement
   If e.TagName = "TD" Then
      e.parentelement.className = "Selected"
   ElseIf e.TagName = "A" Then
      e.parentelement.parentelement.className = "Selected"
   End If
End Sub
Sub BrowseTable_onmouseout()
   Set e = window.event.srcElement
   If e.TagName = "TD" Or e.TagName = "A" Then
      If e.TagName = "TD" Then
         Set p = e.parentelement
      Else
         Set p = e.parentelement.parentelement
      End If
      If p.RowIndex Mod 2 Then
         p.className = "DataLight"
      Else
         p.className = "DataDark"
      End If
   End If
End Sub

</SCRIPT>

 -->
<SCRIPT LANGUAGE=VBS>
Sub returnData(returnstr)
   window.parent.returnvalue = returnstr
   window.parent.Close
End Sub
</SCRIPT>
<script language="javascript">
$(function(){
	try{
		window.parent.setTabObjName("<%=tempname %>");
	}catch(e){
		//alert("ddddddddddddd");
	}
});
var parentWin = window.parent.parent.getParentWindow(parent);
var dialog = window.parent.parent.getDialog(parent);
function onClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
			 try{
			     dialog.callback(returnjson);
			 }catch(e){}
			 
			 try{
			     dialog.close(returnjson);
			 }catch(e){}
		    
	}else{
		<%if(!"1".equals(othercallback)){%>
    		window.parent.returnValue=returnjson;
			window.parent.close();
    	<%}else{%>
    		returnData("{'id':'','name':''}")
    	<%}%>
	}
}
function onSubmit()
{
	SearchForm.submit();
}
function onPage(index)
{
	changeCurpage(index);//TD34490 lv 修改当前页
	SearchForm.submit();
}
function onClose()
{
	if(dialog){
	    dialog.close();
	}else{  
	    window.parent.close();
	}
}
//TD196207 回车即搜索
function enterSearch(){
var event = arguments.callee.caller.arguments[0] || window.event;
if(event.keyCode == 13){
SearchForm.submit();
}
}

//TD34490 lv 修改当前页
function changeCurpage(index){
	//document.SearchForm.curpage.value = index;
}

function afterDoWhenLoaded(){

	$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing'][class!='e8EmptyTR']").each(function(){
		var tr = jQuery(this);
		tr.bind("click",function(){
			var td1 = tr.children("td:first").next();
			var id = td1.attr("spacevalue")||td1.attr("title");//spacevalue是chrome的，title是IE的
			var name = tr.children("td:first").next().next().text();
			
			var desc = "";
			try
			{
				desc = tr.children("td:first").next().next().next().text();
			}
			catch(e)
			{
			}
			
			
			var returnjson = {'id':id,'name':name,'desc':desc,'href':'<%=href%>'};
			if(dialog){
				try{
			    	dialog.callback(returnjson);
			    }catch(e){}

				try{
				    dialog.close(returnjson);
				}catch(e){}
			}else{
		    	<%if(!"1".equals(othercallback)){%>
		    		window.parent.returnValue = returnjson;
		    		window.parent.close();
		    	<%}else{%>
		    	returnData("{'id':'"+id+"','name':'"+name+"','desc':'"+desc+"','href':'<%=href%>'}")
		    	<%}%>
		 	}
		});
	});
}

</script>
<%
//添加自定义浏览框使用记录
weaver.interfaces.workflow.browser.BrowserLogService BrowserLogService = new weaver.interfaces.workflow.browser.BrowserLogService();
BrowserLogService.save(type);
%>