<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo"
	class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo"
	scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo"
	class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
	<HEAD>

		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<link href="/css/deepTree_wev8.css" rel="stylesheet" type="text/css">
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
		String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
		String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(124, user.getLanguage());
		String needfav = "1";
		String needhelp = "";
		ArrayList departments = Util.TokenizerString(Util.null2String(request.getParameter("departments")), ",");
		ArrayList subcompanyids = Util.TokenizerString(Util.null2String(request.getParameter("subcompanyids")), ",");
		String isall = Util.null2String(request.getParameter("isall"));
		String onlyselfdept = Util.null2String(request.getParameter("onlyselfdept"));
		
		int isdetail = Util.getIntValue(request.getParameter("isdetail"),0);
		int isbill = Util.getIntValue(request.getParameter("isbill"),0);
		int fieldid = Util.getIntValue(request.getParameter("fieldid"),0);
		int detachable = Util.getIntValue(request.getParameter("detachable"),0);
		
		String selectedids = Util.null2String(request.getParameter("selectedids"));
		String isruledesign = Util.null2String(request.getParameter("isruledesign"));
		int uid = user.getUID();
		int beagenter = Util.getIntValue((String) session.getAttribute("beagenter_" + user.getUID()));
		if (beagenter <= 0) {
			beagenter = uid;
		}
		int tabid = 0;
		String rem = null;
		Cookie[] cks = request.getCookies();

		for (int i = 0; i < cks.length; i++) {
			if (cks[i].getName().equals("departmentmultiDecOrder" + uid)) {
				rem = cks[i].getValue();
				break;
			}
		}
		String nodeid = null;
		if (rem != null) {
			String[] atts = Util.TokenizerString2(rem, "|");
			if (atts.length > 1)
				nodeid = atts[1];
		}
		boolean exist = false;
		String tmpnodeid = "";
		if (nodeid != null)
			tmpnodeid = nodeid.substring(nodeid.lastIndexOf("_") + 1);
		if (nodeid != null && nodeid.indexOf("com") > -1) {
			if (isall.equals("true")) {
				exist = SubCompanyComInfo.getIdIndexKey(tmpnodeid) < 0 ? false : true;
			} else {
				exist = subcompanyids.indexOf(tmpnodeid) > -1 ? true : false;
			}
		} else if (nodeid != null && nodeid.indexOf("dept") > -1) {
			if (isall.equals("true")) {
				exist = DepartmentComInfo.getIdIndexKey(tmpnodeid) < 0 ? false : true;
			} else {
				exist = subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(tmpnodeid)) > -1 ? true : false;
			}
		}
		if (!exist)
			nodeid = null;
		String deptid = ResourceComInfo.getDepartmentID("" + beagenter);
		if (!deptid.equals("0")&&nodeid == null && (isall.equals("true") || departments.indexOf(deptid) > -1 || subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(deptid)) > -1))
			nodeid = "com_" + DepartmentComInfo.getSubcompanyid1(deptid);

		String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	%>

	<body onload="initTree()">
		<form name="SearchForm" style="margin-bottom: 0"
			action="MultiSelect.jsp" method="post" target="frame2">
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/leftMenuCommon.jsp"%>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:document.SearchForm.btnok.click(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON class=btn accessKey=O style="display: none" id="btnok"
				onclick="btnok_onclick();">
				<U>O</U>-<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></BUTTON>
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:document.SearchForm.btnclear.click(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON class=btn accessKey=2 style="display: none" id=btnclear
				onclick="btnclear_onclick();">
				<U>2</U>-<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></BUTTON>

			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<script>
rightMenu.style.visibility='hidden'
</script>

			<table width=100% class="ViewForm" valign="top"
				style="margin-top: 0px;">
				<!--######## Search Table Start########-->
				<tr>
					<td height=170>
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"
							style="height: 100%;" />
					<td>
				</tr>
			</table>
			<input class=inputstyle type="hidden" name="resourceids">
			<input class="inputstyle" type="hidden" name="subcompanyid">
			<input class="inputstyle" type="hidden" name="sqlwhere"
				value='<%=xssUtil.put(sqlwhere)%>'>
			<input class="inputstyle" type="hidden" id="showsubdept"
				name="showsubdept">
			<input class="inputstyle" type="hidden" name="tabid">
			<input class="inputstyle" type="hidden" name="nodeid">
			<input class="inputstyle" type="hidden" name="companyid">
			<input class="inputstyle" type="hidden" name="departmentid">
				<input class=inputstyle type=hidden name=selectedids id="selectedids" value="<%=selectedids%>">
			 <input class=inputstyle type=hidden name=fieldid value="<%=fieldid%>">
	         <input class=inputstyle type=hidden name=isdetail value="<%=isdetail%>">
	         <input class=inputstyle type=hidden name=isbill value="<%=isbill%>">
	         <input class=inputstyle type=hidden name=f_weaver_belongto_userid value="<%=f_weaver_belongto_userid%>">
	         <input class=inputstyle type=hidden name=f_weaver_belongto_usertype value="<%=f_weaver_belongto_usertype%>">
	         <input class=inputstyle type=hidden name=detachable value="1">
			<!--########//Search Table End########-->
		</FORM>
		<!--
<SCRIPT LANGUAGE=VBS>
resourceids =""
resourcenames = ""

Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub


Sub btnok_onclick()
	 setResourceStr()
     replaceStr()
     window.parent.returnvalue = Array(resourceids,resourcenames)
    window.parent.close
End Sub

Sub btnsub_onclick()
	setResourceStr()
    document.all("resourceids").value = resourceids.substring(1)
    document.SearchForm.submit
End Sub
</SCRIPT>  -->


		<script language="javascript">
	function initTree(){
	cxtree_id = '<%=Util.null2String(nodeid)%>';
	CXLoadTreeItem("", "/hrm/tree/DepartmentMultiXMLByDecOrder.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>&fieldid=<%=fieldid%>&isbill=<%=isbill%>&isdetail=<%=isdetail%>&detachable=1&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	//end by cyril on 2008-08-12 for td:9109
	}
	
	//to use xtree,you must implement top() and showcom(node) functions
	
	function top1(){
	<%if(nodeid!=null){%>
	try{
	deeptree.scrollTop=<%=nodeid%>.offsetTop;
	deeptree.HighlightNode(<%=nodeid%>.parentElement);
	deeptree.ExpandNode(<%=nodeid%>.parentElement);
	    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|<%=nodeid%>");
	 }catch(e){
	
	    }
	<%}%>
	}
</script>

		<script language="javascript">
var resourceids =""
var resourcenames = ""
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

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}

function btnok_onclick1(){
	if(setResourceStr()){
  replaceStr();
  if(dialog){
		var returnjson =  {id:resourceids,name:resourcenames};
		try{
    	dialog.callback(returnjson);
    }catch(e){}

		try{
			dialog.close(returnjson);
		}catch(e){}
  }else{
    window.parent.parent.returnValue =  {id:resourceids,name:resourcenames};
    window.parent.parent.close();
	}
	}
}

function showcom(node){
}

function check(node){
}
function setCookie(name,val){
	var Then = new Date();
	Then.setTime(Then.getTime() + 30*24*3600*1000 );
	document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
}
function setResourceStr(){

	var resourceids1 =""
        var resourcenames1 = ""
       try{
	for(var i=0;i<parent.frame2.resourceArray.length;i++){
		resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;

		resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
	}
	resourceids=resourceids1
	resourcenames=resourcenames1
       }catch(err){}
	return true;

}

function replaceStr(){
    var re=new RegExp("[ ]*[|]*[|]","g");
    resourcenames=resourcenames.replace(re,"|");
    re=new RegExp("[|][^,]*","g");
    resourcenames=resourcenames.replace(re,"");   
}

function doSearch()
{
	if(setResourceStr()){
		jQuery("#selectedids").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
    document.all("resourceids").value = resourceids.substring(1) ;
    if(jQuery(parent.document).find("#frame2").contents().find("#showsubdept").attr("checked")){
    	jQuery("#showsubdept").val("1") ;
    }else{
      jQuery("#showsubdept").val("0")  ;
    }
    document.SearchForm.submit();
	}
}
var companyid_ = -1;
function setCompany(id){
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("tabid").value=0
	if(companyid_ == id && id != -1){
			return;
	}
	companyid_ = id;
    doSearch()
}
var subcompanyid_ = -1;
function setSubcompany(nodeid){
    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|"+nodeid);
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
	if(subcompanyid_ == nodeid && nodeid != -1){
		return;
	}
	subcompanyid_ = nodeid;
    doSearch()
}
	var departmentid_ = -1;
function setDepartment(nodeid){
    setCookie("departmentmultiDecOrder<%=uid%>","<%=tabid%>|"+nodeid);
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
	if(departmentid_ == nodeid && nodeid != -1){
		return;
	}
	departmentid_ = nodeid;
    doSearch()
}
</script>
	</BODY>
</HTML>