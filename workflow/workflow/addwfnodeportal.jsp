<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="FormComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="BillComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="FormFieldMainManager" class="weaver.workflow.form.FormFieldMainManager" scope="page" />
<%FormFieldMainManager.resetParameter();%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<%WFNodeMainManager.resetParameter();%>
<jsp:useBean id="WFNodeFieldMainManager" class="weaver.workflow.workflow.WFNodeFieldMainManager" scope="page" />
<%WFNodeFieldMainManager.resetParameter();%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<%
    String ajax=Util.null2String(request.getParameter("ajax"));
	int wfid=0;
	wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<%WFNodePortalMainManager.resetParameter();%>
<html>
<%

 String[] sessionnames =  request.getSession(true).getValueNames();
 for(int i=0;i<sessionnames.length;i++){
 	String tmpname = sessionnames[i];
 	if(tmpname.indexOf("con")!=-1)
		if(tmpname.indexOf("_const_cas_assertion_")==-1){//解决CAS集成后出口信息保存不了的问题
 		request.getSession(true).removeValue(tmpname);
		}
 }
 String splitstr = ""+Util.getSeparator();

	String wfname="";
	String wfdes="";
	String title="";
	String isbill = "";
	String iscust = "";
	String isFree = "";
	
	int formid=0;
	title="edit";
	WFManager.setWfid(wfid);
	WFManager.getWfInfo();
	wfname=WFManager.getWfname();
	wfdes=WFManager.getWfdes();
	formid = WFManager.getFormid();
	isbill = WFManager.getIsBill();
	iscust = WFManager.getIsCust();
	isFree = WFManager.getIsFree();
	int typeid = 0;
	typeid = WFManager.getTypeid();
	int rowsum=0;
	int maxrow = 0;
	ArrayList nodeids = new ArrayList();
	ArrayList nodenames = new ArrayList();
	ArrayList nodetypes = new ArrayList();
    ArrayList nodeattrs = new ArrayList();
    nodeids.clear();
	nodenames.clear();
	nodetypes.clear();
    nodeattrs.clear();;
    //add by wjy :提取相关工作流的所有有规则的节点

    String sql2 = "select objid from workflow_addinoperate where workflowid = "+wfid+" and isnode=0";
    String hasRolesIds = "";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("objid");
    }
	
	//zzl默认显示绿色钩子，表示有节点后操作

    sql2 = "select nodelinkid from int_BrowserbaseInfo where w_fid = "+wfid+" and nodelinkid <>0 and w_enable=1";
    RecordSet.executeSql(sql2);
    while(RecordSet.next()){
        hasRolesIds += ","+RecordSet.getString("nodelinkid");
    }
    //zzl-end
    
	
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    if(detachable==1){  
        //如果开启分权，管理员
        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId2")),-1);
        if(user.getUID() == 1){
            operatelevel = 2;
        }else{
            String subCompanyIds = manageDetachComInfo.getDetachableSubcompanyIds(user);
            if (subCompanyId == 0 || subCompanyId == -1 ) {
                if (subCompanyIds != null && !"".equals(subCompanyIds)) {
                    String [] subCompanyIdArray = subCompanyIds.split(",");
                    for (int i=0; i<subCompanyIdArray.length; i++) {
                        subCompanyId = Util.getIntValue(subCompanyIdArray[i]);
                        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
                        if (operatelevel > 0) {
                            break;
                        }
                    }
                }
            } else {
                operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId);
            }            
        }

    }else{
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
            operatelevel=2;
        }else{
            operatelevel=1;
        }
    }
    
    if(operatelevel < 1 && haspermission){
        operatelevel = 1;
    }
    int subCompanyId2 = WFManager.getSubCompanyId2();
	if(subCompanyId2 != -1 && subCompanyId2 != 0 && detachable == 1){
	    if(!haspermission){
	        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkflowManage:All",subCompanyId2);    
	    }
	}
    boolean showwayoutinfo=GCONST.getWorkflowWayOut();
%>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(259,user.getLanguage());
String needfav ="";
String needhelp ="";
%>
</head>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
    if(!ajax.equals("1"))
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
    else
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:portsave(this),_self} " ;
		RCMenuHeight += RCMenuHeightStep;

    if(!ajax.equals("1")) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",addwf.jsp?src=editwf&wfid="+wfid+",_self} " ;
		RCMenuHeight += RCMenuHeightStep;
    }

    if(!ajax.equals("1")){
		if(RecordSet.getDBType().equals("db2")){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where int(operateitem)=88 and relatedid="+wfid)+",_self} " ;   
		}else{
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere="+xssUtil.put("where operateitem=88 and relatedid="+wfid)+",_self} " ;
		}
		RCMenuHeight += RCMenuHeightStep ;
    }
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="portform" name="portform" method=post action="wf_operation.jsp" >
<%
if(ajax.equals("1")){
%>
<input type="hidden" name="ajax" value="1">
<%}%>

