<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="recordSet4" class="weaver.conn.RecordSet" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
int showOldBrowser = Util.getIntValue(request.getParameter("showOldBrowser"), 0);

if(showOldBrowser==1){
}else{
	request.getRequestDispatcher("/fna/maintenance/BudgetfeeTypeBrowserNew.jsp").forward(request, response);
	return;
}


int enableDispalyAll=0;
String separator ="";
int subjectBrowseDefExpanded = 0;//单科目浏览框默认展开
recordSet4.executeSql("select * from FnaSystemSet");
while(recordSet4.next()){
	enableDispalyAll = recordSet4.getInt("enableDispalyAll");
	separator = recordSet4.getString("separator");
	subjectBrowseDefExpanded = Util.getIntValue(recordSet4.getString("subjectBrowseDefExpanded"), 0);
}

int filterlevel = Util.getIntValue(request.getParameter("level"),0);
String displayarchive=Util.null2String(request.getParameter("displayarchive"));//是否显示封存科目
String fromWfFnaBudgetChgApply=Util.null2String(request.getParameter("fromWfFnaBudgetChgApply")).trim();//=1：来自系统表单预算变更申请单
int orgType = Util.getIntValue(request.getParameter("orgType"),-1);
int orgId = Util.getIntValue(request.getParameter("orgId"),-1);
int fromFnaRequest = Util.getIntValue(request.getParameter("fromFnaRequest"),-1);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),-1);
int fieldid = Util.getIntValue(request.getParameter("fieldid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),-1);


int filterfeetype = 0;
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

if(sqlwhere.indexOf("displayarchive=0")>0) displayarchive="0";

if("".equals(displayarchive)){
	displayarchive = "1";
}

if(sqlwhere.indexOf("feetype='1'")>0) filterfeetype=1;
else if(sqlwhere.indexOf("feetype='2'")>0) filterfeetype=2;
if(filterfeetype>0&&filterlevel==0) filterlevel=3;
%>

<HTML>
<HEAD>
<script type="text/javascript">
var _fna_subjectBrowseDefExpanded = "<%=subjectBrowseDefExpanded %>";
</script>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<!-- added by cyril on 2008-10-29 for td:9332 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js?r=1"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<!-- end by cyril on 2008-10-29 for td:9332 -->
</HEAD>

<BODY onload="initTree()">
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


	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="fna"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(27766, user.getLanguage()) %>"/>
	</jsp:include>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td>
			<td class="rightSearchSpan" style="text-align: right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
		
	<FORM NAME=select STYLE="margin-bottom:0" method=post>
		<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />   
	</FORM>
	
</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" class="zd_btn_cancle" accessKey=O  id=btnok onclick="onSave();" 
					value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
				<input type="button" class="zd_btn_cancle" accessKey=2  id=btnclear onclick="onClear();" 
					value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
		        <input type="button" class="zd_btn_cancle" accessKey=T  id=btncancel onclick="btncancel_onclick();" 
		        	value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
    <script language="javaScript">
			//要把声明 radio的代码写在body里面(body加载的时候就要实例化)
				var temp_imgname = '';
				<%
				if(filterlevel==0) {
				%>
				temp_imgname = '3';
				<%
				}
				else {
				%>
				temp_imgname = '<%=filterlevel%>';
				<%
				}
				%>
				var appendimg = 'subject'+temp_imgname;
				var appendname = 'selObj';
				
				//保存的js函数要写在body 里面 谷歌浏览器才识别
				function onSave(){
					var trunStr = onSaveJavaScript();
					var _trunStr = null;
					if(trunStr && !trunStr.id){
						var _trunStrArray = trunStr.split("_");
						try{
							_trunStr = {"id":_trunStrArray[0],"name":_trunStrArray[1]};
						}catch(ex1){}
					}else{
						_trunStr = trunStr;
					}
					onSave2(_trunStr);
				}
				//保存的js函数要写在body 里面 谷歌浏览器才识别
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
								nameStr =  select.selObj[i].value;
								break;
							}
						}
					}
				    return nameStr;   
				} 
		</script>
</BODY>
</HTML>


<script type="text/javascript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.parent.getParentWindow(parent);
dialog = parent.parent.parent.getDialog(parent);
}catch(e){}
</script>

<script language="javaScript">
function onSave2(trunStr) {
	//var trunStr = "";
	var returnVBArray = null;
	//trunStr = onSaveJavaScript();
    if(trunStr && trunStr.id) {
		var returnjson = {id:trunStr.id, name:trunStr.name};
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
    }else{
		if(dialog){
			dialog.close();
		}else{
			window.parent.parent.close();
		}    
	}
}

function onClear() {
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

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
  		window.parent.parent.close();
	}
}
	
function initTree(){
//deeptree.init("/fna/maintenance/SubjectSingleXML.jsp?init=true&type=L0&level=<%=filterlevel%>&feetype=<%=filterfeetype%>");
//added by cyril on 2008-07-31 for td:9109
//设置选中的ID
cxtree_id = '';
CXLoadTreeItem("", "/fna/maintenance/SubjectSingleXML.jsp?init=true&type=L0&level=<%=filterlevel%>&feetype=<%=filterfeetype%>&displayarchive=<%=displayarchive%>&fromWfFnaBudgetChgApply=<%=fromWfFnaBudgetChgApply %>&orgType=<%=orgType%>&orgId=<%=orgId%>&fromFnaRequest=<%=fromFnaRequest%>&workflowid=<%=workflowid%>&fieldid=<%=fieldid%>&billid=<%=billid%>");
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}

function top(){

}
//node is a DIV object
function showcom(node){
}

function check(node){
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
</script>
