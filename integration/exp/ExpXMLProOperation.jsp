<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.Prop"%>
<%@page import="weaver.expdoc.ExpUtil"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExpXMLCominfo" class="weaver.expdoc.ExpXMLCominfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
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
String synType = Util.null2String(request.getParameter("synType"));//同步方式
String timeModul = Util.null2String(request.getParameter("TimeModul"));//时间模式
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
String XMLType = Util.null2String(request.getParameter("XMLType"));//XML格式
String XMLEcodingType = Util.null2String(request.getParameter("XMLEcodingType"));//XML文件编码
String XMLFileType = Util.null2String(request.getParameter("XMLFileType"));//XML文件信息格式
String XMLHaveRemark = Util.null2String(request.getParameter("XMLHaveRemark"));//XML包含流转意见
String xmltext = Util.null2String(request.getParameter("xmltext"));//-XML模板内容
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

int userid = user.getUID();
String createdate = TimeUtil.getCurrentTimeString();

if(operation.equals("add")){
	ConnStatement statement = null;
	try{
	//RecordSet.executeSql("insert into exp_localdetail(name,path,createdate,creator) values('"+name+"','"+path+"','"+createdate+"',"+userid+")");
	statement=new ConnStatement();
	
	//exp_ProList
	String sql = "insert into exp_XMLProSettings("+
				"name,"+
				"FileSaveType,"+
				" regitType,"+
				" synType,"+
				
				" TimeModul,"+
				" Frequency, "+
				"frequencyy, "+
				"createType, "+
				
				"createTime,"+
				"XMLType,"+
				"XMLEcodingType,"+
				"XMLFileType,"+
				
				"XMLHaveRemark,"+
				"xmltext,"+
				"ExpWorkflowFileFlag,"+
				"ExpWorkflowFileForZipFlag,"+
				
				"ExpWorkflowRemarkFileFlag,"+
				"ExpWorkflowRemarkFileForZip,"+
				"ExpWorkflowFilePath,"+
				"ExpWorkflowInfoFlag,"+
				
				"ExpWorkflowInfoPath,"+
				"ExpWorkflowRemarkFlag,"+
				"ExpSignFileFlag,"+
				"ExpSignFilePath"+
				") values("+
				"'"+StringEscapeUtils.escapeSql(name)+"',"+
				"'"+StringEscapeUtils.escapeSql(fileSaveType)+"',"+
				Util.getIntValue(regitType,-1)+","+
				"'"+StringEscapeUtils.escapeSql(synType)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(timeModul)+"',"+
				""+Util.getIntValue(frequency,1)+","+
				""+Util.getIntValue(frequencyy,1)+","+
				"'"+StringEscapeUtils.escapeSql(createType)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(createTime)+"',"+
				"'"+StringEscapeUtils.escapeSql(XMLType)+"',"+
				"'"+StringEscapeUtils.escapeSql(XMLEcodingType)+"',"+
				"'"+StringEscapeUtils.escapeSql(XMLFileType)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(XMLHaveRemark)+"',"+
				"'"+StringEscapeUtils.escapeSql(xmltext)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFileForZipFlag)+"',"+
				
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFileForZip)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowFilePath)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowInfoFlag)+"',"+

				"'"+StringEscapeUtils.escapeSql(ExpWorkflowInfoPath)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpWorkflowRemarkFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpSignFileFlag)+"',"+
				"'"+StringEscapeUtils.escapeSql(ExpSignFilePath)+"')";
		RecordSet.executeSql(sql);		
		
		int Proid=-1;
		sql = "select max(id) as maxid from exp_XMLProSettings ";
		RecordSet.executeSql(sql);
		
		if(RecordSet.next()){
			Proid = Util.getIntValue(RecordSet.getString("maxid"), -1);
		}
		
		sql = "insert into exp_ProList("+
				"ProName,"+
				"Proid,"+
				"ProType,"+
				"ProFileSaveType"+
				
				") values("+
				"'"+StringEscapeUtils.escapeSql(name)+"',"+Proid+",'0','"+StringEscapeUtils.escapeSql(fileSaveType)+"'"+
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
    SysMaintenanceLog.setOperateDesc("exp_XMLProSettings_Insert,"+para);
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
	//exp_ProList
	String sql = "";
		sql = "update exp_XMLProSettings set "+
				"name=?,"+
				"FileSaveType=?,"+
				" regitType=?,"+
				" synType=?,"+
				" TimeModul=?,"+
				
				" Frequency=?, "+
				"frequencyy=?, "+
				"createType=?, "+
				"createTime=?,"+
				"XMLType=?,"+
				
				"XMLEcodingType=?,"+
				"XMLFileType=?,"+
				"XMLHaveRemark=?,"+
				"xmltext=?,"+
				"ExpWorkflowFileFlag=?,"+
				
				"ExpWorkflowFileForZipFlag=?,"+
				"ExpWorkflowRemarkFileFlag=?,"+
				"ExpWorkflowRemarkFileForZip=?,"+
				"ExpWorkflowFilePath=?,"+
				"ExpWorkflowInfoFlag=?,"+
				
				"ExpWorkflowInfoPath=?,"+
				"ExpWorkflowRemarkFlag=?,"+
				"ExpSignFileFlag=?,"+
				"ExpSignFilePath=? "+
				" where "+
				" id="+proId;
		
		statement.setStatementSql(sql);
		
		statement.setString(1, name);
		statement.setString(2, fileSaveType);
		statement.setInt(3, Util.getIntValue(regitType,-1));
		statement.setString(4, synType);
		statement.setString(5, timeModul);
		statement.setString(6, frequency);
		statement.setInt(7,Util.getIntValue(frequencyy,1) );
		statement.setString(8, createType);
		statement.setString(9, createTime);
		statement.setString(10,XMLType);
		statement.setString(11,XMLEcodingType);
		statement.setString(12, XMLFileType);
		
		statement.setString(13, XMLHaveRemark);
		statement.setString(14, xmltext);
		statement.setString(15, ExpWorkflowFileFlag);
		statement.setString(16, ExpWorkflowFileForZipFlag);
		statement.setString(17, ExpWorkflowRemarkFileFlag);
		statement.setString(18, ExpWorkflowRemarkFileForZip);
		statement.setString(19, ExpWorkflowFilePath);
		statement.setString(20, ExpWorkflowInfoFlag);
		statement.setString(21, ExpWorkflowInfoPath);
		statement.setString(22, ExpWorkflowRemarkFlag);
		statement.setString(23, ExpSignFileFlag);
		statement.setString(24, ExpSignFilePath);
		
		if(!proId.equals("")){
		statement.executeUpdate();
		sql = "update exp_ProList set "+
		"ProName=?,"+
		"ProType=?,"+
		"ProFileSaveType=?"+
		
		" where "+
		" id="+id;
		statement.setStatementSql(sql);
		statement.setString(1, name);
		statement.setString(2,"0");
		statement.setString(3, fileSaveType);
		statement.executeUpdate();
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
   SysMaintenanceLog.setOperateDesc("exp_XMLProSettings_Update,"+para);
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
				String tempProid= "";
				String tempProtype= "";
				String sql="select * from exp_ProList where id='"+tempid+"'";
				RecordSet.execute(sql);
				if(RecordSet.next()){
					tempProid=RecordSet.getString("Proid");
					tempProtype=RecordSet.getString("ProType");
				}
				String tempworkflowname="";
				if(tempProtype.equals("0")){
				RecordSet.execute("select *  from exp_XMLProSettings where id = "+tempProid);
				if(RecordSet.next()){
					tempworkflowname=Util.null2String(RecordSet.getString("name")) ;
				}
				sql="delete from exp_XMLProSettings where id = "+tempProid;
				}
				else if(tempProtype.equals("1")){
					RecordSet.execute("select *  from exp_DBProSettings where id = "+tempProid);
					if(RecordSet.next()){
						tempworkflowname=Util.null2String(RecordSet.getString("name")) ;
					}
					sql="delete from exp_DBProSettings where id = "+tempProid;
				}
				if(RecordSet.execute(sql))
				{
					RecordSet.execute("delete from exp_ProList where id = "+tempid);
				}
				String para =""+tempProid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(tempProid));
			     SysMaintenanceLog.setRelatedName(tempworkflowname);
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("exp_ProList_delete,"+para);
			     SysMaintenanceLog.setOperateItem("162");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
			}
		}
	}
}
ExpXMLCominfo.removeExpXMLCacheInfo();
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