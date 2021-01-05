<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.expdoc.ExpUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExpDBcominfo" class="weaver.expdoc.ExpDBcominfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
char separator = Util.getSeparator() ;
String isDialog = Util.null2String(request.getParameter("isdialog"));
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());

String proId = Util.null2String(request.getParameter("proId"));//方案id
String name = Util.null2String(request.getParameter("name"));//方案名称
String fileSaveType = Util.null2String(request.getParameter("FileSaveType"));//文件保存方式
String regitType = Util.null2String(request.getParameter("regitType"));//-注册类型
String expTableType = Util.null2String(request.getParameter("expTableType"));//-文档归档目标
String synType = Util.null2String(request.getParameter("synType"));//同步方式
String timeModul = Util.null2String(request.getParameter("TimeModul"));//时间模式
//QC335317 [80][90][缺陷]流程归档集成-解决归档方案中同步频率不能修改的问题 -start
	//代表每周星期几
	String fre_0 = Util.null2String(request.getParameter("fer_0"));
	//代表每月第几天
	String fre_1 = Util.null2String(request.getParameter("fer_1"));
	//代表年多少月
	String fre_2 = Util.null2String(request.getParameter("fer_2"));
	String frequency = Util.null2String(request.getParameter("Frequency"));//时间模式为按年时，表示第几天

	String frequencyy = Util.null2String(request.getParameter("frey"));//时间模式为按年时，表示第几天
	if (timeModul.equals("1")) {
		frequency = fre_0;
	}else if (timeModul.equals("2")){
		frequency = fre_1;
	}else if (timeModul.equals("3")) {
		frequency = fre_2;
	}
//QC335317 [80][90][缺陷]流程归档集成-解决归档方案中同步频率不能修改的问题 -end
String createType = Util.null2String(request.getParameter("createType"));//计算类型，0,为表示正数，1，表示倒数
String createTime = "";//同步具体时间
if("0".equals(timeModul))
//天
{
    createTime = Util.null2String(request.getParameter("dayTime"));
}
else if("1".equals(timeModul))
//周
{
    createTime = Util.null2String(request.getParameter("weekTime"));
}
else if("2".equals(timeModul))
//月
{
    createType = Util.null2String(request.getParameter("monthType"));        
    
    createTime = Util.null2String(request.getParameter("monthTime"));
}
else if("3".equals(timeModul))
//年
{
    createType = Util.null2String(request.getParameter("yearType"));
    
    createTime = Util.null2String(request.getParameter("yearTime"));
}
if("".equals(createTime) || null == createTime)
//如果创建时间为空，则默认为00:00
{
    createTime = "00:00";
}
String regitDBId = Util.null2String(request.getParameter("regitDBId"));//注册数据库id
String mainTableKeyType = Util.null2String(request.getParameter("mainTableKeyType"));//主表主键生成规则
String dtTableKeyType = Util.null2String(request.getParameter("dtTableKeyType"));//明细表主键生成规则
String ExpWorkflowFileFlag = Util.null2String(request.getParameter("ExpWorkflowFileFlag"));//导出流程表单文档
String ExpWorkflowFileForZipFlag = Util.null2String(request.getParameter("ExpWorkflowFileForZipFlag"));//-导出流程表单文档为ZIP
String ExpWorkflowRemarkFileFlag = Util.null2String(request.getParameter("ExpWorkflowRemarkFileFlag"));//导出流转意见文档
String ExpWorkflowRemarkFileForZip = Util.null2String(request.getParameter("ExpWorkflowRemarkFileForZip"));//导出流转意见文档为ZIP
String ExpWorkflowFilePath = Util.null2String(request.getParameter("ExpWorkflowFilePath"));//出流程文档路径
String ExpWorkflowInfoFlag = Util.null2String(request.getParameter("ExpWorkflowInfoFlag"));//导出流程表单
String ExpWorkflowInfoPath = Util.null2String(request.getParameter("ExpWorkflowInfoPath"));//导出流程表单路径
String ExpWorkflowRemarkFlag = Util.null2String(request.getParameter("ExpWorkflowRemarkFlag"));//导出流转意见
String ExpSignFileFlag = Util.null2String(request.getParameter("ExpSignFileFlag"));//导出签章图片
String ExpSignFilePath = Util.null2String(request.getParameter("ExpSignFilePath"));//导出签章图片路径

