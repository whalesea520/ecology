<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.exchange.AutoCreateTable,org.apache.commons.lang3.*"%>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<%@page import="java.sql.Statement"%>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OutDataComInfo" class="weaver.workflow.exchange.rdata.OutDataComInfo" scope="page"/>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

Logger newlog = LoggerFactory.getLogger();
String operate = Util.null2String(request.getParameter("operate"));
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.fromScreen(request.getParameter("backto"),user.getLanguage());

if(operate.equals("edit")){
    String viewid = Util.null2String(request.getParameter("viewid"));//keyid
    
    String setname = Util.null2String(request.getParameter("setname"));//名称
    String workflowid = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    String outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
    String successback = Util.null2String(request.getParameter("successback"));//流程触发成功时回写设置
    String failback = Util.null2String(request.getParameter("failback"));//流程触发失败时回写设置
    String datarecordtype = "2";//Util.null2String(request.getParameter("datarecordtype"));//
    String keyfield = "id" ;//Util.null2String(request.getParameter("keyfield"));//
    String requestid = "requestid" ;//Util.null2String(request.getParameter("requestid"));//
    String FTriggerFlag = "FTriggerFlag" ;//Util.null2String(request.getParameter("FTriggerFlag"));//
    String FTriggerFlagValue = "1" ;//Util.null2String(request.getParameter("FTriggerFlagValue"));//
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String periodvalue = Util.null2String(request.getParameter("periodvalue"));//
    String status = Util.null2String(request.getParameter("status"));//
    String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
    
    String wftypeid = Util.null2String(request.getParameter("wftypeid"));
    String wfid = Util.null2String(request.getParameter("wfid"));
    String _subcomid = Util.null2String(request.getParameter("_subcomid"));
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + ",";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
    
    String oldworkflowid = "";
    RecordSet.executeSql("select workflowid from wfec_outdatawfset where id="+viewid);
    if(RecordSet.next()){
        oldworkflowid = RecordSet.getString("workflowid");
        if(!oldworkflowid.equals(workflowid)){
             //流程已变更，删除详细设置内容。
             RecordSet.executeSql("delete from wfec_outdatawfsetdetail where mainid="+viewid);
        }
    }
    
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    outermainwhere = Util.replace(outermainwhere,"'","''",0);
    successback = Util.replace(successback,"'","''",0);
    failback = Util.replace(failback,"'","''",0);
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    outerdetailwheres = Util.replace(outerdetailwheres,"'","''",0);
    keyfield = Util.replace(keyfield,"'","''",0);
    requestid = Util.replace(requestid,"'","''",0);
    FTriggerFlag = Util.replace(FTriggerFlag,"'","''",0);
    FTriggerFlagValue = Util.replace(FTriggerFlagValue,"'","''",0);
    String updateSql = "update wfec_outdatawfset set "+
                       "name='"+setname+"',typename='"+typename+"',"+
                       "workflowid='"+workflowid+"',"+
                       "outermaintable='"+outermaintable+"',"+
                       "outermainwhere='"+outermainwhere+"',"+
                       "successback='"+successback+"',"+
                       "failback='"+failback+"',"+
                       "outerdetailtables='"+outerdetailtables+"',"+
                       "outerdetailwheres='"+outerdetailwheres+"',"+
                       "keyfield='"+keyfield+"',"+
                       "requestid='"+requestid+"',"+
                       "FTriggerFlag='"+FTriggerFlag+"',"+
                       "datasourceid='"+datasourceid+"', "+
                       "datarecordtype='"+datarecordtype+"', "+
                       "FTriggerFlagValue='"+FTriggerFlagValue+"',periodvalue="+Util.getIntValue(periodvalue,1)+",status="+Util.getIntValue(status,0)+
                       " ,subcompanyid="+Util.getIntValue(subcompanyid,0) +
                       " where id="+viewid;
    //System.out.println("updateSql=="+updateSql);
    RecordSet.executeSql(updateSql);
    OutDataComInfo.updateOutDataInfoCache(viewid);
    RecordSet.executeSql("select id,name,workflowid from wfec_outdatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"基础信息");
    SysMaintenanceLog.setOperateItem("200"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		//window.parent.document.location.href="/workflow/exchange/rdata/automaticsettingTab.jsp?_fromURL=1&typename=<%=typename%>&viewid=<%=viewid%>&backto=<%=backto%>";
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab.jsp?_fromURL=1&isclose=2&mainid=<%=viewid%>&wfid=<%=wfid%>&wftypeid=<%=wftypeid%>&subcompanyid=<%=_subcomid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equals("adddetail")){
	String viewid = Util.null2String(request.getParameter("viewid"));//keyid 
    int detailcount = Util.getIntValue(request.getParameter("detailcount"),0);
    try{
    //处理主表记录
    int maintablerows = Util.getIntValue(Util.null2String(request.getParameter("maintablerows")),0);//主表总记录数
    String maindeleterow = Util.null2String(request.getParameter("maindeleterow"));
    String mainaddrows = Util.null2String(request.getParameter("mainaddrows"));
    ArrayList maindelarray = Util.TokenizerString(maindeleterow,",");
    if(maindelarray.size()>0){
    	RecordSet.executeSql("delete from wfec_outdatasetdetail  where mainid="+viewid+" and id in ("+StringUtils.join(maindelarray,",")+")");//先删除
    }
    //System.out.println("maintablerows = "+maintablerows);
    for(int i = 0 ; i < maintablerows ; i++){
    	int id = Util.getIntValue(Util.null2String(request.getParameter("id_"+i)),-1);
    	
    	int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid_"+i)),0);
        String wffieldname = Util.null2String(request.getParameter("fieldname_"+i));
        String htmltype = Util.null2String(request.getParameter("fieldtype_"+i));
        int wffieldhtmltype = 1 ;
        int wffieldtype = 1 ;
        if(!htmltype.equals("")){
        	wffieldhtmltype = Util.getIntValue(htmltype.split("_")[0]);
        	wffieldtype = Util.getIntValue(htmltype.split("_")[1]);
        }
        String wffielddbtype = Util.null2String(request.getParameter("fielddbtype_"+i));
        String outerfieldname = Util.null2String(request.getParameter("outerfieldname_"+i));
        String outfielddbtype = Util.null2String(request.getParameter("outfieldtype_"+i));
        int changetype = Util.getIntValue(Util.null2String(request.getParameter("rulesopt_"+i)),0);
        String customstr = Util.null2String(request.getParameter("customstr_"+i));
        String customhrm = Util.null2String(request.getParameter("chrmid_"+i+"_"+i));
        String customsql = "" ;
        String customtxt = "";
    	if(wffieldname.equals("")||wffieldid==0){
    		continue ;
    	}
    	if(changetype==6) customsql = customstr ;
    	if(changetype==9) customtxt = customstr ;
    	if(changetype==9 && htmltype.equals("3_1")){
    		customtxt = customhrm ;
    	}
    	if(id==-1){
    		String insertSql = "insert into wfec_outdatasetdetail("+
            "mainid,"+
            "wffieldid,"+
            "wffieldname,"+
            "wffieldhtmltype,"+
            "wffieldtype,"+
            "wffielddbtype,"+
            "outerfieldname,"+
            "changetype,"+
            "customsql,customtxt,detailindex,outfielddbtype) values("+
            viewid+","+
            wffieldid+","+
            "'"+wffieldname+"',"+
            wffieldhtmltype+","+
            wffieldtype+","+
            "'"+wffielddbtype+"',"+
            "'"+outerfieldname+"',"+
            changetype+",'" +customsql+"','"+customtxt+"',0,'"+outfielddbtype+"')";
            
			RecordSet.executeSql(insertSql);
    	}else{
    		if(!maindelarray.contains(id+"")){
    			String updatesql = "update wfec_outdatasetdetail set "+
                "wffieldid = "+wffieldid+","+
                "wffieldname = '"+wffieldname+"',"+
                "wffieldhtmltype = "+wffieldhtmltype+","+
                "wffieldtype = "+wffieldtype+","+
                "wffielddbtype='"+wffielddbtype+"',"+
                "outerfieldname = '"+outerfieldname+"',outfielddbtype='"+outfielddbtype+"',"+
                "changetype="+changetype+","+
                "customsql='"+customsql+"',customtxt='"+customtxt+"' where id="+id;
    			RecordSet.executeSql(updatesql);
    		}
    	}
    }
    
    for(int j = 0 ; j < detailcount ; j++ ){
    	int dttablerows = Util.getIntValue(Util.null2String(request.getParameter("dt"+j+"tablerows")),0);//主表总记录数
        String dtdeleterow = Util.null2String(request.getParameter("dt"+j+"deleterow"));
        String dtaddrows = Util.null2String(request.getParameter("dt"+j+"addrows"));
        String dttableaname = Util.null2String(request.getParameter("dt"+j+"tableaname"));
        ArrayList dtdelarray = Util.TokenizerString(dtdeleterow,",");
        if(maindelarray.size()>0){
        	RecordSet.executeSql("delete from wfec_outdatasetdetail  where mainid="+viewid+" and id in ("+StringUtils.join(dtdelarray,",")+")");//先删除
        }
        //System.out.println("dttablerows = "+dttablerows+" dtdeleterow = "+dtdeleterow);
        for(int i = 0 ; i < dttablerows ; i++){
        	String tempid = Util.null2String(request.getParameter("id"+j+"_"+i));
        	int id = Util.getIntValue(tempid);
        	int wffieldid = Util.getIntValue(request.getParameter("fieldid"+j+"_"+i),0);
            String wffieldname = Util.null2String(request.getParameter("fieldname"+j+"_"+i));
            String htmltype = Util.null2String(request.getParameter("fieldtype"+j+"_"+i));
            //int wffieldhtmltype = Util.getIntValue(Util.null2String(htmltype.split("_")[0]));
            //int wffieldtype = Util.getIntValue(Util.null2String(htmltype.split("_")[1]));
            int wffieldhtmltype = 1 ;
            int wffieldtype = 1 ;
            if(!htmltype.equals("")){
            	wffieldhtmltype = Util.getIntValue(htmltype.split("_")[0]);
            	wffieldtype = Util.getIntValue(htmltype.split("_")[1]);
            }
            String wffielddbtype = Util.null2String(request.getParameter("fielddbtype"+j+"_"+i));
            String outerfieldname = Util.null2String(request.getParameter("outerfieldname"+j+"_"+i));
            String outfielddbtype = Util.null2String(request.getParameter("outfieldtype"+j+"_"+i));
            int changetype = Util.getIntValue(Util.null2String(request.getParameter("rulesopt"+j+"_"+i)),0);
            String customstr = Util.null2String(request.getParameter("customstr"+j+"_"+i));
            String customhrm = Util.null2String(request.getParameter("chrmid"+j+"_"+i+"_"+i));
            String customsql = "" ;
            String customtxt = "";
            //System.out.println("outerfieldname = "+outerfieldname+"  wffieldid = "+wffieldid+"  htmltype"+j+"_"+i+" = "+htmltype);
        	if(wffieldid==0||wffieldname.equals("")){
        		continue ;
        	}
        	if(!outerfieldname.equals("")){
        		outerfieldname = dttableaname+"."+outerfieldname ;
        	}
        	if(changetype==6) customsql = customstr ;
        	if(changetype==9) customtxt = customstr ;
        	if(changetype==9 && htmltype.equals("3_1")){
        		customtxt = customhrm ;
        	}
        	if(id==-1){
        		String insertSql = "insert into wfec_outdatasetdetail("+
                "mainid,"+
                "wffieldid,"+
                "wffieldname,"+
                "wffieldhtmltype,"+
                "wffieldtype,"+
                "wffielddbtype,"+
                "outerfieldname,"+
                "changetype,"+
                "customsql,customtxt,detailindex,outfielddbtype) values("+
                viewid+","+
                wffieldid+","+
                "'"+wffieldname+"',"+
                wffieldhtmltype+","+
                wffieldtype+","+
                "'"+wffielddbtype+"',"+
                "'"+outerfieldname+"',"+
                changetype+",'" +customsql+"','"+customtxt+"',"+(j+1)+",'"+outfielddbtype+"')";
                //System.out.println(insertSql);
    			RecordSet.executeSql(insertSql);
        	}else{
        		if(!maindelarray.contains(id+"")){
        			String updatesql = "update wfec_outdatasetdetail set "+
                    " wffieldid = "+wffieldid+","+
                    " wffieldname = '"+wffieldname+"',"+
                    " wffieldhtmltype = "+wffieldhtmltype+","+
                    " wffieldtype = "+wffieldtype+","+
                    " wffielddbtype='"+wffielddbtype+"',"+
                    " outerfieldname = '"+outerfieldname+"', outfielddbtype='"+outfielddbtype+"',"+
                    " changetype="+changetype+","+
                    " customsql='"+customsql+"',customtxt='"+customtxt+"' where id="+id;
        			RecordSet.executeSql(updatesql);
        			//System.out.println("修改数据"+id+"  >>"+updatesql);
        		}
        		
        	}
        }
    
    }
    }catch(Exception e){
        newlog.error(e);
    	e.printStackTrace();
    }
    //处理明细表记录

    RecordSet.executeSql("select id,name,workflowid from wfec_outdatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+" 字段对应关系");
    SysMaintenanceLog.setOperateItem("200"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		//window.parent.document.location.href="/workflow/exchange/rdata/automaticsettingTab.jsp?_fromURL=1&typename=<%=typename%>&viewid=<%=viewid%>&backto=<%=backto%>";
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab.jsp?_fromURL=2&mainid=<%=viewid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equalsIgnoreCase("saveActionList")){//保存动作列表
	weaver.workflow.action.WorkflowActionManager workflowActionManager = new weaver.workflow.action.WorkflowActionManager();
	
	int rowNum = Util.getIntValue(request.getParameter("rowNum"),-1);
	int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
	
  	String deleteRows = Util.null2String(request.getParameter("actiondeleterows"));
  	int allRows = Util.getIntValue(request.getParameter("allrows"));
  	String addRows = Util.null2String(request.getParameter("addrows"));
  	
  	ArrayList deleteids = Util.TokenizerString(deleteRows,",");
  	//首先删除记录
  	try{
  		for(int i = 0 ; i < deleteids.size() ;i++){
  	  		int actionId = Util.getIntValue(deleteids.get(i).toString(),0) ;
  	  		RecordSet.executeSql("select * from workflowactionset where id="+actionId);
  	  		RecordSet.next();
  	  		workflowActionManager.setActionid(actionId);
  			workflowActionManager.setWorkflowid(workflowid);
  			workflowActionManager.setNodeid(Util.getIntValue(RecordSet.getString("nodeid"),0));
  			workflowActionManager.setNodelinkid(Util.getIntValue(RecordSet.getString("nodelinkid"),0));
  			workflowActionManager.setIspreoperator(Util.getIntValue(RecordSet.getString("ispreoperator"),0));
  			workflowActionManager.doDeleteWsAction(actionId);
  	  	}
  	
  	for(int i=0;i < allRows ; i++){
  		int actionId = Util.getIntValue(request.getParameter("actionChecbox_"+i),0);
		String sqltmp = "";
		//System.out.println(actionId);
		if(deleteids.indexOf(actionId)!=-1){
			continue ;
		}
  		if(actionId>0||actionId==-1){
  			String customervalue = Util.null2String(request.getParameter("customervalue_"+i));
  			String actionname = "";
  			RecordSet.executeSql("select actionshowname from actionsetting where actionname='"+customervalue+"'");
  			if(RecordSet.next()){
  				actionname = RecordSet.getString("actionshowname");
  			}
  			String isnode = Util.null2String(request.getParameter("isnode_"+i));
  			String objid = Util.null2String(request.getParameter("objid_"+i)).trim();
  			String isused = Util.null2String(request.getParameter("isused_"+i));
  			
  			
  			int nodeid = 0 ;
  			int nodelinkid = 0 ;
  			int ispreoperator = 0 ;
  			if(isnode.equals("1")){
  				nodeid = Util.getIntValue(objid,0);
  			}else{
  				nodelinkid = Util.getIntValue(objid,0);
  			}
  			workflowActionManager.setActionid(actionId);
			workflowActionManager.setWorkflowid(workflowid);
			workflowActionManager.setNodeid(nodeid);
			workflowActionManager.setActionorder(0);
			workflowActionManager.setNodelinkid(nodelinkid);
			workflowActionManager.setIspreoperator(ispreoperator);
			workflowActionManager.setActionname(actionname);
			workflowActionManager.setInterfaceid(customervalue);
			workflowActionManager.setInterfacetype(3);
			workflowActionManager.setIsused(Util.getIntValue(isused,0));
			
			workflowActionManager.doSaveWsAction();
			
  		}
  	}
  	
  	out.println("1");
  	}catch(Exception e){
  	  newlog.error(e);
  		e.printStackTrace();
  	}
}else if(operate.equalsIgnoreCase("createtable")){
	int tableid = -1 ;
	String viewid = Util.null2String(request.getParameter("viewid"));//keyid 
	String setname = Util.null2String(request.getParameter("setname"));//名称
    String workflowid = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    String outermainwhere = Util.null2String(request.getParameter("outermainwhere"));//外部主表条件
    String successback = Util.null2String(request.getParameter("successback"));//流程触发成功时回写设置
    String failback = Util.null2String(request.getParameter("failback"));//流程触发失败时回写设置
    String datarecordtype = Util.null2String(request.getParameter("datarecordtype"));//
    String keyfield = Util.null2String(request.getParameter("keyfield"));//
    String requestid = Util.null2String(request.getParameter("requestid"));//
    String FTriggerFlag = Util.null2String(request.getParameter("FTriggerFlag"));//
    String FTriggerFlagValue = Util.null2String(request.getParameter("FTriggerFlagValue"));//
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String periodvalue = Util.null2String(request.getParameter("periodvalue"));//
    String status = Util.null2String(request.getParameter("status"));//
    String changetype = Util.null2String(request.getParameter("changetype"));//
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    ArrayList detailtablelist = new ArrayList();
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        detailtablelist.add(tempouterdetailname);
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + ",";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
   	
    //删除历史数据
    ArrayList<String> tableids = new ArrayList<String>();
    RecordSet.executeSql("select id from wfec_tablelist where changetype=0 and rid="+viewid);
    while(RecordSet.next()){
    	tableids.add(RecordSet.getString(1));
    }
    for(String _tableid : tableids){
    	RecordSet.executeSql("delete from wfec_tablelist where id="+_tableid);
    	RecordSet.executeSql("delete from wfec_tablefield where tableid="+_tableid);
    }
    AutoCreateTable act = new AutoCreateTable();
    ArrayList<ArrayList<String>> workflowfieldinfos = act.getWorkflowFieldInfo(workflowid);
    act.setRid(viewid);
    act.setDatasource(datasourceid);
    act.setType(changetype);
    ArrayList outerdetailtableslist = new ArrayList();
    //if(!outermaintable.equals("")){
    	tableid = act.createTableInfo(0,"",outermaintable,0,workflowid,0,workflowfieldinfos.get(0));
    	outermaintable = act.getTablename() ;
    	if(!outermaintable.equals("")){
	    	for(int i = 0 ;i<detailtablelist.size();i++){
	    		String tempdttablename = detailtablelist.get(i).toString();
	    		if(tempdttablename.equals("-")){
	    			tempdttablename = "";
	    		}
	    		int dttableid =act.createTableInfo(tableid,outermaintable,tempdttablename,1,workflowid,i+1,workflowfieldinfos.get(i+1)); 
	    		tempdttablename= act.getTablename() ;
	    		outerdetailtableslist.add(tempdttablename);
	    	}
    	}
    	
    //}
    outerdetailtables = StringUtils.join(outerdetailtableslist,",");
   //
    String oldworkflowid = "";
    RecordSet.executeSql("select workflowid from wfec_outdatawfset where id="+viewid);
    if(RecordSet.next()){
        oldworkflowid = RecordSet.getString("workflowid");
        if(!oldworkflowid.equals(workflowid)){
             //流程已变更，删除详细设置内容。
             RecordSet.executeSql("delete from wfec_outdatawfsetdetail where mainid="+viewid);
        }
    }
	outerdetailwheres="";
	for(int k = 0 ; k < outerdetailtableslist.size();  k++){
		String _tempdttablename = outerdetailtableslist.get(k).toString();
		outerdetailwheres += _tempdttablename+".mainid = "+outermaintable+".id," ;
	}
    
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    outermainwhere = Util.replace(outermainwhere,"'","''",0);
    successback = Util.replace(successback,"'","''",0);
    failback = Util.replace(failback,"'","''",0);
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    outerdetailwheres = Util.replace(outerdetailwheres,"'","''",0);
    keyfield = Util.replace(keyfield,"'","''",0);
    requestid = Util.replace(requestid,"'","''",0);
    FTriggerFlag = Util.replace(FTriggerFlag,"'","''",0);
    FTriggerFlagValue = Util.replace(FTriggerFlagValue,"'","''",0);
    String updateSql = "update wfec_outdatawfset set "+
                       "name='"+setname+"',typename='"+typename+"',"+
                       "workflowid='"+workflowid+"',"+
                       "outermaintable='"+outermaintable+"',"+
                       "outermainwhere='"+outermainwhere+"',"+
                       "successback='"+successback+"',"+
                       "failback='"+failback+"',"+
                       "outerdetailtables='"+outerdetailtables+"',"+
                       "outerdetailwheres='"+outerdetailwheres+"',"+
                       "keyfield='"+keyfield+"',"+
                       "requestid='"+requestid+"',"+
                       "FTriggerFlag='"+FTriggerFlag+"',"+
                       "datasourceid='"+datasourceid+"', "+
                       "datarecordtype='"+datarecordtype+"', "+
                       "FTriggerFlagValue='"+FTriggerFlagValue+"',periodvalue="+Util.getIntValue(periodvalue,1)+",status="+Util.getIntValue(status,0)+
                       "where id="+viewid;
    //System.out.println("updateSql=="+updateSql);
    RecordSet.executeSql(updateSql);
    RecordSet.executeSql("select id,name,workflowid from wfec_outdatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"基础信息");
    SysMaintenanceLog.setOperateItem("200"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		//window.parent.document.location.href="/workflow/exchange/rdata/automaticsettingTab.jsp?_fromURL=1&typename=<%=typename%>&viewid=<%=viewid%>&backto=<%=backto%>";
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab.jsp?_fromURL=1&mainid=<%=viewid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equals("savetablefield")){
	ExchangeUtil exu = new ExchangeUtil();
	String viewid = Util.null2String(request.getParameter("viewid"));
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	java.sql.Connection conn = null ;
	Statement stat = null ;
	try{
	conn = exu.getConnection(datasourceid);
	stat = conn.createStatement() ;
	int maintablerows = Util.getIntValue(request.getParameter("maintablerows"));
	String maintabledelrow = Util.null2String(request.getParameter("maindeleterow"));
	String maintableaddrow = Util.null2String(request.getParameter("mainaddrows"));
	String maintableid = Util.null2String(request.getParameter("maintableid"));
	String maintablename = Util.null2String(request.getParameter("maintablename"));
	ArrayList mainaddrows = Util.TokenizerString(maintableaddrow,",");
	for(int i = 0 ; i < mainaddrows.size() ; i++){
		int idx = Util.getIntValue(mainaddrows.get(i).toString());
		String fieldChecbox = Util.null2String(request.getParameter("fieldChecbox_"+idx));
		//System.out.println("idx = "+idx);
		if(idx>0){
			String dbname = Util.null2String(request.getParameter("dbname_"+(idx-1)));
			String type = Util.null2String(request.getParameter("type_"+(idx-1)));
			String dbtype = Util.null2String(request.getParameter("dbtype_"+(idx-1)));
			if(!dbname.equals("")){
				//TOOD 这里需要修改。。
				exu.InsertTableField(stat,maintableid,maintablename,dbname,type,dbtype,0);
			}
		}
	}
	if(!maintabledelrow.equals("")){
		//System.out.println("maintabledelrow = "+maintabledelrow);
		exu.DropTableFieldBatch(stat,maintablename,maintabledelrow);
	}
	
	int dtcount = Util.getIntValue(request.getParameter("dtcount"));//明细数
	//System.out.println("dtcount = "+dtcount);
	ArrayList dt_addrowslist = new ArrayList();
	for(int i = 0 ; i < dtcount ; i++){
		dt_addrowslist.clear() ;
		int dt_rows = Util.getIntValue(request.getParameter("dt"+i+"_tablerows"));
		String dt_delrows = Util.null2String(request.getParameter("dt"+i+"_deleterow"));
		String dt_addrows = Util.null2String(request.getParameter("dt"+i+"_addrow"));
		//System.out.println("i="+i+" dt_delrows = "+dt_delrows+"  dt_rows = "+dt_rows);
		String dttableid = Util.null2String(request.getParameter("dt"+i+"_tableid"));
		String dttablename = Util.null2String(request.getParameter("dt"+i+"_tablename"));
		dt_addrowslist = Util.TokenizerString(dt_addrows,",");
		//System.out.println("i="+i+" dt_addrowslist = "+dt_addrowslist.size());
		for( int j = 0 ; j < dt_addrowslist.size() ; j++ ){
			int idx = Util.getIntValue(dt_addrowslist.get(j).toString());
			String dbname = Util.null2String(request.getParameter("dt"+i+"_dbname_"+(idx-1)));
			String type = Util.null2String(request.getParameter("dt"+i+"_type_"+(idx-1)));
			String dbtype = Util.null2String(request.getParameter("dt"+i+"_dbtype_"+(idx-1)));
			if(!dbname.equals("")){
				//TODO 这里需要修改
				//System.out.println("i="+i+" dttableid = "+dttableid+" dttablename="+dttablename+" dbname = "+dbname+" type = "+type);
				exu.InsertTableField(stat,dttableid,dttablename,dbname,type,dbtype,0);
				
			}
		}
		
		if(!dt_delrows.equals("")){
			exu.DropTableFieldBatch(stat,dttablename,dt_delrows);
		}
	}
	}catch(Exception e){
	    newlog.error(e);
	}finally{
		try{
			if(stat!=null){
				stat.close();
			}
		}catch(Exception e){
		    newlog.error(e);
		}
		try{
			if(conn!=null){
				conn.close();
			}
		}catch(Exception e){
		    newlog.error(e);
		}
		RecordSet.executeSql("select id,name,workflowid from wfec_outdatawfset where id="+viewid );
		RecordSet.next();
		String title = RecordSet.getString("name");
		SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
	    SysMaintenanceLog.setRelatedName(title);
	    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
	    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+" 数据表字段");
	    SysMaintenanceLog.setOperateItem("200"); //type =1 
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	}
	%>
    <script language=javascript >
    try
    {
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab.jsp?_fromURL=3&mainid=<%=viewid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equals("delete")){
	String viewid = Util.null2String(request.getParameter("viewid"));//keyid	
  	RecordSet.executeSql("select id,name,workflowid from wfec_outdatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	String wfid = RecordSet.getString("workflowid");
	String wftypeid = Util.null2String(request.getParameter("wftypeid"));//WorkflowComInfo.getWorkflowtype(wfid);
	try{
	    RecordSet.executeSql("delete from wfec_outdatawfset where id="+viewid+"");
	    RecordSet.executeSql("delete from wfec_outdatasetdetail where mainid="+viewid);
	    RecordSet.executeSql("delete from wfec_outdatawfdetail where mainid="+viewid);
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
	    SysMaintenanceLog.setRelatedName(title);
	    SysMaintenanceLog.setOperateType("3");//1 new  2:eidt 3:del
	    SysMaintenanceLog.setOperateDesc("删除"+typename+"设置："+title);
	    SysMaintenanceLog.setOperateItem("200"); //type =1 
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	   // out.println("1");
	}catch(Exception e){
	    newlog.error(e);
		//out.println("0");
	}
	%>
    <script language=javascript >
    try
    {
		//window.parent.parent.document.location.href="/workflow/exchange/managelist.jsp?reflush=1" ;
		//if(window.parent.parent.document.getElementById("mainFrame")){
		//}else{
		//console.log("AAAAAAAABBBBBBBBBBBBBBBBBBB");
		//}
		window.parent.location.href = "/workflow/exchange/ExchangeSetTab.jsp?isclose=1&wftypeid=<%=wftypeid %>";
	}
	catch(e)
	{
	}
	</script>
    <%
}
%>