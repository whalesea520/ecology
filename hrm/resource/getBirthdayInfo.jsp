<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.settings.RemindSettings"%>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.common.DateUtil"%>
<%@ page import="java.util.ArrayList,java.util.Iterator" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user==null)return;

JSONArray jsonArr = new JSONArray();
JSONObject json = new JSONObject();
ArrayList<String[]> birthEmployers=(ArrayList<String[]>)application.getAttribute("birthEmployers");

RemindSettings settings=(RemindSettings)application.getAttribute("hrmsettings");//生日提醒参数
int birthdialogstyle = Util.getIntValue(settings.getBirthdialogstyle(),1);//弹窗样式
String birthshowfield = settings.getBirthshowfield();//显示字段
String congratulation=Util.stringReplace4DocDspExt(settings.getCongratulation());
String birthshowfieldcolor = "";//Util.null2String(settings.getBirthshowfieldcolor(),"");//字段颜色
String birthshowcontentcolor = "";//Util.null2String(settings.getBirthshowcontentcolor(),"");//提醒内容颜色
if("".equals(birthshowfieldcolor)){
	birthshowfieldcolor = "3b486d";
}
if("".equals(birthshowcontentcolor)){
	birthshowcontentcolor = "3b486d";
}
String url = "/images_face/ecologyFace_1/BirthdayFace/1/BirthdayBg_3_wev8.jpg";
int rowIndex = 0;
rs.executeSql("select docid,docname from HrmResourcefile " 
		+ " where resourceid='0' and scopeId ='-99' and fieldid='-99' order by id");
while(rs.next()){
	rowIndex++;
	if(birthdialogstyle==rowIndex){
		url ="/weaver/weaver.file.FileDownload?fileid="+Util.null2String(rs.getString("docid"));
	}
}

if(birthEmployers!=null){
	Iterator<String[]> iter=birthEmployers.iterator();
	String[] empInfo = null;
	String[] deptinfo = null;
	while(iter.hasNext()){
		empInfo = iter.next();
		deptinfo = new String[empInfo.length];
		String comInfo = "";
		String nameInfo = "";
		for(int i=1;empInfo!=null&&i<empInfo.length;i++){
			if(Util.null2String(empInfo[i]).length()==0)continue;
			if(birthshowfield.indexOf("3")==-1 && i==1)continue;//分部
			if(birthshowfield.indexOf("2")==-1 && i==2)continue;//部门
			if(comInfo.length()>0)comInfo+="-";
			comInfo+=empInfo[i];
			deptinfo[i] = empInfo[i];
		}
   	
   	if(comInfo.length()>0){
   		if(birthshowfield.indexOf("3") !=-1 && birthshowfield.indexOf("2") !=-1){
   			comInfo = deptinfo[2]+"-"+deptinfo[1];
   		}else if(birthshowfield.indexOf("3") !=-1){
   			comInfo = deptinfo[1];
   		}else if(birthshowfield.indexOf("2") !=-1){
   			comInfo = deptinfo[2];
   		}
   	}
 		nameInfo=empInfo[0];
		JSONObject tmp = new JSONObject();
		tmp.put("lastname", nameInfo);
		tmp.put("detialInfo",comInfo);
		jsonArr.add(tmp);
	}
}

json.put("bgimg", url);
json.put("curdate", DateUtil.getCurrentDate());
json.put("congratulation",congratulation);
json.put("textcolor",birthshowfieldcolor);
json.put("usercolor",birthshowcontentcolor);
json.put("userlist",jsonArr.toString());
out.println(json.toString());
%>
