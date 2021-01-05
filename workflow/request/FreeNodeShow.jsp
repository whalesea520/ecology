
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE>
<html>
  <head>

	<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
	<jsp:useBean id="WFFreeFlowManager" class="weaver.workflow.request.WFFreeFlowManager" scope="page"/>
	<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
	<%@ include file="/systeminfo/init_wev8.jsp" %>

	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<script  src='/js/ecology8/request/freeWorkflowShow_wev8.js'></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	
	<link rel="stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css">
<!--	<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>-->
	<script type="text/javascript" src="/js/jquery/ui/ui.core_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.draggable_wev8.js"></script>
	<script type="text/javascript" src="/js/jquery/ui/ui.resizable_wev8.js"></script>
	<script language="javascript" src="/js/jquery/ui/ui.droppable_wev8.js"></script>

	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzRadio_wev8.js"></script>
	
	<link href="/css/ecology8/request/freeWorkflowShow_wev8.css" type=text/css rel=STYLESHEET>

	<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
	<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

	<%
		String workflowid = Util.null2String(request.getParameter("workflowid")) ;
		int requestid = Util.getIntValue(request.getParameter("requestid"));
		int roadduty = Util.getIntValue(request.getParameter("isroutedit"));
		int frmsduty = Util.getIntValue(request.getParameter("istableedit"));
		//当前节点
		int nodeid = -1;
		//当前节点流转的下一个节点

		int prenodeid = -1;
		//创建节点
		int startnodeid = -1;
		//归档节点
		int stopnodeid = -1;		
		int createrid = 0;
           
        //新建
        if(requestid == -1){
		  createrid=user.getUID();
		}else{
          	RecordSet.executeSql("select  creater from workflow_requestbase a where a.requestid="+requestid);
		  	if(RecordSet.next()){
		     	createrid = Util.getIntValue(RecordSet.getString("creater"),0);
		  	}
        }

        //查询流程的创建节点和归档节点
		RecordSet.executeSql("select nodeid,nodetype from workflow_flownode where (nodetype=0 or nodetype=3) and workflowid="+workflowid);
		while (RecordSet.next()) {
			int nodetype = Util.getIntValue(RecordSet.getString("nodetype"),0);
			if(nodetype == 0){
				startnodeid = Util.getIntValue(RecordSet.getString("nodeid"),0);
			}else if(nodetype == 3){
				stopnodeid = Util.getIntValue(RecordSet.getString("nodeid"),0);
			}
		}
		
		if(requestid == -1){
			nodeid = startnodeid;
			prenodeid = stopnodeid;
			roadduty = 1;
		}else{
			//当前节点
			nodeid = Util.getIntValue((String) session.getAttribute(user.getUID() + "_" + requestid + "nodeid"));
		}	
		
		List list = new ArrayList();
		String src = Util.null2String(request.getParameter("src"));
		boolean saveflag = true;
		if (src.equals("save")) {
			saveflag = WFFreeFlowManager.SaveFreeFlow(request,requestid,nodeid,user.getLanguage());
		}
		//当前节点下的自由节点
		RecordSet.executeSql("select id from workflow_nodebase where startnodeid=" + nodeid + " and requestid=" + requestid + " order by floworder,id");

		while (RecordSet.next()) {
			 int freenodeid = Util.getIntValue(RecordSet.getString("id"),0);
			 list.add(freenodeid);
		}
	
		String nodeStr = "[";
		StringBuilder nodeBuilder = new StringBuilder();
		nodeBuilder.append("[");
		int consult = startnodeid;
		while(consult != -1){
			RecordSet.executeSql("select * from("+
				"select base.id,node.workflowid,base.nodename,node.nodetype,node.isFormSignature,node.IsPendingForward,"+
				"base.operators,base.Signtype,base.floworder from workflow_flownode node,workflow_nodebase base where node.nodeid=base.id ) a "+
				"left join ("+
				"select rights.nodeid,manage.retract,manage.pigeonhole,rights.isroutedit,rights.istableedit from "+
				"workflow_function_manage manage full join workflow_freeright rights on manage.operatortype=rights.nodeid"+
				") b on a.id=b.nodeid where a.workflowid="+workflowid+" and a.id="+consult);

			while (RecordSet.next()) {
				if(consult == nodeid){
					prenodeid = consult;
				}
				String operators = Util.null2String(RecordSet.getString("operators"));
				String operatornames = "";
				ArrayList operatorlist = Util.TokenizerString(operators,",");
				
				int floworder = Util.getIntValue(RecordSet.getString("floworder"),0);
				String nodename = Util.null2String(RecordSet.getString("nodename"));
				int Signtype = Util.getIntValue(RecordSet.getString("Signtype"),0);
				int freenodeid = Util.getIntValue(RecordSet.getString("id"),0);
				int nodetype = Util.getIntValue(RecordSet.getString("nodetype"),0);
				int isFormSignature = Util.getIntValue(RecordSet.getString("isFormSignature"),0);
				int road = Util.getIntValue(RecordSet.getString("isroutedit"),0);
				int frms = Util.getIntValue(RecordSet.getString("istableedit"),0);

				if(nodetype == 0){
				   operatorlist = new ArrayList();
                   operatorlist.add(createrid+"");
                   operators = createrid+"";
                }

				for(int j=0;j<operatorlist.size();j++){
					if(operatornames.equals("")){
						operatornames=ResourceComInfo.getLastname((String)operatorlist.get(j));
					}else{
						operatornames+=","+ResourceComInfo.getLastname((String)operatorlist.get(j));
					}
				}
				String nodeDo="";
				int IsPendingForward=Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
				if(IsPendingForward==1){
					nodeDo=nodeDo+"1,";
				}				
				int pigeonhole=Util.getIntValue(RecordSet.getString("pigeonhole"),0);
				if(pigeonhole==1){
					nodeDo=nodeDo+"2,";
				}
				int retract=Util.getIntValue(RecordSet.getString("retract"),0);
				if(retract==1){
					nodeDo=nodeDo+"3,";	
				}
				if(nodeDo.lastIndexOf(",")>-1){
					nodeDo = nodeDo.substring(0,nodeDo.lastIndexOf(","));
				}

			/*	nodeStr=nodeStr+"{";
				nodeStr=nodeStr+"nodeid:'"+freenodeid+"',";
				nodeStr=nodeStr+"nodetype:'"+nodetype+"',";
				nodeStr=nodeStr+"floworder:'"+floworder+"',";
				nodeStr=nodeStr+"nodename:'"+nodename+"',";
				nodeStr=nodeStr+"Signtype:'"+Signtype+"',";
				nodeStr=nodeStr+"operators:'"+operators+"',";
				nodeStr=nodeStr+"operatornames:'"+operatornames+"',";

				nodeStr=nodeStr+"road:'"+road+"',";//路径编辑
				nodeStr=nodeStr+"frms:'"+frms+"',";//表单编辑
				nodeStr=nodeStr+"trust:'"+isFormSignature+"',";//节点签章
				nodeStr=nodeStr+"nodeDo:'"+nodeDo+"'";//操作

				nodeStr=nodeStr+"},";
				*/
				nodeBuilder.append("{").append("nodeid:'").append(freenodeid).append("',nodetype:'").append(nodetype).append("',floworder:'").append(floworder).append("',nodename:'")
					.append(nodename).append("',Signtype:'").append(Signtype).append("',operators:'").append(operators).append("',operatornames:'").append(operatornames).append("',road:'")
					.append(road).append("',frms:'").append(frms).append("',trust:'").append(isFormSignature).append("',nodeDo:'").append(nodeDo).append("'},");
			}

			if(consult == stopnodeid){
				consult = -1;
			}else{
				//寻找下一个节点

				RecordSet.executeSql("select destnodeid from workflow_nodelink where  nodeid="+consult+" and wfrequestid is null and workflowid = "+workflowid+" and (((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 and (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and (IsFreeNode is null or IsFreeNode !='1'))>0 ) or ((select COUNT(1) from workflow_nodebase b where workflow_nodelink.nodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0  or (select COUNT(1) from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and IsFreeNode ='1' and requestid="+requestid+")>0 ))");

				String nextnodeid = "";
				while (RecordSet.next()) {
					nextnodeid = nextnodeid+Util.null2String(RecordSet.getString("destnodeid"))+",";
				}

				if(!nextnodeid.equals("")){
					nextnodeid = nextnodeid.substring(0,nextnodeid.lastIndexOf(","));
					String[] nnode = nextnodeid.split(",");
					if(nnode.length > 1){
						for(String nid : nnode){
							RecordSet.executeSql("select COUNT(id) as id from workflow_nodelink where destnodeid="+nid);
							if(RecordSet.next()) {
								if(Util.getIntValue(RecordSet.getString("id"),0) == 1){
									consult = Util.getIntValue(nid,0);
								}
							}
						}
						if (("," + nextnodeid).indexOf("," + consult + ",") == -1) {
                            consult = Util.getIntValue(nnode[1], -1);
                        }
					}else{
						consult = Util.getIntValue(nextnodeid,0);
					}
				}else{
					consult = -1;
				}
			}

			if(prenodeid != stopnodeid){
				if(list.size() == 0 && prenodeid == nodeid){
					prenodeid = consult;
				}else if(list.size() > 0 && prenodeid != -1){
					if(!list.contains(consult)){
						list = new ArrayList();
					}
					prenodeid = consult;
				}
			}
		}
	     nodeStr = nodeBuilder.toString();
		if(nodeStr.lastIndexOf(",") > -1){
			nodeStr = nodeStr.substring(0,nodeStr.lastIndexOf(","));
		}
		nodeStr += "]";
		//nodeBuilder.append("]");
		
	%>
	<script type="text/javascript">
		jQuery(function (){
			
			var fullData=eval("<%=nodeStr%>");
			var currnodeid=<%=nodeid%>;
			var nextnodeid=<%=prenodeid%>;

			var option=[
				{id:0,value:'<%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%>'},
				{id:1,value:'<%=SystemEnv.getHtmlLabelName(359, user.getLanguage())%>'},
				{id:2,value:'<%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%>'},
				{id:3,value:'<%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%>'}
			];

			freeWorkflow.setNodeTypeOption(option);

			option=[
				{id:0,value:'<%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%>'},
				{id:1,value:'<%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%>'},
				{id:2,value:'<%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%>'}
			];

			freeWorkflow.setSignTypeOption(option);

			option=[{id:0,value:'<%=SystemEnv.getHtmlLabelName(83519, user.getLanguage())%>'},
					{id:1,value:'<%=SystemEnv.getHtmlLabelName(32178, user.getLanguage())%>'},
					{id:2,value:'<%=SystemEnv.getHtmlLabelName(84500, user.getLanguage())%>'}]
			freeWorkflow.setRoadTypeOption(option);
			
			freeWorkflow.setInitNodeName('<%=SystemEnv.getHtmlLabelName(15070, user.getLanguage())%>');

			freeWorkflow.setFreedata(jQuery(".freeNode", window.top.freewindow.document));
			freeWorkflow.setRequestid(<%=requestid%>);
			freeWorkflow.setRoadDuty(<%=roadduty%>);
			freeWorkflow.setFrmsDuty(<%=frmsduty%>);
			freeWorkflow.create(jQuery("#mainSpan"),fullData,currnodeid,nextnodeid);

			jQuery(".spanBase").mousedown(function (){
				jQuery(".spanChecked").removeClass("spanChecked");
				jQuery(".spanOther").addClass("spanChecked");
				jQuery("#spanBase").css("display","block");
				jQuery("#spanOther").css("display","none");
			});
			jQuery(".spanOther").mousedown(function (){
				jQuery(".spanChecked").removeClass("spanChecked");
				jQuery(".spanBase").addClass("spanChecked");
				jQuery("#spanOther").css("display","block");
				jQuery("#spanBase").css("display","none");
			});

			jQuery("#spanOther").jNice();
			jQuery("#spanBase").find("select").selectbox();
			jQuery("#spanOther").find("select").selectbox();
		})
		
		function doSave(obj) {
			if(jQuery(".nodeChecked").length>0&&jQuery("#detail_disable").css("display")=="none"){
				freeWorkflow.saveDetail();
			}

			if (check_form(document.FreeWorkflowSetform,document.FreeWorkflowSetform.checkfield.value)){
			//	document.FreeWorkflowSetform.submit();
				
				//把保存的信息提交到父页面
				freeWorkflow.saveDataToParent();

				obj.disabled=true;
				freeWorkflow.saveChangedStatus();
				clostWin();
			}
		}
		
		function changeName(value){
			//alert(value);
			freeWorkflow.changeNodeName(value);
		}
		function changeType(value){
			//alert(value);
			freeWorkflow.changeNodeType(value);
		}
		function browserCallback(e, valObj, name, ele) {
			if (valObj != undefined && valObj != null) {
				var resourceids = valObj.id;
				var resourcename = valObj.name;

				jQuery("input[name='operatornames']").val(resourcename);
			}
		}
		function onShowBrowser(res){
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.URL = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
			dialog.callbackfun = function (paramobj, id1) {
				if (id1 != undefined && id1 != null) {
				  var resourceids = id1.id;
				  var resourcename = id1.name;

				  jQuery("#"+res).val(resourceids);
				  jQuery("input[name='operatornames']").val(resourcename);
				  
				  jQuery("#"+res+"span").empty();
				  if(resourcename.length>0){
					var resnames=resourcename.split(",");
					var resids=resourceids.split(",");
					for(var i=0;i<resnames.length;i++){
						if(resnames[i]!=""){
							var span="<span class='e8_showNameClass'>"
										+"<a href='#"+resids[i]+"' target='_blank' title='"+resnames[i]+"' style='max-width:105px;'>"
										+resnames[i]
										+"</a>"
										+"<span id='"+resids[i]+"' class='e8_delClass' onclick=\"del(event,this,1);mark('"+res+"')\" >"
										+"&nbsp;x&nbsp;"
										+"</span>"
									+"</span>";
							jQuery("#"+res+"span").append(span);
						}
					}
				  }
					
				}
			} ;
			dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
			dialog.Width = 550 ;
			dialog.Height = 600;
			dialog.Drag = true;
			//dialog.maxiumnable = true;
			dialog.show();
			// var	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
			// if (id1 != null) {
			//   var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			//   var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			
			//   jQuery("#"+res).val(resourceids);
			//   jQuery("input[name='operatornames']").val(resourcename);
			  
			//   jQuery("#"+res+"span").empty();
			//   if(resourcename.length>0){
			// 	var resnames=resourcename.split(",");
			// 	var resids=resourceids.split(",");
			// 	for(var i=0;i<resnames.length;i++){
			// 		if(resnames[i]!=""){
			// 			var span="<span class='e8_showNameClass'>"
			// 						+"<a href='#"+resids[i]+"' target='_blank' title='"+resnames[i]+"' style='max-width:105px;'>"
			// 						+resnames[i]
			// 						+"</a>"
			// 						+"<span id='"+resids[i]+"' class='e8_delClass' onclick=\"del(event,this,1);mark('"+res+"')\" >"
			// 						+"&nbsp;x&nbsp;"
			// 						+"</span>"
			// 					+"</span>";
			// 			jQuery("#"+res+"span").append(span);
			// 		}
			// 	}
			//   }
			// }
		}
		function mark(res){
			var text="";
			jQuery("#"+res+"span").find("a").each(function (){
				text=text+jQuery(this).text()+",";
			});
			if(text.lastIndexOf(",")>-1){
				text = text.substring(0,text.lastIndexOf(","));
			}
			jQuery("input[name='operatornames']").val(text);
		}
		
		function clostWin()
		{
			//关闭对话框

			window.top.freedialog.close();
		}
	</script>
  </head>
  
  <body>
  	<div>
		<div id="mainSpan">	
			<div class="menu">
				<div class="insert" title="<%=SystemEnv.getHtmlLabelName(15598,user.getLanguage())%>"></div>
				<div class="remove" title="<%=SystemEnv.getHtmlLabelName(15599,user.getLanguage())%>"></div>
				<div class="agency" title="<%=SystemEnv.getHtmlLabelName(84501,user.getLanguage())%>" onclick="jQuery('#operators_browserbtn').click();"></div>
			</div>
		</div>
		<div id="detail_disable"></div>
		<div id="detail">
			<table width='100%' cellpadding="0" cellspacing="0" border="0"><tr><td align="center">
			<div style='margin: 10px 6px 10px 6px;'>
				<div class='spanBase'><%=SystemEnv.getHtmlLabelName(16261, user.getLanguage())%></div>
				<div class='spanOther spanChecked'><%=SystemEnv.getHtmlLabelName(17563, user.getLanguage())%></div>
			</div>
			</td></tr><tr><td>
			<div style="margin-left: 10px;margin:10px 6px 0px 6px; ">
				<div id='spanBase'>
					<table width='100%'>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr style="height:30px;">
							<td width="80px"><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>					
							<td>
								<input class=inputstyle style="width:120px" type='text' name='nodename' onblur="changeName(this.value)"/>
								<div class='bacoError'><img src='/images/BacoError_wev8.gif' align='absMiddle'/></div>
							</td>		
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr style="height:30px;">
							<td width="80px"><%=SystemEnv.getHtmlLabelName(15536, user.getLanguage())%></td>					
							<td>
								<select class=inputstyle style="width:120px" name='nodetype' onchange="changeType(this.value)">
									<option value="0"><%=SystemEnv.getHtmlLabelName(125, user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(359, user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(251, user.getLanguage())%></option>
								</select>
							</td>
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr style="height:30px;">
							<td width="80px"><%=SystemEnv.getHtmlLabelName(21790, user.getLanguage())%></td>					
							<td>
								<select class=inputstyle style="width:120px" name='Signtype'>
									<option value="0"><%=SystemEnv.getHtmlLabelName(15556, user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(15557, user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(15558, user.getLanguage())%></option>
								</select>
							</td>
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr style="height:30px;">
							<td width="80px"><%=SystemEnv.getHtmlLabelName(553, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127, user.getLanguage())%></td>				
							<td><!--/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp-->
								<brow:browser _callback="browserCallback" viewType="0" name="operators" browserValue="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=" hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp" width="118px" browserSpanValue=""> </brow:browser>
								<input class=inputstyle type='hidden' name='operatornames'/>
							</td>
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
					</table>
				</div>
				<div id='spanOther' style='display:none'>
					<table width='100%'>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr height='30px'>
							<td width="80px"><%=SystemEnv.getHtmlLabelName(124788, user.getLanguage())%></td>					
							<td><select class=inputstyle style="width:120px" name='road'>
									<option value="0">无</option>
									<option value="1">加签</option>
									<option value="2">后续</option>
								</select>
							</td>		
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr height='30px'>
							<td width="80px"><%=SystemEnv.getHtmlLabelName(33473, user.getLanguage())%></td>					
							<td><input type='radio' tzCheckbox="true" class=InputStyle name='frms' value='0'/></td>	
						</tr>
						<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr height='30px' style="display:none;">
							<td width="80px"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21650, user.getLanguage())%></td>		
							<td><input type='radio' tzCheckbox="true" class=InputStyle name='trust' value='0'/></td>
						</tr>
				<!--		<TR style="height:1px;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr height='30px'>
							<td width="80px">同步所有节点</td>					
							<td><input type='radio' tzCheckbox="true" class=InputStyle name='sync' value='0'/></td>	
						</tr>-->
						<TR style="height:1px;display:none;">
							<TD class=Line colSpan=2></TD>
						</TR>
						<tr style="display:none;">
							<td colSpan=2>
								<table width='100%'>
									<tr>
										<td width="80px">节点操作</td>
										<td>
											<table width='100%'>
												<tr height='30px'>
													<td width='30px'>
														<input type="checkbox" name="nodeDo" value="1">
													</td>
													<td>转发</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<table width='100%'>
												<tr height='30px'>
													<td width='30px'>
														<input type="checkbox" name="nodeDo" value="2">
													</td>
													<td>强制归档</td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td></td>
										<td>
											<table width='100%'>
												<tr height='30px'>
													<td width='30px'>
														<input type="checkbox" name="nodeDo" value="3">
													</td>
													<td>强制收回</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<TR style="height:1px;display:none;">
							<TD class=Line colSpan=2></TD>
						</TR>
					</table>
				</div>
			</div>
			</td></tr></table>
		</div>
	</div>
	<form id='freeForm' name="FreeWorkflowSetform" method="post" action="FreeDivShow.jsp">
		<input type=hidden name="requestid" value="<%=requestid%>"/>
		<input type='hidden' id="rownum" name="rownum"/>
		<input type='hidden' id="indexnum" name="indexnum"/>
		<input type='hidden' id="checkfield" name="checkfield"/>
		<input type='hidden' name="freeNode" value="1"/>
		<input type='hidden' name='freeDuty' value="<%=roadduty%>"/>
	</form>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<table width="100%">
			<tr><td style="text-align:center;">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="javascript:doSave(this)">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="clostWin();">
			</td></tr>
		</table>
	</div>	
  </body>
</html>
