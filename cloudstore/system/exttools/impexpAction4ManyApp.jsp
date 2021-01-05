<%@page language="java" contentType="text/html;charset=UTF-8"%> 
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils" %>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ExpDataService" %>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ImpDataService"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.file.FileManage"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ProgressStatus"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.OperateThread4app"%>
<%@page import="weaver.formmode.exttools.impexp.common.FileUtils"%>
<%@page import="java.util.*"%>
<%@page import="ln.LN" %>
<%@page import="com.cloudstore.api.util.Util_FileCopy" %>
<%
	String type = StringUtils.null2String(request.getParameter("type"));
	String id = StringUtils.null2String(request.getParameter("id"));
	String appNo = StringUtils.null2String(request.getParameter("appNo"));
	String pageid=appNo;
	User user = HrmUserVarify.getUser(request, response);
	String sessionid = session.getId();
	int userid = user.getUID();
	JSONObject jsonObject = new JSONObject();
	String version="";
	List<String> fileList=new ArrayList<String>();
	Util_FileCopy utilFile=new Util_FileCopy();	
	String dir=GCONST.getRootPath() + "cloudstore"
			+ File.separator + "app" + File.separator + appNo
			+ File.separator + "resource";
	String start=appNo+"app";
	String end=".zip";
	fileList=utilFile.FindFileList(dir, start, end);
	if("1".equals(type)){//导入
		for(int i=0;i<fileList.size();i++){
			pageid=fileList.get(i);
			//System.out.println("-----------fileList.get(i):"+fileList.get(i));
			ProgressStatus.create(sessionid, pageid, userid, 1);
			String isadd = StringUtils.null2String(request.getParameter("isadd"));
			String ptype = StringUtils.null2String(request.getParameter("ptype"));
			RecordSet rs = new RecordSet();
			int fileid = 0;
			String xmlfilepath = "";
			if ("0".equals(ptype)) {
				try {
					rs.executeProc("SequenceIndex_SelectFileid", "");
					if (rs.next()) {
						fileid = StringUtils.getIntValue(rs.getString(1),-1);
					}
				} catch (Exception e) {
					fileid = -1;
					e.printStackTrace();
				}
				xmlfilepath = GCONST.getRootPath() + "cloudstore"
						+ File.separator + "app" + File.separator + appNo
						+ File.separator + "resource" + File.separator
						+ fileList.get(i);
				char separator = StringUtils.getSeparator();
				String fileName =fileList.get(i);// appNo + ".zip";
				String para = "" + fileid + separator + fileName
						+ separator + "" + separator + "1" + separator
						+ xmlfilepath + separator + "0" + separator + "0"
						+ separator + "1000";
				rs.executeProc("ImageFile_Insert", para);
			} 
			boolean add = "1".equals(isadd) ? true : false;
			Thread thread = new Thread(new OperateThread4app(id, userid,
					xmlfilepath, fileid, sessionid, add, version, pageid));
			thread.start();
		}
		out.print(jsonObject.toString());
	} else if ("2".equals(type)) {//查看导入/导出日志明细
		int logid = StringUtils.getIntValue(request
				.getParameter("logid"));
		//System.out.println("logid="+logid);
		String sql = "select * from mode_impexp_logdetail where logid='"
				+ logid + "' order by id";
		RecordSet rs = new RecordSet();
		rs.executeSql(sql);
		String str = "";
		int i = 1;
		while (rs.next()) {
			String message = StringUtils.null2String(rs.getString("message"));
			str += (i++) + ":" + message + "\n";
		}
		out.clear();
		out.print(str);
		return;
	} else if ("3".equals(type)) {//获取导入导出进度
		jsonObject.put("inprocess", false);
		int percent=0;
		for(int i=0;i<fileList.size();i++){
			pageid=fileList.get(i);
			Map<String, Object> progressStatusMap = ProgressStatus.get(sessionid, pageid);
			if (progressStatusMap != null) {
				percent+= ProgressStatus.getCurrentProgressPersent(sessionid, pageid);
				int ptype = ProgressStatus.getPtype(sessionid, pageid);
				String logid = ProgressStatus.getLogid(sessionid, pageid);
				jsonObject.put("inprocess", true);
				jsonObject.put("process", percent/fileList.size());
				jsonObject.put("ptype", ptype);
				jsonObject.put("logid", logid);
				jsonObject.put("error", progressStatusMap.get("error"));
				if (progressStatusMap.containsKey("datatype")) {
					if ("app".equals(StringUtils.null2String(progressStatusMap.get("datatype")))) {
						jsonObject.put("datatype", "应用");
					} 
				}
			}			
		}
		//System.out.println("-----------jsonObject.toString()"+jsonObject.toString());
		out.print(jsonObject.toString());
	} else if ("4".equals(type)) {
		for(int i=0;i<fileList.size();i++){
			ProgressStatus.finish(sessionid, fileList.get(i));
			//System.out.println("-----------fileList.get(i):"+fileList.get(i));
		}
		return;
	}
%>