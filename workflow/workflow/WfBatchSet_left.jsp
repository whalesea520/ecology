<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.json.JSONObject" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" ></jsp:useBean>
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" ></jsp:useBean>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" ></jsp:useBean>
<jsp:useBean id="jsonarray" class="org.json.JSONArray" scope="page" ></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" ></jsp:useBean>
<jsp:useBean id="buffer" class="java.lang.StringBuffer" scope="page"></jsp:useBean>
<%
	boolean isUseWfManageDetach = manageDetachComInfo.isUseWfManageDetach();	
	buffer.append("select a.id,a.typename,b.id,b.workflowname,b.version from workflow_type a left join workflow_base b on a.id = b.workflowtype where 1 = 1");
	
	String workflowname = Util.null2String(request.getParameter("workflownamespan"));
	if("".equals(workflowname)){
	    workflowname = Util.null2String(request.getParameter("workflowname"));
	}
	int workflowtype = Util.getIntValue(request.getParameter("workflowtype"),0);
	
    if(StringUtils.isNotBlank(workflowname)){
        buffer.append(" and b.workflowname like '%").append(workflowname).append("%'");
    }
    
    if(isUseWfManageDetach){
		String hasRightSub=SubCompanyComInfo.getRightSubCompany(user.getUID(),"WorkflowManage:All",0);
		if(StringUtils.isNotBlank(hasRightSub)){
		    buffer.append(" and b.subcompanyid in (").append(hasRightSub).append(")");
		}
    }
	
	if(workflowtype > 0){
	    buffer.append(" and a.id = ").append(workflowtype);
	}
	buffer.append(" order by a.id");
	rs.execute(buffer.toString());
	
	JSONObject root = new JSONObject();
	root.put("id","t_0");
	root.put("pId","-1");
	root.put("name",SystemEnv.getHtmlLabelName(332,user.getLanguage()));
	root.put("open",true);
	jsonarray.put(root);
	
	Map<Integer,Boolean> cachemap = new HashMap<Integer,Boolean>();
	int version = 0;
	while(rs.next()){
	    if(cachemap.get(rs.getInt(1)) == null){
		    JSONObject jsonobjwftype = new JSONObject();
		    jsonobjwftype.put("id","t_"+rs.getString(1));
		    jsonobjwftype.put("pId","t_0");
		    jsonobjwftype.put("name",Util.null2String(rs.getString(2)));
		    jsonobjwftype.put("open",true);
		    jsonarray.put(jsonobjwftype);
		    
		    cachemap.put(rs.getInt(1),true);
	    }
	    
	    
	    JSONObject jsonobjwf = new JSONObject();
	    jsonobjwf.put("id",rs.getString(3));
	    jsonobjwf.put("pId","t_"+rs.getString(1));
	    
	    
	    version = Util.getIntValue(rs.getString("version"), 1);
	    if(version == 1){
		    jsonobjwf.put("name",Util.null2String(rs.getString(4)));
	    }else{
		    jsonobjwf.put("name",Util.null2String(rs.getString(4))+"(V"+version+")");
	    }
	    jsonarray.put(jsonobjwf);
	}
	
%>

<HTML>
<HEAD>
    <LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.core_wev8.js"></script>
	<script type="text/javascript" src="/wui/common/jquery/plugin/zTree/js/jquery.ztree.excheck.min_wev8.js"></script>
