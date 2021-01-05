<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Random"%>
<%@page import="weaver.common.MessageUtil"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
/***
 * 随机数密码
 * @param n
 * @return
 */
public static String random(int n) {
  Random ran = new Random();
  if (n == 1) {
      return String.valueOf(ran.nextInt(10));
  }
  int bitField = 0;
  char[] chs = new char[n];
  for (int i = 0; i < n; i++) {
      while(true) {
          int k = ran.nextInt(10);
          if( (bitField & (1 << k)) == 0) {
              bitField |= 1 << k;
              chs[i] = (char)(k + '0');
              break;
          }
      }
  }
  return new String(chs);
}
%>
<%

String id = Util.null2String(request.getParameter("id"));
String language = Util.null2String(request.getParameter("language"));
String type = Util.null2String(request.getParameter("type"));
String method = Util.null2String(request.getParameter("method"));
String reUrl = request.getRequestURL().toString();


String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/RdResourceOptAjax.jsp"))+"/rdeploy/hrm/RdMobileLogin.jsp?uid="+id;
if(method.equals("sendMsg")){
   try{
String password_tmp = Util.null2String(request.getParameter("pwd"));
       
    rs.executeSql("select sendtime from rdeployhrmsendmsg where resourceid =  "+id);
    if(rs.next()){
        String sendtime = rs.getString(1);
        Calendar calendar = Calendar.getInstance();
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        calendar.setTime(format.parse(sendtime));
        long a =System.currentTimeMillis()-calendar.getTime().getTime();
        //System.out.println("时间差："+a);
        if(a<1000*60*30){
            out.println("{\"result\":false,\"reason\":\"1\"}"); 
    	    return;
        }
    }
       
	String mobile = ResourceComInfo.getMobile(id);
	
	//System.out.println("短信通知id。。。"+id);
	
	//发送短信
	String content = Util.null2String(request.getParameter("content"));
	//System.out.println("短信通知。。。"+content);
	MessageUtil.sendSMS(mobile,content);
	
	
	rs.executeSql("select sendtime from rdeployhrmsendmsg where resourceid =  "+id);
	
		Calendar calendar = Calendar.getInstance();
		DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String thisTime = format.format(calendar.getTime());
		if(rs.next()){
		    rs.executeSql("update rdeployhrmsendmsg set sendtime = '"+thisTime+"' where resourceid =  "+id);
		}else{
		    rs.executeSql("insert into rdeployhrmsendmsg(resourceid,sendtime) values("+id+",'"+thisTime+"')");
		}
	}catch(Exception e){
	    out.println("{\"result\":false,\"reason\":\"0\"}"); 
	    return;
	}
	out.println("{\"result\":true}");
}
if(method.equals("freeze")){
    if("2".equals(type)){
        String status = ResourceComInfo.getStatus(id);
        if("7".equals(status)){
            out.print("{\"result\":true}");
            return ;
        }
        String sql = " UPDATE HrmResource SET beforefrozen=status,status='7'  WHERE id = "+id;
        boolean result = rs.executeSql(sql);
        ResourceComInfo.updateResourceInfoCache(id);
        out.print("{\"result\":"+result+"}");
    }else{
        String[] idsArray = id.split(",");
        String idStr = "";
        for(int i =0;i<idsArray.length;i++){
            if(!"".equals(idsArray[i].trim())){
    	         String status = ResourceComInfo.getStatus(idsArray[i]);
    	         if("7".equals(status)){
    	             continue;
    	         }
    	         if(i>0){
    	         idStr+=",";
    	         }
    	         idStr+=idsArray[i];
            }
        }
        if("".equals(idStr)){
            out.print("{\"result\":true}");
            return;
        }
        String sql = " UPDATE HrmResource SET beforefrozen=status,status='7'  WHERE id in("+idStr+")";
        boolean result = rs.executeSql(sql);
        String[] needUpdateIds = idStr.split(",");
        for(int i =0;i<needUpdateIds.length;i++){
    	    ResourceComInfo.updateResourceInfoCache(needUpdateIds[i]);
        }
        out.print("{\"result\":"+result+"}");
    }
}

