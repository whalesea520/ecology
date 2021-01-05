
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
String isDialog = Util.null2String(request.getParameter("isdialog"));
String operate = Util.null2String(request.getParameter("operate"));
String typename = Util.null2String(request.getParameter("typename"));
String parentWinHref ="".equals(typename)?"/workflow/automaticwf/automaticsetting.jsp":"/workflow/automaticwf/automaticsetting.jsp?typename="+typename;
String backto = Util.fromScreen(request.getParameter("backto"),user.getLanguage());
Logger log = LoggerFactory.getLogger();
/*
 * QC:256124
 * 解决新建名称重复有效性检查可以通过
 * SJZ 2017-03-16
 *
 * BEGIN
 */
String setname = Util.null2String(request.getParameter("setname"));//名称
String viewid = Util.null2String(request.getParameter("viewid"));//keyid

if("add".equalsIgnoreCase(operate) || "addAndDetail".equalsIgnoreCase(operate)
        || "edit".equalsIgnoreCase(operate)){

    if(!setname.isEmpty()) {
        String checkNameExistSql = "select 1 from outerdatawfset where setname = '" + setname + "'";
        if ("edit".equals(operate) && !viewid.isEmpty()) {
            checkNameExistSql += " and id != '" + viewid + "'";
        }

        boolean bool = RecordSet.executeSql(checkNameExistSql);

        if (!bool || RecordSet.next()) {
        	//QC289154  STRAT
        	request.getRequestDispatcher("/workflow/automaticwf/automaticsettingEdit.jsp?msg=1&viewid="+viewid+"&backto="+backto).forward(request,response);
            return;
        }
    } else {
    	request.getRequestDispatcher("/workflow/automaticwf/automaticsettingEdit.jsp?msg=2&viewid="+viewid+"&backto="+backto).forward(request,response);
    	return;
    	//QC289154  END
    }
}
// QC:256124 END


SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sdf1 = new SimpleDateFormat("HH:mm:ss");
Date date = new Date();
String date_now = sdf.format(date);
String time_now = sdf1.format(date);

