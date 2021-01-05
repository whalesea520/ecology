<%@ page import="weaver.general.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%

	String propertyPath = GCONST.getRootPath() + "WEB-INF" + File.separator + "prop" + File.separator;
	String weaverPath = propertyPath + "weaver.properties";

	Properties weaverConfig = new Properties();
	weaverConfig.load( new FileInputStream(weaverPath) );

	String overtimePath = propertyPath + "workflowovertime.properties";
	Properties overtimeConfig = new Properties();
	overtimeConfig.load( new FileInputStream(overtimePath) );

	String overtime = request.getParameter("overtime");
	if( overtime == null || overtime.trim().equals("")){
		weaverConfig.remove("ecology.overtime");
	}else{
		weaverConfig.setProperty("ecology.overtime", overtime);
	}

	String changestatus = request.getParameter("changestatus");
	if( changestatus == null){
		weaverConfig.remove("ecology.changestatus");
	}else{
		weaverConfig.setProperty("ecology.changestatus", "1");
	}

	weaverConfig.store(new FileOutputStream(weaverPath), " modified by WorkflowSettings.jsp @ " + new Date());

	String skipNotWorkDate = request.getParameter("skipNotWorkDate");
	if( skipNotWorkDate == null){
		overtimeConfig.setProperty("WORKFLOWOVERTIMETEMP", "0");
	}else{
		overtimeConfig.setProperty("WORKFLOWOVERTIMETEMP", "1");
	}

	overtimeConfig.store(new FileOutputStream(overtimePath), " modified by WorkflowSettings.jsp @ " + new Date());

    //个性化签章设置
    String showimg = Util.null2String(request.getParameter("showimg"));
	String imgheight = Util.null2String(request.getParameter("imgheight"));
	String imgshowtpe = Util.null2String(request.getParameter("imgshowtpe"));
    String signaturePath = propertyPath + "WFSignatureImg.properties";
	File f = new File(signaturePath);
	if(!f.exists()){
	   f.createNewFile();
	}
	BufferedWriter writer = new BufferedWriter(new FileWriter(f));
	writer.write("#流转意见中操作人是否显示签章图片 1：为显示");
	writer.newLine();
	writer.write("showimg = "+showimg);
	writer.newLine();
	writer.write("#以下参数只适用于图形化");
	writer.newLine();
	writer.write("#签章图片高度，单位 (像素)");
	writer.newLine();
	writer.write("imgheight = "+imgheight);
	writer.newLine();
	writer.write("#图片显示方式 1：原始尺寸 2：自动缩放");
	writer.newLine();
	writer.write("imgshowtpe = "+imgshowtpe);
	writer.close();
	/*
	Properties signatureConfig = new Properties();
	signatureConfig.load( new FileInputStream(f) );
	String showimg = Util.null2String(request.getParameter("showimg"));
	String imgheight = Util.null2String(request.getParameter("imgheight"));
	String imgshowtpe = Util.null2String(request.getParameter("imgshowtpe"));
	signatureConfig.setProperty("showimg",showimg);
	signatureConfig.setProperty("imgheight",imgheight);
	signatureConfig.setProperty("imgshowtpe",imgshowtpe);
	signatureConfig.store(new FileOutputStream(signaturePath), " modified by WorkflowSettings.jsp @ " + new Date());
	*/
	String scan = request.getParameter("scan");
	String mobilechangemode = request.getParameter("mobilechangemode");
	String mobilemode = request.getParameter("mobilemode");
	String mobileapplyworkflow = request.getParameter("mobileapplyworkflow");
	String mobileapplyworkflowids = request.getParameter("mobileapplyworkflowids");
	if(scan == null || scan.trim().equals("")){
		scan = "0";
	}
	if("on".equals(mobilechangemode)){
		mobilechangemode = "1";
	}else{
		mobilechangemode = "0";
	}
	if(mobilechangemode == null || mobilechangemode.trim().equals("")){
		mobilechangemode = "0";
	}
	RecordSet.executeSql("update SystemSet set scan=" + scan+",mobilechangemode="+mobilechangemode+",mobilemode="+mobilemode+",mobileapplyworkflow='"+mobileapplyworkflow+"',mobileapplyworkflowids='"+mobileapplyworkflowids+"'");

	response.sendRedirect("WorkflowSettings.jsp");
	
%>
