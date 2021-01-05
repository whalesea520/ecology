<%@ page language="java" contentType="application/json" pageEncoding="UTF-8"%>
<%@page import="net.sf.json.*"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.docs.networkdisk.server.NetWorkDiskFileOperateServer"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.OutputStreamWriter"%>
<%!
	private static String getImgSrc(String content){
		String rootPath=GCONST.getRootPath();
	    Map<String,String> map=new HashMap<String,String>();
	    //目前img标签标示有3种表达式
	    //<img alt="" src="1.jpg"/>   <img alt="" src="1.jpg"></img>     <img alt="" src="1.jpg">
	    //开始匹配content中的<img />标签
	    Pattern p_img = Pattern.compile("<(img|IMG)(.*?)(/>|></img>|>)");
	    Matcher m_img = p_img.matcher(content);
	    boolean result_img = m_img.find();
	    StringBuffer sb = new StringBuffer();
	    InputStream in = null;
	    if (result_img) {
	        while (result_img) {
	            //获取到匹配的<img />标签中的内容
	            String str_img = m_img.group(2);
	             
	            //开始匹配<img />标签中的src
	            Pattern p_src = Pattern.compile("(src|SRC)=(\"|\')(.*?)(\"|\')");
	            Matcher m_src = p_src.matcher(str_img);
	            StringBuffer srcReplace = new StringBuffer("<img ");
	            if (m_src.find()) {
	                String str_src = m_src.group(3);
	                String src_base64="";
	                if(map.containsKey(str_src)){
	                	src_base64=map.get(str_src);
	                }else{
	                	if(!"".equals(str_src)){
		                	if(str_src.startsWith("/")){
		                		if(str_src.startsWith("/weaver/weaver.file.FileDownload")){//上传文件.数据库读取转化
		                			String str_temp=str_src.replace("/weaver/weaver.file.FileDownload?fileid=","");
		                			src_base64=weaver.docs.networkdisk.tools.ImageFileUtil.getImageFileForBase64(str_temp);
		                		}else{
				                	File file=new File(rootPath+str_src);
				                	if(file.exists()){
				                		try{
					                		in = new FileInputStream(file);
					                		src_base64=ImageUtil.zoomImage(in,2000,2000,false);
					                		if(src_base64!=null){
					                			map.put(str_src,src_base64);
					                		}
				                		}catch(Exception e){}
				                	}
		                		}
		                	}
	                	}
	                }
	                if(!"".equals(src_base64)){//可以转base64的图片
		                m_src.appendReplacement(srcReplace,"src=\"data:image/png;base64,"+src_base64+"\"");
	                }else{
	                	m_src.appendReplacement(srcReplace,"src=\""+str_src+"\"");
	                }
	            }
	            //结束匹配<img />标签中的src
	            m_src.appendTail(srcReplace);
	            srcReplace.append("/>");
	            m_img.appendReplacement(sb,srcReplace.toString());
	            
	            //匹配content中是否存在下一个<img />标签，有则继续以上步骤匹配<img />标签中的src
	            result_img = m_img.find();
	        }
            m_img.appendTail(sb);
	    }
	    return sb.toString();
	}

	private String readCss(String cssFile) {  
		StringBuffer sb = new StringBuffer();
		String rootPath=GCONST.getRootPath();
		File file=new File(rootPath+cssFile);
    	if(file.exists()){
    		try{
	    		BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
				String str = null;
				while ((str = bufferedReader.readLine()) != null) {
					sb.append(str).append("\n");
	
				}
    		}catch(Exception e){}
    	}
		return sb.toString();
	}
%>
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}

Map result = new HashMap();
int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

response.setContentType("application/json;charset=UTF-8");

FileUpload fu = new FileUpload(request);

String content = Util.null2String(fu.getParameter("content"));
String timestamp = Util.null2String(fu.getParameter("timestamp"));
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String width = Util.null2String(fu.getParameter("width"));//页面宽度
String style = Util.null2String(fu.getParameter("style"));//样式
width="".equals(width)?"640":width;
String bgcolor="#F1F2F6";
if("blue/".equals(style)){
	bgcolor="#053E73";
}
String currenttime=TimeUtil.getFormartString(Calendar.getInstance().getTime(),"yyyyMMddHHmmss");

if(!"".equals(content)&&!"".equals(timestamp)){
	content=URLDecoder.decode(content,"UTF-8");
	String str="<!DOCTYPE html>"+
				"<html>"+
				"<head>"+
				"<meta charset=\"UTF-8\">"+
				"<meta name=\"viewport\" content=\"width=device-width,height=device-height, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\" />"+
				"<title>小e助手聊天记录</title>"+
				"<style>"+
				readCss("/wechat/css/jquery.mobile-1.1.1.min_wev8.css")+
				readCss("/mobile/plugin/fullsearch/css/"+style+"voice_wev8.css")+
				"	.result-ul{ display:none;}"+
				"	.result-current-ul{ display:block;}"+
				"	#main{ background-color: #d5d7df;}"+
				"</style>"+
				"</head>"+
				"<body class=\"ui-mobile-viewport ui-overlay-c\">"+
				"	<div data-role=\"page\" id=\"main\" data-url=\"main\" tabindex=\"0\" class=\"ui-page ui-body-c ui-page-active\" style=\"display: block;\">"+
				"	    <div id=\"contentDiv\" class=\"contentDiv\" data-role=\"content\" class=\"ui-content\" role=\"main\" style=\"text-align: center;width: "+width+"px;margin: auto;background-color: "+bgcolor+";padding-bottom: 30px;\" >"+
				getImgSrc(content)+
				"	    </div>"+
				"	</div>"+
				"</body>"+
				"<script type=\"text/javascript\">"+
				"function goPage(detailid,schema,url) {}"+
				"function createWF(id){}"+
				"</script>"+
				"</html>";
	//测试保存到本地			
	//File writeFile=new File("E:/test/"+"小e助手聊天记录"+currenttime+".html");
	//BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(
	//	    new FileOutputStream(writeFile), "UTF-8"));
	//writer.write(str);
	//writer.close();
	 
	//System.out.println(str);			
	//生成网盘文件.接口
	int fileid=new NetWorkDiskFileOperateServer().save2html(user,str,"小e助手聊天记录"+currenttime+".html");	
	if(fileid>0){
		result.put("fileid",fileid);
		result.put("filename","小e助手聊天记录"+currenttime+".html");
	}
	result.put("result","success");
}

JSONObject jo = JSONObject.fromObject(result);
out.println(jo.toString());
%>