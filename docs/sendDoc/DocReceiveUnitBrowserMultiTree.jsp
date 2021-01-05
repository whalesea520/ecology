
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 


<%@ page import="weaver.hrm.company.SubCompanyComInfo"%>

<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML>
<HEAD>
<%String fromBrowser = Util.null2String(request.getParameter("fromBrowser")); %>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript" src="/js/xtree_wev8.js"></script>
<script type="text/javascript" src="/js/xmlextras_wev8.js"></script>
<script type="text/javascript" src="/js/cxloadtree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/css/xtree2_wev8.css" />
<script type="text/javascript">
	try{
		<%if(fromBrowser.equals("1")){%>
			parent.parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19309",user.getLanguage())%>");
		<%}else{%>
			parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19309",user.getLanguage())%>");
		<%}%>
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>

<%

String receiveUnitIds=Util.null2String(request.getParameter("receiveUnitIds"));
String[] receiveUnitIdArray=Util.TokenizerString2(receiveUnitIds,",");

int uid=user.getUID();

String nodeid = null;
String rem=null;
Cookie[] cks= request.getCookies();
        
for(int i=0;i<cks.length;i++){
        //System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
	if(cks[i].getName().equals("receiveUnitIdsmulti"+uid)){
		rem=cks[i].getValue();
		break;
	}
}
if(rem!=null){
	Cookie ck = new Cookie("receiveUnitIdsmulti"+uid,rem);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);

    nodeid = rem;
}else{
	if(nodeid==null || "".equals(nodeid)){
		int optSubcompanyid = Util.getIntValue(ResourceComInfo.getSubCompanyID(""+user.getUID()), 0);
		if(optSubcompanyid > 0){
			nodeid = "com_"+optSubcompanyid;
		}
	}
	rem = nodeid;
	Cookie ck = new Cookie("receiveUnitIdsmulti"+uid,rem);  
	ck.setMaxAge(30*24*60*60);
	response.addCookie(ck);
}
%>


<BODY>
<div class="zDialog_div_content" style="<%=fromBrowser.equals("1")?"height:100%;overflow:hidden;":"" %>">
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
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    <script>
     rightMenu.style.visibility='hidden'
    </script>