String zwMapFiletype = Util.null2String(request.getParameter("zwMapFiletype"));//流程表单正文
String fjMapFiletype = Util.null2String(request.getParameter("fjMapFiletype"));//流程表单附件
String dwdMapFiletype = Util.null2String(request.getParameter("dwdMapFiletype"));//流程表单文档
String mwdMapFiletype = Util.null2String(request.getParameter("mwdMapFiletype"));//-流程表单多文档
String remarkWDMapFiletype = Util.null2String(request.getParameter("remarkWDMapFiletype"));//流转意见文档
String remarkFJMapFiletype = Util.null2String(request.getParameter("remarkFJMapFiletype"));//流转意见附件
String bdMapFiletype = Util.null2String(request.getParameter("bdMapFiletype"));//流程表单

//主表字段和明细表字段
String mainfieldNames[] = request.getParameterValues("mainfieldName");
String mainfieldtypes[] = request.getParameterValues("mainfieldtype");
String mainiskeys[] = request.getParameterValues("mainiskey");
String mainisdocs[] = request.getParameterValues("mainisdoc");
String mainisdoctypes[] = request.getParameterValues("mainisdoctype");
String mainisdocnames[] = request.getParameterValues("mainisdocname");

String dtfieldNames[] = request.getParameterValues("dtfieldName");
String dtfieldtypes[] = request.getParameterValues("dtfieldtype");
String dtiskeys[] = request.getParameterValues("dtiskey");
String dtisdocs[] = request.getParameterValues("dtisdoc");
String dtisdoctypes[] = request.getParameterValues("dtisdoctype");
String dtismainkeys[] = request.getParameterValues("dtismainkey");
String dtisdocnames[] = request.getParameterValues("dtisdocname");




