
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.ArrayList"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />


<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
   	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery-1.4.4.min_wev8.js"></script>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core.min_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
</HEAD>
<%
int uid=user.getUID();

String type=Util.null2String(request.getParameter("type"));
String id=Util.null2String(request.getParameter("id"));
String nodename=Util.null2String(request.getParameter("nodename"));
String level=Util.null2String(request.getParameter("level"));
String subid=Util.null2String(request.getParameter("subid"));
String resourceids = Util.null2String(request.getParameter("resourceids"));
String passedDepartmentIds = Util.null2String(request.getParameter("passedDepartmentIds"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));


String nodeid=null;
String nodeids=null;
Cookie[] cks= request.getCookies();
String rem=null;        
for(int i=0;i<cks.length;i++){
//System.out.println("ck:"+cks[i].getName()+":"+cks[i].getValue());
if(cks[i].getName().equals("postmulti"+uid)){
  rem=cks[i].getValue();
  break;
}
}
if(rem!=null&&rem.length()>1)
nodeids=rem.substring(1);
nodeids="";
String[] resourceidsArray=resourceids.split(",");
for(int i=0;i<resourceidsArray.length;i++){
	if(!"".equals(resourceidsArray[i])){
		String subdept=JobTitlesComInfo.getDepartmentid(resourceidsArray[i]);
	    String subcom=DepartmentComInfo.getSubcompanyid1(subdept);	
	    nodeids=nodeids+"|"+"job_"+subcom+"_"+resourceidsArray[i];
	}
}
if(nodeids.length()>0)
	nodeids=nodeids.substring(1);
/*
if(nodeids!=null){
 if(nodeids.indexOf("|")>-1)
  nodeid=nodeids.substring(nodeids.lastIndexOf("|")+1);
 else
  nodeid=nodeids;
}
boolean exist=false;

if(nodeid!=null&&nodeid.indexOf("job")>-1){
    String jobname=JobTitlesComInfo.getJobTitlesname(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subdept=JobTitlesComInfo.getDepartmentid(nodeid.substring(nodeid.lastIndexOf("_")+1));
    String subcom=DepartmentComInfo.getSubcompanyid1(subdept);
    if(!jobname.equals("")&&subcom.equals(nodeid.substring(nodeid.indexOf("_")+1,nodeid.lastIndexOf("_"))))
		exist=true;
    else
		exist=false;
}
if(!exist)
nodeid=null;
*/
String[] ids=Util.TokenizerString2(nodeids,",");

//System.out.println("nodeid:"+nodeid);
String[] idss=Util.TokenizerString2(resourceids,",");
%>


<BODY>
    <DIV align=right>
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
        RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(userightmenu_self == 1){%>
    <script>
     rightMenu.style.visibility='hidden'
    </script>
<%}%>
    </DIV>

    <table   width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
                <TABLE  class=Shadow>
                    <tr>
                        <td valign="top">
                            <FORM NAME=select STYLE="margin-bottom:0" action="SubcompanyBrowser1.jsp" method=post>
                                <input class=inputstyle type=hidden name=type value="<%=type%>">
                                <input class=inputstyle type=hidden name=id value="<%=id%>">
                                <input class=inputstyle type=hidden name=level value="<%=level%>">
                                <input class=inputstyle type=hidden name=subid value="<%=subid%>">
                                <input class=inputstyle type=hidden name=nodename value="<%=nodename%>">
                                <textarea style="display:none" name=passedDepartmentIds ><%=passedDepartmentIds%></textarea>
                                <textarea style="display:none" name=resourceids ><%=resourceids%></textarea>
                                <TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0" width="100%">
                                     <TR class=Line1><TH colspan="4" ></TH></TR>
                                      <TR>
                                          <TD height=400 colspan="4" >
                                           <div id="deeptree" style="height:100%;width:100%;overflow:scroll;">
                                            	<ul id="ztreedeep" class="ztree"></ul>
                                            </div>
                                          </TD>
                                      </TR>
                                </TABLE>
                            </FORM>
                         </td>
                    </tr>
                </TABLE>
            </td>
            <td></td>
        </tr>
        <tr> <td height="10" colspan="3"></td></tr>
        <tr>
        <td align="center" valign="bottom" colspan=3>
	<BUTTON class=btn accessKey=O  id=btnok onclick="onSave()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="onClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
        <BUTTON class=btnReset accessKey=T  id=btncancel onclick="window.parent.close()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
        </td>
        </tr>
    </table>
