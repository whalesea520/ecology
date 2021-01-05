<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.appdetach.AppDetachComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link href="/css/deepTree_wev8.css" rel="stylesheet" type="text/css">
<!-- added by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css" />
<LINK href="/js/ecology8/customSelect/customSelect_wev8.css" type=text/css rel=STYLESHEET></LINK>
<script src="/js/ecology8/customSelect/customSelect_wev8.js" type="text/javascript"></script>
<!-- end by cyril on 2008-07-31 for td:9109 -->
<script type="text/javascript"> 
  var dialog = null;
  try{
 		dialog = parent.parent.parent.getDialog(parent.parent);
  }catch(e){ }
  
  function changeShowType(obj,showtype){
		var title = jQuery(obj).find(".e8text").html();
		var title1 = jQuery(obj).find(".e8text").attr("title");
		jQuery("#optionSpan").html(title);
		jQuery("#virtualtype").val(showtype);
		jQuery("#leftTree").css("background-color",jQuery(".leftTypeSearch").css("background-color"));
		jQuery("span[id^='showspan']").each(function(){
			jQuery(this).addClass("e8imgSel");
		});
		jQuery("#showspan"+showtype).removeClass("e8imgSel");
		showE8TypeOption();
		initTree();
	}

	function showE8TypeOption(closed){
		if(closed){
			jQuery("#e8TypeOption").hide();
		}else{
			jQuery("#e8TypeOption").toggle();
		}
		if(jQuery("#e8TypeOption").css("display")=="none"){
			jQuery("span.leftType").removeClass("leftTypeSel");
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_wev8.png");
		}else{
			jQuery("span.leftType").addClass("leftTypeSel");
			jQuery("#e8TypeOption").width(jQuery("span.leftType").width()+10);
			var src = jQuery("#currentImg").attr("src");
			if(src){
				jQuery("#currentImg").attr("src",src);
			}
			jQuery("#e8typeImg").attr("src","/images/ecology8/doc/down_sel_wev8.png");
		}
		return;
	}
 </script>
</HEAD>

<%
String show_virtual_org = Util.null2String(request.getParameter("show_virtual_org"));
boolean showvirtual = false;
CompanyVirtualComInfo.setUser(user);
if(!show_virtual_org.equals("-1")&&CompanyVirtualComInfo.getCompanyNum()>0){
	showvirtual = true;
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(124, user.getLanguage());
String needfav = "1";
String needhelp = "";
int uid=user.getUID();
int tabid=0;
String showId = new AppDetachComInfo().getScopeIds(user, "department");//Util.null2String(request.getParameter("showId"));
String nodeid=null;
String rem=null;
        Cookie[] cks= request.getCookies();

        for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
        if(cks[i].getName().equals("departmentmultiOrder"+uid)){
        rem=cks[i].getValue();
        break;
        }
        }
        rem=null;//取消Cookie 不稳定老是出现问题      
