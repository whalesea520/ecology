<%@ page language="java" import="java.util.regex.*" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@page import="weaver.social.SocialUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>

<%@page import="io.rong.models.FormatType"%>
<%@page import="io.rong.models.SdkHttpResult"%>
<%@page import="io.rong.util.CodeUtil"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="weaver.general.*"%>
<%@page import="weaver.conn.*"%>

<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.resource.*" %>
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	Log logger= LogFactory.getLog(this.getClass());
	
	String method = Util.null2String(request.getParameter("m"));
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
%>

<%
	////检测私有云相关配置
	//// ?m=CHECKOPENFIRE
	if(method.equalsIgnoreCase("CHECKOPENFIRE")){
		OrderProperties privateprop = new OrderProperties();
		privateprop.load(GCONST.getPropertyPath()+ "OpenfireModule.properties");
		String Openfire = Util.null2String(privateprop.get("Openfire"));
		String openfireEMobileUrl = Util.null2String(privateprop.get("openfireEMobileUrl"));
		String openfireMobileClientUrl = Util.null2String(privateprop.get("openfireMobileClientUrl"));
		String openfireEmessageClientUrl = Util.null2String(privateprop.get("openfireEmessageClientUrl"));
		String openfireHttpbindPort = Util.null2String(privateprop.get("openfireHttpbindPort"));
		boolean isOk = true;
		String host = "",proto="http";
		if("true".endsWith(Openfire)){
			if(openfireEmessageClientUrl.isEmpty()) {
				if(openfireMobileClientUrl.isEmpty()) {
					out.println("Openfire未配置ip地址！");
					isOk = false;
				}else if(openfireHttpbindPort.isEmpty()){
					out.println("Openfire端口未配置！");
					isOk = false;
				}else {
					host = openfireMobileClientUrl;
					if(openfireHttpbindPort.equals("7443")){
						proto = "https";
					}
					//isOk = isPortOpened(openfireMobileClientUrl, Util.getIntValue(openfireHttpbindPort));
					//if(!isOk)
					//	out.println("emessage服务运行异常，服务器地址："+openfireMobileClientUrl+" 端口："+openfireHttpbindPort);
				}
			}else if(openfireHttpbindPort.isEmpty()){
				out.println("Openfire端口未配置！");
				isOk = false;
			}else{
				host = openfireEmessageClientUrl;
				if(openfireHttpbindPort.equals("7443")){
					proto = "https";
				}
				//isOk = isPortOpened(openfireEmessageClientUrl, Util.getIntValue(openfireHttpbindPort));
				//if(!isOk)
				//	out.println("emessage服务运行异常，服务器地址："+openfireEmessageClientUrl+" 端口："+openfireHttpbindPort);
			}
			
			// 检测openfireEMobileUrl配置是否正常
			String regex="//(.*?):(.*)";
			Pattern p = Pattern.compile(regex);
			Matcher m = p.matcher(openfireEMobileUrl);
			boolean isPortOpened = false;
			if(m.find()){
				String mHost = m.group(1);
				String mPort = m.group(2);
				isPortOpened = isPortOpened(mHost, Util.getIntValue(mPort));
				if(!isPortOpened){
					out.println("oa服务到emessage服务器的9090端口不通，请检查配置："+openfireEMobileUrl);
					isOk = false;
				}
			}else {
				out.println("openfireEMobileUrl格式有误，需要带协议和端口，请检查："+openfireEMobileUrl);
				isOk = false;
			}
		}else{
			out.println("Openfire未开启！[openfire="+Openfire+"]");
			isOk = false;
		}
		
		// 检测初始化数据是否正常
		RecordSet rs = new RecordSet();
		rs.execute("select count(username) from OfUser");
		int ofUserCnt = 0,oaUserCnt = 0;
		if(rs.next()){
			ofUserCnt = rs.getInt(1);
		}
		rs.execute("select count(id) from HrmResource");
		if(rs.next()){
			oaUserCnt = rs.getInt(1);
		}
		if(oaUserCnt - ofUserCnt > 1){
			out.println("<div>OfUser有<span style='color:red'>"+ofUserCnt+"</span>条记录,Hrmresource有<span style='color:red'>"+oaUserCnt+"</span>,两个表数目不匹配，请检查，初始化步骤请参考：<a href='http://im.cobiz.cn/html/emessagefile/%E7%A7%81%E6%9C%89%E9%83%A8%E7%BD%B2%E5%88%9D%E5%A7%8B%E5%8C%96%E5%A4%B1%E8%B4%A5%E5%AF%BC%E8%87%B4%E4%B8%8D%E8%83%BD%E6%AD%A3%E5%B8%B8%E4%BD%BF%E7%94%A8%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm'>私有部署初始化失败导致不能正常使用解决方案说明</a></div>");
		}
		out.println(isOk?"<h2 style='color: lightgreen'>emessage服务运行正常</h2>":"<h2 style='color: red'>检测到emessage服务运行异常</h2>");
		if(isOk){
			String clientIp = getRemoteIP(request);
			String targetHost = proto+"://"+host+":"+openfireHttpbindPort;
			out.println("<p>检测客户端(<span style='color:red'>"+clientIp+"</span>)到emessage服务器(<span style='color:red'>"+targetHost+"</span>)连通性(<span style='color: blue;font-size:9px;'>下方出现\'Openfire HTTP Binding Service\'表示正常 </span>)：</p>");
		%>
			<iframe frameborder=0 width='400px' height='100px' scrolling='no' src="<%=targetHost%>"></iframe>
		<%
		//FIXME: 测试iq请求是否到达
		}
	}
	//// emessage的附件 打不开
	else if(method.equalsIgnoreCase("checkConf")){
		// 检查web.xml相关配置
		boolean isBaseFilterConfigured = SocialUtil.isFilterConfigured("SocialIMFilter");
        boolean isServletFilterConfigured = SocialUtil.isFilterConfigured("SocialIMServlet");
		// 检查安全补丁包相关配置
        boolean isLoginCheckOpen = SocialUtil.isLoginCheckOpen();
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("<div>");
		buffer.append("<p>SocialIMFilter："+(isBaseFilterConfigured?"已配置":"<span style='color: red'>没有配置</span>")+
        		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157626'>查看相关配置说明</a>"+"</p>");
        buffer.append("<p>SocialIMServlet："+(isServletFilterConfigured?"已配置":"<span style='color: red'>没有配置</span>")+
        		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/emessage4%E9%99%84%E4%BB%B6%E5%92%8C%E5%9B%BE%E7%89%87%E8%87%AA%E5%8A%A8%E5%88%A0%E9%99%A4%E5%8A%9F%E8%83%BD%E9%85%8D%E7%BD%AE%E6%89%8B%E5%86%8C.htm'>查看相关配置文档</a></p>");
        buffer.append("<p>"+(isLoginCheckOpen?"<span style='color: red'>安全补丁包开启了登录检查</span>":"安全补丁包没有开启登录检查")+
        		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157627'>查看相关配置说明</a>"+"</p>");
        
		buffer.append("</div>");   
		
		%>
		<div>如果出现以下问题，请先检查相关配置(红色表示不正常)：</div>
		<p>1 emessage单点到oa主页跳转到登录页</p>
		<p>2 emessage接收附件打开乱码或提示数据损坏</p>
		<%=buffer.toString() %>
	<%
	}
	//// 检测web版emessage相关配置
	//// ?m=checkwebem
	else if(method.equalsIgnoreCase("checkweb")){
		// 1 检查总开关
		boolean isOpenIM = SocialIMService.isOpenIM();
		// 2 检查web版开关
		boolean isOpenWebIM = SocialIMService.isUseWebEmessage();
		// 3 检查license授权
		boolean isLicenseOk = SocialImLogin.checkLience() == 1;
		// 4 检查version版本号
		boolean isE4 = SocialIMService.checkE4Version();
		boolean isAccessLogin= false, isPcOnline =false;
		User user = HrmUserVarify.getUser (request , response);
		if(user != null) {
			// 5 检查是否禁止登录
			isAccessLogin= SocialImLogin.checkForbitLogin(user.getUID()+"");
			// 6 检查pc版登录状态
			String userid = user.getUID()+"";
			ResourceComInfo rci = new ResourceComInfo();
			String username = rci.getLastname(userid);
			String messageUrl = rci.getMessagerUrls(userid);
			isPcOnline = SocialImLogin.CheckpcOnline(userid, username, messageUrl);
		}
		
		// 7 检查当前浏览器版本
		%>
		<div>我的（<span style="color: blue">登录名: <%=user.getLoginid() %></span>）web版emessage图标不显示了 <button onclick="refresh()">重新检查</button></div>
		<script>
			var isOpenIM = <%=isOpenIM?1:0%>;
			var isOpenWebIM = <%=isOpenWebIM?1:0%>;
			var isLicenseOk = <%=isLicenseOk?1:0%>;
			var isE4 = <%=isE4?1:0%>;
			var isAccessLogin = <%=isAccessLogin?1:0%>;
			var isPcOnline = <%=isPcOnline?1:0%>;
			
			// 检查浏览器版本
			function IEVersion() {
	            var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
	            var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1; //判断是否IE<11浏览器  
	            var isEdge = userAgent.indexOf("Edge") > -1 && !isIE; //判断是否IE的Edge浏览器  
	            var isIE11 = userAgent.indexOf('Trident') > -1 && userAgent.indexOf("rv:11.0") > -1;
	            if(isIE) {
	                var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
	                reIE.test(userAgent);
	                var fIEVersion = parseFloat(RegExp["$1"]);
	                if(fIEVersion == 7) {
	                    return 7;
	                } else if(fIEVersion == 8) {
	                    return 8;
	                } else if(fIEVersion == 9) {
	                    return 9;
	                } else if(fIEVersion == 10) {
	                    return 10;
	                } else {
	                    return 6;//IE版本<=7
	                }   
	            } else if(isEdge) {
	                return 'edge';//edge
	            } else if(isIE11) {
	                return 11; //IE11  
	            }else{
	                return -1;//不是ie浏览器
	            }
	        }
	        
	        function appendBanner(htmlText, color) {
	        	var node = document.createElement("DIV");
	        	node.style.color = color?color:"red";
	        	node.innerHTML = htmlText;
	        	document.body.appendChild(node);
	        }
	        
	        function refresh() {
	        	window.location.reload();
	        }
	        
	        function checkBrowser() {
	        	var versionNO = IEVersion();
				var text = "";
				
				if(versionNO > 0 && versionNO < 10){
					text = "当前浏览器版本不支持";
					appendBanner("当前浏览器版本不支持, 至少是ie10版本");
					return false;
				}
				return  true;
	        }
	        
	        function checkWeb() {
	        	var url = "http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#";
	        	var isOk = true;
	        	if(!isOpenIM) {
	        		appendBanner("<div>IM功能未开启 <a target='_blank' href='"+url+"_Toc510953369'>处理方案</a></div>");
	        		isOk = false;
	        	} 
	        	if(!isOpenWebIM) {
	        		appendBanner("<div>web版emessage开关未开启 <a target='_blank' href='"+url+"#_Toc510953369'>处理方案</a></div>");
	        		isOk = false;
	        	} 
	        	if(!isLicenseOk) {
	        		appendBanner("<div>emessage授权异常 <a target='_blank' href='"+url+"#_Toc510953365'>处理方案</a></div>");
	        		isOk = false;
	        	} 
	        	if(!isE4) {
	        		appendBanner("<div>version不兼容【检查/ecology/social/im/resources/emessage.properties文件，确认version字段值为4.0】</div>");
	        		isOk = false;
	        	} 
	        	if(!isAccessLogin) {
	        		appendBanner("<div>当前用户被禁止登录emessage<a target='_blank' href='"+url+"#_Toc510953393'>处理方案</a></div>");
	        		isOk = false;
	        	} 
	        	if(isPcOnline) {
	        		appendBanner("<div>当前用户客户端在线 【客户端和web端不能同时在线】</div>");
	        		isOk = false;
	        	} 
	        	isOk = checkBrowser()?isOk: false;
	        	if(isOk) {
	        		appendBanner("检测正常", "green");
	        	}else {
	        		appendBanner("可能是以上原因导致web端不显示，请做相应处理后，再进行检查", "blue");
	        	}
	        }
	        
	        checkWeb();
		
		</script>
		<%
	}
%>

<%!
	public static String RONGCLOUDURI = "http://api.cn.ronghub.com"; 
	public static StringBuilder logSb = new StringBuilder();
	
	static {
		try{
			OrderProperties privateprop = new OrderProperties();
			privateprop.load(GCONST.getPropertyPath()+ "EMRongPrivate.properties");
			String apihost = privateprop.get("API_HOST");
			logSb.append("API_HOST:"+apihost);
			if(apihost != null && !apihost.isEmpty()){
				RONGCLOUDURI="http://"+apihost;
			}
		}catch(Exception e){
			logSb.append(e.toString());
			RONGCLOUDURI = "http://api.cn.ronghub.com"; 
		}
	}
	private static final String UTF8 = "UTF-8";
	private static final String UDID = "udid";
	private static final String TIMESTAMPOLD = "timestamp";
	private static final String SIGNATUREOLD = "sign";
	private static final String FORMAL = "formal";

	private static final String APPKEY = "RC-App-Key";
	private static final String NONCE = "RC-Nonce";
	private static final String TIMESTAMP = "RC-Timestamp";
	private static final String SIGNATURE = "RC-Signature";

public static SdkHttpResult getMessageHistoryUrl(String appKey,
		String appSecret, String date, FormatType format ,String udid) throws Exception {

	HttpURLConnection conn = CreatePostHttpConnection(appKey,
			appSecret,
			RONGCLOUDURI + "/message/history." + format.toString() , udid );

	StringBuilder sb = new StringBuilder();
	sb.append("date=").append(URLEncoder.encode(date, UTF8));
	logSb.append(sb);
	setBodyParameter(sb, conn);

	return getResult(conn);
}

//添加签名header
public static HttpURLConnection CreatePostHttpConnection(String appKey,
		String appSecret, String uri,String udid) throws MalformedURLException,
		IOException, ProtocolException {
	String nonce = String.valueOf(Math.random() * 1000000);
	String timestamp = String.valueOf(System.currentTimeMillis() / 1000);
	StringBuilder toSign = new StringBuilder(appSecret).append(nonce)
			.append(timestamp);
	String sign = CodeUtil.hexSHA1(toSign.toString());
	logSb.append("URI:"+uri);
	URL url = new URL(uri);
	HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	conn.setUseCaches(false);
	conn.setDoInput(true);
	conn.setDoOutput(true);
	conn.setRequestMethod("POST");
	conn.setInstanceFollowRedirects(true);
	conn.setConnectTimeout(30000);
	conn.setReadTimeout(30000);

	conn.setRequestProperty(APPKEY, appKey);
	conn.setRequestProperty(NONCE, nonce);
	conn.setRequestProperty(TIMESTAMP, timestamp);
	conn.setRequestProperty(SIGNATURE, sign);
	conn.setRequestProperty("Content-Type",
			"application/x-www-form-urlencoded");

	return conn;
}

// 设置body体
public static void setBodyParameter(StringBuilder sb, HttpURLConnection conn)
		throws IOException {
	DataOutputStream out = new DataOutputStream(conn.getOutputStream());
	out.writeBytes(sb.toString());
	out.flush();
	out.close();
}

public static SdkHttpResult getResult(HttpURLConnection conn)
		throws Exception, IOException {
	String result;
	InputStream input = null;
	if (conn.getResponseCode() == 200) {
		input = conn.getInputStream();
		
	} else {
		input = conn.getErrorStream();
	}
	result = returnStringFromInput(input);
	return new SdkHttpResult(conn.getResponseCode(), result);
}

public static String returnStringFromInput(InputStream inStream) throws Exception {
	BufferedReader br = new BufferedReader( new InputStreamReader(inStream,"UTF-8"));
	String buffer, dir = new String();
    while((buffer = br.readLine())!= null)
    	dir += buffer + "\n";
    br.close();
	return dir;
}
//下载文件到指定位置
	public static void  downloadMsg(URL url,String savePath){
		InputStream in = null;
		FileOutputStream fo = null; 
		boolean result=false;
		try {
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			in = conn.getInputStream();
			
			File file=new File(savePath);
			if(!file.exists()){
				file.createNewFile();
			}
			
			fo = new FileOutputStream(file);
			byte[] buffer = new byte[1024];
			int len = 0;
			while((len = in.read(buffer)) > 0){
				fo.write(buffer, 0, len);
			}
			fo.flush();
			result=true;
		} catch (IOException e) {
			result=false;
			e.printStackTrace();
			logSb.append("下载保存消息记录失败");
			logSb.append("<br>");
			logSb.append(e);
			logSb.append("<br>");
		}finally{
			try{
				if(in != null)
					in.close();
				if(fo != null)
					fo.close();
			}catch (Exception e) {
				e.printStackTrace();
				logSb.append(e);
				logSb.append("<br>");
			}
		}
		
	}
	

%>

<%!

public static boolean isPortOpened(String hostname, int port){
	Socket client = null;
	try{
	  client = new Socket();
	  client.connect(new InetSocketAddress(hostname, port), 5000);
	  client.close();
	  return true;
	}catch(Exception e){
	  e.printStackTrace();
	}
	return false;
}

public String getRemoteIP(HttpServletRequest request) { 
	String ip  =  request.getHeader( "x-forwarded-for" ); 
    if (ip == null || ip.length() == 0 || "unknown" .equalsIgnoreCase(ip))  {  
    	ip = request.getHeader( "Proxy-Client-IP" );  
    }
    if (ip == null || ip.length() == 0 || "unknown" .equalsIgnoreCase(ip))  {  
    	ip = request.getHeader( "WL-Proxy-Client-IP");  
    }   
    if (ip == null || ip.length() == 0 || "unknown" .equalsIgnoreCase(ip))  {  
    	ip = request.getRemoteAddr();  
    }   
	return ip;
 }  

%>