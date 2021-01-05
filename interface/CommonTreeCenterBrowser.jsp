<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>

<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/interface/ztreev3/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script type="text/javascript" src="/interface/ztreev3/js/jquery.ztree.core-3.5_wev8.js"></script>
<script type="text/javascript" src="/interface/ztreev3/js/jquery.ztree.excheck-3.5_wev8.js"></script>
<script type="text/javascript" src="/interface/ztreev3/js/jquery.ztree.exedit-3.5_wev8.js"></script>
<%--QC295666 [80][90]数据展现集成-解决自定义浏览按钮收藏/帮助两个按钮无效的问题--%>
<%
    String titlename = SystemEnv.getHtmlLabelName(33387,user.getLanguage());
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<%
String isreport = Util.getIntValue(request.getParameter("isreport"),0)+"";

String type = URLDecoder.decode(Util.null2String(request.getParameter("browsertype")));
String ismutil = Util.null2String(request.getParameter("ismutil"));//1：单选；2：多选
String othercallback = Util.null2String(request.getParameter("othercallback"));
String currenttime = Util.null2String(request.getParameter("currenttime"));
if("".equals(currenttime)){
	currenttime= new Date().getTime()+"";
}
String workflowid = Util.getIntValue(request.getParameter("workflowid"),-1)+"";
Browser browser=(Browser)StaticObj.getServiceByFullname(type, Browser.class);
String tempname = browser.getName();
if("".equals(tempname)){
	tempname = SystemEnv.getHtmlLabelName(83327 ,user.getLanguage());
	}//自定义浏览框
String href = Util.null2String(browser.getHref());
String outpage = Util.null2String(browser.getOutPageURL());
String search = Util.null2String(browser.getSearch());

String beanids = Util.null2String(request.getParameter("beanids"));
//System.out.println("beanids:"+beanids);

String parentfield = browser.getParentfield();
String from = Util.null2String(browser.getFrom());

browser.initBaseBrowser("",type,from);

%>
<div class="content_wrap" >
	
		
	<div class="zTreeDemoBackground left" >
		<ul id="treeDemo" class="ztree" style="overflow:auto"></ul>
	</div>
	<div style="width: 100%;height: 100px;">
	&nbsp;
	</div>
		

	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="text-align: center;">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_submit id=btnok val="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" onclick="jsOK()"></input>
					<input type="button" class=zd_btn_submit id=btnclear value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="jsClear()"></input>
					<input type="button" class=zd_btn_cancle id=btncancel value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" onclick="jsCancel()"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<div id="tmpTitle" style="display: none;"></div>
		<!-- 用于缓存之前信息 -->
		<div id="e8_box_middle_bak" style="display: none;"></div>
	</div>
	<div id="hshadowAdvancedSearchOuterDiv" style="top: 228px; height: 300px;width: 348px;margin-left:2px;display: none;position: absolute;background:rgb(220, 226, 241);z-index:2;opacity:0.6"></div>
</div>

