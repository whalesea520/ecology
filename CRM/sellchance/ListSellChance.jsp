
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />

<%
String CustomerID = request.getParameter("CustomerID");

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

String subject = Util.fromScreen(request.getParameter("subject"),user.getLanguage());
String datetypePre = Util.null2String(request.getParameter("datetypePre"));
String predateBegin = Util.fromScreen(request.getParameter("predateBegin"),user.getLanguage());
String predateEnd = Util.fromScreen(request.getParameter("predateEnd"),user.getLanguage());
String preyield = Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1 = Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String probability = Util.fromScreen(request.getParameter("probability"),user.getLanguage());
String probability_1 = Util.fromScreen(request.getParameter("probability_1"),user.getLanguage());
String datetypeCre = Util.null2String(request.getParameter("datetypeCre"));
String createdateBegin = Util.fromScreen(request.getParameter("createdateBegin"),user.getLanguage());
String createdateEnd = Util.fromScreen(request.getParameter("createdateEnd"),user.getLanguage());
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());

/*check right begin*/
RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
	return;
}
RecordSetC.first();
String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;


int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

 if( useridcheck.equals(RecordSetC.getString("agent")) ) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

RecordSet.executeProc("CRM_SellChance_SByCustomerID",CustomerID);

String childWhere = "";


rs.execute("select fieldhtmltype ,type,fieldname , candel,groupid from CRM_CustomerDefinField where usetable = 'CRM_SellChance' and issearch= 1 and isopen=1");
String fieldName = "";
String fieldValue = "";
String htmlType = "";
String type= "";
Map map = new HashMap();
while(rs.next()){
	fieldName = rs.getString("fieldName");
	fieldValue = Util.null2String(Util.null2String(request.getParameter(fieldName)));
	htmlType = rs.getString("fieldhtmltype");
	type = rs.getString("type");
	
	if(fieldName.equals("") || fieldValue.equals("")){
		continue;
	}else{
		map.put(fieldName ,fieldValue);
	}
	
	if(fieldName.equals("probability")){
		if (!probability.equals("")) {
			childWhere += " and 100 * probability >= '" + probability + "'";
		}

		if (!probability_1.equals("")) {
			childWhere += " and 100 * probability <= '" + probability_1 + "'";
		}
	}else if(fieldName.equals("preyield")){
		if (!preyield.equals("")) {
			childWhere += " and preyield >= '" + preyield + "'";
		}

		if (!preyield_1.equals("")) {
			childWhere += " and preyield <= '" + preyield_1 + "'";
		}
	}else if(fieldName.equals("predate")){
		if(!"".equals(datetypePre) && !"6".equals(datetypePre)){
			childWhere += " and predate >= '"+TimeUtil.getDateByOption(datetypePre+"","0")+"'";
			childWhere += " and predate <= '"+TimeUtil.getDateByOption(datetypePre+"","")+"'";
		}

		if ("6".equals(datetypePre) && !predateBegin.equals("")) {
			childWhere += " and predate >= '" + predateBegin + "'";
		}

		if ("6".equals(datetypePre) && !predateEnd.equals("")) {
			childWhere += " and predate <= '" + predateEnd + "'";
		}
	}else if(htmlType.equals("1") && (type.equals("2") || type.equals("3"))){//单行文本为数值类型
		childWhere +=  " and "+fieldName+" = "+fieldValue;
	}else if((htmlType.equals("5") || htmlType.equals("3"))&&!type.equals("162")){//下拉框 和 浏览框
		childWhere += " and "+fieldName+" = "+fieldValue;
	}else{
		childWhere += " and "+fieldName+" like '%"+fieldValue+"%'";
	}
}
if(!"".equals(datetypeCre) && !"6".equals(datetypeCre)){
	childWhere += " and createdate >= '"+TimeUtil.getDateByOption(datetypeCre+"","0")+"'";
	childWhere += " and createdate <= '"+TimeUtil.getDateByOption(datetypeCre+"","")+"'";
}
if ("6".equals(datetypeCre) && !createdateBegin.equals("")) {
	childWhere += " and createdate >= '" + createdateBegin + "'";
}
if (!endtatusid.equals("") && !endtatusid.equals("4")) {
	childWhere += " and endtatusid = '" + endtatusid + "'";
}

boolean first = true;
%>


