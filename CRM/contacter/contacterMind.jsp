<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.alibaba.fastjson.JSONArray"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@page import="weaver.conn.BatchRecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%
	String titlename = SystemEnv.getHtmlLabelName(572,user.getLanguage()) + SystemEnv.getHtmlLabelName(82639,user.getLanguage());
	String customerId = request.getParameter("customerId");
	String contacterId = Util.null2String(request.getParameter("contacterId"));//contacterId
	String firstname = request.getParameter("firstname");
	String jobtitle = Util.null2String(request.getParameter("jobtitle"));
	String title = Util.null2String(request.getParameter("title"));
	String mobilephone = Util.null2String(request.getParameter("mobilephone"));
	String email = Util.null2String(request.getParameter("email"));
	String phoneoffice =  Util.null2String(request.getParameter("phoneoffice"));
	String imcode =  Util.null2String(request.getParameter("imcode"));
	String attitude =  Util.null2String(request.getParameter("attitude"));
	String attention =  Util.null2String(request.getParameter("attention"));
	//用户权限判断
	User usr = HrmUserVarify.getUser(request, response);
    String usrId = usr.getUID()+"";
	boolean canView = false;
	boolean canEdit = false;
	//判断是否有查看该客户权限
	String usertype = "0";
	String logintype = ""+user.getLogintype();
	if(logintype.equals("2")){
		usertype="1";
	}
	int sharelevel = CrmShareBase.getRightLevelForCRM(usrId,customerId,usertype);
	if(sharelevel>0){
		canView=true;
        if(sharelevel==2) canEdit=true;
        if(sharelevel==3||sharelevel==4){
        	canEdit=true;
        }
    }
	if(!canView){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	
	/***查询联系人 如果有保存过联系人关系图，则显示联系人关系图，否则直接根据客户ID查询联系人**/
	String total_attitude = "";
	int zcwf = 0;
	int wbt = 0;
	int wfd = 0;
	int fd = 0;
	String arrData = "";
	JSONArray arr = new JSONArray();
	String customerName = "";
	String sql = "select m.contacterid,m.parentid,m.direction,t.id,t.firstname,t.jobtitle,t.mobilephone,t.phoneoffice,t.imcode,t.attention,t.attitude,t.email,title.fullname as title,title.id as titleid,c.name from CRM_CustomerContacter t "+
				" left join crm_customercontacter_mind m on m.contacterid = t.id "+
				" left join crm_customerinfo c on t.customerid = c.id "+
				" left join CRM_ContacterTitle title on t.title = title.id"+
				" where t.customerid = "+customerId + " order by t.id ";
	rs.execute(sql);
	while (rs.next()) {
		JSONObject obj = new JSONObject();
		customerName = Util.null2String(rs.getString("name"));
		obj.put("id", Util.null2String(rs.getString("id")));
		if(StringUtil.isNullOrEmpty(rs.getString("parentid"))){
			obj.put("parentid", "root");
		}else{
			obj.put("parentid", rs.getString("parentid"));
		}
		String direction = rs.getString("direction");
		if("1".equals(direction)){
			direction = "right";
		}else if("-1".equals(direction)){
			direction = "left";
		}else{
			direction = "right";
		}
		obj.put("direction", direction);
		attitude = Util.null2String(rs.getString("attitude"));
		if("支持我方".equals(attitude)){
			zcwf++;
			attitude = "<span  style=\"background-color:#00DD00;color:#FFFFFF;border-radius: 15px;font-size:11px;font-weight:600;padding:0 10px;display:inline-block;width:auto;height:24px;line-height:24px;text-align:center; \">"+attitude+"</span>";
		}else if("未反对".equals(attitude)){
			wfd++;
			attitude = "<span  style=\"color:#FFFFFF;background-color:#FFAA33;border-radius: 15px;font-size:11px;font-weight:600;padding:0 10px;display:inline-block;width:auto;height:24px;line-height:24px;text-align:center; \">"+attitude+"</span>";
		}else if("反对".equals(attitude)){
			fd++;
			attitude = "<span  style=\"background-color:red;color:#FFFFFF;border-radius: 15px;font-size:11px;font-weight:600;padding:0 10px;display:inline-block;width:auto;height:24px;line-height:24px;text-align:center; \">"+attitude+"</span>";
		}else if("未表态".equals(attitude)){
			wbt++;
			attitude = "<span  style=\"background-color:#00a3ff;color:#FFFFFF;border-radius: 15px;font-size:11px;font-weight:600;padding:0 10px;display:inline-block;width:auto;height:24px;line-height:24px;text-align:center; \">"+attitude+"</span>";
		}else{//未表态
			wbt++;
			attitude = "<span  style=\"background-color:#00a3ff;color:#FFFFFF;border-radius: 15px;font-size:11px;font-weight:600;padding:0 10px;display:inline-block;width:auto;height:24px;line-height:24px;text-align:center; \">未表态</span>";
		}
		contacterId = Util.null2o(rs.getString("id"));
		/**卡片信息**/
		StringBuffer topic = new StringBuffer();
	    title = rs.getString("title");
	    if("先生".equals(title)){
	    	title = "<td valign=\"top\"; style=\"width:20px;\"><img style=\"width:20px;\" src=\"/CRM/images/contacterMind/man.png\" ></div>";
	    }else{
	    	title = "<td valign=\"top\"; style=\"width:20px;\"><img style=\"width:20px;\" src=\"/CRM/images/contacterMind/women.png\" ></div>";
	    }
	    
		firstname = Util.null2String(rs.getString("firstname"));
		firstname = "<a href=\"#\" onclick=\"openFullWindowHaveBar('/CRM/contacter/ContacterView.jsp?ContacterID="+contacterId+"')\" style=\"color:#0d0e0e;font-size:13px;font-weight:bold;\">"+"<span style=\"display:inline-block;width:56px;overflow:hidden;\">"+firstname+"</span></a>";
		jobtitle = Util.null2String(rs.getString("jobtitle"));
		jobtitle = "<span style=\"font-size:12px;display:inline-block;width:135px;overflow: hidden;\">"+jobtitle+"</span>";
		attention = Util.null2String(rs.getString("attention"));
		//attention = "<span style=\"display:inline-block;overflow:hidden;\">"+attention+"</span>";
		phoneoffice = Util.null2String(rs.getString("phoneoffice"));
		phoneoffice = "<span style=\"width:128px;display:inline-block;overflow:hidden;\"><img style=\"width:13px; vertical-align:middle;\" src=\"/CRM/images/contacterMind/phoneoffice.png\">"+" "+phoneoffice+"</span>";
		email = "<a href=\"#\" title=\"发送邮件\" onclick=\"openFullWindowHaveBar('/email/new/MailInBox.jsp?opNewEmail=1&isInternal=0&to="+Util.null2String(rs.getString("email"))+"')\" style=\"color:#30b5ff;\">"+Util.null2String(rs.getString("email"))+"</a>";
		email = "<span style=\"width:128px;display:inline-block;overflow:hidden;\"><img style=\"width:13px;vertical-align:middle;\" src=\"/CRM/images/contacterMind/email.png\" style=\"color:#0d0e0e;\">"+" "+email+"</span>";
		mobilephone = Util.null2String(rs.getString("mobilephone"));
		mobilephone = "<span style=\"width:128px;display:inline-block;overflow:hidden;\"><img style=\"width:13px;vertical-align:middle;\" src=\"/CRM/images/contacterMind/mobilephone.png\">"+" "+mobilephone+"</span>";
		imcode = Util.null2String(rs.getString("imcode"));
		imcode = "<span style=\"width:128px;display:inline-block;overflow:hidden;\"><img style=\"width:13px;vertical-align:middle;\" src=\"/CRM/images/contacterMind/imcode.png\">"+" "+imcode+"</span>";
		String imString = "";
		List<String> im = new ArrayList<String>();
	    if(StringUtil.isNotNullAndEmpty(rs.getString("phoneoffice"))){
			im.add(phoneoffice);
		}
	    if(StringUtil.isNotNullAndEmpty(rs.getString("email"))){
			im.add(email);
		}
	    if(StringUtil.isNotNullAndEmpty(rs.getString("mobilephone"))){
			im.add(mobilephone);
		}
	    if(StringUtil.isNotNullAndEmpty(rs.getString("imcode"))){
			im.add(imcode);
		}
	    int imLen = im.size();
		int j = 0;
		imString += "<tr style=\"height:20px;\">";
		if(imLen > 0){
			for(int i = 0; i < imLen;i++){
				if(j%2 == 0 && j > 0){
					imString += "</tr>";
					imString += "<tr style=\"height:20px;\">";
				}
				imString += "<td>"+im.get(0)+"</td>";
				im.remove(0);
				j++;
			}
		}else{
			imString += "<td><span style=\"width:128px;display:inline-block;\"><span/></td>"+
						"<td><span style=\"width:128px;display:inline-block;\"><span/></td>";
		}
		if(imLen == 1){
			imString += "<td><span style=\"width:128px;display:inline-block;\"><span/></td>";
		}
		imString += "</tr>";
		
		String rightTd = 
		"<td style=\"padding:0px 2px;\">"+
			"<table class=\"mind\" style=\"width:100%;\">"+
				"<tr class=\"mind\" valign=\"top\";>"+
					"<td>"+firstname+"</td>"+
					"<td>"+jobtitle+"</td>"+
					"<td style=\"text-align: right;\">"+attitude+"</td>"+
				"</tr>"+
				"<tr  style=\"height:20px;\">"+
					"<td colspan=3  style=\"word-break:break-all;white-space:normal;width:185px;\">"+attention+"</td>"+
				"</tr>"+
				"<tr>"+
					"<td style=\"padding:0px 5px;\" height=\"1px;\"; bgcolor=\"#e7e7e7\"; colspan='3'></td>"+
				"</tr>"+
				"<tr>"+
					"<table>"+
						imString +
					"</table>"+
				"</tr>"+
		"</table>"+
		"</td>";
		topic.append("<table style='font-size:11px';color:'#7d7f81';><tr>");
		topic.append(title).append(rightTd);
		topic.append("</tr></table>");
		obj.put("topic",topic.toString());
		arr.add(obj);
	}
	if(zcwf>0){
		total_attitude +=" | 支持我方("+zcwf+")  ";
	}
	if(wbt>0){
		total_attitude +=" | 未表态("+wbt+")  ";
	}
	if(wfd>0){
		total_attitude +=" | 未反对("+wfd+")  ";
	}
	if(fd>0){
		total_attitude +=" | 反对("+fd+")  ";
	}
	
	if(StringUtil.isNotNullAndEmpty(total_attitude)){
		total_attitude = total_attitude.substring(2,total_attitude.length());
	}
	
	JSONObject obj = new JSONObject();
	obj.put("id", "root");
	obj.put("isroot", true);
	if("".equals(customerName)){
		customerName = CustomerInfoComInfo.getCustomerInfoname(customerId);
	}
	obj.put("topic", customerName);
	arr.add(obj);
	arrData = arr.toString();
	int contacterNum = zcwf+wbt+wfd+fd;
%>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title><%=titlename %></title>
		<link type="text/css" rel="stylesheet" href="../css/jsmind.css" />
		<style type="text/css">
			#mind_top{
				background:#FFF;
				height:30px; 
				}
			#mind_total{
				float:left;
				}
			#mind_operate{
				float:right;
				}
			#mind_total ul{
				text-align:center;
				line-height:15px;
				margin:0px auto;
				padding:0;
				margin-left:53px; 
				font-size:12px;
				color:#7d7f81;
				height:30px;
				margin-top: 6px;
				}
			#mind_operate ul{
				margin:0px auto;
				padding:0;
				margin-right:25px; 
				height:30px; 
				}
			#mind_operate ul li{
				list-style:none;
				float:right;
				margin-top: 6px;
   				margin-left: -1px;
				}
			
			#mind_operate ul li a{
				width:60px;
				height:18px;
				line-height:15px;
				color:#30b5ff;
				background:#FFF;
				margin:1px 0px;
				font-size:12px;
				text-align:center;
				text-decoration:none;
				border:1px solid #30b5ff;
				display:block;
				}
			#jsmind_container {
				height: 93%;
				width: 99.5%;
				border: solid 1px #ccc;
				background: #f4f4f4;
			}
			
			a {
				text-decoration: none;
			}
			a:hover {
				text-decoration: none;
			}
			jmnode{box-shadow:0px 0px 10px #aaa;}
			jmnode.selected{box-shadow:0px 0px 10px #017afd;}
			jmnode:hover{box-shadow:0px 0px 10px #777;}
		</style>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
		<%
	if(canEdit){
		RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(2022, user.getLanguage())
			+ ",javascript:resetContacter(),_top} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"
				+ SystemEnv.getHtmlLabelName(81294, user.getLanguage())
				+ ",javascript:createContacter(),_top} ";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(31229, user.getLanguage())
			+ ",javascript:editContacter(),_top}";
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"
			+ SystemEnv.getHtmlLabelName(81299, user.getLanguage())
			+ ",javascript:deleteContacter(),_top} ";
		RCMenuHeight += RCMenuHeightStep;
	}
	
%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
	<div id="mind_top">
		<div id="mind_total">
		 	<ul>共<%=contacterNum %>位联系人：
		 	<%=total_attitude%>
		 	</ul>
		</div>
		<div id="mind_operate">
			<ul>
				<li><a style="width:90px;" href="#" onclick="showLog()">日志</a></li>
				<li><a href="#" onclick="zoomOut()"> - 缩小</a></li>
			    <li><a href="#" onclick="zoomIn()"> + 放大</a></li>
			    <li><a style="width:90px;" href="#" onclick="collapse_all()">  全部收起 </a></li>
			    <li><a style="width:90px;" href="#" onclick="expand_all()">  全部展开 </a></li>
			</ul>
		</div>
	</div>
	<div id="jsmind_container"></div>

	<script type="text/javascript" src="../js/jsmind.js"></script>
	<script type="text/javascript" src="../js/jsmind.draggable.js"></script>
	<script type="text/javascript" src="../js/jsmind.shell.js"></script>
	<script type="text/javascript">
	
    var _jm = null;
    function load_jsmind(datas){
        var mind = {
            meta:{
            },
            format:'node_array',
            data:datas

        };
        var options = {
            container:'jsmind_container',
            editable:false,
            theme:'weaver'
        }
        _jm = jsMind.show(options,mind);
        if(<%=canEdit%>){
        	editable();
        }
        
        
    }
    
    function replay(){
        var shell = _jm.shell;
        if(!!shell){
            shell.replay();
        }
    }
	
	function createContacter(){
		var parentid = "root";
		var direction = "1";
		var node = _jm.get_selected_node();
		if(null != node){
			parentid = _jm.get_selected_node().id;
			direction = _jm.get_selected_node().direction;
		}	
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/CRM/contacter/contacterMindNew.jsp?customerId="+<%=customerId%>+"&parentid="+parentid+"&direction="+direction;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(81294, user.getLanguage())%>";
		dialog.Width = 420;
		dialog.Height =420;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	function editContacter(){
		var node = _jm.get_selected_node();
		if(null == node){
			window.top.Dialog.alert("请选中联系人后右键编辑！");
		}else{
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var contacterId = _jm.get_selected_node().id;
			var url = "/CRM/contacter/contacterMindNew.jsp?contacterId="+contacterId+"&customerId="+"<%=customerId%>";
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(31229, user.getLanguage())%>";
			dialog.Width = 420;
			dialog.Height =420;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.show();
		}	
		
	}
	
	function deleteContacter(){
		var node = _jm.get_selected_node();
		if(null == node){
			window.top.Dialog.alert("请选中联系人后右键编辑！");
		}else{
			window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>？",function(){
			var contracterId = _jm.get_selected_node().id;
				$.post("/CRM/contacter/contacterMindOperate.jsp",
						{"action":"delete",
						"contacterId":contracterId,
						"customerId":"<%=customerId%>"
						}, function(data,status){
								window.location.reload(true);
		 					 });
		});
		}
	}
	
	function showLog(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/CRM/contacter/contacterMindLog.jsp?customerId="+"<%=customerId%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061, user.getLanguage())%>";
		dialog.Width = 800;
		dialog.Height =600;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	var arr = new Array();
	var old_parent = "";
	var new_parent = "";
	var selectd_node = "";
	function saveContacterMind(){
		editable();
		arr.length = 0;
		findAllChildrenByNode(_jm.get_root());
		$.post("/CRM/contacter/contacterMindOperate.jsp",
					{"datas":JSON.stringify(arr),
					 "old_parent":old_parent,
					 "new_parent":new_parent,
					 "customerId":"<%=customerId%>",
					 "contacterId":selectd_node
					}, function(data,status){
								//window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22619, user.getLanguage())%>");
								old_parent = "";
								new_parent = "";
	 					 });
	 
	}
	
	function findAllChildrenByNode(node){
		var id;
		var parentid;
		var obj;
		var direction;
		var children = node.children;
		var length = children.length;
		if(length>0){
			for(var i = 0 ;i < length;i++){
				id = children[i].id;
				parentid = children[i].parent.id;
				direction = children[i].direction;
				obj = {"id":id,"parentid":parentid,"direction":direction};
				arr.push(obj);
				this.findAllChildrenByNode(children[i]);
			}
		}
	}
	
	
	function resetContacter(){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27088,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(84498,user.getLanguage())%>",function(){
			$.post("/CRM/contacter/contacterMindOperate.jsp",
					{"customerId":<%=customerId%>,
					"action":"reset"
					}, function(data,status){
							window.location.reload(true);
	 					 });
		});
		
	}
	
	
	function editable(){
        _jm.enable_edit();
    }
    
    function expand_all(){
        _jm.expand_all();
    }
    
    function collapse_all(){
        _jm.collapse_all();
    }
    //浏览器版本
  	var browserName = $.client.browserVersion.browser;             //浏览器名称
  	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
  	var osVersion=$.client.version;                                //操作系统版本
  	var browserOS=$.client.os;
	 
     function zoomIn() {
     if((browserName == "IE"&&browserVersion<10)){
		 window.top.Dialog.alert("不支持IE9及以下版本,请升级IE版本");
	  }
        _jm.view.zoomIn();
       
    };

    function zoomOut() {
    if((browserName == "IE"&&browserVersion<10)){
		 window.top.Dialog.alert("不支持IE9及以下版本,请升级IE版本");
	  }
       _jm.view.zoomOut();
    };
    
     
    load_jsmind(<%=arrData%>);
</script>
	</body>
</html>
