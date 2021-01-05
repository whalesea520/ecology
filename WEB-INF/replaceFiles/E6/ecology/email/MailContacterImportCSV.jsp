<%@ page language="java" contentType="text/html;charset=gbk" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>

<%@ include file="/systeminfo/init.jsp" %>

<%!
	private boolean validateFileExt(String filename){
		if(filename==null)return false;
		if(filename.indexOf(".")!=filename.lastIndexOf(".")){
			return false;
		}
		String[] allowTypes  = new String[]{".csv"};
		if(filename!=null && allowTypes!=null){
			for(int i=0;i<allowTypes.length;i++){
				if(filename.toLowerCase().endsWith(allowTypes[i].toLowerCase())){
					return true;
				}
			}
			return false;
		}else{
			return false;
		}
	}
%>

<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(572,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(18596,user.getLanguage()) + "CSV";
String needfav ="1";
String needhelp ="";

int groupId = 0;
String str = "";
String fullFileName = "";
String path = GCONST.getRootPath() + "email" + File.separatorChar + "csv";
String pathTemp = GCONST.getRootPath() + "email" + File.separatorChar + "csv" + File.separatorChar + "temp";
if(!new File(path).isDirectory()) new File(path).mkdirs();
if(!new File(pathTemp).isDirectory()) new File(pathTemp).mkdirs();

DiskFileUpload fu = new DiskFileUpload();
//fu.setSizeMax(4194304);				//4MB
fu.setSizeThreshold(4096);				//缓冲区大小4kb
fu.setRepositoryPath(pathTemp);

List fileItems = fu.parseRequest(request);
Iterator i = fileItems.iterator();
try{
	while(i.hasNext()){
		FileItem item = (FileItem)i.next();
		if(!item.isFormField()){
			String name = item.getName();
			if(Util.isExcuteFile(name)) continue;
			long size = item.getSize();
			if((name==null || name.equals("")) || size==0)	continue;
			
			name = name.replace('\\','/');
			fileName = fileName.replaceAll("%00","").replaceAll("%","");
			if(!validateFileExt(fileName)) continue;
			File fullFile = new File(name);
			fullFileName = fullFile.getName().toLowerCase();
			File savedFile = new File(path + File.separatorChar, fullFileName);
			item.write(savedFile);

			//===============================================================================================
			// Read CSV
			//===============================================================================================
			try{
				java.util.Properties ps = new java.util.Properties();
				ps.put("charset","GBK");
				
				Class.forName("org.relique.jdbc.csv.CsvDriver");
				Connection conn = DriverManager.getConnection("jdbc:relique:csv:" + path, ps);

				Statement stmt = conn.createStatement();
				ResultSet results = stmt.executeQuery("SELECT * FROM "+fullFileName.substring(0, fullFileName.length()-4)+"");
				ResultSetMetaData md = results.getMetaData();

				str += "<select><option value=''></option>";
				for(int j=1;j<=md.getColumnCount();j++){
				str += "<option value=\""+md.getColumnName(j)+"\">"+md.getColumnName(j)+"</option>";
				}
				str += "</select>";

				results.close();
				stmt.close();
				conn.close();
			}catch(Exception e){
				System.out.println("csvjdbc-> " + e);
			}
			//===============================================================================================
		}else{
			if(item.getFieldName().equals("groupId")) groupId=Util.getIntValue(item.getString());
		}
	}
}catch(FileNotFoundException e){
	//TODO
	e.printStackTrace();
}
%>

<html>
<head>
<script type="text/javascript" src="/js/prototype.js"></script>
<script type="text/javascript">
function doSubmit(){
	var fields = "";
	var columnNames = "";
	var columnName = "";
	var o = document.getElementsByTagName("SELECT");
	for(var i=0;i<o.length;i++){
		columnName = o[i].options[o[i].selectedIndex].value;
		if(columnName==""){
			//columnNames += "''" + ",";
			continue;
		}else{
			columnNames += columnName + ",";
			fields += o[i].parentNode.firstChild.value + ",";
		}
	}
	$("columnNames").value = columnNames;
	$("fieldNames").value = fields;
	//alert(fields);
	//alert($("columnNames").value);
	$("fMailContacter").submit();
}
function doCancel(){
	location.href = "MailContacter.jsp";
}
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver.css" />
</head>
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doCancel(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailContacterOperation.jsp" id="fMailContacter">
<input type="hidden" name="operation" value="contacterImportCSV" />
<input type="hidden" name="groupId" value="<%=groupId%>" />
<input type="hidden" id="columnNames" name="columnNames" value="" />
<input type="hidden" id="fieldNames" name="fieldNames" value="" />
<input type="hidden" id="path" name="path" value="<%=path%>" />
<input type="hidden" id="fullFileName" name="fullFileName" value="<%=fullFileName%>" />
<table class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())//基本信息%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())//姓名%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserName"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19805,user.getLanguage())//邮件地址%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailAddress"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())//说明%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserDesc"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())//个人信息%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())//电话%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserTelP"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(422,user.getLanguage())//手机%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserMobileP"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(20030,user.getLanguage())//即时通讯%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserIMP"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(19814,user.getLanguage())//家庭住址%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserAddressP"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())//工作信息%></th>
</tr>
<tr class="Spacing"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(421,user.getLanguage())//电话%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserTelW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(494,user.getLanguage())//传真%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserFaxW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(1851,user.getLanguage())//公司%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserCompanyW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())//部门%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserDepartmentW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())//岗位%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserPostW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(17095,user.getLanguage())//联系地址%></td>
	<td class="Field"><input type="hidden" name="fields" value="mailUserAddressW"><%=str%></td>
</tr>
<tr><td class="Line" colspan="2"></td></tr>
</table>
</form>
<!--==========================================================================================-->
<div id="help" class="help"><%=SystemEnv.getHtmlLabelName(20023,user.getLanguage())//%></div>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>