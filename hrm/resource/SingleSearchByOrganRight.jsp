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
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String rightStr = Util.null2String(request.getParameter("rightStr"));
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


%>

<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="SelectByDec.jsp" method=post target="frame2">
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
<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
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
	<td height=170>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	</td>
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
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%>&rightStr=<%=rightStr%><%}else{%>?onlyselfdept=<%=onlyselfdept%>&rightStr=<%=rightStr%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}

function setCompany(id){
    
    document.all("departmentid").value="";
    document.all("subcompanyid").value="";
    document.all("companyid").value=id;
    document.all("tabid").value=0;
    document.SearchForm.submit();
}
function setSubcompany(nodeid){ 
      //是否显示无账号人员
	  if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked")){
	    jQuery("#isNoAccount").val("1");
	  }else{
	    jQuery("#isNoAccount").val("0");
	 	}
	  
	  //是否包含下级机构  
	 	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked")){
	    jQuery("#alllevel").val("1");
	  }else{
	    jQuery("#alllevel").val("0");
	  }
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("companyid").value="";
    document.all("departmentid").value="";
    document.all("subcompanyid").value=subid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.submit();
}
function setDepartment(nodeid){
	  //是否显示无账号人员
	  if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked")){
	    jQuery("#isNoAccount").val("1");
	  }else{
	    jQuery("#isNoAccount").val("0");
	 	}
	  
	  //是否包含下级机构  
	 	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked")){
	    jQuery("#alllevel").val("1");
	  }else{
	    jQuery("#alllevel").val("0");
	  }
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    document.all("subcompanyid").value="";
    document.all("companyid").value="";
    document.all("departmentid").value=deptid;
    document.all("tabid").value=0;
    document.all("nodeid").value=nodeid;
    document.SearchForm.submit();
}

function btnclear_onclick(){
			if(dialog){
	  	var returnjson = {id:"", name:""};
	   	try{
          dialog.callback(returnjson);
     }catch(e){}

try{
     dialog.close(returnjson);
 }catch(e){}
	  }else{
	    window.parent.parent.returnValue = {id:"", name:""};
	    window.parent.parent.close();
		}
}
</script>
 

</BODY>
</HTML>