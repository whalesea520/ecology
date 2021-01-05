
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<jsp:useBean id="UserDefaultManager"
	class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="MainCategoryComInfo"
	class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo"
	class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo"
	class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="DocSearchManage"
	class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo"
	class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo"
	class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp"%>


<!--声明结束-->

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer"
	src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>

<%
	String loginid = Util.null2String(request.getParameter("loginid"));
	String msg = Util.null2String(request.getParameter("msg"));
	String userId = Util.null2String(request.getParameter("userId"));
	String beginDate = Util.null2String(request.getParameter("beginDate"));
	String endDate = Util.null2String(request.getParameter("endDate"));
	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24530, user.getLanguage());
	String needfav = "1";
	String needhelp = "";
%>
<!--声明开始 此断请不要修改  可以放在此处，也可放在此文件开始处-->


<%@ page import="weaver.common.xtable.*"%>
<%@ include file="/docs/docs/DocCommExt.jsp"%>
<%@ include file="/docs/DocDetailLog.jsp"%>

<%@ include file="/systeminfo/TopTitleExt.jsp"%>


<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />

<%
	String backFields = "id,jidcurrent,sendto,msg,strtime";
	String sqlFrom = "HrmMessagerMsg";
	String sqlWhere = " where (jidcurrent='" + user.getUID()
			+ "' or sendto='" + user.getUID() + "') ";
	
	
	if(!"".equals(msg)){
		sqlWhere+=" and msg like '%"+msg+"%' ";
	}
	
	if(!"".equals(userId)){
		sqlWhere+=" and (jidcurrent='"+userId+"' or sendto='"+userId+"') ";
	}
	
	if(!"".equals(beginDate)){
		sqlWhere+=" and strtime >= '"+beginDate+" 00:00:00' ";
	}
	
	if(!"".equals(endDate)){
		sqlWhere+=" and strtime <= '"+endDate+" 59:59:59' ";
	}
	
	String orderBy = "strtime";
	String primarykey = "id";
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if (pagesize < 2)
		pagesize = 10;

	ArrayList xTableColumnList = new ArrayList();
	


	TableColumn tc2 = new TableColumn();
	tc2.setColumn("jidcurrent");
	tc2.setDataIndex("jidcurrent");
	tc2.setHeader(SystemEnv.getHtmlLabelName(24531, user.getLanguage()));
	tc2.setSortable(true);
	tc2.setTransmethod("weaver.splitepage.transform.SptmForHR.getMessageName2");
	tc2.setPara_1("column:jidcurrent");
	tc2.setPara_2(""+user.getUID());
	
	tc2.setWidth(0.15);
	xTableColumnList.add(tc2);
	
	
	TableColumn tc1 = new TableColumn();
	tc1.setColumn("sendto");	
	tc1.setDataIndex("sendto");
	tc1.setHeader(SystemEnv.getHtmlLabelName(896, user.getLanguage()));
	tc1.setSortable(true);	
	tc1.setTransmethod("weaver.splitepage.transform.SptmForHR.getMessageName2");
	tc1.setPara_1("column:sendto");
	tc1.setPara_2(""+user.getUID());
	
	tc1.setWidth(0.15);
	xTableColumnList.add(tc1);

	TableColumn tc3 = new TableColumn();
	tc3.setColumn("msg");
	tc3.setDataIndex("msg");
	tc3.setHeader(SystemEnv.getHtmlLabelName(345, user.getLanguage()));
	tc3.setSortable(true);
	tc3.setWidth(0.5);
	xTableColumnList.add(tc3);

	TableColumn tc4 = new TableColumn();
	tc4.setColumn("strtime");
	tc4.setDataIndex("strtime");
	tc4.setHeader(SystemEnv.getHtmlLabelName(277, user.getLanguage()));
	tc4.setSortable(true);
	tc4.setWidth(0.4);
	xTableColumnList.add(tc4);

	TableSql xTableSql = new TableSql();
	xTableSql.setBackfields(backFields);
	xTableSql.setPageSize(pagesize);
	xTableSql.setSqlform(sqlFrom);
	xTableSql.setSqlwhere(sqlWhere);
	xTableSql.setSqlgroupby("");
	xTableSql.setSqlprimarykey(primarykey);
	xTableSql.setSqlisdistinct("true");
	xTableSql.setDir(TableConst.DESC);
	//xTableSql.setSqlisprintsql("true");
	xTableSql.setSort(orderBy);
%>



