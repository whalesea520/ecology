<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentVirtualComInfo" class="weaver.hrm.companyvirtual.DepartmentVirtualComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(parent.document.body).height());
	});
}
</script>
</HEAD>
<%
String rightStr=Util.null2String(request.getParameter("rightStr"));
String zxnodeid = Util.null2String(request.getParameter("nodeid"));
int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=(String)session.getAttribute("treeleft");
if(rem==null){
	Cookie[] cks= request.getCookies();
	for(int i=0;i<cks.length;i++){
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
	exist=SubCompanyVirtualComInfo.getSubCompanyname(nodeid.substring(nodeid.lastIndexOf("_")+1)).equals("")?false:true;
}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
	String deptname=DepartmentVirtualComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
	String subcom=DepartmentVirtualComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
  if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
     exist=true;
  else
    exist=false;
}        
if(!exist)nodeid=null;

CompanyComInfo.setTofirstRow();
String dfvirtualtype = "";
String dfvirtualtypename = "";
if(CompanyComInfo.next()){
	dfvirtualtype=CompanyComInfo.getCompanyid();
	dfvirtualtypename=CompanyComInfo.getCompanyname();
}
CompanyVirtualComInfo.setUser(user);
%>

<BODY onload="initTree()">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&virtualtype=<%=dfvirtualtype %>" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<BUTTON class=btn type="button" accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType" style="width: 219px">
					<span><img id="currentImg" style="vertical-align:middle;" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
					<span>
						<div id="e8typeDiv" style="width:auto;height:auto;position:relative;">
							<span id="optionSpan" style="width: 155px; text-overflow:ellipsis;white-space:nowrap;overflow:hidden;" title="<%=dfvirtualtypename %>" onclick="showE8TypeOption();"><%=dfvirtualtypename.length()>4?dfvirtualtypename:dfvirtualtypename%></span>
							<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
							<span style="width:16px;height:16px;padding-left:8px;cursor:pointer;" onclick="showE8TypeOption();">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
							<%} %>
						</div>
					</span>
					<span id="totalDoc"></span>
					</span>
					<span class="leftSearchSpan">
						&nbsp;<input type="text" class="leftSearchInput" style="width:220px!important;margin-right:25px;"/>
					</span>
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" style="overflow:hidden;position:relative;" CfgXMLSrc="/css/TreeConfig.xml" />
		</td>
	</tr>
</table>
<%	if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
	<ul id="e8TypeOption" class="e8TypeOption">
	<%
	if(CompanyComInfo.getCompanyNum()>0){
		CompanyComInfo.setTofirstRow();
		while(CompanyComInfo.next()){
	%>
		<li onclick="changeShowType(this,<%=CompanyComInfo.getCompanyid() %>);">
			<span style="display: inline-block;height: 100%;vertical-align: middle;">
				<span id="showspan<%=CompanyComInfo.getCompanyid() %>" class="e8img" style="vertical-align: middle;"><img src="/images/ecology8/doc/current_wev8.png"/></span>
				<span class="e8img" style="vertical-align: middle;"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
				<span class="e8text" style="vertical-align: middle;display:inline-block;width:155px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;" title="<%=dfvirtualtypename%>"><%=dfvirtualtypename.length()>4?dfvirtualtypename:dfvirtualtypename%></span>
			</span>
		</li>
	<%}}
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		CompanyVirtualComInfo.setTofirstRow();
		while(CompanyVirtualComInfo.next()){
		%>
		<li onclick="changeShowType(this,<%=CompanyVirtualComInfo.getCompanyid() %>);">
			<span style="display: inline-block;height: 100%;vertical-align: middle;">
				<span id="showspan<%=CompanyVirtualComInfo.getCompanyid() %>" class="e8img e8imgSel" style="vertical-align: middle;"><img src="/images/ecology8/doc/current_wev8.png"/></span>
				<span class="e8img" style="vertical-align: middle;"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
				<span class="e8text" style="vertical-align: middle;display:inline-block;width:155px;text-overflow:ellipsis;white-space:nowrap;overflow:hidden;" title="<%=CompanyVirtualComInfo.getVirtualType() %>"><%=CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()%></span>
			</span>
		</li>
		<%} %>
	</ul>
<%} %>
<%} %>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="id" >
  <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="<%=dfvirtualtype%>">
	<!--########//Search Table End########-->
	</FORM>
<script language="javascript">
function initTree(){
	var virtualtype = jQuery("#virtualtype").val();
	cxtree_id = '<%=zxnodeid%>';
	if(virtualtype=="1"){
		//行政组织结构
		CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	}else{
		CXLoadTreeItem("", "/hrm/companyvirtual/HrmCompany_XML.jsp?virtualtype="+virtualtype+"&<%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	}		
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
}

function changeShowType(obj,showtype){
	var title = jQuery(obj).find(".e8text").html();
	var title1 = jQuery(obj).find(".e8text").attr("title");
	jQuery("#optionSpan").html(title);
	jQuery("#optionSpan").attr("title",title1);
	jQuery("#virtualtype").val(showtype);
	jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
	jQuery("span[id^='showspan']").each(function(){
		jQuery(this).addClass("e8imgSel");
	});
	jQuery("#showspan"+showtype).removeClass("e8imgSel");
	showE8TypeOption();
	initTree();
	setCompany("com_"+showtype);
}
	
function showcom(node){
}
function check(node){
}

function setCompany(nodeid){
	comid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	document.all("departmentid").value="";
	document.all("subCompanyId").value="";
	document.all("id").value=comid;
	document.all("tabid").value=0;
	var virtualtype = jQuery("#virtualtype").val();
	document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&virtualtype="+virtualtype;;
	document.SearchForm.submit();
}

function setSubcompany(nodeid){ 
	subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	document.all("companyid").value="";
	document.all("departmentid").value="";
	document.all("subCompanyId").value=subid;
	document.all("tabid").value=0;
	document.all("id").value=subid;
	var virtualtype = jQuery("#virtualtype").val();
	document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&subcompanyid1="+subid+"&virtualtype="+virtualtype;
	document.SearchForm.submit();
}

function setDepartment(nodeid){
	//deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
  var str=nodeid;
  var s = str.split("_");
  subCompanyId=s[1];
  deptid=s[2];
	document.all("subCompanyId").value="";
	document.all("companyid").value="";
	document.all("departmentid").value=deptid;
	document.all("tabid").value=0;
	document.all("id").value=deptid;
	var virtualtype = jQuery("#virtualtype").val();
	document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=HrmResourceSearchResult&departmentid="+deptid+"&subcompanyid1="+subCompanyId+"&virtualtype="+virtualtype;
	document.SearchForm.submit();
}
</script>
</BODY>
</HTML>