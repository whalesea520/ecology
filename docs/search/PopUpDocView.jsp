
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page import="weaver.common.xtable.*" %>		
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
 <%
	 ArrayList xTableColumnList=new ArrayList();
 %>
<!--声明结束-->

<%

DocSearchComInfo.resetSearchInfo();

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(21885,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid=user.getUID()+"" ;
String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();

boolean canSetPopUp = HrmUserVarify.checkUserRight("Docs:SetPopUp", user);
if(!canSetPopUp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}

Date newdate = new Date();
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);


String docsubject = Util.null2String(request.getParameter("docsubject"));
String satrdate = Util.null2String(request.getParameter("startdate"));
String enddate = Util.null2String(request.getParameter("enddate"));
String pop_state = Util.null2String(request.getParameter("pop_state"));

int perpage=15;

String tableString = "";
String orderBy = "doclastmoddate,doclastmodtime";
String backfields =   "t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,ownerid,doccreaterid,t1.usertype,doccreatedate,doclastmoddate,replaydoccount,sumReadCount,docstatus,sumMark";
String  fromSql = "DocDetail  t1, "+tables+"  t2 ";
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage())+" and t1.docextendname = 'html'" ;
whereclause=whereclause+" and t1.docstatus in ('1','2','5') and t1.usertype=1 ";

if(!"".equals(docsubject)){
  whereclause=whereclause+" and t1.docsubject like '%"+docsubject+"%'";
}
if(!"".equals(satrdate)){
   whereclause=whereclause+" and t1.doccreatedate >= '"+satrdate+"'";
}
if(!"".equals(enddate)){
  whereclause=whereclause+" and t1.doccreatedate <= '"+enddate+"'";
}
if(!"".equals(satrdate) && !"".equals(enddate)){
  whereclause=whereclause+" and t1.doccreatedate >= '"+satrdate+"' and t1.doccreatedate <= '"+enddate+"'";
}
if("2".equals(pop_state)){
   whereclause=whereclause+" and t1.id in (select docid from DocPopUpInfo where pop_enddate < '"+CurrentDate+"' )";
}
if("1".equals(pop_state)){
  whereclause=whereclause+" and t1.id in (select docid from DocPopUpInfo where pop_enddate >= '"+CurrentDate+"' )";
}
if("0".equals(pop_state)){
	whereclause=whereclause+" and t1.id not in (select docid from DocPopUpInfo)";
}

String sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);

TableColumn xTableColumn_DocName=new TableColumn();
xTableColumn_DocName.setColumn("docsubject");
xTableColumn_DocName.setDataIndex("docsubject");
xTableColumn_DocName.setHeader(SystemEnv.getHtmlLabelName(58,user.getLanguage()));
xTableColumn_DocName.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocName");
xTableColumn_DocName.setPara_1("column:id");
xTableColumn_DocName.setTarget("_fullwindow");
xTableColumn_DocName.setHref("/docs/docs/DocDsp.jsp");
xTableColumn_DocName.setLinkkey("id");
xTableColumn_DocName.setSortable(true);
xTableColumn_DocName.setWidth(0.4); 
xTableColumnList.add(xTableColumn_DocName);

TableColumn xTableColumn_Owner=new TableColumn();
xTableColumn_Owner.setColumn("ownerid");
xTableColumn_Owner.setDataIndex("ownerid");
xTableColumn_Owner.setHeader(SystemEnv.getHtmlLabelName(79,user.getLanguage()));
xTableColumn_Owner.setTransmethod("weaver.splitepage.transform.SptmForDoc.getName");
xTableColumn_Owner.setPara_1("column:ownerid");
xTableColumn_Owner.setPara_2("column:usertype");
xTableColumn_Owner.setSortable(true);
xTableColumn_Owner.setWidth(0.1); 
xTableColumnList.add(xTableColumn_Owner);

