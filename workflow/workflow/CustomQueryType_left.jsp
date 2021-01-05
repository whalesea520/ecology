<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-08-20 for td:9215 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<!-- end by cyril on 2008-08-20 for td:9215 -->
</HEAD>


<%
String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String isTemplate=Util.getIntValue(Util.null2String(request.getParameter("isTemplate")),0)+"";
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

String rightStr=Util.null2String(request.getParameter("rightStr"));

int uid=user.getUID();
int tabid=0;

//modified by cyril on 2008-08-20 for td:9215
String cnodeid=Util.null2String((String)session.getAttribute("treeleft_cnodeid"+isTemplate));
//out.println("1 cnodeid="+cnodeid);
String nodeid=Util.null2String(request.getParameter("nodeid"));
String rem=(String)session.getAttribute("treeleft"+isTemplate);
if(rem==null || cnodeid.equals(""))
{
    Cookie[] cks= request.getCookies();
    
    for(int i=0;i<cks.length;i++)
    {
	    //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
	    if(rem==null && cks[i].getName().equals("treeleft"+isTemplate+uid)){
	     	rem=cks[i].getValue();
	    }
	    if(cnodeid.equals("") && cks[i].getName().equals("treeleft_cnodeid"+isTemplate+uid)){
	        cnodeid=cks[i].getValue();
	    }
	    if(rem!=null && !cnodeid.equals("")) break;
    }
}
if(rem!=null){
	session.setAttribute("treeleft"+isTemplate,rem);
	Cookie ck = new Cookie("treeleft"+isTemplate+uid,rem);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);
	nodeid=rem;
}
if(!cnodeid.equals("")) {
	session.setAttribute("treeleft_cnodeid"+isTemplate,cnodeid);
	Cookie ck = new Cookie("treeleft_cnodeid"+isTemplate+uid,cnodeid);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);
}
//out.println("nodeid="+nodeid+" cnodeid="+cnodeid);
//end by cyril on 2008-08-20 for td:9215

int subcompanyid=-1;
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int operatelevel=0;

if(detachable==1){  
    subcompanyid = Util.getIntValue(request.getParameter("subcompanyid"), -1);
    if(subcompanyid>0){
    	operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowCustomManage:All",subcompanyid);
    }
}else{
    if(HrmUserVarify.checkUserRight("WorkflowCustomManage:All", user))
        operatelevel=2;
}
%>
<BODY onload="initTree()">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/workflow/workflow/CustomQuerySetTab.jsp" method=post target=wfmainFrame>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(125100,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv">
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"/>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid"  >
  

	</FORM>
<script language="javascript">
function initTree(){
	try
	{
		<%
		String cxtree_id = "SearchType_1";
		if(!cnodeid.equals("") && !cnodeid.equals("0")) 
		{
			cxtree_id = "SearchType_"+cnodeid;
		}
		else 
		{
			if(!Util.null2String(nodeid).equals("") && !nodeid.equals("0"))
				cxtree_id = "SearchType_"+nodeid;
		}
		%>
		cxtree_id = '<%=cxtree_id%>';
		//alert(cxtree_id);
		CXLoadTreeItem("", "/workflow/workflow/CustomQueryTypeXML.jsp?init=true&subcompanyid=<%=subcompanyid%>&operatelevel=<%=operatelevel%>&nodeid=<%=nodeid%>");
		var tree = new WebFXTree();
		tree.add(cxtree_obj);
		//document.write(tree);
		document.getElementById('deeptree').innerHTML = tree;
		cxtree_obj.expand();
		//setTimeout("setHight()",500);
		//end by cyril on 2008-08-20 for td:9215
	}
	catch(e)
	{
		
	}
}

function setHight(){
	jQuery(".ulDiv").css("display","");
	jQuery("#webfx-tree-object-4").css("display","block");
	jQuery("#webfx-tree-object-7-cont").css("display","block");
	$("#overFlowDiv").height($("#wfmainFrame",window.parent.document).height()-$(".leftTypeSearch").height());
	$(".ulDiv").height($(".ulDiv div").height());
}
//to use xtree,you must implement top() and showcom(node) functions

function top2(){
	<%if(nodeid!=null){%>
	try{
		deeptree.scrollTop=SearchType_<%=nodeid%>.offsetTop;
		deeptree.HighlightNode(SearchType_<%=nodeid%>.parentElement);
		deeptree.ExpandNode(SearchType_<%=nodeid%>.parentElement);
	}catch(e){}
	<%}%>
}

function showcom(node){
}
function check(node){
	if(typeof(select.selObj.length)=='undefined'){
		highlight(node);
		deeptree.ExpandNode(node.parentElement);
		return;
	}
	for(i=0;i<select.selObj.length;i++){
		highlight(select.selObj[i].previousSibling);
	}
	deeptree.ExpandNode(node.parentElement); 
}



//end

//node is a SPAN object
function highlight(node){
	if(node.nextSibling.checked)
		node.style.color='red';
	else
		node.style.color='black';
}

function onSaveJavaScript(){     
        var idStr="";
        var nameStr="";
        var nodeidStr="";
        if(typeof(select.selObj.length)=="undefined") {
		if(select.selObj.checked) {
			var kids = select.selObj.parentNode.childNodes;
			
			for(var j=0;j<kids.length;j++){
				if(kids[j].type=="label") {
					
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj.value;
				                idStr+=temp;													
						break;
						
				}
			}
		}
	} else {
		for(var i=0;i<select.selObj.length;i++) {
			if(select.selObj[i].checked) {
			var kids = select.selObj[i].parentNode.childNodes;
				for(var j=0;j<kids.length;j++){
					if(kids[j].type=="label") {
					        				    
						nameStr +=kids[j].innerText;
						nodeidStr+=kids[j].id;
						var temp = select.selObj[i].value;
				                idStr+=temp;													
						break;
						
					}
				}
			}
		}
	}
        return idStr +"_" + nameStr;   
    } 
    
function setSubCompany(subcompanyid){
	var uid="<%=user.getUID()%>";
	var de="<%=detachable%>";
	document.all("subcompanyid").value=subcompanyid;
	document.SearchForm.submit();
}


</script>
</BODY>
</HTML>