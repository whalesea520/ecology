
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.Prop,weaver.workflow.request.WFLinkInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestRejectManager" class="weaver.workflow.request.RequestRejectManager" scope="page" />
<jsp:useBean id="wfli" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<%
    int requestid=Util.getIntValue(Util.null2String(request.getParameter("requestid")),0);
	int workflowid=Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
    int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
    int isrejectremind=Util.getIntValue(Util.null2String(request.getParameter("isrejectremind")),0);
    int ischangrejectnode=Util.getIntValue(Util.null2String(request.getParameter("ischangrejectnode")),0);
    int isselectrejectnode=Util.getIntValue(Util.null2String(request.getParameter("isselectrejectnode")),0);
    //读取配置退回节点选择配置文件
    String isEnableRejectNodeSelect = Prop.getPropValue("workflowreturnnode","WORKFLOWRETURNNODE");
    //System.err.println("isEnableRejectNodeSelect:"+isEnableRejectNodeSelect);
    ArrayList[] nodelist;
    ArrayList nodeids=new ArrayList();
    ArrayList nodenames=new ArrayList();
	/*
    String sql="select a.nodeid,b.nodename from workflow_currentoperator a,workflow_nodebase b where a.nodeid=b.id and a.requestid="+requestid+" order by a.id";
    RecordSet.executeSql(sql);
    while(RecordSet.next()){
        if(nodeids.indexOf(Util.null2String(RecordSet.getString("nodeid")))<0){
            nodeids.add(Util.null2String(RecordSet.getString("nodeid")));
            nodenames.add(Util.null2String(RecordSet.getString("nodename")));
        }
    }*/ 
	//根据requestid和userid查询到当前的节点id!不知道为什么nodeid不准确,....可能是以前的bug,...不动以前的东西.
	int realnodeid = -1; 
    int usrcount = 0 ;
    String sql3 = "SELECT  nodeid FROM workflow_currentoperator WHERE  userid = "+user.getUID()+" and isremark=0 AND requestid = "+requestid;
	RecordSet.executeSql(sql3);
	usrcount = RecordSet.getCounts() ;
    String sql2 = "SELECT  nodeid FROM workflow_currentoperator WHERE  userid = "+user.getUID()+" and islasttimes=1  AND requestid = "+requestid;
	RecordSet.executeSql(sql2);
	while(RecordSet.next()){ 
		realnodeid =Util.getIntValue(RecordSet.getString("nodeid"));
	}
	int _nodeid = Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"nodeid"),0);
	if(_nodeid!=realnodeid&&usrcount>1){
		realnodeid = _nodeid ;
	}
	String ss = "SELECT  nb.id , nb.nodename,nb.nodeattribute FROM workflow_nodelink nl , workflow_nodebase nb WHERE wfrequestid IS NULL AND NOT EXISTS ( SELECT 1 FROM workflow_nodebase b WHERE nl.destnodeid = b.id AND b.IsFreeNode = '1' ) AND nl.destnodeid = nb.id AND nl.nodeid = "+realnodeid+" AND nl.workflowid = "+workflowid+" AND nl.isreject = 1 ORDER BY nodeid , nl.id ";
	
	String nodeattribute = "0";
	RecordSet.executeSql("select nodeattribute from workflow_nodebase where id="+nodeid);
	if(RecordSet.next()){
		nodeattribute = RecordSet.getString(1);
	}
%>
<html>
<head>

</head>

