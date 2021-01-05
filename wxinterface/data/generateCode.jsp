<%@ page language="java" import="java.util.*,weaver.general.RadomNumUtil" pageEncoding="utf-8"%>
<%@ page import="weaver.sms.*"  %>
<%@ page import="java.io.*"  %>
<%@ page import="weaver.general.GCONST"  %> 
<%@ page import="weaver.general.Util"  %>
<%@ page import="weaver.general.TimeUtil"  %>
<%@ page import="weaver.file.Prop"  %>
<jsp:useBean id="sendShortMsg" class="weaver.crm.shortMessages.SendShortMsg" scope="page"/>
<%
Map<String,String> codeInfo = new HashMap<String,String>();
response.setContentType("text/plain;charset=utf-8");
SMSManager smsManager = new SMSManager();
String phoneNum = request.getParameter("phonenum");
String jsonp=request.getParameter("jsonpcallback"); 
//服务微信集成服务
String msgtype=request.getParameter("msgtype"); 
if(null != phoneNum ){
	try{
		Map<String,String> codeInfo = RadomNumUtil.getCodeInfo(phoneNum);
		if(codeInfo!=null){
			long gtime = Long.parseLong(codeInfo.get("gtime"));
      long currentTime = new Date().getTime();
      if((currentTime - gtime)/(60*1000) <= 1){//防止1分钟内重复发送
      	out.println(jsonp+"({\"result\":\"0\"})");
      	return;
      }
		}
	
	  //生成4位随机动态验证码
	  String code = RadomNumUtil.createRandom(true,4);
	  //创建日期
	  codeInfo.put("gtime",new Date().getTime()+"");
	  codeInfo.put("code",code);
	  //将信息存储到session
	  //session.setAttribute("codeinfo",codeInfo);
	  RadomNumUtil.addCodeinfo(phoneNum,codeInfo);
	  String msg = "尊敬的用户，欢迎您体验泛微e-cology产品。您的验证码是:"+code+"，请即时输入，将在一分钟内有效！";
	  if(!"".equals(msgtype) && "1".equals(msgtype)){
		  msg = "尊敬的用户，欢迎您体验微信集成应用。您的验证码是:"+code+"，请即时输入，将在一分钟内有效！";
	  }
	  if(!"".equals(msgtype) && "2".equals(msgtype)){
		  msg = "尊敬的用户，欢迎您体验泛微e-office产品。您的验证码是:"+code+"，请即时输入，将在一分钟内有效！";
	  }
	  if(!"".equals(msgtype) && "5".equals(msgtype)){
		  msg = "尊敬的用户，欢迎您体验泛微移动应用。您的验证码是:"+code+"，请即时输入，将在一分钟内有效！";
	  }
	  if(!"".equals(msgtype) && "4".equals(msgtype)){// eoffice
		  msg = Util.null2String(request.getParameter("msgcontent")); 
	  }
	  //发送短信
	  boolean issuccess = false;
	  if(!"".equals(msg)){
	  	
		  issuccess = "success".equals(sendShortMsg.send(phoneNum,msg));
	  	
	  	//msg = "【泛微网络】"+ msg;
	  	//issuccess = smsManager.sendSMS(phoneNum, msg);
	  }
	  
	  //验证码生成成功
	  if(issuccess){
			updateProp();//记录调用次数
	    out.println(jsonp+"({\"result\":\"1\"})");
	  }else
	    out.println(jsonp+"({\"result\":\"0\"})");
	}catch(Exception e){
	  //验证码生成失败
	  out.println(jsonp+"({\"result\":\"0\"})");
}
}else{
	  //验证码生成失败
	  out.println(jsonp+"({\"result\":\"0\"})");
}

%>
<%!
public static boolean updateProp(){
	String propfile = "applysmsrecord";
	
	String ym = TimeUtil.getCurrentDateString().substring(0,7);
	int amount = Util.getIntValue(Prop.getPropValue(propfile, ym),0);
	amount++;
	
	//获取绝对路径  
	String filepath = GCONST.getPropertyPath()+propfile+".properties";
    Properties prop = new Properties();  
    
    InputStream fis = null;
    OutputStream fos = null;
    try {  
        File file = new File(filepath);  
        if (!file.exists())  
            file.createNewFile();  
        fis = new FileInputStream(file);  
        prop.load(fis);  
        //一定要在修改值之前关闭fis  
        fis.close();  
        fos = new FileOutputStream(filepath);  
        
        prop.setProperty(ym, amount+"");  
        
        //保存，并加入注释  
        prop.store(fos,"");  
        
    } catch (IOException e) {  
    	return false; 
    } finally{
    	if(fos!=null){
    		try {
				fos.close();
			} catch (IOException e) {
			} 
    	}
    }
    
    return true;
}
%>

