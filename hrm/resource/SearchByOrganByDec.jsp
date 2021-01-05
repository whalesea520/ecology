<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>

<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-08-12 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-08-12 for td:9109 -->
</HEAD>


<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

ArrayList departments=Util.TokenizerString(Util.null2String(request.getParameter("departments")),",");
ArrayList subcompanyids=Util.TokenizerString(Util.null2String(request.getParameter("subcompanyids")),",");
String isdetail = Util.null2String(request.getParameter("isdetail"));
String isbill = Util.null2String(request.getParameter("isbill"));
String fieldid = Util.null2String(request.getParameter("fieldid"));
String detachable = Util.null2String(request.getParameter("detachable"));
String isall=Util.null2String(request.getParameter("isall"));
String onlyselfdept=Util.null2String(request.getParameter("onlyselfdept"));   
String moduleManageDetach=Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)

String isruledesign = Util.null2String(request.getParameter("isruledesign"));

int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("decresourcemulti"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
Cookie ck = new Cookie("decresourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}

//String deptid=ResourceComInfo.getDepartmentID(""+uid);
//if(isall.equals("true")||departments.indexOf(deptid)>-1||subcompanyids.indexOf(DepartmentComInfo.getSubcompanyid1(deptid))>-1) nodeid="dept_"+DepartmentComInfo.getSubcompanyid1(deptid)+"_"+deptid;

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String selectedids=Util.null2String(request.getParameter("selectedids"));

String resourceids = "" ;
String resourcenames ="";
if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	Hashtable ht = new Hashtable();
	while(RecordSet.next()){
		ht.put(RecordSet.getString("id"),RecordSet.getString("lastname"));
		/*
		if(check_per.indexOf(","+RecordSet.getString("id")+",")!=-1){

				resourceids +="," + RecordSet.getString("id");
				resourcenames += ","+RecordSet.getString("lastname");
		}
		*/
	}

	StringTokenizer st = new StringTokenizer(check_per,",");

	while(st.hasMoreTokens()){
		String s = st.nextToken();
		resourceids +=","+s;
		resourcenames += ","+ht.get(s).toString();
	}
	}catch(Exception e){

	}
}
%>

<BODY onload="initTree()">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelectByDec.jsp" method=post target="frame2">
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
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	}
	%>
	<!-- 2012-08-15 ypc 修改 添加了btnok_onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<!-- 2012-08-15 ypc 修改 添加了btnclear_onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick();"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<table width=100% class="ViewForm" valign="top">
	<!--######## Search Table Start########-->



	<TR>
	<td height=170>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>


	</table>
	  <input type="hidden" name="f_weaver_belongto_userid" value="<%=f_weaver_belongto_userid %>"/>
	<input type="hidden" name="f_weaver_belongto_usertype" value="<%=f_weaver_belongto_usertype %>"/>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
<input class=inputstyle type="hidden" name="isdetail" value='<%=isdetail%>'>
<input class=inputstyle type="hidden" name="isbill" value='<%=isbill%>'>
<input class=inputstyle type="hidden" name="fieldid" value='<%=fieldid%>'>
<input class=inputstyle type="hidden" name="detachable" value='<%=detachable%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  
  
  <input class=inputstyle type="hidden" name="selectedids" id="selectedids" value='<%=selectedids%>'>
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount"> 
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
	<!--########//Search Table End########-->
	</FORM>
<SCRIPT type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

var resourceids = "<%=resourceids%>";
function btnclear_onclick(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
    	dialog.callback(returnjson);
    }catch(e){}

		try{
	  	dialog.close(returnjson);
	 	}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
	}
}

function btnok_onclick(){
	window.parent.frame2.btnok.click();
}
function btnok_onclick1(){
	 setResourceStr();
   replaceStr();
   var returnjson={id:resourceids,name:resourcenames};
   if(dialog){
		try{
    	dialog.callback(returnjson);
    }catch(e){}

		try{
	  	dialog.close(returnjson);
	 	}catch(e){}
	}else{
		window.parent.parent.returnValue = returnjson;
    window.parent.parent.close();
	}
}
function btnsub_onclick(){
	setResourceStr();
    $("#resourceids").val(resourceids.substring(1));
    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");
    document.SearchForm.submit();
}
</SCRIPT>



<!-- 初始化zTree的的js函数应该写在body里面才能解决兼容问题 Google 火狐 IE ypc 2012-08-14 -->
<script language="javascript">
var resourceids = "<%=resourceids%>";
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXMLByDec.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>");
//added by cyril on 2008-08-12 for td:9109
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceMultiXMLByDec.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>&isdetail=<%=isdetail %>&isbill=<%=isbill %>&fieldid=<%=fieldid %>&detachable=<%=detachable %>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>");
//CXLoadTreeItem("", "/hrm/tree/ResourceMultiXMLByDec.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%>&onlyselfdept=<%=onlyselfdept%><%}else{%>?onlyselfdept=<%=onlyselfdept%><%}%>");
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
 }catch(e){

    }
<%}%>
}

function showcom(node){
}

function check(node){
}
</script>
</BODY>
</HTML>
<script>

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


}

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

function doSearch()
{
	setResourceStr();
	jQuery("#selectedids").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
	
   document.all("resourceids").value = resourceids.substring(1) ;
   //是否显示无账号人员
    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
      jQuery("#isNoAccount").val("1");
    else
      jQuery("#isNoAccount").val("0");
      
    //是否包含下级机构  
   	if(jQuery(parent.document).find("#frame2").contents().find("#alllevel_c").attr("checked"))
      jQuery("#alllevel").val("1");
    else
      jQuery("#alllevel").val("0");
   document.SearchForm.submit();
}
function setCompany(id){

    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("tabid").value=0
    doSearch()
}
function setSubcompany(nodeid){
		<%if(onlyselfdept.equals("true")){%>
       return ;
    <%}%>
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
function setDepartment(nodeid){
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
</script>