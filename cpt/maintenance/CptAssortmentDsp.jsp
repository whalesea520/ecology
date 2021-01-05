<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PropUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />

<%
boolean canedit = HrmUserVarify.checkUserRight("CptCapitalGroupEdit:Edit", user) ;
if(!canedit ){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);
boolean isroot=parentid<=0;
int data1count=Util.getIntValue( CapitalAssortmentComInfo.getCapitalCount(parentid+""),0);

//判断资产组的资产资料个数是否和实际的是否一致20180224
if(data1count>0){
	RecordSet.executeSql("select id from cptcapital where isdata =1 and capitalgroupid ="+parentid);
	if(RecordSet.next()){
		RecordSet1.executeSql("select count(1) as num from cptcapital where isdata =1 and capitalgroupid ="+parentid);
		RecordSet1.next();
        int num = RecordSet1.getInt(1);
        if(num!=data1count){
        	RecordSet.executeSql("update CptCapitalAssortment set capitalcount="+num+" where id ="+parentid);
        }
	}else{
		data1count=0;
		RecordSet.executeSql("update CptCapitalAssortment set capitalcount=0 where id ="+parentid);
	}
}//end20180224

int subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
int subcompanyid1=Util.getIntValue(request.getParameter("subcompanyid1"),0);
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

String assortmentid = ""+parentid;
RecordSet.executeProc("CptCapitalAssortment_SByID",assortmentid);
RecordSet.next();

String assortmentname = RecordSet.getString("assortmentname");
String assortmentmark = RecordSet.getString("assortmentmark");
String supassortmentid = RecordSet.getString("supassortmentid");
String supassortmentstr = RecordSet.getString("supassortmentstr");
String assortmentremark= RecordSet.getString("assortmentremark");
String subassortmentcount= RecordSet.getString("subassortmentcount");
String capitalcount= RecordSet.getString("capitalcount");
String roleid= RecordSet.getString("roleid");

//System.out.println("isroot:"+isroot);
String pageId=Util.null2String(PropUtil.getPageId("cpt_cptassortmentdsp"));
%>

<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script language="javascript">



function OpenNewWindow(sURL,w,h)
{
  var iWidth = 0 ;
  var iHeight = 0 ;
  iWidth=(window.screen.availWidth-10)*w;
  iHeight=(window.screen.availHeight-50)*h;
  ileft=(window.screen.availWidth - iWidth)/2;
  itop= (window.screen.availHeight - iHeight + 50)/2;
  var szFeatures = "" ;
  szFeatures =	"resizable=no,status=no,menubar=no,width=" +
				iWidth + ",height=" + iHeight*h + ",top="+itop+",left="+ileft
  window.open(sURL,"",szFeatures)
}

</script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<% 