<BODY>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())
			+ ",javascript:onSearch(this),_top} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(18363, user.getLanguage())
			+ ",javascript:_table.firstPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(1258, user.getLanguage())
			+ ",javascript:_table.prePage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(1259, user.getLanguage())
			+ ",javascript:_table.nextPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(18362, user.getLanguage())
			+ ",javascript:_table.lastPage(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script language="javascript">	
	if(userightmenu_self!=1){
		_divSearchDivHeightNo = 61;
		_divSearchDivHeight=125;
	}else{
		_divSearchDivHeightNo = 33;
		_divSearchDivHeight=125;
	}
	_isViewPort=true;
	_pageId="DocView";  
	_divSearchDiv='divContent'; 
	_defaultSearchStatus='show';  //close //show //more
</script>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0"
	valign="top">
	<colgroup>
		<col width="10">
		<col width="">
		<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td></td>
		<TD valign="top">
		<TABLE valign="top" style="width: 100%">
			<TR>
				<TD valign="top">
				<div id="divContent" style="display: none">
				<FORM name="frmSearch" method="post" action="MsgSearch.jsp">
				<TABLE class=ViewForm valign="top">
					<TR valign="top">


						<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></TD>
						<TD CLASS="Field"><input type="text" name="msg" value="<%=msg%>"	class="inputstyle"></TD>

						<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(24533, user.getLanguage())%></TD>
						<TD CLASS="Field">



						<input class='wuiBrowser' _displayText="<%=ResourceComInfo.getLastname(userId)%>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type="hidden" name="userId"	id="userId"  value="<%=userId%>"></TD>
					</TR>
					<TR style="height: 1px">
						<td colspan=4 class="line"></td>
					</TR>
					<TR valign="top">
						<TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(277, user.getLanguage())%></TD>
						<TD WIDTH="20%" CLASS="Field">
							<button class="Calendar" onclick="getDate(spanBeginDate,beginDate);" type="button"></button>
							<span id="spanBeginDate"><%=beginDate%></span> 
							<input name="beginDate" id="beginDate" type="hidden"  value="<%=beginDate%>"> <span>-&nbsp;&nbsp;</span>
							
							<button class="Calendar" onclick="getDate(spanEndDate,endDate);" type="button"></button>
							<span id="spanEndDate"><%=endDate%></span> 
							<input name="endDate" id="endDate" type="hidden"  value="<%=endDate%>"></TD>
						<TD WIDTH="10%"></TD>
						<TD width="20%"></TD>
					</TR>

					<TR>
						<TD valign="top" colspan=6><script type="text/javascript"
							src="/js/WeaverTablePlugins_wev8.js"></script> <%
 	Table xTable = new Table(request);
 	xTable.setTableId("xTable_MsgSearch");
 	xTable.setTableGridType(TableConst.NONE);
 	//xTable.setTableGridType(TableConst.CHECKBOX);
 	xTable.setTableNeedRowNumber(true);
 	xTable.setTableSql(xTableSql);
 	xTable.setTableColumnList(xTableColumnList);
 	xTable.setUser(user);

 	out.println(xTable.toString2("_table"));
 %> <%-- edited by wdl end --%></TD>
					</TR>
				</TABLE>
				</FORM>
				</div>
				</TD>
			</TR>
		</TABLE>
		</TD>
		<td></td>
	</TR>
</TABLE>


</BODY>
</HTML>
<script language="javaScript">
    function onSearch(){
        if(_btnSearchStatusShow)  frmSearch.submit(); 
        else _onShowOrHidenSearch();    
    }

    function doDocDel(docid){
        if (isdel()){
        	var url = "/docs/docs/DocOperate.jsp?operation=delete&docid="+docid;
        	
        	Ext.Ajax.request({
        		url : '/docs/docs/DocDwrProxy.jsp' , 
				params : {},
				url : url ,
				method: 'POST',
				success: function ( result, request) {
					alert(result.responseText.trim());
       				//Ext.Msg.alert('Status', result.responseText.trim());
       				_table.reLoad();
				},
				failure: function ( result, request) { 
					Ext.MessageBox.alert('Failed', 'Successfully posted form: '+result); 
				} 
			});
        }
    }
</script>


<script type="text/javascript" src="/js/doc/DocShareSnip_wev8.js"></script>
<script language="javascript">
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
        //split: true,
        items: [ panelTitle, tab]    
    });      
    Ext.get('loading').fadeOut();    
    _table.load();
});



</script>

<script language="vbscript">

</script>
