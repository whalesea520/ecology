
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.*,weaver.interfaces.datasource.*" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.interfaces.workflow.browser.*" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD> 
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String showtypeid = Util.null2String(request.getParameter("showtypeid"));
String issearch = Util.null2String(request.getParameter("issearch"));


String userid = user.getUID()+"";
BaseBrowser browser=new BaseBrowser();
browser.initBaseBrowser(showtypeid,"2","2");
String titleshowname = browser.getShowname();
String outpage = Util.null2String(browser.getOutPageURL());
String href = Util.null2String(browser.getHref());
href = Util.null2String(browser.getHref(""+user.getUID(),href));
String from = Util.null2String(browser.getFrom());
String showtree = Util.null2String(browser.getShowtree());
if(!outpage.equals("")){
	if(outpage.indexOf("?")>=0){
		outpage += "&showtypeid="+showtypeid;
	}else{
		outpage += "?showtypeid="+showtypeid;
	}
	response.sendRedirect(outpage);
	return;
}
String datasourceid = browser.getDatasourceid();
if(!"".equals(datasourceid))
{
	DataSource datasource = (DataSource) StaticObj.getServiceByFullname(datasourceid, DataSource.class);
	browser.setDs(datasource);
}
Map searchfieldMap = browser.getSearchfieldMap();
Map searchvaluemap = new HashMap();
String namesimple = "";
if(null!=searchfieldMap)
{
	Set keyset = searchfieldMap.keySet();
	int allcolumn = keyset.size();
	int i = 0;
    for(Iterator it = keyset.iterator();it.hasNext();)
    {
    	String keyname = (String)it.next();
    	String showname = (String)searchfieldMap.get(keyname);
        if("".equals(showname))
       		continue;
    	String keyvalue = Util.null2String(request.getParameter(keyname));
    	namesimple = Util.null2String(request.getParameter("simple_"+keyname));
    	//System.out.println("namesimple : "+namesimple+" keyname : "+keyname+" keyvalue : "+keyvalue);
    	if(!"".equals(namesimple))
    		searchvaluemap.put(keyname,namesimple);
    	else if(!"".equals(keyvalue))
    		searchvaluemap.put(keyname,keyvalue);
        
    }
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String outfieldname = "";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<%
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
			            	outfieldname = keyname;
		            	
					%>
						<input type="text" class="searchInput" name="simple_<%=keyname %>" value="<%=serchvalue%>"/>
						&nbsp;&nbsp;&nbsp;
					<%
							break;
						}
					}
					%>	
					<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;<!-- 高级搜索 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<FORM NAME=SearchForm action="integrationCommonSearch.jsp" method=post>
<input type=hidden id='showtypeid' name='showtypeid' value="<%=showtypeid%>">
<input type=hidden id='issearch' name='issearch' value="1">

		
		<div id="tabDiv" >
		   <span style="font-size:14px;font-weight:bold;"><%=browser.getShowname() %>&nbsp;</span> 
		</div>
		
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
			<wea:layout type="4col">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<%
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
							<wea:item><input id='<%=keyname %>' name='<%=keyname %>' style='width:280px;' value='<%=serchvalue%>' class="InputStyle"></wea:item>
			        <%
			        		}
			        	}
					%>
					
					</wea:group>
					<wea:group context="" attributes="{'groupDisplay':'none'}">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197 ,user.getLanguage()) %>" class="zd_btn_submit" onclick="onSubmit();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201 ,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
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
			String PageConstId = "CommonSearch20141217gxh_"+showtypeid;
			String tableString="";
			if(fieldsize>0)
			{
				String requestjson = weaver.interfaces.workflow.browser.BaseBrowserDataSource.requestToSpitParam(request);
				new BaseBean().writeLog("requestjson : "+requestjson);
				int colwidth = 100/(fieldsize);
				if(!from.equals("2")){
					tableString=""+
					"<table instanceid=\"BrowseTable\" pageId=\"\" pagesize=\""+PageIdConst.getPageSize(PageConstId,user.getUID(),PageIdConst.Browser)+"\"  datasource=\"weaver.interfaces.workflow.browser.BaseBrowserDataSource.getDataResourceListForSearch\" sourceparams=\""+Util.toHtmlForSplitPage(requestjson)+"\" tabletype=\"none\" pageBySelf=\"true\">"+
						"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
						"<head>";
							tableString+=	 "<col width=\"0%\" hide=\"true\" text=\"idskey_forused\" column=\"ids\" orderkey=\"ids\"/>";
							tableString+=	 "<col width=\""+colwidth+"%\"  text=\""+Util.null2String(browser.getNameHeader())+"\" column=\"names\" orderkey=\"names\"/>";
							tableString += "<col width=\""+colwidth+"%\"  text=\""+Util.null2String(browser.getDescriptionHeader())+"\" column=\"descs\" orderkey=\"descs\"/>"+
						"</head>"+
					"</table>";
				}
				else
				{
					Set keyset = showfieldMap.keySet();
					tableString = "<table instanceid=\"BrowseTable\" pageId=\"\" pagesize=\""+PageIdConst.getPageSize(PageConstId ,user.getUID(),PageIdConst.Browser)+"\"  datasource=\"weaver.interfaces.workflow.browser.BaseBrowserDataSource.getDataResourceListForSearch\" sourceparams=\""+Util.toHtmlForSplitPage(requestjson)+"\" tabletype=\"none\" pageBySelf=\"true\">"+
									"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  />"+
									"<head>";
					tableString+=	"<col width=\"0%\" hide=\"true\" text=\"idskey_forused\" column=\"ids\" orderkey=\"ids\"/>";
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
		<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%=PageConstId %>"/>
		<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run" showExpExcel="true"/> 
		
</FORM>

</BODY></HTML>


<script type="text/javascript">
//<!--
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onSubmit2});
});
//-->
</script>
<script language="javascript">
function onSubmit2(value)
{
	//alert("ddddddddddddddddddd");
	//alert("dfdf : "+SearchForm.simple_lastname.value);
	jQuery("#<%=outfieldname%>").val(value);
	onSubmit();
}
function onSubmit()
{
	//alert("dfdf : "+SearchForm.simple_lastname.value);
	
	SearchForm.submit();
}
</script>