if(method.equals("unfreeze")){
    if("2".equals(type)){
        String status = ResourceComInfo.getStatus(id);
        if(!"7".equals(status)){
            out.print("{\"result\":true}");
            return ;
        }
        String sql = " UPDATE HrmResource SET status=beforefrozen,beforefrozen=null  WHERE id = "+id;
        boolean result = rs.executeSql(sql);
        ResourceComInfo.updateResourceInfoCache(id);
        out.print("{\"result\":"+result+"}");
    }else{
        String[] idsArray = id.split(",");
        String idStr = "";
        for(int i =0;i<idsArray.length;i++){
            if(!"".equals(idsArray[i].trim())){
    	         String status = ResourceComInfo.getStatus(idsArray[i]);
    	         if(!"7".equals(status)){
    	             continue;
    	         }
    	         if(i>0){
    	         idStr+=",";
    	         }
    	         idStr+=idsArray[i];
            }
        }
        if("".equals(idStr)){
            out.print("{\"result\":true}");
            return;
        }
        String sql = " UPDATE HrmResource SET status=beforefrozen,beforefrozen=null  WHERE id in("+idStr+")";
        boolean result = rs.executeSql(sql);
        String[] needUpdateIds = idStr.split(",");
        for(int i =0;i<needUpdateIds.length;i++){
    	    ResourceComInfo.updateResourceInfoCache(needUpdateIds[i]);
        }
        out.print("{\"result\":"+result+"}");
    }
}

if(method.equals("clearOpt")){
    String[] idsArray = id.split(",");
    String idStr = "";
    for(int i =0;i<idsArray.length;i++){
        if(!"".equals(idsArray[i].trim())){
	         if(i>0){
	         idStr+=",";
	         }
	         idStr+=idsArray[i];
        }
    }
    boolean result = rs.executeSql(" update HrmResource set isnewuser = null  where id in( "+idStr+")");
    out.print("{\"result\":"+result+"}");    
}

if(method.equals("deleteOpt")){
    if("2".equals(type)){
        String sql = " delete from HrmResource where  id = "+id;
        boolean result = rs.executeSql(sql);
        ResourceComInfo.deleteResourceInfoCache(id);
        out.print("{\"result\":"+result+"}");
    }else{
        String[] idsArray = id.split(",");
        String idStr = "";
        for(int i =0;i<idsArray.length;i++){
            if(!"".equals(idsArray[i].trim())){
    	         if(i>0){
    	         idStr+=",";
    	         }
    	         idStr+=idsArray[i];
            }
        }
        if("".equals(idStr)){
            out.print("{\"result\":true}");
            return;
        }
        String sql = " delete from HrmResource where  id in("+idStr+")";
        boolean result = rs.executeSql(sql);
        String[] needUpdateIds = idStr.split(",");
        for(int i =0;i<needUpdateIds.length;i++){
    	    ResourceComInfo.deleteResourceInfoCache(needUpdateIds[i]);
        }
        out.print("{\"result\":"+result+"}");
    }
}

if(method.equals("passOpt")){
    String comname = CompanyComInfo.getCompanyname("1");
    User user = HrmUserVarify.getUser (request , response) ;
    int languageid = user.getLanguage();
    if("2".equals(type)){
      	//设置密码
        String password_tmp =random(4);
        String password = Util.getEncrypt(password_tmp);
        String sql = "update HrmResource set isnewuser = null,status = '1',PASSWORD = '"+password+"'  where  id = "+id;
        boolean result = rs.executeSql(sql);
        out.print("{\"result\":"+result+"}");
        String content = SystemEnv.getHtmlLabelName(125167 ,languageid)+""+comname+SystemEnv.getHtmlLabelName(125168 ,languageid)+ResourceComInfo.getLoginID(id)+SystemEnv.getHtmlLabelName(125169  ,languageid)
						+password_tmp+SystemEnv.getHtmlLabelName(125170 ,languageid)+invUrl;
    	String mobile = ResourceComInfo.getMobile(id);
    	// rs.executeSql("select resourcefrom from HrmResource where id = "+id);
       // if(rs.next()){
         //   String resourcefrom = rs.getString(1);
         //   if("DD".equals(resourcefrom)){
         //       String password_tmp =random(4);
        ////    	String password = Util.getEncrypt(password_tmp);
        //    	rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+id);
        //        content = "管理员已通过您的申请，请马上登陆系统。用户名为："+mobile+"，密码为："+password_tmp;
        //    }
       // }
       	ResourceComInfo.updateResourceInfoCache(id);
        //发送短信
    	MessageUtil.sendSMS(mobile,content);
    }else{
        String[] idsArray = id.split(",");
        String idStr = "";
        for(int i =0;i<idsArray.length;i++){
            if(!"".equals(idsArray[i].trim())){
    	         if(i>0){
    	         idStr+=",";
    	         }
    	         idStr+=idsArray[i];
            }
        }
        if("".equals(idStr)){
            out.print("{\"result\":true}");
            return;
        }
        String sql = "update HrmResource set isnewuser = null,status = '1'  where  id in("+idStr+")";
        boolean result = rs.executeSql(sql);
        out.print("{\"result\":"+result+"}");
        String[] needUpdateIds = idStr.split(",");
        
        for(int i =0;i<needUpdateIds.length;i++){
          //设置密码
            String password_tmp =random(4);
            String password = Util.getEncrypt(password_tmp);

            rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+needUpdateIds[i]);
            
            String content = SystemEnv.getHtmlLabelName(125167 ,languageid)+""+comname+SystemEnv.getHtmlLabelName(125168 ,languageid)+ResourceComInfo.getLoginID(needUpdateIds[i])+SystemEnv.getHtmlLabelName(125169  ,languageid)
    						+password_tmp+SystemEnv.getHtmlLabelName(125170 ,languageid)+invUrl;
            
        	String mobile = ResourceComInfo.getMobile(needUpdateIds[i]);
    	  	//发送短信
           // rs.executeSql("select resourcefrom from HrmResource where id = "+id);
           // if(rs.next()){
           //     String resourcefrom = rs.getString(1);
           //     if("DD".equals(resourcefrom)){
           //         String password_tmp =random(4);
           //     	String password = Util.getEncrypt(password_tmp);
           //     	rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+id);
            //        content = "管理员已通过您的申请，请马上登陆系统。用户名为："+mobile+"，密码为："+password_tmp;
            //    }
            //}
        	MessageUtil.sendSMS(mobile,content);
    	    ResourceComInfo.updateResourceInfoCache(needUpdateIds[i]);
        }
        
    }
}

