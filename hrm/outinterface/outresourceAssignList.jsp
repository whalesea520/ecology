<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
if(!HrmUserVarify.checkUserRight("CRM:AssignManager",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";

int crmid = Util.getIntValue(request.getParameter("crmid"),0);
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(126086,user.getLanguage())+",javascript:doAssign();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmMain").submit();
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function doAssign(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(126085,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=outresourceAssignSet&isdialog=1&customids="+id;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(126086,user.getLanguage())%>";
	dialog.Width = 600;
	dialog.Height = 350;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</head>
<body>
<FORM name="frmMain" id=frmMain method=post action="outresourceAssignList.jsp">
<input name="id" id="id" type="hidden" value="<%=crmid %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="doAssign();"  value="<%=SystemEnv.getHtmlLabelName(126086,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
 <%
 String backFields = "t1.id,t1.name,t1.city,t1.province,t1.county,t1.phone,"+
 					"t1.source,t1.sector,t1.size_n,t1.type,t1.description,t1.status,t1.rating,t1.manager,t1.department";
 if (rs.getDBType().equals("oracle")){
 	backFields += " , (select t3.id from (select id , customerid from CRM_CustomerContacter ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1 ) contacterid";
 	backFields += " , (select t3.fullname from (select fullname , customerid from CRM_CustomerContacter  ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1) fullname";
 	backFields += " , (select t3.jobtitle from (select jobtitle , customerid from CRM_CustomerContacter  ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1) jobtitle";
 	backFields += " , (select t3.email from (select email , customerid from CRM_CustomerContacter  ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1) email";
 	backFields += " , (select t3.phoneoffice from (select phoneoffice , customerid from CRM_CustomerContacter  ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1) phoneoffice";
 	backFields += " , (select t3.mobilephone from (select mobilephone , customerid from CRM_CustomerContacter  ORDER BY main desc,id desc) t3 where t3.customerid = t1.id and rownum=1) mobilephone";
 } else {
 	backFields += " , (select TOP 1 id from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) contacterid";
 	backFields += " , (select TOP 1 firstname from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) firstname";
 	backFields += " , (select TOP 1 jobtitle from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) jobtitle";
 	backFields += " , (select TOP 1 email from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) email";
 	backFields += " , (select TOP 1 phoneoffice from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) phoneoffice";
 	backFields += " , (select TOP 1 mobilephone from CRM_CustomerContacter where customerid = t1.id  ORDER BY main desc,id desc) mobilephone";
 }
 String sqlFrom = "from CRM_CustomerInfo t1";
 String sqlWhere = CRMSearchComInfo.FormatSQLSearch(user.getLanguage(),false);
 sqlWhere +=" and (manager is null or manager = 0 ) and (deleted is null or deleted = 0)";
 String orderBy = "t1.id";
 	
 String operateString= "<operates width=\"15%\">";
        operateString+="     <operate href=\"javascript:doAssign()\"   text=\""+SystemEnv.getHtmlLabelName(126086,user.getLanguage())+"\" index=\"0\"/>";
        operateString+="</operates>";
 String tableString="<table pageId=\"ad\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_CustomerList,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"checkbox\">";
        tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"Desc\" sqlprimarykey=\"t1.id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlisdistinct=\"true\" />";
        
        tableString+="<head>"+
        "<col name='name' width='20%' text='"+SystemEnv.getHtmlLabelNames("1268",user.getLanguage())+"' column='name' href='/CRM/data/ViewCustomer.jsp' linkkey='CustomerID' linkvaluecolumn='id' orderkey='t1.name' target='_blank'/>"+
        "<col name='address1' width='10%' text='"+SystemEnv.getHtmlLabelNames("110",user.getLanguage())+"' column='address1' display = 'false'  orderkey='t1.address1' target='_blank'/>"+
        "<col name='phone' width='10%' text='"+SystemEnv.getHtmlLabelNames("421",user.getLanguage())+"' column='phone' display = 'false'  orderkey='t1.phone' target='_blank'/>"+
        "<col name='source' width='10%' text='"+SystemEnv.getHtmlLabelNames("645",user.getLanguage())+"' column='source' transmethod='weaver.crm.Maint.ContactWayComInfo.getContactWayname' display = 'false'  orderkey='t1.source' target='_blank'/>"+
        "<col name='sector' width='10%' text='"+SystemEnv.getHtmlLabelNames("575",user.getLanguage())+"' column='sector' display = 'false' transmethod='weaver.crm.Maint.SectorInfoComInfo.getSectorInfoname' orderkey='t1.sector' target='_blank'/>"+
        "<col name='size_n' width='10%' text='"+SystemEnv.getHtmlLabelNames("576",user.getLanguage())+"' column='size_n' transmethod='weaver.crm.Maint.CustomerSizeComInfo.getCustomerSizename' display = 'false'  orderkey='t1.size_n' target='_blank'/>"+
        "<col name='type' width='10%' text='"+SystemEnv.getHtmlLabelNames("63",user.getLanguage())+"' column='type' transmethod='weaver.crm.Maint.CustomerTypeComInfo.getCustomerTypename' orderkey='t1.type' target='_blank'/>"+
        "<col name='description' width='10%' text='"+SystemEnv.getHtmlLabelNames("433",user.getLanguage())+"' column='description' transmethod='weaver.crm.Maint.CustomerDescComInfo.getCustomerDescname' display = 'false'  orderkey='t1.description' target='_blank'/>"+
        "<col name='status' width='10%' text='"+SystemEnv.getHtmlLabelNames("602",user.getLanguage())+"' column='status' transmethod='weaver.crm.Maint.CustomerStatusComInfo.getCustomerStatusname' orderkey='t1.status' target='_blank'/>"+
        "<col name='rating' width='10%' text='"+SystemEnv.getHtmlLabelNames("139",user.getLanguage())+"' column='rating' transmethod='weaver.crm.Maint.CustomerRatingComInfo.getCustomerRatingname' display = 'false'  orderkey='t1.rating' target='_blank'/>"+
        "<col name='city' width='10%' text='"+SystemEnv.getHtmlLabelNames("493",user.getLanguage())+"' column='city' transmethod='weaver.hrm.city.CityComInfo.getCityname' orderkey='t1.city' target='_blank'/>"+
        "<col name='province' width='10%' text='"+SystemEnv.getHtmlLabelNames("800",user.getLanguage())+"' column='province' transmethod='weaver.hrm.province.ProvinceComInfo.getProvincename' display = 'false'  orderkey='t1.province' target='_blank'/>"+
        "<col name='county' width='10%' text='"+SystemEnv.getHtmlLabelNames("644",user.getLanguage())+"' column='county' display = 'false'  orderkey='t1.county' target='_blank'/>"+
        "<col name='manager' width='10%' text='"+SystemEnv.getHtmlLabelNames("1278",user.getLanguage())+"' column='manager' transmethod='weaver.hrm.resource.ResourceComInfo.getResourcename' href='/hrm/resource/HrmResource.jsp' linkkey='id' orderkey='t1.manager' target='_blank'/>"+
        "<col name='department' width='10%' text='"+SystemEnv.getHtmlLabelNames("144,124",user.getLanguage())+"' column='department' transmethod='weaver.hrm.company.DepartmentComInfo.getDepartmentname' href='/hrm/company/HrmDepartmentDsp.jsp' linkkey='id' display = 'false'  orderkey='t1.department' target='_blank'/>"+
        "<col name='firstname' width='10%' text='"+SystemEnv.getHtmlLabelNames("25034",user.getLanguage())+"' column='id' transmethod='weaver.crm.Maint.CRMTransMethod.getContacterFirstname'/>"+
        "<col name='jobtitle' width='10%' text='"+SystemEnv.getHtmlLabelNames("6086",user.getLanguage())+"' column='id' transmethod='weaver.crm.Maint.CRMTransMethod.getContacterJobtitle' display = 'false'/>"+
        "<col name='phoneoffice' width='10%' text='"+SystemEnv.getHtmlLabelNames("661",user.getLanguage())+"' column='id' transmethod='weaver.crm.Maint.CRMTransMethod.getContacterPhoneoffice' display = 'false' />"+
        "<col name='mobilephone' width='10%' text='"+SystemEnv.getHtmlLabelNames("620",user.getLanguage())+"' column='id' transmethod='weaver.crm.Maint.CRMTransMethod.getContacterMobilephone'/>"+
        "<col name='email' width='10%' text='"+SystemEnv.getHtmlLabelNames("477",user.getLanguage())+"' column='id' transmethod='weaver.crm.Maint.CRMTransMethod.getContacterEmail'/>"+
        "</head>";
        tableString+=operateString;
        tableString+="</table>";
        
        //System.out.println("select "+backFields+" "+sqlFrom+" where "+sqlWhere);  
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.CRM_CustomerList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  /> 
 </form> 
</body>
</html>