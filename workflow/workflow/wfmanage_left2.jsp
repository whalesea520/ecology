<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-08-20 for td:9215 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<!-- end by cyril on 2008-08-20 for td:9215 -->

<style type="text/css">
a {
	word-break :break-all;
}
</style>

<script type="text/javascript">
jQuery(document).ready(function () {
	//jQuery("#deeptree").css("height", jQuery(document.body).height());
	//jQuery(".ulDiv").height(jQuery(".webfx-tree-container").height());
	//jQuery('#overFlowDiv').perfectScrollbar();
});
</script>
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

String isWorkflowDoc = Util.null2String(request.getParameter("isWorkflowDoc"));
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
int uid=user.getUID();
int tabid=0;
	
	//判断当前用户有路径维护
	WfRightManager wfrm = new WfRightManager();
	boolean hasPermission  = wfrm.hasPermission2(0, user, WfRightManager.OPERATION_CREATEDIR);
	String workflowIds = "";
	if(hasPermission && -1== subCompanyId){
		workflowIds = wfrm.getAllWfTypeIds(user.getUID());
	}
	
	


//modified by cyril on 2008-08-20 for td:9215
String cnodeid=Util.null2String((String)session.getAttribute("treeleft_cnodeid"+isTemplate));
//out.println("1 cnodeid="+cnodeid);
String nodeid=Util.null2String(request.getParameter("nodeid"));
String rem=(String)session.getAttribute("treeleft"+isTemplate);
        if(rem==null || cnodeid.equals("")){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
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

//如果客户单独进这个页面，就无法取到是否开启分权
int detachable=0;
boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();
if(isUseWfManageDetach){
	detachable = 1 ;
	session.setAttribute("detachable","1");
}

int operatelevel=0;
    if(detachable==1){  
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
            operatelevel=2;
    }
%>

<BODY onload="initTree()" style="overflow:hidden;">
    <FORM NAME=SearchForm STYLE="margin-bottom:0" action="managewfTab.jsp" method=post target="wfmainFrame">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch" style="display:table-cell;">
			<div>
				<span class="leftType">
					<%=SystemEnv.getHtmlLabelName("1".equals(isTemplate)?33658:16483,user.getLanguage()) %>
					<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv">
						<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" style="overflow:hidden;"/>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>

  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subCompanyId" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="cnodeid" >
   <input class=inputstyle type="hidden" name="isWorkflowDoc" value="<%=isWorkflowDoc %>" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input type="hidden" name="isTemplate" value="<%=isTemplate%>">
    <!--########//Search Table End########-->
	</FORM>


<script language="javascript">
	//重写搜索
	flowPageManager.loadFunctions.dealLeftSearch = function(){
		//重写jQuery的contains选择器，让查询忽略大小写
		jQuery.expr[':'].contains = function(a, i, m) {
		  return jQuery(a).text().toUpperCase()
		      .indexOf(m[3].toUpperCase()) >= 0;
		};
		
		jQuery(".leftSearchInput").searchInput({
			searchFn:function(value){
				initTree();
				expandRootNode();
			}
		});
	}
	
	jQuery(document).ready(function(){
		expandRootNode();
	});
	
	function expandRootNode(){
		setTimeout(function(){
			var oItem = jQuery("div[_id='div_root']")[0];
			var oItemObj =  webFXTreeHandler.all[oItem.id];
			if(!oItemObj.open){
				webFXTreeHandler.toggle(oItemObj);
			}
		},1000);
	}

function setHeight(){
var divHeight = $("#overFlowDivTree").height();
$(".ulDiv").height(divHeight);
return divHeight;
}
function initTree(){
var searchStr=jQuery.trim(jQuery(".leftSearchInput").val());
//deeptree.init("/workflow/workflow/WorkflowXML.jsp?isTemplate=<%=isTemplate%>&init=true&subCompanyId=<%=subCompanyId%>&operatelevel=<%=operatelevel%>&nodeid=<%=nodeid%>");
//added by cyril on 2008-08-20 for td:9215
//设置选中的ID
<%
String cxtree_id = "workflowtype_1";
if(!cnodeid.equals("") && !cnodeid.equals("0")) {
	cxtree_id = "workflow_"+cnodeid;
}
else {
	if(!Util.null2String(nodeid).equals("") && !nodeid.equals("0"))
		cxtree_id = "workflowtype_"+nodeid;
}
%>
cxtree_id = '<%=cxtree_id%>';
//alert(cxtree_id);
CXLoadTreeItem("", "/workflow/workflow/WorkflowXML.jsp?isWorkflowDoc=<%=isWorkflowDoc %>&isTemplate=<%=isTemplate%>&init=true&subCompanyId=<%=Util.getIntValue(request.getParameter("subCompanyId"),-1)%>&operatelevel=<%=operatelevel%>&nodeid=<%=nodeid%>&workflowIds=<%=workflowIds %>&searchStr="+searchStr);
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
$("#overFlowDiv").height($("#wfmainFrame",window.parent.document).height());
$("#overFlowDivTree").height($("#wfmainFrame",window.parent.document).height());
//end by cyril on 2008-08-20 for td:9215
}

//to use xtree,you must implement top() and showcom(node) functions

function top2(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=workflowtype_<%=nodeid%>.offsetTop;
deeptree.HighlightNode(workflowtype_<%=nodeid%>.parentElement);
deeptree.ExpandNode(workflowtype_<%=nodeid%>.parentElement);
}catch(e){}
<%}%>
}

function showcom(node){
}
function check(node){
	alert(node);
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
    
function setSubCompany(subCompanyId){
    document.all("subCompanyId").value=subCompanyId;
    document.SearchForm.submit();
}


</script>

<script language="vbScript">
 sub onSave()    
    dim trunStr,returnVBArray
    trunStr =  onSaveJavaScript() 
    returnVBArray = Split(trunStr,"_",-1,0)    
    window.parent.returnValue  = returnVBArray
    window.parent.close     
end sub

sub onClear()
     window.parent.returnValue = Array(0,"","")
     window.parent.close
end sub
</script> 

</BODY>
</HTML>