<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.file.*,java.io.*,java.util.*,java.text.*" %>
<%@page import="wscheck.*,java.util.*,weaver.general.*,java.io.*,java.util.zip.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<%
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;
if(user==null)
	return;
FileUpload fu = new FileUpload(request,false);
boolean noFileUpload = false;
try{
	boolean test = fu.getUploadFileNames()==null;
}catch(Exception e){
	noFileUpload = true;
}

if(noFileUpload){
	response.sendRedirect("/keygenerator/KeyGeneratorCompare.jsp?message=-3");
	return;
}

String operation = Util.null2String(fu.getParameter("operation"));
String projectpath = Util.null2String(fu.getParameter("projectpath"));
if("".equals(operation)){ operation=Util.null2String(request.getParameter("operation"));}
if("".equals(projectpath)){ projectpath=Util.null2String(request.getParameter("projectpath"));}
if(!"".equals(projectpath)&&!projectpath.endsWith(""+File.separatorChar)) {
	projectpath = projectpath + File.separatorChar;
}
String message = "";
Map fileMap = null;
if(!operation.equals("pack"))
{
	session.removeAttribute("fileMap");
	session.removeAttribute("classList");
	wscheck.KeyGeneratorCompare KeyGenerator = new wscheck.KeyGeneratorCompare();
	boolean ischeckpass = KeyGenerator.checkFileSize(fu);
	
	if(ischeckpass)
	{
		Map compareMap = KeyGenerator.getCompareMap(fu,response);
		
		if(null!=compareMap&&compareMap.size()>0){
			fileMap = KeyGenerator.getCompareResult(compareMap,projectpath);
			
			session.setAttribute("fileMap",fileMap);
			session.setAttribute("classList",KeyGenerator.classList);
			KeyGenerator.classList = new ArrayList();
		}
		else{
			response.sendRedirect("/keygenerator/KeyGeneratorCompare.jsp?message=-1");
			return;
		}
	}
	else
	{
		response.sendRedirect("/keygenerator/KeyGeneratorCompare.jsp?message=-2");
		return;
	}
}
else
{}
String version="";
String latestPackageNo="";
String missPackageNo="";
String systemInfo="系统版本信息:";
List packageList = new ArrayList();
String note = "*如果检测出来的文件是一些备份的文件，则可以忽略这些文件。";


RecordSet.execute("select cversion from license order by  expiredate desc");
if(RecordSet.next()){
	version=RecordSet.getString(1);
	systemInfo+=version;
}else{
	systemInfo+="未获取到版本信息 ";
}
RecordSet1.execute("select label from ecologyuplist order by label desc");

while(RecordSet1.next()){
	packageList.add(RecordSet1.getString(1));
	latestPackageNo = (String)packageList.get(0);
}

if(!latestPackageNo.equals("")){
// 	latestPackageNo=(String)packageList.get(0);
	systemInfo+="  当前系统最新补丁包编号:"+latestPackageNo;
	Format f1 = new DecimalFormat("000");
	for(int i=1;i<Integer.valueOf(latestPackageNo);i++){
		if(!packageList.contains(f1.format(i))){
			missPackageNo+=f1.format(i)+"、";
		}
	}
	if(!missPackageNo.equals("")){
		missPackageNo = missPackageNo.substring(0, missPackageNo.length()-1);
		systemInfo+="  补丁包打包情况:跳包("+missPackageNo+")";
	}else{
		systemInfo+="  补丁包打包情况:正常";
	}
}else{
	systemInfo+="  当前系统最新补丁包编号:未获取到系统最新补丁包编号 补丁包打包情况:未找到补丁包";
}

String showSystemInfo = systemInfo;

systemInfo = java.net.URLEncoder.encode(systemInfo, "UTF-8");
if(null==fileMap||fileMap.size()==0) {
	note = "没有未备案的文件！";
}
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/green/wui_wev8.css'/>
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<script type="text/javascript" src="/wui/common/jquery/jquery_wev8.js"></script>
<style type="text/css">
.btn1_mouseout {
 BORDER-RIGHT: #7EBF4F 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7EBF4F 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#B3D997); BORDER-LEFT: #7EBF4F 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7EBF4F 1px solid
}
.btn2_mousedown
{
 BORDER-RIGHT: #FFE400 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #FFE400 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#C3DAF5); BORDER-LEFT: #FFE400 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #FFE400 1px solid
}
.e8_btn_submit{
		border:0px;cursor:pointer;
		padding-left:0;
		padding-left:10px;
		padding-right:10px;
		height:30px;
		line-height:25px;
	
		background-color:#558ED5;
		color:white;
		width:75px;
	}
	.e8_btn_disabled{
		border:0px;cursor:pointer;
		padding-left:0;
		padding-left:10px;
		padding-right:10px;
		height:30px;
		line-height:30px;
	
		background-color:#959595;
		color:white;
		width:75px;
	}