TableColumn xTableColumn_Createdate=new TableColumn();
xTableColumn_Createdate.setColumn("doccreatedate");
xTableColumn_Createdate.setDataIndex("doccreatedate");
xTableColumn_Createdate.setHeader(SystemEnv.getHtmlLabelName(722,user.getLanguage()));
xTableColumn_Createdate.setSortable(true);
xTableColumn_Createdate.setWidth(0.08); 
xTableColumnList.add(xTableColumn_Createdate);

TableColumn xTableColumn_Moddate=new TableColumn();
xTableColumn_Moddate.setColumn("doclastmoddate");
xTableColumn_Moddate.setDataIndex("doclastmoddate");
xTableColumn_Moddate.setHeader(SystemEnv.getHtmlLabelName(723,user.getLanguage()));
xTableColumn_Moddate.setSortable(true);
xTableColumn_Moddate.setWidth(0.08); 
xTableColumnList.add(xTableColumn_Moddate);

TableColumn xTableColumn_Replaydoccount=new TableColumn();
xTableColumn_Replaydoccount.setColumn("replaydoccount");
xTableColumn_Replaydoccount.setDataIndex("replaydoccount");
xTableColumn_Replaydoccount.setTransmethod("weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount");
xTableColumn_Replaydoccount.setPara_1("column:id");
xTableColumn_Replaydoccount.setPara_2("column:replaydoccount");
xTableColumn_Replaydoccount.setHeader(SystemEnv.getHtmlLabelName(18470,user.getLanguage()));
xTableColumn_Replaydoccount.setWidth(0.07); 
xTableColumnList.add(xTableColumn_Replaydoccount);

TableColumn xTableColumn_ReadCount=new TableColumn();
xTableColumn_ReadCount.setColumn("sumReadCount");
xTableColumn_ReadCount.setDataIndex("sumReadCount");
xTableColumn_ReadCount.setHeader(SystemEnv.getHtmlLabelName(18469,user.getLanguage()));
xTableColumn_ReadCount.setWidth(0.07); 
xTableColumn_ReadCount.setSortable(true);
xTableColumnList.add(xTableColumn_ReadCount);

TableColumn xTableColumn_DocStatus=new TableColumn();
xTableColumn_DocStatus.setColumn("docstatus");
xTableColumn_DocStatus.setDataIndex("docstatus");
xTableColumn_DocStatus.setHeader(SystemEnv.getHtmlLabelName(602,user.getLanguage()));	 
//xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus2");
xTableColumn_DocStatus.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocStatus3");
xTableColumn_DocStatus.setPara_1("column:id");
//xTableColumn_DocStatus.setPara_2(""+user.getLanguage());
xTableColumn_DocStatus.setPara_2(""+user.getLanguage()+"+column:docstatus+column:seccategory");
xTableColumn_DocStatus.setWidth(0.05); 
xTableColumn_DocStatus.setSortable(true);
xTableColumnList.add(xTableColumn_DocStatus);

TableColumn xTableColumn_popups=new TableColumn();
xTableColumn_popups.setColumn("popup_status");
xTableColumn_popups.setDataIndex("popup_status");
xTableColumn_popups.setHeader(SystemEnv.getHtmlLabelName(21886,user.getLanguage()));
xTableColumn_popups.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocPouUpStatus");
xTableColumn_popups.setPara_1("column:id");
xTableColumn_popups.setPara_2(""+user.getLanguage());
xTableColumn_popups.setSortable(false);
xTableColumn_popups.setWidth(0.08); 
xTableColumnList.add(xTableColumn_popups);

TableColumn xTableColumn_operate=new TableColumn();
xTableColumn_operate.setColumn("popup_operate");
xTableColumn_operate.setDataIndex("popup_operate");
xTableColumn_operate.setHeader(SystemEnv.getHtmlLabelName(104,user.getLanguage()));
xTableColumn_operate.setTransmethod("weaver.splitepage.transform.SptmForDoc.getDocPouUpOperate");
xTableColumn_operate.setPara_1("column:id");
xTableColumn_operate.setPara_2(""+user.getLanguage());
xTableColumn_operate.setSortable(false);
xTableColumn_operate.setWidth(0.1); 
xTableColumnList.add(xTableColumn_operate);


