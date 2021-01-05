<!-- 
|last modified by cyril on 2008-07-31
|改写人力资源树
|将deepTree改成xtree,取消HTC控件
 -->
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="appDetachComInfo" class="weaver.hrm.appdetach.AppDetachComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
</HEAD>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

int uid=user.getUID();
int tabid=0;

String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("resourcemulti"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
if(rem!=null){
rem=tabid+rem.substring(1);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
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

//判断应用分权，如果没有权限看选中的结构则删除默认指定机构

if(appDetachComInfo.isUseAppDetach()){
if(nodeid!=null&&nodeid.indexOf("com")>-1){
	if(appDetachComInfo.checkUserAppDetach(nodeid.substring(nodeid.lastIndexOf("_")+1), "2", user)==0)  exist=false; 
} else if(nodeid!=null&&nodeid.indexOf("dept")>-1){
   if(appDetachComInfo.checkUserAppDetach(nodeid.substring(nodeid.lastIndexOf("_")+1), "3", user)==0)  exist=false;    
}
}

if(!exist)
nodeid=null;

String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String moduleManageDetach=Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));
String virtualtype=Util.null2String(request.getParameter("virtualtype"));

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

<BODY  oncontextmenu="return false;">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MutiSelect.jsp" method=post target="frame2">
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())

+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())

+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<button type="button" class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<button type="button" class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
	
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
<table width=100% class="ViewForm" valign="top" height="100%">
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td height=170 width="100%">
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
  <input class=inputstyle type="hidden" name="status" value='<%=status%>'>
  <input class=inputstyle type="hidden" name="resourceids">
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount"> 
  <input class=inputstyle type="hidden" name="alllevel" id="alllevel" value="1"/>
  <input class=inputstyle type="hidden" name="moduleManageDetach" id="moduleManageDetach"> 
  <input class=inputstyle type=hidden name=virtualtype value="<%=virtualtype%>">
  <input class=inputstyle type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'> 
	<!--########//Search Table End########-->
	</FORM>
 
<SCRIPT type="text/javascript">
var dialog = null;
try{
	dialog = parent.parent.parent.getDialog(parent.parent);
}catch(ex1){}

var resourceids = "<%=resourceids%>";
var resourcenames = "<%=resourcenames%>";
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
		jQuery("input[name=resourceids]").val(window.parent.frame2.systemIds.value);
    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");
    document.SearchForm.submit();
}
</SCRIPT>
<script language="javascript">
var virtualtype = '<%=virtualtype%>';
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
if(virtualtype==""){
	CXLoadTreeItem("", "/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
}else{
	CXLoadTreeItem("", "/hrm/companyvirtual/HrmCompany_XML.jsp?virtualtype="+virtualtype);
}
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
//to use xtree,you must implement top() and showcom(node) functions

function top111(){
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
</body>
</html>
<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 start -->
<script language="javascript">
	$(function(){
		initTree();
	});
	
	function setResourceStr(){
		var resourceids1 =""
	  var resourcenames1 = ""
	  try{
			var frame2;   
			for(var i=0;i<parent.frame2.resourceArray.length;i++){
				resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
				resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
			}
			resourceids=resourceids1
			resourcenames=resourcenames1
	   }catch(err){
			//alert(err.message)
		 }		
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
		jQuery("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());;
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
      
    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");
    
    if(virtualtype!="")
    	document.SearchForm.action="MutiSelect.jsp";
    else
    	document.SearchForm.action="MutiSelect.jsp";  
    document.SearchForm.submit();
}
function setCompany(id){
    //alert('setCompany');
    document.all("departmentid").value=""
    document.all("subcompanyid").value=""
    document.all("companyid").value=id
    document.all("tabid").value=0
    doSearch()
}
function setSubcompany(nodeid){ 
    //alert('setSubcompany');
    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("companyid").value=""
    document.all("departmentid").value=""
    document.all("subcompanyid").value=subid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
function setDepartment(nodeid){
	//alert('setDepartment');
    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
    document.all("subcompanyid").value=""
    document.all("companyid").value=""
    document.all("departmentid").value=deptid
    document.all("tabid").value=0
    document.all("nodeid").value=nodeid
    doSearch()
}
</script>
<!-- 一下js代码是从body体 里面挪出来的 2012-8-06  ypc 修改 end -->