</style>
</head>
<body>
<DIV id="divTopTitle">	
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr>
		<td width="10px">&nbsp;</td>
		<td  width="*">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0  class=TopTitle>
			  <TBODY>
			  <TR>
			  
			    <TD align=left width=45><IMG src="/images/hdMaintenance_wev8.gif" height="18px"></TD>
			   
			    <TD align=left style="padding-top:3px"><SPAN id='BacoTitle' >显示获取和泛微备案环境差异文件清单</SPAN></TD>
			    <TD align=right>&nbsp;</TD>
			    <TD width=5></TD>    
			    <TD align=middle width=24><!-- <BUTTON style="display:none" class=btnLittlePrint id=onPrint title="打印" onclick="javascript:window.print();" style="display:none"></BUTTON> -->
				</TD>
			    
				 <TD align=middle width=24><!--<BUTTON class=btnBack id=onBack title="回退" onclick="javascript:history.back();" style="display:none"></BUTTON> -->
				 </TD>
			     <td align="right">
				 &nbsp;
				</td>
			     <td width="10">&nbsp;</td >
			  </TR>
			  </TBODY>
			</TABLE>
		</td>
		<td width="10px"></td>
		</tr>
	</TABLE>
</DIV>
<br>
<form action="/keygenerator/packKeyCompareFiles.jsp" method="post" name="frmmain" id="frmmain">
	<INPUT type="hidden" name="pagepos" value="">
	<INPUT type="hidden" name="operation" value="pack">
	<INPUT type="hidden" name="projectpath" value="<%=projectpath %>">
	<INPUT type="hidden" name=systemInfo value="<%=systemInfo %>">
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr>
		<td width="10px">&nbsp;</td>
		<td  width="*">
		    <TABLE class=ListStyle cellspacing=1 style="margin: 0px;">
		        <colgroup>
		        <col width="5%">
		        <col width="45%">
		        <col width="10%">
		        <col width="12%">
		        <col width="12%">
		        <col width="26%">
		        <tr>
					<td colspan="6"  style="color:black;font-weight:bold;font-size:14px;"><%=showSystemInfo%></td>
				</tr>
		        <tr>
					<td colspan="6"  style="color:red;font-weight:bold;font-size:12px;"><%=note %></td>
				</tr>
		        <tr class=header >
		            <td colspan="6">
		            <div style="float:right">
		            	<span>&nbsp;&nbsp;&nbsp;<font id="submittips"  style=" display:none; font-weight:bold;font-size:larger;color:red">正在打包文件，请耐心等待，刷新或关闭页面将导致导出文件不正确 ...  &nbsp;&nbsp;&nbsp;&nbsp;</font></span>
		            
		            <%if(message.equals("1")){ %><button type="button" name="upload" class='btn2_mousedown' onclick="downUpdateFile(this)">下载</button>&nbsp;&nbsp;<%} %><button id="dosubmit" type="button" name="upload" class='e8_btn_submit' onclick="packUpdateFile(this)">打包文件</button></div></td>
		        </tr>
		        <tr class=header>
		            <td><input type='checkbox' id=checkAllList name=checkAllList onclick="checkAllList1(this);"><span></span></td>
		            <td>文件路径</td>
		            <td>操作类型</td>
		            <td>当前环境最后修改日期</td>
		            <td>备案环境最后修改日期</td>
		            <td>说明</td>
		        </tr>
		        <%
		        int colorcount = 0;
		        if(null!=fileMap&&fileMap.size()>0)
		        {
		        	String tempprojectpath = GCONST.getRootPath();
		        	if(!projectpath.equals(""))
		        	{
		        		tempprojectpath = projectpath;
		        	}
			        Set keyset = fileMap.keySet();
			        int rownum = 0;
					for(Iterator it = keyset.iterator();it.hasNext();)
					{
						rownum++;
						String realfilepath = "";
						String filename = Util.null2String((String)it.next()).trim();
						String operatetype = Util.null2String((String)fileMap.get(filename)).trim();
						String lastModifieddate = "";
						if(operatetype.indexOf("2")==0)
						{
							List operatetypeList = Util.TokenizerString(operatetype,"+");
							
							if(operatetypeList.size()==2){
								operatetype = (String)operatetypeList.get(0);
								lastModifieddate = (String)operatetypeList.get(1);
								try
								{
									lastModifieddate = TimeUtil.getDateString(TimeUtil.getString2Date(lastModifieddate, "yyyy'-'MM'-'dd"));
								}catch(Exception ex)
								{
									
								}
							}
						}
						if("".equals(filename))
						{
							continue;
						}
// 						if(operatetype.equals("0")){
// 							continue;
// 						}
						if(filename.startsWith("/"))
						{
							filename = filename.substring(1,filename.length());
						}
						if("\\".equals(""+File.separatorChar))
						{
							realfilepath = tempprojectpath+(filename.replaceAll("/","\\\\"));
						}
						else
						{
							realfilepath = tempprojectpath+filename;
						}
						Date date = null;
						try
						{
							if(!operatetype.equals("0"))
							{
								File newfile = new File(realfilepath);
								date = new Date(newfile.lastModified());
							}
						}
						catch(Exception e)
						{
							
						}
						String localLastModifieddate ="";
						if(date!=null) {
							localLastModifieddate =  TimeUtil.getDateString(date);
						}
						String datacolor = "green";
						if(localLastModifieddate.compareTo(lastModifieddate)>0){
							datacolor = "green";
						}
						else if(localLastModifieddate.compareTo(lastModifieddate)<0)
						{
							datacolor = "red";
						}
						if(colorcount==0)
						{
							colorcount=1;
					%>
					<TR class=DataLight>
					<%
						}
						else
						{
							colorcount=0;
					%>
					<TR class=DataDark>
					<%
						}
					%>
						<td height="23">
							<input type='checkbox' id=checkbh name=checkbh 
							<%if("0".equals(operatetype)){ %>
								disabled<%
							  }else if("2".equals(operatetype)&&(localLastModifieddate.compareTo(lastModifieddate)<0)){ %>
								value=<%=realfilepath +"==older" %>
							<%}else{ %>
								value=<%=realfilepath%>
							<%}%>>
							<span><%=rownum %></span>
						</td>
						<td  height="23">
							<%=realfilepath %>
						</td>
						<td  height="23">
							<%
							if(operatetype.equals("0"))
							{
								out.print("删除");
							}
							else if(operatetype.equals("1"))
							{
								out.print("新增");
							}
							else if(operatetype.equals("2"))
							{
								out.print("修改");
							}
							%>
						</td>
						<td  height="23">
							<%if(null!=date){%><font color='<%=datacolor %>' style='color:<%=datacolor %>;'><%=localLastModifieddate %></font><%} %>
						</td>
						<td  height="23">
							<%if(!"".equals(lastModifieddate)){%><font color='<%=datacolor %>' style='color:<%=datacolor %>;'><%=lastModifieddate %></font><%} %>
						</td>
						<td  height="23">
							<%if(null!=date&&(!"".equals(lastModifieddate)&&localLastModifieddate.compareTo(lastModifieddate)<0)){%><font color='<%=datacolor %>' style='color:<%=datacolor %>;'>客户环境该文件老于总部备案文件的时间</font><%} %>
						</td>
					</tr>
				<%
					}
				} 
				%>
		   	</TABLE>
    	</TD>
    	<td width="10px">&nbsp;</td>
  	</TR>
  	<tr><td height=10></td></tr>
  </tbody>
