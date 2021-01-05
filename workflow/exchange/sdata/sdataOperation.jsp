<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,java.sql.*,weaver.workflow.automatic.automaticconnect" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.exchange.AutoCreateTable,org.apache.commons.lang3.*"%>
<%@page import="weaver.workflow.exchange.ExchangeUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(!HrmUserVarify.checkUserRight(ExchangeUtil.WFEC_SETTING_RIGHTSTR,user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operate = Util.null2String(request.getParameter("operate"));
String typename = Util.null2String(request.getParameter("typename"));
String backto = Util.fromScreen(request.getParameter("backto"),user.getLanguage());

if(operate.equals("edit")){
    String viewid = Util.null2String(request.getParameter("viewid"));//keyid
    
    String setname = Util.null2String(request.getParameter("setname"));//名称
    String workflowid = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));//外部主表
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量    
    String status = Util.null2String(request.getParameter("status"));//
    String outerdetailtables = "";//外部明细表集合
    
    String wftypeid = Util.null2String(request.getParameter("wftypeid"));
    String wfid = Util.null2String(request.getParameter("wfid"));
    String _subcomid = Util.null2String(request.getParameter("_subcomid"));
    
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailtable"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
        }else{
            outerdetailtables += tempouterdetailname;
        }
    }
    
    String oldworkflowid = "";
    RecordSet.executeSql("select workflowid from wfec_indatawfset where id="+viewid);
    if(RecordSet.next()){
        oldworkflowid = RecordSet.getString("workflowid");
        if(!oldworkflowid.equals(workflowid)){
             //流程已变更，删除详细设置内容。
             //RecordSet.executeSql("delete from wfec_outdatawfsetdetail where mainid="+viewid);
        }
    }
    
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    String updateSql = "update wfec_indatawfset set "+
                       "name='"+setname+"', "+
                       "workflowid='"+workflowid+"',"+
                       "outermaintable='"+outermaintable+"',"+
                       "outerdetailtables='"+outerdetailtables+"',"+
                       "datasourceid='"+datasourceid+"', "+
                       "status="+Util.getIntValue(status,0)+",subcompanyid="+Util.getIntValue(subcompanyid,0)+
                       "where id="+viewid;
    if(status.equals("0")){
    	//要停止Action的操作
    }
    RecordSet.executeSql(updateSql);
    RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"基础信息");
    SysMaintenanceLog.setOperateItem("199"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab1.jsp?_fromURL=1&mainid=<%=viewid%>&isclose=2&wfid=<%=wfid%>&wftypeid=<%=wftypeid%>&subcompanyid=<%=_subcomid%>";
		//window.parent.location.href = "/workflow/exchange/ExchangeSetTab1.jsp?isclose=1&wftypeid=";
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equals("cbsetting")){
	String viewid = Util.null2String(request.getParameter("viewid"));//
	String iscallback = Util.null2String(request.getParameter("iscallback"));//
	String periodvalue = Util.null2String(request.getParameter("periodvalue"));//
	RecordSet.executeSql("update wfec_indatawfset set iscallback="+Util.getIntValue(iscallback,0)+",periodvalue="+Util.getIntValue(periodvalue,0)+" where id="+viewid);
	new weaver.workflow.exchange.sdata.InDataComInfo().updateResourceInfoCache(viewid);
	RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"回调信息");
    SysMaintenanceLog.setOperateItem("199"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
	 %>
    <script language=javascript >
    try
    {
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab1.jsp?_fromURL=6&mainid=<%=viewid%>";
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
    	RecordSet.executeSql("delete from wfec_indatasetdetail  where mainid="+viewid+" and id in ("+StringUtils.join(maindelarray,",")+")");//先删除
    }
    
    for(int i = 0 ; i < maintablerows ; i++){
    	int id = Util.getIntValue(Util.null2String(request.getParameter("id_"+i)),-1);
    	
    	int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid_"+i)),0);
        String wffieldname = Util.null2String(request.getParameter("fieldname_"+i));
        String htmltype = Util.null2String(request.getParameter("fieldtype_"+i));
        int wffieldhtmltype = 1 ;//Util.getIntValue(htmltype.split("_")[0]);
        int wffieldtype = 1 ;//Util.getIntValue(htmltype.split("_")[1]);
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
        //chrmid_2_2
    	if(outerfieldname.equals("")){
    		continue ;
    	}
    	if(changetype==6) customsql = customstr ;
    	if(changetype==9) customtxt = customstr ;
    	if(changetype==9&&htmltype.equals("3_1")){
    		customtxt = customhrm ;
    	}
    	if(id==-1){
    		String insertSql = "insert into wfec_indatasetdetail("+
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
    			String updatesql = "update wfec_indatasetdetail set "+
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
        	RecordSet.executeSql("delete from wfec_indatasetdetail  where mainid="+viewid+" and id in ("+StringUtils.join(dtdelarray,",")+")");//先删除
        }
        for(int i = 0 ; i < dttablerows ; i++){
        	String tempid = Util.null2String(request.getParameter("id"+j+"_"+i));
        	int id = Util.getIntValue(tempid);
        	int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid"+j+"_"+i)),0);
            String wffieldname = Util.null2String(request.getParameter("fieldname"+j+"_"+i));
            String htmltype = Util.null2String(request.getParameter("fieldtype"+j+"_"+i));
            //int wffieldhtmltype = Util.getIntValue(Util.null2String(htmltype.split("_")[0]));
            //int wffieldtype = Util.getIntValue(Util.null2String(htmltype.split("_")[1]));
            int wffieldhtmltype = 1 ;//Util.getIntValue(htmltype.split("_")[0]);
            int wffieldtype = 1 ;//Util.getIntValue(htmltype.split("_")[1]);
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
        	if(outerfieldname.equals("")){
        		continue ;
        	}
        	if(changetype==6) customsql = customstr ;
        	if(changetype==9) customtxt = customstr ;
        	if(changetype==9 && htmltype.equals("3_1")){
        		customtxt = customhrm ;
        	}
        	if(id==-1){
        		String insertSql = "insert into wfec_indatasetdetail("+
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
                "'"+dttableaname+"."+outerfieldname+"',"+
                changetype+",'" +customsql+"','"+customtxt+"',"+(j+1)+",'"+outfielddbtype+"')";
    			RecordSet.executeSql(insertSql);
        	}else{
        		if(!maindelarray.contains(id+"")){
        			String updatesql = "update wfec_indatasetdetail set "+
                    " wffieldid = "+wffieldid+","+
                    " wffieldname = '"+wffieldname+"',"+
                    " wffieldhtmltype = "+wffieldhtmltype+","+
                    " wffieldtype = "+wffieldtype+","+
                    " wffielddbtype='"+wffielddbtype+"',"+
                    " outerfieldname = '"+dttableaname+"."+outerfieldname+"', outfielddbtype='"+outfielddbtype+"',"+
                    " changetype="+changetype+","+
                    " customsql='"+customsql+"',customtxt='"+customtxt+"' where id="+id;
        			RecordSet.executeSql(updatesql);
        		}
        		
        	}
        }
    
    }
    }catch(Exception e){
    	e.printStackTrace();
    }
    //处理明细表记录
    /*
    RecordSet.executeSql("delete from wfec_indatasetdetail  where mainid="+viewid);//先删除
    for(int i=1;i<=fieldscount;i++){
        int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid_index_"+i)),-1);
        String wffieldname = Util.null2String(request.getParameter("fieldname_index_"+i));
        int wffieldhtmltype = Util.getIntValue(Util.null2String(request.getParameter("fieldhtmltype_index_"+i)),-1);
        int wffieldtype = Util.getIntValue(Util.null2String(request.getParameter("fieldtype_index_"+i)),-1);
        String wffielddbtype = Util.null2String(request.getParameter("fielddbtype_index_"+i));
        String outerfieldname = Util.null2String(request.getParameter("outerfieldname_index_"+i));
        int iswriteback = Util.getIntValue(Util.null2String(request.getParameter("iswriteback_"+i)),0);
        String customsql = Util.null2String(request.getParameter("customsql_"+i));
        String customtxt = Util.null2String(request.getParameter("customtxt_"+i));
        int changetype = 0;
        //if(wffieldhtmltype==3&&(wffieldtype==1||wffieldtype==4||wffieldtype==164)){
            //单人力资源浏览框，单部门浏览框，单分部浏览框才有转换规则
            changetype = Util.getIntValue(Util.null2String(request.getParameter("rulesopt_"+i)),0);
            if(changetype==5){//选择了固定的创建人
                outerfieldname = Util.null2String(request.getParameter("hrmid"));
            }
        //}
        String insertSql = "insert into wfec_indatasetdetail("+
                           "mainid,"+
                           "wffieldid,"+
                           "wffieldname,"+
                           "wffieldhtmltype,"+
                           "wffieldtype,"+
                           "wffielddbtype,"+
                           "outerfieldname,"+
                           "changetype,"+
                           "customsql,customtxt) values("+
                           viewid+","+
                           wffieldid+","+
                           "'"+wffieldname+"',"+
                           wffieldhtmltype+","+
                           wffieldtype+","+
                           "'"+wffielddbtype+"',"+
                           "'"+outerfieldname+"',"+
                           changetype+",'" +customsql+"','"+customtxt+"')";
                           
         RecordSet.executeSql(insertSql);
    }
    */
    RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"字段对应关系");
    SysMaintenanceLog.setOperateItem("199"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		//window.parent.document.location.href="/workflow/exchange/rdata/automaticsettingTab.jsp?_fromURL=1&typename=<%=typename%>&viewid=<%=viewid%>&backto=<%=backto%>";
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab1.jsp?_fromURL=3&mainid=<%=viewid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equalsIgnoreCase("saveActionList")){//保存动作列表
	weaver.workflow.action.WorkflowActionManager workflowActionManager = new weaver.workflow.action.WorkflowActionManager();
	int workflowid = Util.getIntValue(request.getParameter("wfid"),-1);
  	String deleteRows = Util.null2String(request.getParameter("actiondeleterows"));
  	int allRows = Util.getIntValue(request.getParameter("allrows"));
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
  		e.printStackTrace();
  	}
}else if(operate.equalsIgnoreCase("createtable")){
	int tableid = -1 ;
	String viewid = Util.null2String(request.getParameter("viewid"));//keyid 
	String setname = Util.null2String(request.getParameter("setname"));//名称
    String workflowid = Util.null2String(request.getParameter("workFlowId"));//流程id
    String datasourceid = Util.null2String(request.getParameter("datasourceid"));//数据源
    String outermaintable = Util.null2String(request.getParameter("outermaintable"));//外部主表
    
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String status = Util.null2String(request.getParameter("status"));//
    String changetype = Util.null2String(request.getParameter("changetype"));//
    boolean isnotsupportdatabase = false ;
    
	Connection conn = null;//获得外部连接
	String dbType = "" ;
    try{
    
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
	   	
	    //
	    RecordSet.executeSql("delete from wfec_indatasetdetail  where mainid="+viewid);//先删除字段对应关系
	    if(!isnotsupportdatabase){
	        AutoCreateTable act = new AutoCreateTable();
	        ArrayList<ArrayList<String>> workflowfieldinfos = act.getWorkflowFieldInfo(workflowid);
	        act.setRid(viewid);
	        act.setDatasource(datasourceid);
	        act.setType(changetype);
	    
	    	ArrayList outerdetailtableslist = new ArrayList();
	    
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
	    	

	    	outerdetailtables = StringUtils.join(outerdetailtableslist,",");
	    }
	   //
	    String oldworkflowid = "";
	    RecordSet.executeSql("select workflowid from wfec_indatawfset where id="+viewid);
	    if(RecordSet.next()){
	        oldworkflowid = RecordSet.getString("workflowid");
	        if(!oldworkflowid.equals(workflowid)){
	             //流程已变更，删除详细设置内容。
	             RecordSet.executeSql("delete from wfec_indatasetdetail where mainid="+viewid);
	        }
	    }
	    
	    setname = Util.replace(setname,"'","''",0);
	    outermaintable = Util.replace(outermaintable,"'","''",0);
	    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
	    
	    String updateSql = "update wfec_indatawfset set "+
	                       "name='"+setname+"',"+
	                       "workflowid='"+workflowid+"',"+
	                       "outermaintable='"+outermaintable+"',"+
	                       "outerdetailtables='"+outerdetailtables+"',"+
	                       "datasourceid='"+datasourceid+"', "+
	                       "status="+Util.getIntValue(status,0)+
	                       "where id="+viewid;
	    RecordSet.executeSql(updateSql);
    }catch(Exception e){
    	e.printStackTrace();
    }
    RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
    SysMaintenanceLog.setRelatedName(title);
    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+"基础信息1");
    SysMaintenanceLog.setOperateItem("199"); //type =1 
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
    %>
    <script language=javascript >
    try
    {
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab1.jsp?_fromURL=1&mainid=<%=viewid%>"
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
	Connection conn = null ;
	Statement stat = null ;
	try{
		conn = exu.getConnection(datasourceid);
		stat = conn.createStatement();
		int maintablerows = Util.getIntValue(request.getParameter("maintablerows"));
		String maintabledelrow = Util.null2String(request.getParameter("maindeleterow"));
		String maintableaddrow = Util.null2String(request.getParameter("mainaddrows"));
		String maintableid = Util.null2String(request.getParameter("maintableid"));
		String maintablename = Util.null2String(request.getParameter("maintablename"));
		ArrayList mainaddrows = Util.TokenizerString(maintableaddrow,",");
		for(int i = 0 ; i < mainaddrows.size() ; i++){
			int idx = Util.getIntValue(mainaddrows.get(i).toString());
			String fieldChecbox = Util.null2String(request.getParameter("fieldChecbox_"+idx));
			if(idx>0){
				String dbname = Util.null2String(request.getParameter("dbname_"+(idx-1)));
				String type = Util.null2String(request.getParameter("type_"+(idx-1)));
				String dbtype = Util.null2String(request.getParameter("dbtype_"+(idx-1)));
				if(!dbname.equals("")){
					exu.InsertTableField(stat,maintableid,maintablename,dbname,type,dbtype,0);
				}
			}
		}
		if(!maintabledelrow.equals("")){
			exu.DropTableFieldBatch(stat,maintablename,maintabledelrow);
		}
		
		int dtcount = Util.getIntValue(request.getParameter("dtcount"));//明细数
		ArrayList dt_addrowslist = new ArrayList();
		for(int i = 0 ; i < dtcount ; i++){
			dt_addrowslist.clear() ;
			int dt_rows = Util.getIntValue(request.getParameter("dt"+i+"_tablerows"));
			String dt_delrows = Util.null2String(request.getParameter("dt"+i+"_deleterow"));
			String dt_addrows = Util.null2String(request.getParameter("dt"+i+"_addrow"));
			String dttableid = Util.null2String(request.getParameter("dt"+i+"_tableid"));
			String dttablename = Util.null2String(request.getParameter("dt"+i+"_tablename"));
			dt_addrowslist = Util.TokenizerString(dt_addrows,",");
			for( int j = 0 ; j < dt_addrowslist.size() ; j++ ){
				int idx = Util.getIntValue(dt_addrowslist.get(j).toString());
				String dbname = Util.null2String(request.getParameter("dt"+i+"_dbname_"+(idx-1)));
				String type = Util.null2String(request.getParameter("dt"+i+"_type_"+(idx-1)));
				String dbtype = Util.null2String(request.getParameter("dt"+i+"_dbtype_"+(idx-1)));
				if(!dbname.equals("")){
					exu.InsertTableField(stat,dttableid,dttablename,dbname,type,dbtype,0);
				}
			}
			
			if(!dt_delrows.equals("")){
				//RecordSet.executeSql("delete from wfec_tablefield where id in ("+dt_delrows+")");
				exu.DropTableFieldBatch(stat,dttablename,dt_delrows);
			}
		}
	}catch(Exception e){
		
	}finally{
		try{
			if(stat!=null){
				stat.close();
			}
		}catch(Exception e){
			
		}
		try{
			if(conn!=null){
				conn.close();
			}
		}catch(Exception e){
			
		}
		RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
		RecordSet.next();
		String title = RecordSet.getString("name");
		SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
	    SysMaintenanceLog.setRelatedName(title);
	    SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
	    SysMaintenanceLog.setOperateDesc("修改"+typename+"设置："+title+" 数据表字段");
	    SysMaintenanceLog.setOperateItem("199"); //type =1 
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	}
	%>
    <script language=javascript >
    try
    {
		window.parent.document.location.href="/workflow/exchange/ExchangeSetTab1.jsp?_fromURL=4&mainid=<%=viewid%>"
	}
	catch(e)
	{
	}
	</script>
    <%
}else if(operate.equals("delete")){
	String viewid = Util.null2String(request.getParameter("viewid"));//keyid	
  	RecordSet.executeSql("select id,name,workflowid from wfec_indatawfset where id="+viewid );
	RecordSet.next();
	String title = RecordSet.getString("name");
	String wfid = RecordSet.getString("workflowid");
	String wftypeid = Util.null2String(request.getParameter("wftypeid"));//WorkflowComInfo.getWorkflowtype(wfid);
	try{
	    RecordSet.executeSql("delete from wfec_indatawfset where id="+viewid+"");
	    RecordSet.executeSql("delete from wfec_indatadetail where mainid="+viewid);
	    RecordSet.executeSql("delete from wfec_indatasetdetail where mainid="+viewid);
	    SysMaintenanceLog.resetParameter();
	    SysMaintenanceLog.setRelatedId(Util.getIntValue(viewid));
	    SysMaintenanceLog.setRelatedName(title);
	    SysMaintenanceLog.setOperateType("3");//1 new  2:eidt 3:del
	    SysMaintenanceLog.setOperateDesc("删除"+typename+"设置："+title);
	    SysMaintenanceLog.setOperateItem("199"); //type =1 
	    SysMaintenanceLog.setOperateUserid(user.getUID());
	    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    SysMaintenanceLog.setSysLogInfo();
	   // out.println("1");
	}catch(Exception e){
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
		window.parent.location.href = "/workflow/exchange/ExchangeSetTab1.jsp?isclose=1&wftypeid=<%=wftypeid %>";
	}
	catch(e)
	{
	}
	</script>
    <%
}
%>