<BODY style="overflow: hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84508,user.getLanguage())%>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onsave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:parent.window.close(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content" style="overflow:auto;height:290px"> 
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="" method=post>
<input id="isfork" name="isfork" value="0" type="hidden" />
<wea:layout type="2col">
  <% 
  if(isselectrejectnode>=1&&isEnableRejectNodeSelect.equals("1")){  
	 nodelist=RequestRejectManager.getPathWayNodes(workflowid,requestid,realnodeid); 
	 int defaultnodeid=RequestRejectManager.getDefaultRejectNode(requestid,realnodeid);
	 ArrayList rejectnodeids = new ArrayList() ;
	 ArrayList rejectnodenames = new ArrayList() ;
	 ArrayList rejectnodeattrs = new ArrayList() ;
	 if(nodelist==null||nodelist.length<3){
		//do nothing
	 }else{
		rejectnodeids=nodelist[0];
		rejectnodenames=nodelist[1];
		rejectnodeattrs = nodelist[2];	 
	 }
	 
	 
	 ArrayList rejectableNodeList = new ArrayList();
	 ArrayList BrancheNodes = new ArrayList();
	 if(2 == isselectrejectnode) {
		 RecordSet.executeSql("select * from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + realnodeid);
		 if(RecordSet.next()) {
			 rejectableNodeList = Util.TokenizerString(Util.null2String(RecordSet.getString("rejectableNodes")), ",");
		 }
	 }
	 if(nodeattribute.equals("2")){
		 BrancheNodes  = wfli.getFlowBrancheNodes(requestid,workflowid,nodeid);
	 }
  %>
	  <wea:group context='<%=SystemEnv.getHtmlLabelName(26437,user.getLanguage())%>'>
	     <wea:item attributes="{'isTableList':'true'}">
	        <table class="ListStyle" id="oTable" cellspacing=0>
	            <COLGROUP>
					<COL width="30%">
					<COL width="70%">
				</COLGROUP>
				<tr class=header>
					<td><%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%></td>
					<td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
				</tr>
				<%
				int colorcount=0;  
				RecordSet.executeSql(ss); 
				//添加默认的节点.
				while(RecordSet.next()){ 
					if(!rejectnodeids.contains(RecordSet.getInt("id")+"")){
						rejectnodeids.add(RecordSet.getInt("id")+"");
						rejectnodenames.add(RecordSet.getString("nodename"));
						rejectnodeattrs.add(RecordSet.getString("nodeattribute"));
					}
				} 
				//删除当前节点.
				int indexid=rejectnodeids.indexOf(realnodeid+"");
				if(indexid>-1){
					rejectnodeids.remove(indexid);
					rejectnodenames.remove(indexid);
					rejectnodeattrs.remove(indexid);
				}
				//下面是已经走过的节点.
				for(int i=0;i<rejectnodeids.size();i++){
					String nodeattr = rejectnodeattrs.get(i).toString();
					String rejectnodename = rejectnodenames.get(i).toString();
					boolean ischeck = false ;
					if(defaultnodeid>0){
						ischeck = defaultnodeid==Util.getIntValue((String)rejectnodeids.get(i));
					}else{
						ischeck = true ;
					}
					if(2 == isselectrejectnode && rejectableNodeList.size() > 0) {
						if(!rejectableNodeList.contains((String) rejectnodeids.get(i))) {
							continue;
						}
					}
					if(!BrancheNodes.contains((String)rejectnodeids.get(i))&&nodeattr.equals("2")){
						continue ;
					}
					if(colorcount==0){
						colorcount=1;
				%>
						<TR class=DataLight>
				<%
					}else{
						colorcount=0;
				%>
						<TR class=DataDark>
				<%
					}
				%>
							<td>
								<input type="radio" name="rejectnodeid" onclick="checkIfSingle(this,0)" onchange="checkIfSingle(this,0)" value="<%=rejectnodeids.get(i)%>" <%if(ischeck){%>checked<%}%>>
							</td>
							<td><%=rejectnodename %></td>
						</tr>
				  <%
				    String __rejectnodeids = rejectnodeids.get(i).toString();
				  	boolean isreqnode = isRequestNode(__rejectnodeids,nodeattr,requestid+"",workflowid+"",wfli);
				    if(!nodeattribute.equals("2")){//分叉中间节点不能重走分叉和取消合并
						if(nodeattr.equals("1")&&isreqnode){//分叉起始 重新分叉
							if(colorcount==0){
								colorcount=1;
						%>
								<TR class=DataLight>
						<%
							}else{
								colorcount=0;
						%>
								<TR class=DataDark>
						<%
							}
						%>
									<td>
										<input type="radio" name="rejectnodeid" onclick="checkIfSingle(this,1)" onchange="checkIfSingle(this,1)" value="<%=rejectnodeids.get(i)%>" >
									</td>
									<td><%=rejectnodename %>(<%=SystemEnv.getHtmlLabelName(126842,user.getLanguage())%>)<SPAN class=".e8tips" style="CURSOR: hand" id="remind_<%=rejectnodeids.get(i)%>" title="<%=SystemEnv.getHtmlLabelName(126503,user.getLanguage()) %>"><IMG id=ext-gen124 align=absMiddle src="/images/remind_wev8.png"></SPAN></td>
								</tr>
						<%		
						}
						if((nodeattr.equals("3")||nodeattr.equals("4")||nodeattr.equals("5"))&&isreqnode){
							if(colorcount==0){
								colorcount=1;
						%>
								<TR class=DataLight>
						<%
							}else{
								colorcount=0;
						%>
								<TR class=DataDark>
						<%
							}
						%>
									<td>
										<input type="radio" name="rejectnodeid" onclick="checkIfSingle(this,2)" onchange="checkIfSingle(this,2)" value="<%=rejectnodeids.get(i)%>" >
									</td>
									<td><%=rejectnodename %>(<%=SystemEnv.getHtmlLabelName(126456,user.getLanguage())%>)<SPAN class=".e8tips" style="CURSOR: hand" id="remind_<%=rejectnodeids.get(i)%>" title="<%=SystemEnv.getHtmlLabelName(126504,user.getLanguage()) %>"><IMG id=ext-gen124 align=absMiddle src="/images/remind_wev8.png"></SPAN></td>
								</tr>
						<%	
						}
				    }//end if nodeattribute == 2
				}   
				%>
	        </table>
	     </wea:item>
	  </wea:group>
  <%}%>
  <%
  if(isrejectremind==1&&ischangrejectnode==1){
	 nodelist=RequestRejectManager.getProcessNodes(requestid);
	 nodeids=nodelist[0];
	 nodenames=nodelist[1];
  %>
  <wea:group context='<%=SystemEnv.getHtmlLabelName(26438,user.getLanguage())%>'>
	  <wea:item attributes="{'isTableList':'true'}">
	      <table class="ListStyle" id="oTable" cellspacing=0 style="overflow: scroll;">
	            <COLGROUP>
					<COL width="30%">
					<COL width="70%">
				</COLGROUP>
				<tr class=header>
		            <td><input id="checkall" onclick="javascript:changstatus(this);" type="checkbox"><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></td>
		            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
				</tr>
				<%
				    int colorcount=0;
				    for(int i=0;i<nodeids.size();i++){
				        if(colorcount==0){
						colorcount=1;
				%>
						<TR class=DataLight>
				<%
						}else{
							colorcount=0;
				%>
						<TR class=DataDark>
				<%
						}
				%>
				 		<td>
					        <input type="checkbox" accesskey="nodeitem" name="nodeid_<%=nodeids.get(i)%>" value="<%=nodeids.get(i)%>" onclick="clearcheckall()">
					    </td>
					    <td>
					        <%=nodenames.get(i)%>
					    </td>
					</tr>
				<%
				}
				%>
		  </table>
	  </wea:item>
  </wea:group>
  <%}%>
</wea:layout>
</FORM>
</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%="O-"
					+ SystemEnv.getHtmlLabelName(826, user.getLanguage())%>"
								id="zd_btn_submit_0" class="zd_btn_submit" onclick="onsave();">
				<input type="button" accessKey=T id=btncancel
								value="<%="T-"
					+ SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
								id="zd_btn_cancle" class="zd_btn_cancle" onclick="btnclose_onclick();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>
<script language=javascript>
var parentWin = null;
var dialog = null;
try{
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
}catch(e){
}
function callback(returnjson){
	if(dialog){
		try{
			dialog.callback(returnjson);
		}catch(e){
		}
		dialog.close(returnjson);
	}else{ 
	   	window.parent.returnValue  = returnjson;
	   	window.parent.close();
	}
}
// 关闭
function btnclose_onclick(){
    if(dialog){
        try{
		dialog.close();
		}catch(e){
		}
	}else{
	    window.parent.close();
	}
}
//保存
function onsave(){
   	  var nodeids="";
    <%if(isrejectremind==1&&ischangrejectnode==1){%>
    if($G("checkall").checked){ 
		 nodeids="-1";
    }else{ 
        <%
        for(int j=0;j<nodeids.size();j++){
        %>
        if($G("nodeid_<%=nodeids.get(j)%>").checked){
            if(nodeids.length>0){
                nodeids+=","+$G("nodeid_<%=nodeids.get(j)%>").value;
            }else{
                nodeids=$G("nodeid_<%=nodeids.get(j)%>").value;
            }
        }
        <%}%>
        //alert(nodeids);
           }
    <%}%>
    var rejectnodeid="";
    <%if(isselectrejectnode>=1){%>
    rejectnodeid=getRadioValue("rejectnodeid");
    if(rejectnodeid==""){
        alert("<%=SystemEnv.getHtmlLabelName(26436,user.getLanguage())%>");
        return false;
    }
    <%}%>
    var nodeattr = jQuery("#isfork").val();
    var returnjson = {id:"reject",name:nodeids+"|"+rejectnodeid+"|"+nodeattr}
    callback(returnjson);
}


function changstatus(obj){
       if(jQuery(obj).is(":checked")){
	       jQuery("input[accesskey='nodeitem']").each(function(){
	        	changeCheckboxStatus($(this),true);
		   });
       }else{
	       jQuery("input[accesskey='nodeitem']").each(function(){
	        	changeCheckboxStatus($(this),false);
		   });
       }
}

function clearcheckall(){
     if($G("checkall").checked){
          changeCheckboxStatus($("#checkall"),false);
     }
}

jQuery(function(){
	jQuery("span[id^=remind]").wTooltip({html:true});
	changeCheckboxStatus(jQuery("#checkall"),true);
	changstatus(jQuery("#checkall"));
});

function getRadioValue(name){
	if(document.getElementsByName(name)){
	var radioes = document.getElementsByName(name);
		for(var i=0;i<radioes.length;i++){
		     if(radioes[i].checked){
		      return radioes[i].value;
		     }
		}
	}
return "";
}
jQuery(".zDialog_div_content").niceScroll();

function checkIfSingle(obj,flag){
	if(jQuery(obj).is(":checked")){
		jQuery(obj).next(".jNiceRadio").addClass("jNiceChecked");
	}
	if(flag==null||flag==''||flag==undefined){
		flag = "0";
	}
	jQuery("#isfork").val(flag);
}
</script>
<%!
public boolean isRequestNode(String nodeid,String nodeattr,String requestid,String workflowid,WFLinkInfo wfli){
	boolean isreqnode = false ;//是否在请求中流转过
	RecordSet rs = new RecordSet();
	if(nodeattr.equals("1")){
		rs.executeSql("select nodeid from workflow_currentoperator where requestid="+requestid+" and nodeid="+nodeid);
		if(rs.next()){
			isreqnode = true ;
		}
	}else if(nodeattr.equals("3")||nodeattr.equals("4")||nodeattr.equals("5")){
		int startnodeid = wfli.getStartNodeidByEndNodeid(Util.getIntValue(workflowid), Util.getIntValue(nodeid)) ;
		rs.executeSql("select nodeid from workflow_currentoperator where requestid="+requestid+" and nodeid="+startnodeid);
		if(rs.next()){
			isreqnode = true ;
		}
	}else{
		
	}
	return isreqnode ;
}
%>