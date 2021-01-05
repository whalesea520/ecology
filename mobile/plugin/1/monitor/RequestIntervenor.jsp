<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ page import="weaver.workflow.request.ComparatorUtilBean" %>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<%

User user = HrmUserVarify.getUser (request , response) ;
String intervenoruserids="";
String intervenoruseridsType="";
String intervenorusernames="";
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int intervenorright = Util.getIntValue(request.getParameter("intervenorright"),0);
int isbill = Util.getIntValue(request.getParameter("isbill"),0);
int formid = Util.getIntValue(request.getParameter("formid"),0);
int billid = Util.getIntValue(request.getParameter("billid"),0);
int userid = Util.getIntValue(request.getParameter("userid"),0);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
int nodetype = Util.getIntValue(request.getParameter("nodetype"),0); 
int creater =Util.getIntValue(request.getParameter("creater"),0);
int creatertype =Util.getIntValue(request.getParameter("creatertype"),0);
int usertype = Util.getIntValue(request.getParameter("usertype"),0);
String creatername = "";
if(creatertype==1){  
	creatername=CustomerInfoComInfo.getCustomerInfoname(""+creater);
}else{
	creatername=ResourceComInfo.getResourcename(""+creater);
}
RecordSet.executeSql("select currentnodeid from workflow_requestbase where requestid = " + requestid);
if(RecordSet.next()){
    if(RecordSet.getInt("currentnodeid") > 0){
       nodeid = RecordSet.getInt("currentnodeid");
    }
}
int nextnodeid=-1;
String nodeattr="";
ArrayList BrancheNodes=new ArrayList();
int endNodeId = 0;
if(intervenorright>0){
    String billtablename = "";
    int operatorsize = 0;

    WFNodeMainManager.setWfid(workflowid);
    WFNodeMainManager.selectWfNode();
    boolean thisNodeFlag = false;
    while(WFNodeMainManager.next()){
        //保存归档节点的节点id
        if("3".equals(WFNodeMainManager.getNodetype())){
            endNodeId = WFNodeMainManager.getNodeid();
        }
        if(WFNodeMainManager.getNodeid()==nodeid){
            nodeattr=WFNodeMainManager.getNodeattribute();
            thisNodeFlag = true;
        }
    }
    if(nodeattr.equals("2")){
        BrancheNodes=WFLinkInfo.getFlowBrancheNodes(requestid,workflowid);
    }
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();


    if (isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息


			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表


    }
//查询节点操作者


    requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(""+nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		requestNodeFlow.setIsintervenor("1");
		hasnextnodeoperator = requestNodeFlow.getNextNodeOperator();
	    //新增处理，如果下一个节点和当前的节点的分类（主干和分叉）不一致时，不显示默认干预节点
	    //if(hasnextnodeoperator){
		if(hasnextnodeoperator 
		        && ("2".equals(requestNodeFlow.getNextnodeattribute()) == "2".equals(nodeattr)) 
		        && requestNodeFlow.getNextnodeattribute() != null
	            && !"".equals(requestNodeFlow.getNextnodeattribute()) 
	            && (("1".equals(requestNodeFlow.getIsFreeNode()) && endNodeId == requestNodeFlow.getNextNodeid()) 
	                || !"1".equals(requestNodeFlow.getIsFreeNode()))){
			operatorsht = requestNodeFlow.getOperators();
            nextnodeid=requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            if(operatorsize > 0){

                TreeMap map = new TreeMap(new ComparatorUtilBean());
				Enumeration tempKeys = operatorsht.keys();
				try{
				while (tempKeys.hasMoreElements()) {
					String tempKey = (String) tempKeys.nextElement();
					ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
					map.put(tempKey,tempoperators);
				}
				}catch(Exception e){}
				Iterator iterator = map.keySet().iterator();
                Map<String,String> opertorMap = new HashMap<String,String>();
				while(iterator.hasNext()) {
				String operatorgroup = (String) iterator.next();
				ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
				for (int i = 0; i < operators.size(); i++) {
				    String operatorandtype = (String) operators.get(i);
						String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
						String opertor = operatorandtypes[0];
						//去除重复操作者
						if(opertorMap.containsKey(opertor)){
						    continue;
						}else{
						    opertorMap.put(opertor,"");
						}
						String opertortype = operatorandtypes[1];
						String opertorsigntype = operatorandtypes[3];
						if(opertorsigntype.equals("-3")||opertorsigntype.equals("-4")) continue;
                        intervenoruserids+=opertor+",";
						intervenoruseridsType +=opertortype+",";
                        if("0".equals(opertortype)){
						intervenorusernames += "<A href='javaScript:openhrm("+opertor+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(opertor)+"</A>&nbsp;";
						}else{
						intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor)+" ";
						}

				}
                }
        }
        }
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
		intervenoruseridsType=intervenoruseridsType.substring(0,intervenoruseridsType.length()-1);
    }
}
	

	//User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	String relationArr[] = new String[]{"15556","15557","15558","125399","125400","125401"};
	String eh_fromcreate = Util.null2String(request.getParameter("eh_fromcreate"));