<FORM NAME="SearchForm" STYLE="margin-bottom:0" action="MultiSelect.jsp" method="post" target="frame2">
	<wea:layout attributes="{'formTableId':'BrowseTable'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="deeptree" class="cxtree" CfgXMLSrc="/css/TreeConfig.xml" />
			</wea:item>
		</wea:group>
	</wea:layout>
	<input type="hidden" id="receiveUnitId" name="receiveUnitId" >
	<input type="hidden" id="subcompanyid" name="subcompanyid" >
	<input type="hidden" id="receiveUnitIds" name="receiveUnitIds" >
	<input type="hidden" id="nodeid" name="nodeid" >
	<input class=inputstyle type="hidden" name="showsubdept" id="showsubdept">
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:<%=fromBrowser.equals("1")?"none":"" %>">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=O  id=btnok  value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="onSave();">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<%if(!fromBrowser.equals("1")){%>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	<%}%>
</div>
<!-- 把body之外的js函数移到body体内 需要初始化的函数写在body内 Google才识别 end 2012-08-07 ypc 修改 start-->
<script type="text/javascript">
		var selectallflag=false;
		//to use deeptree,you must implement following methods 
		function initTree(){
			//deeptree.init("/docs/sendDoc/DocReceiveUnitBrowserMultiXML.jsp?<%if(nodeid!=null){%>nodeid=<%=nodeid%><%}%>");
			cxtree_id = '<%=Util.null2String(nodeid)%>';
			CXLoadTreeItem("", "/docs/sendDoc/DocReceiveUnitBrowserMultiXML.jsp?<%if(nodeid!=null&&!nodeid.equals("")){%>init=true&nodeid=<%=nodeid%><%}%>");
			var tree = new WebFXTree();
			tree.add(cxtree_obj);
			//document.write(tree);
			document.getElementById('deeptree').innerHTML = tree;
			cxtree_obj.expand();
		}

		jQuery(document).ready(function(){
			initTree();
		});
		
		function setCookie(name,val){ 
			var Then = new Date();
			Then.setTime(Then.getTime() + 30*24*3600*1000 );
			document.cookie = name+"="+val+";expires="+ Then.toGMTString() ;
		}
		
		function doSearch(){
			//setResourceStr();
			var contentWindow = jQuery("#frame2",parent.document).get(0).contentWindow;
			var _document = contentWindow.document;
			if(parent.document.all("showsubdept").checked){
		        document.getElementById("showsubdept").value ="1" ;
				_document.getElementById("showsubdept").value ="1" ;
		    }else{
		        document.getElementById("showsubdept").value ="0" ;
				_document.getElementById("showsubdept").value ="0" ;
		    }
		    //document.getElementById("receiveUnitIds").value = resourceids.substring(1) ;
			jQuery("#btnsearch",_document).trigger("click");
			
		    //document.SearchForm.submit();
		}

		function setReceiveUnit(nodeid){
            var _document = jQuery("#frame2",parent.document).get(0).contentWindow.document;
		    var receiveUnitId = nodeid.substring(nodeid.lastIndexOf("_")+1);
		    document.getElementById("receiveUnitId").value = receiveUnitId;
			_document.getElementById("receiveUnitId").value = receiveUnitId;
		    document.getElementById("nodeid").value = nodeid;
			_document.getElementById("nodeid").value = nodeid;
		    document.getElementById("subcompanyid").value = "";
			_document.getElementById("subcompanyid").value = "";
		    doSearch();
		}
		
		function setSubcompany(nodeid){
		
			var _document = jQuery("#frame2",parent.document).get(0).contentWindow.document;
		    var subcompanyid = nodeid.substring(nodeid.lastIndexOf("_")+1);
		    document.getElementById("subcompanyid").value = subcompanyid;
			_document.getElementById("subcompanyid").value = subcompanyid;
		    document.getElementById("nodeid").value = nodeid;
			_document.getElementById("nodeid").value = nodeid;
		    document.getElementById("receiveUnitId").value = "";
			_document.getElementById("receiveUnitId").value = "";
		    doSearch();
		}
		
		 function onSave(){
		    var trunStr,returnVBArray;
		    trunStr =  onSaveJavaScript();
		    returnVBArray = trunStr.split("$");
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
 		}


		function onClear(){
			var returnjson = {id:"", name:""};
			if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}
			try{
				dialog.close(returnjson);
			}catch(e){}
		    }else{
			    window.parent.returnValue = {id:"", name:""};
			    window.parent.close();
			}
		}
		function onClose(){
			 if(dialog){
		    	dialog.close()
		    }else{
			    window.parent.close();
			}
		}
		//node is a SPAN object
		function check(node){
			highlight(node);
		    if(selectallflag){
		        deeptree.ExpandNode(node.parentElement);
				if(node.parentElement.getElementsByTagName("INPUT")[0].checked){
				    for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
					    if(!node.parentElement.getElementsByTagName("INPUT")[i].checked){
						    node.parentElement.getElementsByTagName("INPUT")[i].click();
						}
					}
		        }else{
					for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
					    node.parentElement.getElementsByTagName("INPUT")[i].checked=false;
		                highlight(node.parentElement.getElementsByTagName("INPUT")[i].previousSibling);
					}
		        }
		    }
		}
		
		//node is a SPAN object
		function highlight(node){
		
			if(node.nextSibling.checked){
				node.style.color='red';
			}
		    else{
				node.style.color='black';
		    }
		}
		function setResourceStr(){
			var resourceids1 = "";
			var resourcenames1 = "";
			try{
				for(var i=0;i<parent.frame2.resourceArray.length;i++){
					resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
					resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
				}
				resourceids=resourceids1
				resourcenames=resourcenames1
			}catch(err){}	
			
			
		}
</script>
<!-- 把body之外的js函数移到body体内 需要初始化的函数写在body内 Google才识别 end 2012-08-07 ypc 修改 end-->
</BODY>
</HTML>

