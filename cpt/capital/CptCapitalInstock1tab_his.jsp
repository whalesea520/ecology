<%@page import="weaver.filter.XssUtil"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@page import="weaver.cpt.util.CommonShareManager"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("CptCapital:InStock", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String nameQuery = Util.null2String(request.getParameter("flowTitle"));

String buyerid = Util.null2String(request.getParameter("buyerid"));
String selectdate = Util.null2String(request.getParameter("selectdate"));
String selectdate1 = Util.null2String(request.getParameter("selectdate1"));
String checkerid = Util.null2String(request.getParameter("checkerid"));
String stockindate2 = Util.null2String(request.getParameter("stockindate2"));
String stockindate1 = Util.null2String(request.getParameter("stockindate1"));
String ischecked = Util.null2String(request.getParameter("ischecked"));
String contractno = Util.null2String(request.getParameter("contractno"));
String customerid = Util.null2String(request.getParameter("customerid"));

String sqlWhere = " where d.cptstockinid=m.id  and m.buyerid in(" +new CommonShareManager().getContainsSubuserids(""+ user.getUID())+")  ";
if(!"".equals(nameQuery)){
	//sqlWhere+=" and name like '%"+nameQuery+"%'";
}

if(!"".equals(buyerid)){
	sqlWhere+=" and m.buyerid='"+buyerid+"' ";
}
if(!"".equals(selectdate)){
	sqlWhere+=" and d.SelectDate>='"+selectdate+"' ";
}
if(!"".equals(selectdate1)){
	sqlWhere+=" and d.SelectDate<='"+selectdate1+"' ";
}
if(!"".equals(checkerid)){
	sqlWhere+=" and m.checkerid='"+checkerid+"' ";
}
if(!"".equals(stockindate2)){
	sqlWhere+=" and m.stockindate>='"+stockindate2+"' ";
}
if(!"".equals(stockindate1)){
	sqlWhere+=" and m.stockindate<='"+stockindate1+"' ";
}
if(!"".equals(ischecked)){
	sqlWhere+=" and m.ischecked='"+ischecked+"' ";
}
if(!"".equals(contractno)){
	sqlWhere+=" and d.contractno like '%"+contractno+"%' ";
}
if(!"".equals(customerid)){
	sqlWhere+=" and d.customerid='"+customerid+"' ";
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script src="/cpt/js/myobserver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptcapitalinstock1tab_his"));
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelNames("20839,33110",user.getLanguage())+",javascript:batchInstock(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span id="advancedSearch" class="advancedSearch" style="display:;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">