<script type="text/javascript">
	//<!--
	/**
	 * 获取url（alax方式获得子节点时使用）
	 */
	function getAsyncUrl(treeId, treeNode) {
		//获取子节点时 
	    if (treeNode != undefined && treeNode.isParent != undefined && treeNode.isParent != null) {
	    	return "/hrm/tree/JobTitlesMultiXML.jsp?" + treeNode.ajaxParam + "&" + new Date().getTime() + "=" + new Date().getTime();
	    } else {
	    	//初始化时
	    	return "/hrm/tree/JobTitlesMultiXML.jsp?<%if(nodeid!=null){%>&nodeid=<%=nodeid%><%}%>" + "&" + new Date().getTime() + "=" + new Date().getTime();
	    }
	};
	//zTree配置信息
	var setting = {
		async: {
			enable: true,       //启用异步加载
			dataType: "text",   //ajax数据类型
			url: getAsyncUrl    //ajax的url
		},
		check: {
			enable: true,       //启用checkbox或者radio
			chkStyle: "checkbox",  //check类型为checkbox
			chkboxType: { "Y" : "", "N" : "" } 
		},
		view: {
			expandSpeed: ""     //效果
		},
		callback: {
			onClick: zTreeOnClick,   //节点点击事件
			onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
		}
	};

	var zNodes =[
	];
	
	$(document).ready(function(){
		//初始化zTree
		$.fn.zTree.init($("#ztreedeep"), setting, zNodes);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    if (treeNode.isParent) {
			treeObj.expandNode(treeNode);
		}
		treeObj.checkNode(treeNode, true, false);
	};


	function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
	    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	    treeObj.expandAll(true);
	    
	    var nodeids="<%=nodeids%>".split("|");
	    var selectedids="<%=resourceids%>".split(",");
	    
	    for(var i=0;i<nodeids.length;i++){
	    	var node = treeObj.getNodeByParam("id", nodeids[i], null);
		    if (node != undefined && node != null ) {
		    	treeObj.selectNode(node);
		    	treeObj.checkNode(node, true, true);
		    }
	    }
	}
	
	function checkNode(selectedids,nodeid){
		var flag=false;
		for (var i = 0; i < selectedids.length; i++) { 
			if (selectedids[i] == nodeid) { 
				flag=true;
				break; 
			} 
		}
		return flag;
	}
	
	
	function onSaveJavaScript(){
	    var nameStr="";
	    var idStr = "";
	    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
		var nodes = treeObj.getCheckedNodes(true);
		var nodeids="";
		
		if (nodes == undefined || nodes == "" || nodes.length < 1) {
			return "";
		}
		
		for (var i=0; i<nodes.length; i++) {
			idStr =idStr+","+nodes[i].nodeid.split("_")[2];
			nameStr = nameStr+","+nodes[i].name;
			nodeids=nodeids+"|"+nodes[i].nodeid;
		}
		resultStr = idStr + "$" + nameStr;
	    return resultStr;
	}
	
	function onSave() {
    	var  trunStr = "", returnVBArray = null;
	    trunStr =  onSaveJavaScript();
	    if(trunStr != "") {
			returnVBArray = trunStr.split("$");
			var returnjson = {id:returnVBArray[0], name:returnVBArray[1]};
	        window.parent.returnValue  = returnjson;
	        window.parent.close();
	    } else {
	        window.parent.close();     
		}
    }
    
    function onClear() {
	    window.parent.returnValue = {id:"", name:""};
	    window.parent.close();
	}
	//-->
</SCRIPT>
</BODY>
</HTML>