int userid = user.getUID();
String createdate = TimeUtil.getCurrentTimeString();
//System.out.println("ExpWorkflowFileFlag=="+ExpWorkflowFileFlag);
//System.out.println("ExpWorkflowFileForZipFlag=="+ExpWorkflowFileForZipFlag);
//System.out.println("ExpWorkflowRemarkFileFlag=="+ExpWorkflowRemarkFileFlag);
//System.out.println("ExpWorkflowRemarkFileForZip=="+ExpWorkflowRemarkFileForZip);
if(operation.equals("add")){
	ConnStatement statement = null;
	try{
	//RecordSet.executeSql("insert into exp_localdetail(name,path,createdate,creator) values('"+name+"','"+path+"','"+createdate+"',"+userid+")");
	statement=new ConnStatement();
	
	//exp_ProList
	String sql = "";
	/* 	sql = "insert into exp_DBProSettings("+
				"name,"+
				"FileSaveType,"+
				" regitType,"+
				"expTableType,"+
				" synType,"+
				" TimeModul,"+
				" Frequency, "+
				"frequencyy, "+
				"createType, "+
				"createTime,"+
				
				"regitDBId,"+
				"mainTableKeyType,"+
				"dtTableKeyType,"+
				
				"ExpWorkflowFileFlag,"+
				"ExpWorkflowFileForZipFlag,"+
				"ExpWorkflowRemarkFileFlag,"+
				"ExpWorkflowRemarkFileForZip,"+
				"ExpWorkflowFilePath,"+
				"ExpWorkflowInfoFlag,"+
				"ExpWorkflowInfoPath,"+
				"ExpWorkflowRemarkFlag,"+
				"ExpSignFileFlag,"+
				"ExpSignFilePath,"+
				
				"zwMapFiletype,"+
				"fjMapFiletype,"+
				"dwdMapFiletype,"+
				"mwdMapFiletype,"+
				"remarkWDMapFiletype,"+
				"remarkFJMapFiletype,"+
				"bdMapFiletype"+

				") values("+
				"?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"+
				")";
		statement.setStatementSql(sql);
		
		statement.setString(1, name);
		statement.setString(2, fileSaveType);
		statement.setInt(3, Util.getIntValue(regitType,-1));
		statement.setString(4,expTableType);
		statement.setString(5, synType);
		statement.setString(6, timeModul);
		statement.setString(7, frequency);
		statement.setInt(8,Util.getIntValue(frequencyy,1) );
		statement.setString(9, createType);
		statement.setString(10, createTime);
		
		statement.setInt(11, Util.getIntValue(regitDBId,-1));
		statement.setString(12,mainTableKeyType);
		statement.setString(13, dtTableKeyType);
		
		statement.setString(14, ExpWorkflowFileFlag);
		statement.setString(15, ExpWorkflowFileForZipFlag);
		statement.setString(16, ExpWorkflowRemarkFileFlag);
		statement.setString(17, ExpWorkflowRemarkFileForZip);
		statement.setString(18, ExpWorkflowFilePath);
		statement.setString(19, ExpWorkflowInfoFlag);
		statement.setString(20, ExpWorkflowInfoPath);
		statement.setString(21, ExpWorkflowRemarkFlag);
		statement.setString(22, ExpSignFileFlag);
		statement.setString(23, ExpSignFilePath);
		
		
		statement.setString(24, zwMapFiletype);
		statement.setString(25, fjMapFiletype);
		statement.setString(26, dwdMapFiletype);
		statement.setString(27, mwdMapFiletype);
		statement.setString(28, remarkWDMapFiletype);
		statement.setString(29, remarkFJMapFiletype);
		statement.setString(30, bdMapFiletype);
		
		int temp=statement.executeUpdate();
		
		statement.executeQuery(); */
		
		sql = "insert into exp_DBProSettings("+
				"name,"+
				"FileSaveType,"+
				" regitType,"+
				"expTableType,"+
				" synType,"+
				" TimeModul,"+
				" Frequency, "+
				"frequencyy, "+
				"createType, "+
				"createTime,"+
				
				"regitDBId,"+
				"mainTableKeyType,"+
				"dtTableKeyType,"+
				
				"ExpWorkflowFileFlag,"+
				"ExpWorkflowFileForZipFlag,"+
				"ExpWorkflowRemarkFileFlag,"+
				"ExpWorkflowRemarkFileForZip,"+
				"ExpWorkflowFilePath,"+
				"ExpWorkflowInfoFlag,"+
				"ExpWorkflowInfoPath,"+
				"ExpWorkflowRemarkFlag,"+
				"ExpSignFileFlag,"+
				"ExpSignFilePath,"+
				
				"zwMapFiletype,"+
				"fjMapFiletype,"+
				"dwdMapFiletype,"+
				"mwdMapFiletype,"+
				"remarkWDMapFiletype,"+
				"remarkFJMapFiletype,"+
				"bdMapFiletype"+

				") values("+
				"'"+StringEscapeUtils.escapeSql(name)+"',"+
				"'"+StringEscapeUtils.escapeSql(fileSaveType)+"',"+
				Util.getIntValue(regitType,-1)+","+
				"'"+StringEscapeUtils.escapeSql(expTableType)+"',"+
				"'"+StringEscapeUtils.escapeSql(synType)+"',"+
				"'"+StringEscapeUtils.escapeSql(timeModul)+"',"+
				Util.getIntValue(frequency,1)+","+
				Util.getIntValue(frequencyy,1)+","+
				"'"+StringEscapeUtils.escapeSql(createType)+"',"+
				"'"+StringEscapeUtils.escapeSql(createTime)+"',"+
				
				Util.getIntValue(regitDBId,-1)+","+
				"'"+StringEscapeUtils.escapeSql(mainTableKeyType)+"',"+
				"'"+StringEscapeUtils.escapeSql(dtTableKeyType)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFileForZipFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFileForZip)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFilePath)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowInfoFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowInfoPath)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpSignFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpSignFilePath)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(zwMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(fjMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(dwdMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(mwdMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(remarkWDMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(remarkFJMapFiletype)+"',"+
				"'"+StringEscapeUtils.escapeSql(bdMapFiletype)+"') ";
				
		RecordSet.executeSql(sql);
		
		int Proid=-1;
		sql = "select max(id) as maxid from exp_DBProSettings ";
		RecordSet.executeSql(sql);
		
		if(RecordSet.next()){
			Proid = Util.getIntValue(RecordSet.getString("maxid"), -1);
		}
		
		//保存主表字段
		if(mainfieldNames!=null){
			for(int i=0;i<mainfieldNames.length;i++){
				if(mainfieldNames[i]!=null && !"".equals(mainfieldNames[i].trim())){
					sql = "insert into exp_dbmaintablesetting("+
					"dbsettingid,"+
					"columnname,"+
					"columntype,"+
					"primarykey,"+
					"isdoce,"+
					"doctype,"+
					"filename"+
					
					") values("+
					"?,?,?,?,?,?,?"+
					")";
					statement.setStatementSql(sql);
					statement.setInt(1,Proid);
					statement.setString(2, mainfieldNames[i]);
					statement.setString(3,mainfieldtypes[i]);
					statement.setString(4, mainiskeys[i]);
					statement.setString(5, mainisdocs[i]);
					statement.setString(6, mainisdoctypes[i]);
					statement.setString(7, mainisdocnames[i]);
				
					statement.executeUpdate();
				}
			}
		}
		
		if(dtfieldNames!=null){
	
		//保存明细表字段
		for(int i=0;i<dtfieldNames.length;i++){
			if(dtfieldNames[i]!=null && !"".equals(dtfieldNames[i].trim())){
				sql = "insert into exp_dbdetailtablesetting("+
				"dbsettingid,"+
				"columnname,"+
				"columntype,"+
				"primarykey,"+
				"isdoce,"+
				"doctype,"+
				"mainid,"+
				"filename"+
				
				") values("+
				"?,?,?,?,?,?,?,?"+
				")";
				statement.setStatementSql(sql);
				statement.setInt(1,Proid);
				statement.setString(2, dtfieldNames[i]);
				statement.setString(3,dtfieldtypes[i]);
				statement.setString(4, dtiskeys[i]);
				statement.setString(5, dtisdocs[i]);
				statement.setString(6, dtisdoctypes[i]);
				statement.setString(7, dtismainkeys[i]);
				statement.setString(8, dtisdocnames[i]);
				statement.executeUpdate();
			}
		
		}
		}
		
		//
		sql = "insert into exp_ProList("+
		"ProName,"+
		"Proid,"+
		"ProType,"+
		"ProFileSaveType"+
		
		") values("+
		"'"+StringEscapeUtils.escapeSql(name)+"',"+Proid+",'1','"+StringEscapeUtils.escapeSql(fileSaveType)+"'"+
		")";
		
		RecordSet.executeSql(sql);
		
	}catch(Exception e){
		new BaseBean().writeLog(e);
		
	}finally{
		try{
			statement.close();
		}catch(Exception e){
			
		}
	}
	
	int maxid=0;
	RecordSet.executeSql("select  max(id) from exp_ProList");
	if(RecordSet.next()){
	maxid = RecordSet.getInt(1);
	}
	String para = name +separator+ fileSaveType +separator + createdate +separator + userid ;
	SysMaintenanceLog.resetParameter();
    SysMaintenanceLog.setRelatedId(maxid);
    SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateType("1");
    SysMaintenanceLog.setOperateDesc("exp_dbdetailtablesetting_Insert,"+para);
    SysMaintenanceLog.setOperateItem("162");
    SysMaintenanceLog.setOperateUserid(user.getUID());
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
    SysMaintenanceLog.setSysLogInfo();
		
	
}

else if(operation.equals("edit")){
	String id = Util.null2String(request.getParameter("id"));//id
	ConnStatement statement = null;
	try{
	statement=new ConnStatement();

	String sql = "";
		sql = "update exp_DBProSettings set "+
				"name=?,"+
				"FileSaveType=?,"+
				" regitType=?,"+
						
				" expTableType=?,"+
						
				" synType=?,"+
				" TimeModul=?,"+
				" Frequency=?, "+
				"frequencyy=?, "+
				"createType=?, "+
				"createTime=?,"+
	
				"regitDBId=?,"+
				"mainTableKeyType=?,"+
				"dtTableKeyType=?,"+
						
				"ExpWorkflowFileFlag=?,"+
				"ExpWorkflowFileForZipFlag=?,"+
				"ExpWorkflowRemarkFileFlag=?,"+
				"ExpWorkflowRemarkFileForZip=?,"+
				"ExpWorkflowFilePath=?,"+
				"ExpWorkflowInfoFlag=?,"+
				"ExpWorkflowInfoPath=?,"+
				"ExpWorkflowRemarkFlag=?,"+
				"ExpSignFileFlag=?,"+		
				"ExpSignFilePath=?, "+
				
				
				"zwMapFiletype=?,"+
				"fjMapFiletype=?,"+
				"dwdMapFiletype=?,"+
				"mwdMapFiletype=?,"+
				"remarkWDMapFiletype=?,"+
				"remarkFJMapFiletype=?,"+
				"bdMapFiletype=?"+
		
		
				" where "+
				" id="+proId;
		
		statement.setStatementSql(sql);
		
		statement.setString(1, name);
		statement.setString(2, fileSaveType);
		statement.setInt(3, Util.getIntValue(regitType,-1));
		statement.setString(4,expTableType);
		statement.setString(5, synType);
		statement.setString(6, timeModul);
		statement.setString(7, frequency);
		statement.setInt(8,Util.getIntValue(frequencyy,1) );
		statement.setString(9, createType);
		statement.setString(10, createTime);
		
		statement.setInt(11, Util.getIntValue(regitDBId,-1));
		statement.setString(12,mainTableKeyType);
		statement.setString(13, dtTableKeyType);
		
		statement.setString(14, ExpWorkflowFileFlag);
		statement.setString(15, ExpWorkflowFileForZipFlag);
		statement.setString(16, ExpWorkflowRemarkFileFlag);
		statement.setString(17, ExpWorkflowRemarkFileForZip);
		statement.setString(18, ExpWorkflowFilePath);
		statement.setString(19, ExpWorkflowInfoFlag);
		statement.setString(20, ExpWorkflowInfoPath);
		statement.setString(21, ExpWorkflowRemarkFlag);
		statement.setString(22, ExpSignFileFlag);
		statement.setString(23, ExpSignFilePath);
		
		
		statement.setString(24, zwMapFiletype);
		statement.setString(25, fjMapFiletype);
		statement.setString(26, dwdMapFiletype);
		statement.setString(27, mwdMapFiletype);
		statement.setString(28, remarkWDMapFiletype);
		statement.setString(29, remarkFJMapFiletype);
		statement.setString(30, bdMapFiletype);
		
		if(!proId.equals("")){
		statement.executeUpdate();

		sql="delete exp_dbmaintablesetting where dbsettingid='"+proId+"'";
		RecordSet rs1=new RecordSet();
		rs1.executeSql(sql);
		
		//保存主表字段
	 if(mainfieldNames!=null){
		for(int i=0;i<mainfieldNames.length;i++){
			if(mainfieldNames[i]!=null && !"".equals(mainfieldNames[i].trim())){
				sql = "insert into exp_dbmaintablesetting("+
				"dbsettingid,"+
				"columnname,"+
				"columntype,"+
				"primarykey,"+
				"isdoce,"+
				"doctype,"+
				"filename"+
				
				") values("+
				"?,?,?,?,?,?,?"+
				")";
				statement.setStatementSql(sql);
				statement.setInt(1,Util.getIntValue(proId,-1));
				statement.setString(2, mainfieldNames[i]);
				statement.setString(3,mainfieldtypes[i]);
				statement.setString(4, mainiskeys[i]);
				statement.setString(5, mainisdocs[i]);
				statement.setString(6, mainisdoctypes[i]);
				statement.setString(7, mainisdocnames[i]);
				statement.executeUpdate();
			}
		}
	 }
		
		sql="delete exp_dbdetailtablesetting where dbsettingid='"+proId+"'";
		rs1.executeSql(sql);
		//保存明细表字段
		if(dtfieldNames!=null){
		for(int i=0;i<dtfieldNames.length;i++){
			if(dtfieldNames[i]!=null && !"".equals(dtfieldNames[i].trim())){
				sql = "insert into exp_dbdetailtablesetting("+
				"dbsettingid,"+
				"columnname,"+
				"columntype,"+
				"primarykey,"+
				"isdoce,"+
				"doctype,"+
				"mainid,"+
				"filename"+
				
				") values("+
				"?,?,?,?,?,?,?,?"+
				")";
				statement.setStatementSql(sql);
				statement.setInt(1,Util.getIntValue(proId,-1));
				statement.setString(2, dtfieldNames[i]);
				statement.setString(3,dtfieldtypes[i]);
				statement.setString(4, dtiskeys[i]);
				statement.setString(5, dtisdocs[i]);
				statement.setString(6, dtisdoctypes[i]);
				statement.setString(7, dtismainkeys[i]);
				statement.setString(8, dtisdocnames[i]);
				statement.executeUpdate();
			}
		}
		}
		
		sql = "update exp_ProList set "+
		"ProName='"+name+"',"+
		"ProType='1',"+
		"ProFileSaveType='"+fileSaveType+"'"+
		
		" where "+
		" id="+id;
		rs1.executeSql(sql);
		
		}
		
	}catch(Exception e){
		new BaseBean().writeLog(e);
		
	}finally{
		try{
			statement.close();
		}catch(Exception e){
			
		}
	}
	
	String para = id+separator+name +separator+ fileSaveType +separator + createdate +separator + userid ;
	 SysMaintenanceLog.resetParameter();
   SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
   SysMaintenanceLog.setRelatedName(name);
   SysMaintenanceLog.setOperateType("2");
   SysMaintenanceLog.setOperateDesc("exp_DBProSettings_Update,"+para);
   SysMaintenanceLog.setOperateItem("162");
   SysMaintenanceLog.setOperateUserid(user.getUID());
   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
   SysMaintenanceLog.setSysLogInfo();
}
else if(operation.equals("delete")){
	String id = Util.null2String(request.getParameter("id"));//id
	if(!"".equals(id)){
		proId = id;
	}
	List ids = Util.TokenizerString(proId,",");

	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++)		{
			String tempid = Util.null2String((String)ids.get(i));
			ExpUtil eu=new ExpUtil();
			
			if(!"".equals(tempid))			{
				String tempProid= eu.getProidById(tempid);
				String tempworkflowname="";
				RecordSet.execute("select *  from exp_DBProSettings where id = "+tempProid);
				if(RecordSet.next()){
					tempworkflowname=Util.null2String(RecordSet.getString("name")) ;
				}
				if(RecordSet.execute("delete from exp_DBProSettings where id = "+tempProid))
				{
					RecordSet.execute("delete from exp_ProList where id = "+tempid);
				}
				 String para =""+tempProid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(tempProid));
			     SysMaintenanceLog.setRelatedName(tempworkflowname);
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("exp_DBProSettings_delete,"+para);
			     SysMaintenanceLog.setOperateItem("162");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
			}
		}
	}
}
ExpDBcominfo.removeExpDBCacheInfo();
if("1".equals(isDialog)){
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="/integration/exp/ExpProDetail.jsp?backto=<%=backto%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("/integration/exp/ExpProDetail.jsp?backto="+backto);
%>