<script language="javaScript">
		function top(){
		<%if(nodeid!=null&&!nodeid.equals("")){%>
			try{
				deeptree.scrollTop=<%=nodeid%>.offsetTop;
				deeptree.HighlightNode(<%=nodeid%>.parentElement);
				deeptree.ExpandNode(<%=nodeid%>.parentElement);
			}catch(e){}
		<%}%>
		}
		
		//node is a DIV object
		function showcom(node){
		
		}
		
		//node is a SPAN object
		function check(node){
			highlight(node);
		
		    if(selectallflag){
		        deeptree.ExpandNode(node.parentElement);
				if(node.parentElement.getElementsByTagName("INPUT")[0].checked){
				    for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
					    if(!node.parentElement.getElementsByTagName("INPUT")[i].checked){
						    node.parentElement.getElementsByTagName("INPUT")[i].click();
						}
					}
		        }else{
					for(i=1;i<node.parentElement.getElementsByTagName("INPUT").length;i++){
					    node.parentElement.getElementsByTagName("INPUT")[i].checked=false;
		                highlight(node.parentElement.getElementsByTagName("INPUT")[i].previousSibling);
					}
		        }
		    }
		}
		
		//end
		
		//node is a SPAN object
		function highlight(node){
		
			if(node.nextSibling.checked){
				node.style.color='red';
			}
		    else{
				node.style.color='black';
		    }
		}
		
		
		   
		function onSaveJavaScript(){      
		        var idStr="";
		        var nameStr="";
		        var nodeidStr="";
		        if(typeof(select.selObj.length)=="undefined") {
				if(select.selObj.checked) {
					var kids = select.selObj.parentNode.childNodes;
					for(var j=0;j<kids.length;j++){
						if(kids[j].type=="label") {
								nameStr +=","+ kids[j].innerText;
								nodeidStr+="|"+ kids[j].id;
								var temp = select.selObj.value;
						                idStr+=","+temp;					

								
								break;
						}
					}
				}
			} else {
				for(var i=0;i<select.selObj.length;i++) {
					if(select.selObj[i].checked) {
					var kids = select.selObj[i].parentNode.childNodes;
						for(var j=0;j<kids.length;j++){
							if(kids[j].type=="label") {				 

   
								nameStr +=","+ kids[j].innerText;
								nodeidStr+="|"+ kids[j].id;
								var temp = select.selObj[i].value;
						                idStr+=","+temp;					

								
								break;
							}
						}				
					}
				}
			}
		
			if(nodeidStr.length>1){
				setCookie("DocReceiveUnitBrowserMulti<%=uid%>",nodeidStr);
			}
		    return idStr +"$" + nameStr;   
		} 
		   
		function needSelectAll(flag,obj){
		   selectallflag=flag;
		   showcom(deeptree);
		   i=obj.value.indexOf('>');
		   if(selectallflag){
		       a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19324,user.getLanguage())%>';
		   }
		   else{
		       a=obj.value.substring(0,i+1)+' <%=SystemEnv.getHtmlLabelName(19323,user.getLanguage())%>';
		   }
		   obj.value=a;
		}
		
		
		
</script>
<SCRIPT type="text/javascript">
resourceids =""
resourcenames = ""

function btnclear_onclick(){
	var returnjson = {id:"", name:""};
	if(dialog){
			try{
				dialog.callback(returnjson);
			}catch(e){}
			try{
				dialog.close(returnjson);
			}catch(e){}
    }else{
	    window.parent.returnValue = {id:"", name:""};
	    window.parent.close();
	}
}


function btnok_onclick(){
	 setResourceStr();
     replaceStr();
     if(dialog){
		 try{
			dialog.callback({id:resourceids,name:resourcenames});
		 }catch(e){}

		  try{
			dialog.close({id:resourceids,name:resourcenames});
		 }catch(e){}

	}else{
        window.parent.returnValue  = {id:resourceids,name:resourcenames};
        window.parent.close();
    }
}

function btnsub_onclick(){
	setResourceStr();
    $("resourceids").val( resourceids.substring(1));
    document.SearchForm.submit();
}
</SCRIPT>




