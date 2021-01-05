
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <script type="text/javascript" src="/js/xtree_wev8.js"></script>
	<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
	<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
    <link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
    <script type="text/javascript">
   try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->MultiSubcompanyBrowserByDec.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>
<%
String f_weaver_belongto_userid=Util.fromScreen(request.getParameter("f_weaver_belongto_userid"),user.getLanguage());
String f_weaver_belongto_usertype=Util.fromScreen(request.getParameter("f_weaver_belongto_usertype"),user.getLanguage());
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
int beagenter = Util.getIntValue((String)session.getAttribute("beagenter_"+user.getUID()));
if(beagenter <= 0){
	beagenter = uid;
}
String isruledesign = Util.null2String(request.getParameter("isruledesign"));
//判断是否是管理员
boolean isadmin = false;
String adminsql = "select * from HrmResourceManager where id = " + beagenter;
RecordSet.executeSql(adminsql);
if(RecordSet.next()){
	isadmin = true;
}

if(isadmin && "true".equals(isruledesign)){
	beagenter = 1;
}

String excludeid=Util.null2String(request.getParameter("excludeid"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String selectedids = Util.null2String(request.getParameter("selectedids"));

String[] selecteds = selectedids.split("[,]");
String selectnode = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			selectnode = ",com_"+selecteds[i]+selectnode;
		}
	}
}
if(selectnode.startsWith(",")){
	selectnode = selectnode.substring(1);
}
int fieldid=Util.getIntValue(request.getParameter("fieldid"));
    int isdetail=Util.getIntValue(request.getParameter("isdetail"));
    int isbill=Util.getIntValue(request.getParameter("isbill"),1);
    boolean onlyselfdept=CheckSubCompanyRight.getDecentralizationAttr(beagenter,"Subcompanys:decentralization",fieldid,isdetail,isbill);
    
String nodeid=null;
/*
ArrayList cks=Util.TokenizerString(selectedDepartmentIds,",");
String rem=null;
for(int i=0;i<cks.size();i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("departmentsingle"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>0)
nodeid=rem;

boolean exist=false;
if(nodeid!=null&&nodeid.indexOf("dept")>-1){
    String deptname=DepartmentComInfo.getDepartmentname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(nodeid.substring(nodeid.lastIndexOf("_")+1));
    if(!deptname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
       exist=true;
    else
      exist=false;
}
if(!exist)
nodeid=null;
*/
String[] ids=Util.TokenizerString2(selectedDepartmentIds,",");

//System.out.println("nodeid:"+nodeid);

%>


<BODY onload="initTree()">
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
   	<FORM NAME=select STYLE="margin-bottom:0" action="MultiSubcompanyBrowserByDec.jsp" method=post>
       <input class=inputstyle type=hidden name=type value="<%=type%>">
       <input class=inputstyle type=hidden name=id value="<%=id%>">
       <input class=inputstyle type=hidden name=level value="<%=level%>">
       <input class=inputstyle type=hidden name=subid value="<%=subid%>">
       <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
       <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
       <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
       <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
            <TR class=Line1><TH colspan="4" ></TH></TR>
             <TR>
                 <TD height=400 colspan="4" >
                   <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
                 </TD>
             </TR>
       </TABLE>
    </FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col" needImportDefaultJsAndCss="false">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" class=zd_btn_submit accessKey=O  id=btnok onclick="onSave()" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>">
				<input type="button" class=zd_btn_submit accessKey=2  id=btnclear onclick="onClear()" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>">
	      <input type="button" class=zd_btn_submit accessKey=T  id=btncancel onclick="btncancel_onclick()" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</BODY>
</HTML>

