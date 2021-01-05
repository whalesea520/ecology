
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <script type="text/javascript" src="/js/xtree_wev8.js"></script>
	<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
	<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
	<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
	<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%>");//分部
	}catch(e){
		if(window.console)console.log(e+"-->SubcompanyBrower2.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage());//分部
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String excludeid=Util.null2String(request.getParameter("excludeid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String allselect = Util.null2String(request.getParameter("allselect"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
String selectedids = Util.null2String(request.getParameter("selectedids"));

//isedit如果为1则显示具有编辑权限以上的分部    
String isedit = Util.null2String(request.getParameter("isedit"));

String nodeid=null;
/*
Cookie[] cks= request.getCookies();
String rem=null;
for(int i=0;i<cks.length;i++){

if(cks[i].getName().equals("departmentsingle"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>0)
nodeid=rem;

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("dept")>-1){
    String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(!exist)
nodeid=null;
*/

%>


<BODY onload="initTree()">
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span><!-- 确定 -->
			</td>
		</tr>
	</table>
    <DIV align=right>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    BaseBean baseBean_self = new BaseBean();
    int userightmenu_self = 1;
    try{
    	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
    }catch(Exception e){}
    if(userightmenu_self == 1){
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;//确定
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;//取消
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>


<FORM NAME=select STYLE="margin-bottom:0" action="SubcompanyBrowser1.jsp" method=post>
    <input class=inputstyle type=hidden name=type value="<%=type%>">
  <input class=inputstyle type=hidden name=id value="<%=id%>">
  <input class=inputstyle type=hidden name=level value="<%=level%>">
  <input class=inputstyle type=hidden name=subid value="<%=subid%>">
  <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
  <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
  <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
  	 <wea:layout attributes="{'formTableId':'BrowseTable'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
					<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" /> 
	    </wea:item>
	  </wea:group>
	 </wea:layout> 
	</FORM>   
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
  <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"><!-- 确定 -->
				<input type="button" class=zd_btn_submit accessKey=T  id=btncancel onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"><!-- 取消 -->
			</wea:item>
		</wea:group>
	</wea:layout>
		<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>
</HTML>

<script language="javaScript">
//to use deeptree,you must implement following methods
var appendimg = 'Home';
var appendname = 'selObj';
var allselect = "<%=allselect%>";
var selectedids = "<%=selectedids%>";
if(selectedids!="-1"&&selectedids!="0"&&selectedids!=""){
	cxtree_id = "com_"+selectedids;
}

function initTree(){

CXLoadTreeItem("", "/hrm/tree/SubcompanySingleByRightXML.jsp?excludeid=<%=excludeid%>&rightStr=<%=rightStr%>&isedit=<%=isedit%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}




function onSaveJavaScript(){
        var nameStr="";
        if(select.selObj==null) return "";
    if(typeof(select.selObj.length)=="undefined") {
		if(select.selObj.checked) {
			nameStr =  select.selObj.value;
		}
	} else {
		for(var i=0;i<select.selObj.length;i++) {
			if(select.selObj[i].checked) {
				nameStr =  select.selObj[i].value;
				break;
			}
		}
	}
	arraytemp = nameStr.split("_");
    //----TD13905 start----
    //var resultStr = arraytemp[1];
    var resultStr = "0";
    if(arraytemp.length > 1) {
        resultStr = arraytemp[1];
    }
    //----TD13905 end------
	var strtmp2 = "";
	for(var i=0;i<arraytemp.length;i++){
		if(i>1){
			strtmp2 = strtmp2 + "_" + arraytemp[i];
		}
	}
	resultStr = resultStr+"$"+strtmp2.substring(1);
    return resultStr;   
    }

function onSave(){
	var trunStr,returnVBArray;
	trunStr =  onSaveJavaScript();
	returnVBArray = trunStr.split("$");
	
	var returnjson = {id:returnVBArray[0],name:returnVBArray[1]};
	if(dialog){
		try{
          dialog.callback(returnjson);
     }catch(e){}
		
		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
  	window.parent.parent.close();
	}
}

function onClear(){
      var returnjson = {id:"",name:""};
			if(dialog){
				try{
          dialog.callback(returnjson);
			     }catch(e){}
			
			try{
			     dialog.close(returnjson);
			 }catch(e){}
			}else{
				window.parent.parent.returnValue = returnjson;
		  	window.parent.parent.close();
			}
}

	function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  	window.parent.parent.close();
	}
	}
</script>
