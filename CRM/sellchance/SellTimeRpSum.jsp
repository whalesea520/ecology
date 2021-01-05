<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SellfailureComInfo" class="weaver.crm.sellchance.SellfailureComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(2227,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15113,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>

 
<%



int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String customer=Util.fromScreen(request.getParameter("customer"),user.getLanguage());
String preyield=Util.fromScreen(request.getParameter("preyield"),user.getLanguage());
String preyield_1=Util.fromScreen(request.getParameter("preyield_1"),user.getLanguage());
String sellstatusid=Util.fromScreen(request.getParameter("sellstatusid"),user.getLanguage());
String endtatusid=Util.fromScreen(request.getParameter("endtatusid"),user.getLanguage());

String sqlwhere="";

if(resource!=0){
	sqlwhere+=" and creater="+resource;
}
if(!customer.equals("")){
	sqlwhere+=" and customerid="+customer;
}
if(!preyield.equals("")){
	sqlwhere+=" and preyield>="+preyield;
}
if(!preyield_1.equals("")){
	sqlwhere+=" and preyield<="+preyield_1;
}

if(!sellstatusid.equals("")){	
        if(sellstatusid.equals("0")){
        sqlwhere+=" and sellstatusid <> 0";
        }else{
        sqlwhere+=" and sellstatusid="+sellstatusid;
        }
}
if(!endtatusid.equals("")&&!endtatusid.equals("4")){
	sqlwhere+=" and endtatusid ="+endtatusid;
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
			<input class="e8_btn_top middle" onclick="addCRMTimespan()" type="button"  value="<%=SystemEnv.getHtmlLabelName(343,user.getLanguage()) %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;overflow: auto" >
<form id=weaver name=frmmain method=post action="SellTimeRpSum.jsp">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>' >
	<%if (!user.getLogintype().equals("2")) {%>
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

	    <wea:item><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%></wea:item>
	    <wea:item>
	    <select id=sellstatusid name=sellstatusid>
	      	<option value=0 <%if(sellstatusid.equals("")||sellstatusid.equals("0")){%> selected<%}%> ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
		    <%  
		    String theid="";
		    String thename="";
		    String sql_0="select * from CRM_SellStatus ";
		    RecordSetM.executeSql(sql_0);
		    while(RecordSetM.next()){
		        theid = RecordSetM.getString("id");
		        thename = RecordSetM.getString("fullname");
		        if(!thename.equals("")){
		        %>
		    		<option value=<%=theid%>  <%if(sellstatusid.equals(theid)){%> selected<%}%> ><%=thename%></option>
		    	<%}
		    }%>
	    </wea:item>

	    <wea:item><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<INPUT text class=InputStyle maxLength=20 size=12 id="preyield" name="preyield"    onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield");comparenumber()' value="<%=preyield%>" style="width: 150px;">
	     	-
	     	<INPUT text class=InputStyle maxLength=20 size=12 id="preyield_1" name="preyield_1"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield_1");comparenumber()' value="<%=preyield_1%>" style="width: 150px;">
	    </wea:item>  
	</wea:group>
	
	<wea:group context="" attributes="{'Display':'none'}">
		<wea:item type="toolbar">
			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondition()"/>
			<span class="e8_sep_line">|</span>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</wea:item>
	</wea:group>
	
</wea:layout>
</form>
</div>

<%
	
	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
	String isnull = "isnull";
	if(RecordSet.getDBType().equals("oracle")){
		isnull = "nvl";
	}
	
	String fromSql = "";
	String sql="select * from CRM_SelltimeSpan";
	RecordSet.executeSql(sql);
	RecordSet.next();
	int timespan= RecordSet.getInt("timespan");
	int spannum= RecordSet.getInt("spannum");
	
	Calendar calendar = Calendar.getInstance ();//今天的日期
	
	String begindate=""; //定义每个区间段的开始日期
	String enddate ="";  //定义每个区间段的结束日期
	
	
	for(int i=0;i<spannum ; i++){

		begindate = Util.add0(calendar.get(Calendar.YEAR), 4) +"-"+
		        Util.add0(calendar.get(Calendar.MONTH) + 1, 2) +"-"+
		        Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2) ;
		
		calendar.add(Calendar.DATE, timespan) ; //增加天数

		enddate = Util.add0(calendar.get(Calendar.YEAR), 4) +"-"+
		        Util.add0(calendar.get(Calendar.MONTH) + 1, 2) +"-"+
		        Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2) ;
		
		String childSql="select '"+begindate+"--"+enddate+"' as range , "+isnull+"(sum(t1.preyield),0) moneysum_n, "+isnull+"(sum(t1.preyield),0) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+begindate+"' and t1.predate <= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid " + sqlwhere;
		
		if(i == 0){
			fromSql = childSql;
		}else{
			fromSql +=" union all "+childSql;
		}
	}
	
	calendar.add(Calendar.DATE, 1) ;
	enddate = Util.add0(calendar.get(Calendar.YEAR), 4) +"-"+
	          Util.add0(calendar.get(Calendar.MONTH) + 1, 2) +"-"+
	          Util.add0(calendar.get(Calendar.DAY_OF_MONTH), 2) ;
	if(spannum > 0){
		fromSql+=" union all ";
	}
	fromSql +="select '"+enddate+"--"+"' as range,  "+isnull+"(sum(t1.preyield),0) moneysum_n, "+isnull+"(sum(t1.preyield),0) moneysum,count(distinct t1.id) sellnum from CRM_Sellchance t1,"+leftjointable+" t4,CRM_CustomerInfo t3 where t1.endtatusid=0 and t1.predate >= '"+enddate+"' and t3.deleted=0 and t3.id= t1.customerid and t1.customerid = t4.relateditemid "+sqlwhere;
	
	

	
	int pagesize = 10;
	String orderby = "rt.range";
	fromSql = "("+fromSql+") rt";
	String backfields = "rt.*";
	String sqlWhere = "1=1";
	
	String tableString =" <table instanceid=\"info\"  pageId=\""+PageIdConst.CRM_RPTimeLayout+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.CRM_RPTimeLayout,user.getUID(),PageIdConst.CRM)+"\" tabletype=\"none\">"+ 
    "<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlWhere+"\"  "+
    	"sqlorderby=\""+orderby+"\"  sqlprimarykey=\"rt.range\" sqlsortway=\"Desc\" sumColumns=\"moneysum\"/>"+
    "<head>"+
    "<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(277,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(15256,user.getLanguage())+"）"+"\" column=\"range\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15258,user.getLanguage()) +"\" column=\"sellnum\""+ 
		" transmethod=\"weaver.crm.report.CRMReporttTransMethod.getSellChanceInfo\" otherpara=\"column:range\"/>"+ 
	"<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(15259,user.getLanguage()) +"\" column=\"moneysum_n\"/>"+ 	
	"<col width=\"40%\"  text=\""+ SystemEnv.getHtmlLabelName(15260,user.getLanguage()) +"(%)\" column=\"moneysum\" "+
		" algorithmdesc=\""+SystemEnv.getHtmlLabelName(31143,user.getLanguage())+"="+SystemEnv.getHtmlLabelName(136,user.getLanguage())+SystemEnv.getHtmlLabelName(1331,user.getLanguage())+"/"+SystemEnv.getHtmlLabelName(523,user.getLanguage())+"\""+
		" molecular=\"moneysum\" denominator=\"sum:moneysum\"/>"+
	"</head>"+   			
	"</table>";
	
	// System.err.println("select "+backfields+" from "+ fromSql+" where "+sqlWhere);
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.CRM_RPTimeLayout%>">
<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></form>
<script type="text/javascript">
  function doSearch(){
    jQuery("#weaver").submit();
  }

