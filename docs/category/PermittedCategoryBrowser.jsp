<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    int operationcode = Util.getIntValue(request.getParameter("operationcode"), -1);
    AclManager am = new AclManager();
    if (categoryid != -1 && categorytype != -1) {
        if (!am.hasPermission(categoryid, categorytype, user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode)) {
            response.sendRedirect("/notice/noright.jsp");
        	return;
        }
    }
    CategoryTree tree = am.getPermittedTree(user.getUID(), user.getType(), Util.getIntValue(user.getSeclevel(),0), operationcode);
%>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("67",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->CategoryBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<script>
function clearCategory() {
    if(dialog){
		try{
		dialog.callback({id:"",name:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:""});
		}catch(e){}
	}else{
    	window.parent.returnValue={id:"",name:""}
    	window.parent.close();
    }
}
function onClose(){
	if(dialog){
		dialog.close();
	}else{
    	window.parent.close();
    }
}
function selectCategory(nodeID) {
    var node = tree.getNode(nodeID);
    var path = node.text;
    var id = node.categoryid;
    var subid = -1;
    var mainid = -1;
    while (node.parent != null) {
        path = node.parent.text + "/" + path;
        if (node.parent.categorytype == 1 && subid == -1) {
            subid = node.parent.categoryid;
        }
        if (node.parent.categorytype == 0) {
            mainid = node.parent.categoryid;
        }
        node = node.parent;
    }
    if(dialog){
		try{
		dialog.callback({tag:1,id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,});
		}catch(e){}
		try{
		dialog.close({tag:1,id:""+id, path:""+path, mainid:""+mainid, subid:""+subid});
		}catch(e){}
	}else{
	    window.parent.returnValue = {tag:1,id:""+id, path:""+path, mainid:""+mainid, subid:""+subid};
	    window.parent.close();
	}
}
</script>
</HEAD>
<BODY>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>



<iframe height=0 src="about:blank" width=0></iframe>

<DIV align=right style="display:none">

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=1 onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type="button" class=btn accessKey=2 onclick="clearCategory()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>


<script src=/js/tree_maker_wev8.js></script>
<script>
function load(nodeID) // nodeID为点击结点的id
{
    var node = tree.getNode(nodeID);
    if( node && node.loaded!=true ) // 如果未加载就载入子菜单
    {  	
		var str=new String(window.location);
		str=str.substring(0,str.lastIndexOf("/")+1);
        window.frames[0].location= str +"OpenCategory.jsp?categoryid="+node.categoryid+"&categorytype="+node.categorytype+"&node="+nodeID;
    }
}
function findThisNode(categoryid, categorytype) {
    var i;
    var node;
    for (i=0;i<Tree_node_array.length;i++) {
        node = Tree_node_array[i];
        if (node != null && node.categoryid == categoryid && node.categorytype == categorytype) {
            return node;
        }
    }
    return null;
}
function loadthisnode(categoryid, categorytype) {
    var node = findThisNode(categoryid, categorytype);
    if (node != null) {
        load(node.id);
    }
}
function expandthisnode(categoryid, categorytype) {
    var node = findThisNode(categoryid, categorytype);
    if (node != null) {
        alert('expanding ' + node.text);
        node.expand(true);
    }
}
</script>
<script>
var tree = new Tree_treeView(); // 生成 Tree_treeView 对象
tree.showLine=true; //显示连线
tree.lineFolder = "/images/treemaker/"
tree.fileImg="/images/treemaker/link_wev8.gif"; // 设置默认图片
tree.folderImg1="/images/treemaker/clsfld_wev8.gif";
tree.folderImg2="/images/treemaker/openfld_wev8.gif";
var node;
var parentNode;
<%
    CategoryUtil.generateAddNodeScript(out, tree.mainCategories, null);
    if (categoryid > 0) {
        if (categorytype == AclManager.CATEGORYTYPE_SUB || categorytype == AclManager.CATEGORYTYPE_SEC) {
            int id;
            int type;
            CategoryManager cm = new CategoryManager();
            RecordSet rs = cm.getSuperiorSubCategoryList(categoryid, categorytype);
            int i = 0;
            while (rs.next()) {
                if (i == 0) {
                    i = 1;
                    id = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(rs.getString("subcategoryid")),0);
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_MAIN%>);
parentNode.expand(true);
<%
                }
                id = rs.getInt("subcategoryid");
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_SUB%>);
parentNode.expand(true);
<%
            }
        }
    }
%>
</script>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
 </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY></HTML>
