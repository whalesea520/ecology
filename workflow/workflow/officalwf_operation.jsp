<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page buffer="8kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.util.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.Writer" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.change.*" %>
<%@ page import="weaver.general.TimeUtil,weaver.workflow.workflow.WfDataSource"%>
<%@ page import="org.json.JSONArray,org.json.JSONObject" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="mouldManager" class="weaver.docs.mould.MouldManager" scope="page" />
<%
  User user = HrmUserVarify.getUser(request,response);
  String id = Util.null2String(request.getParameter("wfid"));
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(Util.getIntValue(id, 0), 0, user, WfRightManager.OPERATION_CREATEDIR);
  if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
        response.sendRedirect("/notice/noright.jsp");
            return;
    }  
  String src = Util.null2String(request.getParameter("operation"));
////得到标记信息
  if(id.equals("") && !src.equalsIgnoreCase("testFtp")){
    JSONObject result = new JSONObject();
    result.put("result",0);
    out.println(result.toString());
    return;
  }
  if(src.equalsIgnoreCase("setOfficalWf")){  //添加公文流程    
     String sql = "update workflow_base set isWorkflowDoc=1 where id="+id;
     if(rs.execute(sql)){
        WorkflowComInfo.reloadWorkflowInfos();
        log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), sql, "220", "24", 0, request.getRemoteAddr());
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
     }else{
     JSONObject result = new JSONObject();
        result.put("result",2);
        out.println(result.toString());
     }
	sql = "update workflow_createdoc set status='1' where workflowid="+id;
    rs.execute(sql);
  }else if(src.equalsIgnoreCase("detachOfficalWf")){//删除公文流程
    String sql = "update workflow_base set isWorkflowDoc=0 where id in ("+id+")";
    if(rs.execute(sql)){
        String[] idArr = id.split(",");
        for(int i=0;i<idArr.length;i++){
            log.insSysLogInfo(user, Util.getIntValue(idArr[i]), WorkflowComInfo.getWorkflowname(idArr[i]), sql, "220", "3", 0, request.getRemoteAddr());
        }
        WorkflowComInfo.reloadWorkflowInfos();
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("result",2);
        out.println(result.toString());
    }
	sql = "update workflow_createdoc set status=0 where workflowid="+id;
    rs.execute(sql);
  }else if(src.equalsIgnoreCase("setCreateDoc")){
    int status = Util.getIntValue(request.getParameter("status"),0);
    String sql = "update workflow_createdoc set wfstatus="+status+" where workflowid="+id;
    if(rs.execute(sql)){
        log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), sql, "220", status==0?"25":"26", 0, request.getRemoteAddr());
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("result",2);
        out.println(result.toString());
    }
  }else if(src.equalsIgnoreCase("detachViewMould")){//删除套红模板
    String mouldids = Util.null2String(request.getParameter("mouldids"));
    String sql = "update workflow_mould set visible=0 where mouldType=0 and mouldid in ("+mouldids+") and workflowid = "+id;
    if(rs.execute(sql)){
        log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), sql, "220", "2", 0, request.getRemoteAddr());
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("result",2);
        out.println(result.toString());
    }
  }else if(src.equalsIgnoreCase("detachEditMould")){//删除编辑模板
    String mouldids = Util.null2String(request.getParameter("mouldids"));
    String sql = "update workflow_mould set visible=0 where mouldType=3 and mouldid in ("+mouldids+") and workflowid = "+id;
    if(rs.execute(sql)){
        log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), sql, "220", "2", 0, request.getRemoteAddr());
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("result",2);
        out.println(result.toString());
    }
  }else if(src.equalsIgnoreCase("attachViewMould")){//添加套红/编辑模板
    String from = Util.null2String(request.getParameter("from"));
    String mouldids = "";
    String seccategory = "";
    String mouldType = Util.null2String(request.getParameter("mouldType"));
    if(mouldType.equals(""))mouldType="0";
    if(from.equals("selectMulti")){
        String[] sec_mould = Util.null2String(request.getParameter("mouldids")).split("\\|");
        for(int i=0;i<sec_mould.length;i++){
            seccategory = sec_mould[i].split("_")[0];
            try{
                mouldids = Util.null2String(sec_mould[i].split("_")[1]);
            }
            catch(Exception e){
                mouldids = "";
            }
            String[] mouldIdArr = null;
            if(!mouldids.equals("")){
                mouldIdArr = mouldids.split(",");
                mouldManager.attachMould(mouldIdArr,seccategory,mouldType.equals("4"));
            }
            mouldManager.officalMouldAttach(mouldids,mouldType,id,seccategory);
        }
    }else{
        mouldids = Util.null2String(request.getParameter("mouldids"));
        seccategory = Util.null2String(request.getParameter("seccategory"));
        String[] mouldIdArr = mouldids.split(",");
        //首先将模板与子目录进行绑定

        mouldManager.attachMould(mouldIdArr,seccategory,mouldType.equals("3"));
        mouldManager.officalMouldAttach(mouldids,mouldType,id,seccategory);
    }
    log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), "", "220", "2", 0, request.getRemoteAddr());
    JSONObject result = new JSONObject();
    result.put("result",1);
    out.println(result.toString());
  }else if(src.equalsIgnoreCase("saveActionList")){//保存动作列表
    int rowNum = Util.getIntValue(request.getParameter("rowNum"),-1);
    StringBuilder existids = new StringBuilder();
    String deleteRows = Util.null2String(request.getParameter("__weaverDeleteRows"));
    for(int i=0;i<rowNum;i++){
        int actionId = Util.getIntValue(request.getParameter("actionChecbox_"+i),0);
        if(actionId>0){
            if(existids.length()>0)existids.append(",");
            existids.append(actionId+"");
        }
    }

	int isUse = Util.getIntValue(request.getParameter("isUse"),-1);
	rs.executeSql("UPDATE Workflow_BarCodeSet SET isUse = '"+isUse+"' WHERE workflowId ="+id);

    //首先删除记录
    
    
    String logsql =""; 
    String sql2 = "delete from workflow_addinoperate where workflowid = "+id+" and id in ("+deleteRows+")";
    if(!deleteRows.equals("")){
        logsql = sql2;
        rs.executeSql(sql2);
    }
    for(int i=0;i<rowNum;i++){
        int actionId = Util.getIntValue(request.getParameter("actionChecbox_"+i),0);
        if(actionId>0||actionId==-1){
            String customervalue = Util.null2String(request.getParameter("customervalue_"+i));
            String fieldid = Util.null2String(request.getParameter("fieldid_"+i));
            String isTriggerReject = Util.null2String(request.getParameter("isTriggerReject_"+i));
            String isnode = Util.null2String(request.getParameter("isnode_"+i));
            String objid = Util.null2String(request.getParameter("objid_"+i));
            StringBuilder sql = new StringBuilder();
            if(actionId>0){//更新
                sql.append("update workflow_addinoperate set customervalue='");
                sql.append(customervalue).append("',fieldid='");
                sql.append(fieldid).append("',isTriggerReject='");
                sql.append(isTriggerReject).append("',isnode='");
                sql.append(isnode).append("',objid='");
                sql.append(objid).append("',ispreadd=0 where id=").append(""+actionId);
            }else{//新增
                sql.append("insert into workflow_addinoperate(customervalue,fieldid,isTriggerReject,isnode,objid,ispreadd,workflowid,type,rules) values('");
                sql.append(customervalue).append("','").append(fieldid).append("','").append(isTriggerReject).append("','").append(isnode);
                sql.append("','").append(objid).append("',0,").append(id).append(",1").append(",0)");
            }
            logsql = logsql + ";" + sql.toString();
            rs.executeSql(sql.toString());
        }
    }
    log.insSysLogInfo(user, Util.getIntValue(id), WorkflowComInfo.getWorkflowname(id), logsql, "220", "2", 0, request.getRemoteAddr());
    JSONObject result = new JSONObject();
    result.put("result",1);
    out.println(result.toString());
  }else if(src.equalsIgnoreCase("testFtp")){
    String serverURL = Util.null2String(request.getParameter("serverURL"));
    String serverPort = Util.null2String(request.getParameter("serverPort"));
    String serverUser = Util.null2String(request.getParameter("serverUser"));
    String serverPwd = Util.null2String(request.getParameter("serverPwd"));
    DocChangeManager dcm = new DocChangeManager();
    boolean success = dcm.testFtpServer(serverURL,serverPort,serverUser,serverPwd);
    if(success){
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
    }else{
        JSONObject result = new JSONObject();
        result.put("result",0);
        out.println(result.toString());
    }
  }else if(src.equalsIgnoreCase("addChangeWf")){
    String wfid = Util.null2String(request.getParameter("wfid"));
    String[] wfidArr = wfid.split(",");
    String currentDate = TimeUtil.getCurrentDateString();
    String currentTime = (TimeUtil.getCurrentTimeString()).substring(11,19);
    for(int i=0;i<wfidArr.length;i++){
        String sql = "insert into DocChangeWorkflow(id,createdate,createtime,workflowid,creator) values ("+weaver.docs.change.DocChangeManager.getNextChangeId()+",'"+currentDate+"','"+currentTime+"',"+wfidArr[i]+","+user.getUID()+")";
        rs.executeSql(sql);
        log.insSysLogInfo(user, Util.getIntValue(wfidArr[i]), WorkflowComInfo.getWorkflowname(wfidArr[i]), sql, "347", "24", 0, request.getRemoteAddr());
    }
    JSONObject result = new JSONObject();
    result.put("result",1);
    out.println(result.toString());
  }else if(src.equalsIgnoreCase("updateIsTriDiffWorkflow")){
        String isTriDiffWorkflow = Util.null2String(request.getParameter("isTriDiffWorkflow"));
        if(rs.executeSql("update workflow_base set isTriDiffWorkflow='"+isTriDiffWorkflow+"' where id= "+id)){
            JSONObject result = new JSONObject();
            result.put("result",1);
            out.println(result.toString());
        }else{
            JSONObject result = new JSONObject();
            result.put("result",0);
            out.println(result.toString());
        }
         
  }else if(src.equalsIgnoreCase("updateIsRead")){
        String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));
        String isread = Util.null2String(request.getParameter("isread"));
        if(!isread.equals("1")){
            isread = "0";
        }
        String isreadNodes = Util.null2String(request.getParameter("isreadNodes"));
        if(isread.equals("0")){
            isreadNodes = "";
        }else{
            //if(isreadNodes.trim().equals("")){
            //  isreadNodes = "all";
            //}
        }
        
        String isreadMainwf = Util.null2String(request.getParameter("isreadMainwf"));
        if(!isreadMainwf.equals("1")){
            isreadMainwf = "0";
        }
        String isreadMainWfNodes = Util.null2String(request.getParameter("isreadMainWfNodes"));
        if(isreadMainwf.equals("0")){
            isreadMainWfNodes = "";
        }else{
            //if(isreadMainWfNodes.trim().equals("")){
            //  isreadMainWfNodes = "all";
            //}
        }
        
        String isreadParallelwf = Util.null2String(request.getParameter("isreadParallelwf"));
        if(!isreadParallelwf.equals("1")){
            isreadParallelwf = "0";
        }
        String isreadParallelwfNodes = Util.null2String(request.getParameter("isreadParallelwfNodes"));
        if(isreadParallelwf.equals("0")){
            isreadParallelwfNodes = "";
        }else{
            //if(isreadParallelwfNodes.trim().equals("")){
            //  isreadParallelwfNodes = "all";
            //}
        }
        
        if(rs.executeSql("update Workflow_SubwfSet set isread='"+isread+"',isreadNodes='"+isreadNodes+"',isreadMainwf='"+isreadMainwf+"',isreadMainWfNodes='"+isreadMainWfNodes+"',isreadParallelwf='"+isreadParallelwf+"',isreadParallelwfNodes='"+isreadParallelwfNodes+"' where id= '"+workflowSubwfSetId+"'")){
            JSONObject result = new JSONObject();
            result.put("result",1);
            out.println(result.toString());
        }else{
            JSONObject result = new JSONObject();
            result.put("result",0);
            out.println(result.toString());
        }
         
  }else if(src.equalsIgnoreCase("updateDiffIsRead")){
        String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));
        String isread = Util.null2String(request.getParameter("isread"));
        String isreadNodes = Util.null2String(request.getParameter("isreadNodes"));
        if(isread.equals("0")){
            isreadNodes = "";
        }else{
            //if(isreadNodes.trim().equals("")){
            //  isreadNodes = "all";
            //}
        }
        
        String isreadMainwf = Util.null2String(request.getParameter("isreadMainwf"));
        String isreadMainWfNodes = Util.null2String(request.getParameter("isreadMainWfNodes"));
        if(isreadMainwf.equals("0")){
            isreadMainWfNodes = "";
        }else{
            //if(isreadMainWfNodes.trim().equals("")){
            //  isreadMainWfNodes = "all";
            //}
        }
        
        String isreadParallelwf = Util.null2String(request.getParameter("isreadParallelwf"));
        String isreadParallelwfNodes = Util.null2String(request.getParameter("isreadParallelwfNodes"));
        if(isreadParallelwf.equals("0")){
            isreadParallelwfNodes = "";
        }else{
            //if(isreadParallelwfNodes.trim().equals("")){
            //  isreadParallelwfNodes = "all";
            //}
        }
        
        if(rs.executeSql("update Workflow_TriDiffWfSubWf set isread='"+isread+"',isreadNodes='"+isreadNodes+"',isreadMainwf='"+isreadMainwf+"',isreadMainWfNodes='"+isreadMainWfNodes+"',isreadParallelwf='"+isreadParallelwf+"',isreadParallelwfNodes='"+isreadParallelwfNodes+"' where id= '"+workflowSubwfSetId+"'")){
            JSONObject result = new JSONObject();
            result.put("result",1);
            out.println(result.toString());
        }else{
            JSONObject result = new JSONObject();
            result.put("result",0);
            out.println(result.toString());
        }
         
  }else if(src.equalsIgnoreCase("deleteSubWfSet")){
        String workflowSubwfSetId = Util.null2String(request.getParameter("workflowSubwfSetId"));
        try {
            rs.executeSql(" select id from rule_maplist where rulesrc=7 and linkid in (" + workflowSubwfSetId + ")");
	        while (rs.next()) {
	            RuleBusiness.deleteRuleMapping(Util.getIntValue(rs.getString(1)));
	        }
		} catch (Exception e8) {
		    e8.printStackTrace();
        }
        rs.executeSql(" delete from Workflow_SubwfSetDetail where subwfSetId in ("+workflowSubwfSetId+")");
        rs.executeSql(" delete from Workflow_SubwfSet where id in ("+workflowSubwfSetId+")");
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());
         
  }else if(src.equalsIgnoreCase("deleteSubWfSetDiff")){
        String workflowSubwfSetIds = Util.null2String(request.getParameter("workflowSubwfSetId"));
        try {
	        if (!"".equals(workflowSubwfSetIds)) {
	            rs.executeSql(" select id from rule_maplist where rulesrc=8 and linkid in (" + workflowSubwfSetIds + ")");
	            while (rs.next()) {
	                RuleBusiness.deleteRuleMapping(Util.getIntValue(rs.getString(1)));
	            }
	        }
        } catch (Exception e8) {
            e8.printStackTrace();
        }
        String[] subwfArr = workflowSubwfSetIds.split(",");
        String workflowSubwfSetId = "";
        for(int i=0;i<subwfArr.length;i++){
            workflowSubwfSetId = subwfArr[i];
            rs.executeSql(" delete from Workflow_TriDiffWfSubWfField where exists (select 1 from Workflow_TriDiffWfSubWf  where Workflow_TriDiffWfSubWf.id=Workflow_TriDiffWfSubWfField.triDiffWfSubWfId  and triDiffWfDiffFieldId="+workflowSubwfSetId+") ");
            rs.executeSql(" delete from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId= "+workflowSubwfSetId);          
            rs.executeSql(" delete from Workflow_TriDiffWfDiffField where id= "+workflowSubwfSetId);
        }   
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());         
         
  }else if(src.equalsIgnoreCase("deleteTriggerEntry")){//删除字段联动设置
        String entryIds = Util.null2String(request.getParameter("entryId"));
        String sql = "delete from Workflow_DataInput_field where DataInputID in (select id from Workflow_DataInput_main where entryId in ("+entryIds+"))";
        rs.executeSql(sql);
        sql = "delete from Workflow_DataInput_table where DataInputID in (select id from Workflow_DataInput_main where entryId in ("+entryIds+"))";
        rs.executeSql(sql);
        sql = "delete from Workflow_DataInput_main where entryId in ("+entryIds+")";
        rs.executeSql(sql);
        sql = "delete from Workflow_DataInput_entry where id in ("+entryIds+")";
        rs.executeSql(sql);
        JSONObject result = new JSONObject();
        result.put("result",1);
        out.println(result.toString());       
  }else if(src.equalsIgnoreCase("getWfField")){//删除字段联动设置
    String formid = WorkflowComInfo.getFormId(id);
    String isbill = WorkflowComInfo.getIsBill(id);
    String triggerFieldId = Util.null2String(request.getParameter("triggerFieldId"));
    if(formid.equals("")||isbill.equals("")){
        rs1.executeSql("select formid,isbill from workflow_base where id="+id );
        if(rs1.next()){
            formid = Util.null2String(rs1.getString("formid"));
            isbill = Util.null2String(rs1.getString("isbill"));
        }
    }
    if(!"1".equals(isbill)){
        isbill="0";
    }
    String wfMainFieldsOptions = "";//主字段

    String sql = "";
    if(isbill.equals("0")){//表单主字段

        sql = "select a.fieldid, b.fieldlable, a.isdetail, a.fieldorder from workflow_formfield a, workflow_fieldlable b "+
                    " where a.isdetail is null and a.formid=b.formid and a.fieldid=b.fieldid and a.formid="+formid+" and b.langurageid = "+user.getLanguage();
        if(rs.getDBType().equals("oracle")){
            sql += " order by a.isdetail desc,a.fieldorder asc ";
        }else{    
            sql += " order by a.isdetail,a.fieldorder ";
        }
    }else if(isbill.equals("1")){//单据主字段

        sql = "select id,fieldlabel,viewtype,dsporder from workflow_billfield where viewtype=0 and billid="+formid;
        sql += " order by viewtype,dsporder";
    }
    rs.executeSql(sql);
    while(rs.next()){
        String fieldname = "";
        if(isbill.equals("0")) fieldname = rs.getString("fieldlable");
        if(isbill.equals("1")) fieldname = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"), user.getLanguage());
        wfMainFieldsOptions += "<option value="+rs.getString(1)+">"+fieldname+"</option>";
    }
  }else if(src.equalsIgnoreCase("getParameterwfField")){//字段联动中获取取值参数

    String dataInputID = Util.null2String(request.getParameter("dataInputID"));
    String index = Util.null2String(request.getParameter("index"));
    String secIndex = Util.null2String(request.getParameter("secIndex"));
    String entryID = Util.null2String(request.getParameter("entryID"));
    String sql = "select * from workflow_dataInput_main where id="+dataInputID;
    rs.executeSql(sql);
    String datasourcename = "";
    if(rs.next()){
        datasourcename = Util.null2String(rs.getString("datasourcename"));
    }
    String formid = WorkflowComInfo.getFormId(id);
    String isbill = WorkflowComInfo.getIsBill(id);
    if(formid.equals("")||isbill.equals("")){
        rs1.executeSql("select formid,isbill from workflow_base where id="+id );
        if(rs1.next()){
            formid = Util.null2String(rs1.getString("formid"));
            isbill = Util.null2String(rs1.getString("isbill"));
        }
    }
    sql = "select * from Workflow_DataInput_field where type=1 and DataInputID="+dataInputID;
    rs.executeSql(sql);
    JSONArray jsonArray=new JSONArray();
    JSONArray ajaxData=new JSONArray();
    RecordSet rs4 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    String tabfix = "";
    while(rs.next()){
        String isdetail = Util.null2String(rs.getString("pagefieldindex")) ;
        jsonArray=new JSONArray();
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("name", "id");
        jsonObject.put("value", Util.null2String(rs.getString("id")));
        jsonObject.put("iseditable", "true");
        jsonObject.put("type", "checkbox");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "parawfField"+index+secIndex);
        String PageFieldName = Util.null2String(rs.getString("PageFieldName"));
        String tempfieldid = PageFieldName.substring(5,PageFieldName.length()) ;
        jsonObject.put("value", tempfieldid);
        
        String PageFieldNamestr = "";
        String ptabfix = "";
        try{
            if(isbill.equals("0")){
                if(isdetail.equals("0")){
                    ptabfix = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+formid+" and b.id="+tempfieldid+" and a.langurageid = "+user.getLanguage());
                    if(rs4.next()) {
                        PageFieldNamestr = Util.null2String(rs4.getString("fieldlable"));
                    }
                }else{
                    ptabfix = SystemEnv.getHtmlLabelName(19325,user.getLanguage()) ;
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+formid+" and b.id="+tempfieldid+" and a.langurageid = "+user.getLanguage());
                    if(rs4.next()) {
                        PageFieldNamestr = Util.null2String(rs4.getString("fieldlable"));
                    }
                    rs4.executeSql("select groupid from workflow_formfield where fieldid="+tempfieldid+" and formid="+formid+" and isdetail=1");
                    if(rs4.next()){
                        ptabfix += ""+(Util.getIntValue(rs4.getString(1),0)+1);
                    }
                }    
                
            }else{
                String viewtype = "";
                String detailtable = "";
                rs4.executeSql("select fieldlabel,viewtype,detailtable from workflow_billfield where billid="+formid+" and id="+tempfieldid+"");
                if(rs4.next()) {
                    PageFieldNamestr = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
                    viewtype = rs4.getString("viewtype") ;
                    detailtable = rs4.getString("detailtable") ;
                    if(viewtype.equals("0")){
                        ptabfix = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
                    }else{
                        ptabfix = SystemEnv.getHtmlLabelName(19325,user.getLanguage()) ;
                        rs3.executeSql("select orderid from workflow_billdetailtable where tablename='"+detailtable+"' and billid="+formid);
                        if(rs3.next()){
                            ptabfix += WfDataSource.getNewGroupid(formid,rs3.getInt(1));
                        }
                    }
                }
                
            }
            
        }catch(Exception e){
        }
        if(!ptabfix.equals("")) ptabfix += ".";
        jsonObject.put("label", ptabfix+PageFieldNamestr);
        jsonObject.put("type", "browser");
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        String DBFieldName = Util.null2String(rs.getString("DBFieldName"));
        jsonObject.put("name", "parafieldname"+index+secIndex);
        String TableID = rs.getString("TableID");
        String parafieldnamespan = DBFieldName;
        String FieldTableName = "";
        String FieldTableFormId = "";
        //if(parafieldnamespan.equals("requestid")) parafieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
        //if(parafieldnamespan.equals("id")) parafieldnamespan = SystemEnv.getHtmlLabelName(563,user.getLanguage())+"ID";
        String tablefix = "";
        String aliasname = "";
        rs4.executeSql("select TableName,FormId,alias from Workflow_DataInput_table where id="+TableID);
        if(rs4.next()){
            FieldTableName = rs4.getString("TableName");
            FieldTableFormId = Util.null2String(rs4.getString("FormId"));
            aliasname = Util.null2String(rs4.getString("alias"));
            if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) {
                FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
            }
        }
        
        String tablenamespan = "";
        if(datasourcename.trim().equals("")){
            if(parafieldnamespan.equals("requestid")) parafieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
            if(parafieldnamespan.equals("id")) parafieldnamespan = SystemEnv.getHtmlLabelName(563,user.getLanguage())+"ID";
            if(!"".equals(FieldTableFormId)&&!"0".equals(FieldTableFormId)){
                if(FieldTableFormId.indexOf("_") < 0){
                    rs3.executeSql("select formname from workflow_formbase where id="+FieldTableFormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    String tempFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
                    String tempGroupId = FieldTableFormId.substring(FieldTableFormId.indexOf("_")+1,FieldTableFormId.length());
                    rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
                    int detailIndex = 0;
                    while(rs3.next()){
                        detailIndex++;
                        if(rs3.getString("groupId").equals(tempGroupId)) break;
                    }
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
                }
            }else{
                if("".equals(FieldTableFormId)) FieldTableFormId="0";
                rs3.executeSql("select namelabel from workflow_bill where tablename='"+FieldTableName+"'");
                if(rs3.next()){
                    tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+FieldTableName+"'");
                    if(rs3.next()){
                        if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
                        if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
                        tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                    }else{
                        rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+FieldTableName+"'");
                        if(rs3.next()){
                            String tempBillId = rs3.getString("billid");
                            rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                            }
                            rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId+" order by orderid");
                            int detailIndex = 0;
                            while(rs3.next()){
                                detailIndex++;
                                String tempTableName = rs3.getString("tablename");
                                if(tempTableName.equals(FieldTableName)) break;
                            }
                            tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
                        }else{
                            rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+FieldTableName+"'");
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                                tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
                            }
                        }
                    }
                }
            }
        }
        
        if(datasourcename.trim().equals("")&&!parafieldnamespan.equals("requestid")){
            if(FieldTableName.equals("workflow_form")||FieldTableName.equals("workflow_formdetail")){
                if(FieldTableName.equals("workflow_form"))
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
                else
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
                if(rs4.next()) parafieldnamespan = Util.null2String(rs4.getString("fieldlable"));
            }else{
            	int _billid = 0;
                String maintable = "";
                String detailtable = "";
                rs4.executeSql("select id,tablename,detailtablename from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"'");
                if(rs4.next()){
                    _billid = Util.getIntValue(rs4.getString(1),0);
                    maintable = Util.null2String(rs4.getString(2));
                    detailtable = Util.null2String(rs4.getString(3));
                }
                int _isdetail = 0 ;
                if(maintable.equalsIgnoreCase(FieldTableName)){
                    _isdetail = 0 ;
                }else{
                    _isdetail = 1 ;
                }
                rs4.executeSql("select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
                if(rs4.next()){
                    _billid = Util.getIntValue(rs4.getString(1),0);
                    _isdetail = 1 ;
                }
                //rs4.executeSql("select id from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"' union select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
                if(_billid!=0){
                    if(_isdetail!=1){
                        rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=0");
                    }else{
                        rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=1 and detailtable='"+FieldTableName+"'");
                    }
                    if(rs4.next()) parafieldnamespan = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
                }else{
                    rs4.executeSql("select id from Sys_tabledict where tablename='"+FieldTableName+"'");
                    if(rs4.next()){
                        rs4.executeSql("select fielddesc,fielddescen from Sys_fielddict where fieldname='"+DBFieldName+"' and tabledictid="+rs4.getInt("id"));
                        if(rs4.next()){
                            if(user.getLanguage()==7) parafieldnamespan = rs4.getString("fielddesc");
                            if(user.getLanguage()==8) parafieldnamespan = rs4.getString("fielddescen");
                        }
                    }
                }
            }
        }
        
        if(aliasname.equals("")){
            if(tablenamespan.equals("")||tablenamespan.equalsIgnoreCase("null")){
                tablefix = FieldTableName+".";
            }else{
                tablefix = tablenamespan+".";
            }
        }else{
            tablefix = aliasname+"." ;
        }
        jsonObject.put("value", ("".equals(aliasname)?"":aliasname+".")+DBFieldName);
        jsonObject.put("label",tablefix + parafieldnamespan);
        jsonObject.put("type", "browser");
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "parafieldtablename"+index+secIndex);
        jsonObject.put("value", FieldTableName);
        jsonObject.put("type", "input");
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "pfieldindex"+index+secIndex);
        jsonObject.put("value", isdetail);
        jsonObject.put("type", "input");
        jsonObject.put("iseditable", "false");
        jsonArray.put(jsonObject);
        
        ajaxData.put(jsonArray);
    }
    out.println(ajaxData.toString());
  }else if(src.equalsIgnoreCase("getEvaluatewfField")){//字段联动中获取赋值参数

    String dataInputID = Util.null2String(request.getParameter("dataInputID"));
    String index = Util.null2String(request.getParameter("index"));
    String secIndex = Util.null2String(request.getParameter("secIndex"));
    String entryID = Util.null2String(request.getParameter("entryID"));
    
    String formid = WorkflowComInfo.getFormId(id);
    String isbill = WorkflowComInfo.getIsBill(id);
    if(formid.equals("")||isbill.equals("")){
        rs1.executeSql("select formid,isbill from workflow_base where id="+id );
        if(rs1.next()){
            formid = Util.null2String(rs1.getString("formid"));
            isbill = Util.null2String(rs1.getString("isbill"));
        }
    }
    String sql = "select * from workflow_dataInput_main where id="+dataInputID;
    rs.executeSql(sql);
    String datasourcename = "";
    if(rs.next()){
        datasourcename = Util.null2String(rs.getString("datasourcename"));
    }
    sql = "select a.*,b.alias from Workflow_DataInput_field a left join Workflow_DataInput_table b on a.tableid = b.id  where a.type=2 and a.DataInputID="+dataInputID;
    rs.executeSql(sql);
    JSONArray jsonArray=new JSONArray();
    JSONArray ajaxData=new JSONArray();
    RecordSet rs4 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    while(rs.next()){
        jsonArray=new JSONArray();
        String isdetail = rs.getString("pagefieldindex");
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("name", "id");
        jsonObject.put("value", Util.null2String(rs.getString("id")));
        jsonObject.put("type", "checkbox");
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "evaluatewfField"+index+secIndex);
        String PageFieldName = Util.null2String(rs.getString("PageFieldName"));
        String tempfieldid = PageFieldName.substring(5,PageFieldName.length()) ;
        String alias = Util.null2String(rs.getString("alias"));
        jsonObject.put("value", tempfieldid);
        
        String PageFieldNamestr = "";
        String ptabfix = "";
        try{
            
            if(isbill.equals("0")){
                if(isdetail.equals("0")){
                    ptabfix = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+formid+" and b.id="+tempfieldid+" and a.langurageid = "+user.getLanguage());
                    if(rs4.next()) {
                        PageFieldNamestr = Util.null2String(rs4.getString("fieldlable"));
                    }
                }else{
                    ptabfix = SystemEnv.getHtmlLabelName(19325,user.getLanguage()) ;
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+formid+" and b.id="+tempfieldid+" and a.langurageid = "+user.getLanguage());
                    if(rs4.next()) {
                        PageFieldNamestr = Util.null2String(rs4.getString("fieldlable"));
                    }
                    rs4.executeSql("select groupid from workflow_formfield where fieldid="+tempfieldid+" and formid="+formid+" and isdetail=1");
                    if(rs4.next()){
                        ptabfix += ""+(Util.getIntValue(rs4.getString(1),0)+1);
                    }
                }    
                
            }else{
                String viewtype = "";
                String detailtable = "";
                rs4.executeSql("select fieldlabel,viewtype,detailtable from workflow_billfield where billid="+formid+" and id="+tempfieldid+"");
                if(rs4.next()) {
                    PageFieldNamestr = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
                    viewtype = rs4.getString("viewtype") ;
                    detailtable = rs4.getString("detailtable") ;
                    if(viewtype.equals("0")){
                        ptabfix = SystemEnv.getHtmlLabelName(21778,user.getLanguage());
                    }else{
                        ptabfix = SystemEnv.getHtmlLabelName(19325,user.getLanguage()) ;
                        rs3.executeSql("select orderid from workflow_billdetailtable where tablename='"+detailtable+"' and billid="+formid);
                        if(rs3.next()){
                            ptabfix += WfDataSource.getNewGroupid(formid,rs3.getInt(1));
                        }
                    }
                }
            }
            
        }catch(Exception e){
        }
        if(!ptabfix.equals("")) ptabfix += ".";
        jsonObject.put("label", ptabfix+PageFieldNamestr);
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        String DBFieldName = Util.null2String(rs.getString("DBFieldName"));
        jsonObject.put("name", "evaluatefieldname"+index+secIndex);
        jsonObject.put("value", ("".equals(alias)?"":alias+".")+DBFieldName);
        String TableID = rs.getString("TableID");
        String parafieldnamespan = DBFieldName;
        String FieldTableName = "";
        String FieldTableFormId = "";
        
        String tablefix = "";
        String aliasname = "";
        rs4.executeSql("select TableName,FormId,alias from Workflow_DataInput_table where id="+TableID);
        if(rs4.next()){
            FieldTableName = rs4.getString("TableName");
            FieldTableFormId = Util.null2String(rs4.getString("FormId"));
            aliasname = Util.null2String(rs4.getString("alias"));
            if(!FieldTableFormId.equals("")&&FieldTableFormId.indexOf("_")>0) {
                FieldTableFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
            }
        }
        
        String tablenamespan = "";
        if(datasourcename.trim().equals("")){
            if(parafieldnamespan.equals("requestid")) parafieldnamespan = SystemEnv.getHtmlLabelName(648,user.getLanguage())+"ID";
            if(parafieldnamespan.equals("id")) parafieldnamespan = SystemEnv.getHtmlLabelName(563,user.getLanguage())+"ID";
            if(!"".equals(FieldTableFormId)&&!"0".equals(FieldTableFormId)){
                if(FieldTableFormId.indexOf("_") < 0){
                    rs3.executeSql("select formname from workflow_formbase where id="+FieldTableFormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    String tempFormId = FieldTableFormId.substring(0,FieldTableFormId.indexOf("_"));
                    String tempGroupId = FieldTableFormId.substring(FieldTableFormId.indexOf("_")+1,FieldTableFormId.length());
                    rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
                    int detailIndex = 0;
                    while(rs3.next()){
                        detailIndex++;
                        if(rs3.getString("groupId").equals(tempGroupId)) break;
                    }
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
                }
            }else{
                if("".equals(FieldTableFormId)) FieldTableFormId="0";
                rs3.executeSql("select namelabel from workflow_bill where tablename='"+FieldTableName+"'");
                if(rs3.next()){
                    tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+FieldTableName+"'");
                    if(rs3.next()){
                        if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
                        if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
                        tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                    }else{
                        rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+FieldTableName+"'");
                        if(rs3.next()){
                            String tempBillId = rs3.getString("billid");
                            rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                            }
                            rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId+" order by orderid asc");
                            int detailIndex = 0;
                            while(rs3.next()){
                                detailIndex++;
                                String tempTableName = rs3.getString("tablename");
                                if(tempTableName.equals(FieldTableName)) break;
                            }
                            tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+detailIndex+")";
                        }else{
                            rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+FieldTableName+"'");
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                                tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
                            }
                        }
                    }
                }
            }
        }

        if(datasourcename.trim().equals("")&&!parafieldnamespan.equals("requestid")){
            if(FieldTableName.equals("workflow_form")||FieldTableName.equals("workflow_formdetail")){
                if(FieldTableName.equals("workflow_form"))
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdict b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
                else
                    rs4.executeSql("select a.fieldlable from workflow_fieldlable a,workflow_formdictdetail b where a.langurageid="+user.getLanguage()+" and a.fieldid=b.id and a.formid="+FieldTableFormId+" and b.fieldname='"+DBFieldName+"' and a.langurageid = "+user.getLanguage());
                if(rs4.next()) parafieldnamespan = Util.null2String(rs4.getString("fieldlable"));
            }else{
                int _billid = 0;
                String maintable = "";
                String detailtable = "";
            	rs4.executeSql("select id,tablename,detailtablename from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"'");
            	if(rs4.next()){
            		_billid = Util.getIntValue(rs4.getString(1),0);
            		maintable = Util.null2String(rs4.getString(2));
            		detailtable = Util.null2String(rs4.getString(3));
            	}
            	int _isdetail = 0 ;
            	if(maintable.equalsIgnoreCase(FieldTableName)){
            		_isdetail = 0 ;
            	}else{
            		_isdetail = 1 ;
            	}
            	rs4.executeSql("select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
        		if(rs4.next()){
                    _billid = Util.getIntValue(rs4.getString(1),0);
                    _isdetail = 1 ;
                }
            	//rs4.executeSql("select id from workflow_bill where tablename='"+FieldTableName+"' or detailtablename='"+FieldTableName+"' union select billid as id from workflow_billdetailtable where tablename='"+FieldTableName+"'");
                if(_billid!=0){
                	if(_isdetail!=1){
                	    rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=0");
                	}else{
                		rs4.executeSql("select fieldlabel from workflow_billfield where billid="+_billid+" and fieldname='"+DBFieldName+"' and viewtype=1 and detailtable='"+FieldTableName+"'");
                	}
                    if(rs4.next()) parafieldnamespan = SystemEnv.getHtmlLabelName(rs4.getInt("fieldlabel"),user.getLanguage());
                }else{
                    rs4.executeSql("select id from Sys_tabledict where tablename='"+FieldTableName+"'");
                    if(rs4.next()){
                        rs4.executeSql("select fielddesc,fielddescen from Sys_fielddict where fieldname='"+DBFieldName+"' and tabledictid="+rs4.getInt("id"));
                        if(rs4.next()){
                            if(user.getLanguage()==7) parafieldnamespan = rs4.getString("fielddesc");
                            if(user.getLanguage()==8) parafieldnamespan = rs4.getString("fielddescen");
                        }
                    }
                }
            }
        }

        if(aliasname.equals("")){
            if(tablenamespan.equals("")||tablenamespan.equalsIgnoreCase("null")){
                tablefix = FieldTableName+".";
            }else{
                tablefix = tablenamespan+".";
            }
        }else{
            tablefix = aliasname+"." ;
        }
        
        jsonObject.put("label", tablefix + parafieldnamespan);
        jsonObject.put("type", "browser");
        jsonObject.put("iseditable", "true");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "evaluatefieldtablename"+index+secIndex);
        jsonObject.put("value", FieldTableName);
        jsonObject.put("iseditable", "true");
        jsonObject.put("type", "input");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "fieldindex"+index+secIndex);
        jsonObject.put("value", isdetail);
        jsonObject.put("type", "input");
        jsonObject.put("iseditable", "false");
        jsonArray.put(jsonObject);
        
        ajaxData.put(jsonArray);
    }
    
    out.println(ajaxData.toString());
  }else if(src.equalsIgnoreCase("getRelateTableInfo")){//获取引用数据库表
    String dataInputID = Util.null2String(request.getParameter("dataInputID"));
    String index = Util.null2String(request.getParameter("index"));
    String secIndex = Util.null2String(request.getParameter("secIndex"));
    String entryID = Util.null2String(request.getParameter("entryID"));
    String datasourcename = Util.null2String(request.getParameter("datasourcename"));
    RecordSet rs2 = new RecordSet();
    RecordSet rs3 = new RecordSet();
    rs2.executeSql("select * from Workflow_DataInput_table where DataInputID="+dataInputID+" order by id");
    JSONArray jsonArray=new JSONArray();
    JSONArray ajaxData=new JSONArray();
    while(rs2.next()){
        jsonArray=new JSONArray();
        String TableName = rs2.getString("TableName");
        String Alias = rs2.getString("Alias");
        String FormId = Util.null2String(rs2.getString("FormId"));
        String tablenamespan = "";
        if(datasourcename.trim().equals("")){
            if(!"".equals(FormId)&&!"0".equals(FormId)){
                if(FormId.indexOf("_") < 0){
                    rs3.executeSql("select formname from workflow_formbase where id="+FormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    String tempFormId = FormId.substring(0,FormId.indexOf("_"));
                    String tempGroupId = FormId.substring(FormId.indexOf("_")+1,FormId.length());
                    rs3.executeSql("select formname from workflow_formbase where id="+tempFormId);
                    if(rs3.next()) tablenamespan = rs3.getString("formname");
                    rs3.executeSql("select distinct groupId from workflow_formfield where formid="+tempFormId+" and isdetail=1 order by groupId");
                    int detailIndex = 0;
                    while(rs3.next()){
                        detailIndex++;
                        if(rs3.getString("groupId").equals(tempGroupId)) break;
                    }
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(detailIndex+1)+")";
                }
            }else{
                if("".equals(FormId))   FormId="0";
                rs3.executeSql("select namelabel from workflow_bill where tablename='"+TableName+"'");
                if(rs3.next()){
                    tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                    tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                }else{
                    rs3.executeSql("select tabledesc,tabledescen from Sys_tabledict where tablename='"+TableName+"'");
                    if(rs3.next()){
                        if(user.getLanguage()==7) tablenamespan = rs3.getString("tabledesc");
                        if(user.getLanguage()==8) tablenamespan = rs3.getString("tabledescen");
                        tablenamespan += "("+SystemEnv.getHtmlLabelName(21778,user.getLanguage())+")";
                    }else{
                        rs3.executeSql("select billid from Workflow_billdetailtable where tablename='"+TableName+"'");
                        if(rs3.next()){
                            String tempBillId = rs3.getString("billid");
                            rs3.executeSql("select namelabel from workflow_bill where id="+tempBillId);
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                            }
                            rs3.executeSql("select tablename from Workflow_billdetailtable where billid="+tempBillId+" order by orderid ");
                            int detailIndex = 0;
                            while(rs3.next()){
                                detailIndex++;
                                String tempTableName = rs3.getString("tablename");
                                if(tempTableName.equals(TableName)) break;
                            }
                            tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+(detailIndex)+")";
                        }else{
                            rs3.executeSql("select namelabel from workflow_bill where detailtablename='"+TableName+"'");
                            if(rs3.next()){
                                tablenamespan = SystemEnv.getHtmlLabelName(rs3.getInt("namelabel"),user.getLanguage());
                                tablenamespan += "("+SystemEnv.getHtmlLabelName(19325,user.getLanguage())+"1)";
                            }
                        }
                    }
                }
            }
        }
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("name", "id");
        jsonObject.put("iseditable", "true");
        jsonObject.put("value", Util.null2String(rs2.getString("id")));
        jsonObject.put("type", "checkbox");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "formid"+index+secIndex);
        jsonObject.put("value", FormId);
        jsonObject.put("iseditable", "true");
        jsonObject.put("label", tablenamespan);
        jsonObject.put("type", "browser");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "tablename"+index+secIndex);
        jsonObject.put("value", TableName);
        jsonObject.put("iseditable", "true");
        jsonObject.put("type", "input");
        jsonArray.put(jsonObject);
        
        jsonObject=new JSONObject();
        jsonObject.put("name", "tablebyname"+index+secIndex);
        jsonObject.put("value", Alias);
        jsonObject.put("iseditable", "true");
        jsonObject.put("type", "input");
        jsonArray.put(jsonObject);
        
        ajaxData.put(jsonArray);
    }
    
    out.println(ajaxData.toString());
    
  }else if(src.equals("edpstatus")){//启用/禁用过程定义
    String status = Util.null2String(request.getParameter("status"));
    String sql = "update workflow_processdefine set status="+status+" where id="+id;
    JSONObject jsonObject=new JSONObject();
    if(rs.executeSql(sql)){
        rs1.executeSql("select id,label from workflow_processdefine where id ="+id);
        if(rs1.next()){
            log.insSysLogInfo(user, rs1.getInt(1), rs1.getString(2), sql, "345", status.equals("0")?"25":"26", 0, request.getRemoteAddr());
        }
        jsonObject.put("result","1");
    }else{
        jsonObject.put("result","0");
    }
    out.println(jsonObject.toString());
  }else if(src.equals("delProcess")){//删除过程定义
    String sql = "delete from workflow_processdefine where  id in ("+id+") and isSys = 0";
    rs1.executeSql("select id,label from workflow_processdefine where id in("+id+") and isSys=0");
    JSONObject jsonObject=new JSONObject();
    if(rs.executeSql(sql)){
        while(rs1.next()){
            log.insSysLogInfo(user, rs1.getInt(1), rs1.getString(2), sql, "345", "3", 0, request.getRemoteAddr());
        }
        jsonObject.put("result","1");
    }else{
        jsonObject.put("result","0");
    }
    out.println(jsonObject.toString());
  }else if(src.equals("delProcessInst")){//删除常用批示语

    String sql = "delete from workflow_processinst where  id in ("+id+")";
    JSONObject jsonObject=new JSONObject();
    if(rs.executeSql(sql)){
        jsonObject.put("result","1");
    }else{
        jsonObject.put("result","0");
    }
    out.println(jsonObject.toString());
  }else if(src.equals("setProcessInstDefault")){//设置默认常用批示语

    int isdefault = Util.getIntValue(request.getParameter("isdefault"),0);
    String sql = "";
    String pdid = Util.null2String(request.getParameter("pdid"));
    if(isdefault==1){
        sql = "update workflow_processinst set isdefault=0 where pd_id="+pdid;
        rs.executeSql(sql);
    }
    sql = "update workflow_processinst set isdefault="+isdefault+" where id="+id;
    JSONObject jsonObject=new JSONObject();
    if(rs.executeSql(sql)){
        jsonObject.put("result","1");
    }else{
        jsonObject.put("result","0");
    }
    out.println(jsonObject.toString());
  }
  
%>