<!-- 
|last modified by cyril on 2008-07-31
|改写人力资源树
|将deepTree改成xtree,取消HTC控件
 -->
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<script type="text/javascript"> 
  var dialog = null;
  try{
 		dialog = parent.parent.parent.getDialog(parent.parent);
  }catch(e){ }
 </script>
<!-- end by cyril on 2008-07-31 for td:9109 -->
</HEAD>


<%
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6086,user.getLanguage());
String needfav ="1";
String needhelp ="";

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));

int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=(String)session.getAttribute("jobtitlesingle");
        if(rem==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("jobtitlesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
session.setAttribute("jobtitlesingle",rem);
Cookie ck = new Cookie("jobtitlesingle"+uid,rem);
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
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<BODY onload="initTree()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select.jsp" method=post target="frame2">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.frame2.btncancel_onclick(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:parent.frame2.btnclear_onclick();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="window.parent.parent.close()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%


%>	
<!-- 2012-08-15 ypc 修改 添加了btnclear_onclick() 事件 -->
<BUTTON class=btn accessKey=2 style="display:none" id="btnclear" onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%}%>
<table width=100% class="ViewForm" valign="top" height="100%">
	
	<!--######## Search Table Start########-->
	
	<tr>
	<td height="170" width="100%">
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"></div>
	</td>
	</tr>
	
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
	<!--########//Search Table End########-->
	


<script language="javascript">
function initTree(){
//deeptree.init("/hrm/tree/ResourceSingleXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceSingleXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
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
</script>
</FORM>
<SCRIPT LANGUAGE=VBS>
Sub btnclear_onclick()
     window.parent.returnvalue = Array("","")
     window.parent.close
End Sub
</SCRIPT>
</BODY>
</HTML>
<!-- 一下这部分代码从body体里面移到body体外边 就解决在Google和火狐浏览器中　打开流程表单中的＂职务＂类型浏览框，选中相应部门下的岗位 2012-08-08 ypc 修改 start-->
<script language="javascript">
//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js
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
	
	function setCompany(id){
	    document.all("departmentid").value="";
	    document.all("subcompanyid").value="";
	    document.all("companyid").value=id;
	    document.all("tabid").value=0;
	    document.SearchForm.submit();
	}
	function setSubcompany(nodeid){ 
	    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    document.all("companyid").value="";
	    document.all("departmentid").value="";
	    document.all("subcompanyid").value=subid;
	    document.all("tabid").value=0;
	    document.all("nodeid").value=nodeid;
	    document.SearchForm.submit();
	}
	function setDepartment(nodeid){
	    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    document.all("subcompanyid").value="";
	    document.all("companyid").value="";
	    document.all("departmentid").value=deptid;
	    document.all("tabid").value=0;
	    document.all("nodeid").value=nodeid;
	    document.SearchForm.submit();
	}		
</script>
<!-- 一下这部分代码从body体里面移到body体外边 就解决在Google和火狐浏览器中　打开流程表单中的＂职务＂类型浏览框，选中相应部门下的岗位 2012-08-08 ypc 修改 e-->