<SCRIPT type="text/javascript">
		var setting = {
			check: {
				enable: true
			},
			data: {
				simpleData: {
					enable: true
				}
			},
			view: {
				expandSpeed: ""
			},
			  callback: {
			   onClick: zTreeOnClick,   //节点点击事件
			   onCheck: zTreeOnCheck,
			   onAsyncSuccess: zTreeOnAsyncSuccess  //ajax成功事件
			 }
		};
	 
		jQuery(document).ready(function(){
			jQuery.fn.zTree.init(jQuery("#ztreedeep"),setting,<%=jsonarray.toString()%>);
			jQuery('.flowMenusTd').show();
			jQuery('.searchInputSpan').find('span').css('right','100');
			
	         jQuery('.leftadvancesearchbtn').toggle(
	         	function(){
	         		jQuery('.advancesearchdiv_0').show();
	         	},
	         	function(){
	         		jQuery('.advancesearchdiv_0').hide();
	         	}
	         );
	         
	        jQuery('#close').click(function(){
	        	jQuery('.advancesearchdiv_0').hide();
	        });
	        
	        jQuery('#searchBtn').click(function(){
	        	leftform.submit();
	        });
	        
	        jQuery('#fieldname1').css('padding-left','10px!important');
		});
		
		
		
		function zTreeOnClick(event, treeId, treeNode) {
		    var treeObj = $.fn.zTree.getZTreeObj(treeId);
		    if (treeNode.isParent) {
				treeObj.expandNode(treeNode);
			}
		}
		var flagre='false';
		function zTreeOnAsyncSuccess(event, treeId, treeNode, msg) {
		    var treeObj = $.fn.zTree.getZTreeObj(treeId);
	
		    if (selectallflag) {
		    	 if (treeNode != undefined && treeNode != null) {
		 		    if (treeNode.checked) {
		 			    var childrenNodes = treeNode.childs;
		 		    	for (var i=0; i<childrenNodes.length; i++) {
		 		    		treeObj.checkNode(childrenNodes[i], true, false);
		 				}
		 		    }
		 	    }
		    }
			var node = null;
			
		    if (cxtree_ids != undefined && cxtree_ids != null && flagre=='false') {
				flagre='true';
			    for (var z=0; z<cxtree_ids.length; z++) {
					node = treeObj.getNodeByParam("id", "q_" + cxtree_ids[z], null);
				    if (node != undefined && node != null ) {
				    	treeObj.selectNode(node);
				    	treeObj.checkNode(node, true, false);
				    }
			    }
			}
		}	
		
		
		 function onSaveJavaScript(){
		    var nameStr="";
		    var idStr = "";
		    var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
			var nodes = treeObj.getSelectedNodes(true);
			//var nodes = treeObj.getCheckedNodes(true);
			if (nodes == undefined || nodes == "" || nodes.length < 1) {
				return "";
			}
			for (var i=0; i<nodes.length; i++) {
			 var checkid=""+nodes[i].id;
			 if (checkid.indexOf("q_")<0) {
					//nameStr += "," + nodes[i].id;
					//idStr += "," + nodes[i].name;
					nameStr = nodes[i].id;
					idStr = nodes[i].name;
				 }
			}
		 	resultStr = nameStr + "$" + idStr;
		    return resultStr;
		}
		
		function zTreeOnCheck(event, treeId, treeNode) {
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
	
			var nodes = treeNode.childs;
			
			if (nodes == null || nodes == undefined) {
				treeObj.reAsyncChildNodes(treeNode, "refresh");
			} else {
				if (selectallflag && treeNode.checked) {
			    	for (var i=0; i<nodes.length; i++) {
				    	if (nodes[i].checked) {
				    		treeObj.checkNode(nodes[i], false, false);	
				    	}
				    	treeObj.checkNode(nodes[i], true, false);
					}
				}
			}
		}
	
	
		 function onCheck(e,treeId,treeNode){
            var treeObj=$.fn.zTree.getZTreeObj("treeDemo"),
            nodes=treeObj.getCheckedNodes(true),
            v="";
            for(var i=0;i<nodes.length;i++){
               v+= nodes[i].id+",";
            }
              document.getElementById('test').value=v;
         }
         
         
         function getSelectedWfids(){
         	 var treeObj = $.fn.zTree.getZTreeObj("ztreedeep");
	         var nodes = treeObj.getCheckedNodes(true);
	         var wfids = '';
	         jQuery.each(nodes,function(i,node){
	         	if(node.id.indexOf('t_') === -1){
	         		wfids += node.id + ',';
	         	}
	         });
	         if(wfids.length > 0){
	         	wfids = wfids.substring(0,wfids.length - 1);
	         }
	         return wfids;
         }
         
         function search(){
         	jQuery("input[name='workflownamespan']").val(jQuery('.advancesearchdiv_0').find("input[name='workflowname']").val());
         	leftform.submit();
         }
	</SCRIPT>
	<style type="text/css">
		.leftadvancesearchbtn{
			border:none!important;
			cursor:pointer;
			color:#888686;
			height:21px!important;
			line-height:21px!important;
			padding-left:5px;
			padding-right:5px;
			background-color:#fff;
			border-left:1px solid rgb(189,189,189)!important;
		}
		
		.leftadvancesearchbtn span{
			font-size:12px;
		}
		
		td.leftTypeSearchtemp{
			vertical-align:top;
			height:60px;
			width:246px!important;
			font-size:15px;
			border-right:1px solid #BDBDBD;
			/*border-bottom:1px solid #dadada;*/
			background-color:rgb(245,245,245);
			position:relative;
		}
		.leftType{
			font-weight:bold;
		}
		
		.searchInput{
			border:none!important;
			vertical-align:middle;
			height:100%!important;
			background-color:#FFF;
			width:145px;
		}
		
		.searchInputSpan{
			/*background-color:#F5F5F5;*/
			display:-moz-inline-box;
			display:inline-block;
			height:21px!important;
			border:0px;
			top:0px!important;
			border:1px solid rgb(189,189,189)!important;
			border-left:none!important;
			background-color:#fff!important;
			width:100%;
		}
		
		.advancesearchdiv_0{
			position:absolute;
			left:0px;
			top:53px;
			width:246px;
			z-index:2;
			background-color:#FFF;
			display:none;
		}
		.wfResetLeftDiv{
			position:absolute;
			z-index:1;
			top:0px;
			left:0px;
		}
	</style>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script>