if(rem!=null){
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
if(!exist)
nodeid=null;
%>

<BODY onload="initTree()" oncontextmenu="return false;">
	<FORM NAME=SearchForm STYLE="margin-bottom:0" action="MultiSelect.jsp" method=post target="frame2">
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/leftMenuCommon.jsp"%>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	loadTopMenu = 0; //1-加载头部操作按钮，0-不加载头部操作按钮，主要用于多部门查询框。
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:document.SearchForm.btnok.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了onclick() 事件 -->
	<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick();"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>



	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	%>
	<!-- 2012-08-15 ypc 修改 添加了onclick() 事件 -->
	<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>

			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>
<%if(showvirtual){ %>
	<table cellspacing="0" cellpadding="0" style="width:100%;">
		<tr>
			<td class="leftTypeSearch">
				<div class="topMenuTitle" style="border-bottom:none;height: 30px">
					<span class="leftType" style="width: 564px;height: 0px">
						<span style="border: 0px"><img id="currentImg" style="height: 16px;width: 16px;vertical-align: top;" src="/images/ecology8/doc/org_wev8.png" /></span>
						<span style="border: 0px">
							<div  id="e8typeDiv" style="width:auto;height:auto;position:relative;line-height: 0px">
								<span id="optionSpan" style="width: 515px;line-height: 15px;border: 0px;" onclick="showE8TypeOption();" ><%=CompanyComInfo.getCompanyname("1")%></span>
								<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
								<span style="width:16px;height:16px;cursor:pointer;border: 0px;" onclick="showE8TypeOption();">
									<img id="e8typeImg" src="/images/ecology8/doc/down_wev8.png"/>
								</span>
								<%} %>
							</div>
						</span>
				</div>
			</td>
		</tr>
	</table>
<%} %>
<table width=100% class="ViewForm" valign="top">

	<!--######## Search Table Start########-->
	<TR>
	<td height=100% width="100%">
	<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml"/>
	<td>
	</tr>
	</table>
	<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
	<ul id="e8TypeOption" class="e8TypeOption" style="height: 150px">
	<%
	if(CompanyComInfo.getCompanyNum()>0){
		CompanyComInfo.setTofirstRow();
		while(CompanyComInfo.next()){
	%>
		<li onclick="changeShowType(this,<%=CompanyComInfo.getCompanyid() %>);">
			<span id="showspan<%=CompanyComInfo.getCompanyid() %>" class="e8img" style="border: 0px"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img" style="border: 0px"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text" style="border: 0px"><%=CompanyComInfo.getCompanyname()%></span>
		</li>
	<%}}
	if(CompanyVirtualComInfo.getCompanyNum()>0){
		CompanyVirtualComInfo.setTofirstRow();
		while(CompanyVirtualComInfo.next()){
		%>
		<li onclick="changeShowType(this,<%=CompanyVirtualComInfo.getCompanyid() %>);">
			<span id="showspan<%=CompanyVirtualComInfo.getCompanyid() %>" class="e8img e8imgSel" style="border: 0px"><img src="/images/ecology8/doc/current_wev8.png"/></span>
			<span class="e8img" style="border: 0px"><img src="/images/ecology8/doc/org_sel_wev8.png"/></span>
			<span class="e8text" style="border: 0px" title="<%=CompanyVirtualComInfo.getVirtualType() %>"><%=CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()%></span>
		</li>
		<%} %>
	</ul>
<%} %>
<%} %>
<input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
  <input class=inputstyle type="hidden" name="resourceids" >
  <input class=inputstyle type="hidden" name="showsubdept" >      
  <input class=inputstyle type="hidden" name="tabid" >
  <input class=inputstyle type="hidden" name="nodeid" >
  <input class=inputstyle type="hidden" name="companyid" >
  <input class=inputstyle type="hidden" name="subcompanyid" >
  <input class=inputstyle type="hidden" name="departmentid" >
  <input type="hidden" name="showId" id="showId" value='<%=showId%>'>
  <input class=inputstyle type=hidden id=virtualtype name=virtualtype value="">
	<!--########//Search Table End########-->
	<!-- 把body之外的js函数移到body体内 和radio不能选中同样道理需要初始化的函数写在body内 Google才识别 -->
	
	<script type="text/javascript">
		//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js start
		var resourceids =""
		var resourcenames = ""
		function btnok_onclick(){
			window.parent.frame2.btnok.click();
return;
			setResourceStr();
		  replaceStr();
		  if(dialog){
	  		var returnjson =  {id:resourceids,name:resourcenames};
	   		try{
          dialog.callback(returnjson);
     		}catch(e){}

				try{
				     dialog.close(returnjson);
				 }catch(e){}
		  }else{
		    window.parent.parent.returnValue =  {id:resourceids,name:resourcenames};
		    window.parent.parent.close();
			}
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
		//2012-08-15 ypc 添加 原因是：本页面的 确定右键菜单的 事件处理是用vbs编写的 在Google和火狐是不能解析的 所以改为js end
		function replaceStr(){
		    var re=new RegExp("[ ]*[|]*[|]","g")
		    resourcenames=resourcenames.replace(re,"|")
		    re=new RegExp("[|][^,]*","g")
		    resourcenames=resourcenames.replace(re,"")
		}
		function setSubcompany(nodeid){
		    setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|"+nodeid);
		    subid=nodeid.substring(nodeid.lastIndexOf("_")+1)
		    document.all("companyid").value=""
		    document.all("departmentid").value=""
		    document.all("subcompanyid").value=subid
		    document.all("tabid").value=0
		    document.all("nodeid").value=nodeid
		    doSearch()
		}
		function setCookie(name,val){
			var Then = new Date();
			Then.setTime(Then.getTime() + 30*24*3600*1000 );
			document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
		}
	
		function doSearch()
		{
			setResourceStr();
			$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
				if(jQuery(parent.document).find("#frame2").contents().find("#showsubdept").attr("checked")){
		        document.all("showsubdept").value ="1" ;
		    }else{
		        document.all("showsubdept").value ="0" ;
		    }
		    document.SearchForm.submit();
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
		
		function btnsub_onclick(){
	//window.parent.parent.frame1.SearchForm.btnsub.click();
		var curDoc;
		if(document.all){
			curDoc=window.parent.frames["frame1"].document
		}
		else{
			curDoc=window.parent.document.getElementById("frame1").contentDocument	
		}
		$(curDoc).find("#btnsub")[0].click();
}
	</script>
</FORM>


<script language="javascript">
function initTree(){
//deeptree.init("/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
//added by cyril on 2008-07-31 for td:9109
	/*
webFXTreeConfig.rootIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openRootIcon	= "/images/xp/openfolder_wev8.png";
webFXTreeConfig.folderIcon		= "/images/xp/folder_wev8.png";
webFXTreeConfig.openFolderIcon	= "/images/xp/openfolder_wev8.png";
//webFXTreeConfig.fileIcon		= "/images/xp/file_wev8.png";
webFXTreeConfig.fileIcon		= "/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif";
webFXTreeConfig.lMinusIcon		= "/images/xp/Lminus_wev8.png";
webFXTreeConfig.lPlusIcon		= "/images/xp/Lplus_wev8.png";
webFXTreeConfig.tMinusIcon		= "/images/xp/Tminus_wev8.png";
webFXTreeConfig.tPlusIcon		= "/images/xp/Tplus_wev8.png";
webFXTreeConfig.iIcon			= "/images/xp/I_wev8.png";
webFXTreeConfig.lIcon			= "/images/xp/L_wev8.png";
webFXTreeConfig.tIcon			= "/images/xp/T_wev8.png";
*/
//设置选中的ID
cxtree_id = '<%=Util.null2String(nodeid)%>';
var virtualtype = jQuery("#virtualtype").val();
if(virtualtype<0){
	CXLoadTreeItem("", "/hrm/companyvirtual/ResourceMultiXML.jsp?virtualtype="+virtualtype+"<%if(nodeid!=null){%>&init=true&nodeid=<%=nodeid%><%}%>");
}else{
	CXLoadTreeItem("", "/hrm/tree/ResourceMultiXML.jsp<%if(nodeid!=null){%>?init=true&nodeid=<%=nodeid%><%}%>");
}
var tree = new WebFXTree();
tree.add(cxtree_obj);
//document.write(tree);
document.getElementById('deeptree').innerHTML = tree;
cxtree_obj.expand();
//end by cyril on 2008-07-31 for td:9109
}
//to use xtree,you must implement top() and showcom(node) functions
	
function top1(){
<%if(nodeid!=null){%>
try{
deeptree.scrollTop=<%=nodeid%>.offsetTop;
deeptree.HighlightNode(<%=nodeid%>.parentElement);
deeptree.ExpandNode(<%=nodeid%>.parentElement);
    setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|<%=nodeid%>");
 }catch(e){

    }
<%}%>
}

function showcom(node){
}

function check(node){
}
		function setCompany(id){
		    document.all("departmentid").value=""
		    document.all("subcompanyid").value=""
		    document.all("companyid").value=id
		    document.all("tabid").value=0
		    doSearch()
		}

		function setDepartment(nodeid){
			setCookie("departmentmultiOrder<%=uid%>","<%=tabid%>|"+nodeid);
		    deptid=nodeid.substring(nodeid.lastIndexOf("_")+1)
		    document.all("subcompanyid").value=""
		    document.all("companyid").value=""
		    document.all("departmentid").value=deptid
		    document.all("tabid").value=0
		    document.all("nodeid").value=nodeid
		    doSearch()
		} 
		
	jQuery(document).ready(function(){
		jQuery(".leftTypeSearch").show();
		jQuery(".leftTypeSearch").height(30);
		jQuery(".leftTypeSearch").height(30);
		jQuery("#e8TypeOption").perfectScrollbar();
	}) 
</script>
</BODY>
</HTML>