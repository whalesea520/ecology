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
<style>
 td.leftTypeSearch{
  display:block !important;
 }
 .flowMenusTd{
 display:block !important;
 }
.flowsTable{
 height:100% !important;
}
</style>
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}
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


String rigthPage = Util.null2String(request.getParameter("rigthPage"));//右边框架页面地址
if("".equals(rigthPage.trim())){//设定默认值，为新建页面
	rigthPage = "RequestSubmitFrame";
}

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
	<tr style='height: 30px;'>
		<td class="leftTypeSearch" style="height:30px">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(83715,user.getLanguage()) %><span id="totalDoc"></span></span>
				
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="background-color:#f8f8f8;width:246px;height: 100%;overflow:hidden;" />
		</td>
	</tr>
</table>
  <input class=inputstyle type="hidden" id="sqlwhere" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" id="tabid" name="tabid" >
  <input class=inputstyle type="hidden" id="companyid" name="companyid" >
  <input class=inputstyle type="hidden" id="subcompanyid" name="subcompanyid" >
  <input class=inputstyle type="hidden" id="departmentid" name="departmentid" >
  <input class=inputstyle type="hidden" id="nodeid" name="nodeid" >
  <input class=inputstyle type="hidden" id="hrmid" name="hrmid" >
  <input class=inputstyle type=hidden id=seclevelto name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden id=needsystem name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type="hidden" name="objId">
  <input class=inputstyle type="hidden" name="type_d" >
  <input class=inputstyle type="hidden" name="isfromleft" value="1">
  <input class=inputstyle type="hidden" name="rigthRage" value="<%=rigthPage%>" >
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">

function doSearch(id)
{
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    var iframeSrc = parent.document.getElementById("contentframe").src;
	document.SearchForm.action = "/worktask/request/<%=rigthPage%>.jsp";
	//setResourceStr();
    //document.all("resourceids").value = resourceids.substring(1) ;
    //alert(id);
 
     document.SearchForm.submit();
}

function initTree(){
    
	$(parent.document).find("#oTd1").css("width","246px")
    $(".flowMenusTd").css("height",($(window).height()-70)+'px');
	webFXTreeConfig.blankIcon		= "/images/xp2/blank_wev8.png";
	webFXTreeConfig.lMinusIcon		= "/images/xp_none/Lminus_wev8.png";
	webFXTreeConfig.lPlusIcon		= "/images/xp_none/Tplus_wev8.png";
	webFXTreeConfig.tMinusIcon		= "/images/xp_none/Lminus_wev8.png";
	webFXTreeConfig.tPlusIcon		= "/images/xp_none/Tplus_wev8.png";
	webFXTreeConfig.iIcon			= "/images/xp2/I_wev8.png";
	webFXTreeConfig.lIcon			= "/images/xp2/L_wev8.png";
	webFXTreeConfig.tIcon			= "/images/xp2/T_wev8.png";
	var rti;
	var tree = new WebFXTree('');
	tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>", "/worktask/request/checkFlowListTreeForHrmTree.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>"));
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
	initTree();
})
//to use xtree,you must implement top() and showcom(node) functions


function showcom(node){
}

function check(node){
}

function setCompany(id){
	//===================================================================================added by hubo,TD3830
	var iframeSrc = parent.document.getElementById("contentframe").src;
	//===================================================================================
    document.all("type_d").value="0" //集团
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("objId").value=id
    document.all("tabid").value=0
    doSearch(id)
}
function setSubcompany(nodeid){ 
    document.all("type_d").value="1" //分部
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("objId").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(subid)
}
function setDepartment(nodeid){
     document.all("type_d").value="2" //部门
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("objId").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(deptid)
}

function setHrm(nodeid){
     document.all("type_d").value="3" //人力资源
    hrmid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("hrmid").value=hrmid
    document.all("objId").value=hrmid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch(hrmid)
}


</script>
 
</BODY>
</HTML>