rightMenu.style.visibility='hidden'
</script>	
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>

<form id="leftform" name ="leftform" method="post" action="/workflow/workflow/WfBatchSet_left.jsp">
<div class="advancesearchdiv_0">
	<wea:layout type="twoCol" attributes="{'cw1':'30%','cw2':'70%'}">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(20550 , user.getLanguage()) %>' >
	    	<wea:item attributes="{'id':'fieldname1'}"><%=SystemEnv.getHtmlLabelName(81651, user.getLanguage())%></wea:item>
		    <wea:item><span><input type="text" name="workflowname" class="Inputstyle" value="<%=workflowname %>"></span></wea:item>
	    	<wea:item attributes="{'id':'fieldname2'}"><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
	    	<wea:item>
	    		<span>
			    	 	<brow:browser viewType="0" name="workflowtype"
									browserValue='<%=workflowtype+"" %>'
									browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkTypeBrowser.jsp"
									_callback="" 
									hasInput="false" isSingle="true" hasBrowser="true"
									isMustInput="1" completeUrl="/data.jsp"
									browserDialogWidth="600px"
									browserSpanValue='<%=WorkTypeComInfo.getWorkTypename(workflowtype+"") %>'>
						</brow:browser>
		    		</span> 
	    	</wea:item>
	    </wea:group>
	     <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_cancel" onclick="search();"/>
				<span class="e8_sep_line">|</span>
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="close"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>
<div class="wfResetLeftDiv">
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearchtemp">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(127118,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="searchInputSpan" style="position:relative;">
					<input type="text" class="searchInput middle" name="workflownamespan" value="<%=workflowname %>" style="vertical-align: top;">
					<span class="middle searchImg" id="searchBtn">
						<img class="middle" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
					</span>
					<span class="leftadvancesearchbtn"><span><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span></span>
				</span>
			</div>
		</td>
		<td rowspan="2"></td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv">
						<div id="deeptree" style="overflow:hidden;">
							<ul id="ztreedeep" class="ztree"></ul>
						</div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
</form>
</div>
<style type="text/css">
	.fieldName{
		padding-left:15px !important;
	}
</style>
</body>
</html>