%>
<style type="text/css">
.pageMasking{
	width:100%; height:100%; top:0px; left:0px;
	position:absolute; z-index:99; background-color:rgb(51, 51, 51); opacity:0.2;
}
.showWinInter{
	width:50%; position:absolute; z-index:999; margin:0;
	min-width:300px;
	box-shadow:0px 0px 2px 2px #b3b3b3;
	/*border:4px solid transparent;
    -moz-border-top-colors: #b3b3b3 #d2d2d2 #e9e9e7 #f7f7f5;
    -moz-border-left-colors: #b3b3b3 #d2d2d2 #e9e9e7 #f7f7f5;
    -moz-border-bottom-colors: #b3b3b3 #d2d2d2 #e9e9e7 #f7f7f5;
    -moz-border-right-colors: #b3b3b3 #d2d2d2 #e9e9e7 #f7f7f5;*/
	border-top-left-radius:5px;
    border-top-right-radius:5px;
    border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
    color:#323232;
    font-family:"Microsoft YaHei";
	-webkit-user-select:none; onselectstart:none;<!--禁止页面选中 -->
}

.showWin333{
	width:50%; top:50px; left:8px; position:absolute; z-index:999;
	-webkit-user-select:none; onselectstart:none;<!--禁止页面选中 -->
}
.showWin_masking{
	width:95%; position:absolute; z-index:9999; background-color:rgb(51, 51, 51); opacity:0.2;
	display:none; text-align:center; font-size:16px; color:#eeefff;
}
.winHead{
	height:51px; line-height:51px; color:#323232;
    border-top-left-radius:5px;
    border-top-right-radius:5px;
	background:#dfdfdf; 
}
.winHead_title{
	width:70%; float:left; padding-left:25px; font-size:16px;
    <% if(user.getLanguage() == 8){%>
    line-height:16px;padding-top:9px;
    <%}%>
}
.winHead_close{
    color:#898989;
	width:32px; float:right; font-size:18px; font-weight:bold; cursor:pointer;
}
.winContent{
	background:#f1f6f7;
	border:1px solid #e0e0e0;
	border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
	color:#333;
}
.winContentTitle{
    width:50%;
    height:46px;
    line-height:46px;
    margin-left:25%;
    margin-right:25%;
    font-size:16px;
    text-align:center;
    color:#333;
    border-top-left-radius:5px;
    border-top-right-radius:5px;
}

.winContentTitleHead{
    border-top-left-radius:5px;
    border-top-right-radius:5px;
    border-left:1px solid #e0e0e0;
    border-top:1px solid #e0e0e0;
    border-right:1px solid #e0e0e0;
}
.operatorArea{
	width:100%; font-size:16px; color:#333; padding-top:2px;
}
.operatorArea .oper_title{
	float:left; width:150px; height:32px; line-height:32px; padding-left:12px; 
    width:90% !important;
}
.operatorArea .operation_title{
    float:left;  height:32px;  padding-left:12px; 
    
    <% if(user.getLanguage() == 8){%>
    width:200px;
    line-height:16px;
    <%}else{%>
    width:250px;
    line-height:32px;
    <%}%>
}
.operatorArea .oper_info{
	float:right; height:32px; line-height:32px;
}
.operatorArea .oper_choose{
	float:right; padding:4px 12px 0px 12px; cursor:pointer;
}
.operatorArea .oper_add{
	clear:both; height:62px ; padding-left:14px;
}
.operatorArea .oper_show{
	clear:both; height:62px ; padding-left:14px;
}


.operatorArea .Interval_add{
	clear:both; height:32px; padding-left:14px;
}

.operatorArea .Intervalcar_add{
	clear:both; padding-left:14px;
	height:auto;
	min-height:32px;
}


