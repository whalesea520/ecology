<%@page language="java" contentType="text/html;charset=UTF-8"%> 
<%@page import="weaver.formmode.exttools.impexp.common.StringUtils" %>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ExpDataService" %>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ImpDataService"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.file.FileManage"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.ProgressStatus"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.formmode.exttools.impexp.exp.service.OperateThread"%>
<%@page import="weaver.formmode.exttools.impexp.common.FileUtils"%>
<%@page import="java.util.*"%>
<%@page import="ln.LN" %>
<%
String type = StringUtils.null2String(request.getParameter("type"));
String id = StringUtils.null2String(request.getParameter("id"));
String pageid="no0000036";
LN ln=new LN();
User user = HrmUserVarify.getUser(request, response);
String sessionid = session.getId();
int userid = user.getUID();
JSONObject jsonObject = new JSONObject();
String version="";
if (ln.getEcologyBigVersion().equals("7")) {
	version="7";
}

if("0".equals(type)){//导出
    ProgressStatus.create(sessionid,pageid,userid,0);
    int ptype = StringUtils.getIntValue(StringUtils.null2String(request.getParameter("ptype")));
    Thread thread = new Thread(new OperateThread(id,userid,sessionid,ptype,pageid));
    thread.start();
    out.print(jsonObject.toString());
    return;
}else if("1".equals(type)){//导入   
    ProgressStatus.create(sessionid,pageid,userid,1);
    String isadd = StringUtils.null2String(request.getParameter("isadd"));
    String ptype = StringUtils.null2String(request.getParameter("ptype"));  
    //System.out.println("--------sessionid:"+sessionid+"---------pageid:"+pageid);
	RecordSet rs = new RecordSet();
    int fileid = 0 ;
    String xmlfilepath="";
        FileUpload fu = new FileUpload(request,false);
        FileManage fm = new FileManage();
        fileid = StringUtils.getIntValue(fu.uploadFiles("filename"),0);
        String filename = "data.zip";
        String sql = "select * from imagefile where imagefileid = "+fileid;
        rs.executeSql(sql);
        String uploadfilepath="",isaesencrypt="",aescode="";
        if(rs.next()){
            uploadfilepath =  rs.getString("filerealpath");
            isaesencrypt = rs.getString("isaesencrypt");
            aescode = rs.getString("aescode");
        }
        String exceptionMsg ="";
        if(!uploadfilepath.equals("")){
            try{
                xmlfilepath = GCONST.getRootPath()+"formmode"+File.separatorChar+"import"+File.separatorChar+filename ;
                File oldfile = new File(xmlfilepath);
                if(oldfile.exists()){
                    oldfile.delete();
                }
                if("1".equals(isaesencrypt)){
                    uploadfilepath = FileUtils.aesDesEncrypt(uploadfilepath,aescode);
                }
                fm.copy(uploadfilepath,xmlfilepath);
            }catch(Exception e){
                exceptionMsg = "读取文件失败!";//读取文件失败!
                //System.out.println(exceptionMsg);
                ProgressStatus.finish(sessionid,pageid);
            }
        } 
    
    boolean add = "1".equals(isadd)?true:false;
    //System.out.println("id"+id);
    //System.out.println("userid"+userid);
    //System.out.println("xmlfilepath"+xmlfilepath);
    //System.out.println("fileid"+fileid);
    //System.out.println("sessionid"+sessionid);
    //System.out.println("add"+add); 
    Thread thread = new Thread(new OperateThread(id,userid,xmlfilepath,fileid,sessionid,add,version,pageid));
    thread.start();
    out.print(jsonObject.toString());
    
}else if("2".equals(type)){//查看导入/导出日志明细
    int logid = StringUtils.getIntValue(request.getParameter("logid"));
    //System.out.println("logid="+logid);
    String sql = "select * from mode_impexp_logdetail where logid='"+logid+"' order by id";
    RecordSet rs = new RecordSet();
    rs.executeSql(sql);
    String str = "";
    int i = 1;
    while(rs.next()){
        String message = StringUtils.null2String(rs.getString("message"));
        str += (i++)+":"+message+"\n";
    }
    out.clear();
    out.print(str);
    return;
}else if("3".equals(type)){//获取导入导出进度
    jsonObject.put("inprocess",false);
    Map<String,Object> progressStatusMap = ProgressStatus.get(sessionid,pageid);
    //System.out.println("--------sessionid:"+sessionid+"---------pageid:"+pageid);
	if(progressStatusMap!=null){
        int persent = ProgressStatus.getCurrentProgressPersent(sessionid,pageid);
        int ptype = ProgressStatus.getPtype(sessionid,pageid);
        String logid = ProgressStatus.getLogid(sessionid,pageid);
        jsonObject.put("inprocess",true);
        jsonObject.put("process",persent);
        jsonObject.put("ptype",ptype);
        jsonObject.put("logid",logid);
        jsonObject.put("error",progressStatusMap.get("error"));
        if(progressStatusMap.containsKey("datatype")){
            if("app".equals(StringUtils.null2String(progressStatusMap.get("datatype")))){
                jsonObject.put("datatype","应用");
            }else if("mode".equals(StringUtils.null2String(progressStatusMap.get("datatype")))){
                jsonObject.put("datatype","模块");
            }
        }
        String fileid = StringUtils.null2String(progressStatusMap.get("fileid"));
        if(!"".equals(fileid)){
            jsonObject.put("fileid",fileid);
        }
    }
    out.print(jsonObject.toString());
}else if("4".equals(type)){
    ProgressStatus.finish(sessionid,pageid);
    return;
}
%>