<script language="javaScript">
//to use deeptree,you must implement following methods
var selectallflag=false;
var appendimg = 'Home';
var appendname = 'selObj';
var allselect = "all";
var typename = "checkbox";
var selectreview = "openall";
var selectedids = "<%=selectedids%>";
if(selectedids!="0"&&selectedids!=""){
	cxtree_id = "<%=selectnode%>";
	cxtree_ids = cxtree_id.split(',');
	cxtree_id = cxtree_ids[0];
} 
var xmlHttp;
var ajaxvalue;
function showAjax(subId,suptype){
	if(window.ActiveXObject){
        xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    else if(window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    }
    xmlHttp.onreadystatechange = getReturnValue;
	xmlHttp.open("get","MutiDepartmentAjax.jsp?subId="+subId+"&suptype="+suptype,false); 
	xmlHttp.send(); 
}
function getReturnValue(){
	if(xmlHttp.readystate==4){ 
		if(xmlHttp.status==200){
			var returnTemp = xmlHttp.responseText;
			ajaxvalue = returnTemp;
		}
	}
}
function initTree(){
	CXLoadTreeItem("", "/hrm/tree/SubcompanyMutiXMLByDec.jsp?onlyselfdept=<%=onlyselfdept%>&excludeid=<%=excludeid%><%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>&f_weaver_belongto_userid=<%=f_weaver_belongto_userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isruledesign=<%=isruledesign%>&mathrandom="+Math.random());
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
	}

function onSaveJavaScript(){      
    var nameStr="";
    if(select.selObj==null) return "";
    if(typeof(select.selObj.length)=="undefined") {
		if(select.selObj.checked) {
			nameStr =  select.selObj.value.replace(",","，");
		}
	} else {
		for(var i=0;i<select.selObj.length;i++) {
			if(select.selObj[i].checked) {
				if(selectallflag){
					if(nameStr.indexOf(select.selObj[i].value)>=0){
						continue;
					}else{
						nameStr = nameStr + select.selObj[i].value.replace(",","，") + ",";
						showAjax(select.selObj[i].value.split("_")[1],"subcom");
						nameStr = nameStr + ajaxvalue;
					}
				}else{
					nameStr = nameStr + select.selObj[i].value.replace(",","，") + ",";
				}
			}
		}
	}
	arrayname = nameStr.split(",");
	var resultStr1="";
	var resultStr2="";
	for(var j=0;j<arrayname.length;j++){
		arraytemp = arrayname[j].split("_");
		if(arraytemp.length==1){
			break;
		}
		if(resultStr1.length>0)resultStr1+=",";
		resultStr1 += arraytemp[1];
		var strtmp2 = "";
		for(var i=0;i<arraytemp.length;i++){
			if(i>1){
				strtmp2 = strtmp2 + "_" + arraytemp[i];
			}
		}
		if(resultStr2.length>0)resultStr2+=",";
		resultStr2 += strtmp2.substring(1);
	}
    return resultStr1+"$"+resultStr2;
}

function showallcheckbox(node){
	for(var i=0;i<node.childNodes.length;i++){
		if(node.childNodes[i].folder){
			if(node.childNodes[i].icon.indexOf(appendimg)<1){
				if(selectallflag){
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="";	
				}else{
					document.getElementById(node.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display="none";
				}
			}
			showallcheckbox(node.childNodes[i]);
		}else{
			continue;
		}
	}
}
function needSelectAll(flag,obj){
	selectallflag=flag;
	   showallcheckbox(cxtree_obj);
	   i=obj.value.indexOf('>');
	   if(selectallflag)
	     obj.innerHTML='<%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
	   else
	     obj.innerHTML='<%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
	   obj.value=obj.innerHTML;
}
function onSave(){
	 var trunStr,returnVBArray;
   trunStr =  onSaveJavaScript();
   returnVBArray = trunStr.split("$");
   var returnjson = {id:returnVBArray[0],name:returnVBArray[1]};
   if(dialog){
   	try{
          dialog.callback(returnjson);
     }catch(e){}

	try{
		dialog.close(returnjson);
	}catch(e){}
   }else{
    window.parent.parent.returnValue  = returnjson;
   	window.parent.close();
   }
}

function onClear(){
	var returnjson = {id:"",name:""};
	if(dialog){
		try{
	          dialog.callback(returnjson);
	     }catch(e){}

		try{
		     dialog.close(returnjson);
		 }catch(e){}
   }else{
		window.parent.parent.returnValue  = returnjson;
	   	window.parent.close();
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