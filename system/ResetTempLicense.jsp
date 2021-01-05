
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ page import="java.util.*,weaver.general.Util" %>

<%@ page import="weaver.common.xtable.*" %>		
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
<%
ArrayList xTableColumnList=new ArrayList();

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = "临时LICENSE申请清零";
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"" ;

String companyname = Util.null2String(request.getParameter("companyname"));
String times = Util.null2String(request.getParameter("times"));
String useridtemp = Util.null2String(request.getParameter("useridtemp"));
String licids = Util.null2String(request.getParameter("licids"));

boolean canSetLicense = HrmUserVarify.checkUserRight("TempLinces:RESET", user);
if(!canSetLicense){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}

int perpage=10;

if(!"".equals(licids)) {
	String licidstemp = licids.substring(0,licids.length()-1);
	RecordSet.executeSql("delete from templicense where id in ("+licidstemp+")");
}

String tableString = "";
String orderBy = "id";
String backfields = "*";
String fromSql = "templicense";
String sqlWhere = " 1=1 " ;

if (!"".equals(companyname)) {
	sqlWhere += " and companyname like '%"+companyname+"%'";
}
if(!"".equals(times)) {
	sqlWhere += " and times like '%"+times+"%'";
}
if(!"".equals(useridtemp)){
	sqlWhere += " and userid = "+useridtemp;
}

TableColumn xTableColumn_CompanyName=new TableColumn();
xTableColumn_CompanyName.setColumn("companyname");
xTableColumn_CompanyName.setDataIndex("companyname");
xTableColumn_CompanyName.setHeader(SystemEnv.getHtmlLabelName(1976,user.getLanguage()));
xTableColumn_CompanyName.setSortable(true);
xTableColumn_CompanyName.setWidth(0.6); 
xTableColumnList.add(xTableColumn_CompanyName);

TableColumn xTableColumn_Times=new TableColumn();
xTableColumn_Times.setColumn("times");
xTableColumn_Times.setDataIndex("times");
xTableColumn_Times.setHeader("申请次数");
xTableColumn_Times.setSortable(true);
xTableColumn_Times.setWidth(0.3); 
xTableColumnList.add(xTableColumn_Times);

TableColumn xTableColumn_UseridName=new TableColumn();
xTableColumn_UseridName.setColumn("userid");
xTableColumn_UseridName.setDataIndex("userid");
xTableColumn_UseridName.setHeader(SystemEnv.getHtmlLabelName(368,user.getLanguage()));
xTableColumn_UseridName.setTransmethod("weaver.hrm.resource.ResourceComInfo.getResourcename");
xTableColumn_UseridName.setPara_1("column:userid");
xTableColumn_UseridName.setSortable(true);
xTableColumn_UseridName.setWidth(0.5); 
xTableColumnList.add(xTableColumn_UseridName);

TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(perpage);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlprimarykey("id");
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);

Table xTable=new Table(request); 
xTable.setTableId("xTable_LicenseView");//必填而且与别的地方的Table不能一样，建议用当前页面的名字
xTable.setTableGridType(TableConst.NONE);
xTable.setTableNeedRowNumber(true);												
xTable.setTableSql(xTableSql);
xTable.setTableGridType(TableConst.CHECKBOX);
xTable.setTableColumnList(xTableColumnList);
%>
<BODY>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%@ include file="/systeminfo/TopTitleExt.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
String topButton = "";
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
%>
<%
if(userightmenu_self==1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{清零,javascript:onsub(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	topButton +="{iconCls:'btn_search',text:'"+SystemEnv.getHtmlLabelName(197, user.getLanguage())+"',handler:function(){onSearch();}},";
	topButton +="'-',";
}
if(isSysadmin==1){
	topButton +="{iconCls:'btn_viewUrl',text:'"+SystemEnv.getHtmlLabelName(21682, user.getLanguage())+"',handler:function(){viewSourceUrl()}},";
	topButton +="'-',";
}
if(topButton.length()>5){
	topButton = topButton.substring(0,topButton.length()-5);
}
topButton = "["+topButton+"]";
%>
<script  language="javascript">	
	_pageId="LicenseView";  
	_divSearchDiv='divSearch'; 
	_defaultSearchStatus='show';  //close //show //more
    userightmenu_self = '<%=userightmenu_self%>';
	if(userightmenu_self!=1){
		_divSearchDivHeightNo = 61;
		_divSearchDivHeight=100;
		<%if(userightmenu_self!=1){%>
		eval(rightMenuBarItem = <%=topButton%>);
		<%}%>
	}else{
		_divSearchDivHeightNo = 33;
		_divSearchDivHeight=100;
	}
</script>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<br>
<div id="divSearch" style="display:none">
<FORM id=weaver name=weaver action="ResetTempLicense.jsp" method=post>
<input type=hidden name="licids">
<TABLE width=100%  border="0" cellspacing="0" cellpadding="0">
 <tr>
	 <td valign="top">
	  <table class=ViewForm >
	      <tr><td class=Line colSpan=6></td></tr>
		  <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></td>
		   <td CLASS="Field" width=22%>
		     <input class=InputStyle  type="text" name="companyname" value="<%=companyname%>">
		   </td>
		   <td width=10%>申请次数</td>
		   <td CLASS="Field" width=22%>
		     <input class=InputStyle  type="text" name="times" value="<%=times%>">
		   </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(368,user.getLanguage())%></td>
		   <td CLASS="Field" width=21%>
		     <BUTTON class=Browser id=SelectResourceID onClick="onShowHrmResource()"></BUTTON>
		      <span id=resourcespan><%=ResourceComInfo.getResourcename(useridtemp)%></span>
		      <input type=hidden name="useridtemp" value="<%=useridtemp%>">
		   </td>
		  </tr>		  
	</table>
   </td>
  </tr>
</TABLE>
</FORM>
</div>
<%out.println(xTable.toString2("_table"));%>
</BODY>
<script type='text/javascript' src='/js/WeaverTablePlugins_wev8.js'></script>
<script type='text/javascript'>
   function onSearch(obj){
     	if(_btnSearchStatusShow)   weaver.submit(); 
        else _onShowOrHidenSearch();  
   }
   function onsub(){
      var licids = _table._xtable_CheckedCheckboxId();
      
      if (licids != null && licids != "") {    
        document.weaver.licids.value=licids;
        weaver.submit();
      }
   }

</script>  
<script  language="javascript">
var viewport
Ext.onReady(function(){
	var tab=new Ext.Panel({		
		activeTab: 0,	
		margins: '5 8 5 5',
		region: 'center',
        resizeTabs: true,
        tabWidth: 150,
        minTabWidth: 120,
        layout:'fit',
        border:false,
        enableTabScroll: true,
        plugins: new Ext.ux.TabCloseMenu(),       
        items: [_table.getGrid()]
	});
	viewport = new Ext.Viewport({
        layout: 'border',
        items: [ panelTitle, tab]    
    });   
    Ext.get('loading').fadeOut();    
    _table.load();
});
</script>
<script language=vbs>
sub onShowHrmResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourcespan.innerHtml = id(1)
	document.getElementById("userid").value=id(0)
	else
	resourcespan.innerHtml = ""
	document.getElementById("useridtemp").value=id(0)
	end if
	end if
end sub
</script>


