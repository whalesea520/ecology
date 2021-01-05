<%@ page language="java" import="java.util.*,java.util.zip.*,java.util.regex.*" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.social.im.SocialIMClient"%>
<%@page import="weaver.social.im.SocialImLogin"%>
<%@page import="weaver.social.SocialUtil"%>
<%@page import="weaver.social.service.SocialIMService"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>

<%@page import="io.rong.models.FormatType"%>
<%@page import="io.rong.models.SdkHttpResult"%>
<%@page import="io.rong.util.CodeUtil"%>
<%@page import="java.net.*"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="weaver.general.*"%>
<%@page import="weaver.conn.*"%>
<%@page import="weaver.file.Prop" %>
<%@page import="weaver.mobile.rong.HistoryMsgService"%>
<%@page import="weaver.social.service.SocialOpenfireUtil"%>
<%@page import="weaver.social.service.SocialApiHttpClient"%>
<%@page import="weaver.social.license.MessageLicenseUtil"%>
<%@page import="net.sf.json.JSONObject"%>

<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.hrm.resource.*" %>
<%
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");
	
	String method = Util.null2String(request.getParameter("m"));
	request.setCharacterEncoding("UTF-8");
	response.setCharacterEncoding("UTF-8");
%>

<%
	////检测内部推送
	//// ?m=PUSH&receivers=1,2,3
	if(method.equalsIgnoreCase("PUSH") ) { 
		String receivers = Util.null2String(request.getParameter("receivers"));
		SocialIMClient sic = new SocialIMClient();
		
		String requesttitle = "测试打开内部推送";
		String requestdetails = "创建人：系统管理员<br>创建时间：" + TimeUtil.getCurrentTimeString();
		String requesturl = "http://www.weaver.com.cn";
		String extra = "";
		
		List<String> receiverIds = Util.TokenizerString(receivers, ",");
		// receiverIds.add("79");
		//sic.pushExternal(19, requesttitle,requestdetails,extra, receiverIds);
		sic.pushInternal(1, requesttitle, requestdetails, "1", extra, receiverIds);
		
		out.print("push测试完成！");
	}
	
	//// 公有云消息记录下载
	//// ?m=DOWNRONGMSG&date=xx&startH=xx&endH=xx&isSavePre3=1
	else if(method.equalsIgnoreCase("DOWNRONGMSG") ) { 

		String appKey = Prop.getPropValue("EMobileRong", "AppKey");
		String appSecret = Prop.getPropValue("EMobileRong", "AppSecret");
		String udid = "";
		RecordSet rs = new RecordSet();
		rs.execute("select * from mobileProperty where name='rongAppUDIDNew'");
		if(rs.next()){
			udid = rs.getString("propValue");
		}
		String dirPath = application.getRealPath("/");
		// 指定日期
		String targetDate = Util.null2String(request.getParameter("date"));
		// 默认当天
		String currentDate = TimeUtil.getFormartString(new Date(), "yyyyMMdd");
		// 开始时段（24）
		String startHour = Util.null2String(request.getParameter("startH"));
		// 截止时段（24）
		String endHour = Util.null2String(request.getParameter("endH"));

		int iStartHr = startHour.isEmpty()?0:Util.getIntValue(startHour);
		int iEndHr = endHour.isEmpty()?24:Util.getIntValue(endHour);

		// 是否同步前3个小时的消息记录，用于公有云切换私有云时使用
		String isSavePre3 = Util.null2String(request.getParameter("isSavePre3"));

		String fileDir = "HistoryMsgFiles";
		//初始化融云sdk
		try{
				SdkHttpResult result = new SdkHttpResult(0,"{\"code\":\"200\",\"result\":\"\"}");
				String[] dateIndexs = {"".equals(targetDate)?currentDate:targetDate};
				String date = "";
				File file=new File(File.separatorChar+fileDir);
			if(!file.exists()){
				file.mkdirs();
			}
			logSb.setLength(0);
			logSb.append("===============开始执行=============");
			logSb.append("<br>");
		//获取消息记录下载地址
			for(String dateIndex:dateIndexs){
				for(int i = iStartHr ; i <= iEndHr ;i++){
					String index ="";
					if(i<9)
					{
						index = "0"+i;
						date = dateIndex + index ;
					}else
					{
						date = dateIndex + i ;
					}
					
					
					result = getMessageHistoryUrl(appKey, appSecret, date,  FormatType.json,udid);
					logSb.append("===================="+result.getResult());
					logSb.append("<br>");
					org.json.JSONObject json = json = new org.json.JSONObject(result.getResult());
				
					String savePath = dirPath + "/" + fileDir +File.separatorChar+date+".zip";
					
					String downloadCode=json.getString("code");
					String downloadUrl=json.getString("url");
					
					if(!downloadCode.equals("200")){
						logSb.append("数据下载失败:result为"+json.toString());
						logSb.append("<br>");
					}
					
					if("".equals(downloadUrl)){  //url为空 表示没有消息记录
						logSb.append(date+" 没有消息记录");
						logSb.append("<br>");
					}else
					{
						URL url = new URL(json.getString("url"));
						//下载保存消息记录
						downloadMsg(url,savePath);
					}
				}
			}
				// 同步前3个小时的消息记录
				if(!isSavePre3.isEmpty()) {
					logSb.append("===============执行入库操作=============");

			        HistoryMsgService hmse = new HistoryMsgService();

					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHH");
					Date now = new Date();
					Calendar cal = Calendar.getInstance();
					cal.setTime(now);
					cal.add(Calendar.HOUR_OF_DAY, -3);
					String time = sdf.format(cal.getTime());

			        hmse.doThreadWork(time);
			        
			        cal.add(Calendar.HOUR_OF_DAY, 1);
			        time = sdf.format(cal.getTime());
			        hmse.doThreadWork(time);
			        
			        cal.add(Calendar.HOUR_OF_DAY, 1);
			        time = sdf.format(cal.getTime());
			        hmse.doThreadWork(time);
					
					logSb.append("===============结束执行=============");
					logSb.append("<br>");
					
				}
			} catch (Exception e) {
				e.printStackTrace();
				logSb.append(e);
				logSb.append("<br>");
				return;
			} finally{
				out.print(logSb.toString());
			}
	}
	//// 公有云消息入库
	//// ?m=saverongmsg&ym=xx&d=xx&startH=xx&endH=xx&rootPath=xx
	else if(method.equalsIgnoreCase("SAVERONGMSG") ) { 
		String yearMonth = Util.null2String(request.getParameter("ym"));
		String dateRange = Util.null2String(request.getParameter("d"));
		// 如果没有指定日期，默认取当天日期
		String ymd = TimeUtil.getFormartString(new Date(), "yyyyMMdd");
		if(yearMonth.isEmpty()){
			yearMonth = ymd.substring(0, 6);
		}
		if(dateRange.isEmpty()){
			dateRange = ymd.substring(6, 8);
		}
		
		// 开始时段（24）
		String startHour = Util.null2String(request.getParameter("startH"));
		// 截止时段（24）
		String endHour = Util.null2String(request.getParameter("endH"));

		int iStartHr = startHour.isEmpty()?0:Util.getIntValue(startHour);
		int iEndHr = endHour.isEmpty()?23:Util.getIntValue(endHour);
		
		rootPath = Util.null2String(request.getParameter("rootPath"));
		
		HistoryMsgService historyMsgService = new HistoryMsgService();
	   
		String[] day = Util.TokenizerString2(dateRange, ",");
		List<String> dayList = new ArrayList<String>();
		int startDate, endDate, i;
		for(String d : day) {
			i = d.indexOf("-");
			if(i != -1){
				startDate = Util.getIntValue(d.substring(0,i));
				endDate = Util.getIntValue(d.substring(i+1, d.length()));
				for(; startDate <= endDate; startDate++) {
					dayList.add(startDate+"");
				}
			}else{
				dayList.add(d);
			}
		}
		// day = null;
		day = dayList.toArray(day);
	   StringBuffer sb = new StringBuffer();
	   for(int j = iStartHr; j <= iEndHr; ++j){
		   sb.append(j+",");
	   }
	   sb.deleteCharAt(sb.length() - 1);
	   String[] time = Util.TokenizerString2(sb.toString(), ",");
	    for(String d : day ) {
	        for(String t : time) {%>
	        	<div><%= "正在进行入库操作：" + yearMonth + d + t %></div>
	    		<%
	    		logger.error("正在进行入库操作：" + yearMonth + d + t);
	    		
				List<Map<String,String>> msgRecords = getMsgRecords(yearMonth + d + t); //下载历史记录 
	    		try {
	    			historyMsgService.msgRecords2Db(msgRecords);
			    } catch (Exception e) {
			    	logger.error("入库失败：" + e.toString());
			    }
	    		%>
	    		<span>ok</span>
	    		<%
	        }
	    }
		
	    out.println("over!");
	} 
	//// 检测OpenfireModule.properties配置是否正确
	//// ?m=GETPROPS
	
	else if(method.equalsIgnoreCase("GETPROPS") ) { 
		String appPath = getRootPath();
		String fileName = "";
		File file = null;
		BufferedReader input = null;
		try {
			
			// EMobileRong.properties
			StringBuffer buffer = new StringBuffer();
            String text;
            buffer.append("<div style='float: left;padding: 20px;'><h2>EMobileRong.properties</h2>");
            fileName = GCONST.getPropertyPath()+ "EMobileRong.properties";
            file = new File(fileName);
            input = new BufferedReader(new FileReader(file));
            
            while ((text = input.readLine()) != null)
                buffer.append("<p>"+text + "</p>");
            
            // udid
            RecordSet rs = new RecordSet();
            rs.execute("select * from mobileProperty where name='rongAppUDIDNew'");
            if(rs.next()){
            	String udid = rs.getString("propValue");
            	buffer.append("<p>Udid="+udid + "</p></div>");
            }
            
            // OpenfireModule.properties
            
            fileName = GCONST.getPropertyPath()+ "OpenfireModule.properties";
            file = new File(fileName);
            input = new BufferedReader(new FileReader(file));
            buffer.append("<div style='float:left;padding: 20px;'><h2>OpenfireModule.properties</h2>");
            while ((text = input.readLine()) != null)
                buffer.append("<p>"+text + "</p>");
            buffer.append("</div>"); 
            // emessage.properties
            buffer.append("<div style='float:left;padding: 20px;'><h2>emessage.properties</h2>");
            fileName = appPath + 
            	File.separator + "social" + 
            	File.separator + "im" +
            	File.separator + "resources" +
            	File.separator + "emessage.properties";
            
            file = new File(fileName);
           	input = new BufferedReader(new FileReader(file));
            while ((text = input.readLine()) != null)
                buffer.append("<p>"+text + "</p>");
            buffer.append("</div>");   
               
            //TODO: emessage服务端版本和配置
            
            // ecology KB补丁包版本
            buffer.append("<div style='float: left;padding: 20px;'><h2>ecology KB补丁包版本</h2>");
            rs.executeSql("select companyname,cversion from license");
            String companyName = null, cversion = null;
			if (rs.next()) {
				companyName=rs.getString("companyname");
				cversion=rs.getString("cversion");
				buffer.append("<p>公司名："+companyName+"  版本："+cversion+"</p>");
			}
			buffer.append("</div>");   
			
			// 过滤器和安全包登录检查配置
            buffer.append("<div style='float: left;padding: 20px;'><h2>过滤器和安全包登录检查配置</h2>");
            boolean isBaseFilterConfigured = SocialUtil.isFilterConfigured("SocialIMFilter");
            boolean isServletFilterConfigured = SocialUtil.isFilterConfigured("SocialIMServlet");
            boolean isLoginCheckOpen = SocialUtil.isLoginCheckOpen();
            
            buffer.append("<p>SocialIMFilter："+(isBaseFilterConfigured?"已配置":"没有配置")+
            		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157626'>查看相关配置说明</a>"+"</p>");
            buffer.append("<p>SocialIMServlet："+(isServletFilterConfigured?"已配置":"没有配置")+
            		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/emessage4%E9%99%84%E4%BB%B6%E5%92%8C%E5%9B%BE%E7%89%87%E8%87%AA%E5%8A%A8%E5%88%A0%E9%99%A4%E5%8A%9F%E8%83%BD%E9%85%8D%E7%BD%AE%E6%89%8B%E5%86%8C.htm'>查看相关配置文档</a></p>");
            buffer.append("<p>"+(isLoginCheckOpen?"安全补丁包开启了登录检查":"安全补丁包没有开启登录检查")+
            		"&nbsp;&nbsp;<a target='_blank' href='http://im.cobiz.cn/html/emessagefile/message4.x%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E8%A7%A3%E5%86%B3%E6%96%B9%E6%A1%88.htm#_Toc502157627'>查看相关配置说明</a>"+"</p>");
            
			buffer.append("</div>");   
            out.print(buffer.toString());
        } catch (IOException ioException) {
            System.err.println("File Error!");
        } finally {
        	if(input != null)
        		input.close();
        }
	}
	//// 检测openfire服务是否正常
	//// ?m=CHECKOPENFIRE
	else if(method.equalsIgnoreCase("CHECKOPENFIRE")){
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
	//// 手动刷新服务端缓存配置
	//// ?m=flushconfig
	else if(method.equalsIgnoreCase("FLUSHCONFIG")){
		// RongService
	}
	////手动刷新license配置
	//// ?m=flushlicense
	else if(method.equalsIgnoreCase("FLUSHLICENCE")){
		MessageLicenseUtil.fresh();
	}
	//// 获取sessionkey缓存
	//// ?m=listSessionkey
	else if(method.equalsIgnoreCase("LISTSESSIONKEY")){
		Map sessionkeyMap = SocialImLogin.getSessionKeyMap();
		Iterator<Map.Entry<Integer, String>> it = sessionkeyMap.entrySet().iterator();
		logSb.setLength(0);
		logSb.append("<h2>sessionMap</h2>");
		while (it.hasNext()) {
			Map.Entry<Integer, String> entry = it.next();
			logSb.append("<p>"+"userid= <span style='color: red'>" + entry.getKey() + "</span> and sessionkey= <span style='color: blue;'>" + entry.getValue()+"</span></p>");
		}
		
		Map cacheMap = SocialImLogin.getcacheMap();
		Iterator<Map.Entry<String, Integer>> it0 = cacheMap.entrySet().iterator();
		logSb.append("<h2>cacheMap</h2>");
		while (it0.hasNext()) {
			Map.Entry<String, Integer> entry = it0.next();
			logSb.append("<p>"+"sessionkey= <span style='color: blue'>" + entry.getKey() + "</span> and userid= <span style='color: red;'>" + entry.getValue()+"</span></p>");
		}
		out.println(logSb.toString());
	}
	////强制移除sessionkey缓存
	//// ?m=clearSessionkey&userids=1,3,4
	else if(method.equalsIgnoreCase("CLEARSESSIONKEY")){
		// 根据userid去删，如果没有，清空所有
		String userids = Util.null2String(request.getParameter("userids"));
		if (userids.isEmpty()) {
			SocialImLogin.removeAllSession();
		} else {
			String[] idlist = Util.TokenizerString2(userids, ",");
			for(String id: idlist) {
				SocialImLogin.removeSession(id);
			}
		}
		out.println("操作成功");
	}
	////强制移除的tokenMap缓存
	//// ?m=clearTokenMap
	else if(method.equalsIgnoreCase("clearTokenMap")){
		if(SocialOpenfireUtil.getInstanse().isBaseOnOpenfire()){
			SocialOpenfireUtil.getInstanse().clearTokenMap();
		}		
		out.println("操作成功");
	}
	////获取私有云的tokenMap缓存
	//// ?m=getTokenMap
	else if(method.equalsIgnoreCase("getTokenMap")){
		StringBuilder result = new StringBuilder();
		//if(SocialOpenfireUtil.getInstanse().isBaseOnOpenfire()){
		Map tokenMap = SocialOpenfireUtil.getInstanse().getTokenMap();
		//}	
		result.append("<h2>TokenMap</h2>");
		for(Object indexKey : tokenMap.keySet()){
			result.append("<p>"+"IMUserID: <span style='color: red'>" +indexKey + "</span> and token: <span style='color: blue;'>" + tokenMap.get(indexKey)+"</span></p>");
		}
		out.println(result.toString());
	}
	////获取私有云超时时间
	//// ?m=getSecTimeout
	else if(method.equalsIgnoreCase("getSecTimeout")){
		out.println(SocialApiHttpClient.getSecTimeout());
	}
	////刷新私有云超时时间
	//// ?m=updateSecTimeout
	else if(method.equalsIgnoreCase("updateSecTimeout")){
		out.println("<p>刷新前的值:"+SocialApiHttpClient.getSecTimeout()+"</p>");
		int newValue = SocialApiHttpClient.updateTimeoutByProp();
		out.println("<p>"+(newValue == -1?"刷新失败":("刷新后的值："+newValue))+"</p>");
	}
	////提取消息记录的附件id
	//// ?m=extractMsgFileid
	else if(method.equalsIgnoreCase("extractMsgFileid")){
		String tableName = Util.null2String(request.getParameter("table"));
		RecordSet rs = new RecordSet();
		tableName = tableName.isEmpty()? "HistoryMsg": tableName;
		out.println("<p>为表"+tableName+"创建临时字段tmp_fileid</p>");
		try{
			rs.execute("alter table "+ tableName +" add tmp_fileid int");
		}catch(Exception e) {
			
		}
		out.println("<p>创建成功!开始规整附件信息。。</p>");
		rs.execute("select id, extra from " + tableName + " where classname = 'FW:attachmentMsg'");
		Map<String, String> map = new HashMap<String, String>();
		while(rs.next()) {
			try{
				JSONObject json = JSONObject.fromObject(rs.getString(2));
				map.put(rs.getString(1), json.getString("fileid"));
			}catch(Exception e){
				
			}
		}
		out.println("<p>规整成功!📱收集了"+map.size()+"条数据，开始更新tmp_fileid字段。。</p>");
		String updateSql = "update " + tableName + " set tmp_fileid = ? where id = ?";
		BatchRecordSet brs = new BatchRecordSet();
		List<String> paras = new ArrayList<String>();
		final char ch = Util.getSeparator();
		int count = 0;
		for(String id : map.keySet()) {
			// 过滤非法的fileid
			if (!SocialUtil.isNumeric(map.get(id))) {
				continue;
			}
			paras.add(map.get(id)+ch+id);
			count++;
			// 到4000条，执行一次更新
			if(count == 4000){
				brs.executeSqlBatch(updateSql, paras);
				out.println("<p>更新了4000条</p>");
				paras.clear();
				count = 0;
			}
		}
		
		brs.executeSqlBatch(updateSql, paras);
		out.println("<p>更新了"+paras.size()+"条</p>");
		out.println("<p>更新成功!📱 开始添加索引</p>");
		try{
			rs.execute("create index msg_tmpfileid_idx on " + tableName + "(tmp_fileid)");
		}catch(Exception e) {
			
		}
		
		out.println("<p>创建成功!</p>");
		
	}
	//// 检测web版emessage相关配置
	//// ?m=checkwebem
	else if(method.equalsIgnoreCase("checkweb")){
		// 1 检查总开关
		boolean isOpenIM = SocialIMService.isOpenIM();
		out.println("<div>emessage总开关是否开启："+ (isOpenIM?"<span style='color: green;'>是</span>":"<span style='color: red;'>否</span>") + "</div>");
		// 2 检查web版开关
		boolean isOpenWebIM = SocialIMService.isUseWebEmessage();
		out.println("<div>web版emessage开关是否开启："+ (isOpenWebIM?"<span style='color: green;'>是</span>":"<span style='color: red;'>否</span>") + "</div>");
		// 3 检查license授权
		boolean isLicenseOk = SocialImLogin.checkLience() == 1;
		out.println("<div>emessage4.x授权是否正常："+ (isLicenseOk?"<span style='color: green;'>是</span>":"<span style='color: red;'>否</span>") + "</div>");
		// 4 检查version版本号
		boolean isE4 = SocialIMService.checkE4Version();
		out.println("<div>version值是否是4.0："+ (isE4?"<span style='color: green;'>是</span>":"<span style='color: red;'>否</span>") + "</div>");
		
		User user = HrmUserVarify.getUser (request , response);
		if(user != null) {
			// 5 检查是否禁止登录
			boolean isAccessLogin= SocialImLogin.checkForbitLogin(user.getUID()+"");
			out.println("<div>是否禁止登录：用户 "+ user.getLoginid() + (isAccessLogin?" <span style='color: green;'>没有被禁止登录</span>":" <span style='color:red;'>被禁止登录</span>")+"</div>");
			// 6 检查pc版登录状态
			String userid = user.getUID()+"";
			ResourceComInfo rci = new ResourceComInfo();
			String username = rci.getLastname(userid);
			String messageUrl = rci.getMessagerUrls(userid);
			boolean isPcOnline = SocialImLogin.CheckpcOnline(userid, username, messageUrl);
			out.println("<div>是否客户端在线：用户 "+ user.getLoginid() + (isPcOnline?" <span style='color:red;'>在线</span>":" <span style='color: green;'>不在线</span>")+"</div>");
		}
		
		// 7 检查当前浏览器版本
		%>
		<script>
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
		var versionNO = IEVersion();
		var text = "";
		var node = document.createElement("DIV");
		if(versionNO > 0 && versionNO < 10){
			text = "当前浏览器版本不支持";
			node.style.color = "red";
		}else {
			text = "当前浏览器版本支持";
			node.style.color = "green";
		}
		
		var textnode=document.createTextNode(text);
		node.appendChild(textnode);
		document.body.appendChild(node);
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

Log logger= LogFactory.getLog(this.getClass());

String rootPath = "";

public String getRootPath(){
	String rootPaht=rootPath.isEmpty()? GCONST.getRootPath(): rootPath;
	return rootPaht;
}

public Map<String, String> parseJSON2Map(String jsonStr){  
    Map<String, String> map = new HashMap<String, String>(); 
    JSONObject json = JSONObject.fromObject(jsonStr);  
    for(Object k : json.keySet()){ 
    	Object v =  json.get(k);   
        if(v instanceof JSONObject){ 
        	map.putAll(parseJSON2Map(v.toString()));
        } else {  
            map.put(k.toString(), v.toString());  
        }  
    } 
    return map;  
}

public List<Map<String,String>> getMsgRecords(String dateFormat) throws Exception{
	List<Map<String,String>> msgRecords = new ArrayList<Map<String, String>>();
	String downloadpath=getRootPath()+"HistoryMsgFiles";
	File file = new File(downloadpath);
	if(!file.exists()){
		file.mkdirs();
	}
	String msgPath =downloadpath+File.separatorChar+dateFormat + ".zip";
	logger.error(msgPath);
	file = new File(msgPath);
	if (file.exists()) {
		List<String> lineMsgs = new ArrayList<String>();
		ZipFile zfile = new ZipFile(file);
		InputStream in = new BufferedInputStream(new FileInputStream(file));
		ZipInputStream zin = new ZipInputStream(in);
		ZipEntry ze; 
		while ((ze = zin.getNextEntry()) != null) {
			long size = ze.getSize();
			logger.error("size:"+size);
			if (size > 0) {
				BufferedReader br = new BufferedReader(
						new InputStreamReader(zfile.getInputStream(ze),"UTF-8"));
				String tempStr;
				while ((tempStr = br.readLine()) != null) {
					logger.error("tempStr:"+tempStr);
					if (tempStr.contains("|schedus")
							|| tempStr.contains("|mails")
							|| tempStr.contains("|meetting")
							|| tempStr.contains("|ding")
							|| tempStr.contains("|wf|")
							|| tempStr.contains("FW:SyncMsg")) {
						continue;
					}
					//logger.error("tempStr:"+tempStr);
					lineMsgs.add(tempStr);
				}
				br.close();
			}
		}
		
		for(String str: lineMsgs){
			if(str != null){
				str = str.substring(str.indexOf("{"));
				if(str.equals("{}")) break;
				Map<String, String> map = parseJSON2Map(str);
				msgRecords.add(map);
			}
		}
		logger.error("lineMsgs:"+lineMsgs.size());
		zin.close();
		in.close();
		zfile.close();
		return msgRecords;
	}
	else{
		return null;
	}
	
}
	
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