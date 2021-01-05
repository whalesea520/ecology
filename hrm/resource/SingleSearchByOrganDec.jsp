<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-08-12 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-08-12 for td:9109 -->
<script type="text/javascript">  
  var dialog = null;
  try{
 		dialog = parent.parent.parent.getDialog(parent.parent);
  }catch(e){ }
 </script>
</HEAD>


<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());

String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

String isruledesign = Util.null2String(request.getParameter("isruledesign"));

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String onlyselfdept=Util.null2String(request.getParameter("onlyselfdept"));
ArrayList departments=Util.TokenizerString(Util.null2String(request.getParameter("departments")),",");
ArrayList subcompanyids=Util.TokenizerString(Util.null2String(request.getParameter("subcompanyids")),",");
String isall=Util.null2String(request.getParameter("isall"));
int uid=user.getUID();
int tabid=0;
String deptid=ResourceComInfo.getDepartmentID(""+uid);
String nodeid=null;
if(isall.equals("true")||departments.indexOf(deptid)>-1||subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(deptid))>-1) nodeid="dept_"+DepartmentComInfo.getSubcompanyid1(deptid)+"_"+deptid;


int isdetail = Util.getIntValue(request.getParameter("isdetail"),0);
int isbill = Util.getIntValue(request.getParameter("isbill"),0);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),0);
int detachable = Util.getIntValue(request.getParameter("detachable"),0);

%>

<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SelectByDec.jsp" method=post target="frame2">
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<button type="button"  class=btnok accessKey=1 style="display:none" onclick="btncancel_onclick()" id="btnok" ><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<button type="button"  class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table width=100% class="ViewForm" valign="top">
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height=170 width="100%"> 
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" ></div>
	<td>
	</tr>
	
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
  
  <input class=inputstyle type=hidden name=isdetail value="<%=isdetail%>">
  <input class=inputstyle type=hidden name=isbill value="<%=isbill%>">
  <input class=inputstyle type=hidden name=fieldid value="<%=fieldid%>">
  <input class=inputstyle type=hidden name=detachable value="<%=detachable%>">
  
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
//deeptree.init("/hrm/tree/ResourceSingleXMLByDec.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>");
//added by cyril on 2008-08-12 for td:9109
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceSingleXMLByDec.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>&isdetail=<%=isdetail %>&isbill=<%=isbill %>&fieldid=<%=fieldid %>&detachable=1&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-08-12 for td:9109
}

//to use xtree,you must implement top() and showcom(node) functions

function top(){
<%if(nodeid!=null){%>
    try{
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
         }catch(e){

    }
<%}%>
}

function showcom(node){
}

function check(node){
}

</script>
</BODY>
</HTML>
<!-- 以下js函数需要是从body体内移出来的，在Google浏览器中一下这些js函数在body外边才识别 2012-08-08 ypc 修改 start -->
<script language="javascript">
	function setCompany(id){
	    $("input[name=departmentid]").val("");
	    $("input[name=subcompanyid]").val("");
	    $("input[name=companyid]").val(id);
	    $("input[name=tabid]").val(0);
	     //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");
	   
	   //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
	    document.SearchForm.submit();
	}
	function setSubcompany(nodeid){ 
	    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    $("input[name=companyid]").val("");
	    $("input[name=departmentid]").val("");
	    $("input[name=subcompanyid]").val(subid);
	    $("input[name=tabid]").val(0);
	    $("input[name=nodeid]").val(nodeid);
	     //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");
	   
	   //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
	    document.SearchForm.submit();
	}
	function setDepartment(nodeid){
	    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    $("input[name=subcompanyid]").val("");
	    $("input[name=companyid]").val("");
	    $("input[name=departmentid]").val(deptid);
	    $("input[name=tabid]").val(0);
	    $("input[name=nodeid]").val(nodeid);
	     //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");
	   
	   //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
	    document.SearchForm.submit();
	}
	
	function btnclear_onclick(){
	  	var returnjson = {id:"", name:""};
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
<!-- 以下js函数需要是从body体内移出来的，在Google浏览器中一下这些js函数在body外边才识别 2012-08-08 ypc 修改 end -->