<SCRIPT type="text/javascript">
	
	var setting = {
	    view:{
				selectedMulti: false
			},
		check:{
			enable: true,
			<%if(ismutil.equals("1")){%>
			chkStyle: "radio",
			radioType:"all"
			<%}else{%>
			chkboxType:{"Y" : "", "N" : ""}
			<%}%>
		},
		data: {
			simpleData: {
				enable: true
			}
		}
		
	};
	
	var treeNodes;
	var treeObj;
	var currenttime = <%=currenttime%>;
	function initTreeData(){
		 $.ajax({  
	        async : false,  
	        cache:false,  
	        type: 'POST',  
	        data:{'checked':'false','type':'<%=type%>','currenttime':currenttime,'workflowid':'<%=workflowid%>','isreport':'<%=isreport%>'},
	        dataType : "json",  
	        url: "/interface/CommonTreeCenterTreeData.jsp",
	        error: function () {//请求失败处理函数  
	            alert('请求失败');  
	        },  
	        success:function(data){ //请求成功后处理函数。  
	            
	            treeNodes = data;   //把后台封装好的简单Json格式赋给treeNodes  
	            $.fn.zTree.init($("#treeDemo"), setting, treeNodes);
	            treeObj= $.fn.zTree.getZTreeObj("treeDemo");
	            initSelected("<%=beanids%>");
	        }  
	    });  
	}
	
	
	
	
	
	function getSelectValue(){
        var ids = "";  
	    var names = "";
	    
	    var checkid = new Array;// 存放选中id的数组   
        var checkname = new Array;// 存放选中name的数组     	
	 
	    var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
	    nodes=treeObj.getCheckedNodes(true),
	    v="";
	    for(var i=0;i<nodes.length;i++){
		     checkname.push(nodes[i].name);// 添加id到数组 
             checkid.push(nodes[i].id);
	    }
	    var array = new Array();  
	    array[0] = checkid.toString();  
	    array[1] = checkname.toString();
	    
	    return array;  
    }	
	
	
	$(document).ready(function(){
	    initTreeData();
	});
	
	function initSelected(arraysStr){
	  var strArray=arraysStr.split(",");
	  for(var i=0;i<strArray.length;i++){
		   var node = treeObj.getNodeByParam("id", ""+strArray[i]);
		   treeObj.selectNode(node);
		   treeObj.checkNode(node, true, true);
	  }
	}
	
	
	function jsOK(){
	    var array = getSelectValue();  //选中值array[0] 为ID，array[1]为名称,格式都为"xx,xx"  
        if(array[0].length == 0){  
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(558 ,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(124877 ,user.getLanguage())%>");
            return;  
        }
        try
        {
         	var returnjson = {id:array[0], name:array[1]};
     
         	if(dialog){
				try{
				     dialog.callback(returnjson);
				}catch(e){}
				 
				try{
				     dialog.close(returnjson);
				}catch(e){}
			}else{
				<%if(!"1".equals(othercallback)){%>
			  		window.parent.returnValue=returnjson;
				    window.parent.close();
			  	<%}else{%>
			  		returnData("{'id':'"+array[0]+"','name':'"+array[1]+"'}")
			  	<%}%>
				
			}
        }
        catch(e)
        {
        	 window.parent.close();
        }  
	}
	
	function jsClear(){
	   
        try
        {
         	 var returnjson = {id:"", name:""};
     
         	if(dialog){
				try{
				     dialog.callback(returnjson);
				}catch(e){}
				 
				try{
				     dialog.close(returnjson);
				}catch(e){}
			}else{
				<%if(!"1".equals(othercallback)){%>
			  		window.parent.returnValue=returnjson;
				    window.parent.close();
			  	<%}else{%>
			  		returnData("{'id':'','name':''}");
			  	<%}%>
				
			}
        }catch(e)
        {
        	 window.parent.close();
        }  
	}
	
	function jsCancel(){
	     if(dialog){
	 
    	dialog.close()
    }else{
	    window.parent.close();
	}
	}
	
	
</SCRIPT>
<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
<script language="javascript">
window.parent.setTabObjName("<%=tempname %>");
	$(function(){
	try{
		window.parent.setTabObjName("<%=tempname %>");
	}catch(e){
		//alert("ddddddddddddd");
	}
});
var parentWin = window.parent.parent.getParentWindow(parent);
var dialog = window.parent.parent.getDialog(parent);
</SCRIPT>
<%
if(!"".equals(parentfield))
{
%>
<SCRIPT LANGUAGE=VBS>
Sub returnData(returnstr)
   window.parent.returnvalue = returnstr
   window.parent.Close
End Sub
</SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
	 
</script>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(83577,user.getLanguage())%>
<%}%>
<%
//添加自定义浏览框使用记录
weaver.interfaces.workflow.browser.BrowserLogService BrowserLogService = new weaver.interfaces.workflow.browser.BrowserLogService();
BrowserLogService.save(type);
%>