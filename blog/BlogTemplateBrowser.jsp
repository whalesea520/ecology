<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="BlogDao" class="weaver.blog.BlogDao" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<%

String tempName=Util.null2String(request.getParameter("tempName"));
String tempDesc=Util.null2String(request.getParameter("tempDesc"));
String sqlwhere = "";
if(!tempName.equals("")){
	sqlwhere+=" and t1.tempName like '%"+tempName+"%'";
}
if(!tempDesc.equals("")){
	sqlwhere+=" and t1.tempName like '%"+tempDesc+"%'";
}

%>
<BODY scroll="auto">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:btnclear_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
 <jsp:include page="/systeminfo/commonTabHead.jsp">
    <jsp:param name="mouldID" value="blog"/>
    <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(64,user.getLanguage()) %>"/>
 </jsp:include>
<DIV align=right style="display:none">
	<button type="button" class=btnSearch accessKey=S type=submit onclick="document.SearchForm.submit()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
	<button type="button" class=btnReset accessKey=T type=reset onclick="document.SearchForm.reset()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=1 onclick="dialog.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<%


int pagesize = 10;
String backFields = "id , tempName ,tempDesc, isUsed ,userId,tempContent,isSystem,case isSystem when '1' then '"+SystemEnv.getHtmlLabelName(83158,user.getLanguage())+"' else '"+SystemEnv.getHtmlLabelName(83159,user.getLanguage())+"' END isSystem_str";
String sqlFrom = "from blog_template t1 left join "+BlogDao.getTemplateTable(user.getUID()+"")+"t2 on t1.id = t2.tempid";
sqlwhere = "(t1.id = t2.tempid or userId = "+user.getUID()+")"+sqlwhere+" and isUsed = 1";
String orderBy = "isSystem , id";

String tableString="<table   pagesize=\""+pagesize+"\" tabletype=\"none\">";
tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"DESC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
tableString+="<head>";
tableString+="<col hide=\"true\" width=\"5%\" text=\"\" column=\"id\"/>";
tableString+="<col width=\"25%\" transmethod=\"weaver.blog.BlogTransMethod.getBlogTemplateName\" "+
			"text=\""+ SystemEnv.getHtmlLabelName(18151,user.getLanguage()) +"\" column=\"tempName\" orderkey=\"tempName\" otherpara=\"column:id\"/>";
tableString+="<col width=\"30%\" text=\""+ SystemEnv.getHtmlLabelName(18627,user.getLanguage()) +"\" column=\"tempDesc\" orderkey=\"tempDesc\"/>";
tableString+="<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(20622,user.getLanguage()) +"\" column=\"isSystem_str\" orderkey=\"isSystem_str\"/>";
tableString+="<col hide=\"true\" width=\"5%\" text=\"\" column=\"tempContent\"/>";
tableString+="</head>";
tableString+="</table>";
%>
<div class="zDialog_div_content">
<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="BlogTemplateBrowser.jsp" method=post>
<input type="hidden" name="pagenum" value=''>

<wea:layout type="4col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
			<wea:item><input class=InputStyle  name="tempName" id="tempName" value='<%=tempName%>' style="width: 160px;"></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle  name=tempDesc value="<%=tempDesc%>" style="width: 160px;">
			</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'colspan':'full'}">&nbsp;</wea:item>
	</wea:group>
	
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:SplitPageTag tableString='<%=tableString%>'   mode="run" isShowTopInfo="false" />
		</wea:item>
	</wea:group>
	
</wea:layout>
</FORM>
</div>


<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=2  id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnclear_onclick()">
				<input type="button" accessKey=1  id=btnclear value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
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
</BODY></HTML>
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
		var name = jQuery.trim(jQuery(this).find("td:eq(5)").html());
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
</script>
