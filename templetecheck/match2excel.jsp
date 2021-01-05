<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.templetecheck.MatchUtil" %>
<%@ page import="weaver.templetecheck.CheckUtil" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%!
public String changeStr(String str) {
	if(str!=null&&!"".equals(str)) {
		str = str.replaceAll("&#124;","\\|");
		str = str.replaceAll("&#94;","\\^");
	}

	//str = str.replaceAll("&","&amp;");
	
	return str;
}
%>
<%
Map<String,String> otherparams =new HashMap<String,String>();
String tabtype = request.getParameter("tabtype");
String ruleid = request.getParameter("ruleid");
String ishtml = request.getParameter("ishtml");//0--流程模板 1--配置文件 2--web.xml 3.其他 4.移动建模模板  5.表单建模模板  6 自定义页面查询
String name = request.getParameter("name");
String description = request.getParameter("description");
String status = request.getParameter("status");

otherparams.put("type","1");
otherparams.put("tabtype",""+tabtype);
otherparams.put("ruleid",""+ruleid);
otherparams.put("ishtml",""+ishtml);
otherparams.put("name",""+name);
otherparams.put("description",""+description);
otherparams.put("status",""+status);
otherparams.put("match2excel","match2excel");

MatchUtil match = new MatchUtil();
List<Map<String,String>> res = match.getMatchResult(user,otherparams,request , response);

CheckUtil checkutil = new CheckUtil();
Map<String,String> otherparams2 =new HashMap<String,String>();
otherparams2.put("tabtype",""+tabtype);
otherparams2.put("ruleid",""+ruleid);
List<Map<String,String>> rules1 = checkutil.getRulesByCondition(user,otherparams2,request , response);


ExcelFile.init();
//匹配规则

ExcelSheet es = new ExcelSheet();
ExcelStyle excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelStyle excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
ExcelRow er = es.newExcelRow();
//表头
er.addStringValue("ID", "Header");

er.addStringValue("标识", "Header");
er.addStringValue("名称", "Header");
er.addStringValue("描述", "Header");
er.addStringValue("规则", "Header");
if("0".equals(ishtml)||"3".equals(ishtml)||"4".equals(ishtml)||"5".equals(ishtml)) {
	er.addStringValue("替换为", "Header");
}


for(int i = 0; i < rules1.size();i++) {
	er = es.newExcelRow();
	Map<String,String> map = (Map<String,String>)rules1.get(i);
	er.addStringValue(Util.null2String(""+(i+1)), "Border");
	er.addStringValue(Util.null2String(map.get("flageid")), "Border");
	er.addStringValue(Util.null2String(map.get("name")), "Border");
	er.addStringValue(Util.null2String(map.get("desc")), "Border");
	er.addStringValue(Util.null2String(changeStr(map.get("content"))), "Border");
	if("0".equals(ishtml)||"3".equals(ishtml)||"4".equals(ishtml)||"5".equals(ishtml)) {
		er.addStringValue(Util.null2String(changeStr(map.get("replacecontent"))), "Border");
	}
}

ExcelFile.addSheet("规则", es);
//匹配结果
es = new ExcelSheet();
excelStyle = ExcelFile.newExcelStyle("Border");
excelStyle.setCellBorder(ExcelStyle.WeaverBorderThin);
excelStyle1 = ExcelFile.newExcelStyle("Header");
excelStyle1.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor);
excelStyle1.setFontcolor(ExcelStyle.WeaverHeaderFontcolor);
excelStyle1.setFontbold(ExcelStyle.WeaverHeaderFontbold);
excelStyle1.setAlign(ExcelStyle.WeaverHeaderAlign);
excelStyle1.setCellBorder(ExcelStyle.WeaverBorderThin);
er = es.newExcelRow();
//表头
//er.addStringValue("ID", "Header");
if("0".equals(ishtml)) {
	er.addStringValue("流程名称", "Header");
	er.addStringValue("节点名称", "Header");
}

er.addStringValue("名称", "Header");
er.addStringValue("描述", "Header");
if("0".equals(ishtml)||"3".equals(ishtml)) {
	er.addStringValue("匹配内容", "Header");
	er.addStringValue("替换为", "Header");
}

er.addStringValue("地址", "Header");
if(!"0".equals(ishtml)&&!"3".equals(ishtml)) {
	er.addStringValue("状态", "Header");
}
if("1".equals(ishtml)||"2".equals(ishtml)) {
	for(int i = 0; i < res.size();i++) {
		er = es.newExcelRow();
		Map<String,String> map = res.get(i);
		
		//er.addStringValue(Util.null2String(""+(i+1)), "Border");
		if("0".equals(ishtml)) {
			er.addStringValue(Util.null2String(map.get("workflowname")), "Border");
			er.addStringValue(Util.null2String(map.get("nodename")), "Border");
		}

		er.addStringValue(Util.null2String(map.get("name")), "Border");
		er.addStringValue(Util.null2String(map.get("desc")), "Border");
		if("0".equals(ishtml)||"3".equals(ishtml)) {
			er.addStringValue(Util.null2String(changeStr(map.get("matchcontent"))), "Border");
			er.addStringValue(Util.null2String(changeStr(map.get("replacecontent"))), "Border");
		}
		
		er.addStringValue(Util.null2String(map.get("file")), "Border");
		if(!"0".equals(ishtml)&&!"3".equals(ishtml)) {
			er.addStringValue(Util.null2String(map.get("status")), "Border");
		}
	}
} else {
	HashMap<String,ArrayList<HashMap<String,String>>> map = match.getMatchResult();
	Set set = map.keySet();
	Iterator iterator = set.iterator();
	while(iterator.hasNext()) {
		String key = (String)iterator.next();
		ArrayList<HashMap<String,String>> list =  (ArrayList<HashMap<String, String>>) map.get(key);
		Iterator<HashMap<String, String>> it = list.iterator();
		while(it.hasNext()) {
			er = es.newExcelRow();//新建行
			
			HashMap<String,String>  itmap = it.next();
			if("0".equals(ishtml)||"4".equals(ishtml)||"5".equals(ishtml)) {
				er.addStringValue(Util.null2String(itmap.get("workflowname")), "Border");
				er.addStringValue(Util.null2String(itmap.get("nodename")), "Border");
			}
			er.addStringValue(Util.null2String(itmap.get("name")), "Border");
			er.addStringValue(Util.null2String(itmap.get("desc")), "Border"); 
			er.addStringValue(Util.null2String(changeStr(itmap.get("matchcontent"))), "Border");
			er.addStringValue(Util.null2String(changeStr(itmap.get("replacecontent"))), "Border");
			er.addStringValue(Util.null2String(key), "Border");
		}
	}
}


ExcelFile.setFilename("检测结果");
ExcelFile.addSheet("匹配内容", es);
%>
<iframe name="ExcelOut" id="ExcelOut" src="/weaver/weaver.file.ExcelOut" style="display:none" ></iframe>