
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ page import="weaver.docs.category.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
	function refreshTreeMain(id,parentId,needRefresh){
		selectNodeId = id;
		if(needRefresh){
			e8_custom_search_for_tree("",id);
		}else{
			selectDefaultNode("categoryid",id);
		}
	}
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(341,user.getLanguage());
String needfav ="1";
String needhelp ="";
String subcompanyId = Util.null2String(request.getParameter("subCompanyId"));
boolean isUseDocManageDetach=ManageDetachComInfo.isUseDocManageDetach();
String hasRightSub=subcompanyId;
String isFromMonitor = Util.null2String(request.getParameter("isFromMonitor"));
String rightStr="DocSecCategoryAdd:Add";
if(isFromMonitor.equals("1")){
rightStr="DocEdit:Edit";
}
MultiAclManager am = new MultiAclManager();
if(subcompanyId.equals("")){
	//subcompanyId = Util.null2String(session.getAttribute("docdftsubcomid"));
	if(isUseDocManageDetach){
	hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),rightStr,-1);
	String hasRightSubFirst="";
	if(!hasRightSub.equals("")){
	  if(hasRightSub.indexOf(',')>-1){  
	      hasRightSubFirst=Util.null2String(hasRightSub.substring(0,hasRightSub.indexOf(',')));
       }else{
          hasRightSubFirst=hasRightSub;
       }
	 //subcompanyId=hasRightSubFirst;
    }
	session.setAttribute("hasRightSub",hasRightSub);
	session.setAttribute("hasRightSub2",hasRightSub);
	}
}
session.setAttribute("maincategory_subcompanyid",subcompanyId);
%>
<BODY scroll="no">
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="DocCategoryEdit.jsp" method=post target="contentframe">
    <input type="hidden" name="seccategory" id="seccategory" value="">
    <input type="hidden" name="id" id="id" value="">
</FORM>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType">
				<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"></span>
				<span><%= SystemEnv.getHtmlLabelName(16398,user.getLanguage())%></span>
				<span id="totalDoc"></span>
				</span>
				<span class="leftSearchSpan">
					<input type="text" class="leftSearchInput"/>
				</span>
			</div>
		</td>
		<td rowspan="2">
			<iframe src="DocCategoryTab.jsp?isFromMonitor=<%=isFromMonitor%>&subCompanyId=<%=subcompanyId%>" id="contentframe" name="contentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
		</td>
	</tr>
	<tr>
		<td style="width:246px;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
	
	<script type="text/javascript">
		function leftMenuClickFn(attr,level,numberType,node,options){
			var treeNode = options.treeNode;
			var id = treeNode.categoryid;
			document.getElementById("seccategory").value = id;
			document.getElementById("id").value = id;
			document.SearchForm.action = "DocCategoryTab.jsp?_fromURL=3&isFromMonitor=<%=isFromMonitor%>&subCompanyId=<%=subcompanyId%>";
			document.SearchForm.submit();
		}
		function e8_custom_search_for_tree(categoryname,value){
			var expandAllFlag = !categoryname?false:true;
			jQuery.ajax({
				url:"DocCategoryTreeLeft.jsp",
				type:"post",
				dataType:"json",
				data:{
					categoryname:categoryname,
					subCompanyId:'<%=hasRightSub%>'
				},
				complete:function(xhr){
					e8_after2();
				},
				success:function(data){
					var demoLeftMenus = data;
					$(".ulDiv").leftNumMenu(demoLeftMenus,{
							showZero:false,
							addDiyDom:false,
							multiJson:true,	
							_callback:expandAllFlag?_expandAll:null,	
							clickFunction:function(attr,level,numberType,node,options){
								leftMenuClickFn(attr,level,numberType,node,options);
							}
					});
					try{
						selectDefaultNode("categoryid",value);
					}catch(e){}
				}
			});
		}
		jQuery(document).ready(function(){
			e8_custom_search_for_tree("");
		});
	</script>