.operatorArea .oper_add_img{
	cursor:pointer; margin-top:4px;
}

.operatorArea .singleUser{
	float:left; width:56px; text-align:center; font-size:12px;
}
.operatorArea .userHead{
	width:36px; height:36px; border-radius:18px; margin-top:4px; margin-bottom:2px; 
}
.operatorArea .userName{
	white-space:nowrap; text-overflow:ellipsis; overflow:hidden;
}

.operatorArea .userHead{
	width:36px; height:36px; border-radius:18px; margin-top:4px; margin-bottom:2px; 
}
.submitNodeId{
   height:42px; padding-left:14px;
}
.oper_title div{
    float:left;
    <% if(user.getLanguage() == 8){%>
    max-width:250px;
    line-height:16px;
    <%}%>
}

.relationTitle{
	height:32px; line-height:32px; padding-left:12px; font-size:16px; color:#333;
}
.singleRelation{
	height:52px; padding-left:14px;
    border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
}
.showInfo{
	float:left; padding-top:4px; padding-bottom:2px;
}
.showInfo .showInfo_top{
	height:24px; line-height:24px; font-size:14px; color:#3f3f3f;
}
.showInfo .showInfo_bottom{
	height:22px; line-height:22px; font-size:12px; color:#afafaf;
}
.checkMark{
	float:right; margin:12px 6px 4px 4px;
}
.btnArea{
	height:40px; width:100%; margin-top:16px;
}
.btnDiv{
	width:200px; margin-left:auto; margin-right:auto;
}
.operBtn{
	width:70px; height:30px; line-height:30px; text-align:center; float:left;
	border-radius:5px; margin-left:15px; margin-right:15px; cursor:pointer; font-size:14px; color:#ffffff;
}
.pageIntervaling{

}

.nodeArea{
	width:100%; font-size:16px; color:#333; padding-top:2px; height:50px;
}

.nodeArea .node_title{
	float:left; width:100px; 
    <% if(user.getLanguage() == 8){%>
	height:50px; line-height:16px; padding-left:12px; 
	padding-top:8px;
	<%}else{%>
    height:50px; line-height:50px; padding-left:12px; 
	<%}%>
}
.nodeArea .node_info{
	float:right; height:50px; line-height:50px;
	width:150px;
    text-overflow:ellipsis;
    white-space:nowrap;
    overflow:hidden;
    text-align:right;
}
.nodeArea .node_choose{
	float:right; padding:13px 12px 13px 12px; cursor:pointer;
}

.node_making{
	display:none; 
}

.node_showWin{
	background:#fffffb;
    border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
}


.node_showWin .chooseNodeId{
	height:63px; line-height:63px; font-size:16px; color:#323232;
	margin-left:25px;
}

.chooseNodeName{
    width:90%;
    text-overflow:ellipsis;
    white-space:nowrap;
    overflow:hidden;
    float:left;
}
.nodeMark{
	float:right; 
}
.nodeMark img{
    width:26px;
    margin-top:18px;
    margin-right:15px;
}

 .showWin_nodetitle{
	height:32px; line-height:32px; padding-left:12px; font-size:16px; color:#333;
}

.borderbottom1{
    border-bottom:1px solid #dee1e1;
}

