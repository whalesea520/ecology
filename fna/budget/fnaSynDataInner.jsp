<%@page import="org.apache.commons.lang.StringEscapeUtils"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String userid=""+user.getUID();

if(!HrmUserVarify.checkUserRight("FnaSystemSetEdit:Edit",user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(128636,user.getLanguage());//财务报表权限设置
String needfav ="1";
String needhelp ="";

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<div class="zDialog_div_content">
<form id=form2 name=form2 method=post action="//fna/budget/fnaSynDataInner.jsp">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>
<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
</div>
<%
String tableString = "";
      
String backfields = " a.* ";
String fromSql = " from FnaSynchronized a ";
String sqlWhere = " where 1=1 ";
String orderby = " a.lockDate, a.lockTime ";

String sqlprimarykey = "a.lockGuid";

//out.println("select "+backfields+fromSql+sqlWhere);
tableString =" <table pagesize=\"15\" tabletype=\"none\" >"+
"	   <sql backfields=\""+Util.toHtmlForSplitPage(backfields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" "+
			" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+Util.toHtmlForSplitPage(orderby)+"\" "+
			" sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" sqlisdistinct=\"true\" />"+
"			<head>";
tableString+="				<col width=\"55%\"  text=\"锁定事项\" column=\"memo\" />";//锁定事项
tableString+="				<col width=\"15%\"  text=\"锁定发起人\" column=\"userId\" "+//锁定发起人
	" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\" />";
tableString+="				<col width=\"15%\"  text=\"锁定日期\" column=\"lockDate\" />";//锁定日期
tableString+="				<col width=\"10%\"  text=\"锁定时间\" column=\"lockTime\" />";//锁定时间
tableString+="			</head>";
tableString+="		<operates>";
tableString+="			<operate href=\"javascript:gridRelease();\" text=\"释放锁定\" linkvaluecolumn=\"lockGuid\" linkkey=\"lockGuid\" target=\"_self\" index=\"1\"/>";//释放锁定
tableString+="		</operates>";   
tableString+="</table>";
%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
</form>

<!--   added by xwj for td2023 on 2005-05-20  end  -->
     
<table align=right>
   <tr>
   <td>&nbsp;</td>
   <td>
 <td>&nbsp;</td>
   </tr>
	  </TABLE>
	  
	  </td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>



<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

//页面初始化事件
jQuery(document).ready(function(){
	resizeDialog(document);
});

//关闭
function doClose(){
	parent.btnClose_onclick();
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
	form2.submit();
}

//删除
function gridRelease(lockGuids){
	//确定要删除吗?
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",
		function(){
			gridRelease2(lockGuids);
		}, function(){}
	);
}
function gridRelease2(lockGuids){
	var _data = "operation=releaseSynData&lockGuids="+lockGuids;
	
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	jQuery.ajax({
		url : "/fna/budget/FnaSystemSetEditInnerAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		data : _data,
		dataType : "json",
		success: function do4Success(_json){
		    try{
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(_json.flag){
					window._table.reLoad();
				}else{
					top.Dialog.alert(_json.msg);
				}
		    	showRightMenuIframe();
		    }catch(e1){
		    	showRightMenuIframe();
		    }
		}
	});	
}

</script>
</html>
