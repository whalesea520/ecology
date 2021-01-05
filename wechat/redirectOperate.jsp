
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@page import="java.util.*,weaver.wechat.request.QueryAction,weaver.wechat.util.*,java.net.*,com.alibaba.fastjson.JSONObject"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//必须通过微信授权页面过来才有效
String code=request.getParameter("code");
String publicid=request.getParameter("publicid");
String mode=request.getParameter("mode");
String params=request.getParameter("params");
String state=request.getParameter("state");
QueryAction qa=new QueryAction();
String queryopenid=qa.queryBandOpendId(publicid,code);
if("1".equals(state)){//系统模块发送提醒
	String openid=request.getParameter("openid");
	String userid=request.getParameter("userid");
	if(!"".equals(queryopenid)&&queryopenid.equals(openid)){
		//此时生成token
		String token=WechatUtil.createToken(userid,publicid,openid);
		//获取用户登录id
		String loginid=ResourceComInfo.getLoginID(userid);
		//获取手机web地址
		String mobileurl=WechatPropConfig.getMobileUrl();
		//模块查看地址
		String modeurl=WechatPropConfig.getModeUrl(mode);
		if(!"".equals(modeurl)){
			params=URLDecoder.decode(params,"UTF-8");
			JSONObject json=JSONObject.parseObject(params);
			Iterator<String> it=json.keySet().iterator();
			while(it.hasNext()){
				String key=it.next();
				if(modeurl.indexOf("{"+key+"}")>-1){
					modeurl=modeurl.replace("{"+key+"}",json.getString(key));
				}
			}
			modeurl=URLEncoder.encode(modeurl,"UTF-8");
			response.sendRedirect(mobileurl+"/weixin.jsp?loginid="+URLEncoder.encode(loginid,"UTF-8")+"&password="+token+"&tokenpass=_wechat&target="+modeurl);
		}else{
			response.sendRedirect("result.jsp?type=param&msg=nomodeurl");
	    	return;
		}
	}else{
		response.sendRedirect("result.jsp?type=param&msg=invalid");
	    return;
	}
}else if("qr".equals(state)){//二维码扫描
	if(!"".equals(queryopenid)){
		//查看openid 是否绑定
		rs.execute("select userid from wechat_band where publicid='"+publicid+"' and openid='"+queryopenid+"'");
		if(rs.next()){
			String userid=rs.getString("userid");
			//此时生成token
			String token=WechatUtil.createToken(userid,publicid,queryopenid);
			//获取用户登录id
			String loginid=ResourceComInfo.getLoginID(userid);
			//获取手机web地址
			String mobileurl=WechatPropConfig.getMobileUrl();
			//模块自定义查看地址
			String modeurl=WechatPropConfig.getCustomUrl(mode);
			if(!"".equals(modeurl)&&!"".equals(mobileurl)){
				params=URLDecoder.decode(params,"UTF-8");
				JSONObject json=JSONObject.parseObject(params);
				Iterator<String> it=json.keySet().iterator();
				while(it.hasNext()){
					String key=it.next();
					if(modeurl.indexOf("{"+key+"}")>-1){
						modeurl=modeurl.replace("{"+key+"}",json.getString(key));
					}
				}
				modeurl=URLEncoder.encode(modeurl,"UTF-8");
				response.sendRedirect(mobileurl+"/weixin.jsp?loginid="+URLEncoder.encode(loginid,"UTF-8")+"&password="+token+"&tokenpass=_wechat&target="+modeurl);
			}else{
				response.sendRedirect("result.jsp?type=param&msg=nomodeurl");
		    	return;
			}
		}else{
			response.sendRedirect("result.jsp?type=user&msg=noband");
	    	return;
		}
	}else{
		response.sendRedirect("result.jsp?type=param&msg=invalid");
	    return;
	}
}else{
	response.sendRedirect("result.jsp?type=param&msg=nosupport");
	return;
}

 %>