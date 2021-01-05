
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.io.*,java.util.regex.*,java.util.concurrent.*,weaver.hrm.*,weaver.filter.SecurityCheckList,weaver.security.classLoader.ReflectMethodCall" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page"></jsp:useBean>
<%
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>安全体检</title>

<style type="text/css">
	*{
		font-family: 微软雅黑; 
		mso-hansi-font-family: 微软雅黑
	}
	.normal{
		font-size:14px;
		font-weight:bold;
		color:#81878d;
		display:inline-block;
		padding-right:2px;
		padding-left:2px;
		text-align:center;
		height:40px;
		cursor:pointer;
	}

	.current{
		color:#197be0;
		border-bottom:2px solid #2887d7;
	}

	.listTable{
		width:100%;
		border:1px solid #dcdcdc;
		border-collapse:collapse;
	}
	.listTable th{
		height:40px;
	}
	.listTable th, .listTable td{
		border:1px solid #dcdcdc;
		font-size:12px;
		color:#384049;
	}
	.listTable td{
		padding-left:10px;
	}
</style>
<script type="text/javascript">
	function checkDone(obj){
		//obj.disabled = true;
		document.getElementById("msg").innerHTML="正在执行异常文件检查...";
		document.getElementById("shadow").style.display = "block";
		//document.getElementById("checkSecurityListBtn").disabled=true;
		//document.getElementById("fixBtn").disabled=true;
		location.href="checkdone.jsp?operation=checkExceptionFile";
	}

	function checkSecurityList(obj){
		//obj.disabled = true;
		document.getElementById("msg").innerHTML="正在执行安全项检查...";
		document.getElementById("shadow").style.display = "block";
		//document.getElementById("checkBtn").disabled=true;
		//document.getElementById("fixBtn").disabled=true;
		setTimeout(function(){
			location.href="checkdone.jsp?operation=checkSecurityList";
		},1000);
	}
	
	function fixDone(obj){
		//obj.disabled = true;
		document.getElementById("msg").innerHTML="正在执行安全项修复...";
		document.getElementById("shadow").style.display = "block";
		//document.getElementById("checkBtn").disabled=true;
		//document.getElementById("checkSecurityListBtn").disabled=true;
		setTimeout(function(){
			location.href="checkdone.jsp?operation=fixSecurityList";
		},1000);
	}