<%
	    String nodeidattr4="";
%>
<wea:layout type="2col">
	<%if(!ajax.equals("1")){%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(2079,user.getLanguage())%></wea:item>
		<wea:item><%=wfname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15433,user.getLanguage())%></wea:item>
		<wea:item><%=WorkTypeComInfo.getWorkTypename(""+typeid)%></wea:item>
		<%if(isPortalOK){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15588,user.getLanguage())%></wea:item>	
		<wea:item>
			<%if(iscust.equals("0")){%><%=SystemEnv.getHtmlLabelName(15589,user.getLanguage())%><%}else{%><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%><%}%>
		</wea:item>
		<%}%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>		
		<wea:item>
    		<%if(isbill.equals("0")){%>
            	<%=FormComInfo.getFormname(""+formid)%>
            <%}
            else if(isbill.equals("1")){
            	int labelid = Util.getIntValue(BillComInfo.getBillLabel(""+formid));
            %>
            	<%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage())%>
            <%}else{%>
            	
            <%}%>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15594,user.getLanguage())%></wea:item>
		<wea:item><%=wfdes%></wea:item>
	</wea:group>
	<%}%>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
<%
	WFNodeMainManager.setWfid(wfid);
	WFNodeMainManager.selectWfNode();
    String nodeidstr="";
    String nodeattrstr="";
    String nodenamestr="";
    while(WFNodeMainManager.next()){
		nodeids.add(""+WFNodeMainManager.getNodeid());
		nodenames.add(WFNodeMainManager.getNodename());
		nodetypes.add(WFNodeMainManager.getNodetype());
        nodeattrs.add(WFNodeMainManager.getNodeattribute());
        if(nodeidstr.equals("")){
            nodeidstr=""+WFNodeMainManager.getNodeid();
            nodeattrstr=WFNodeMainManager.getNodeattribute();
            nodenamestr=WFNodeMainManager.getNodename();
        }else{
            nodeidstr+=","+WFNodeMainManager.getNodeid();
            nodeattrstr+=","+WFNodeMainManager.getNodeattribute();
            nodenamestr+=splitstr+""+WFNodeMainManager.getNodename();
        }
        if("4".equals(WFNodeMainManager.getNodeattribute())) nodeidattr4+=","+WFNodeMainManager.getNodeid();
    }