TableSql xTableSql=new TableSql();
xTableSql.setBackfields(backfields);
xTableSql.setPageSize(perpage);
xTableSql.setSqlform(fromSql);
xTableSql.setSqlwhere(sqlWhere);
xTableSql.setSqlprimarykey("id");
xTableSql.setSqlisdistinct("true");
xTableSql.setDir(TableConst.DESC);

Table xTable=new Table(request); 
xTable.setTableId("xTable_PopUpDocView");//必填而且与别的地方的Table不能一样，建议用当前页面的名字
xTable.setTableGridType(TableConst.NONE);
xTable.setTableNeedRowNumber(true);												
xTable.setTableSql(xTableSql);
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
<link rel="stylesheet" type="text/css" href="/css/weaver-ext-grid_wev8.css" />
<script  language="javascript">	
	_pageId="PopUpDocView";  
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
<FORM id=weaver name=weaver action="PopUpDocView.jsp" method=post>
<TABLE width=100%  border="0" cellspacing="0" cellpadding="0">
 <tr>
	 <td valign="top">
	  <table class=ViewForm >
	      <tr style="height: 1px!important;"><td class=Line colSpan=6></td></tr>
		  <tr>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(19541,user.getLanguage())%></td>
		   <td CLASS="Field" width=22%>
		     <input class=InputStyle  type="text" name="docsubject" value="<%=docsubject%>">
		   </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></td>
		   <td CLASS="Field" width=22%>
		     <BUTTON class=Calendar type="button" onclick="getDate(startdatespan,startdate)"></BUTTON> 
			 <SPAN id=startdatespan ><%=satrdate %></SPAN>&nbsp;- &nbsp;
			 <BUTTON class=Calendar type="button" onclick="getDate(enddatespan,enddate)"></BUTTON> 
			 <SPAN id=enddatespan ><%=enddate %></SPAN>
			 <input class=InputStyle  type="hidden" name="startdate" value="<%=satrdate%>">
			 <input class=InputStyle  type="hidden" name="enddate" value="<%=enddate%>">
		   </td>
		   <td width=10%><%=SystemEnv.getHtmlLabelName(21887,user.getLanguage())%></td>
		   <td CLASS="Field" width=21%>
		     <select name="pop_state">
		        <option value=""></option>
			    <option value="0" <%if("0".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21888,user.getLanguage())%></option>
			    <option value="1" <%if("1".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21889,user.getLanguage())%></option>
			    <option value="2" <%if("2".equals(pop_state)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21917,user.getLanguage())%></option>
			 </select>
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
<script type='text/javascript'>
   function showDetailInfo(id){
   	jQuery("iframe[name='docpopward']").remove();
   	var forwardurl = "/docs/search/PopUpDocSet.jsp?docsid="+id;
	 	var windforward = new Ext.Window({
	        layout: 'fit',
	        width: 400,
	        resizable: true,
	        height: 400,
	        closeAction: 'hide',
	        modal: true,
	        title: wmsg.doc.popupset,
     	    html:'<iframe id="docpopward" name= "docpopward" BORDER=0 FRAMEBORDER=no height="100%" width="100%" scrolling="auto" src="'+forwardurl+'"></iframe>',
	        autoScroll: true,
	        buttons: [{
			            text: wmsg.wf.submit,// '提交',
			            handler: function(){
			                 window.frames['docpopward'].doSave(windforward);		                 
			            }
	        		},{
			            text: wmsg.wf.close,// '关闭',
			            handler: function(){
			                 windforward.hide();
			            }
        			}]
	    });
	    windforward.show(""); 	
   }
   
   function onSearch(obj){
     	if(_btnSearchStatusShow)   weaver.submit(); 
        else _onShowOrHidenSearch();  
   }
</script>  
<script type="text/javascript" src="/js/WeaverTableExt_wev8.js"></script>  
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
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