</script>
</head>
<%!
	public List getFiles(String filepath){
		List files = new Vector();
		//System.out.println(TimeUtil.getCurrentTimeString()+":开始得到项目 "+project+" 文件列表...");
		listFiles(files,filepath);
		//System.out.println(TimeUtil.getCurrentTimeString()+":项目 "+project+" 文件列表获取完成..."+files.size());
		return files;
	}

	public void listFiles(List files,String dirName){
		try{
			File dirFile = new File(dirName);
			 if(!dirFile.exists() || (!dirFile.isDirectory())){
			 }else{
				 File[] tmpfiles = dirFile.listFiles();
				 for(int i=0;i<tmpfiles.length;i++){
					 File f = tmpfiles[i];
					 if(f.isFile()){

						 if(f.getName().toLowerCase().endsWith(".jsp")){
							files.add(f.getAbsolutePath().replaceAll("\\\\", "/"));
						 }
					 }else if(f.isDirectory()){
						 listFiles(files,f.getAbsolutePath().replaceAll("\\\\", "/"));
					 }
				 }
			 }
		}catch(Exception e){}
	}

	public String checkCode(String code,int line){
		if(code==null)return null;
		Pattern p = null;
		Matcher m = null;
		p = Pattern.compile("GC\\(|connect\\(\\)",Pattern.CASE_INSENSITIVE);
		m = p.matcher(code);
		if(m.find()){
			//new weaver.filter.XssUtil().writeLog(code+"======"+m.group(),true);
			//找到，有问题，接下来检查是否是例外
				return "0";
		}
		return null;
	}

	public List checkFiles(List files){
		String readline = "";
		List resultList = new Vector();
		int i=0;
		weaver.filter.XssUtil xss = new weaver.filter.XssUtil();
		for(int j=0;j<files.size();j++){
			String file = ""+files.get(i);
			i++;
			//xss.writeLog(file,true);
			if(i%50==0){
				try{
					xss.writeLog("已完成："+(i*1.0/files.size()*100)+"%...",true);
				}catch(Exception e){}
				//System.out.println("已完成："+(i*1.0/files.size()*100)+"%...");
			}
			
			File f = new File(file);
			if(!f.exists())continue;
			if(f.getName().indexOf("MonitorMem.jsp")!=-1 
				||f.getName().indexOf("MailAccountCheckInfoOperation.jsp")!=-1
				||f.getName().indexOf("HrmSalaryOperation.jsp")!=-1
				||f.getName().indexOf("HrmDataCollect.jsp")!=-1
				||f.getName().indexOf("testsapcon.jsp")!=-1
				||f.getName().indexOf("wmForWeb.jsp")!=-1
				||f.getName().indexOf("messager.jsp")!=-1
				||f.getName().indexOf("locationaddress.jsp")!=-1
				||f.getName().indexOf("MailOperationGet.jsp")!=-1
				||f.getName().indexOf("SocialIMClient.jsp")!=-1
			)continue;
			BufferedReader is = null;
			boolean isComment = false;
			try {
				is = new BufferedReader(new InputStreamReader(new FileInputStream(f),"GBK"));
				int lineno=0;
				//System.out.println("正在检查第"+i+"个文件，总共"+files.size()+"个文件...");
				long spaceCount = 0;
				long totalCount = 0;
				boolean inKeyword = false;
				while ((readline = is.readLine()) != null)   {
					//readline = readline.trim() ;
					lineno++;
					if(readline!=null){
						//if(readline.indexOf("//")!=-1)continue;
						//totalCount+=readline.length();
						/*for(int c=0;c<readline.length();c++){
							if(readline.charAt(c)==32){
								spaceCount++;
							}else if(readline.charAt(c)==9){
								spaceCount+=4;
							}
						}*/
						String res = checkCode(readline,lineno);
						if(res==null){//正常
						}else if(res.equals("0")){//非例外
							//resultList.add(f.getPath());
							inKeyword = true;
							break;
						}
					}
				}
				if(inKeyword){
					resultList.add(f.getPath());
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally{
				try{
					is.close();
				}catch(Exception e){}
			}
		}
		return resultList;
	}

	

%>
<body style="margin:0;">

<%
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		out.println("无权限，请用sysadmin登录后访问！");
		return;
	}

	if(!"sysadmin".equals(user.getLoginid())){
		out.println("无权限，请用sysadmin登录后访问！");
		return;
	}
	String operation = xssUtil.null2String(request.getParameter("operation"));
	boolean isCheckSecurity = operation.equals("checkSecurityList");
	
	SecurityCheckList scl = new SecurityCheckList();
	ReflectMethodCall rmc = new ReflectMethodCall();
	Boolean testServer = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","testNetwork",
		            		new Class[]{},null);
	if(testServer==null)testServer=new Boolean(false);
	Boolean isMakeRandCode = new Boolean(false);
	if(isCheckSecurity){
		try{
			//scl.getNeedFixList().clear();
			((List)rmc.call("weaver.security.core.SecurityCheckList","getNeedFixList",new Class[]{},null)).clear();
		}catch(Exception e){}
		try{
			isMakeRandCode = (Boolean)rmc.call("weaver.security.core.SecurityCheckList","isMakeRandCode",new Class[]{},null);
			if(isMakeRandCode==null)isMakeRandCode=new Boolean(false);
		}catch(Exception e){}
	}
	Boolean isFixed = new Boolean(false);
	if("fixSecurityList".equals(operation)){
		//isFixed = scl.fixSecurityList();
		isFixed = ((Boolean)rmc.call("weaver.security.core.SecurityCheckList","fixSecurityList",new Class[]{},null));
		if(isFixed==null){
			isFixed = new Boolean(false);
		}
	}
%>
<div id="shadow" style="<%=new Boolean(true).compareTo(isFixed)==0?"":"display:none;"%>background-color:#eaeaea;filter:alpha(opacity=70); -moz-opacity:0.7; opacity:0.7;position:absolute;width:100%;height:100%;text-align:center;line-height:100%;">
	<div id="msg" style="margin-top:40px;width:180px;line-height:30px;height:30px;color:#0B84E0;font-size:14px;margin-right:auto;margin-left:auto;"></div>
