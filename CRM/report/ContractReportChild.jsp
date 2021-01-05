<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet_count" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="ContacterShareBase" class="weaver.crm.ContacterShareBase" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(614,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.frmmain.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
//add by xhheng @20050128 for TD 1415
RCMenu += "{"+"Excel,javascript:ContractExport(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
%>

<%
int resource=Util.getIntValue(request.getParameter("viewer"),0);
int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getPerpageLog();
if(perpage<=1 )	perpage=10;
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));

String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
String province=Util.fromScreen(request.getParameter("province"),user.getLanguage());
String city=Util.fromScreen(request.getParameter("city"),user.getLanguage());

int sign = Util.getIntValue(request.getParameter("sign"),-1);
int ViewType = Util.getIntValue(request.getParameter("ViewType"),0);
String parentid=Util.fromScreen(request.getParameter("parentid"),user.getLanguage());
String ProjID=Util.fromScreen(request.getParameter("ProjID"),user.getLanguage());

//out.print(sign);
String sqlwhere="where t1.id != 0";
String sqlstr ="";

if(sign==30){
	sqlwhere+=" and t1.status >=2 ";
}
/*
if(sign!=-1){
	sqlwhere+=" and t1.id  in("+conids+")";
}
*/
if(!parentid.equals("")){
	sqlwhere+=" and t3.parentid="+parentid;
}
if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.startDate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.startDate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t1.startDate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t1.startDate<='"+enddate+"'";
}

if(!customer.equals("")){
	sqlwhere+=" and t1.crmId="+customer;
}

if(!status.equals("")) {
	sqlwhere+=" and t1.status="+status;
}

if(!preyield.equals("")){
	sqlwhere+=" and t1.price>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t1.price<="+preyield_1;
}


if(!department.equals("")) {
	sqlwhere+=" and t3.department="+department;
}

if(!province.equals("")){
	sqlwhere+=" and t3.province="+province;
}
if(!city.equals("")){
	sqlwhere+=" and t3.city="+city;
}
if(!ProjID.equals("")){
	sqlwhere+=" and t1.projid="+ProjID;
}

String orderStr = "";
String orderStr1 = "";
if (ViewType == 0 ) {orderStr = "  order by t1.startDate desc "; orderStr1 = "  order by startDate asc ";}
if (ViewType == 1 ) {orderStr = "  order by t1.manager asc "; orderStr1 = "  order by manager desc "; }

//add by xhheng @20050201 for TD 1415
session.setAttribute("sqlwhere",sqlwhere);
session.setAttribute("orderStr",orderStr);
session.setAttribute("orderStr1",orderStr1);
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="ContractExport()" type="button"  value="<%=SystemEnv.getHtmlLabelName(28343,user.getLanguage()) %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>