<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage()) %>'>
	    <wea:item><%=SystemEnv.getHtmlLabelNames("913",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser  name="buyerid" browserValue='<%=buyerid %>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename (buyerid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="selectdate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="selectdate" value="<%=selectdate %>">
			    <input class=wuiDateSel  type="hidden" name="selectdate1" value="<%=selectdate1 %>">
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("901",user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser  name="checkerid" browserValue='<%=checkerid %>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename (checkerid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
		<wea:item>
			<span class="wuiDateSpan" selectId="stockindate_sel" selectValue="">
			    <input class=wuiDateSel type="hidden" name="stockindate2" value="<%=stockindate2 %>">
			    <input class=wuiDateSel  type="hidden" name="stockindate1" value="<%=stockindate1 %>">
			</span>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("751,602",user.getLanguage())%></wea:item>
		<wea:item>
			<select name="ischecked" id="ischecked" class="InputStyle">
				<option value="" ><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
				<option value="0" <%="0".equals(ischecked)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("82682",user.getLanguage())%></option>
				<option value="1" <%="1".equals(ischecked)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("82684",user.getLanguage())%></option>
				<option value="-1" <%="-1".equals(ischecked)?"selected":"" %> ><%=SystemEnv.getHtmlLabelNames("27774",user.getLanguage())%></option>
			</select>
		</wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelNames("21282",user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="contractno" id="contractno" class="InputStyle" value="<%=contractno %>" />
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelNames("138",user.getLanguage())%></wea:item>
		<wea:item>
		<%
		String customerbrowurl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere="+new XssUtil().put("where t1.type=2");
		%>
			<brow:browser  name="customerid" browserValue='<%=customerid %>' browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>' browserUrl='<%=customerbrowurl %>' completeUrl="/data.jsp?type=7"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
		</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="toolbar">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
			<input type="button" onclick="resetForm();" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	
</wea:layout>

</div>
<script>
function resetForm(){
	var form= $("#form2");
	//form.find("input[type='text']").val("");
	form.find(".e8_os").find("span.e8_showNameClass").remove();
	form.find(".e8_os").find("input[type='hidden']").val("");
	form.find("select[name!=mouldid]").selectbox("detach");
	form.find("select[name!=mouldid]").val("");
	//form.find("select[name!=mouldid]").trigger("change");
	form.find("span.jNiceCheckbox").removeClass("jNiceChecked");
	beautySelect(form.find("select[name!=mouldid]"));
	form.find(".calendar").siblings("span").html("");
	form.find(".calendar").siblings("input[type='hidden']").val("");
	form.find(".wuiDateSel").val("");
	form.find("input[name=contractno]").val("");
}
</script>
<%

String orderby ="m.id";
String tableString = "";
int perpage=10;                                 
String backfields = "m.ischecked,m.checkerid,m.id,m.id as tmpid,m.buyerid,d.SelectDate,m.stockindate,d.contractno,d.customerid ";
String fromSql  = " CptStockInMain m,CptStockInDetail d ";

tableString =   " <table instanceid=\"CptCapitalAssortmentTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanBatchInstock' />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"m.id\" sqlsortway=\"desc\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("83587",user.getLanguage())+"\" column=\"tmpid\" orderkey=\"tmpid\" transmethod=\"weaver.cpt.util.CapitalTransUtil.getCapitalInstockViewDetail\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("913",user.getLanguage())+"\" column=\"buyerid\" orderkey=\"buyerid\" transmethod=\"weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("901",user.getLanguage())+"\" column=\"checkerid\" orderkey=\"checkerid\" transmethod=\"weaver.cpt.util.CommonTransUtil.getHrmNamesWithCard\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("21282",user.getLanguage())+"\" column=\"contractno\" orderkey=\"contractno\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("16914",user.getLanguage())+"\" column=\"SelectDate\" orderkey=\"SelectDate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("753",user.getLanguage())+"\" column=\"stockindate\" orderkey=\"stockindate\"  />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("83590",user.getLanguage())+"\" column=\"ischecked\" orderkey=\"ischecked\" transmethod=\"weaver.cpt.util.CapitalTransUtil.getCapitalInstockState\" otherpara=\""+user.getLanguage()+"\" />"+
                "           <col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelNames("138",user.getLanguage())+"\" column=\"customerid\" orderkey=\"customerid\" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"  />"+
                "       </head>"+
                "		<operates>"+
                "     <popedom column=\"id\" otherpara=\"column:ischecked\" transmethod='weaver.cpt.util.CapitalTransUtil.getStockinHistoryOperates' ></popedom> "+
                "		<operate href=\"javascript:onViewDetail();\" text=\""+SystemEnv.getHtmlLabelNames("83591",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onReject();\" text=\""+SystemEnv.getHtmlLabelNames("18666",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		<operate href=\"javascript:onReApply();\" text=\""+SystemEnv.getHtmlLabelNames("82690",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
				"		</operates>"+                  
                " </table>";
                
                //out.println("select "+backfields+"\n from "+fromSql+"\n"+sqlWhere);
%>

<wea:SplitPageTag  tableString='<%=tableString %>'  mode="run" />
 
 </form>
<script language="javascript">
function onViewDetail(id){
	if(id){
		var url="/cpt/capital/CptCapitalInstock.jsp?isdialog=1&id="+id+"&from=viewdetail";
		var title="<%=SystemEnv.getHtmlLabelNames("83591",user.getLanguage())%>";
		openDialog(url,title,1000,550);
	}
}

function onReject(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83583",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/capital/CapitalInstock1Operation.jsp",
				{"method":"reject","id":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83585",user.getLanguage())%>",function(){
						try{
							_table.reLoad();
							onViewDetail(id);
							updatecptstockinnum("<%=user.getUID() %>");
						}catch(e){}
					});
				}
			);
			
		});
	}
}

function onReApply(id){
	if(id){
		var url="/cpt/capital/CapitalBlankTab.jsp?title=<%=SystemEnv.getHtmlLabelNames("83586",user.getLanguage())%>&url=/cpt/capital/CptCapitalInstock1tab.jsp?isdialog=1%26id="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83586",user.getLanguage())%>";
		openDialog(url,title,1000,550);
	}
}



 function back()
{
	window.history.back(-1);
}
function onBtnSearchClick(){
	jQuery("#form2").submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
 
</script>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
</HTML>