</table>
</form>
<iframe id="kg" name="kg" src="" style="width:0%;height:0%"></iframe>
<SCRIPT language=javascript>
function checkAllList1(obj)
{
	var checked = obj.checked;
	var checkbhs = document.getElementsByName("checkbh");
	if(checkbhs)
	{
		if(checkbhs.length>0)
		{
			for(var i = 0;i<checkbhs.length;i++)
			{
				var checkbh = checkbhs[i];
				if(checked)
					checkbh.checked = true;
				else
					checkbh.checked = false;
			}
		}
	}
}
function packUpdateFile(obj){
	var hasselected = false;
	var checkbhs = document.getElementsByName("checkbh");

	if (checkbhs&&checkbhs.length > 0) {
		for (var i = 0; i < checkbhs.length; i++) {
			if (checkbhs[i].checked) {
				//alert(checkbhs[i].value);
				hasselected = true;
			}
		}
	}
		var checkbh = [];

		if (hasselected) {
			alert("注意：在打包过程中，请耐心等待，刷新或关闭页面将导致导出文件不正确！")
			// 		$("#submittips").show();
			$("#dosubmit").attr('disabled', "true");
			$("#dosubmit").removeClass("e8_btn_submit");
			$("#dosubmit").addClass("e8_btn_disabled");
			document.frmmain.method = "post";
			document.frmmain.operation.value = "pack";
			document.frmmain.action = "/keygenerator/packKeyCompareFiles.jsp";
			document.frmmain.submit();
		} else {
			alert("请先选择需要打包的文件!");
		}
	}
	function uploadUpdateFile() {
		openNewFullWindow("http://www.e-cology.com.cn/keygenerator/KeyGenerator.jsp");
	}
	function downUpdateFile(obj) {
		openNewFullWindow("/filesystem/ecology.zip");
	}
</SCRIPT>
</body>
</html>