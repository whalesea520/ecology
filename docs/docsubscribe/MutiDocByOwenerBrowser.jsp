
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.docSubscribe.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.docs.category.CategoryUtil" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiDocByOwnerBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("30041",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>

<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
Enumeration em = request.getParameterNames();
boolean isinit = true;
while(em.hasMoreElements())
{
	String paramName = (String)em.nextElement();
	if(!paramName.equals("")&&!paramName.equals("splitflag"))
		isinit = false;
	break;
}
int date2during= Util.getIntValue(request.getParameter("date2during"),0) ;
int olddate2during = 0;
BaseBean baseBean = new BaseBean();
String date2durings = "";
try
{
	date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
}
catch(Exception e)
{}
String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
if(date2duringTokens.length>0)
{
	olddate2during = Util.getIntValue(date2duringTokens[0],0);
}
if(olddate2during<0||olddate2during>36)
{
	olddate2during = 0;
}
if(isinit)
{
	date2during = olddate2during;
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String subscribePara = Util.null2String(request.getParameter("subscribePara"));
String[] tempStr = Util.TokenizerString2(subscribePara,"_");
String subscribeHrmId = tempStr[0];
String ownerType = tempStr[1];
String subscribeDocId = tempStr[2];

String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere = "" ;
String secCategory = Util.null2String(request.getParameter("secCategory"));
String path= Util.null2String(request.getParameter("path"));
if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));
if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}
else {
		sqlwhere = " where  (t1.docstatus !='3' and t1.ownerid ="+user.getUID()+" ) ";
}

String check_per = Util.null2String(request.getParameter("documentids"));
String documentids = "" ;
String documentnames ="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	documentids=","+check_per;
	String[] tempArray = Util.TokenizerString2(documentids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		documentnames += ","+DocComInfo.getDocname(tempArray[i]);
	}
}

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;

    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!searchsubject.equals("")) DocSearchComInfo.setDocsubject(searchsubject) ;    
    if(!searchdatefrom.equals("")) DocSearchComInfo.setDoclastmoddateFrom(searchdatefrom) ;
    if(!searchdateto.equals(""))  DocSearchComInfo.setDoclastmoddateTo(searchdateto) ;
    if(!searchcreater.equals("")) {
        DocSearchComInfo.setOwnerid(searchcreater) ;
        DocSearchComInfo.setUsertype("1");
    }
    if(!crmId.equals("")) {
        DocSearchComInfo.setDoccreaterid(crmId) ;   
        DocSearchComInfo.setUsertype("2");    
    }
    DocSearchComInfo.setOrderby("4") ;
}

String docstatus[] = new String[]{"1","2","5","7"};
for(int i = 0;i<docstatus.length;i++){
   	DocSearchComInfo.addDocstatus(docstatus[i]);
}

String tempsqlwhere = DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
String orderclause = DocSearchComInfo.FormatSQLOrder() ;
String orderclause2 = DocSearchComInfo.FormatSQLOrder2() ;

if(!tempsqlwhere.equals("")) sqlwhere += " and " + tempsqlwhere ;

/* added by wdl 2007-03-16 不显示历史版本 */
sqlwhere+=" and (ishistory is null or ishistory = 0) ";
/* added end */

sqlwhere+=" and t1.id !="+subscribeDocId;

int perpage = 30 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;
//DocSearchManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = DocSearchManage.getRecordersize();
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
%>
<script type="text/javascript">
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
</script>
</HEAD>

<BODY scroll="no" style="overflow-x: hidden;overflow-y:hidden">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<div class="zDialog_div_content">

<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocByOwenerBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<input type="hidden" name="subscribePara" value='<%=subscribePara%>'>
<input type="hidden" name="documentids" value='<%=documentids%>'>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_top} " ;
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


<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
	<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
	</wea:item>
	<wea:item><input  class=InputStyle  name=searchsubject value='<%=searchsubject%>'></wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
	<wea:item>
	    <span>
	           <brow:browser viewType="0" name="secCategory" browserValue='<%=secCategory%>' 
	            browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
	            idKey="id" nameKey="path"
	            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
	            browserSpanValue='<%= path	 %>'></brow:browser>
	    </span>		
	</wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
	<wea:item attributes="{'colspan':'full'}">
		<span class="wuiDateSpan" selectId="doccreatedateselect">
		    <input class=wuiDateSel type="hidden" name="searchdatefrom" value="<%=searchdatefrom%>">
		    <input class=wuiDateSel  type="hidden" name="searchdateto" value="<%=searchdateto%>">
		</span>
	</wea:item>
<%if(date2duringTokens.length>0){ %>
 <wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
 <wea:item>
  <select class=inputstyle  size=1 id=date2during name=date2during>
  	<option value="">&nbsp;</option>
  	<%
  	for(int i=0;i<date2duringTokens.length;i++)
  	{
  		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
  		if(tempdate2during>36||tempdate2during<1)
  		{
  			continue;
  		}
  	%>
  	<!-- 最近个月 -->
  	<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
  	<%
  	} 
  	%>
  	<!-- 全部 -->
  	<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
  </select>
 </wea:item>
<%} %>
<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
	<wea:item><input class=InputStyle id=searchid name=searchid value='<%=searchid%>' onKeyPress="ItemNum_KeyPress()" onBlur='checkcount1(this)'></wea:item>
</wea:group>

</wea:layout>
<!--#################Search Table END//###################### BroswerStyle-->
</div>
<div id="dialog">
	<div id='colShow' ></div>
</div>
<div style="width:0px;height:0px;overflow:hidden;">
	<button accessKey=T id=myfun1   type=button onclick="resetCondtion();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type=submit></BUTTON>
</div>
	<!--########//Select Table End########-->
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input type="hidden" name="documentids" value="">
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
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
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=documentids%>");
});


</SCRIPT>
</BODY>
</HTML>
