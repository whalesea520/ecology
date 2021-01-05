
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.workflow.browserdatadefinition.ConditionField"%> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />

<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page"/>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page" />


<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/docs/multiDocBrowser_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("30041",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
</script>

<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
<%
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));
if("".equals(f_weaver_belongto_usertype)){
f_weaver_belongto_usertype = "0";
}
 user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
f_weaver_belongto_userid=""+user.getUID();                   //当前用户id
String bdf_wfid = Util.null2String(request.getParameter("bdf_wfid"));
String bdf_fieldid = Util.null2String(request.getParameter("bdf_fieldid"));
String bdf_viewtype = Util.null2String(request.getParameter("bdf_viewtype"));
List<ConditionField> lsConditionField = null;
if(bdf_wfid.length()>0){
	lsConditionField = ConditionField.readAll(Util.getIntValue(bdf_wfid),Util.getIntValue(bdf_fieldid),Util.getIntValue(bdf_viewtype));
}
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

String islink = Util.null2String(request.getParameter("islink"));
String searchid = Util.null2String(request.getParameter("searchid"));
//String searchmainid = Util.null2String(request.getParameter("searchmainid"));
String searchsubject = Util.null2String(request.getParameter("searchsubject"));
String searchcreater = Util.null2String(request.getParameter("searchcreater"));
String searchdatefrom = Util.null2String(request.getParameter("searchdatefrom"));
String searchdateto = Util.null2String(request.getParameter("searchdateto"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String crmId = Util.null2String(request.getParameter("txtCrmId"));
String sqlwhere = "" ;

String secCategory = Util.null2String(request.getParameter("secCategory"));
String path= Util.null2String(request.getParameter("path"));
if (!secCategory.equals("")) path = "/"+CategoryUtil.getCategoryPath(Util.getIntValue(secCategory));

String check_per = Util.null2String(request.getParameter("documentids"));
if("".equals(check_per)){
	check_per = Util.null2String(request.getParameter("selectids"));
}
String documentids = "" ;
String documentnames ="";

String newDocumentids="";

// 2005-04-08 Modify by guosheng for TD1769
if (!check_per.equals("")) {
	documentids=","+check_per;
	String[] tempArray = Util.TokenizerString2(documentids, ",");
	for (int i = 0; i < tempArray.length; i++) {
		String tempDocName=DocComInfo.getDocname(tempArray[i]);
		if(!"".equals(tempDocName)) {
			newDocumentids += ","+tempArray[i];
			documentnames += ","+Util.StringReplace(Util.StringReplace(tempDocName,",","，"),"&quot;","“");
		}
	}
}
documentids=newDocumentids;
/*
if(!sqlwhere1.equals("")) {
	sqlwhere = sqlwhere1 + " and docstatus in ('1','2','5') ";
}
else {
		sqlwhere = " where  docstatus in ('1','2','5') ";
}
    //System.out.println("sqlwhere = " + sqlwhere);
*/
sqlwhere = " where 1=1 ";

if(!islink.equals("1")) {
    DocSearchComInfo.resetSearchInfo() ;
    if(!searchid.equals("")) DocSearchComInfo.setDocid(searchid) ;
    //if(!searchmainid.equals("")) DocSearchComInfo.setMaincategory(searchmainid) ;
    if(!secCategory.equals("")) DocSearchComInfo.setSeccategory(secCategory) ;
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
sqlwhere += dm.getDateDuringSql(date2during);

//int perpage = 30 ;
int perpage = 10 ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
boolean hasNextPage=false;

//DocSearchManage.getSelectResultCount(sqlwhere,user);
int RecordSetCounts = 0;//DocSearchManage.getRecordersize();
if(RecordSetCounts>pagenum*perpage){
	hasNextPage=true;
}
%>

<script type="text/javascript">
    var f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>;
	var f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>;
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
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(527, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>
<BODY scroll="no" style="overflow-x: hidden;overflow-y:hidden">

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
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiDocBrowser.jsp" onsubmit="btnOnSearch();return false;" method=post>
<input type="hidden" name="pagenum" value=''>
<DIV align=right style="display:none">
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
</DIV>

<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<%if(lsConditionField!=null && lsConditionField.size()>0){
  boolean allHide=true;
for(ConditionField conditionField: lsConditionField){
		boolean isHide = conditionField.isHide();
		if(allHide && !isHide){
			allHide=false;
		}
}
if(!allHide){
%>
<wea:layout type="4col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
<%
  Hashtable<String,String> htHide = new Hashtable<String,String>();
	for(ConditionField conditionField: lsConditionField){
		boolean isHide = conditionField.isHide();
		boolean isReadonly = conditionField.isReadonly();
		String isMustInput = isReadonly?"0":"1";
		String filedname = conditionField.getFieldName();
		String valuetype = conditionField.getValueType();
		 String createdatname="";
		
	
		boolean isGetValueFromFormField = conditionField.isGetValueFromFormField();
		String filedvalue = "";
		if(filedname.equals("doccreatedateselect")){

		if(isGetValueFromFormField){
			//表单字段 bdf_fieldname
 	  	filedvalue = Util.null2String(request.getParameter("bdf_"+filedname));	
		searchdatefrom="".equals(searchdatefrom)?filedvalue:searchdatefrom;
		searchdateto="".equals(searchdateto)?filedvalue:searchdateto;
		filedvalue="6";//如果是指定流程字段则认为是指定日期范围类型

		createdatname=SystemEnv.getHtmlLabelName(32530,user.getLanguage());
				
       
		}else{
			filedvalue=valuetype;
			searchdatefrom="".equals(searchdatefrom)?conditionField.getStartDate():searchdatefrom;
			searchdateto="".equals(searchdateto)?conditionField.getEndDate():searchdateto;	
	
		 }
		
		 if(filedvalue.equals("0")){
		  createdatname=SystemEnv.getHtmlLabelName(82857,user.getLanguage());	 
		 }else if(filedvalue.equals("1")){
		  createdatname=SystemEnv.getHtmlLabelName(15537,user.getLanguage());
		 }else if(filedvalue.equals("2")){
		  createdatname=SystemEnv.getHtmlLabelName(15539,user.getLanguage());
		 }else if(filedvalue.equals("3")){
		  createdatname=SystemEnv.getHtmlLabelName(15541,user.getLanguage());
		 }else if(filedvalue.equals("4")){
		  createdatname=SystemEnv.getHtmlLabelName(21904,user.getLanguage());
		 }else if(filedvalue.equals("5")){
		  createdatname=SystemEnv.getHtmlLabelName(15384,user.getLanguage());
		 }else if(filedvalue.equals("6")){
		  createdatname=SystemEnv.getHtmlLabelName(32530,user.getLanguage());
		 }else if(filedvalue.equals("7")){
		  createdatname=SystemEnv.getHtmlLabelName(27347,user.getLanguage());
		 }else if(filedvalue.equals("8")){
		  createdatname=SystemEnv.getHtmlLabelName(81786,user.getLanguage());
		 }
		
		}else{
		if(isGetValueFromFormField){
			//表单字段 bdf_fieldname
			
 	  	filedvalue = Util.null2String(request.getParameter("bdf_"+filedname));			
		}else{
			if(valuetype.equals("1")){
				//当前操作者

				if(filedname.equals("searchcreater")){
					filedvalue = ""+user.getUID();
				}
			}else{
				//指定字段
				filedvalue = conditionField.getValue();
			}
		 }
		}
		
		if(isHide){
			
			htHide.put(filedname,filedvalue);
			continue;
		}
		//System.out.println(filedname+"=="+filedvalue);
		
	if(filedname.equals("searchsubject")){
%>
<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%>
	</wea:item>
	<wea:item><input  class=InputStyle  name=searchsubject  <%=isReadonly?"readonly":"" %> value='<%=filedvalue %>'></wea:item>
<%
		}else if(filedname.equals("secCategory")){
	     if (!filedvalue.equals("")) path = CategoryUtil.getCategoryPath(Util.getIntValue(filedvalue));
%>


<wea:item><%=SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></wea:item>
	<wea:item>
	    <span>
	           <brow:browser viewType="0" name="secCategory" browserValue='<%=filedvalue %>'  
	            browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
	            idKey="id" nameKey="path"
	            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='<%=isMustInput%>'
	            completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" linkUrl="#" width="80%"
	            browserSpanValue='<%=path%>'></brow:browser>
	    </span>		
		
	</wea:item>

<%
		
		}else if(filedname.equals("doccreatedateselect")){
				
%>
	
	<wea:item><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></wea:item>
	
       <% if(isReadonly){%>
	   <wea:item attributes="{'colspan':'full'}">
		<%=createdatname%>
		<%if(filedvalue.equals("6")){%>
		&nbsp;&nbsp;&nbsp;<%=searchdatefrom%>-<%=searchdateto%>
		  
		<%}%>
		
	   <input  type="hidden" id=doccreatedateselect name=doccreatedateselect value="<%=filedvalue%>" readonly>
	   <input class=wuiDateSel  type="hidden" name="searchdatefrom" value="<%=searchdatefrom%>">
	   <input class=wuiDateSel  type="hidden" name="searchdateto" value="<%=searchdateto%>">	 
	   </wea:item>
	  <% 
	   }else{ if(filedvalue.equals("8"))filedvalue="6";%>
	   <wea:item attributes="{'colspan':'full'}">

		<span class="wuiDateSpan" selectId="doccreatedateselect" selectValue="<%= filedvalue%>" >
		    <input class=wuiDateSel type="hidden" name="searchdatefrom" value="<%=searchdatefrom%>">
		    <input class=wuiDateSel  type="hidden" name="searchdateto" value="<%=searchdateto%>">
		</span>
		</wea:item>
		<%}%>
	

<%
		}else if(filedname.equals("searchcreater")&&isgoveproj==0){
%>
  <%if(isgoveproj==0){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></wea:item>
	<%}else{%>
	<wea:item><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></wea:item>
	<%}%>
	<wea:item>
	   <brow:browser viewType="0" name="searchcreater" browserValue='<%=filedvalue%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=isMustInput%>'
            completeUrl="/data.jsp" linkUrl="" width="80%"
            temptitle='<%=SystemEnv.getHtmlLabelName(isgoveproj==0?36:20098,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
            browserSpanValue='<%= Util.toScreen(ResourceComInfo.getResourcename(filedvalue),user.getLanguage())	 %>'></brow:browser>


	</wea:item>

<%
		
		}else if(filedname.equals("txtCrmId")){

%>

	
	<%if(isgoveproj==0){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
         <wea:item>
            <span>
           <brow:browser viewType="0" name="txtCrmId" browserValue='<%=filedvalue%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true"  isMustInput='<%=isMustInput%>'
            completeUrl="/data.jsp?type=7" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
            browserSpanValue='<%= Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(filedvalue),user.getLanguage())	 %>'></brow:browser>
    </span>	
        </wea:item>
		<%}%>


<%
		
		}else if(filedname.equals("date2during")){
			
%>

<%if(date2duringTokens.length>0){ %>
 <wea:item><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></wea:item>
 <wea:item>
 <%if(isReadonly){ %>
				<input type="hidden" id=date2during name=date2during value="<%=filedvalue%>">
				<%}%>
  <select class=inputstyle  size=1 id=date2during name=date2during  <%=isReadonly?"disabled":"" %>>
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
  	<option value="<%=tempdate2during %>" <%if (Util.getIntValue(filedvalue,0)==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
  	<%
  	} 
  	%>
  	<!-- 全部 -->
  	<option value="38" <%if (Util.getIntValue(filedvalue,0)==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
  </select>
 </wea:item>
<%} %>


<%
		
		}else if(filedname.equals("searchid")){

%>

<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
	<wea:item><input class=InputStyle id=searchid name=searchid value='<%=filedvalue%>' onKeyPress="ItemNum_KeyPress()" <%=isReadonly?"readonly":"" %> onBlur='checkcount1(this)'></wea:item>

<%
		}
	}

%>
	
<%
//显示隐藏域

 Set<String> key = htHide.keySet();
 for (Iterator<String> it = key.iterator(); it.hasNext();) {
  String fieldname = (String) it.next();
  String fieldvalue = htHide.get(fieldname);
 
  if(fieldname.equals("doccreatedateselect")){
%>

		
		    <input  type="hidden" name="searchdatefrom" value="<%=searchdatefrom%>">
		    <input   type="hidden" name="searchdateto" value="<%=searchdateto%>">
		
	
<%
  }
 %>
  <input type="hidden" name='<%=fieldname %>' value='<%=fieldvalue %>' >
<%}%>


</wea:group>

</wea:layout>
<%}%>
<!--#################Search Table END//###################### BroswerStyle-->
</div>
<div id="dialog">
	<div id='colShow' ></div>
</div>



<div style="width:0px;height:0px;overflow:hidden;">
	<button accessKey=T id=myfun1   type=button onclick="resetCondtion();"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type=submit></BUTTON>
</div>
		</FORM>
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


<% }else{%>



<wea:layout type="4col">
<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
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
	<%if(isgoveproj==0){%>
	<wea:item><%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%></wea:item>
	<%}else{%>
	<wea:item><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></wea:item>
	<%}%>
	<wea:item>
	   
	    <span>
           <brow:browser viewType="0" name="searchcreater" browserValue='<%=searchcreater%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$);" width="80%"
            temptitle='<%=SystemEnv.getHtmlLabelName(isgoveproj==0?36:20098,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
            browserSpanValue='<%= Util.toScreen(ResourceComInfo.getResourcename(searchcreater),user.getLanguage())	 %>'></brow:browser>
    	</span>	
	</wea:item>
	<%if(isgoveproj==0){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
         <wea:item>
            <span>
           <brow:browser viewType="0" name="txtCrmId" browserValue='<%=crmId%>' 
            browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
            hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
            completeUrl="/data.jsp?type=7" linkUrl="#" temptitle='<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
            browserSpanValue='<%= Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmId),user.getLanguage())	 %>'></brow:browser>
    </span>	
        </wea:item>
		<%}%>
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
		</FORM>
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


<%}%>

<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	</div>
</div>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>


<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiDocDialog("<%=documentids%>");
});


</SCRIPT>
</BODY>
</HTML>
