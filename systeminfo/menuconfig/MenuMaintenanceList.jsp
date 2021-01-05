
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.Document"%>
<%@ page import="org.jdom.Element"%>
<%@ page import="org.jdom.output.Format"%>
<%@ page import="org.jdom.output.XMLOutputter"%>
<%@ page import="org.jdom.transform.XSLTransformer"%>
<%@ page import="org.jdom.xpath.XPath"%>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>

<%
	String type = Util.null2String(request.getParameter("type"));// top left 
	String mode = Util.null2String(request.getParameter("mode"));  //visible hidden 默认为hidden
	int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
    String resourceType = Util.null2String((String)request.getParameter("resourceType"));
	String isCustom = Util.null2String(request.getParameter("isCustom"));


	String saved = Util.null2String(request.getParameter("saved"));
    int companyid = Util.getIntValue(request.getParameter("companyid"),0);
    int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
	int sync = Util.getIntValue(request.getParameter("sync"),0);

	
    
   
    
    int userId = 0;
    userId = user.getUID();
    
    //判断总部菜单维护权限
    if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
    	if(companyid>0||"1".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	if(companyid==0&&subCompanyId==0&&resourceId==0&&"".equals(resourceType)) companyid = 1;
    }
    
    //判断分部菜单维护权限
    if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
    	if(subCompanyId>0||"2".equals(resourceType)){
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
    } else {
    	CheckSubCompanyRight newCheck = new CheckSubCompanyRight();
    	int[] subcomids = newCheck.getSubComByUserRightId(userId,"SubMenu:Maint");
    	if(subCompanyId==0&&companyid==0&&resourceId==0&&"".equals(resourceType)){
        	if(subcomids!=null&&subcomids.length>0) subCompanyId = subcomids[0];
        	else {
        		response.sendRedirect("/notice/noright.jsp");
                return;
        	}
    	}
    	//for TD.4374
    	if(subCompanyId>0&&companyid==0){
	    	boolean tmpFlag = false;
	    	for(int i=0;i<subcomids.length;i++){
	    		if(subCompanyId == subcomids[i]){
	    			tmpFlag = true;
	    			break;
	    		}
	    	}
	    	if(!tmpFlag) {
	    		response.sendRedirect("/notice/noright.jsp");
	            return;
	    	}
    	}
    }

    if(companyid>0||subCompanyId>0){
    	resourceId = (companyid>0?companyid:subCompanyId);
    	resourceType = (companyid>0?"1":"2");
    }


    String oldCheckedString = "";
    String oldIdString = "";

    String imagefilename = "/images/hdMaintenance_wev8.gif";

	

	String titlename="";
	if("left".equals(type))		titlename=SystemEnv.getHtmlLabelName(17596,user.getLanguage());
	else if("top".equals(type))		titlename=SystemEnv.getHtmlLabelName(20611,user.getLanguage());


	String menuTitle="";
    if(resourceType.equals("1")) {
		menuTitle= (Util.toScreen(CompanyComInfo.getCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("2")){
		menuTitle = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(""+resourceId), user.getLanguage()));
	} else if(resourceType.equals("3")) {
		menuTitle = user.getLastname();
	}

	menuTitle=menuTitle+titlename;

    
    String needfav = "1";
    String needhelp = "";

    boolean isShowSyncInfo = false;
    
    if(resourceType.equals("2")) isShowSyncInfo = true;


	String ownerid="";
		 if("1".equals(resourceType)){/*总部 z* 分部 s*  个人 r*  */
			ownerid="z" + resourceId;
		} else if("2".equals(resourceType)){
			ownerid="s" + resourceId;
		}else if("3".equals(resourceType)){
			ownerid="r" + resourceId;
		}	

	
    
%>



