<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.File"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.LineNumberReader"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.lang.management.ManagementFactory"%>
<%@ page import="java.lang.management.MemoryPoolMXBean"%>
<%@ page import="java.lang.management.MemoryUsage"%>
<%@ page import="java.lang.management.RuntimeMXBean"%>
<%@ page import="com.sun.tools.attach.VirtualMachine"%>

<%@ page import="java.lang.reflect.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.caucho.util.LruCache"%>
<%@ page import="com.caucho.vfs.Path"%>

<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
%>

<%@ include file="init.jsp" %>

<%
try{
	boolean isUse = false;
	Class debugAgent = null;
    if (!isInitDebug()) {
        
        loadAgent();
        debugAgent = Class.forName("com.weaver.onlinedebug.DebugAgent");
        
        long maxPermGenSize = 0;
        Long maxPermGenSizeObj = (Long) debugAgent.getDeclaredMethod("getMaxPermSize", new Class[] {}).invoke(null, new Object[] {});
        if(maxPermGenSizeObj != null){
            maxPermGenSize = maxPermGenSizeObj.longValue();
        }
        
        if(maxPermGenSize < 192 *1024 * 1024){
            out.append("java 启动参数 -XX:MaxPermSize="+(int)(maxPermGenSize/1024/1024)+"m 设置的太小，调试会造成不稳定，请使用 -XX:MaxPermSize=256m  或者大于256m 启动虚拟机");
            return;
        }
        
        String jspRoot = getServletConfig().getServletContext().getRealPath("/");
        
        String loader = debugAgent.getClassLoader().getClass().getName();
        if(loader.indexOf("SystemClassLoader") != -1){
            out.print("第一次在resin3上进行调试，必须进行一次重启才可以调试，请重启resin服务");
            return;
        }
        // System.out.println("~~~debugAgent="+debugAgent.getClassLoader());
        Method method = debugAgent.getDeclaredMethod("initDebug", new Class[] { String.class });
        method.invoke(null, new Object[]{jspRoot});
    }
    debugAgent = Class.forName("com.weaver.onlinedebug.DebugAgent");
    Class dataClass = Class.forName("com.weaver.onlinedebug.data.DebugData");
    
    Object debugData = session.getAttribute(debugDataKey);
    if(debugData == null){
        debugData = dataClass.newInstance();
        session.setAttribute(debugDataKey, debugData);
    }
    
    String trackType = ""+dataClass.getDeclaredMethod("getTrackType",(Class[])null).invoke(debugData, new Object[]{});
    String isTrackSeq = ""+dataClass.getDeclaredMethod("isTrackSeq",(Class[])null).invoke(debugData, new Object[]{});
    
    String action = request.getParameter("action");
    String message = "";
    
    Integer seq = 999999999;
    
    if ("start".equals(action)) {
        
        String currentUser = "u999999999";

        String cu = (String) debugAgent.getDeclaredMethod("startDebug", new Class[] { dataClass, String.class, int.class}).invoke(null, new Object[]{ debugData, currentUser, seq});

        if (!"".equals(cu)) {
        	isUse = true;
            message = "当前系统正在被"+cu+"调试，请先停止";
        } else {
        	isUse = true;
            message = "启动成功，请进行需要调试的操作，然后后停止,生成调试数据";
        }

    } else if ("stop".equals(action)) {

        boolean success = ((Boolean) debugAgent.getDeclaredMethod("stopDebug", null).invoke(null, new Object[]{})).booleanValue();
		
		isUse = false;
		
        if (success) {
            message = "请下载调试数据";
        } else {
            message = "发生错误，未能生成调试数据";
        }
    }

%>
<HTML>
 <HEAD>
  <TITLE> 远程调试</TITLE>
  <META NAME="Generator" CONTENT="EditPlus">
  <META NAME="Author" CONTENT="">
  <META NAME="Keywords" CONTENT="">
  <META NAME="Description" CONTENT="">
  <meta http-equiv=Content-Type content="text/html; charset=utf8">
<link type='text/css' rel='stylesheet'  href='css/main_wev8.css'/>
<script type="text/javascript" src="javascripts/jquery-1.4.2.min_wev8.js"></script>
<script type="text/javascript" src="javascripts/main_wev8.js"></script>
<script type="text/javascript">

	var debugCurrentClass = '<%=debugCurrentClass%>';
	var debugCurrentLine = '<%=debugCurrentLine%>';

	function setCurrent(className, line){
		debugCurrentClass = className;
		debugCurrentLine = line;
		var box = document.getElementById('vardataedit');
		box.src = 'debugAction.jsp?action=setcurrent&classname='+className+'&line='+line;
	}

	/**
	删除断点
	*/
	function deleteCurrent(){
		var box = document.getElementById('vardatalist');
		box.src = 'debugAction.jsp?action=deletecurrent&classname='+debugCurrentClass+'&line='+debugCurrentLine;
			
	}

	function deleteAll(){
		var box = document.getElementById('vardatalist');
		box.src = 'debugAction.jsp?action=deleteall';
			
	}


	/**
	开始或停止调试
	*/
	function startOrStop(obj){
		if($("#flag").val()=="0"){
			$(obj).text("正在启动");
			/*$("#flag").val("1");
			$("#sos").attr("src", "images/stop_wev8.png");
			*/
			window.location="/debug/debugm.jsp?action=start";
		}else{
			$(obj).text("正在停止");
			/*$("#flag").val("0");
			$("#sos").attr("src", "images/start_wev8.png");
			*/
			window.location="/debug/debugm.jsp?action=stop";
		}
	}
</script>
<style type="text/css">
<!--
body{
    overflow:hidden;
}
-->
</style>
 </HEAD>

 <BODY>
	<!--正文区-->
	<div id="content">
		<table border="0" width="100%" cellspacing="0" cellpadding="0">
			<tr>
				<td class="contentHead">&nbsp;</td>
				<td class="contentCenter"></td>
				<td class="contentBottom"></td>
			</tr>
			<tr>
				<td class="cLeft">&nbsp;</td>
				<td class="cCenter">
					<!--顶部工具区-->
					<div id="top">
						<table border="0" width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<div class="btnStart">
										<% if (!isUse) { %>
											<input type="hidden" name="flag" id="flag" value="0"/>
											<table border="0" width="100%" cellspacing="0" cellpadding="0">
												<tr>
													<td><div><img src="images/start_wev8.png"  style="margin-top:5px;margin-left:15px"  id="sos"></img></div></td>
													<td><div id="sosTxt" onclick="startOrStop(this);" class="debug">开始调试</div></td>
												</tr>
											</table>
										<% }else{ %>
											<input type="hidden" name="flag" id="flag" value="1"/>
											<table border="0" width="100%" cellspacing="0" cellpadding="0">
												<tr>
													<td><div style="float:left;"><img src="images/stop_wev8.png"  style="margin-top:5px;margin-left:15px"  id="sos"></img></div></td>
													<td><div id="sosTxt" onclick="startOrStop(this);" class="debug">停止调试</div></td>
												</tr>
											</table>
										<%} %>
									</div>
								</td>
								<td>
									<div class="btnPoint">
										<form id='statusForm' action='debugAction.jsp' target='emptyiframe'>
											<div style="margin-top:5px;">
												<span style="margin-left:3px;cursor:pointer;padding-right:30px;" onclick="setTrackType1(this);">
													<%if("1".equals(trackType) || trackType==null){ %>
														<img src="images/radio_true_wev8.png" class="imgTxt"/>&nbsp;只跟踪断点类
													<%}else{%>
														<img src="images/radio_false_wev8.png"class="imgTxt"/>&nbsp;只跟踪断点类
													<%}%>
												</span>
												<span style="cursor:pointer;padding-right:30px;" onclick="setTrackType2(this);">
													<%if("2".equals(trackType) || trackType==null){ %>
														<img src="images/radio_true_wev8.png"class="imgTxt"/>&nbsp;跟踪所有类
													<%}else{%>
														<img src="images/radio_false_wev8.png"class="imgTxt"/>&nbsp;跟踪所有类
													<%}%>
												</span>
												<span style="cursor:pointer;" onclick="setTrackSeq(this);">
													<%if("true".equals(isTrackSeq) || isTrackSeq==null){ %>
														<img src="images/checkbox_true_wev8.png"class="imgTxt"/>&nbsp;跟踪执行过程
													<%}else{%>
														<img src="images/checkbox_false_wev8.png"class="imgTxt"/>&nbsp;跟踪执行过程
													<%}%>
												</span>
											</div>
											<input type="hidden" name="tracktype" value="<%= "2".equals(trackType)?"all":"var"%>" id="tracktype"/>
											<span id="trackseqspan">
												<% if("true".equals(isTrackSeq)){ %>
													<input type='hidden' name='trackseq' id="trackseq" value="trackseq" />
												<% } %>
											</span>
											<input type='hidden' name='action' value='updatestatus' style='display:none'>
										  </form>
										  <iframe name='emptyiframe' style='display:none'></iframe>
									</div>
								</td>
								<td>
									<div>
										<table border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td class="downloadLeft"></td>
												<td class="downloadCenter">
													<table border="0" cellspacing="0" cellpadding="0">
														<tr>
															<td><div  style="cursor:pointer;margin-top:5px;padding-right:5px;display:inline;" onclick="javascript:window.location='log.txt'">下载日志文件	</div></td>
															<td><span><img src="images/btn_center_line_wev8.png" width="2px;"></span></td>
															<td><div style="cursor:pointer;margin-top:5px;padding-left:5px;display:inline;" onclick="javascript:window.location='tracklog/manual/<%=seq%>.zip'" >下载跟踪文件</div></td>
														</tr>
													</table>
												</td>
												<td class="downloadRight"></td>
											</tr>
										</table>
									</div>
								</td>
								<td>
										  <form id='uploadForm' action='uploadm.jsp' action='upload.jsp' method='post' enctype='multipart/form-data' style="margin-top:10px;">
											<div>
											<table border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td class="uploadL"></td>
													<td class="uploadC">
														<input type="file" name="file"/>
													</td>
													<td class="uploadR"></td>
												</tr>
											</table>
											</div>
											</form>
									
								</td>
								<td>
									<div class="btnUpload" align="center">
										<div onclick="$('#uploadForm').submit();" class="btnImp">上传跟踪文件</div>
									</div>
								</td>
							</tr>								
							</table>
					</div>
					<div style="margin-top:10px;">
						<!--调试信息输出区-->
						<div id="left">
							<table border="0" style="width:100%;height:100%" cellspacing="0" cellpadding="0">
								<tr>
									<td class="debugTL" height="15px"></td>
									<td class="debugTC" height="15px"></td>
									<td class="debugTR" height="15px"></td>
								</tr>
								<tr>
									<td class="debugCL"></td>
									<td class="debugCC" id="outputTD">
										<iframe frameborder="no" marginheight="0" marginwidth="0" border="0" src="viewLog.jsp" style="width:100%;height:100%">
										</iframe>
									</td>
									<td class="debugCR"></td>
								</tr>
								<tr>
									<td class="debugFL" height="15px"></td>
									<td class="debugFC" height="15px"></td>
									<td class="debugFR" height="15px"></td>
								</tr>
							</table>
							<div style="margin-top:10px;"><%= message %></div>
						</div>
						<!--调试设置区-->
						<div id="right">
							<table  border="0" style="width:100%;height:100%" cellspacing="0" cellpadding="0">
								<tr>
									<td class="pointTL"></td>
									<td class="pointTC" height="15px"></td>
									<td class="pointTR" height="15px"></td>
								</tr>
								<tr>
									<td class="pointCL"></td>
									<td class="pointCC">
										<!--断点设置-->
										<div id="classLine">
										<form action='debugAction.jsp?action=addvardata' target='vardatalist' id="addvardataForm">
											<input type="hidden" value="addvardata" name="action"/>
											<div>
												<span>类：</span>
												<span>
													<input type="text" name="classname" style="width:80%;padding-right:10px;"/>
												</span>
											</div>
											<div>
												<table  border="0" style="width:100%;" cellspacing="0" cellpadding="0">
													<tr>
														<td width="60%">
															<div style="margin-top:10px;">
																<span>行：</span>
																<span>
																	<input type="text" name="line" style="width:80%;padding-right:10px;"/>
																</span>
															</div>
														</td>
														<td>
															
																<div style="margin-top:10px;width:100%;margin-left:10px">
																	<table border="0" cellspacing="0" cellpadding="0">
																		<tr>
																			<td class="pointList"></td>
																			<td height="27px;" class="pointOper">
																				<table border="0" cellspacing="0" cellpadding="0">
																					<tr>
																						<td><div style="cursor:pointer" onclick="$('#addvardataForm').submit();">添加断点</div></td>
																					</tr>
																				</table>
																			</td>
																			<td class="btnCR"></td>
																		</tr>
																	</table>
																</div>
															
														</td>
													</tr>
												</table>
											</div>
											</form>
											<div style="margin-top:10px;">
												<table border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td><span>断点列表：</span></td>
														<td class="pointList"></td>
														<td height="27px;" class="pointOper">
															<table border="0" cellspacing="0" cellpadding="0">
																<tr>
																	<td><div  style="cursor:pointer;margin-top:5px;padding-right:5px;display:inline;" onclick="deleteCurrent();">删除</div></td>
																	<td><span><img src="images/btn_center_line_wev8.png" width="2px;"></span></td>
																	<td><div style="cursor:pointer;margin-top:5px;padding-left:5px;display:inline;" onclick="deleteAll();" >删除所有</div></td>
																</tr>
															</table>
														</td>
														<td class="btnCR"></td>
													</tr>
												</table>
											</div>
										</div>										
										<!--断点列表区-->
										<div id="breakpoint" style="margin-top:10px;background-color:#fff">
											<iframe frameborder="no" marginheight="0" marginwidth="0" border="0" src="varDataList.jsp" name="vardatalist" id="vardatalist" style="width:100%"></iframe>
										</div>
										<!--断点详细信息-->
										<div id="bpLabel" style="margin-top:10px;">断点详细信息：</div>
										<div id="bpDetail" style="margin-top:10px;background-color:#fff">
											<iframe frameborder="no" marginheight="0" marginwidth="0" border="0" src="varDataEdit.jsp" id="vardataedit" name="vardataedit" style="width:100%"></iframe>
										</div>
									</td>
									<td class="pointCR"></td>
								</tr>
								<tr>
									<td class="pointFL" height="15px"></td>
									<td class="pointFC" height="15px"></td>
									<td class="pointFR" height="15px"></td>
								</tr>
							</table>
						</div>
						<div style="clear:both"></div>
					</div>
				</td>
				<td class="cRight"></td>
			</tr>
			<tr>
				<td class="bodyFL">&nbsp;</td>
				<td class="bodyFC"></td>
				<td class="bodyFR"></td>
			</tr>
		</table>
	</div>
 </BODY>
</HTML>
<%
}catch(Exception e){
    e.printStackTrace();
}
%>
<%!
 private void loadAgent(){
     String workRoot = "";
     String resinHome = "";
     try {
        try {
            Class csClass = Thread.currentThread().getContextClassLoader().loadClass("com.caucho.util.CauchoSystem");
            Path workPath = (Path) csClass.getDeclaredMethod("getWorkPath", new Class[] {}).invoke(null, new Object[] {});
            Path resinPath = (Path) csClass.getDeclaredMethod("getResinHome", new Class[] {}).invoke(null, new Object[] {});

            workRoot = workPath.getNativePath().replace('\\', '/');
            resinHome = resinPath.getNativePath().replace('\\', '/');

        } catch (ClassNotFoundException e) {
            Class csClass = Thread.currentThread().getContextClassLoader().loadClass("com.caucho.server.util.CauchoSystem");
            Path workPath = (Path) csClass.getDeclaredMethod("getWorkPath", new Class[] {}).invoke(null, new Object[] {});
            Path resinPath = (Path) csClass.getDeclaredMethod("getResinHome", new Class[] {}).invoke(null, new Object[] {});

            workRoot = workPath.getNativePath().replace('\\', '/');
            resinHome = resinPath.getNativePath().replace('\\', '/');
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    String agentPath = resinHome + "/lib/onlinedebug.jar";
    
    String pid = null;
    RuntimeMXBean runtime = ManagementFactory.getRuntimeMXBean();
    String name = runtime.getName();
    pid = name.substring(0, name.indexOf("@"));
    try {
        VirtualMachine vm = VirtualMachine.attach(pid);
        vm.loadAgent(agentPath);
    } catch ( Exception e) {
        e.printStackTrace();
    } 
 }
 
%>
