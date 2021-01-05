<% weaver.filter.ECompatibleSetting.setVersion(weaver.filter.ECompatibleSetting.ECOLOGY_JSP_VERSION_E8,request); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*,weaver.general.*,weaver.file.*,java.io.*,java.util.*" %>
<%@page import="wscheck.*,java.util.*,weaver.general.*,java.io.*,java.util.zip.*"%>
<%


String operation =Util.null2String(request.getParameter("operation"));
String message = "";
Map fileMap = null;
fileMap = (Map)session.getAttribute("fileMap");
session.removeAttribute("fileMap");
%>
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology7/skins/green/wui_wev8.css'/>
<!-- 字体设置，win7、vista系统使用雅黑字体,其他系统使用宋体 Start -->
<link type='text/css' rel='stylesheet'  href='/wui/common/css/w7OVFont_wev8.css' id="FONT2SYSTEMF">
<style type="text/css">
.btn1_mouseout {
 BORDER-RIGHT: #7EBF4F 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7EBF4F 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#B3D997); BORDER-LEFT: #7EBF4F 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7EBF4F 1px solid
}
.btn2_mousedown
{
 BORDER-RIGHT: #FFE400 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #FFE400 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#C3DAF5); BORDER-LEFT: #FFE400 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #FFE400 1px solid
}

</style>
</head>
<body>
<form method="post" name="frmmain">
	<INPUT type="hidden" name=pagepos value="">
	<INPUT type="hidden" name=operation value="pack">
	<span style="width:100%;text-align:left;display:inline-block;font-size:14px;font-weight:bold;color:red;">当前系统存在未备案文件,请联系泛微客服进行备案后再进行升级</span>
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>

		<tr>
		
		<td  width="*">
		    <TABLE class=ListStyle cellspacing=1>
		        <colgroup>
		        <col width="5%">
		        <col width="55%">
		        <col width="20%">
		        <col width="20%">
		        <tr class=header>
		        <td colspan="2">差异文件清单</td>
		            <td colspan="2"><div style="float:right"> <%if(message.equals("1")){ %><button type="button" name="upload" class='e8_btn_top' onclick="downUpdateFile(this)">下载</button>&nbsp;&nbsp;<%} %></div></td>
		        </tr>
		        <tr class=header>
		            <td><input type='checkbox' id=checkAllList name=checkAllList onclick="checkAllList1(this);"></td>
		            <td>文件路径</td>
		            <td>操作类型</td>
		            <td>修改日期</td>
		        </tr>
		        <%
		        int colorcount = 0;
		        int count = 0;
		        if(null!=fileMap&&fileMap.size()>0)
		        {
			        Set keyset = fileMap.keySet();
					for(Iterator it = keyset.iterator();it.hasNext();)
					{
						count++;
						if(count>100) {//文件太多了  没必要在这里全部显示出来
							//System.out.println(""+count);
							return;
						}
						String realfilepath = "";
						String filename = Util.null2String((String)it.next()).trim();
						String operatetype = Util.null2String((String)fileMap.get(filename)).trim();
						if("".equals(filename))
						{
							continue;
						}
						if(filename.startsWith("/"))
						{
							filename = filename.substring(1,filename.length());
						}
						if("\\".equals(""+File.separatorChar))
						{
							realfilepath = GCONST.getRootPath()+(filename.replaceAll("/","\\\\"));
						}
						else
						{
							realfilepath = GCONST.getRootPath()+filename;
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
							<input type='checkbox' id=checkbh name=checkbh <%if("0".equals(operatetype)){ %>disabled<%} %> value="<%=realfilepath %>">
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
							<%if(null!=date){%><%=TimeUtil.getDateString(date) %><%} %>
						</td>
					</tr>
				<%
					}
				}%>
		   	</TABLE>
    	</TD>
    	
  	</TR>
  	<tr><td height=10></td></tr>
  </tbody>
</table>
</form>
</body>
</html>