if(operate.equals("add") || operate.equals("addAndDetail")){

    String workFlowId = Util.null2String(request.getParameter("workFlowId"));//流程id
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
    String isview = Util.null2String(request.getParameter("isview"));//
    
    String isnextnode = Util.null2String(request.getParameter("isnextnode")); //是否停留创建节点 
    String isupdatewfdata = Util.null2String(request.getParameter("isupdatewfdata"));  //创建节点修改流程数据
    String isupdatewfdataField = Util.null2String(request.getParameter("isupdatewfdataField"));  //修改流程数据标志字段
  
    if(isview==null||"".equals(isview)){
    	isview="0";
    }
    int detailcount = Util.getIntValue(Util.null2String(request.getParameter("detailcount")),0);//明细数量
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + "$@|@$";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
    setname = Util.replace(setname,"'","''",0);
    outermaintable = Util.replace(outermaintable,"'","''",0);
    outermainwhere = Util.replace(outermainwhere,"'","''",0);
    successback = Util.replace(successback,"'","''",0);
    failback = Util.replace(failback,"'","''",0);
    keyfield = Util.replace(keyfield,"'","''",0);
    requestid = Util.replace(requestid,"'","''",0);
    FTriggerFlag = Util.replace(FTriggerFlag,"'","''",0);
    FTriggerFlagValue = Util.replace(FTriggerFlagValue,"'","''",0);
    
    outerdetailtables = Util.replace(outerdetailtables,"'","''",0);
    outerdetailwheres = Util.replace(outerdetailwheres,"'","''",0);
    String insertSql = "insert into outerdatawfset("+
                       "setname,"+
                       "typename,"+
                       "workflowid,"+
                       "outermaintable,"+
                       "outermainwhere,"+
                       "successback,"+
                       "failback,"+
                       "outerdetailtables,"+
                       "outerdetailwheres,"+
                       "datasourceid,keyfield,requestid,FTriggerFlag,datarecordtype,FTriggerFlagValue,isview,CreateDate,CreateTime,ModifyDate,ModifyTime,"+
                       "isupdatewfdata,"+
                       "isupdatewfdataField,"+
                       "isnextnode"+
                       ") values("+
                       "'"+setname+"','"+typename+"',"+
                       ""+workFlowId+","+
                       "'"+outermaintable+"',"+
                       "'"+outermainwhere+"',"+
                       "'"+successback+"',"+
                       "'"+failback+"',"+
                       "'"+outerdetailtables+"',"+
                       "'"+outerdetailwheres+"',"+
                       "'"+datasourceid+"',"+
                       "'"+keyfield+"',"+
                       "'"+requestid+"',"+
                       "'"+FTriggerFlag+"',"+
                       "'"+datarecordtype+"',"+
                       "'"+FTriggerFlagValue+"',"+
                       "'"+isview+"',"+ 
                       "'"+date_now+"',"+ 
                       "'"+time_now+"',"+ 
                       "'"+date_now+"',"+ 
                       "'"+time_now+"',"+ 
                       "'"+isupdatewfdata+"',"+ 
                       "'"+isupdatewfdataField+"',"+ 
                       "'"+isnextnode+"'"+ 
                       ")";
    //System.out.println("insertSql=="+insertSql);
    RecordSet.executeSql(insertSql);

    RecordSet.executeSql("select max(id) from outerdatawfset");
    if(RecordSet.next()){
        viewid = RecordSet.getString(1);
    } else {
        viewid = "";
    }
    //response.sendRedirect("/workflow/automaticwf/automaticsettingTab.jsp?typename="+typename+"&viewid="+viewid+"&backto="+backto);
	if("1".equals(isDialog)){
		if(operate.equals("add")){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href='<%=parentWinHref%>';
		parentWin.closeDialog();
	}catch(e){
		
	}
</script>
<%
		}else if(operate.equals("addAndDetail")){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href="/workflow/automaticwf/automaticsetting.jsp?needDoEditDetailById=<%=viewid%>";
		parentWin.closeDialog();
		
	}catch(e){
		
	}
</script>
<%
		}
    }else{
 		response.sendRedirect("/workflow/automaticwf/automaticsetting.jsp");
	}
	return;
}else if(operate.equals("edit")){
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
    String isview = Util.null2String(request.getParameter("isview"));//是否是视图
    
    String isnextnode = Util.null2String(request.getParameter("isnextnode")); //是否停留创建节点 
    String isupdatewfdata = Util.null2String(request.getParameter("isupdatewfdata"));  //创建节点修改流程数据
    String isupdatewfdataField = Util.null2String(request.getParameter("isupdatewfdataField"));  //修改流程数据标志字段
    
    if(isview==null||"".equals(isview)) {
        isview = "0";
    }
    
    String outerdetailtables = "";//外部明细表集合
    String outerdetailwheres = "";//外部明细表条件集合
    for(int i=0;i<detailcount;i++){
        String tempouterdetailname = Util.null2String(request.getParameter("outerdetailname"+i));
        String tempouterdetailwhere = Util.null2String(request.getParameter("outerdetailwhere"+i));
        if(tempouterdetailname.equals("")) tempouterdetailname = "-";
        if(tempouterdetailwhere.equals("")) tempouterdetailwhere = "-";
        if(i<(detailcount-1)){
            outerdetailtables += tempouterdetailname + ",";
            outerdetailwheres += tempouterdetailwhere + "$@|@$";
        }else{
            outerdetailtables += tempouterdetailname;
            outerdetailwheres += tempouterdetailwhere;
        }
    }
    
    String oldworkflowid = "";
    RecordSet.executeSql("select workflowid from outerdatawfset where id="+viewid);
    if(RecordSet.next()){
        oldworkflowid = RecordSet.getString("workflowid");
        if(!oldworkflowid.equals(workflowid)){
             //流程已变更，删除详细设置内容。
             RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+viewid);
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
    String updateSql = "update outerdatawfset set "+
                       "setname='"+setname+"',typename='"+typename+"',"+
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
                       "FTriggerFlagValue='"+FTriggerFlagValue+"', "+
                       "ModifyDate='"+date_now+"', "+
                       "ModifyTime='"+time_now+"', "+
                       "isview='"+isview+"',  "+
                       "isnextnode='"+isnextnode+"',  "+
                       "isupdatewfdata='"+isupdatewfdata+"',  "+
                       "isupdatewfdataField='"+isupdatewfdataField+"'  "+
                       "where id="+viewid;
    //System.out.println("updateSql=="+updateSql);
    RecordSet.executeSql(updateSql);
	if("1".equals(isDialog)){
%>
<script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href='<%=parentWinHref%>';
		parentWin.closeDialog();
	}catch(e){
		
	}
</script>
<%
    }else{
 		response.sendRedirect("/workflow/automaticwf/automaticsetting.jsp");
	}
}else if(operate.equals("adddetail")){
    int fieldscount = Util.getIntValue(Util.null2String(request.getParameter("fieldscount")),0);//字段总数
    
    RecordSet.executeSql("delete from outerdatawfsetdetail where mainid="+viewid);//先删除
    for(int i=1;i<=fieldscount;i++){
        int wffieldid = Util.getIntValue(Util.null2String(request.getParameter("fieldid_index_"+i)),-1);
        String wffieldname = Util.null2String(request.getParameter("fieldname_index_"+i));
        int wffieldhtmltype = Util.getIntValue(Util.null2String(request.getParameter("fieldhtmltype_index_"+i)),-1);
        int wffieldtype = Util.getIntValue(Util.null2String(request.getParameter("fieldtype_index_"+i)),-1);
        String wffielddbtype = Util.null2String(request.getParameter("fielddbtype_index_"+i));
        String outerfieldname = Util.null2String(request.getParameter("outerfieldname_index_"+i));
        int iswriteback = Util.getIntValue(Util.null2String(request.getParameter("iswriteback_"+i)),0);
        String customsql = Util.null2String(request.getParameter("customsql_"+i));
        int changetype = 0;
        if( wffieldhtmltype==3&&(wffieldtype==1||wffieldtype==4||wffieldtype==164) ){
            //单人力资源浏览框，单部门浏览框，单分部浏览框才有转换规则
            changetype = Util.getIntValue(Util.null2String(request.getParameter("rulesopt_"+i)),0);
            if(changetype==5){//选择了固定的创建人
                outerfieldname = Util.null2String(request.getParameter("hrmid"));
            }
        }
        String insertSql = "insert into outerdatawfsetdetail("+
                           "mainid,"+
                           "wffieldid,"+
                           "wffieldname,"+
                           "wffieldhtmltype,"+
                           "wffieldtype,"+
                           "wffielddbtype,"+
                           "outerfieldname,"+
                           "changetype,"+
                           "iswriteback,customsql) values("+
                           viewid+","+
                           wffieldid+","+
                           "'"+wffieldname+"',"+
                           wffieldhtmltype+","+
                           wffieldtype+","+
                           "'"+wffielddbtype+"',"+
                           "'"+outerfieldname+"',"+
                           changetype+","+
                           iswriteback+",'"+customsql+"')";
                           
         //RecordSet.executeSql(insertSql);
        
        String cssql = "insert into outerdatawfsetdetail(mainid,wffieldid,wffieldname,wffieldhtmltype,wffieldtype,wffielddbtype,outerfieldname,changetype,iswriteback,customsql,CreateDate,CreateTime,ModifyDate,ModifyTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"; 
        ConnStatement cs = null;
		try{
			cs = new ConnStatement();
        cs.setStatementSql(cssql);
        cs.setString(1,viewid);
        cs.setInt(2,wffieldid);
        cs.setString(3,wffieldname);
        cs.setInt(4,wffieldhtmltype);
        cs.setInt(5,wffieldtype);
        cs.setString(6,wffielddbtype);
        cs.setString(7,outerfieldname);
        cs.setInt(8,changetype);
        cs.setInt(9,iswriteback);
        cs.setString(10,customsql);
        cs.setString(11,date_now);
        cs.setString(12,time_now);
        cs.setString(13,date_now);
        cs.setString(14,time_now);
        cs.executeUpdate();				
		}catch(Exception e){
			log.error(e);
			e.printStackTrace();
		}finally {
			cs.close();
		}

    }
    
    %>
    <script language=javascript >
    try{
		var parentWin = parent.parent.getParentWindow(parent);
		parentWin.location.href='<%=parentWinHref%>';
		//parentWin.closeDialog();
		dialog = parent.parent.getDialog(parent);
		dialog.close();
	}catch(e){
		
	}
	</script>
    <%
}
%>