if(canedit&&data1count<=0) {
    RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addSub("+parentid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    
}
if(canedit){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("32136",user.getLanguage())+",javascript:batchDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}


/**
if(HrmUserVarify.checkUserRight("CptAssortment:Log", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid="+parentid+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
**/
%>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name="form2" method="post"  action="">
<input type="hidden" name="pageId" id="pageId" value="<%=pageId  %>" />
<input type="hidden" name="isroot" value="<%=isroot %>" />
<input type="hidden" name="paraid" value="<%=parentid %>" />
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%
		if(canedit&&data1count<=0){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("82",user.getLanguage())%>" class="e8_btn_top" onclick="addSub(<%=parentid %>);"/>
			<%
		}
		if(canedit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("32136",user.getLanguage())%>" class="e8_btn_top" onclick="batchDel()"/>
			<%
		}
		
		%>
		
			<input type="text" class="searchInput" name="flowTitle"  value="<%=nameQuery %>" />
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
	<table class="viewForm">
      <TR>
    	  <td></td>
    	  <td class=Field><select class=inputstyle  name=typeid onChange="wfSearch()" >
    	  	<option value="0">&nbsp;</option>
    	  </select></td>
          <td></td>
          <td class=Field><input type="text" class=inputstyle name="wfnameQuery" size="30" value=""></td>  	  
    	  </TR>
    	<tr>
	    <td  colspan="4" class="btnTd">
			<input type="submit" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" class="e8_btn_submit" />
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("201",user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
		</td> 
		</tr>
	</table>
</div>	


<%

String popedomOtherpara="";

//操作列参数
JSONObject operatorInfo=new JSONObject();
operatorInfo.put("userid", user.getUID());
operatorInfo.put("usertype", user.getLogintype());
operatorInfo.put("languageid", user.getLanguage());
operatorInfo.put("operatortype", "cpt_cptassortment");//操作项类型
operatorInfo.put("operator_num", 5);//操作项数量
operatorInfo.put("operator_val", popedomOtherpara);

operatorInfo.put("isroot", isroot);

String sqlWhere = " where supassortmentid="+parentid;

if(!"".equals(nameQuery)){
	sqlWhere+=" and assortmentname like '%"+nameQuery+"%'";
}


if(subcompanyid1>0) {
    sqlWhere+=" and subcompanyid1="+subcompanyid1;
}
String orderby =" assortmentmark ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,assortmentname,assortmentmark ";
String fromSql  = " CptCapitalAssortment ";

tableString =   " <table  pageId=\""+pageId+"\"  instanceid=\"CptCapitalAssortmentTable\" tabletype=\"checkbox\"  pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"cpt")+"\"  >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\"column:id\" showmethod='weaver.cpt.util.CapitalTransUtil.getCanDelCptAssortment'  />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName( 195 ,user.getLanguage())+"\" column=\"assortmentname\" orderkey=\"assortmentname\" />"+
                "           <col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName( 714 ,user.getLanguage())+"\" column=\"assortmentmark\" orderkey=\"assortmentmark\" />"+
                "       </head>"+
                "		<operates>"+
                "     <popedom  column='id' otherpara='"+operatorInfo.toString() +"' transmethod='weaver.cpt.util.CapitalTransUtil.getOperates'  ></popedom> "+
	                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelNames("93",user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
					"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelNames("91",user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
					"		<operate href=\"javascript:onLog();\" text=\""+SystemEnv.getHtmlLabelNames("83",user.getLanguage())+"\" target=\"_self\" index=\"2\"/>"+
					"		<operate href=\"javascript:addSub();\" text=\""+SystemEnv.getHtmlLabelNames("18423",user.getLanguage())+"\" target=\"_self\" index=\"3\"/>"+
				"		<operate href=\"javascript:onShare();\" text=\""+SystemEnv.getHtmlLabelNames("2112",user.getLanguage())+"\" target=\"_self\" index=\"4\"/>"	+
				"		</operates>"+                  
                " </table>";
%>

<!-- listinfo -->
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />


</form>

<script language="javascript">
function submitData()
{
	var wfids = _xtable_CheckedCheckboxId();
	if(wfids=="") return ;
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        form2.action="delwfs.jsp?wfids="+wfids;
			form2.submit();
			enableAllmenu();
				}, function () {}, 320, 90,false);
}


function submitClear()
{
	btnclear_onclick();
}


</script>

<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
function addSub(id){
		if(id==undefined||id==null) id=0;
		var url="/cpt/maintenance/CptAssortmentAdd.jsp?subcompanyid1=<%=subcompanyid1 %>&isdialog=1&paraid="+id;
		var title=id!=0?"<%=SystemEnv.getHtmlLabelNames("18423",user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelNames("83654",user.getLanguage())%>";
		openDialog(url,title,600,368);
}
function onEdit(id){
	if(id){
		var url="/cpt/maintenance/CptAssortmentEdit.jsp?isdialog=1&paraid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83656",user.getLanguage())%>";
		openDialog(url,title,600,368);
	}
}

function onDel(id){
	if(id){
		window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83600",user.getLanguage())%>',function(){
			jQuery.post(
				"/cpt/maintenance/CptAssortmentOperation.jsp",
				{"operation":"deleteassortment","assortmentid":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
						_table.reLoad();
						refreshLeftTree();
					});
					
				}
			);
			
		});
	}
}
function onShare(id){
	if(id){
		var url="/cpt/maintenance/CptAssortmentAddShare.jsp?isdialog=1&assortmentid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83660",user.getLanguage())%>";
		openDialog(url,title,500,290);
	}
}

function onLog(id){
	//var url="/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem = 43 and relatedid="+id;
	var url = "/systeminfo/SysMaintenanceLog.jsp?operateitem=43&relatedid="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("32061",user.getLanguage())%>";
	openDialog(url,title,1000,600,false);
}

function batchDel(){
	var typeids = _xtable_CheckedCheckboxId();
	if(typeids=="") return ;
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83601",user.getLanguage())%>',function(){
		jQuery.post(
			"/cpt/maintenance/CptAssortmentOperation.jsp",
			{"operation":"batchdeleteassortment","assortmentid":typeids},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					_table.reLoad();
					refreshLeftTree();
				});
			}
		);
		
	});
}
function onBtnSearchClick(){
	form2.submit();
}
$(function(){
	var cptgroupname='<%=CapitalAssortmentComInfo.getAssortmentName(""+ parentid) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(16617,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});

$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});

function refreshLeftTree(){
	try{
		var tree= $("#leftframe",parent.parent.document);
		var src=tree.attr("src");
		tree.attr("src",src);
	}catch(e){}
}
</script>

</body>
</html>
