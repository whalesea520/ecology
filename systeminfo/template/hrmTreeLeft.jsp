<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
window.__hideExpandOrCollapseDiv = true;
</script>
</HEAD>


<%
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

String rightStr=Util.null2String(request.getParameter("rightStr"));

int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=(String)session.getAttribute("treeleft");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("treeleft"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
session.setAttribute("treeleft",rem);
Cookie ck = new Cookie("treeleft"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("com")>-1){
exist=SubCompanyComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_")+1)).equals("")?false:true;
}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}        
if(!exist)
nodeid=null;



%>

<BODY scroll=no>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="templateTabs.jsp?_fromURL=hpTheme" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:SearchForm.btnok.click(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:SearchForm.btnclear.click(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;	
}
%>

<%-- <BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>--%>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%}%>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(83715,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="background-color:#f8f8f8;width:220px;overflow:hidden;" />
		</td>
	</tr>
</table>
  <input class=inputstyle type="hidden" id="sqlwhere" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" id="tabid" name="tabid" >
  <input class=inputstyle type="hidden" id="companyid" name="companyid" >
  <input class=inputstyle type="hidden" id="subCompanyId" name="subCompanyId" >
  <input class=inputstyle type="hidden" id="departmentid" name="departmentid" >
  <input class=inputstyle type="hidden" id="nodeid" name="nodeid" >
  <input class=inputstyle type=hidden id=seclevelto name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden id=needsystem name=needsystem value="<%=needsystem%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
	var rti;
	var tree = new WebFXTree('');
	tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>", "/systeminfo/menuconfig/MenuMaintenanceTreeLeftXML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>"));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	document.getElementById('deeptree').innerHTML = tree;
	rti.expand();
}

function initTree9old(){
CXLoadTreeItem("", "/frameleftXML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
}
$(function(){
	initTree9old();
})
//to use xtree,you must implement top() and showcom(node) functions


function showcom(node){
}

function check(node){
}

function setCompany(id){
    
    jQuery("#departmentid").val("");
    jQuery("#subCompanyId").val("");
    jQuery("#companyid").val(id);
    jQuery("#tabid").val(0);
    document.SearchForm.submit();
}
function setSubcompany(nodeid){ 
    
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery("#companyid").val("");
    jQuery("#departmentid").val("");
    jQuery("#subCompanyId").val(subid);
    jQuery("#tabid").val(0);
    jQuery("#nodeid").val(nodeid);
    document.SearchForm.submit();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery("#subCompanyId").val("");
    jQuery("#companyid").val("");
    jQuery("#departmentid").val(deptid);
    jQuery("#tabid").val(0);
    jQuery("#nodeid").val(nodeid);
    document.SearchForm.submit();
}


</script>
 
</BODY>
</HTML>