</div>
<div style="width:100%;height:74px;">
	<div style="width:100%;">&nbsp;</div>
	<div style="text-align:left;left:30px;color:red;position:absolute;">
		<%
			if("fixSecurityList".equals(operation)){
				if(isFixed.compareTo(new Boolean(true))==0){
					out.println("<div>导出修复包成功！<br/>请按照以下步骤操作修复：</div>");
					out.println("<ul>");
					out.println("<li>");
					out.println("1、请将"+rmc.call("weaver.security.core.SecurityCheckList","getNewFilePath",new Class[]{},null)+"web.xml文件替换到"+request.getRealPath("/")+"WEB-INF"+File.separatorChar+"目录下（如果文件不存在就忽略此步骤）");
					out.println("</li>");
					out.println("<li>");
					out.println("2、请将"+rmc.call("weaver.security.core.SecurityCheckList","getNewFilePath",new Class[]{},null)+"resin.conf文件替换到"+System.getProperties().getProperty("resin.home")+File.separatorChar+"conf"+File.separatorChar+"目录下（如果文件不存在就忽略此步骤）");
					out.println("</li>");
					out.println("<li>");
					out.println("3、请重启OA服务");
					out.println("</li>");
					out.println("<li>");
					out.println("4、如果服务无法正常启动，请将自动备份的文件还原到对应的目录下，再次重启OA服务即可。");
					out.println("</li>");
					out.println("<li>");
					out.println("4.1、自动备份文件路径如下<br/>resin.conf的备份文件："+System.getProperties().getProperty("resin.home")+File.separatorChar+"conf"+File.separatorChar+"resin.conf."+xssUtil.getCurrentDateString().replaceAll("-","")+"<br/>web.xml的备份文件："+request.getRealPath("/")+"WEB-INF"+File.separatorChar+"web.xml."+xssUtil.getCurrentDateString().replaceAll("-",""));
					out.println("</li>");
					out.println("</ul>");
				}else{
					out.println("导出修复包失败！");
				}
			}
		%>
	</div>