<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<form id=frmmain name=frmmain method=post action="ContractReportChild.jsp">
<input type=hidden id=pagenum name=pagenum value="<%=pagenum%>">
<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	
	<%if(!user.getLogintype().equals("2")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="viewer" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		     browserValue='<%=resource+""%>' 
		     browserSpanValue = '<%=Util.toScreen(resourcename,user.getLanguage())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp" width="150px" ></brow:browser>
		
		</wea:item>
  	<%}%>

	    <wea:item><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>  </wea:item>
	    <wea:item>
	    	<INPUT class=InputStyle maxLength=50 size=6 id="preyield" name="preyield" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")' value="<%=preyield%>" style="width: 80px;">
	     	-
	     	<INPUT class=InputStyle maxLength=50 size=6 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1")' value="<%=preyield_1%>" style="width: 80px;">
	    </wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
	    <wea:item>
		    <select class=InputStyle id=status  name=status style="width: 100px;">
			    <option value="" <%if(status.equals("")){%> selected <%}%> ></option>
			    <option value=0 <%if(status.equals("0")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></option>
			    <option value=-1 <%if(status.equals("-1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage())%></option>
			    <option value=1 <%if(status.equals("1")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%></option>
			    <option value=2 <%if(status.equals("2")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(6095,user.getLanguage())%></option>
				<option value=3 <%if(status.equals("3")){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></option>
			</select>
	    </wea:item>
	
	    <wea:item><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<brow:browser viewType="0" name="customer" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
			     browserValue='<%=customer+""%>' 
			     browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customer),user.getLanguage())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>
	  	</wea:item>
	
	
	    <wea:item><%=SystemEnv.getHtmlLabelName(1936,user.getLanguage())%></wea:item>
	    <wea:item>
        	<span>
	        	<SELECT  name="datetype" id="datetype" onchange="onChangetype(this)" style="width: 100px;">
				  <option value="" 	<%if(datetype.equals("")){%> selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				  <option value="1" <%if(datetype.equals("1")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
				  <option value="2" <%if(datetype.equals("2")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
				  <option value="3" <%if(datetype.equals("3")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
				  <option value="4" <%if(datetype.equals("4")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
				  <option value="5" <%if(datetype.equals("5")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
				  <option value="6" <%if(datetype.equals("6")){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
				</SELECT>     
			</span>
		        
        	<span id="dateTd" style="margin-left: 10px;padding-top: 5px;">
		    	<BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;<SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
		        <input type="hidden" name="fromdate" value=<%=fromdate%>>
		         －
		        <BUTTON type="button" class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;<SPAN id=enddatespan >
		        <%=Util.toScreen(enddate,user.getLanguage())%></SPAN><input type="hidden" name="enddate" value=<%=enddate%>>
		    </span>
	    </wea:item>
	    
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="department" 
			     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			     browserValue='<%=department+""%>' 
			     browserSpanValue = '<%=Util.toScreen(DepartmentComInfo.getDepartmentname(department),user.getLanguage())%>'
			     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			     completeUrl="/data.jsp?type=4" width="150px" ></brow:browser>
		</wea:item>
	
		<wea:item> <%=SystemEnv.getHtmlLabelName(643,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="province" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/province/ProvinceBrowser.jsp"
		     browserValue='<%=province+""%>' 
		     browserSpanValue = '<%=ProvinceComInfo.getProvincename(province)%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=2222" width="150px" ></brow:browser>
		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
		<wea:item>  
		  <brow:browser viewType="0" name="city" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/city/CityBrowser.jsp"
		     browserValue='<%=city+""%>' 
		     browserSpanValue = '<%=CityComInfo.getCityname(city)%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=58" width="150px" ></brow:browser>
		</wea:item>
		<wea:item> <%=SystemEnv.getHtmlLabelName(591,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="parentid" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp"
		     browserValue='<%=parentid+""%>' 
		     browserSpanValue = '<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(parentid),user.getLanguage())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=7" width="150px" ></brow:browser>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="ProjID" 
		     browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp"
		     browserValue='<%=ProjID+""%>' 
		     browserSpanValue = '<%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(ProjID),user.getLanguage())%>'
		     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
		     completeUrl="/data.jsp?type=8" width="150px" ></brow:browser>
		</wea:item>
	</wea:group>
	
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
	String  tableString  =  "";
	String  backfields  =  "t1.id, t1.crmid, t1.typeid, t1.price, t1.status, t1.name, t1.manager, t1.startdate ";
	String  fromSql  = "";
    String sqlmei = "";
    if(user.getLogintype().equals("1")){
        fromSql=" CRM_Contract  t1,"+ContacterShareBase.getTempTable(user.getUID()+"")+"  t2 ,CRM_CustomerInfo  t3 ";
        sqlmei=" and t1.crmId = t3.id and t1.id = t2.relateditemid ";
    }else{
        fromSql=" CRM_Contract  t1,CRM_CustomerInfo  t3 ";
        sqlmei=" and t1.crmId = t3.id and t1.crmId="+user.getUID();
    }
	String orderby  =  "t1.startdate";
	if(!sqlwhere.equals("")){
		sqlwhere += sqlmei;
	}
    tableString =" <table instanceid=\"workflowRequestListTable\" tabletype=\"none\" pageId=\""+PageIdConst.CRM_RPContractList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPContractList,user.getUID(),PageIdConst.CRM)+"\" >"+
		 "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\"  sqlisdistinct=\"true\"  />"+
		 "<head>";
	tableString+="<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\"  column=\"id\" orderkey=\"t1.name\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getContractName\" otherpara=\"column:crmid\"/>";
	tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(6083,user.getLanguage())+"\" column=\"typeid\" orderkey=\"t1.typeid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getTypeName\"/>";
	       tableString+="<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(614,user.getLanguage())+SystemEnv.getHtmlLabelName(534,user.getLanguage())+"\"  column=\"price\" orderkey=\"t1.price\"/>";
	       tableString+="<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getStatus\" otherpara=\""+user.getLanguage()+"\"/>";
	       tableString+="<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(136,user.getLanguage())+"\" column=\"crmid\" orderkey=\"t1.crmid\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getCRMName\"/>";
	       tableString+="<col width=\"8%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" column=\"manager\" orderkey=\"t1.manager\" transmethod=\"weaver.crm.report.CRMContractTransMethod.getResourceName\"/>";
	       tableString+="<col width=\"12%\" text=\""+SystemEnv.getHtmlLabelName(1936,user.getLanguage())+"\" column=\"startdate\" orderkey=\"t1.startdate\"/>";
	       tableString+="</head>";
	     tableString+="</table>";
        %>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPContractList%>">
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
<iframe id="searchexport" style="display:none"></iframe>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>

<SCRIPT language="javascript">
function OnSubmit(pagenum){
    document.frmmain.pagenum.value = pagenum;
	document.frmmain.submit();
}

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
	if("<%=datetype%>" == 6){
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
	
function comparenumber(){
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
}

function ContractExport(){
    _xtable_getAllExcel();
}
function showInfo(contractId){
    var diag =new window.top.Dialog();
    diag.Title='查看合同信息';
    diag.URL = "/CRM/data/ContractView.jsp?isfromtab=false&id="+contractId+"&"+new Date().getTime();
    diag.ShowButtonRow=false;
    diag.Height =420;
    diag.Width =680;
    diag.show();
    document.body.click();
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
