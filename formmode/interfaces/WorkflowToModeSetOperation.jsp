<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.action.WorkflowActionManager"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));

if (operation.equals("getBaseField")){
	String wfformid = Util.null2String(request.getParameter("wfformid"));
	String formtype = Util.null2String(request.getParameter("formtype"));
	String basedfield = Util.null2String(request.getParameter("basedfield"));
	boolean ischangeformtype = Util.null2String(request.getParameter("type")).equals("true");
	
	StringBuffer basedfieldhtml = new StringBuffer();
	String tablename = "";
	rs.executeSql("select tablename from workflow_bill where id = '"+wfformid+"'");
	if(rs.next()){
		tablename = Util.null2String(rs.getString("tablename"));
	}
	String tempdetailtable = tablename+"_dt"+formtype.replace("detail","");
	String sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = '" + 
		wfformid + "' order by viewtype asc,detailtable asc,id asc";
	rs.executeSql(sql);
	
	boolean basedfieldexists = false;
	basedfieldhtml.append("<select class=InputStyle id='basedfield' name='basedfield' onChange=\"checkinput('basedfield','basedfieldspan');initSbSelectorStyle();\">") ;
	basedfieldhtml.append("<option value=''></option>");
	while(!"".equals(wfformid)&&rs.next()){
		String fieldid = Util.null2String(rs.getString("id"));
		String fieldname = Util.null2String(rs.getString("fieldname"));
		String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
		String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
		String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
		String type = Util.null2String(rs.getString("type"));
		String viewtype = Util.null2String(rs.getString("viewtype"));
		String detailtable = Util.null2String(rs.getString("detailtable"));
		String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
		if("3".equals(fieldhtmltype) && "256".equals(type)){
			labelname += "("+fieldname+")";
		}else if("3".equals(fieldhtmltype) && "257".equals(type)){
			labelname += "("+fieldname+")";
		}else{
			labelname += "("+fieldname+")";
		}
		
		if(viewtype.equals("1")){
			if(tempdetailtable.equals(detailtable)) {
				int modedetailno = Util.getIntValue(detailtable.replace(tablename+"_dt", ""));
				labelname = SystemEnv.getHtmlLabelName(17463,user.getLanguage())+modedetailno +"_"+ labelname;
			} else {
				continue;
			}
			//modedetailno++;
			
		}
		
		if(formtype.equals("maintable") && !"0".equals(viewtype)) {
			continue;
		}
		
		//整数或者多选browser框可以作为依据字段
		if(("1".equals(fieldhtmltype)&&"2".equals(type))||FormModeBrowserUtil.isMultiBrowser(fieldhtmltype, type)){
			basedfieldhtml.append("<option value='"+fieldid+"'");
			if(!"1".equals(fieldhtmltype)){
				basedfieldhtml.append(" ismultibrowser='true' ");
			}
			if(!ischangeformtype && fieldid.equals(basedfield)){
   				basedfieldhtml.append(" selected ");
   				basedfieldexists = true;
   			}
   			basedfieldhtml.append(">"+labelname+"</option>");
		}
	}
	basedfieldhtml.append("</select>");
	basedfieldhtml.append("<span id=basedfieldspan>");
	if(!basedfieldexists){
		basedfieldhtml.append("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	}
	basedfieldhtml.append("</span>");
	JSONObject obj = new JSONObject();
	response.resetBuffer();
	response.setContentType("text/html;charset=UTF-8");
	obj.put("basedfieldhtml",basedfieldhtml.toString());
	response.getWriter().write(obj.toString());
	return;
}



char separator = Util.getSeparator() ;
String sql = "";

int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
int modecreater = Util.getIntValue(request.getParameter("modecreater"),0);
int modecreaterfieldid = Util.getIntValue(request.getParameter("modecreaterfieldid"),0);
int detailno = Util.getIntValue(request.getParameter("detailno"),0);
int triggerMethod = Util.getIntValue(request.getParameter("triggerMethod"),1); //触发方式：节点触发，出口触发
int triggerMethodOld = Util.getIntValue(request.getParameter("triggerMethodOld"), 1);
int triggerNodeId = 0;
int triggerNodeIdOld = 0;
int triggerType = 0;
int workflowExport = 0;
int workflowExportOld = 0;
if (triggerMethod == 1) { //节点触发
	triggerNodeId = Util.getIntValue(request.getParameter("triggerNodeId"),0);
	triggerNodeIdOld = Util.getIntValue(request.getParameter("triggerNodeIdOld"),0);
	triggerType = Util.getIntValue(request.getParameter("triggerType"),0);
} else if (triggerMethod == 2) { //出口触发
	workflowExport = Util.getIntValue(request.getParameter("workflowExport"),0); //触发出口
	workflowExportOld = Util.getIntValue(request.getParameter("workflowExportOld"),0); 
}
int isenable = Util.getIntValue(request.getParameter("isenable"),0);
String formtype =  Util.null2String(request.getParameter("formtype"),"maintable");
int tempid = id;
String isnode = "1";
String type = "2";

int initworkflowid = Util.getIntValue(request.getParameter("initworkflowid"),0);
int initmodeid = Util.getIntValue(request.getParameter("initmodeid"),0);
int actionid = Util.getIntValue(request.getParameter("actionid"),0);
String maintableopttype = Util.null2String(request.getParameter("maintableopttype"),"1");
String maintableupdatecondition = Util.null2String(request.getParameter("maintableupdatecondition")).trim();
String maintablewherecondition = Util.null2String(request.getParameter("maintablewherecondition")).trim();

if (!"4".equals(maintableopttype)) { //如果不是插入并更新，则清除掉条件
	maintablewherecondition = "";
}

if("1".equals(maintableopttype) || "4".equals(maintableopttype)){//如果是插入或者是插入并更新，则清空更新条件
	maintableupdatecondition = "";
}else{
	maintableupdatecondition = maintableupdatecondition.replaceAll("<br>",""+'\n').replaceAll("\'","\''");
}

String basedfield = Util.null2String(request.getParameter("basedfield"));
//如果不是批量插入操作，则清空生成多条数据字段信息
if(!"3".equals(maintableopttype)){
	basedfield = "";
}

boolean needDeleteAction = false;
//1、触发发方式改变；2、触发节点改变；3、触发出口改变
if(triggerMethod != triggerMethodOld || (triggerMethod == 1 && triggerNodeId != triggerNodeIdOld) || (triggerMethod == 2 && workflowExport != workflowExportOld)){
	needDeleteAction = true;
}

//先删除数据再重新保存
if (operation.equals("save")) {
	String customervalue = "action.WorkflowToMode";//通过action，使流程的数据转为卡片数据
	if(modecreater!=3){
		modecreaterfieldid = 0;
	}
	
	if(id>0){//编辑
		//修改数据
		sql = "update mode_workflowtomodeset set isenable = "+isenable+",modeid = "+modeid+",workflowid = "+workflowid+",modecreater = "+modecreater
				+",modecreaterfieldid = "+modecreaterfieldid+",triggerMethod="+triggerMethod+",triggerNodeId = "+triggerNodeId+",triggerType = "+triggerType+",workflowExport="+workflowExport+",formtype='"
				+formtype+"',maintableopttype='"+maintableopttype+"',maintableupdatecondition='"+maintableupdatecondition+"',maintablewherecondition='"+maintablewherecondition+"',basedfield='"+basedfield+"' where id = " + id;
		rs.executeSql(sql);
		
		//删除已经设置好的明细数据
		sql = "delete from mode_workflowtomodesetdetail where mainid = " + id;
		rs.executeSql(sql);
		
        for(int i=0;i<=detailno;i++){
        	String wffieldidvalues[] = request.getParameterValues("wffieldid"+i);
        	String modefieldidvalues[] = request.getParameterValues("modefieldid"+i);
        	
        	if(wffieldidvalues!=null && modefieldidvalues!=null){
        		for(int j=0;j<wffieldidvalues.length;j++){
        			int wffieldidvalue = Util.getIntValue((String)wffieldidvalues[j],0);
        			int modefieldidvalue = Util.getIntValue((String)modefieldidvalues[j],0);
        			
        			sql = "insert into mode_workflowtomodesetdetail (mainid,modefieldid,wffieldid) values ("+id+","+modefieldidvalue+","+wffieldidvalue+")";
        			rs.executeSql(sql);
        		}
        	}
        }
        
        //删除已经设置好的明细表操作方式
        sql ="delete from mode_workflowtomodesetopt where mainid = " + id;
        rs.executeSql(sql);
        
        if(formtype.indexOf("detail")==-1){
        	for(int i=1;i<=detailno;i++){
	        	String detailtablename = Util.null2String(request.getParameter("detailtablename"+i));
	        	String detailtableopttype =Util.null2String(request.getParameter("detailtableopttype"+i));
	        	String detailtableupdatecondition = Util.null2String(request.getParameter("detailtableupdatecondition"+i));
	        	String detailtablewherecondition = Util.null2String(request.getParameter("detailtablewherecondition"+i));
	        	detailtableupdatecondition = Util.fromScreen(detailtableupdatecondition,user.getLanguage());
	        	//如果主数据中不是插入并更新，清除掉条件数据
	        	if (!"4".equals(maintableopttype)) {
	        		detailtablewherecondition = "";
	        	}
	        	if("1".equals(maintableopttype)){//如果主表是插入操作，则子表操作条件清空
	        		detailtableopttype = "";
	        		detailtableupdatecondition = "";
	        	}
	        	if(!"3".equals(detailtableopttype)&&!"4".equals(detailtableopttype)){//如果不是更新操作则更新条件清空
	        		detailtableupdatecondition = "";
	        	}
	        	
	        	sql = "insert into mode_workflowtomodesetopt (mainid,detailtablename,opttype,updatecondition,wherecondition) values "
	        			+"("+id+",'"+detailtablename+"','"+detailtableopttype+"','"+detailtableupdatecondition+"','"+detailtablewherecondition+"')";
	        	rs.executeSql(sql);
	        }
        }
        
        if(actionid>0){
        	WorkflowActionManager workflowActionManager = new WorkflowActionManager();
        	int actionorder = 0;
	        rs.executeSql("select actionorder from workflowactionset where id = "+actionid);
        	if(!rs.next()) {
       			actionid = 0;
       			actionorder = 0;
       		} else {
       			actionorder = Util.getIntValue(rs.getString("actionorder"),0);
       		}
       		if(needDeleteAction){
       			workflowActionManager.doDeleteWsAction(actionid);
       			actionid = 0;
       		}
        	String actionname = "WorkflowToMode";
	        workflowActionManager.setActionid(actionid);//保存
			workflowActionManager.setWorkflowid(workflowid);
			workflowActionManager.setNodeid(triggerNodeId);
			workflowActionManager.setActionorder(actionorder);
			workflowActionManager.setNodelinkid(workflowExport); //出口
			workflowActionManager.setIspreoperator(triggerType);
			workflowActionManager.setActionname(actionname);
			workflowActionManager.setInterfaceid(actionname);
			workflowActionManager.setInterfacetype(3);
			workflowActionManager.setIsused(isenable);//是否启用
			
			actionid = workflowActionManager.doSaveWsAction();
        } else if (actionid == -1) {
        	String actionname = "WorkflowToMode";
		    WorkflowActionManager workflowActionManager = new WorkflowActionManager();
		    workflowActionManager.setActionid(0);//新建
			workflowActionManager.setWorkflowid(workflowid);
			workflowActionManager.setNodeid(triggerNodeId);
			workflowActionManager.setActionorder(0);
			workflowActionManager.setNodelinkid(workflowExport);
			workflowActionManager.setIspreoperator(triggerType);
			workflowActionManager.setActionname(actionname);
			workflowActionManager.setInterfaceid(actionname);
			workflowActionManager.setInterfacetype(3);
			workflowActionManager.setIsused(isenable);//是否启用
				
			actionid = workflowActionManager.doSaveWsAction();
        }
        //修改主表action字段
		sql = "update mode_workflowtomodeset set actionid = " + actionid + " where id = " + id;
        rs.executeSql(sql);
	} else {//新建
    	String actionname = "WorkflowToMode";
        WorkflowActionManager workflowActionManager = new WorkflowActionManager();
        workflowActionManager.setActionid(0);//新建
		workflowActionManager.setWorkflowid(workflowid);
		workflowActionManager.setNodeid(triggerNodeId);
		workflowActionManager.setActionorder(0);
		workflowActionManager.setNodelinkid(workflowExport);
		workflowActionManager.setIspreoperator(triggerType);
		workflowActionManager.setActionname(actionname);
		workflowActionManager.setInterfaceid(actionname);
		workflowActionManager.setInterfacetype(3);
		workflowActionManager.setIsused(0);//新建未启用
		
		actionid = workflowActionManager.doSaveWsAction();
		
		//插入主表数据
        sql = "insert into mode_workflowtomodeset(modeid,workflowid,modecreater,modecreaterfieldid,triggerMethod,triggerNodeId,triggerType,workflowExport,isenable,formtype,actionid)"
        		+" values ("+modeid+","+workflowid+","+modecreater+","+modecreaterfieldid+","+triggerMethod+","+triggerNodeId+","+triggerType+","+workflowExport+","+isenable+",'"+formtype+"',"+actionid+")";
        rs.executeSql(sql);
        
        //查询id
        sql = "select max(id) id from mode_workflowtomodeset where modeid = " + modeid + " and workflowid = " + workflowid + " and modecreater = " + modecreater + " and modecreaterfieldid = " +modecreaterfieldid;
        rs.executeSql(sql);
        while(rs.next()){
        	id = rs.getInt("id");
        }
        
		//新建的时候，如果明细和主表用的为同一个表单，则初始化字段的对应关系
       	int modeformid = 0;
       	int wfformid = 0;
       	wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
   		sql = "select modename,formid from modeinfo where id = " + modeid;
   		rs.executeSql(sql);
   		while(rs.next()){
   			modeformid = rs.getInt("formid");
   		}
   		if(wfformid==modeformid&&wfformid!=0){
         	sql = "insert into mode_workflowtomodesetdetail (mainid,modefieldid,wffieldid) select " + id + ",id,id from workflow_billfield where billid = " + wfformid;
			rs.executeSql(sql);
   		}
    }
	response.sendRedirect("/formmode/interfaces/WorkflowToModeSet.jsp?initworkflowid="+initworkflowid+"&initmodeid="+initmodeid+"&id="+id);
}else if (operation.equals("del")) {
    //删除主表数据
	sql = "delete from mode_workflowtomodeset where id = " + id;
	rs.executeSql(sql);
	
	//删除明细表更新条件
	sql = "delete from mode_workflowtomodesetopt where mainid = " + id;
	rs.executeSql(sql);

	//删除明细表数据
	sql = "delete from mode_workflowtomodesetdetail where mainid = " + id;
	rs.executeSql(sql);
	if(actionid>0){
		WorkflowActionManager workflowActionManager = new WorkflowActionManager();
		workflowActionManager.doDeleteWsAction(actionid);
	}
	
	response.sendRedirect("/formmode/interfaces/WorkflowToModeList.jsp?workflowid="+initworkflowid+"&modeid="+initmodeid);
}

%>