<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RoleComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GroupAction" class="weaver.hrm.group.GroupAction" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-07-31 for td:9109 -->
<style>
#divTree { overflow: scroll; height: 170; width: 100%; }
</style>
<script src="/js/tree_wev8.js"></script>

</HEAD>

<BODY onload="" oncontextmenu="return false;">
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1867,user.getLanguage());
String needfav ="1";
String needhelp ="";

int uid=user.getUID();
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
rem="1"+rem.substring(1);
Cookie ck = new Cookie("resourcemulti"+uid,rem);  
ck.setMaxAge(30*24*60*60);
response.addCookie(ck);

String[] atts=Util.TokenizerString2(rem,"|");
if(atts.length>1)
nodeid=atts[1];
}
nodeid = ""+Util.getIntValue(nodeid, -2);
//List grouplist=GroupAction.getGroupTree(user);
//System.out.println("nodes"+grouplist.size());
//request.setAttribute("grouplist",grouplist);
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String status = Util.null2String(request.getParameter("status"));
String check_per = Util.null2String(request.getParameter("resourceids"));
String moduleManageDetach= Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)
String fromHrmStatusChange = Util.null2String(request.getParameter("fromHrmStatusChange"));

String resourceids = "" ;
String resourcenames ="";

if(!check_per.equals("")){
	try{
	String strtmp = "select id,lastname from HrmResource where id in ("+check_per+")";
	RecordSet.executeSql(strtmp);
	//System.out.println(strtmp);
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
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
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
	//这里要在SearchForm.btnok.click()前面加上document 在火狐中才可以识别 2012-08-15 ypc 修改
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
	<!--2012-08-15 ypc 修改 确定:btnok_onclick() 清楚:btnclear_onclick() 在此页面是vbs 在Google和火狐是调用不到的！-->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
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
<table height="100%" width=100% class="ViewForm" valign="top">
	
	<!--######## Search Table Start########-->
	
	
	
	<TR>
	<td>
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
	<td>
	</tr>
	
	
	</table>
	<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
	<input class=inputstyle type="hidden" name="status" value='<%=status%>'>
  <input class=inputstyle type="hidden" id="resourceids" name="resourceids" >
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="groupid" value="<%=Util.null2String(nodeid)%>">
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="isNoAccount" id="isNoAccount">
  <input class=inputstyle type="hidden" name="moduleManageDetach" id="moduleManageDetach">
  <input class=inputstyle type="hidden" name="fromHrmStatusChange" id="fromHrmStatusChange" value='<%=fromHrmStatusChange%>'> 
	<!--########//Search Table End########-->
	</FORM>


  
<script language="javascript">
$(function(){
	initTree();
});
function initTree(){
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
CXLoadTreeItem("", "/hrm/tree/ResourceMultiXMLByGroup.jsp");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
</script>

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
	var dialog = null;
	try{
		dialog = parent.parent.parent.getDialog(parent.parent);
	}catch(ex1){}
	
 	var resourceids = "";
 	var resourcenames = "";
 	
 	function btnok_onclick(){
		window.parent.frame2.btnok.click();
	}
	function btnok_onclick1(){
		setResourceStr();
		replaceStr();
		window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
		window.parent.parent.close();
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
    }

function replaceStr(){
    var re=new RegExp("[ ]*[|][^|]*[|]","g")
    resourcenames=resourcenames.replace(re,"|")
    re=new RegExp("[|][^,]*","g")
    resourcenames=resourcenames.replace(re,"")
}

//由于本页面的此方法是用vbs 写的 在Google和火狐中是不识别的 所以要改写成js
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
		jQuery("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
    //是否显示无账号人员 
    if(jQuery(parent.document).find("#frame2").contents().find("#isNoAccount").attr("checked"))
      jQuery("#isNoAccount").val("1");
    else
      jQuery("#isNoAccount").val("0");
      
    jQuery("#moduleManageDetach").val("<%=moduleManageDetach%>");     
    document.SearchForm.submit();
}
function setGroup(id){
    jQuery("input[name=groupid]").val(id);
		jQuery("input[name=nodeid]").val(id);
		jQuery("input[name=tabid]").val(1);
		
    doSearch();
}

</script>
</BODY>
</HTML>