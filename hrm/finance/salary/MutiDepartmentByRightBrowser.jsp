
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
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
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("18939",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->MutiDepartmentByRightBrowser.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18939,user.getLanguage());
String needfav ="1";
String needhelp ="";
int uid=user.getUID();
String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
String rightStr=Util.null2String(request.getParameter("rightStr"));
String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String selectedDepartmentIds = Util.null2String(request.getParameter("selectedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

String selectedids = Util.null2String(request.getParameter("selectedids"));
String[] selecteds = selectedids.split("[,]");
int deptlevel = 0;
int maxnum=0;
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			maxnum = DepartmentComInfo.getLevelByDepId(selecteds[i]);
			if(deptlevel<maxnum){
				deptlevel = maxnum;
			}
		}
	}
}
String selectnode = "";
String supcompanyid = "";
if(!"".equals(selectedids)&&!"0".equals(selectedids)){
	for(int i=0;i<selecteds.length;i++){
		if(!"".equals(selecteds[i])&&!"0".equals(selecteds[i])){
			supcompanyid = DepartmentComInfo.getSubcompanyid1(selecteds[i]);
			selectnode = ",dept_"+supcompanyid+"_"+selecteds[i]+selectnode;
		}
	}
}
if(selectnode.startsWith(",")){
	selectnode = selectnode.substring(1);
}

String scope=Util.null2String(request.getParameter("scope"));    
String nodeid=null;
String nodeids=null;

String[] idss=Util.TokenizerString2(selectedDepartmentIds,",");
%>


<BODY onload="initTree()">
    <DIV align=right>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
        RCMenu += "{"+SystemEnv.getHtmlLabelName(19323,user.getLanguage())+",javascript:needSelectAll(!parent.selectallflag,this),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
    

    <script>
     rightMenu.style.visibility='hidden'
    </script>

    </DIV>

     <FORM NAME=select STYLE="margin-bottom:0" action="MutiDepartmentByRightBrowser.jsp" method=post>
         <input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
         <input class=inputstyle type=hidden name=type value="<%=type%>">
         <input class=inputstyle type=hidden name=id value="<%=id%>">
         <input class=inputstyle type=hidden name=level value="<%=level%>">
         <input class=inputstyle type=hidden name=subid value="<%=subid%>">
         <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
         <textarea style="display:none" name=selectedDepartmentIds ><%=selectedDepartmentIds%></textarea>
         <TABLE  ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
              <TR class=Line1><TH colspan="4" ></TH></TR>
               <TR  >
                   <TD height=400 colspan="4" >
                         <div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" onclick="rightMenu.style.visibility='hidden'" />
                   </TD>
               </TR>
         </TABLE>
     </FORM>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
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
<script language="javaScript">


var selectallflag=false;
var appendimg = 'subCopany_Colse';
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
//to use deeptree,you must implement following methods
function initTree(){
	CXLoadTreeItem("", "/hrm/finance/salary/DepartmentMultiByRightXML.jsp?rightStr=<%=rightStr%>&subcompanyid=<%=subcompanyid%>&scope=<%=scope%>");
	var tree = new WebFXTree();
	tree.add(cxtree_obj);
	document.getElementById('deeptree').innerHTML = tree;
	cxtree_obj.expand();
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

function onSaveJavaScript(){      
    var nameStr="";
    if(select.selObj==null) return "";
    if(typeof(select.selObj.length)=="undefined") {
	if(select.selObj.checked) {
		nameStr =  select.selObj.value;
	}
} else {
	for(var i=0;i<select.selObj.length;i++) {
		if(select.selObj[i].checked) {
			if(select.selObj[i].value.indexOf("_")==0){
				showAjax(select.selObj[i].value.split("_")[1],"com");
				nameStr = nameStr + ajaxvalue;
			}else{
				if(selectallflag){
					if(nameStr.indexOf(select.selObj[i].value)>=0){
						continue;
					}else{
						nameStr = nameStr + select.selObj[i].value + ",";
						showAjax(select.selObj[i].value.split("_")[2],"dep");
						nameStr = nameStr + ajaxvalue;
					}
				}else{
					nameStr = nameStr + select.selObj[i].value + ",";
				}
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
	resultStr1 = resultStr1 + "," + arraytemp[2];
	var strtmp2 = "";
	for(var i=0;i<arraytemp.length;i++){
		if(i>2){
			strtmp2 = strtmp2 + "_" + arraytemp[i];
		}
	}
	resultStr2 = resultStr2 + "," + strtmp2.substring(1);
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
	   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%> ';
	   else
	   a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%> ';
	   obj.value=a;
}
  var parentWin = parent.parent.getParentWindow(parent);
  var dialog = parent.parent.getDialog(parent);
function onSave(){
	var trunStr;
	var returnid,returnname;
	trunStr =  onSaveJavaScript();
	returnid=trunStr.split("$")[0];
	returnname=trunStr.split("$")[1];
	var returnjson = {id:returnid,name:returnname};
	if(dialog){
	   try{
	    dialog.callback(returnjson);
	   }catch(e){}
	   try{
	    dialog.close(returnjson);
	   }catch(e){}
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	 }
	//window.parent.returnValue={id:returnid,name:returnname};
	//window.parent.close();
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
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	 }
		//window.parent.returnValue ={id:"",name:""};
		//window.parent.close();
}

function btncancel_onclick(){
if(dialog){
	   try{
	    dialog.close();
	   }catch(e){}
	}else{  
		window.parent.close();
	}
}
</script>

<!--  <script language="vbScript">
 sub onSave()
    dim trunStr,returnVBArray
    trunStr =  onSaveJavaScript()
    returnVBArray = Split(trunStr,"$",-1,0)
    window.parent.returnValue  = returnVBArray
    window.parent.close
end sub

sub onClear()
     window.parent.returnValue = Array("","")
     window.parent.close
end sub
</script>-->


</HTML>




