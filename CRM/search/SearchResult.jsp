
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.crm.util.CrmFieldComInfo"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rso" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetCO" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="CreditInfoComInfo" class="weaver.crm.Maint.CreditInfoComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page" />
<jsp:useBean id="DeprtmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CrmFieldComInfo" class="weaver.crm.util.CrmFieldComInfo" scope="page" />
<jsp:useBean id="CRMTransMethod" class="weaver.crm.Maint.CRMTransMethod" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>
</HEAD>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(527,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%
String userid = ""+user.getUID();
String loginType = ""+user.getLogintype();
String userSeclevel = user.getSeclevel();
String msg = Util.null2String(CRMSearchComInfo.getMsg());//report ：报表查看客户信息
String selectType = Util.null2String(CRMSearchComInfo.getSelectType());//mine 我的客户 ，share批量共享
if("monitor".equals(selectType) && !HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){ 
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String leftjointable = CrmShareBase.getTempTable2(loginType,userid);
leftjointable = leftjointable.replaceFirst("distinct", "");
if("share".equals(selectType)){//批量共享，加上编辑权限限制
	leftjointable = leftjointable.replace("deleted =0" ,"deleted =0 and sharelevel>=2 ");
}

String name="";
String text="";
String column="";
String orderkey="";
String transmethod="";
String linkkey="";

String strURL="";
String linkvaluecolumn="";

String tableInfo = "";
String backFields = "t1.department,t1.id";
//配置要查询的列
String backFields2 = "t1.id";
String columnString = "";
CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
while(comInfo.next()){
  	if(comInfo.getUsetable().equals("CRM_CustomerInfo")&&"1".equals(comInfo.getIsdisplay())){
  		
  		String fieldid = comInfo.getId();
  		String fieldname = comInfo.getFieldname();//字段名
  		String fieldlabel = comInfo.getFieldlabel();//字段显示名
  		int fieldhtmltype = comInfo.getFieldhtmltype();//字段html类型
  		String type = comInfo.getType();//字段类型
  		String dmlUrl = comInfo.getDmlurl();//
  		String fielddbtype = comInfo.getFielddbtype();
  		String groupid = comInfo.getGroupid()+"";
  		String isdisplay = comInfo.getIsdisplay();
  		if(!"4".equals(groupid)){//提出联系人字段
  			if("text".equals(fielddbtype)){
  	  			backFields2+=",cast(t1."+fieldname+" as varchar(max)) "+fieldname;
  	  		}else{
  	  			backFields2+=",t1."+fieldname;
  	  		}
  	  		backFields+=",t1."+fieldname;	
  		}
  		//返回一个col
  		String col = CRMTransMethod.getCrmColString(fieldid,fieldname,fieldlabel,fieldhtmltype,type,dmlUrl,user,groupid,isdisplay);
  		columnString+=col;
	}
}
String colString = "";
String sqlFrom = "";
String sqlWhere = "";
String orderBy = "t1.id";
if(loginType.equals("1")){
	String tempTableSql = " (select HrmResource.departmentid as department,"+backFields2+" from CRM_CustomerInfo t1 left join HrmResource on t1.manager=HrmResource.id where "
			+ CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false) + " ) ";
	sqlFrom = "from " + tempTableSql + " t1 "+(rs.getDBType().equals("oracle")?"left join":"inner join")+leftjointable+" t2 on t1.id = t2.relateditemid "; 
	sqlWhere +=" t1.id = t2.relateditemid ";
	if("monitor".equals(selectType)){//客户监控，查询所有客户信息 
		if(rs.getDBType().equals("sqlserver")) backFields = "t1.department,"+backFields2;
		sqlFrom = "from CRM_CustomerInfo t1";
		sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false);
	}
	
}else{
	if(rs.getDBType().equals("sqlserver")) backFields = "t1.department,"+backFields2;
	sqlFrom = "from CRM_CustomerInfo t1 ";
	sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false)+" and t1.agent="+userid;
}
String popedomOtherpara = loginType+"_"+userid+"_"+userSeclevel;
String operateString= "<operates width=\"15%\">";
       operateString+=" <popedom transmethod=\"weaver.splitepage.operate.SpopForCus.getCusOpratePopedom\"  otherpara=\""+popedomOtherpara+"\"></popedom> ";
       operateString+="     <operate href=\"/email/new/MailInBox.jsp\"  linkkey=\"opNewEmail=1&amp;isInternal=0&amp;to\" linkvaluecolumn=\"email\" text=\""+SystemEnv.getHtmlLabelName(2051,user.getLanguage())+"\" target=\"_blank\"  index=\"0\"/>";
       operateString+="     <operate href=\"/workflow/request/RequestType.jsp\" linkkey=\"crmid\" linkvaluecolumn=\"id\"  text=\""+SystemEnv.getHtmlLabelName(16392,user.getLanguage())+"\" target=\"_blank\"  index=\"0\"/>";
       operateString+="     <operate href=\"javascript:doAddCowork()\"   text=\""+SystemEnv.getHtmlLabelName(18034,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"0\"/>";
       operateString+="     <operate href=\"javascript:doWorkPlan()\"   text=\""+SystemEnv.getHtmlLabelName(18481,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"0\"/>";
       operateString+="</operates>";
	
    String tableString = "";
    tableString="<table pageId=\""+PageIdConst.CRM_CustomerListInfo+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_CustomerListInfo,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">";
    tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"t1.id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />";
    tableString+="<head>";
    tableString+=columnString;
    tableString+="</head>";
    tableString+=operateString;
    tableString+="</table>";  
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onReSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if("monitor".equals(selectType) && HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deleteBatch(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("MailMerge:Merge", user)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1226,user.getLanguage())+",javascript:sendMailBatch()',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}

if(HrmUserVarify.checkUserRight("MutiApproveCustomerNoRequest", user)){//升级降级
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17530,user.getLanguage())+",javascript:doLevelUp(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(17531,user.getLanguage())+",javascript:doLevelDown(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){
    //RCMenu += "{"+"Excel,javascript:_xtable_getAllExcel(),_top} " ;
	RCMenu += "{"+"Excel,javascript:crmExport(),_top} " ;
    RCMenuHeight += RCMenuHeightStep;
}

%>

<%
if("report".equals(msg)){ %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="customer"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(!user.getLogintype().equals("2")&&HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>" class="e8_btn_top_first middle" onclick="crmExport();"/>
			<%} %>
			<%if("search".equals(selectType) || "hrmView".equals(CRMSearchComInfo.getSearchtype())){%>
				<input class="e8_btn_top_first middle" onclick="sendMailBatch()" type="button"  value="<%=SystemEnv.getHtmlLabelName(2051,user.getLanguage()) %>"/>
			<%} %>
			<%if("share".equals(selectType)){ %>
				<input class="e8_btn_top_first middle" onclick="shareBatch()" type="button"  value="<%=SystemEnv.getHtmlLabelName(18037,user.getLanguage()) %>"/>
			<%} %>
			<%if("monitor".equals(selectType) && HrmUserVarify.checkUserRight("EditCustomer:Delete", user)){ %>
				<input class="e8_btn_top_first middle" onclick="changeManager()" type="button"  value="修改经理"/>
				<input class="e8_btn_top_first middle" onclick="deleteBatch()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
			<%} %>
			<input type="text" class="searchInput"  id="searchCustomerName" name="searchCustomerName" value="<%=CRMSearchComInfo.getFieldValue("name").toString()%>" />
			<%if(!"report".equals(msg)){ %>
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>



<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
<FORM id=weaver name="weaver" action="/CRM/search/SearchOperation.jsp?selectType=<%=selectType %>" method="post">
<input type="hidden" name="msg" value="<%=msg %>">
<input type="hidden" name="settype" value="<%=CRMSearchComInfo.getSettype() %>">
<input type="hidden" name="destination" value="no">
<input type="hidden" name="searchtype" value="<%=CRMSearchComInfo.getSearchtype() %>">
<input type="hidden" name="actionKey" value="common"> 
<input type="hidden" name="PrjID" value="<%=CRMSearchComInfo.getFieldValue("PrjID") %>"> 
<input name="FirstNameDesc" type="hidden" value="2">
<input name="searchHrmId" type="hidden" value="<%=CRMSearchComInfo.getFieldValue("searchHrmId") %>">
	
<wea:layout type="4Col">
	<%
	
	rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_CustomerInfo' order by dsporder asc");
	while(rs.next()){
		String groupid = rs.getString("id");
		if(!groupid.equals("1") && !groupid.equals("2")){
			rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_CustomerInfo' and issearch= 1 and groupid = "+groupid);
			rst.next();
			if(rst.getInt(1)==0){
				continue;
			}
		}
		
		
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_CustomerInfo".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				//没有作为搜索条件、或者是附件则跳过
				if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
					continue;
				}
				
			%>
				
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<wea:item>
					<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(CRMSearchComInfo.getFieldValue(comInfo.getFieldname())), user , "search")%>
				</wea:item>
			<%}}%>
			
			<%if(groupid.equals("1")){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
				<wea:item>
					 <div areaType="province" areaName="province" areaValue="<%=CRMSearchComInfo.getFieldValue("province")+""%>" 
						areaSpanValue="<%=ProvinceComInfo.getProvincename(CRMSearchComInfo.getFieldValue("province")+"")%>"  areaMustInput="1"  areaCallback="areaCallBackUpdate"  class="_areaselect" id="_areaselect_provinceid"></div>																	
														  		
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item>
		        <wea:item>
		        	<span>
			        	<SELECT  id="datetype" name="datetype" onchange="onChangetype(this)" style="width: 120px;">
						  <option value="" 	<%if(CRMSearchComInfo.getFieldValue("datetype").equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						  <option value="1" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						  <option value="2" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						  <option value="3" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						  <option value="4" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						  <option value="5" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						  <option value="6" <%if(CRMSearchComInfo.getFieldValue("datetype").equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
						</SELECT>     
		        	</span>
		        	
		        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
						<BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
						<SPAN id=fromdatespan ><%=CRMSearchComInfo.getFieldValue("fromdate")%></SPAN>
						<input type="hidden" name="fromdate" value=<%=CRMSearchComInfo.getFieldValue("fromdate")%>>
						-
						<BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
						<SPAN id=enddatespan ><%=CRMSearchComInfo.getFieldValue("enddate")%></SPAN>
						<input type="hidden" name="enddate" value=<%=CRMSearchComInfo.getFieldValue("enddate")%>>
					</span>
				</wea:item>	
				<wea:item><%=SystemEnv.getHtmlLabelNames("144,124",user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="department" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("department")+""%>' 
				         browserSpanValue = '<%=DeprtmentComInfo.getDepartmentname(CRMSearchComInfo.getFieldValue("department"))%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp" width="230px" ></brow:browser> 
				</wea:item>
			<%} %>
			
			<%if(groupid.equals("2")){ 
				String rating = CRMSearchComInfo.getFieldValue("rating")+"";
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
				<wea:item>
					<select style="width: 172px"  name="rating" id="rating">
						<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) %></option>
                     	<option value="0" <%=rating.equals("0")?"selected":""%>>0</option>
                     	<option value="1" <%=rating.equals("1")?"selected":""%>>1</option>
						<option value="2" <%=rating.equals("2")?"selected":""%>>2</option>
						<option value="3" <%=rating.equals("3")?"selected":""%>>3</option>
						<option value="4" <%=rating.equals("4")?"selected":""%>>4</option>
						<option value="5" <%=rating.equals("5")?"selected":""%>>5</option>
						<option value="6" <%=rating.equals("6")?"selected":""%>>6</option>
						<option value="7" <%=rating.equals("7")?"selected":""%>>7</option>
                    </select>
				</wea:item>
															
				<wea:item><%=SystemEnv.getHtmlLabelName(581,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="contractlevel" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/TradeInfoBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("contractlevel")+""%>' 
				         browserSpanValue = '<%=TradeInfoComInfo.getTradeInfoname(CRMSearchComInfo.getFieldValue("contractlevel")+"")%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=debtorNumber" width="230px" ></brow:browser>
				</wea:item>
				
				<wea:item><%=SystemEnv.getHtmlLabelName(580,user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser viewType="0" name="creditlevel" 
				         browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CreditInfoBrowser.jsp"
				         browserValue='<%=CRMSearchComInfo.getFieldValue("creditlevel")+""%>' 
				         browserSpanValue = '<%=CreditInfoComInfo.getCreditInfoname(CRMSearchComInfo.getFieldValue("creditlevel")+"")%>'
				         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				         completeUrl="/data.jsp?type=creditorNumber" width="230px" ></brow:browser>
				</wea:item>
			<%} %>
		</wea:group>
	<%}%>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32694,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>			
</FORM>
</div>


<%if("report".equals(msg)){ %>
<div class="zDialog_div_content" style="height:400px;">
<%}%>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_CustomerListInfo%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" tableInfo="<%=tableInfo%>"/> 

<%if("report".equals(msg)){ %>
</div>
<%}%>		



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<iframe id="searchexport" name="searchexport" style="display:none"></iframe>
<%if("report".equals(msg)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>
<script language="javascript">

<%---onReSearch() edited by 徐蔚绛 2005-03-10 for TD:1546----%>
function onReSearch(){
	window.weaver.submit();
}

function crmExport(){
    searchexport.location="/CRM/search/SearchResultExport.jsp";
}

function doEdit(crmid){
	var url = "/CRM/data/ViewCustomer.jsp?CustomerID="+crmid;
	openFullWindowHaveBar(url);
}

var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function addShareCallback(){
	closeDialog();
}

function doShare(crmid){

	 dialog=getDialog("<%=SystemEnv.getHtmlLabelName(19025,user.getLanguage())%>", 500 , 300);//定义Dialog对象
	 dialog.URL="/CRM/data/AddShare.jsp?isfromtab=true&itemtype=2&CustomerID="+crmid+"&customername=";
　　　dialog.show();
	 document.body.click();
}

function doViewLog(crmid){
	
	 dialog=getDialog("<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage())%>", 600 , 500);//定义Dialog对象
　　　dialog.URL="/CRM/data/ViewLog.jsp?log=n&isfromtab=false&CustomerID="+crmid;
　　　dialog.show();
	 document.body.click();
}

function doViewContactLog(crmid){
	
	 dialog=getDialog("<%=SystemEnv.getHtmlLabelName(31704,user.getLanguage())%>", 600 , 500);//定义Dialog对象
　　　dialog.URL="/CRM/data/ViewContactLog.jsp?log=n&isfromtab=false&CustomerID="+crmid;
　　　dialog.show();
     document.body.click();
}


function sendMailBatch(){
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	jQuery.post("/CRM/search/SearchResultOperation.jsp",{"customerids":customerids,"method":"getEmail"},function(emails){
		var url = "/email/new/MailInBox.jsp?opNewEmail=1&isInternal=0&to="+emails;
		openFullWindowHaveBar(url);
	})
}



function  shareBatch(){
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	dialog=getDialog("<%=SystemEnv.getHtmlLabelNames("611,119",user.getLanguage())%>", 600 , 500);//定义Dialog对象
　　 dialog.URL="/CRM/data/ShareMutiCustomerTo.jsp?selectType=share&customerids="+customerids;
　　 dialog.show();
	document.body.click();
}

function deleteBatch(){
	
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("/CRM/search/SearchResultOperation.jsp",{"ismanage":"1","customerids":customerids ,"method":"delete","userid":"<%=user.getUID()%>",
			"logintype":"<%=user.getLogintype()%>","loginid":"<%=user.getLoginid()%>"},function(){
			_table.reLoad();
		})
	});
}
$(document).ready(function(){
	areromancedivs();		
	jQuery("#topTitle").topMenuTitle({searchFn:searchCustomerName});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=CRMSearchComInfo.getFieldValue("datetype")%>" == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}			
});

function onChangetype(obj){
	if(obj.value == 6){
		jQuery("#dateTd").show();
	}else{
		jQuery("#dateTd").hide();
	}
}

function searchCustomerName(){
	
	var CustomerName = jQuery("#searchCustomerName").val();
	window.weaver.action = "/CRM/search/SearchOperation.jsp?selectType=<%=selectType %>&name="+encodeURI(CustomerName);
	window.weaver.submit();
	
}


function doAddCowork(id){
	dialog=getDialog("<%=SystemEnv.getHtmlLabelName(27411,user.getLanguage())%>", 680 , 520);//定义Dialog对象
	dialog.URL = "/cowork/AddCoWork.jsp?CustomerID="+id;
	dialog.show();
	document.body.click();
}

function doWorkPlan(id){
	dialog=getDialog("<%=SystemEnv.getHtmlLabelName(18481,user.getLanguage())%>", 680 , 520);//定义Dialog对象
	dialog.URL = "/workplan/data/WorkPlanEdit.jsp?from=1&crmid="+id;
	dialog.show();
	document.body.click();
}

function showViewMessageLog(id){
	dialog=getDialog("<%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%>", 680 , 520);//定义Dialog对象
	dialog.URL = "/CRM/data/ViewMessageLog.jsp?isfromtab=false&types=CC&customerid="+id;
	dialog.show();
	document.body.click();
}


function doLevelUp(){
	doCustomerLevel("up");
}

function doLevelDown(){
	doCustomerLevel("down");
}

function doCustomerLevel(operation){
   
    var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	customerids = customerids.substring(0,customerids.length-1);
   jQuery.post("/CRM/data/ChangeLevelCustomerOperation.jsp",{"operation":operation,"customerids":customerids},function(){
		_table.reLoad();
	})
}

function getDialog(title, width ,height){
	var dialog =new window.top.Dialog();
    dialog.currentWindow = window; 
    dialog.Modal = true;
    dialog.Drag=true;
	dialog.Width =width?width:680;
	dialog.Height =height?height:420;
	dialog.Title = title;
	return dialog;
}
function changeManager(){//修改客户经理
	var customerids = _xtable_CheckedCheckboxId();
	if("" == customerids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	dialog=getDialog("", 400 , 300);
	dialog.URL = "/CRM/data/viewHrm.jsp?customerids="+customerids;
	dialog.show();	
}
function changeCallback(){
	closeDialog();
	_table.reLoad();
}			
</script>
</body>
</html>

