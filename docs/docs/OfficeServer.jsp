<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.docs.docs.*" %>
<%@ page import="java.lang.reflect.Field" %>
<%@ page import="DBstep.iMsgServer2000" %>

<%!

    public void checkSecurity(Object obj){


		String fixFlag = new weaver.general.BaseBean().getPropValue("weaver_officeserver_fix_20200618","isFix");
		if(fixFlag!=null && "1".equals(fixFlag)){
			return;
		}

        Class cls = obj.getClass().getSuperclass();

        Field[] fields = cls.getDeclaredFields();
        DocInfo docInfo = null;
        iMsgServer2000 msgObj = null;
        for (int i=0;i<fields.length;i++){
            try {

                Field field = fields[i];

                field.setAccessible(true);

                String name = field.getName();
                if(name.equals("docInfo")){
                    docInfo = (DocInfo)field.get(obj);
                }else if(name.equals("msgObj")){
                    msgObj = (iMsgServer2000)field.get(obj);
                }
            } catch (IllegalAccessException e) {
                new weaver.general.BaseBean().writeLog(e);
            }
        }
        if(docInfo!=null && msgObj!=null){
            String option = msgObj.GetMsgByName("OPTION") ;
            if(option!=null && option.equalsIgnoreCase("SAVEASHTML")) {
                //delete upload file
                String path = docInfo.getFilePath() + File.separatorChar + docInfo.getHtmlName() ;
                File file = new File(path);
				
                if(file.exists()){
                    try {
                        file.setExecutable(false);
                    }catch(Exception e){}
					try{
						long currentTime = new Date().getTime();
						long lastModifiedTime = file.lastModified();
						if(currentTime - lastModifiedTime<=60*1000){
							String fileName = file.getName();
							if(fileName == null || "".equals(fileName.trim())){
								file.delete();
							}else if(fileName != null && fileName.length()>=100){
								file.delete();
							}else{
								file.renameTo(new File(file.getParent() + File.separatorChar +fileName+"."+System.nanoTime()+".bak"));
							}
						}
					}catch(Exception e){}
                }
            }
        }
    }
%>


<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
DocServer dos  = null;
try{
    //DocOfficeServer dos = new DocOfficeServer(request,response);
    dos = new DocDbServer(request,response);
    out.clear() ;
    dos.doCommand();
}catch(Exception ex){
    throw ex;
}finally{
    if(dos!=null){
        checkSecurity(dos);
    }
}
%>