<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContractTypeComInfo" class="weaver.crm.Maint.ContractTypeComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(136,user.getLanguage());
String needfav ="1";
String needhelp ="";


int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String typeId=Util.fromScreen(request.getParameter("typeId"),user.getLanguage());
 
String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t2.startDate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t2.startDate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t2.startDate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t2.startDate<='"+enddate+"'";
}

if(!preyield.equals("")){
	sqlwhere+=" and t2.price >="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and t2.price <="+preyield_1;
}
if(!(typeId.equals("")||typeId.equals("0"))){
	sqlwhere+=" and t2.typeId ="+typeId;
}



%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >
<form name=frmmain id=weaver method=post action="SellClientRpSumChild.jsp">
<wea:layout type="4Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
	
	    <%if(!user.getLogintype().equals("2")){%>
		    <wea:item><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></wea:item>
		    <wea:item>
		    	<brow:browser viewType="0" name="viewer" 
				     browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				     browserValue='<%=resource+""%>' 
				     browserSpanValue = '<%=resourcename%>'
				     isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
				     completeUrl="/data.jsp" width="150px" ></brow:browser>
		    </wea:item>
	    <%}%>
	
	    <wea:item><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></wea:item>
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
			    <BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="fromdate" value=<%=fromdate%>>
			    －
			    <BUTTON class=calendar type="button" id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="enddate" value=<%=enddate%>>
		    </span>  
	    </wea:item>
	    
	    <wea:item><%=SystemEnv.getHtmlLabelName(6083,user.getLanguage())%></wea:item>
		<wea:item>
			<select text class=InputStyle id=typeId name=typeId style="width: 100px;">
				<option value=0 <%if(typeId.equals("")||typeId.equals("0")){%> selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<%while(ContractTypeComInfo.next()){ %>
					<option value=<%=ContractTypeComInfo.getContractTypeid()%>  
						<%if(typeId.equals(ContractTypeComInfo.getContractTypeid())){%> selected <%}%>><%=ContractTypeComInfo.getContractTypename()%>
					</option>
				<%}%>
			</select>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(6146,user.getLanguage())%>  </wea:item>
		<wea:item>
			<INPUT text class=InputStyle maxLength=20 size=12 id="preyield" name="preyield" style="width: 80px"   
				onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>">
			-
			<INPUT text class=InputStyle maxLength=20 size=12 id="preyield_1" name="preyield_1"  style="width: 80px"    
				onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>">
		</wea:item>    
	
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel"  onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>

<%
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	String orderby = "crmid";
	String fromSql = "CRM_CustomerInfo  t1,CRM_Contract  t2 ,"+leftjointable+" t3";
	String backfields = "t1.id as crmid,sum(t2.price)  resultcount,count(distinct t2.id) conids";
	String sqlWhere = "t2.crmId = t3.relateditemid and  t1.id=t2.crmId and t2.status >=2"+sqlwhere;
	String groupby = "t1.id";
	
	
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPCustomerMoney+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPCustomerMoney,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlgroupby=\""+groupby+"\"  sumColumns=\"resultcount\" />"+
    "<head>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(136,user.getLanguage()) +"\" column=\"crmid\""+
		" href=\"/CRM/data/ViewCustomer.jsp\" linkkey=\"CustomerID\" linkvaluecolumn=\"crmid\" target=\"_blank\""+
		" transmethod=\"weaver.crm.Maint.CustomerInfoComInfo.getCustomerInfoname\"/>"+ 
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15253,user.getLanguage()) +"\" column=\"conids\""+ 
   		" href=\"/CRM/report/ContractReport.jsp\" linkkey=\"customer\" linkvaluecolumn=\"crmid\" target=\"_blank\"/>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(534,user.getLanguage()) +"\" column=\"resultcount\"/>"+ 
   	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31143,user.getLanguage()) +"\" column=\"resultcount\" "+
		" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\""+
		" molecular=\"resultcount\" denominator=\"sum:resultcount\"/>"+
	"</head>"+   			
	"</table>";
	
	 // System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlWhere+" group by "+groupby);
	
%>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPCustomerMoney%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
  </BODY>
<script type="text/javascript">

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

function doSearch(){
  jQuery("#weaver").submit();
}

function comparenumber(){
    if((document.frmmain.preyield.value != "")&&(document.frmmain.preyield_1.value != "")) {
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
    if(lownumber > highnumber){
        alert("<%=SystemEnv.getHtmlLabelName(15254,user.getLanguage())%>！");
    }
    }
}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
</script>
</HTML>