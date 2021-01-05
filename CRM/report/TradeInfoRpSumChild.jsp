<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TradeInfoComInfo" class="weaver.crm.Maint.TradeInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(581,user.getLanguage());
String needfav ="1";
String needhelp ="";

String optional="tradeinfo";


int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String datetype = Util.null2String(request.getParameter("datetype"));
String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and t1.manager="+resource;
}
if(!customer.equals("")){
	sqlwhere+=" and t1.id="+customer;
}

if(!"".equals(datetype) && !"6".equals(datetype)){
	sqlwhere += " and t1.createdate >= '"+TimeUtil.getDateByOption(datetype+"","0")+"'";
	sqlwhere += " and t1.createdate <= '"+TimeUtil.getDateByOption(datetype+"","")+"'";
}
if("6".equals(datetype) && !fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if("6".equals(datetype) && !enddate.equals("")){
	sqlwhere+=" and t1.createdate<='"+enddate+"'";
}


%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >	
<form name=frmmain id=weaver method=post action="TradeInfoRpSumChild.jsp">
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
			    <BUTTON type=button class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
			    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="fromdate" value=<%=fromdate%>>
			    －
			    <BUTTON type=button class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
			    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
			    <input type="hidden" name="enddate" value=<%=enddate%>>
		    </span>  
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
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
String orderby = "resultcount";
String fromSql = "CRM_TradeInfo t5 ,(select sum(t2.price) totalmoney ,t1.id customerid from CRM_CustomerInfo t1,CRM_Contract t2 , "+leftjointable+" t3 "+
		" where  t1.id = t3.relateditemid and  t1.id=t2.crmId "+sqlwhere+" group by t1.id )  t4 ";
String backfields = "t5.id ,t5.fullname,t5.rangelower ,t5.rangeupper , count(*) resultcount";
String sqlWhere = "t4.totalmoney >= t5.rangelower AND t4.totalmoney <= t5.rangeupper";
String groupby = "t5.id ,t5.fullname,t5.rangelower ,t5.rangeupper";

String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPSumMoney+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPSumMoney,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  "+
	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t2.id\" sqlsortway=\"Desc\" sqlgroupby=\""+groupby+"\"  sumColumns=\"resultcount\" />"+
"<head>"+
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(581,user.getLanguage()) +SystemEnv.getHtmlLabelName(603,user.getLanguage())+"\" column=\"id\""+
	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getTradeInfoName\" otherpara=\"column:fullname+column:rangelower+column:rangeupper\"/>"+ 
"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(352,user.getLanguage()) +"\" column=\"resultcount\""+ 
	" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getTradeInfoResult\" otherpara=\"column:id\"/>"+ 
	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(31143,user.getLanguage()) +"\" column=\"resultcount\" "+
	" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\""+
	" molecular=\"resultcount\" denominator=\"sum:resultcount\"/>"+
"</head>"+   			
"</table>";
%>

<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPSumMoney%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  </BODY>
  </form>
<script type="text/javascript">
    function doSearch(){
       jQuery("#weaver").submit();
    }
    
    function showDetailInfo(id){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(20323,user.getLanguage()) %>";
		dialog.Width = 800;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = "/CRM/search/SearchOperation.jsp?msg=report&settype=tradeinfo&id="+id;
		dialog.show();
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
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
