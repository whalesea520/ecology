<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="weaver.page.HPTypeEnum"%>
<%@ page import="weaver.workflow.form.FormManager"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSetTrans" scope="page"/>
<jsp:useBean id="hpu" class="weaver.page.PageUtil" scope="page"/>
<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page"/>
<jsp:useBean id="sc" class="weaver.synergy.SynergyComInfo" scope="page"/>
<%
	String hpid = Util.null2String(request.getParameter("hpid"), "");
	boolean isSetting="true".equalsIgnoreCase(Util.null2String(request.getParameter("isSetting"), "false"));
	int wfid = Util.getIntValue(request.getParameter("wfid"), 0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
	int requestid = Util.getIntValue(request.getParameter("requestid"), -1);
	String formid = Util.null2String(request.getParameter("formid"), "");
	String isbill = Util.null2String(request.getParameter("isbill"), "");
	
	String moduleid = Util.null2String(request.getParameter("moduleid"), "");
	String layoutname = Util.null2String(request.getParameter("layoutname"), "");
	
	
	//表单联动字段
	String _fieldids = Util.null2String(request.getParameter("paramfieldid"), "");
	String fieldids = "";
	String fieldvalues = "";
	String weaverSplit = "||~WEAVERSPLIT~||";
	if (!"".equals(_fieldids)) {
		String[] fieldid = _fieldids.split(",");
		if (fieldid.length > 0) {
			for (int i = 0; i < fieldid.length; i++) {
				fieldids += fieldid[i].replace("field", "") + ",";
				if ("".equals(Util.null2String(request.getParameter(fieldid[i]), ""))) {
					fieldvalues += "null" + weaverSplit;
				} else {
					fieldvalues += Util.null2String(request.getParameter(fieldid[i])) + weaverSplit;
				}
				
			}
			if (!"".equals(fieldids)) {
				fieldids = fieldids.substring(0, fieldids.length() - 1);
			}
			if (!"".equals(fieldvalues)) {
				fieldvalues = fieldvalues.substring(0, fieldvalues.length() - weaverSplit.length());
			}
		}
	}

	//前端展示
	if (!isSetting) {
		//response.sendRedirect("/homepage/Homepage.jsp?hpid="+hpid+"&wfid="+wfid+"&nodeid="+nodeid+"&isSetting="+isSetting+"&pagetype="+HPTypeEnum.HP_WORKFLOW_FORM.getName()+"&isfromportal=1&requestid="+requestid+"&fieldids="+fieldids+"&fieldvalues="+fieldvalues);
		String url = "/homepage/Homepage.jsp?hpid="+hpid+"&wfid="+wfid+"&nodeid="+nodeid+"&isSetting="+isSetting+"&pagetype="+HPTypeEnum.HP_WORKFLOW_FORM.getName()+"&isfromportal=1&requestid="+requestid+"&fieldids="+fieldids+"&fieldvalues="+fieldvalues;
%>
		<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="param" value=""/>
		</jsp:include>
<%	} else {
		//后端配置
		//判断是新增还是编辑或查看
		if ("".equals(hpid) && isSetting) {
			try{
				//往协同表中添加记录数据
				rs.execute("select max(id) from synergy_base");
				rs.first();
				int id = rs.getInt(1) + 1; // 获取id手动加1
				hpid = -id + ""; // 将id作为页面id，加上负号与门户页面区分
				
				rst.setAutoCommit(false);
				rst.executeSql("insert into synergy_base (id,frommodule,frompage,wftype,wfid,supid,modulename,orderkey,styleid,layoutid,subcompanyid,haslayout,showtree)" +
					" values( "+id+", '"+HPTypeEnum.HP_WORKFLOW_FORM.getName()+"', '', '', "+wfid+", '-1', '-1' ,'-1' , 'synergys', '1' , '1', '0', '0')");
				
				//取流程和流程节点名称
				rst.execute("select workflowname from workflow_base where id=" + wfid);
				String wfName = "";
				if (rst.next())
					wfName = rst.getString(1);
				
				rst.execute("select nodename from workflow_nodebase where id=" + nodeid);
				String wfnName = "";
				if (rst.next())
					wfnName = rst.getString(1);
				
				//插入初始化的主页信息
				String infoname = wfName + "-" + wfnName;
				rst.executeSql("insert into hpinfo_workflow (infoname,styleid,layoutid,isuse,islocked,creatortype,creatorid,menuStyleid,wfid,wfnid,hpid)" +
					" values('"+infoname+"', '1', '1', '1', '1', '0', '1', '1', "+wfid+", "+nodeid+", "+hpid+")");
		
			}catch(Exception e){
				e.printStackTrace();
				rst.rollback();
			}finally{
				rst.commit();
				sc.removeSynergyInfoCache();
			}
		}
	
		//设置元素页面
		String url = "/homepage/Homepage.jsp?hpid="+hpid+"&wfid="+wfid+"&nodeid="+nodeid+"&isSetting="+isSetting+"&pagetype="+HPTypeEnum.HP_WORKFLOW_FORM.getName()+"&requestid="+requestid;
%>
	<%@ include file="/systeminfo/init_wev8.jsp" %>
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
	<html>
	<head>
	<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<script language="javascript" src="/js/weaver_wev8.js"></script>
	
	<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
	<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
	<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
	
	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	</head>
	<body>
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				
				<div>
				    <ul class="tab_menu">
				    </ul>
				    <div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
	    
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>
	</body>
	</html>
	
	<script language="javascript">
		jQuery(function(){
		    jQuery('.e8_box').Tabs({
		        getLine:1,
		        iframe:"tabcontentframe",
		        staticOnLoad:true,
		        mouldID:"",
		        objName:"<%=layoutname%>"
		    });
		});
		
		function refreshTab(){
			var f = window.parent.oTd1.style.display;
			if (f != null) {
				if(f==''){
					window.parent.oTd1.style.display='none';
				}else{ 
					window.parent.oTd1.style.display='';
					window.parent.wfleftFrame.setHeight();
				}
			}
		}
		
		function closeDialogCallback() {
			document.getElementById('tabcontentframe').contentWindow.closeDialogCallback();
		}
	</script>
<% }%>