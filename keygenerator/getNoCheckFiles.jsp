
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,java.io.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="wscheck.PageErrorMap,java.util.*,weaver.general.*"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
if(user.getUID()!=1)
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String message =Util.null2String(request.getParameter("message"));
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
<DIV id="divTopTitle">	
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr>
		<td width="10px">&nbsp;</td>
		<td  width="*">
			<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0  class=TopTitle>
			  <TBODY>
			  <TR>
			  
			    <TD align=left width=45><IMG src="/images/hdMaintenance_wev8.gif" height="18px"></TD>
			   
			    <TD align=left style="padding-top:3px"><SPAN id='BacoTitle' >获取未通过校验文件</SPAN></TD>
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
<form action="/keygenerator/getNoCheckFiles.jsp" method="post" name="frmmain">
	<INPUT type="hidden" name=pagepos value="">
	<INPUT type="hidden" name=operation value="">
	
	<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
		<tr>
		<td width="10px">&nbsp;</td>
		<td  width="*">
		    <TABLE class=ListStyle cellspacing=1>
		        <colgroup>
		        <col width="5%">
		        <col width="65%">
		        <col width="30%">
		        <tr class=header>
		            <td colspan="3"><div style="float:right"><button type="button" name="download" class='btn2_mousedown' onclick="uploadUpdateFile()">上传升级包至泛微</button>&nbsp;&nbsp;<%if(message.equals("1")){ %><button type="button" name="upload" class='btn2_mousedown' onclick="downUpdateFile(this)">下载</button>&nbsp;&nbsp;<%} %><button type="button" name="upload" class='btn2_mousedown' onclick="packUpdateFile(this)">打包文件</button></div></td>
		        </tr>
		        <tr class=header>
		            <td><input type='checkbox' id=checkAllList name=checkAllList onclick="checkAllList1(this);"></td>
		            <td>文件路径</td>
		            <td>修改日期</td>
		        </tr>
		        <%
		        int colorcount = 0;
		        List filelist = PageErrorMap.getList();
				//System.out.println("filelist : "+filelist.size());
				for(int i = 0;i<filelist.size();i++)
				{
					String filename = (String)filelist.get(i);
					Date date = null;
					try
					{
						File newfile = new File(filename);
						date = new Date(newfile.lastModified());
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
							<input type='checkbox' id=checkbh name=checkbh value="<%=filename %>">
						</td>
						<td  height="23">
							<%=filename %>
						</td>
						<td  height="23">
							<%if(null!=date){%><%=TimeUtil.getDateString(date) %><%} %>
						</td>
						
					</tr>
				<%} %>
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
	if(checkbhs)
	{
		if(checkbhs.length>0)
		{
			for(var i = 0;i<checkbhs.length;i++)
			{
				var checked = checkbhs[i].checked;
				if(checked)
				{
					//alert(checkbhs[i].value);
					hasselected = true;
				}
			}
		}
	}
	if(hasselected)
	{
	    document.frmmain.method = "post";
		document.frmmain.operation.value = "pack";
		document.frmmain.action = "packNoCheckFiles.jsp";
		document.frmmain.submit();
	}
	else
	{
		alert("请先选择需要打包的文件!");
	}
}
function uploadUpdateFile(){
	openNewFullWindow("http://www.e-cology.com.cn/keygenerator/KeyGenerator.jsp");
}
function downUpdateFile(obj){
	openNewFullWindow("/filesystem/ecology.zip");
}
</SCRIPT>
</body>
</html>