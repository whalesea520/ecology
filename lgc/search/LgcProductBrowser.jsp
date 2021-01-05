
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="LgcAssortmentComInfo" class="weaver.lgc.maintenance.LgcAssortmentComInfo" scope="page"/>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%
String assetname=Util.fromScreen(request.getParameter("assetname"),user.getLanguage());
String assortmentid=Util.fromScreen(request.getParameter("assortmentid"),user.getLanguage());
String assortmentname = "" ;
if(assortmentid.equals("0")){
	assortmentid="";
}
if(!assortmentid.equals(""))  assortmentname=Util.toScreen(LgcAssortmentComInfo.getAssortmentName(assortmentid),user.getLanguage());
String sqlwhere="";

if(!assetname.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t2.assetname like '%"+assetname+"%'";
	else 	sqlwhere+=" and t2.assetname like '%"+assetname+"%'";
}
if(!assortmentid.equals("")){
	if(sqlwhere.equals(""))	sqlwhere+=" where t1.assortmentstr like '%|"+assortmentid+"|%'";
	else 	sqlwhere+=" and t1.assortmentstr like '%|"+assortmentid+"|%'";
}
if(sqlwhere.equals("")){
		sqlwhere += " where t1.id != 0 " ;
}
sqlwhere +=" and t1.id=t2.assetid ";
String backfields = "t2.assetid,t2.assetname,t1.assetunitid,t2.currencyid,t2.salesprice,t1.assortmentid,t1.assortmentstr";
String fromSql="LgcAsset t1,LgcAssetCountry t2";
String orderby = "t1.assortmentstr,t2.assetname";
int pagesize = 10;
String tableString =" <table instanceid='BrowseTable' tabletype='none' pagesize=\""+pagesize+"\">"+ 
"<sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+sqlwhere+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t2.assetid\" sqlsortway=\"Desc\"/>"+
"<head>"+
"<col hide=\"true\" width=\"5%\" text=\"\" column=\"assetid\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(15129,user.getLanguage()) +"\" orderkey=\"assetname\" column=\"assetname\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(705,user.getLanguage()) +"\" orderkey=\"assetunitid\" column=\"assetunitid\" transmethod=\"weaver.lgc.maintenance.AssetUnitComInfo.getAssetUnitname\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(649,user.getLanguage()) +"\" orderkey=\"currencyid\" column=\"currencyid\" transmethod=\"weaver.fna.maintenance.CurrencyComInfo.getCurrencyname\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(726,user.getLanguage()) +"\" orderkey=\"salesprice\" column=\"salesprice\" transmethod=\"weaver.general.Util.getPointValue\"/>"+ 
"<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(63,user.getLanguage()) +"\" orderkey=\"assortmentid\" column=\"assortmentid\" transmethod=\"weaver.lgc.maintenance.LgcAssortmentComInfo.getAssortmentFullName\"/>"+ 
"</head>"+   			
"</table>";
%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:resetInfo(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<BODY>

<BODY scroll="auto">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("6166",user.getLanguage()) %>'/>
</jsp:include>

<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>

<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="LgcProductBrowser.jsp" method=post>
  <input type="hidden" name="pagenum" value=''>
  <wea:layout type="4col" attributes="{'expandAllGroup':'true'}">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser viewType="0" name="assortmentid" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp"
			         browserValue='<%=assortmentid%>' 
			         browserSpanValue = '<%=assortmentname%>'
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
			         completeUrl="/data.jsp?type=-99994" width="150px" ></brow:browser>
			</wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
			  <INPUT class=InputStyle maxLength=50 size=30 name="assetname" value="<%=assetname%>">
			</wea:item>
		</wea:group>
  </wea:layout>
  <div id="e8resultArea">
	<wea:SplitPageTag tableString='<%=tableString%>' mode="run" isShowTopInfo="true" />
</div>	
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){}

jQuery(function(){
	jQuery(".ListStyle").find("tbody tr").live('click',function(){
		var id = jQuery.trim(jQuery(this).find("td:eq(1)").html());
		var name = jQuery.trim(jQuery(this).find("td:eq(2)").html());
		var returnValue = {id:id,name:name};
		if(dialog){
			try{
	            dialog.callback(returnValue);
	      	}catch(e){}
	      	 
		  	try{
		       dialog.close(returnValue);
		   }catch(e){}
		}else{
     		window.parent.parent.returnValue = returnValue;
	 		window.parent.parent.close();
		}
		
	});
});

function btnclear_onclick(){
    var returnValue = {id:"",name:""};
	if(dialog){
		try{
            dialog.callback(returnValue);
       }catch(e){}
	  	try{
	       dialog.close(returnValue);
	   }catch(e){}
	}else{
		window.parent.returnValue = returnValue;
		window.parent.close();
	}
}

function resetInfo(){
	resetCondition();
	jQuery("#assortmentid").val("");
	jQuery("#assortmentidspan").find("a").html("");
	document.SearchForm.reset()
}
</script>
</BODY></HTML>
