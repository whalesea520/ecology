
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="java.util.*" %>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>

<%
	String codemainid = Util.null2String(request.getParameter("codemainid"));
	String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));
	String type = Util.null2String(request.getParameter("type"));
	String fielddbtype = Util.null2String(request.getParameter("fielddbtype"));
	String fieldnamepara = Util.null2String(request.getParameter("fieldname"));
	String fieldId = Util.null2String(request.getParameter("fieldId"));
	String contentstr = Util.null2String(request.getParameter("contentstr"));
	String labelstr = Util.null2String(request.getParameter("labelstr"));
	
	int language = user.getLanguage();
	
	String showname = "0"; //不适用htmllabelinfo表获取，取shownamestr值
	String showtype = ""; //类型
	String showvalue = fieldnamepara; //当前使用的字段
	int codeorder = 0; //排序
	String isSerial = "0"; //是否开启单独流水
	String tablename = ""; //第三方表名(主要是browser和树所使用的表)
	String fieldname = ""; //第三方字段(主要是browser和树所使用的字段)
	String fieldnamestr = labelstr; //内容中显示的内容，如本身值等
	String shownamestr = ""; //标题列显示的内容，替代showname
	
	if (!"".equals(contentstr)&&contentstr.indexOf(".")>-1) {
		tablename = contentstr.substring(0, contentstr.indexOf("."));
		fieldname = contentstr.substring(contentstr.indexOf(".")+1);
	} else {
		fieldname = contentstr;
	}
	
	//获取流水号序号
	rs.executeSql("select codeorder from modecodedetail where showname='18811' and showtype=2 and codemainid="+codemainid);
	int num = 0;
	if (rs.next()) {
		num = rs.getInt("codeorder");
	}
	
	codeorder = num;
	if ("1".equals(fieldhtmltype)) { //文本
		showtype = "7";
		shownamestr = SystemEnv.getHtmlLabelName(608,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
	} else if ("3".equals(fieldhtmltype)) { //browser
		if ("161".equals(type)) { //自定义单选
			showtype = "4";
			shownamestr = SystemEnv.getHtmlLabelName(32306,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else if ("2".equals(type)) { //日期
			showtype = "5";
			shownamestr = SystemEnv.getHtmlLabelName(97,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else if ("1".equals(type)) { //人员
			if ("1".equals(fieldname)) { //值为空的时候，转成其它类型浏览框，取本身值
				showtype = "9";
			} else {
				showtype = "4";
			}
			shownamestr = SystemEnv.getHtmlLabelName(1867,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else if ("4".equals(type)) { //部门
			if ("4".equals(fieldname)) { //值为空的时候，转成其它类型浏览框，取本身值
				showtype = "9";
			} else {
				showtype = "4";
			}
			shownamestr = SystemEnv.getHtmlLabelName(124,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else if ("164".equals(type)) { //分部
			if ("164".equals(fieldname)) { //值为空的时候，转成其它类型浏览框，取本身值
				showtype = "9";
			} else {
				showtype = "4";
			}
			shownamestr = SystemEnv.getHtmlLabelName(141,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else if ("256".equals(type)) { //树形
			showtype = "4";
			shownamestr = SystemEnv.getHtmlLabelName(32308,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		} else { //其它浏览框为9
			showtype = "9";
			shownamestr = SystemEnv.getHtmlLabelName(32306,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		}
	} else if ("5".equals(fieldhtmltype)) { //select
		showtype = "8";
		shownamestr = SystemEnv.getHtmlLabelName(690,language)+"("+showvalue+")"+SystemEnv.getHtmlLabelName(261,language);
		
	} else if ("0".equals(fieldhtmltype)) { //字符串
		showtype = "6";
		isSerial = "0";
		shownamestr = SystemEnv.getHtmlLabelName(27903,language);
	}
	
	
	String sql = "insert into modecodedetail(codemainid,showname,showtype,showvalue,codeorder,isSerial,tablename,fieldname,fieldnamestr,shownamestr) values(" + 
			codemainid + ",'"+showname+"','"+showtype+"','"+showvalue+"','"+codeorder+"','"+isSerial+"','"+tablename+"','"+fieldname+"','"+fieldnamestr+"','"+shownamestr+"'" + 
			     ")";
	rs.executeSql(sql);
	//System.out.println(sql);
	
	//将新增加的项永远放到流水号前面
	rs.executeSql("update modecodedetail set codeorder="+(num+1)+" where showname='18811' and showtype=2 and codemainid="+codemainid);
	
	response.sendRedirect("/formmode/setup/addModeCodeFieldIframe.jsp?isclose=1");
%>