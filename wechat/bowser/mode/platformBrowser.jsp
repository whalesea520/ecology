
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String id =Util.null2String(request.getParameter("id"));
//判断是否有分权
String detachable=Util.null2String(session.getAttribute("wechatdetachable")!=null?session.getAttribute("wechatdetachable").toString():"0");

String name = Util.null2String(request.getParameter("name"));
String publicid=Util.null2String(request.getParameter("publicid"));
String appid=Util.null2String(request.getParameter("appId"));
String subcompany= Util.null2String(request.getParameter("subCompanyId"));

String userID = ""+user.getUID();


int perpage=Util.getPerpageLog();
if(perpage<10) perpage=10;
String sqlwhere="where isdelete=0 and state=0 ";
if(name!=null&&!"".equals(name)){
	sqlwhere+=" and name like '%"+name+"%' ";
}
if(publicid!=null&&!"".equals(publicid)){
	sqlwhere+=" and publicid like '%"+publicid+"%' ";
}
if(appid!=null&&!"".equals(appid)){
	sqlwhere+=" and appid like '%"+appid+"%' ";
}
if(subcompany!=null&&!"".equals(subcompany)){
	sqlwhere+=" and subcompanyid in ("+subcompany+") ";
} 
String backFields = " id,name,appid, publicid,subcompanyid";
String sqlFrom = " wechat_platform t1";
String tableString=""+
			  "<table  pagesize=\""+perpage+"\" instanceid=\"platformTable\" tabletype=\"radio\">"+
			  "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"/>"+
			  "<head>"+                             
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"name\" orderkey=\"name\"/>"+//公众平台+名称 
					  ("1".equals(detachable)?"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\"  column=\"subcompanyid\" transmethod=\"weaver.wechat.WechatTransMethod.getSubCompany\"/>":"")+//所属机构
					  "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(613,user.getLanguage())+"ID\"  column=\"publicid\" orderkey=\"publicid\" />"+//原始
					  "<col width=\"20%\"  text=\"AppID\" column=\"appid\" orderkey=\"appid\" />"+
			  "</head>"+
			  "</table>";
 

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32689,user.getLanguage())+SystemEnv.getHtmlLabelName(195,user.getLanguage());
String needfav ="1";
String needhelp ="";
 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetCondtionAVS(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" class="e8_btn_top" onclick="doSearch()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>
 
	


<table width=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="">
<tr>
	<td valign="top">
		<div class="zDialog_div_content" style="overflow:auto;">
		<form id=SearchForm name=SearchForm method=post action="platformBrowser.jsp">
		<input type="hidden" name="id" value="<%=id %>">
			<wea:layout type="4Col">
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
				      <wea:item><%=SystemEnv.getHtmlLabelName(32689,user.getLanguage())%></wea:item>
				      <wea:item>
				          <input type="text" id="name" name="name" value="<%=name%>" class="InputStyle">
				      </wea:item>
				      
				      <wea:item><%=SystemEnv.getHtmlLabelName(613,user.getLanguage())%>ID</wea:item>
				      <wea:item>
				      	<input type="text" id="publicid" name="publicid" value="<%=publicid%>" class="InputStyle">
				      </wea:item>
				      
				      <wea:item>AppID</wea:item>
				      <wea:item>
				        <input type="text" id="appId" name="appId" value="<%=appid%>" class="InputStyle">
				      </wea:item>
				      
				      <%if("1".equals(detachable)){%>
				      <wea:item><%=SystemEnv.getHtmlLabelName(17868,user.getLanguage())%></wea:item>
				      <wea:item>
					  	     <brow:browser viewType="0" temptitle="" name="subCompanyId" browserValue='<%=subcompany %>' 
										browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
										hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1' 
										completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
										browserSpanValue='<%=!"".equals(subcompany)?SubCompanyComInfo.getSubCompanyname(subcompany):"" %>'></brow:browser>
				      </wea:item>
				      <%}else{ %>
				      
				      <wea:item>
				      </wea:item>
				      <%} %>
			     </wea:group>
			     
			     <wea:group context='<%=SystemEnv.getHtmlLabelName(33046,user.getLanguage())%>' attributes="{'groupDisplay':'none','itemAreaDisplay':'inline-block'}" >
				      <wea:item attributes="{'isTableList':'true'}" >
				          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" selectedstrs="<%=id %>"/>
				      </wea:item>
			     </wea:group>
				 
			</wea:layout>
	 	</form>
 		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2Col">
				<!-- 操作 -->
			     <wea:group context="">
			    	<wea:item type="toolbar">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%>" class="e8_btn_submit" onclick="onClear()">
					  <input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" onclick="btn_cancle()">
				    </wea:item>
			    </wea:group>
		    </wea:layout>
		</div>
		 
	</td>
</tr>
</table>
</BODY>
</HTML>

<script language="javascript">
 

 
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}
 
jQuery(document).ready(function(){
	 //alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#_xTable div.table").find("tr[class!='HeaderForXtalbe']").live("click",function(){
		 var id0  = $(this).find("td:first").next().text();
	     id0 = id0.replace("<","&lt;")
	     id0 = id0.replace(">","&gt;")
	     var id=$(this).find("td:first").find("input[type='radio']").attr("radioid");
	     var returnjson= {id:id,name:id0};
		    if(dialog){
		    	dialog.callback(returnjson);
			}else{ 
		    	window.parent.returnValue  = returnjson;
		    	window.parent.close();
		 	} 
	});
});

var checkids="";
var checknames="";

function btn_cancle(){
	dialog.close();
}

function onClear()
{
    var returnjson= {id:"",name:""};
    if(dialog){
    	dialog.callback(returnjson);
	}else{ 
    	window.parent.returnValue  = returnjson;
    	window.parent.close();
 	}
}

function doSubmit()
{
	checkids=_xtalbe_radiocheckId;
    checknames=$('#_xTable_'+checkids).parent().next().html();
    var returnjson= {id:checkids,name:checknames};
    if(dialog){
    	dialog.callback(returnjson);
	}else{ 
    	window.parent.returnValue  = returnjson;
    	window.parent.close();
 	}
 
}

function doSearch()
{
    document.SearchForm.submit();
}

function resetCondtionAVS(){
	$('#name').val("");
	$('#publicid').val("");
	$('#appId').val("");
	
	$('#subCompanyId').val("");
	$('#subCompanyIdspan').html("");
	
}
 
function preDo(){
	//tabSelectChg();
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#hoverBtnSpan").hoverBtn();
}
function onBtnSearchClick(){
	var name=$("input[name='t_name']",parent.document).val();
	$("#name").val(name);
	doSearch();
}  
</script>