%>	
	<%
	//当流程不为自由流程时，显示添加和删除按钮等设置信息

	if( !isFree.equals("1")){
	%>
	<wea:item attributes="{'colspan':'full'}">
		<select class=inputstyle  name="curnode" style="width: 30%;float: left;">
			<option class=Inputstyle value="-1"><STRONG>************<%=SystemEnv.getHtmlLabelName(15602,user.getLanguage())%>**************</strong>
		<%
			for(int i=0;i<nodeids.size(); i++) {
			if("3".equals(nodetypes.get(i))) continue;
		%>
			<option value="<%=(String)nodeids.get(i)+"_"+(String)nodetypes.get(i)+"_"+nodeattrs.get(i)%>"><strong><%=(String)nodenames.get(i)%></strong>
		<%}%>
		</select>
		<%if(!ajax.equals("1")){%>
		&nbsp;&nbsp;
		<button Class=addbtn type=button accessKey=A onclick="addRow();" title="A-<%=SystemEnv.getHtmlLabelName(15607,user.getLanguage())%>"></button>
		<button Class=delbtn type=button accessKey=D onclick="if(isdel()){deleteRow1();}" title="D-<%=SystemEnv.getHtmlLabelName(15608,user.getLanguage())%>"></button>
		<%}else{%>
		&nbsp;&nbsp;
		<button Class=addbtn type=button accessKey=A onclick="addRow4port(<%=formid%>,<%=isbill%>,'<%=nodeidstr%>','<%=nodeattrstr%>','<%=nodenamestr%>','<%=nodeidattr4%>',<%=showwayoutinfo%>);" title="A-<%=SystemEnv.getHtmlLabelName(15607,user.getLanguage())%>"></button>
		<button Class=delbtn type=button accessKey=D onclick="if(isdel()){deleteRow4port();}" title="D-<%=SystemEnv.getHtmlLabelName(15608,user.getLanguage())%>"></button>
		<%}%>	
	</wea:item>
	<%	
	}
	%>

	<wea:item attributes="{'isTableList':'true'}">
		<%if(!ajax.equals("1")){%>
		<table class=ListStyle cellspacing=0   cols=6 id="oTable">
		<%}else{%>
		<table class=ListStyle cellspacing=0   cols=6 id="oTable4port">
		<%}%>
	      	<colgroup>
	    	<%if(showwayoutinfo){%>
		  	<col width="7%">
		  	<col width="13%">
		  	<%
			//当不为自由流程时，限制“是否退回”和“条件”设置

			if( !isFree.equals("1") ){
			%>
		  	<col width="10%">
		  	<col width="7%">
		  	<%
			}	
		  	%>
		  	<col width="9%">
		  	<col width="9%">
		  	<col width="12%">
		  	<col width="19%">
		    <col width="14%">
	    	<%}else{%>
		    <col width="5%">
		  	<col width="20%">
		  	<%
			//当不为自由流程时，限制“是否退回”和“条件”设置

			if( !isFree.equals("1") ){
			%>
		  	<col width="10%">
		  	<col width="7%">
		  	<%
			}	
		  	%>
		  	<col width="9%">
		  	<col width="9%">
		  	<col width="15%">
		  	<col width="25%">
	    	<%}%> 
	    	</colgroup>  
            <tr class="header notMove">
	            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(15070,user.getLanguage())%></td>
	            <%
				//当不为自由流程时，限制“是否退回”和“条件”设置

				if( !isFree.equals("1") ){
				%>
	            <td><%=SystemEnv.getHtmlLabelName(15609,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
	            <%
	        	}
	        	%>
	            <td><%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(20576,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%></td>
	            <td><%=SystemEnv.getHtmlLabelName(15074,user.getLanguage())%></td>
	            <%if(showwayoutinfo){%><td><%=SystemEnv.getHtmlLabelName(21642,user.getLanguage())%></td><%}%>   
			</tr>
			<tr class='Spacing' style="height:1px!important;"><td <%if(showwayoutinfo){%>colspan=9<%}else{ %>colspan=8<%} %> class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
			<%
			int colorcount=0;
			WFNodePortalMainManager.resetParameter();
			WFNodePortalMainManager.setWfid(wfid);
			WFNodePortalMainManager.selectWfNodePortal();
			while(WFNodePortalMainManager.next()){
				int tmpid = WFNodePortalMainManager.getId();
				int curid=WFNodePortalMainManager.getNodeid();
				int desid=WFNodePortalMainManager.getDestnodeid();
				int tmporder = WFNodePortalMainManager.getLinkorder();
				String isreject = WFNodePortalMainManager.getIsreject();
				String isBulidCode = WFNodePortalMainManager.getIsBulidCode();
				String ismustpass = WFNodePortalMainManager.getIsMustPass();
				String checktmp = "";
				String isBulidCodeCheck="";
				String ismustpasscheck="";
				String disabledWhenIsFree = "";
				//当为自由流程时，禁用相关控件
				if( isFree.equals("1") ){
					disabledWhenIsFree = "disabled";
				}
				if(ismustpass.equals("1")) ismustpasscheck=" checked";
				if(isreject.equals("1"))
					checktmp = " checked";
				if(isBulidCode.equals("1"))
					isBulidCodeCheck = " checked";
				int tmpindex = nodeids.indexOf(""+curid);
				if(tmpindex!=-1){
					String curtype = ""+nodetypes.get(tmpindex);
			        String curattr=""+nodeattrs.get(tmpindex);
			        tmpindex = nodeids.indexOf(""+desid);
			        String desattr="";
			        if(tmpindex!=-1) desattr=""+nodeattrs.get(tmpindex);
			if(colorcount==0){
					colorcount=1;
			%>
			<tr>
			<%}else{
					colorcount=0;
			%>
			<tr>
			<%}
			rowsum = tmpid;
			if(tmpid>maxrow){
				maxrow = tmpid;
			}
			%>
				<td height="23"><input type='checkbox' name='check_node'  value="<%=tmpid%>" >&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />
				<input type="hidden" name="por<%=rowsum%>_id" size=25 value="<%=tmpid%>">
				<input type="hidden" name="por_order_<%=rowsum%>" value="<%=tmporder %>">
				</td>
			    <td  height="23"><%=(String)nodenames.get(Util.getIntValue(""+nodeids.indexOf(""+curid)))%>
			    <input type="hidden" name="por<%=rowsum%>_nodeid" value="<%=curid%>">
			    </td>
			    <%
				//当不为自由流程时，限制“是否退回”和“条件”设置

				if( !isFree.equals("1") ){
				%>
				<td  height="23"><input type="checkbox" name="por<%=rowsum%>_rej" value="1" <%=checktmp%> <%if(!curtype.equals("1")){%> disabled <%}%>></td>

				<td  height="23">
			     <%if(!ajax.equals("1")){%>
			    <button type="button" class=Browser1 onclick="onShowBrowser(<%=tmpid%>,<%=rowsum%>)"></button>
			     <%}else{%>
			    <button type="button" class=Browser1 onclick="onShowBrowser4port(<%=tmpid%>,<%=rowsum%>,<%=formid%>,<%=isbill%>,<%=wfid %>,'<%=isreject %>','<%=curtype %>')"></button>
			     <%}%>
			    <input type="hidden" name="por<%=rowsum%>_con" value="<%=WFNodePortalMainManager.getCondition()%>">
			    <!-- add by xhheng @20050205 for TD 1537 -->
			    <input type="hidden" name="por<%=rowsum%>_con_cn" value="<%=WFNodePortalMainManager.getConditioncn()%>">
			    <%
			    //set value to session....
			    request.getSession(true).setAttribute("por"+rowsum+"_con",WFNodePortalMainManager.getCondition());
			    request.getSession(true).setAttribute("por"+rowsum+"_passtime",""+WFNodePortalMainManager.getPasstime());
			    //add by xhheng @20050205 for TD 1537
			    request.getSession(true).setAttribute("por"+rowsum+"_con_cn",WFNodePortalMainManager.getConditioncn());
			    //System.err.println("trueorfalse:" +((WFNodePortalMainManager.getNodepassHour()+WFNodePortalMainManager.getNodepassMinute())>0 || !WFNodePortalMainManager.getDateField().equals("") || (!WFNodePortalMainManager.getCondition().equals(""))));
			    %>
		        <span  name="por<%=rowsum%>_conspan" id="por<%=rowsum%>_conspan"><%if((WFNodePortalMainManager.getNodepassHour()+WFNodePortalMainManager.getNodepassMinute())>0 || !WFNodePortalMainManager.getDateField().equals("") || (!WFNodePortalMainManager.getCondition().equals("")) || (!"".equals(WFNodePortalMainManager.getNewrule()))){%><img src="/workflow/ruleDesign/images/ok_hover_wev8.png" border=0></img>
			    <%}%>
			    </span>
			    </td>

				<%	
				}
			    %>
			    <td  height="23">
				<button type="button" class=Browser1 onclick="onShowAddInBrowser(<%=tmpid%>)">
			    </button>
			    
			    <span id="ischeck<%=tmpid%>span1">
			 	<%if(hasRolesIds.indexOf(tmpid+"")!=-1){%>
			    	<img src="/images/ecology8/checkright_wev8.png" border="0">
			 	<%}%>
			    </span>
				</td>
			    <td  height="23"><input type="checkbox" name="por<%=rowsum%>_isBulidCode" value="1" <%=isBulidCodeCheck%> ></td>
			    <td  height="23"><input class=Inputstyle type="text" name="por<%=rowsum%>_link" value="<%=WFNodePortalMainManager.getLinkname()%>" onchange='checkinput("por<%=rowsum%>_link","por<%=rowsum%>_linkspan"),checkLength("por<%=rowsum%>_link","60","<%=SystemEnv.getHtmlLabelName(15611,user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>","<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>")'><SPAN id=por<%=rowsum%>_linkspan>
			    	<%
			    	if(WFNodePortalMainManager.getLinkname().equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></SPAN>
			    </td>
			    <td height="23">
			    	<%
			    	//当为自由流程时，禁用select后，此隐藏域用于传值

					if( isFree.equals("1") ){
					%>
					<input type="hidden" name="por<%=rowsum%>_des" value="<%=desid%>"/>
					<%	
					}
			    	%>
				    <select class=inputstyle  name="por<%=rowsum%>_des" onchange='checkSame("por<%=rowsum%>_nodeid",this,"<%=nodeidattr4%>","por<%=rowsum%>_ismustpass","por<%=rowsum%>_ismustpassspan")' <%=disabledWhenIsFree%>>
					<option value="-1"><STRONG><%=SystemEnv.getHtmlLabelName(15612,user.getLanguage())%></strong>
					<%  
						for(int i=0;i<nodeids.size(); i++) {
						    String tempattr=(String)nodeattrs.get(i);
							//if(curid == Util.getIntValue(""+nodeids.get(i))) continue;
							if(curattr.equals("1") && (tempattr.equals("3")||tempattr.equals("4"))) continue;
							if(curattr.equals("2") && (tempattr.equals("0")||tempattr.equals("1"))) continue;
							if((curattr.equals("0")||curattr.equals("3")||curattr.equals("4")) && tempattr.equals("2")) continue;
							String checkit = "";
							if(nodeids.get(i).equals(""+desid))
								checkit = "selected";
				
					%>
					<option value="<%=(String)nodeids.get(i)%>" <%=checkit%>><strong><%=(String)nodenames.get(i)%></strong>
					<%}%>
					</select><input  type="checkbox" name="por<%=rowsum%>_ismustpass" value="1" <%if(!desattr.equals("4")){%>style="display:none;"<%}%> <%=ismustpasscheck%>><SPAN  id="por<%=rowsum%>_ismustpassspan" <%if(!desattr.equals("4")){%>style="display:none;"<%}%>><%=SystemEnv.getHtmlLabelName(21398,user.getLanguage())%></SPAN>
				</td>
				<%if(showwayoutinfo){%>
				<td height="23">
				<input type='text' class=inputstyle name="por<%=rowsum%>_tipsinfo" onblur="checkInputInfoLength(<%=rowsum%>)" value="<%=WFNodePortalMainManager.getTipsinfo()%>" maxlength="500">
				</td>
				<%}else{%>
				<input type="hidden" name="por<%=rowsum%>_tipsinfo" value="<%=WFNodePortalMainManager.getTipsinfo()%>">
				<%}%>          
				</tr>
				<tr class='Spacing' style="height:1px!important;"><td <%if(showwayoutinfo){%>colspan=9<%}else{ %>colspan=8<%} %> class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
				<%
				//rowsum+=1;
				}
				}
				%>
		</table>	
	</wea:item>
	</wea:group>
</wea:layout>
<center>
<input type="hidden" value="wfnodeportal" name="src">
  <input type="hidden" value="<%=wfid%>" name="wfid">
  <input type="hidden" value="0" name="nodessum">
  <input type="hidden" value="" name="delids">
  <input type="hidden" value="" name="portValueStr">
<center>
</form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script type="text/javascript">
jQuery(document).ready(function(){
	jQuery("#oTable").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");	
	jQuery("#oTable4port").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
});
jQuery(function(){
	$("#oTable4port").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
});
//关闭dialog后的回调方法；@authoer Dracula 2014-7-21
function setSpanInner(row,hascon,pre)
{
	if(hascon=="1"){
    	$GetEle("ischeck"+row+"span1").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
   	}else{
    	$GetEle("ischeck"+row+"span1").innerHTML="";
    }
}

function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	var idStr = "";
	<% if(!ajax.equals("1")) {%>
		idStr ="#oTable";
	<% }else {%>
		idStr ="#oTable4port";
	<% }%>
	
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
        
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}
</script>
<%if(!ajax.equals("1")){%>
<script language=javascript>
var rowColor="" ;
rowindex = "<%=rowsum%>";
delids = "";
function addRow()
{		rowColor = getRowBg();
	ncol = 8;

	var oOption=document.portform.curnode.options[document.portform.curnode.selectedIndex];

	if(oOption.value == -1)
		return;

	tmpval = oOption.value;
	tmparry = tmpval.split("_");
	tmpval = tmparry[0];
	tmptype = tmparry[1];
    tmpattr =tmparry[2];

    oRow = oTable.insertRow();

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = oOption.text+"<input type='hidden' name='por"+rowindex+"_nodeid' value='"+tmpval+"'>";


				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex +"_rej' value='1'";
				if(tmptype != 1)
					sHtml += " disabled ";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='por"+rowindex+"_des' onchange=checkSame('por"+rowindex+"_nodeid',this,'<%=nodeidattr4%>','por"+rowindex+"_ismustpass','por"+rowindex+"_ismustpassspan')><option value='-1'><%=SystemEnv.getHtmlLabelName(15612,user.getLanguage())%></option>";
                <%
                for(int i=0;i<nodeids.size(); i++) {
                    String tempattr=(String)nodeattrs.get(i);
                %>
                    switch(tmpattr){
                        case "0":
                        case "3":
                        case "4":
                            if(<%=nodeattrs.get(i)%>!=2){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                        case "1":
                            if(<%=nodeattrs.get(i)%>!=3&&<%=nodeattrs.get(i)%>!=4){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                        case "2":
                            if(<%=nodeattrs.get(i)%>!=0&&<%=nodeattrs.get(i)%>!=1){
                                sHtml += "<option value='<%=nodeids.get(i)%>'><strong><%=nodenames.get(i)%></strong>";
                            }
                            break;
                    }
                <%
                }
                %>
                sHtml+= "</select><input type=checkbox name='por"+rowindex+"_ismustpass' value='1' style='display:none;'><SPAN id='por"+rowindex+"_ismustpassspan' style='display:none;'><%=SystemEnv.getHtmlLabelName(21398,user.getLanguage())%></SPAN>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);

				/*var osel = document.all("por"+rowindex+"_des");
				for(i=0;i<osel.options.length;i++){
					if(osel.options[i].value==tmpval)
						osel.options[i] = null;
				}*/
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type="button" class=Browser1 onclick='onShowBrowser(0,"+rowindex+")'></button>";
				sHtml +="<input type='hidden' name='por"+rowindex+"_con'>";
        /* add by xhheng @20050205 for TD 1537 */
        sHtml +="<input type='hidden' name='por"+rowindex+"_con_cn'>";
				sHtml += "<span  name='por"+rowindex+"_conspan' id='por"+rowindex+"_conspan'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type="button" class=Browser1 onclick='onShowAddInBrowser(0)'></button>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex +"_isBulidCode' value='1'";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex+"_link'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
	jQuery("body").jNice();

}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				if(document.forms[0].elements[i].value!='0')
					delids +=","+ document.forms[0].elements[i].value;
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}
function selectall(){
	document.forms[0].nodessum.value=rowindex;
	document.forms[0].delids.value=delids;

	window.document.portform.submit();
}

function onShowBrowser(id,row){
//	alert("id:"+id+",row:"+row);
    if(id==0)
		alert("<%=SystemEnv.getHtmlLabelName(15613,user.getLanguage())%>");
	else{
	url = "BrowserMain.jsp?url=showcondition.jsp?formid=<%=formid%>&isbill=<%=isbill%>&id="+row+"&linkid="+id;
	con = window.showModalDialog(url,'','dialogHeight:400px;dialogwidth:600px');
	if(con!=null)
	{
		if(con !=""){
      //modify by xhheng @20050205 for TD 1537
			document.all("por"+row+"_con").value=con.substring(0,con.indexOf(";"));
      document.all("por"+row+"_con_cn").value=con.substring(con.indexOf(";")+1,con.length);
			document.all("por"+row+"_conspan").innerHTML="<img src='/workflow/ruleDesign/images/ok_hover_wev8.png' border=0></img>";
		}
		else{
			document.all("por"+row+"_con").value="";
      document.all("por"+row+"_con_cn").value="";
			document.all("por"+row+"_conspan").innerHTML="";
		}
	}
    }
}

//关闭dialog后的回调方法；@authoer Dracula 2014-7-21
function setSpanInner(row,hascon,pre)
{
	if(hascon=="1"){
    	$GetEle("ischeck"+pre+row+"span").innerHTML="<img src=\"/images/ecology8/checkright_wev8.png\" width=\"16\" height=\"17\" border=\"0\">";
   	}else{
    	$GetEle("ischeck"+pre+row+"span").innerHTML="";
    }
}

function checkSame(curNodePortal,obj,nodeidattr4,ismustpass,ismustpassspan){
    if(document.all(curNodePortal).value==obj.value)
    alert("<%=SystemEnv.getHtmlLabelName(18690,user.getLanguage())%>");
    tmpnodeid =","+obj.value+",";
    nodeidattr4+=",";
    if(nodeidattr4.indexOf(tmpnodeid)>-1){
        document.all(ismustpass).style.display='';
        document.all(ismustpassspan).style.display='';
    }else{
        document.all(ismustpass).style.display='none';
        document.all(ismustpassspan).style.display='none';
    }
}
</script>
<%}else{
%>
<div id=portrowsum style="display:none;"><%=maxrow+1%></div>
<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
var rowindex4port = -1;
var delids4port = "";
function addRow4port(rformid,risbill,nodeidstr,nodeattrstr,nodenamestr,nodeidattr4,showwayoutinfo)
{
    //if(rowindex4port == -1)
    //rowindex4port=$GetEle("portrowsum").innerHTML;
	var portrowsum = parseInt(document.all("portrowsum").innerHTML);
	if(rowindex4port==-1)
    rowindex4port=portrowsum;
    if(portrowsum>rowindex4port){
    	rowindex4port = portrowsum;
    }
    rowColor = getRowBg();
	ncol = 8;
    if(showwayoutinfo) ncol = 9;
	var oOption=document.portform.curnode.options[document.portform.curnode.selectedIndex];

	if(oOption.value == -1)
		return;

	tmpval = oOption.value;
	tmparry = tmpval.split("_");
	tmpval = tmparry[0];
	tmptype = tmparry[1];
    tmpattr =tmparry[2];
    tmpnodeids=nodeidstr.split(",");
    tmpnodeattrs=nodeattrstr.split(",");
    var splitstr = "<%=Util.getSeparator()%>";
    //tmpnodenames=nodenamestr.split(splitstr);
    tmpnodenames=nodenamestr.split("$");
	//添加出口 2012-08-29 ypc 修改
	//在这个地方添加啦document.getElementById();
	//oTable4port.insertRow(-1); 这种写法 导致 新建流程时 按照以下顺序会出现错误（IE浏览器的左下角报js错误）

	//路径设置 - 添加 - 添加节点信息 - 添加流程编号 - 添加出口 (错误就在这里: 当选中某一个节点 点击 添加出口 按钮IE浏览器左下角就报js错误) 此种错误不用图形编辑工具去搭建

	oRow = document.getElementById("oTable4port").insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background="#fff";
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0'>&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' /><input type='hidden' name='por_order_" + rowindex4port + "' value=''>";
				sHtml += "<input type='hidden' name='por"+rowindex4port+"_id' value=''>";
				sHtml += "<input type='hidden' name='por"+rowindex4port+"record' value='"+rowindex4port+"'>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = oOption.text+"<input type='hidden' name='por"+rowindex4port+"_nodeid' value='"+tmpval+"'>";


				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex4port +"_rej' value='1'";
				if(tmptype != 1)
					sHtml += " disabled ";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;

			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "";
				var _curtype;
				if(tmptype != 1)
					_curtype = 1;
				sHtml += "<button type='button' class=Browser1 onclick='onShowBrowser4port(0,"+rowindex4port+","+rformid+","+risbill+","+_curtype+")'></button>";
				sHtml +="<input type='hidden' name='por"+rowindex4port+"_con'>";
        /* add by xhheng @20050205 for TD 1537 */
        sHtml +="<input type='hidden' name='por"+rowindex4port+"_con_cn'>";
				sHtml += "<span  name='por"+rowindex4port+"_conspan' id='por"+rowindex4port+"_conspan'></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "";
				sHtml += "<button type='button' class=Browser1 onclick='onShowAddInBrowser(0)'></button>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='por" + rowindex4port +"_isBulidCode' value='1'";
				sHtml += ">";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_link' onchange='checkinput(\"por"+rowindex4port+"_link\",\"por"+rowindex4port+"_linkspan\"),checkLength(\"por"+rowindex4port+"_link\",\"60\",\"<%=SystemEnv.getHtmlLabelName(15611, user.getLanguage())%>\",\"<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>\",\"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>\")'>";
				sHtml += "<span  id='por"+rowindex4port+"_linkspan'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = "<select class=inputstyle  name='por"+rowindex4port+"_des' onchange=checkSame('por"+rowindex4port+"_nodeid',this,'"+nodeidattr4+"','por"+rowindex4port+"_ismustpass','por"+rowindex4port+"_ismustpassspan')><option value='-1'><%=SystemEnv.getHtmlLabelName(15612, user.getLanguage())%></option>";
                for(i=0;i<tmpnodeids.length; i++) {
                	sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                        /*switch(tmpattr){
                            case "0":
                            case "3":
                            case "4":
                                if(tmpnodeattrs[i]!=2){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                            case "1":
                                if(tmpnodeattrs[i]!=3&&tmpnodeattrs[i]!=4){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                            case "2":
                                if(tmpnodeattrs[i]!=0&&tmpnodeattrs[i]!=1){
                                    sHtml += "<option value='"+tmpnodeids[i]+"'><strong>"+tmpnodenames[i]+"</strong>";
                                }
                                break;
                        }*/
                }
                sHtml+= "</select><input type=checkbox name='por"+rowindex4port+"_ismustpass' value='1' style='display:none;'><SPAN id='por"+rowindex4port+"_ismustpassspan' style='display:none;'><%=SystemEnv.getHtmlLabelName(21398, user.getLanguage())%></SPAN>";
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);

				break;
            case 8:
                var oDiv = document.createElement("div");
                //TD23877:20110509 出口提示信息的长度控制 ADD BY QB START  
				//var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_tipsinfo'  maxlength=500>";
				var sHtml = "<input type='text' class=inputstyle name='por"+rowindex4port+"_tipsinfo' onblur=checkAddInputInfoLength(this) maxlength=500>";
				//TD23877:20110509 出口提示信息的长度控制 ADD BY QB END  
				oDiv.innerHTML = sHtml;
				jQuery(oCell).append(oDiv);
				break;
        }
	}
	rowindex4port = rowindex4port*1 +1;
	jQuery("body").jNice();
	beautySelect( jQuery('[name=por'+rowindex4port+'_des]') );
}

function deleteRow4port()
{   
	if(rowindex4port == -1)
    rowindex4port=$GetEle("portrowsum").innerHTML;
	len = document.portform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.portform.elements[i].name=='check_node')
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.portform.elements[i].name=='check_node'){
			if(document.portform.elements[i].checked==true) {
				if(document.portform.elements[i].value!='0')
					delids4port +=","+ document.portform.elements[i].value;
					//删除出口 > 添加 document.getElementById(); 2012-08-29 ypc 修改 (直接通过 id:oTable4port 获取不到该属性 在某种情况下)
				var  nowRow = $(document.portform.elements[i]);				
				var  preRow = nowRow.closest("tr").prev();
				if(preRow.find("td").attr("class")==="paddingLeft18"){
					document.getElementById("oTable4port").deleteRow(preRow.index());
				}		
				var  rowsum2 = nowRow.closest("tr").index();		
				document.getElementById("oTable4port").deleteRow(rowsum2);
			}
			rowsum1 -=1;
		}

	}
}