<HTML><HEAD>
<%if(isfromtab) {%>
<%} %>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canedit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doClick1(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:deleteInfos(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	
	<tr>
	<td class="rightSearchSpan" style="text-align:right;">
		<%if(canedit){%>
			<input class="e8_btn_top middle" onclick="doClick1()" type="button"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="deleteInfos()" type="button"  value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
		<%}%>
		<input type="text" class="searchInput"  id="searchSubject" name="searchSubject" value="<%=subject %>" onchange="searchSubject()"/>
		<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
	</td></tr>
</table>

<!-- 高级搜索 -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=weaver name=frmmain method=post action="/CRM/sellchance/ListSellChance.jsp">
<input type="hidden" name="CustomerID" value="<%=CustomerID %>">
<input type="hidden" name="isfromtab" value="<%=CustomerID %>">

<wea:layout type="4col">
	<%
	CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
	rs.execute("select * from CRM_CustomerDefinFieldGroup where usetable = 'CRM_SellChance' order by dsporder asc");
	boolean firstsearch = true;
	while(rs.next()){
		if(!firstsearch){
			rst.execute("select count(*) from CRM_CustomerDefinField where usetable = 'CRM_SellChance' and issearch= 1 and groupid = "+rs.getString("id"));
			rst.next();
			if(rst.getInt(1)==0){
				continue;
			}
		}
		firstsearch = false;
		
		
		
		%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(rs.getInt("grouplabel"),user.getLanguage())%>'>
			<% while(comInfo.next()){
				if("CRM_SellChance".equals(comInfo.getUsetable())){
				//没有作为搜索条件、或者是附件则跳过
				if(comInfo.getIssearch().trim().equals("") || comInfo.getIssearch().trim().equals("0") || comInfo.getFieldhtmltype() == 6){
					continue;
				}
				
			%>
				<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
				<%if(comInfo.getFieldname().equals("preyield")){ %>	
					<wea:item>
						<INPUT type="text" class=InputStyle maxLength=20 style="width:20%" size=12 id="preyield" name="preyield" value="<%=preyield %>"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' >
			     		-
			     		<INPUT type="text" class=InputStyle maxLength=20 style="width:20%" size=12 id="preyield_1" name="preyield_1" value="<%=preyield_1 %>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()'>
					</wea:item>
				<%}else if(comInfo.getFieldname().equals("probability")){ %>	
					<wea:item>
						<INPUT type="text" class=InputStyle maxLength=20 style="width:20%" size=12 id=probability name="probability" value="<%=probability %>"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("probability");comparenumber()' >
			     		-
			     		<INPUT type="text" class=InputStyle maxLength=20 style="width:20%" size=12 id="probability_1" name="probability_1" value="<%=probability_1 %>"  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("probability_1");comparenumber()'> %
					</wea:item>
				
				<%}else if(comInfo.getFieldname().equals("predate")){ %>	
					<wea:item>
						<span>
				        	<SELECT  name="datetypePre" id="datetypePre" onchange="onChangetypePre(this)" style="width: 100px;">
							  <option value="" 	<%if(datetypePre.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							  <option value="1" <%if(datetypePre.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
							  <option value="2" <%if(datetypePre.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
							  <option value="3" <%if(datetypePre.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
							  <option value="4" <%if(datetypePre.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
							  <option value="5" <%if(datetypePre.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
							  <option value="6" <%if(datetypePre.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
							</SELECT>     
						</span>
						<span id="dateTdPre" style="margin-left: 10px;padding-top: 5px;">	
							<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(predateBeginSpan,predateBegin)></BUTTON>&nbsp;
							<SPAN id=predateBeginSpan ><%=predateBegin %></SPAN>
							<input type="hidden" name="predateBegin" value="<%=predateBegin %>">
							-
							<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(predateEndSpan,predateEnd)></BUTTON>&nbsp;
							<SPAN id=predateEndSpan ><%=predateEnd %></SPAN>
							<input type="hidden" name="predateEnd" value="<%=predateEnd %>">
						</span>
					</wea:item>
				<%}else{ %>			
					<wea:item>
						<%=CrmUtil.getHtmlElementSetting(comInfo ,Util.null2String(map.get(comInfo.getFieldname())), user , "search")%>
					</wea:item>
				<%}
			}}%>
			
			<%if(first){ %>
				<wea:item><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></wea:item>
				<wea:item>
					<select text class=InputStyle id=endtatusid  name=endtatusid style="width: 100px;">
					    <option value="" ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
					    <option value=4 <%if(endtatusid.equals("4")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%> </option>
					    <option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
					    <option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
					    <option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
			    	</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></wea:item>
				<wea:item>
					<span>
			        	<SELECT  name="datetypeCre" id="datetypeCre" onchange="onChangetypeCre(this)" style="width: 100px;">
						  <option value="" 	<%if(datetypeCre.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						  <option value="1" <%if(datetypeCre.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
						  <option value="2" <%if(datetypeCre.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
						  <option value="3" <%if(datetypeCre.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
						  <option value="4" <%if(datetypeCre.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
						  <option value="5" <%if(datetypeCre.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
						  <option value="6" <%if(datetypeCre.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
						</SELECT>     
					</span>
					<span id="dateTdCre" style="margin-left: 10px;padding-top: 5px;">	
						<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(createdateBeginSpan,createdateBegin)></BUTTON>&nbsp;
						<SPAN id=createdateBeginSpan ><%=createdateBegin %></SPAN>
						<input type="hidden" name="createdateBegin" value="<%=createdateBegin %>">
						-
						<BUTTON type="button" class=calendar id=SelectDate onclick=getDate(createdateEndSpan,createdateEnd)></BUTTON>&nbsp;
						<SPAN id=createdateEndSpan ><%=createdateEnd %></SPAN>
						<input type="hidden" name="createdateEnd" value="<%=createdateEnd %>">
					</span>
				</wea:item>
			<%first= false;} %>
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

</form>

</div>


<%
    String tableString = "";
	String backfields = " id,subject,predate,preyield,probability,createdate,sellstatusid,endtatusid , customerid";
	String fromSql  = " CRM_SellChance " ;
	String sqlWhere = " customerid="+CustomerID+childWhere;
	String orderby = "";
	tableString = " <table pageId=\""+PageIdConst.CRM_SellChanceList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_SellChanceList,user.getUID(),PageIdConst.CRM)+"\"  tabletype=\"checkbox\">"+
				  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\"/>"+
				  " <checkboxpopedom showmethod=\"weaver.crm.sellchance.SellChangeRoprtTransMethod.getSellCheckInfo\" popedompara=\"column:endtatusid+column:customerid+"+user.getUID()+"\"  />"+
				  " <head>"+
	              " <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(82534,user.getLanguage())+"\" column=\"id\" orderkey=\"subject\" otherpara=\"column:subject\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMSellSubject\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(2247,user.getLanguage())+"\" column=\"predate\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(2248,user.getLanguage())+"\" column=\"preyield\"/>"+
	              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2249,user.getLanguage())+"\" column=\"probability\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(1339,user.getLanguage())+"\" column=\"createdate\"/>"+
	              "	<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(82536,user.getLanguage())+"\" column=\"sellstatusid\" transmethod=\"weaver.crm.Maint.CRMTransMethod.getSellStatus\"/>"+
	              "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15112,user.getLanguage())+"\" column=\"endtatusid\"  otherpara='"+user.getLanguage()+"' transmethod=\"weaver.crm.Maint.CRMTransMethod.getEndStatus\"/>"+
	 			  "	</head>"+
	 			  "<operates width=\"15%\">"+
			       	"     <operate href=\"javascript:doView(0)\" text=\""+SystemEnv.getHtmlLabelName(360,user.getLanguage())+"\"  index=\"0\"/>";
			       	if(canedit){
			       		tableString += "     <operate  href=\"javascript:deleteInfo()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"2\"/>";
			       	}
			       	tableString += "     <operate href=\"javascript:doView(1)\" text=\""+SystemEnv.getHtmlLabelName(15153,user.getLanguage())+"\" target=\"_fullwindow\"  index=\"1\"/>"+
			      "</operates>"+
	 			  "</table>";
  %>
  <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_SellChanceList%>">
  <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/>


<script type="text/javascript">
function doClick2(){
	location='/CRM/data/ViewCustomer.jsp?CustomerID=<%=CustomerID%>'
}

function doClick1(){

	diag =getDialog("<%=SystemEnv.getHtmlLabelNames("82,32922",user.getLanguage())%>",800,600);
	diag.URL = '/CRM/sellchance/AddSellChance.jsp?isfromtab=<%=isfromtab%>&CustomerID=<%=CustomerID%>';
	diag.show();
	document.body.click();
}

jQuery(function(){
	jQuery("select[name='sellstatusid']").find("option[value='<%=sellstatusid%>']").attr("selected",true); 
	jQuery("select[name='endtatusid']").find("option[value='<%=endtatusid%>']").attr("selected",true); 
	
	if("<%=datetypePre%>" == 6){
		jQuery("#dateTdPre").show();
	}else{
		jQuery("#dateTdPre").hide();
	}
	
	if("<%=datetypeCre%>" == 6){
		jQuery("#dateTdCre").show();
	}else{
		jQuery("#dateTdCre").hide();
	}
});

function onChangetypePre(obj){
	if(obj.value == 6){
		jQuery("#dateTdPre").show();
	}else{
		jQuery("#dateTdPre").hide();
	}
}
	
function onChangetypeCre(obj){
	if(obj.value == 6){
		jQuery("#dateTdCre").show();
	}else{
		jQuery("#dateTdCre").hide();
	}
}
		
function resetCondtion(){
	document.getElementById("weaver").reset();
	jQuery("select").find("option[value='']").attr("selected",true); 
	jQuery("input[name='predateBegin']").val("");
	jQuery("input[name='predateEnd']").val("");
	jQuery("input[name='createdateBegin']").val("");
	jQuery("input[name='createdateEnd']").val("");
	jQuery("span[id='predateBeginSpan']").html("");
	jQuery("span[id='predateEndSpan']").html("");
	jQuery("span[id='createdateBeginSpan']").html("");
	jQuery("span[id='createdateEndSpan']").html("");
}

$(document).ready(function(){
	$("#topTitle").topMenuTitle({searchFn:searchName});
	$("#hoverBtnSpan").hoverBtn();
				
});

function searchName(){
	var name =$(".searchInput").val();
	jQuery("#subject").val(name);
	$("#weaver").submit();
}

function searchSubject(){
	var searchSubject = jQuery("#searchSubject").val();
	window.frmmain.action = "/CRM/sellchance/ListSellChance.jsp?&subject="+encodeURI(searchSubject);
	window.frmmain.submit();
}

function deleteInfos(){
	var chanceids = _xtable_CheckedCheckboxId();
	if("" == chanceids){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
		return;
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("/CRM/sellchance/SellChanceOperation.jsp",{"chanceids":chanceids,"method":"batchDel"},function(){
			_table.reLoad();
		});
	});
	
}

var diag = null;
function closeDialog(){
	if(diag)
		diag.close();
	_table. reLoad();
}

function editInfo(id , customerid){
	
	diag = getDialog("<%=SystemEnv.getHtmlLabelNames("93,32922",user.getLanguage())%>",800,600);
	diag.URL="/CRM/sellchance/EditSellChance.jsp?CustomerID="+customerid+"&chanceid="+id;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();
}

function deleteInfo(id){
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>",function(){
		jQuery.post("/CRM/sellchance/SellChanceOperation.jsp",{"chanceid":id,"method":"del"},function(){
			_table.reLoad();
		});
	});
}

function doView(type , chanceid){
	type = type==0?"info":"contact";
	var title = "";
	if(type == "info"){
		title= "<%=SystemEnv.getHtmlLabelNames("367,32922",user.getLanguage()) %>"
	}else{
		title = "<%=SystemEnv.getHtmlLabelNames("367,32922",user.getLanguage()) %>"
	}
	diag =getDialog(title,800,600);
	if(type=='info'){
		diag.URL = "/CRM/sellchance/ViewSellChanceTab.jsp?type="+type+"&id="+chanceid+"&"+new Date().getTime();
	}else{ 
		diag.URL = "/CRM/sellchance/ViewSellChanceTab.jsp?type="+type+"&id="+chanceid+"&"+new Date().getTime();
	}
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();

}

function getDialog(title,width,height){
    var diag =new window.top.Dialog();
    diag.currentWindow = window; 
    diag.Modal = true;
    diag.Drag=true;
	diag.Width =width?width:800;
	diag.Height =height?height:600;
	diag.Title = title;
	return diag;
} 

function showInfo(id){
	diag = getDialog("<%=SystemEnv.getHtmlLabelNames("367,32922",user.getLanguage())%>",800,600);
	diag.URL="/CRM/sellchance/ViewSellChance.jsp?isfromtab=false&id="+id;
	diag.ShowButtonRow=false;
	diag.show();
	document.body.click();

}
</script>

<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY>
</HTML>
