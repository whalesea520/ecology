<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-12-29 for td:9831 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/ecology8/customSelect/customSelect_wev8.css">
<script type="text/javascript" src="/js/ecology8/customSelect/customSelect_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" /> 
<script type="text/javascript">
if (window.jQuery.client.browser == "Firefox") {
	jQuery(document).ready(function () {
		jQuery("#deeptree").css("height", jQuery(document.body).height());
	});
}

function showE8TypeOption(closed){
	if(closed){
		jQuery("#e8TypeOption").hide();
	}else{
		jQuery("#e8TypeOption").toggle();
	}
	if(jQuery("#e8TypeOption").css("display")=="none"){
		jQuery("span.leftType").removeClass("leftTypeSel");
		var src = jQuery("#currentImg").attr("src");
		if(src){
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
	}else{
		jQuery("span.leftType").addClass("leftTypeSel");
		jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+10);
		var src = jQuery("#currentImg").attr("src");
		if(src){
			jQuery("#currentImg").attr("src",src);
		}
		jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
	}
	return;
}
</script>
<!-- end by cyril on 2008-12-29 for td:9831 -->
</HEAD>


<%
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
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

CompanyComInfo.setTofirstRow();
String dfvirtualtype = "";
String dfvirtualtypename = "";
if(CompanyComInfo.next()){
	dfvirtualtype=CompanyComInfo.getCompanyid();
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		dfvirtualtypename=SystemEnv.getHtmlLabelName(83179,user.getLanguage());
	}else{
		dfvirtualtypename=CompanyComInfo.getCompanyname();
	}
}

%>

<BODY onload="initTree9old()" scroll=no>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/homepage/maint/HomepageTabs.jsp?_fromURL=hpMenu&type=<%=type %>" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

%>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
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
			<div class="topMenuTitle" style="border-bottom:none;">
				<span class="leftType" style="width: 235px">
					<span><img id="currentImg" style="vertical-align:middle;" src="/images/ecology8/doc/org_wev8.png" width="16"/></span>
					<span>
						<div id="e8typeDiv" style="width:auto;height:auto;position:relative;">
							<span id="optionSpan" style="width: 180px; text-overflow:ellipsis;white-space:nowrap;overflow:hidden;" title="<%=dfvirtualtypename %>" onclick="showE8TypeOption();"><%=dfvirtualtypename.length()>4?dfvirtualtypename:dfvirtualtypename%></span>
							<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
							<span style="width:16px;padding-left:8px;cursor:pointer;" onclick="showE8TypeOption();">
								<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
							</span>
							<%} %>
						</div>
					</span>
					<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div id="deeptree" class="cxtree" style="background-color:#F8F8F8;overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml" />
		</td>
	</tr>
</table>

<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
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
	<%	}
	}
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
	<%	} %>
	</ul>
	<%} %>
<%} %>

  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" value="<%=nodeid%>">
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type="hidden" name="isCustom" >
  <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="<%=dfvirtualtype%>">
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">
function initTree(){
	var rti;
	var tree = new WebFXTree('');
	tree.setBehavior("explorer");
	tree.add(rti = new WebFXLoadTreeItem("<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>", "/systeminfo/menuconfig/MenuMaintenanceTreeLeftXML.jsp?showdept=false&rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>"));
	rti.icon = webFXTreeConfig.rootIcon;
	rti.openIcon = webFXTreeConfig.openRootIcon;
	document.getElementById('deeptree').innerHTML = tree;
	rti.expand();
}

function initTree9old(){
	var virtualtype = jQuery("#virtualtype").val();
	//deeptree.init("/systeminfo/menuconfig/MenuMaintenanceTreeLeftXML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	//added by cyril on 2008-12-29 for td:9831
	//设置选中的ID
	cxtree_id = '<%=Util.null2String(nodeid)%>';
	if(virtualtype=="1"){
		//行政组织结构
		CXLoadTreeItem("", "/hrm/tree/HrmCompany_XML.jsp?showdept=false&rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	}else{
		CXLoadTreeItem("", "/hrm/companyvirtual/HrmCompany_XML.jsp?showdept=false&virtualtype="+virtualtype+"&<%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	}
	//CXLoadTreeItem("", "/systeminfo/menuconfig/MenuMaintenanceTreeLeftXML.jsp?showdept=false&rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	//end by cyril on 2008-12-29 for td:9831
	//alert(tree.length);
}

//to use xtree,you must implement top() and showcom(node) functions

function top1(){
<%if(nodeid!=null){%>
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
<%}%>
}

function showcom(node){
}

function check(node){
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
	initTree9old();
	setCompany("com_"+showtype);
}

function setCompany(nodeid){
	
	comid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery("input[name=departmentid]").val("");
    jQuery("input[name=subCompanyId]").val("");
    jQuery("input[name=companyid]").val(comid);
    jQuery("input[name=tabid]").val(0);
    jQuery("input[name=nodeid]").val(nodeid);
	jQuery("input[name=isCustom]").val("false");
    document.SearchForm.submit();
}
function setSubcompany(nodeid){ 
    
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery("input[name=companyid]").val("");
    jQuery("input[name=departmentid]").val("");
    jQuery("input[name=subCompanyId]").val(subid);
    jQuery("input[name=tabid]").val(0);
    jQuery("input[name=nodeid]").val(nodeid);
	jQuery("input[name=isCustom]").val("false");
    document.SearchForm.submit();
}
function setDepartment(nodeid){
    
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
    jQuery("input[name=subCompanyId]").val("");
    jQuery("input[name=companyid]").val("");
    jQuery("input[name=departmentid]").val(deptid);
    jQuery("input[name=tabid]").val(0);
    jQuery("input[name=nodeid]").val(nodeid);
    document.SearchForm.submit();
}


</script>
 
 
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>
</BODY>
</HTML>