</div>
<div style="margin-left:auto;margin-right:auto;width:80%;border:1px solid #dcdcdc;">
	<%if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){%>
		<div style="background-color:#f0f3f4;height:54px;width:100%;border-bottom:#dcdcdc;line-height:54px;">
			<div style="margin-left:20px;float:left;">
				<!--<span id="securityBtn" onclick="javascript:location.href='/security/monitor/checkdone.jsp'" style="line-height:40px;" class="normal <%=(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation))?"current":""%>">
					<span>检查系统安全配置项</span>
				</span>
				<span id="fileBtn" onclick="javascript:location.href='/security/monitor/checkdone.jsp?operation=showExceptionFile'" style="margin-left:60px;" class="normal <%=("checkExceptionFile".equals(operation)||"showExceptionFile".equals(operation))?"current":""%>">
					<span>检查系统异常文件</span>
				</span>-->
			</div>
			<div style="float:right;margin-right:20px;">
				<%if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){%>
						<span name="fixBtn" id="fixBtn" onclick="fixDone(this)" style="<%=isCheckSecurity?"":"visibility:hidden;"%>cursor:pointer;margin-left:18px;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#2c91e6;text-align:center;">修复</span>
					<span name="checkSecurityListBtn" id="checkSecurityListBtn" onclick="checkSecurityList(this)" style="cursor:pointer;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#52be7f;text-align:center;margin-top:10px;">检测</span>
				<%}else{%>
					<!--<span name="fixBtn" id="fixBtn" onclick="fixDone(this)" style="visibility:hidden;cursor:default;margin-left:18px;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#2c91e6;text-align:center;">修复</span>
					<span name="checkBtn" id="checkBtn" onclick="checkDone(this)" style="cursor:pointer;display:inline-block;height:30px;line-height:30px;width:78px;color:white;background-color:#52be7f;text-align:center;">检测</span>
					-->
				<%}%>
			</div>
		   </div>
		<%}%>
	<% int no = 1;%>
	<%if(!"checkExceptionFile".equals(operation)&&!"showExceptionFile".equals(operation)){%>
		<div style="max-height:600px;overflow:auto;">
			<table class="listTable">
				<colgroup>
					<col width="60px"/>
					<col width="20%"/>
					<col width="30%"/>
					<col width="40%"/>
					<col width="5%"/>
				</colgroup>
				<thead>
					<th>序号</th>
					<th>检查项</th>
					<th>说明</th>
					<th>修复方式</th>
					<th>状态</th>
				</thead>
				<tbody>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否正确配置了安全防火墙</td>
						<td>检查WEB-INF/web.xml中是否配置了SecurityFilter</td>
						<td>
							修改WEB-INF/web.xml文件，添加如下代码<br/>
							<code><i><font color="red">
							&lt;filter><br/>
								&lt;filter-name>SecurityFilter&lt;/filter-name><br/>
								&lt;filter-class>weaver.filter.SecurityFilter&lt;/filter-class><br/>
							&lt;/filter><br/>

							&lt;filter-mapping><br/>
								&lt;filter-name>SecurityFilter&lt;/filter-name><br/>
								&lt;url-pattern>/*&lt;/url-pattern><br/>
							&lt;/filter-mapping><br/>
						   </font></i></code>
						   <br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.isConfigFirewall()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否开启了access访问日志</td>
						<td>读取resin.conf文件，检查是否配置了access log</td>
						<td>
							resin2：<br/>
				  搜索ecology关键字，在&lt;app-dir>下面添加访问日志，如下：<br/>
				 
				   &lt;app-dir>F:\workspace\ecology7\&lt;/app-dir><br/>
					<code><i><font color="red">
						&lt;access-log id='log/access.log'><br/>
						  <!--rotate log daily--><br/>
						  &lt;rollover-period>1D&lt;/rollover-period><br/>
						&lt;/access-log><br/>
				  </font></i></code>
				  resin3:<br/>
				  搜索&lt;host-default>关键字，在该节点下添加访问日志，如下：<br/>
				 
				   &lt;host-default><br/>
					<code><font color="red">
					  &lt;access-log path="logs/access.log" 
					   archive-format="access-%Y%m%d.log.gz" 
							format='%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-Agent}i"'
							rollover-period="1D"><br/>
						 &lt;exclude>\.gif$&lt;/exclude><br/>
					   &lt;exclude>\.jpg$&lt;/exclude><br/>
					   &lt;exclude>\.png$&lt;/exclude><br/>
					   &lt;exclude>\.js$&lt;/exclude><br/>
					   &lt;exclude>\.css$&lt;/exclude><br/>
					   &lt;exclude>\.html$&lt;/exclude><br/>
					   &lt;exclude>\.htm$&lt;/exclude><br/>
					   &lt;exclude>\.swf$&lt;/exclude><br/>
					   &lt;exclude>\.cur$&lt;/exclude><br/>
					&lt;/access-log>
					</font></code>
					<br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.isEnableAccessLog()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否配置了生成验证码的servlet，如果没配置，则需要配置</td>
						<td>读取web.xml文件，检查web.xml中是否配置了MakeRandCodeServlet</td>
						<td>
						如果没有配置，则在&lt;/web-app>上方添加以下代码：<br/>
						<code><i><font color="red">
							 &lt;servlet><br/>
								&lt;servlet-name>MakeRandCodeServlet&lt;/servlet-name><br/>
								&lt;servlet-class>weaver.security.access.MakeRandCode&lt;/servlet-class><br/>
							  &lt;/servlet><br/>
							  &lt;servlet-mapping><br/>
								&lt;servlet-name>MakeRandCodeServlet&lt;/servlet-name><br/>
								&lt;url-pattern>/weaver/weaver.security.access.MakeRandCode&lt;/url-pattern><br/>
							  &lt;/servlet-mapping><br/>
						  </font></i></code>
						  <br/>
						   <b>修改完成后请重启OA服务。</b>
						  </td>
						<td style="text-align:center;"><%=isCheckSecurity?(isMakeRandCode.compareTo(new Boolean(true))==0?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>socket超时时间是否不大于10s</td>
						<td>检测socket连接超时时间，缓解http缓慢攻击问题</td>
						<td>检查&lt;socket-timeout>和&lt;keepalive-timeout>两个节点的时间，修改为10s即可<br/>
						<code><i><font color="red">
							&lt;socket-timeout>10s&lt;/socket-timeout><br/>
							&lt;keepalive-timeout>10s&lt;/keepalive-timeout>
							</font></i></code>
							<br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.checkSocketTimeout()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否配置了404错误页面</td>
						<td>检查应用系统是否正确配置了404错误页面</td>
						<td>
							在web.xml的&lt;/web-app>上面添加如下代码即可<br/>
							<code><i><font color="red">
						  &lt;error-page><br/>
							&lt;error-code>404&lt;/error-code><br/>
							&lt;location>/security/error404.jsp&lt;/location><br/>
						   &lt;/error-page><br/>
						   </font></i></code>
						   <br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.is404PageConfig()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否配置了500错误页面</td>
						<td>检查应用系统是否正确配置了500错误页面</td>
						<td>
							在web.xml的&lt;/web-app>上面添加如下代码即可<br/>
							<code><i><font color="red">
						  &lt;error-page><br/>
							&lt;error-code>500&lt;/error-code><br/>
							&lt;location>/security/error500.jsp&lt;/location><br/>
						   &lt;/error-page><br/>
						   </font></i></code>
						   <br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.is500PageConfig()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
					<tr>
						<td style="text-align:center;"><%=no++%></td>
						<td>是否禁用了不使用的http method</td>
						<td>检查web.xml中是否正确配置了web-resource-collection和http-method</td>
						<td>
							在web.xml的&lt;web-app>下方添加如下代码即可<br/>
							<code><i><font color="red">
						  &lt;security-constraint><br/>     
							 &lt;web-resource-collection><br/>       
							 &lt;url-pattern>/*&lt;/url-pattern><br/>       
							 &lt;http-method>PUT&lt;/http-method> <br/> 
							 &lt;http-method>DELETE&lt;/http-method><br/> 
							 &lt;http-method>OPTIONS&lt;/http-method> <br/> 
							 &lt;http-method>TRACE&lt;/http-method><br/>
							 &lt;http-method>SEARCH&lt;/http-method>  <br/> 
							 &lt;http-method>PROPFIND&lt;/http-method> <br/> 
							 &lt;http-method>PROPPATCH&lt;/http-method>  <br/>
							 &lt;http-method>PATCH&lt;/http-method> <br/> 
							 &lt;http-method>MKCOL&lt;/http-method>  <br/>
							 &lt;http-method>COPY&lt;/http-method> <br/>
							 &lt;http-method>MOVE&lt;/http-method> <br/> 
							 &lt;http-method>LOCK&lt;/http-method><br/>
							 &lt;http-method>UNLOCK&lt;/http-method><br/>
							 &lt;/web-resource-collection>     <br/>
							 &lt;auth-constraint>    <br/> 
							 &lt;/auth-constraint> <br/>  
						 &lt;/security-constraint><br/>
						   </font></i></code>
						   <br/>
						   <b>修改完成后请重启OA服务。</b>
						</td>
						<td style="text-align:center;"><%=isCheckSecurity?(scl.isDisabledHttpMethod()?"<font style='color:#52be7f;font-weight:bold;'>正常</font>":"<font style='color:#e84c4c;font-weight:bold;'>异常</font>"):""%></td>
					</tr>
				</tbody>
			</table>
		</div>
	<%}else{%>
		<div style="max-height:600px;overflow:auto;margin-top:36px;">
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;">系统标识：</span>
				<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;"><%=""+rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"uuid",
		            		new Class[]{},null)%></span>
			</div>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;">公司名称：</span>
				<span style="display:inline-block;color:#384049;margin-left:28px;text-overflow:ellipsis;word-wrap:nowrap;"><%=xssUtil.getCompanyname()%></span>
			</div>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
		<span style="display:inline-block;color:#384049;font-weight:bold;">服务器外网：</span>
		<span style="display:inline-block;color:#384049;margin-left:14px;text-overflow:ellipsis;word-wrap:nowrap;"><%=new Boolean(true).compareTo(testServer)==0?"<font style='color:green;'>可以联通外网</font>":"<font style='color:red;'>不可以联通外网</font>"%></span>
	</div>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;">登录保护：</span>
				<span style="display:inline-block;color:<%=(xssUtil.enableFirewall() && xssUtil.isLoginCheck())?"#52be7f":"e84c4c"%>;margin-left:28px;"><%=(xssUtil.enableFirewall() && xssUtil.isLoginCheck())?"开启":"未开启"%></span>
			</div>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;">数据库保护：</span>
				<span style="display:inline-block;text-overflow:ellipsis;word-wrap:nowrap;color:<%=(xssUtil.enableFirewall() && !xssUtil.getIsSkipRule())?"#52be7f":"e84c4c"%>;margin-left:12px;"><%=xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()?"开启":"未开启"%></span>
			</div>
			<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
				<span style="display:inline-block;color:#384049;font-weight:bold;">页面保护：</span>
				<span style="display:inline-block;color:<%=(xssUtil.enableFirewall() && xssUtil.getMustXss())?"#52be7f":"e84c4c"%>;margin-left:28px;"><%=xssUtil.enableFirewall() && xssUtil.getMustXss()?"开启":"未开启"%></span>
			</div>
			<!--<div style="border-bottom:1px dotted #dcdcdc;margin-left:auto;margin-right:auto;max-width:800px;height:40px;line-height:40px;">
			<span style="display:inline-block;color:#384049;font-weight:bold;">疑似异常文件列表：</span>
			</div>
			<div style="margin-left:auto;margin-right:auto;max-width:800px;margin-bottom:30px;margin-top:16px;">
				
				<span style="display:inline-block;color:e84c4c;margin-left:13px;">
					<%/*
						if("checkExceptionFile".equals(operation)){
							List exceptionFiles = checkFiles(getFiles(request.getRealPath("/")));
							for(int i=0;i<exceptionFiles.size();i++){
								out.println("<div style='padding-top:10px;'>"+exceptionFiles.get(i)+"</div>");
							}
						}*/
					%>&nbsp;
				</span>
			</div>-->
		</div>
	<%}%>
	
</div>
</body>
</html>
