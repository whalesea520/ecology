<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-30 [E7 to E8] -->
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
	String _rem = String.valueOf(session.getAttribute("treeleft"));
	if(_rem==null){
		Cookie[] cks= request.getCookies();
		for(int i=0;i<cks.length;i++){
			if(cks[i].getName().equals("treeleft"+uid)){
				_rem=cks[i].getValue();
				break;
			}
		}
	}else{
		_rem=tabid+_rem.substring(1);
		session.setAttribute("treeleft",_rem);
		Cookie ck = new Cookie("treeleft"+uid,_rem);  
		ck.setMaxAge(30*24*60*60);
		response.addCookie(ck);

		String[] atts=Util.TokenizerString2(_rem,"|");
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

	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(33062,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<link type="text/css" rel="stylesheet" href="/css/weaver_wev8.css"/>
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
		</script>
	</HEAD>
	<BODY onload="initTree()">
		<FORM NAME=SearchForm STYLE="margin-bottom:0" action="/hrm/HrmTab.jsp?_fromURL=SignatureList" method=post target="contentframe">
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<script>
				rightMenu.style.visibility='hidden';
			</script>
			<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
			<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
				<tr>
					<td class="leftTypeSearch">
						<div>
							<span class="leftType" onclick="parent.reload();"><%=titlename%><span id="totalDoc"></span></span>
							<span class="leftSearchSpan">
								&nbsp;<input type="text" class="leftSearchInput" style="width:110px;"/>
							</span>
						</div>
					</td>
				</tr>
				<tr>
					<td style="width:23%;" class="flowMenusTd">
						<div id="deeptree" class="cxtree" style="overflow:hidden;" CfgXMLSrc="/css/TreeConfig.xml" />
					</td>
				</tr>
			</table>
			<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
			<input class=inputstyle type="hidden" name="tabid" >
			<input class=inputstyle type="hidden" name="companyid" >
			<input class=inputstyle type="hidden" name="subCompanyId" >
			<input class=inputstyle type="hidden" name="departmentid" >
			<input class=inputstyle type="hidden" name="id" >
			<input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
			<input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
		</FORM>
		<script language="javascript">
			function initTree(){
				CXLoadTreeItem("", "/docs/docs/HrmCompany_XML.jsp?rightStr=<%=rightStr%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
				var tree = new WebFXTree();
				tree.add(cxtree_obj);
				document.getElementById('deeptree').innerHTML = tree;
				cxtree_obj.expand();
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
				document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=SignatureList";
				document.SearchForm.submit();
			}
			function setSubcompany(nodeid){ 
				subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
				document.all("companyid").value="";
				document.all("departmentid").value="";
				document.all("subCompanyId").value=subid;
				document.all("tabid").value=0;
				document.all("id").value=subid;
				document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=SignatureList";
				document.SearchForm.submit();
			}
			function setDepartment(nodeid){
			    var str=nodeid;
			    var s = str.split("_");
				deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
				document.all("subCompanyId").value=s[1];
				document.all("companyid").value="";
				document.all("departmentid").value=s[2];
				document.all("tabid").value=0;
				document.all("id").value=deptid;
				document.SearchForm.action="/hrm/HrmTab.jsp?_fromURL=SignatureList";
				document.SearchForm.submit();
			}

			function btnclear_onclick(){
				 window.parent.returnValue = {id:"",name:""};
				 window.parent.close();
			}
		</script>
	</BODY>
</HTML>