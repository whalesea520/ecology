<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.docs.category.security.*" %>
<%@ page import="weaver.docs.category.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="MainCategoryManager" class="weaver.docs.category.MainCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryManager" class="weaver.docs.category.SubCategoryManager" scope="page" />
<jsp:useBean id="SecCategoryManager" class="weaver.docs.category.SecCategoryManager" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<%
    int categoryid = Util.getIntValue(request.getParameter("categoryid"), -1);
    int categorytype = Util.getIntValue(request.getParameter("categorytype"), -1);
    
    boolean CanCopy = HrmUserVarify.checkUserRight("DocCopyMove:Copy", user);
    boolean CanMove = HrmUserVarify.checkUserRight("DocCopyMove:Move", user);
    String otype=Util.null2String(request.getParameter("otype"));//1 copy , 2 move
    ArrayList al1=new ArrayList();//maincategory
    ArrayList al2=new ArrayList();//subcategory
    ArrayList al3=new ArrayList();//seccategory
    AclManager am = new AclManager();
    rs1.executeSql("select t1.id,t1.subcategoryid,maincategoryid from DocSecCategory t1,docsubcategory t2 where t2.id=t1.subcategoryid order by t1.id");
    while(rs1.next()){
    if(otype.equals("1")&&!CanCopy&&!CanMove){
       if((am.hasPermission(rs1.getInt("id"), AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_COPYDOC))){
       al1.add(""+rs1.getInt("maincategoryid"));
       al2.add(""+rs1.getInt("subcategoryid"));
       al3.add(""+rs1.getInt("id"));
       }
    }else if(otype.equals("2")&&!CanCopy&&!CanMove){
       if((am.hasPermission(rs1.getInt("id"), AclManager.CATEGORYTYPE_SEC, user, AclManager.OPERATION_MOVEDOC))){
       al1.add(""+rs1.getInt("maincategoryid"));
       al2.add(""+rs1.getInt("subcategoryid"));
       al3.add(""+rs1.getInt("id"));
       }
    }else if(CanCopy||CanMove||otype.equals("")){
       al1.add(""+rs1.getInt("maincategoryid"));
       al2.add(""+rs1.getInt("subcategoryid"));
       al3.add(""+rs1.getInt("id"));      
       } 
    }
   //removeDuplicate
   HashSet h1 = new HashSet(al1); 
   al1.clear(); 
   al1.addAll(h1);
   HashSet h2 = new HashSet(al2); 
   al2.clear(); 
   al2.addAll(h2);
   HashSet h3 = new HashSet(al3); 
   al3.clear(); 
   al3.addAll(h3);
   request.getSession().setAttribute("al2",al2);
   request.getSession().setAttribute("al3",al3);  
    
%>
<HTML>
<HEAD>
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
function showPrompt(content,show){
    var message_table_Div  = document.getElementById("message_table_Div");
    if(show){
        message_table_Div.style.display="block";
        message_table_Div.innerHTML=content;
    } else {
        message_table_Div.style.display="none";
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
<div id="message_table_Div" style='padding:3px;display:' align="center"></div>
<script>
     showPrompt("<%=SystemEnv.getHtmlLabelName(19205, user.getLanguage())%>",true);
</script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<iframe height=0 src="about:blank" width=0></iframe>
<form name="SearchForm">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=1 id=btnok onclick="onClose()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON type='button' class=btn accessKey=2 onclick="onClear()" id=btnclear><U></U><%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</form>
</DIV>
<!--
<table class=ViewForm>
    <colgroup>
        <col width=100%>
    <tr class=Spacing>
        <TD class=Line1 colspan=1></TD>
    </tr>
</table>
-->

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
var varScript = "node = tree.getNode(tree.getSelect().id);if( node && node.loaded!=true ){var str=new String(window.location);str=str.substring(0,str.lastIndexOf('/')+1);window.frames[0].location= str +'OpenCategory.jsp?categoryid='+node.categoryid+'&categorytype='+node.categorytype+'&node='+tree.getSelect().id;}";
<%
    MainCategoryManager.resetParameter();
    MainCategoryManager.selectCategoryInfo();
    while(MainCategoryManager.next()){
      	int id = MainCategoryManager.getCategoryid();
      	String name = MainCategoryManager.getCategoryname();
      	float order = MainCategoryManager.getCategoryorder();
       	name = 	Util.replace(
      			name
              	,"\"","&quot;",0);
              	for(int a1=0;a1<al1.size();a1++){
              	if(id==Integer.parseInt(al1.get(a1).toString()))
              	{
%>
node = tree.add(0,Tree_ROOT,Tree_LAST,"<%=name%>","","","","",<%=id%>,<%=AclManager.CATEGORYTYPE_MAIN%>);
node.setScript(varScript); 
node.addChild(0,"loading...");//临时结点，载入时删除
var parentNode;
<% }
  }
    }
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
                    id = Integer.parseInt(SubCategoryComInfo.getMainCategoryid(rs.getString("subcategoryid")));
                    SubCategoryManager.setMainCategoryid(id);
                    SubCategoryManager.selectCategoryInfo();
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_MAIN%>);
parentNode.delChild(0);
parentNode.loaded = true;
<%
                    while (SubCategoryManager.next()) {
                        int subid = SubCategoryManager.getCategoryid();
  	                    String name = SubCategoryManager.getCategoryname();
  	                    int fathersubid = SubCategoryManager.getSubCategoryid();
  	                    if (fathersubid < 0) {
			        	name = 	Util.replace(
			       				name
			               		,"\"","&quot;",0);
%>
node=parentNode.addChild(Tree_LAST, "<%=name%>","","","","",<%=subid%>,<%=AclManager.CATEGORYTYPE_SUB%>);
node.setScript(varScript);
node.addChild(0,'loading...');

<%
                        }
                    }
%>
parentNode.expand(true);
<%
                }
                id = rs.getInt("subcategoryid");
                SubCategoryManager.selectCategoryInfo(id);