function checkSame(curNodePortal,obj,nodeidattr4,ismustpass,ismustpassspan){
    if($GetEle(curNodePortal).value==obj.value)
    alert("<%=SystemEnv.getHtmlLabelName(18690, user.getLanguage())%>");
    tmpnodeid =","+obj.value+",";
    nodeidattr4+=",";
    if(nodeidattr4.indexOf(tmpnodeid)>-1){
        document.portform.all(ismustpass).style.display='';
        document.portform.all(ismustpassspan).style.display='';
    }else{
        document.portform.all(ismustpass).style.display='none';
        document.portform.all(ismustpassspan).style.display='none';
    }
}
var dialog = null;

function onShowBrowser4port(id,row,rformid,risbill,rwfid,isreject,curtype){
    if(id==0) {
		alert("<%=SystemEnv.getHtmlLabelName(15613, user.getLanguage())%>");
    } else {
    	dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=1&formid="+rformid+"&isbill="+risbill+"&linkid="+id+"&wfid="+rwfid+"&isreject="+isreject+"&curtype="+curtype;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18850,user.getLanguage())%>";
		dialog.Width = 900;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
    }
}

function onShowAddInBrowser(row){
	if(row==0)
		alert("<%=SystemEnv.getHtmlLabelName(15613, user.getLanguage())%>");
	else{
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var titlename = "<%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%>";
		var url = "/workflow/workflow/showaddinContent.jsp?wfid=<%=wfid%>&linkid="+row+"&titlename="+titlename;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(15610,user.getLanguage())%>";
		dialog.Width = 1000;
		dialog.Height = 500;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
			dialog.callbackfunc4CloseBtn = function(){
			//alert(1);
			//console.log(dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow);
			dialog.innerFrame.contentWindow.document.getElementById("tabcontentframe").contentWindow.closeWindow();
		};
		dialog.show();
	}
//	alert(url);
}

