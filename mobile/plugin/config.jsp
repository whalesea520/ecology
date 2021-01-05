
<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@page import="weaver.conn.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN" %>
<%@page import="weaver.file.Prop" %>
<%
	Map<String, String> result = new HashMap<String, String>();
	int hideWfSignuture = Util.getIntValue(Prop.getPropValue("Mobile","hideWfSignuture"),0);
	result.put("workflowview", "1");
	
	//获取EMessage服务器地址
	RecordSet rs = new RecordSet();
	rs.executeSql("select 1 from ofProperty where name='weixin'");
	if(rs.next()){
		rs.executeSql("select propValue from ofProperty where name='xmpp.domain'");
		if(rs.next()){
			String ip = rs.getString("propValue");
			result.put("emessageServer", ip+"|true");
		}
	}
	
	result.put("newschedule", "1");
	//获取人力资源浏览优先显示项：0--所有人；1--常用组；2--组织架构
	rs.executeSql("select propValue from mobileProperty where name='hrmbtnshow'");
	if(rs.next()){
		result.put("hrmbtnshow", Util.getIntValue(rs.getString("propValue"), 1)+"");
	}

	rs.executeSql("select propValue from mobileProperty where name='androidsign'");
	if(rs.next()){
		result.put("androidsign", Util.getIntValue(rs.getString("propValue"), 1)+"");
	}
	rs.executeSql("select propValue from mobileProperty where name='iossign'");
	if(rs.next()){
		result.put("iossign", Util.getIntValue(rs.getString("propValue"), 1)+"");
	}
	rs.executeSql("select propValue from mobileProperty where name='ioskey'");
	if(rs.next()){
		result.put("ioskey", rs.getString("propValue"));
	}

	rs.executeSql("select propValue from mobileProperty where name='androidkey'");
	if(rs.next()){
		result.put("androidkey", rs.getString("propValue"));
	}
	rs.executeSql("select propValue from mobileProperty where name='iosWpskey'");
	if(rs.next()){
		result.put("iosWpskey", rs.getString("propValue"));
	}

	rs.executeSql("select propValue from mobileProperty where name='encryptpassword'");
	if(rs.next()){
		result.put("encryptpassword", rs.getString("propValue"));
	}

	LN ln=new LN();
	String cid=ln.getCid();
	
	result.put("cid",cid);

	result.put("newdoc", "1");
	result.put("workflowadsearch", "1");
	result.put("editavatar", "1");
	result.put("newdocreply","1");
	result.put("moreaccount","1");
	result.put("favourite","1");
	result.put("hideWfSignuture",""+hideWfSignuture);
    result.put("changePassword","1");
	result.put("opennetworkdisp","1");
	result.put("hasBroadCast", "1");
	result.put("webdoc", "1");
	result.put("groupchatvote", "1");
	result.put("isCanChangeUserInfo", "1");
	//获取客户端流程消息列表优先显示：0--全部；1--未处理；
	rs.executeSql("select propValue from mobileProperty where name='UntreatedFirst'");
	if(rs.next()){
		result.put("UntreatedFirst", Util.getIntValue(rs.getString("propValue"), 0)+"");
	}
	//获取是否开启CA认证开关以及ca服务地址和认证方式
	result.put("isUsingCA", "0");//默认不使用CA认证
	rs.executeSql("select name,propvalue from mobileProperty where name='isUsingCA' or name='caServerAddress' or name='caUsageMode'");
	while(rs.next()){
		String name = rs.getString("name");
		String propValue = rs.getString("propValue");
		if(name.equals("isUsingCA")){
			result.put("isUsingCA", Util.getIntValue(propValue, 0)+"");
		}else if(name.equals("caServerAddress")){
			result.put("caServerAddress", propValue);
		}else if(name.equals("caUsageMode")){
			result.put("caUsageMode", Util.getIntValue(propValue, 0)+"");
		}
	}

	if(result!=null) {
		JSONObject jo = JSONObject.fromObject(result);
		//System.out.println(jo);
		out.println(jo.toString());
	}
%>