%>
parentNode = findThisNode(<%=id%>, <%=AclManager.CATEGORYTYPE_SUB%>);
parentNode.delChild(0);
parentNode.loaded = true;
<%
                while(SubCategoryManager.next()){
  	                int subid = SubCategoryManager.getCategoryid();
  	                String name = SubCategoryManager.getCategoryname();
		        	name = 	Util.replace(
		       				name
		               		,"\"","&quot;",0);
%>
node=parentNode.addChild(Tree_LAST, "<%=name%>","","","","",<%=subid%>,<%=AclManager.CATEGORYTYPE_SUB%>);
node.setScript(varScript);
node.addChild(0,'loading...');
<%
                }
                SecCategoryManager.setSubcategoryid(id);
                SecCategoryManager.selectCategoryInfo();
                while(SecCategoryManager.next()){
                    int secid = SecCategoryManager.getId();
                    String name = SecCategoryManager.getCategoryname();
		        	name = 	Util.replace(
		       				name
		               		,"\"","&quot;",0);
%>
node=parentNode.addChild(Tree_LAST, "<%=name%>","","",tree.fileImg,tree.fileImg,<%=secid%>,<%=AclManager.CATEGORYTYPE_SEC%>);
node.setScript('selectCategory(tree.getSelect().id)');
<%
                }
%>
parentNode.expand(true);
<%
            }
        }
    }
%>
showPrompt("",false);
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
</BODY>
</HTML>
<script>
function onClear() {
	if(dialog){
		try{
		dialog.callback({id:"",name:"",path:"",path2:""});
		}catch(e){}
		try{
		dialog.close({id:"",name:"",path:"",path2:""});
		}catch(e){}
	}else{
    	window.parent.returnValue={id:"",name:"",path:"",path2:""}
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
    var  parth2="<a href='/docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&seccategory="+id+"'>"+node.text+"</a>";  
    while (node.parent != null) {        
        path = node.parent.text + "/" + path;        
        if (node.parent.categorytype == 1 && subid == -1) {
            subid = node.parent.categoryid;
            parth2="<a href='/docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&subcategory="+subid+"'>"+node.parent.text+"</a>/"+parth2;               
        }  else  if (node.parent.categorytype == 0) {
            mainid = node.parent.categoryid;    
            parth2="<a href='docs/search/DocSummaryList.jsp?showtype=0&displayUsage=0&maincategory="+mainid+"'>"+node.parent.text+"</a>/"+parth2;      
	    }  
        node = node.parent;
    }  
    path = path.replace(/</g, "＜").replace(/>/g, "＞").replace(/&lt;/g, "＜").replace(/&gt;/g, "＞");
	if(dialog){
		try{
		dialog.callback({tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2});
		}catch(e){}
		try{
		dialog.close({tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2});
		}catch(e){}
	}else{
	    window.parent.returnValue = {tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2};
	    window.parent.close();
	}
}
</script>