.relationArea{
    border-bottom-left-radius:5px;
    border-bottom-right-radius:5px;
}
.splitLine{background:#c3c3c3; height:1px; margin-left:15px;}
.bgcolor1{background:#ffffff;}
.bgcolor2{background:#017bfd;}
.bgcolor3{background:#aebdc9;}
.tzCheckbox-div{
    margin-top:8px;
    margin-left:10px;
}
</style>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>

<div class="node_making">
<div class="pageMasking"></div>
<div class="showWin_masking">
	<%=SystemEnv.getHtmlLabelName(18913,user.getLanguage()) %>
</div>
<div class="showWinInter">
<div class="winHead">
		<div class="winHead_title">
			<%=SystemEnv.getHtmlLabelName(126519,user.getLanguage()) %>
		</div>
		<div class="winHead_close" onclick="javascript:donode_Cancel();">×</div>
	</div>
<div class="node_showWin">

                 <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
				 String nexttmpname = "";
				 String nexttmptype = "";
				 String nexttempnodeattr = "";
                 boolean hasnodeid=false; 
                 String nodeattribute = "0";
                 int count = 0;
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                     if(tmpid==nextnodeid){
					   nexttmpname = WFNodeMainManager.getNodename();
					   nexttmptype = WFNodeMainManager.getNodetype();
					   nexttempnodeattr=WFNodeMainManager.getNodeattribute();
					 }
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                    String tempnodeattr=WFNodeMainManager.getNodeattribute();
					
                    if(tmpid==nodeid) {
                        nodeattribute = tempnodeattr ;
                    }
                    if(tempnodeattr.equals("2")){//25428
                    	tmpname += "("+SystemEnv.getHtmlLabelName(21395,user.getLanguage())+")";
                    }
                    if(nodeattr.equals("2")){
                        if(!tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
								intervenoruseridsType = "";
                                intervenorusernames="";
                            }
                            //如果当前节点为分叉节点，则只显示分叉节点
                            continue;
                        }else if(BrancheNodes.indexOf(""+tmpid)==-1){
                            continue;
                        }
                    }else{
                        if(tempnodeattr.equals("2")){
                            if(tmpid==nextnodeid){
                                intervenoruserids="";
								intervenoruseridsType = "";
                                intervenorusernames="";
                            }
                            //如果当前节点为主干节点，则只显示主干节点
                            continue;
                        }
                    }
                    if(tmpname == null || tmpname == ""){
                        intervenoruserids="";
                        intervenoruseridsType = "";
                        intervenorusernames="";
                    }
                 %>
				 <%if(nextnodeid==tmpid){
					 hasnodeid=true;%>
				 <%}%>
				 
                 <%if(count > 0){ %>
                 <div class="splitLine"></div>
                 <%} %>
                 <div  class="chooseNodeId" id = "chooseNodeId" _value="<%=tmpid%>_<%=tmptype%>_<%=tempnodeattr%>" >
					<div class="chooseNodeName"><%=tmpname%></div>
					<div class="nodeMark"  id="<%=tmpid%>_<%=tmptype%>_<%=tempnodeattr%>" style='display:none'>
						<img src="/mobile/plugin/images/check_wev8.png"/>
					</div>
				 </div>
                 <%
                 count++;
                 }%>

				
                 <input type="hidden" id="currentnodeattr" name="currentnodeattr" value="<%=nodeattribute %>" />
                 <input type="hidden" id="tonodeattr" name="tonodeattr" value="0" />
                 <span id="submitNodeIdspan"><%if(!hasnodeid){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
		</div>
		</div>
</div>



	<div class="winContent">
		<div class="nodeArea borderbottom1 bgcolor1">
			<div class="node_title">
				<%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%>
			</div>
			<div class="node_choose">
				<img src="/mobile/plugin/images/chooseOperBtn_wev8.png" style="height:22px;"/>
			</div>
			<div class="node_info" onChange='nodechange()'>
				<span id="node_name"><%=nexttmpname%></span>
				<input type="hidden" id="nextnodeid" name="nextnodeid" value="<%=nextnodeid%>_<%=nexttmptype%>_<%=nexttempnodeattr%>" />
			</div>	
		
		</div>
		<div class="operatorArea borderbottom1 bgcolor1">
		<div class="oper_title">
		    <div><%=SystemEnv.getHtmlLabelName(32598,user.getLanguage())%></div>
		    <div class="tzCheckbox-div"><INPUT class="inputstyle" type="checkbox" tzCheckbox="true" checked name="enableIntervenor" id="enableIntervenor"   onclick="CheckClick()" >
		    </div>
		</div>
		<div class="Intervalcar_add">
			<!--select class=inputstyle  id="enableIntervenor" name=enableIntervenor>
                 <option value="0" ><%=SystemEnv.getHtmlLabelName(25105,user.getLanguage())%></option>
                 <option value="1" selected="selected"><%=SystemEnv.getHtmlLabelName(25104,user.getLanguage())%></option>
             </select-->
			 
			 
             <span style="color: #ccc"><%=SystemEnv.getHtmlLabelName(31483,user.getLanguage())%></span>
		</div>
		</div>
		<div class="operatorArea borderbottom1 bgcolor1">
			<div style="height:32px;">
				<div class="operation_title">
					<%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%>
				</div>
				<div class="oper_choose">
					<img src="/mobile/plugin/images/chooseOperBtn_wev8.png" style="height:22px;"/>
				</div>
				<div class="oper_info">
					<span id="operatorsNum">0</span><%-- 人 --%><%=SystemEnv.getHtmlLabelName(84097,user.getLanguage())%>
				</div>
			</div>
			<div class="oper_add">
				<img class="oper_add_img" src="/mobile/plugin/images/addOperator_wev8.png"/>
			</div>
			<div class="oper_show"></div>
		</div>
		<div class="relationTitle borderbottom1">
			<%=SystemEnv.getHtmlLabelName(21790, user.getLanguage()) %>
		</div>
		<div class="relationArea bgcolor1">
			<%for(int i=0; i<3; i++){ %>
				<div class="singleRelation" target="<%=i %>">
					<div class="showInfo">
						<div class="showInfo_top">
							<%=SystemEnv.getHtmlLabelNames(relationArr[i], user.getLanguage()) %>
						</div>
						<div class="showInfo_bottom">
							<%=SystemEnv.getHtmlLabelNames(relationArr[i+3], user.getLanguage()) %>
						</div>
					</div>
					<div class="checkMark" style="<%=i!=0?"display:none":"" %>">
						<img src="/mobile/plugin/images/check_wev8.png" style="width:28px;" />
					</div>
				</div>
				<%if(i<2){ %>
				<div class="splitLine"></div>
				<%} %>
			<%} %>
		</div>
		<!--<div class="relationTitle borderbottom1">
		</div>
		<div class="remarkDiv">
                                	<textarea name=Intervenorremark id="Intervenorremark" style="width:100%;height:40px;margin:0;resize: none;color:#a2a2a2;overflow: hidden;color:#c7c7c7;" temptitle="<%=SystemEnv.getHtmlLabelName(17614, user.getLanguage())%>" ></textarea>
                           		</div>

		<div class="btnArea">
			<div class="btnDiv">
				<div id="doIntervenor" name="doIntervenor" class="operBtn bgcolor2" onclick="javascript:doConfirm();"><%="提交干预"%></div>
				<div class="operBtn bgcolor3" onclick="javascript:doCancel();">
					<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>
				</div>
			</div>
		</div>	-->
	</div>
    <div style="height:10px;overflow:hidden;"></div>


<script type="text/javascript">
	var maxOperNum = 0;		//显示头像最大个数
	jQuery(document).ready(function(){
		//nodechange(jQuery("#submitNodeId").attr('_value'));
			var _value = jQuery("#nextnodeid").val();
			jQuery("#"+_value).show();
		if(jQuery("#fromPage").val() == "client.jsp"){
			try{
				//controlBottomOperArea("hidden");
			}catch(e){}
		}
		//jQuery("#view_page").css("height", "100%").css("overflow","hidden");
		//jQuery(".showWin").css("top", (jQuery(".pageMasking").height()-jQuery(".showWin").height())/2);
		//jQuery(".showWinInter").css("left", (jQuery(".pageMasking").width()-jQuery(".showWinInter").width())/2);
		//jQuery(".showWin").css("left", (jQuery(".pageMasking").width()-jQuery(".showWin").width())/2);
		//生成提交隐藏域
		jQuery("form#workflowfrm").append('<input type="hidden" id="SignType" name="SignType" value="0" />');
		jQuery("form#workflowfrm").append('<input type="hidden" id="Intervenorid" name="Intervenorid" onchange="operatorChange();" />');
		jQuery("form#workflowfrm").append('<input type="hidden" id="IntervenoridType" name="IntervenoridType" value="<%=creatertype %>"/>');
		jQuery("form#workflowfrm").append('<input type="hidden" id="currentnodeattr" name="currentnodeattr" value="<%=nodeattribute %>"/>');
		jQuery("form#workflowfrm").append('<input type="hidden"  id="tonodeattr" name="tonodeattr" />');
		jQuery("form#workflowfrm").append('<input type="hidden"  id="submitNodeId" name="submitNodeId" />')
		jQuery("form#workflowfrm").append('<input type="hidden"  id="enableIntervenor" value="1" name="enableIntervenor" />')
		jQuery("form#workflowfrm").append('<input type="hidden"  id="Intervenorremark" name="Intervenorremark" />')
		//事件绑定
		
		jQuery(".singleRelation").click(function(){
			jQuery(".checkMark").hide();
			jQuery(this).find(".checkMark").show();
			jQuery("input#SignType").val(jQuery(this).attr("target"));
		});
		
		jQuery(".remarkDiv").change(function(){
			
			jQuery("input#Intervenorremark").val(jQuery(this).find("textarea").val());
		});
		///alert("-----490---"+jQuery("input#nextnodeid").val());
		jQuery("input#submitNodeId").val(jQuery("input#nextnodeid").val());

		jQuery(".chooseNodeId").click(function(){
			jQuery(".nodeMark").hide();
			//alert("nodeMark--222->>>"+jQuery(this).next(".nodeMark"));
			jQuery(this).find(".nodeMark").show();
			//alert("vaule--->>>"+jQuery(this).attr('_value'));
			//alert("vaule--222->>>"+jQuery(this).text());
			
			jQuery("input#submitNodeId").val(jQuery(this).attr('_value'));
			jQuery("span#node_name").html(jQuery(this).text());
			jQuery(".node_making").hide();
			nodechange(jQuery(this).attr('_value'));
			
		});

		/*jQuery("#submitNodeId").change(function(){
			nodechange(jQuery("#submitNodeId").val());
		});	*/															
		
		
			
        // 初始化的时候，执行一次change方法
		jQuery(".remarkDiv").change();
		jQuery(".nodeinfo").change();
		//jQuery(".chooseNodeId").click();


		nodechange(jQuery("#submitNodeId").val());

		jQuery(".oper_choose").parent().add(".oper_add_img").click(function(){
			chooseOperators();
		});
		jQuery(".node_choose").parent().click(function(){
		
			//jQuery(".nodeMark").hide();
			
			shownodeInternor();
			jQuery(".showWinInter").css("left", (jQuery(".pageMasking").width()-jQuery(".showWinInter").width())/2);

		});
		
		//计算最大显示人员头像个数
		var oper_showWidth = parseFloat(jQuery(".operatorArea").width())-10;
		maxOperNum = Math.floor(oper_showWidth/56);
		
		//客户端触屏效果
		jQuery(".singleRelation").each(function(){
			var obj = jQuery(this)[0];
			/*obj.addEventListener("touchstart",function(event){
				jQuery(this).css("background","#d7eeea");
			});
			obj.addEventListener("touchend",function(event){
				jQuery(this).css("background","#ffffff");
			});*/
		});
		var oper_show =jQuery(".oper_show")[0];
		/*obj.oper_show.addEventListener("touchstart",function(event){
			jQuery(".operatorArea").css("background","#d7eeea");
		},false);
		oper_show.addEventListener("touchend",function(event){
			jQuery(".operatorArea").css("background","#ffffff");
			chooseOperators();
		},false);*/
		jQuery(".inputstyle").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   jQuery(this).tzCheckbox({labels:['','']});
		  }
		 });
		 jQuery(".winContent").width(jQuery(".winContent").width() + 2);
		 jQuery(".winContentTitleHead").width(jQuery(".winContent").width());
	});

	function donode_Cancel(){
		jQuery(".node_making").hide();
	}
	
	function chooseOperators(){
		showDialog("/browser/dialog.do","&returnIdField=Intervenorid&returnShowField=Intervenorid_span&method=listUser&isMuti=1");
	}

	function shownodeInternor(){
		   jQuery(".node_making").show();
           jQuery(".chooseNodeName").each(function(){
               $(this).width($(this).parent().width()-46);
           });
	
	}
	
	function operatorChange(){
		try{
			var Intervenorid = jQuery("input#Intervenorid").val();
			var ajaxUrl = "/mobile/plugin/1/workflowAjaxUrl.jsp?&operator="+Intervenorid+"&random="+new Date().getTime();
			jQuery.ajax({
				type: "post",
				url: ajaxUrl,
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				success: function(data){
					jQuery(".oper_show").html("");
					jQuery("#operatorsNum").text("0");
					data = data.trim();
					if(!!data && data !== "[]"){
						jQuery(".oper_add").hide();
						jQuery(".oper_show").show();
						
						var operJson = JSON.parse(data);
						var hasOperNum = operJson.length;
						jQuery("#operatorsNum").text(hasOperNum);
						for(var i=0; i<hasOperNum; i++){
							if(i >= maxOperNum)
								break;
							var operObj = operJson[i];
							var headUrl = !!operObj.messagerurl? operObj.messagerurl : "/messager/images/icon_w_wev8.jpg";
							var singleUser = jQuery("<div class='singleUser'><img class='userHead' src='"+headUrl+"' /><div class='userName'>"+operObj.operatname+"</div></div>");
							jQuery(".oper_show").append(singleUser);
						}
					}else{
						jQuery(".oper_add").show();
						jQuery(".oper_show").hide();
					}
				}
			});
		}catch(e){}
	}
	
	function doConfirm(){
		var Intervenorid = jQuery("#Intervenorid").val();
		if(Intervenorid == null || Intervenorid == ""){
			alert("<%=SystemEnv.getHtmlLabelName(125403,user.getLanguage()) %>");
			return;
		}
		jQuery("input#eh_setoperator").val("y");
		jQuery("#userSignRemark").val(jQuery("#Intervenorremark").val());
		dosubmit_chooseOperator();
	}
	
	function doCancel(){
		//jQuery("input#eh_setoperator").val("n");
		//window.close();
	//	dosubmit_chooseOperator();
	 jQuery(".node_making").hide();
	}
	
	//模拟流程提交
	function dosubmit_chooseOperator(){
		//alert("---#submitNodeId-"+jQuery("#submitNodeId").val());
		showWinMarking();
		//dosubback();
		doIntervenor();
	}
	
	//遮罩并loading效果
	function showWinMarking(){
		var maskDiv = jQuery(".showWin_masking");
		var showWin = jQuery(".showWin");
		maskDiv.css("height", showWin.css("height")).css("line-height", showWin.css("height"))
			.css("top", showWin.css("top")).css("left", showWin.css("left"));
		maskDiv.show();
	}
	
	//客户端隐藏下方按钮及签字意见栏
	function controlBottomOperArea(par){
		var url = "emobile:controlBottomOperArea:"+par;			
    	location = url;
	}
	
	function nodechange(value){
		//alert("----node-value--"+value);
	if(value==""){
       
    }else{
        var nodeids=value.split("_");
        var selnodeid=nodeids[0];
        var selnodetype=nodeids[1];
		var tonodeattr = nodeids[2];
		
        jQuery("#tonodeattr").val(tonodeattr); 
		//alert("---611->>"+jQuery("#tonodeattr").val());
       
	      try{
			
			var ajaxUrl = "/mobile/plugin/1/monitor/WorkflowNextOperator.jsp?userid=<%=userid%>&usertype=<%=usertype%>&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&intervenorright=<%=intervenorright%>&workflowid=<%=workflowid%>&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype+"&random="+new Date().getTime();
			jQuery.ajax({
				type: "get",
				url: ajaxUrl,
				dataType : "text",
				contentType : "application/x-www-form-urlencoded; charset=UTF-8",
				success: function(data){
				
					jQuery(".oper_show").html("");
					jQuery("#operatorsNum").text("0");
					data = data.trim();
					if(!!data && data !== "[]" && jQuery("#node_name").html()!= ""){
					jQuery(".oper_add").hide();
						jQuery(".oper_show").show();
						
						var operJson = JSON.parse(data);
						var hasOperNum = operJson.length;
						var interOpernor = "";
						//alert("----hasOperNum---"+hasOperNum);
						jQuery("#operatorsNum").text(hasOperNum);
						for(var i=0; i<hasOperNum; i++){
							//if(i >= maxOperNum)
							//	break;
							var operObj = operJson[i];
							
							//初始化将人员赋值到hidden域
							if(interOpernor==""){
							  interOpernor = operObj.id;
							}else{
								interOpernor += ","+operObj.id;
							}
							//alert("--interOpernor---"+interOpernor);
							var headUrl = !!operObj.messagerurl? operObj.messagerurl : "/messager/images/icon_w_wev8.jpg";
							var singleUser = jQuery("<div class='singleUser'><img class='userHead' src='"+headUrl+"' /><div class='userName'>"+operObj.operatname+"</div></div>");
							if(i >= maxOperNum) singleUser.css("display","none");
							jQuery(".oper_show").append(singleUser);
							
						}
						//初始化将人员赋值到hidden域
						jQuery("input#Intervenorid").val(interOpernor);
					}else{
						jQuery(".oper_add").show();
						jQuery(".oper_show").hide();
					}
				}
			});
		}catch(e){}	
      //  }
			
        $G("submitNodeIdspan").innerHTML="";
    }
}

function CheckClick(){
   var check = jQuery("#enableIntervenor").is(':checked');
   if(check){
   	 jQuery("input#enableIntervenor").val("1");
   }else{
   	  jQuery("input#enableIntervenor").val("0");
   }
}
</script>