function comparenumber(){
    if((document.frmmain.preyield.value != "")&&(document.frmmain.preyield_1.value != "")) {
    lownumber = eval(toFloat(document.all("preyield").value,0));
    highnumber = eval(toFloat(document.all("preyield_1").value,0));
    if(lownumber > highnumber){
        alert("<%=SystemEnv.getHtmlLabelName(15243,user.getLanguage())%>！");
    }
    }
}


function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}



var dialog = null;
function closeWin(){
	if(dialog){
		dialog.close();
	}
	location.reload();
}

function addCRMTimespan(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(343,user.getLanguage()) %>";
	dialog.Width = 450;
	dialog.Height = 220;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/CRM/sellchance/EditCRMTimespan.jsp";
	dialog.show();
}

$(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:null});
	jQuery("#hoverBtnSpan").hoverBtn();
});

function showDetailInfo(id){
	var begindate = id.substring(id , id.indexOf("--"));
	var enddate = id.substring(id.indexOf("--")+2);
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(2227,user.getLanguage()) %>";
	dialog.Width = 800;
	dialog.Height = 500;
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = "/CRM/sellchance/SellChanceReport.jsp?msg=report&fromdate="+begindate+"&enddate="+enddate+"&viewer=<%=resource%>&customer=<%=customer%>&sellstatusid=<%=sellstatusid%>&preyield=<%=preyield%>&preyield_1=<%=preyield_1%>";
	dialog.show();
}
</script>
</HTML>