function checkInputInfoLength(rowsum){
	var tmpvalue = $G("por"+rowsum+"_tipsinfo").value;
	var size = $G("por"+rowsum+"_tipsinfo").maxLength;
	if (realLength(tmpvalue)>500) {
		alert("<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>"+"500("+"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>"+")");
		while(true){ 	    	
			tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);			
			if(realLength(tmpvalue)<=size){
				$GetEle("por"+rowsum+"_tipsinfo").value = tmpvalue;
				return;
			}
		}
	}
}

function portsave(obj){
	var portrowsum = parseInt($GetEle("portrowsum").innerHTML);
	if(rowindex4port==-1)
    rowindex4port=portrowsum;
    if(portrowsum>rowindex4port){
    	rowindex4port = portrowsum;
    }
    var elementslength = document.portform.elements.length;
    for(var i=0;i<elementslength;i++){
        var pf_elementtmp = document.portform.elements[i];
        if(pf_elementtmp != null && pf_elementtmp.name.indexOf("por")==0&&pf_elementtmp.name.indexOf("_link")==(pf_elementtmp.name.length-5)){
    //if($GetEle("por"+i+"_link") != null){
	    	tempValue = pf_elementtmp.value;
		    	if(tempValue==""){
		    	 alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		    	 return;
		    	}
		    }
		
	   //TD23877:20110505 出口提示信息的长度控制 ADD BY QB START    
	   if ($GetEle("por"+i+"_tipsinfo") != null) {
	   	   temptips = $GetEle("por"+i+"_tipsinfo").value;
	   	   if (realLength(temptips)>500) {
	   	   	alert("<%=SystemEnv.getHtmlLabelName(20246, user.getLanguage())%>"+"500("+"<%=SystemEnv.getHtmlLabelName(20247, user.getLanguage())%>"+")");
	   	   	return null;
	   	   }
	   }
	   //TD23877:20110505 出口提示信息的长度控制 ADD BY QB END  
    }
        
    var por = jQuery("input[name^='por_order_']");
    for(var i=0; i<por.length; i++){
		jQuery(por[i]).val(i+1);
	}
    
    var portValueStr = "";
    jQuery("input[name$='_id']").each(function(i) {
    	var num = jQuery(this).val();
    	if(!!num && num != null){
    		portValueStr += num + "\u001b";
    	}else{
    		num = jQuery(this).next().val();
    		portValueStr += num + "\u001b";
    	}
	});
    jQuery("input[name=portValueStr]").val(portValueStr);
    
    portform.nodessum.value=rowindex4port;
    portform.delids.value=delids4port;
    obj.disabled=true;
    tab4oldurl="";  
    portform.submit();
}
</script>
<%}%>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
</html>