if(method.equals("refuse")){
        String comname = CompanyComInfo.getCompanyname("1");
        User user = HrmUserVarify.getUser (request , response) ;
        int languageid = user.getLanguage();
    if("2".equals(type)){
        String sql = " delete from HrmResource where  id = "+id;
        boolean result = rs.executeSql(sql);
        out.print("{\"result\":"+result+"}");
        String content = SystemEnv.getHtmlLabelName(125167 ,languageid)+comname+SystemEnv.getHtmlLabelName(125171  ,languageid);
        String mobile = ResourceComInfo.getMobile(id);
        MessageUtil.sendSMS(mobile,content);
        ResourceComInfo.deleteResourceInfoCache(id);
        
    }else{
        String[] idsArray = id.split(",");
        String idStr = "";
        for(int i =0;i<idsArray.length;i++){
            if(!"".equals(idsArray[i].trim())){
    	         if(i>0){
    	         idStr+=",";
    	         }
    	         idStr+=idsArray[i];
            }
        }
        if("".equals(idStr)){
            out.print("{\"result\":true}");
            return;
        }
        String sql = " delete from HrmResource where  id in("+idStr+")";
        boolean result = rs.executeSql(sql);
        String[] needUpdateIds = idStr.split(",");
        String content = SystemEnv.getHtmlLabelName(125167 ,languageid)+comname+SystemEnv.getHtmlLabelName(125171  ,languageid);
        for(int i =0;i<needUpdateIds.length;i++){
            String mobile = ResourceComInfo.getMobile(needUpdateIds[i]);
            MessageUtil.sendSMS(mobile,content);
    	    ResourceComInfo.deleteResourceInfoCache(needUpdateIds[i]);
        }
        out.print("{\"result\":"+result+"}");
    }
}

if(method.equals("sendMoileCode")){
    User user = HrmUserVarify.getUser (request , response) ;
    int languageid = user.getLanguage();
	String mobile = Util.null2String(request.getParameter("loginid"));
	String resourceid = "";
	String sql = " select id from hrmresource where mobile = '"+mobile+"' ";
	rs.executeSql(sql);
	if(rs.next()){
		resourceid = rs.getString("id");
	}else{
		 out.println("{\"result\":\"-1\"}");
		 return;
	}

	if(resourceid.length()>0){
	 String sendcode = random(4);
	 sql = " insert into HrmLoginByCode(resourceid,mobile,sendcode) values ('"+resourceid+"','"+mobile+"','"+sendcode+"')";
   rs.executeSql(sql);
	 String content = SystemEnv.getHtmlLabelName(125175 ,languageid)+sendcode+SystemEnv.getHtmlLabelName(125176 ,languageid);
	 MessageUtil.sendSMS(mobile,content);
	 out.println("{\"result\":\"1\"}");
	}
}
%>