<HTML>
 <HEAD>
   <TITLE> New Document </TITLE>
	<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
	<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  	<script type="text/javascript" src="/js/menu/xtree_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
    <script type="text/javascript" src="/js/menu/xmlextras_wev8.js"></script>
    <script type="text/javascript" src="/js/menu/xloadtree_wev8.js"></script>   
	
	<link rel="stylesheet" href="/js/modalbox/dhtmlwindow_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/js/modalbox/modal_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/modalbox/dhtmlwindow_wev8.js"></script>
	<script type="text/javascript" src="/js/modalbox/modal_wev8.js"></script>



	<style  id="thisStyle">
		.clsTxt{
			display:none;
		}
		span{
			display: inline-block;
		}
		.spanTitle{
			font-size: 13px;
			font-weight: bold;
			height: 29px;
			line-height: 161%;
			position: absolute;
			top: 5px;
		}
		#closeBtn{
			position: absolute;
			top: 8px;
			right: 5px;
		}
	</style>


 </HEAD>
 <BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;	
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		

		RCMenu += "{<span id=spanOrder>"+SystemEnv.getHtmlLabelName(15513,user.getLanguage())+"</span>,javascript:order(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		

		RCMenu += "{<span id=spanExOrCo stat='co'>"+SystemEnv.getHtmlLabelName(20606,user.getLanguage())+"</span>,javascript:ExOrCo(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
		if("visible".equals(mode)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(20766,user.getLanguage())+",javascript:hiddenNoVisbleMenu(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		} else {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(20767,user.getLanguage())+",javascript:showNoVisbleMenu(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;			
		}
		//RCMenu += "{"+SystemEnv.getHtmlLabelName(20608,user.getLanguage())+",javascript:synchAll(this),_self} " ;
		//RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<form name="frmAdd" method="post" action="MenuMaintenanceOperation.jsp">
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
		
		<TABLE class="Shadow">
			<tr>
				<td valign="top">



		<input type="hidden" name="method" value="maintenance">
		<input type="hidden" name="sync" value="<%=sync%>">
		<input type="hidden" name="type" value="<%=type%>">
		<input type="hidden" name="resourceId" value="<%=resourceId%>">
		<input type="hidden" name="resourceType" value="<%=resourceType%>">
		<input type="hidden" name="isCustom" value="<%=isCustom%>">
		
		<%			
			MenuUtil mu=new MenuUtil(type,Util.getIntValue(resourceType),resourceId,user.getLanguage());
			String xmlStr="";
			try {
				xmlStr=mu.getMenuXmlStr(1,mode);
				//out.println(xmlStr);
			} catch (Exception e) {			
				out.println(e);
			}
		%>	
 


	<script type="text/javascript">	
	
	
		//var xmlDoc = new ActiveXObject("Microsoft.XMLDOM") ; 
				
		//xmlDoc.async  = false; 
		//xmlDoc.validateOnParse = false; 
	//	xmlDoc.resolveExternals = false; 
	//	xmlDoc.preserveWhiteSpace = true; 
	//	xmlDoc.setProperty("SelectionLanguage", "XPath");

		
	//	xmlDoc.loadXML("<%=xmlStr%>");
	
	var parser;
	if (window.DOMParser)
	  {
	  parser=new DOMParser();
	  xmlDoc=parser.parseFromString("<%=xmlStr%>","text/xml");
	 
	  }
	else // Internet Explorer
	  {
	  xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
	  xmlDoc.async="false";
	  xmlDoc.loadXML("<%=xmlStr%>");
	  } 
		
		xmlDoc.validateOnParse = false; 
		xmlDoc.resolveExternals = false; 
		xmlDoc.preserveWhiteSpace = true; 
		//xmlDoc.setProperty("SelectionLanguage", "XPath");
		var treeName="<%=menuTitle%>";

		webFXTreeConfig.curUserid="<%=ownerid%>";
		webFXTreeConfig.isCustom="<%=isCustom%>";
		webFXTreeConfig.isCustomWidth="<%=isCustom%>";
		webFXTreeConfig.menutype="<%=type%>";
		webFXTreeConfig.resourceType="<%=resourceType%>";
		webFXTreeConfig.resourceId="<%=resourceId%>";
		webFXTreeConfig.isIE = "<%=isIE%>";
		webFXTreeConfig.language="<%=user.getLanguage()%>";
		var tree = new WebFXLoadTree(treeName, "", "", "", "/images/xp/folder_wev8.png", "/images/xp/openfolder_wev8.png",xmlDoc);
		document.write(tree);
		//tree.collapseChildren();
	</script>


	</td>
			</tr>
		</TABLE>
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	</table>


	</form>

 </BODY>
</HTML>

<script type="text/javascript">

		//var agreewin=dhtmlmodal.open("agreebox", "iframe", "/systeminfo/menuconfig/MenuMaintenanceAdd.jsp?id=12&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>", "Edit Menu", "width=450px,height=300px,center=1,resize=1,scrolling=0", "recal")

		//agreewin.onclose=function(){ //Define custom code to run when window is closed
		//	alert("ok")
			//var theform=this.contentDoc.getElementById("eula") //Access form with id="eula" inside iframe
			//var radText=theform.eulabox[0] //Access the first radio button within form
			//var nobox=theform.eulabox[1] //Access the second radio button within form
			//alert(radText);
			
			//return true //Allow closing of window in both cases
		//}

</script>

<script type="text/javascript">
	var addwin,editwin;
	function onEdit(menuId,treeMenuId,menuText){		
		var url="/systeminfo/menuconfig/MenuMaintenanceEdit.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&edit=sub&sync=1";
		
		if(menuId>0) url="/systeminfo/menuconfig/CustomMenuName.jsp?type=<%=type%>&id="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1";





		editwin=dhtmlmodal.open("agreebox", "iframe", url, "<%=SystemEnv.getHtmlLabelName(20603,user.getLanguage())%>:"+menuText, "width=500px,height=310px,center=1,resize=1,scrolling=0", "recal")  

		editwin.onclose=function(){ 			
			var sText=this.contentDoc.getElementById("sText").value;	
			var iconUrl=this.contentDoc.getElementById("iconUrl").value;	
			document.getElementById("txt_"+treeMenuId).innerHTML=sText;
			if(iconUrl!="" && iconUrl!=null)	document.getElementById(treeMenuId+"-icon").src=iconUrl;
			
			//var parentNode=webFXTreeHandler.all[treeMenuId];
			
			//var newNode=new WebFXTreeItem(sText,"",parentNode,sIcon,sIcon,curMenuid,parentMenuId,linkAddress,"1","1");
			//parentNode.expand();	


			return true;
		}
	}



	function onAdd(parentMenuId,treeMenuId,parentMenuText){			

		addwin=dhtmlmodal.open("agreebox", "iframe", "/systeminfo/menuconfig/MenuMaintenanceAdd.jsp?type=<%=type%>&id="+parentMenuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&sync=1", "<%=SystemEnv.getHtmlLabelName(20604,user.getLanguage())%>:"+parentMenuText, "width=500px,height=310px,center=1,resize=1,scrolling=0", "recal")

		addwin.onclose=function(){ 			
			var sText=this.contentDoc.getElementById("sText").value;
			var sIcon=this.contentDoc.getElementById("sIcon").value;
			var curMenuid=this.contentDoc.getElementById("curMenuid").value;
			var linkAddress=this.contentDoc.getElementById("linkAddress").value;	
			var customMenuViewIndex=this.contentDoc.getElementById("customMenuViewIndex").value;
			
			var parentNode=webFXTreeHandler.all[treeMenuId];
			webFXTreeConfig.isCustom="false";
			var newNode=new WebFXTreeItem(sText,"",parentNode,sIcon,sIcon,curMenuid,parentMenuId,linkAddress,"1","1",customMenuViewIndex,"",-1);
			parentNode.expand();	

			return true;
		}
			
	}


	function onDel(menuId,treeMenuId,isShowAllSubDel){
		if(isdel()){
			var thisNode=webFXTreeHandler.all[treeMenuId];
			if(thisNode.childNodes.length>0){
				alert("<%=SystemEnv.getHtmlLabelName(20609,user.getLanguage())%>");
			} else {
				if(isShowAllSubDel){
					if(confirm("<%=SystemEnv.getHtmlLabelName(20830,user.getLanguage())%>")){
						GetContent("/systeminfo/menuconfig/MenuMaintenanceOperation.jsp?type=<%=type%>&infoId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&method=delthisall");
						thisNode.remove();
					}
				} else {
					GetContent("/systeminfo/menuconfig/MenuMaintenanceOperation.jsp?type=<%=type%>&infoId="+menuId+"&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&method=del");
					thisNode.remove();
				}
			}
		}
	}

	function onChkClick(chkobj,menuid){		
		var divObj=chkobj.parentNode.parentNode.parentNode;
		//alert(divObj.tagName)
		if(chkobj.checked){	//选中
		//alert(menuid)
			divObj.style.filter="";
			//上级所有的菜单也会被自动选中
			/*try{
			/	
					var srcNode = this.xmlDoc.selectSingleNode("//tree[@id='"+menuid+"']");		
					var menuparentid=srcNode.parentNode.getAttribute("id");

					if(menuparentid==0) {
						return;								
					} else {
						var objParent=document.getElementById("chkVisible_"+menuparentid);
						objParent.checked=true;
						//alert("menuparentid:"+menuparentid)
						this.onChkClick(objParent,menuparentid);
					}

			} catch(e){}*/

		} else {

			divObj.style.filter="gray()";
		}

	}
	function isdel(){
		var str = "<%=SystemEnv.getHtmlLabelName(23271,user.getLanguage())%>?";
	   if(!confirm(str)){
		   return false;
	   }
       return true;
   }


   function  GetContent(url,code){	
	   //document.write(url)
		var xmlHttp = XmlHttp.create();
		xmlHttp.open("GET",url, true);
		xmlHttp.onreadystatechange = function () {
			switch (xmlHttp.readyState) {
			 
			   case 4 :
					var msgStr=xmlHttp.responseText;
					if(xmlHttp.status==200)   {
						if(code!=null&&code!="") eval(code);
					}else {
						alert(msgStr)
					}
				   break;
			}
		}
		xmlHttp.setRequestHeader("Content-Type","text/xml")
		xmlHttp.send(null);
  }
	



 function onSave(obj){
	 obj.disabled=true;
	 frmAdd.submit();
 }



  function order(obj){
		var style=document.styleSheets["thisStyle"].rules[0].style.display;
		if(style=="none"){
			document.styleSheets["thisStyle"].rules[0].style.display='';
			obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(20605,user.getLanguage())%>";
		}else {
			document.styleSheets["thisStyle"].rules[0].style.display='none';
			obj.lastChild.innerHTML="<%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>";
		}
  }


   function  ExOrCo(obj){
	   var objSpan=obj.lastChild;
	   if(objSpan.stat=="co") {
			objSpan.stat="ex";
			tree.expandAll(this);
			objSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(20607,user.getLanguage())%>";
	   } else {
			objSpan.stat="co";
			tree.collapseChildren();
			objSpan.innerHTML="<%=SystemEnv.getHtmlLabelName(20606,user.getLanguage())%>";
	   }

   }

 function hiddenNoVisbleMenu(obj){
	 obj.disabled=true;
	 window.location="MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&isCustom=<%=isCustom%>&mode=hidden"
 }

 function showNoVisbleMenu(obj){
	 obj.disabled=true;
	 window.location="MenuMaintenanceList.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&isCustom=<%=isCustom%>&mode=visible"
 }




 function synchAll(obj){
	 if(confirm("<%=SystemEnv.getHtmlLabelName(20764,user.getLanguage())%>")) {
		 obj.disabled=true;
		 window.location="MenuMaintenanceOperation.jsp?type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>&isCustom=<%=isCustom%>&mode=synchall"	
	 }
 }
 
  //var width = screen.width ;
 // alert(parent.contentframe.width)
  //alert(parent.contentframe.offsetWidth)

</script>




