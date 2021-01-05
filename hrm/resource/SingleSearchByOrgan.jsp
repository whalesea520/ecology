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
<jsp:useBean id="appDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}
 </script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());

String needsystem = Util.null2String(request.getParameter("needsystem"));
String seclevelto=Util.fromScreen(request.getParameter("seclevelto"),user.getLanguage());
String from = Util.null2String(request.getParameter("from"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));
String sqltag=Util.null2String(request.getParameter("sqltag"));

int uid=user.getUID();
int tabid=0;


String nodeid=null;
String rem=null;

        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcesingle"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }

if(rem!=null){
rem=tabid+rem.substring(1);

Cookie ck = new Cookie("resourcesingle"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("com")>-1){
String tmpNodeid = nodeid.substring(nodeid.lastIndexOf("_")+1);
if(!SubCompanyComInfo.getSubCompanyname(tmpNodeid).equals("")){
	exist= SubCompanyComInfo.getCompanyiscanceled(tmpNodeid).equals("1")?false:true;
}

}else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
	String tmpNodeid = nodeid.substring(nodeid.lastIndexOf("_")+1);
String deptname=DepartmentComInfo.getDepartmentname(tmpNodeid);
String subcom=DepartmentComInfo.getSubcompanyid1(tmpNodeid);
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_")))){
       String subCancel = SubCompanyComInfo.getCompanyiscanceled(subcom);
       String depCancel = DepartmentComInfo.getDeparmentcanceled(tmpNodeid);
       exist= (subCancel.equals("1")||depCancel.equals("1"))?false:true;
    }
    else
      exist=false;
}

//判断应用分权，如果没有权限看选中的结构则删除默认指定机构

if(appDetachComInfo.isUseAppDetach()){
  if(nodeid!=null&&nodeid.indexOf("com")>-1){
	  if(appDetachComInfo.checkUserAppDetach(nodeid.substring(nodeid.lastIndexOf("_")+1), "2", user)==0){
	     exist=false;
	  } 
  } else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
      if(appDetachComInfo.checkUserAppDetach(nodeid.substring(nodeid.lastIndexOf("_")+1), "3", user)==0){
          exist=false; 
      }   
  }
}


        
if(!exist)
nodeid=null;

%>

<BODY >
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="Select1.jsp" method=post target="frame2">
	<input class=inputstyle type=hidden name=sqltag value=<%=sqltag%>>
	<input class=inputstyle type=hidden name=from value=<%=from%>>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
BaseBean baseBean_self = new BaseBean();
int userightmenu_self = 1;
try{
	userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
if(userightmenu_self == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+", javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BUTTON class=btnok accessKey=1 style="display:none" onclick="btncancel_onclick()" id=btnok><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
<script>
rightMenu.style.visibility='hidden'
</script>	

<table width=100% class="ViewForm" valign="top" height="170px">
<!-- ypc 2012-09-13 修改 把height="100%" 修改为 height="170px" -->
	

	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height="170px">
	<!-- ypc 2012-09-13 在此添加样式 -->
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"  style="overflow-x:hidden;overflow-y:hidden;height:100%;"/>
	</td>
	</tr>
	</table>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type=hidden name=seclevelto value="<%=seclevelto%>">
  <input class=inputstyle type=hidden name=needsystem value="<%=needsystem%>">
  <input class=inputstyle type=hidden name=virtualtype value="<%=virtualtype%>">
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
  <input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>"/>
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype %>"/>
	<!--########//Search Table End########-->
	</FORM>


<script language="javascript">

	function initTree(){
	var virtualtype = '<%=virtualtype%>';
	//deeptree.init("/hrm/tree/ResourceSingleXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
	//added by cyril on 2008-07-31 for td:9109
	//设置选中的ID
	cxtree_id = '<%=Util.null2String(nodeid)%>';
	if(virtualtype==""){
		CXLoadTreeItem("", "/hrm/tree/ResourceSingleXML.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
	}else{
		CXLoadTreeItem("", "/hrm/companyvirtual/HrmCompany_XML.jsp?f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&virtualtype="+virtualtype);
	}
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	//document.write(tree);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	//end by cyril on 2008-07-31 for td:9109
	}
	
   function showcom(node){
	}
	
	function check(node){
	}
</script>
</BODY>
</HTML>

<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 start -->
<script language="javascript">
var virtualtype = '<%=virtualtype%>';
    $(function(){
	 	initTree();
    });

	function setCompany(id){
	    $("input[name=departmentid]").val("");
	    $("input[name=subcompanyid]").val("");
	    $("input[name=companyid]").val(id);
	    $("tabid").val(0);
	    //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");
	   
	   //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
      
      if(virtualtype!="")
      	document.SearchForm.action="SelectVirtual.jsp";
      else
      	document.SearchForm.action="Select1.jsp";
	    document.SearchForm.submit();
	}
	function setSubcompany(nodeid){ 
	    
	    subid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    $("input[name=subcompanyid]").val(subid);
	    $("input[name=companyid]").val("");
	    $("input[name=departmentid]").val("");
	    $("input[name=tabid]").val(0);
	    $("input[name=nodeid]").val(nodeid);
	    //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");

	   //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
      
    if(virtualtype!="")
    	document.SearchForm.action="SelectVirtual.jsp";
    else
    	document.SearchForm.action="Select1.jsp";
	  document.SearchForm.submit();
	}
	function setDepartment(nodeid){
	    
	    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1);
	    $("input[name=subcompanyid]").val("");
	    $("input[name=companyid]").val("");
	    $("input[name=departmentid]").val(deptid);
	    $("input[name=tabid]").val(0);
	    $("input[name=nodeid]").val(nodeid);
	    //是否显示无账号人员 
	    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
	      jQuery("#isNoAccount").val("1");
	    else
	      jQuery("#isNoAccount").val("0");
	              //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
      
   if(virtualtype!="")
    	document.SearchForm.action="SelectVirtual.jsp";
    else
    	document.SearchForm.action="Select1.jsp";
    	
	    document.SearchForm.submit();
	}
	
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
	
	function btncancel_onclick(){
		if(dialog){
	  	dialog.close();
	  }else{
	    window.parent.parent.close();
		}   
	}
</script>