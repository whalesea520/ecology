
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.DesUtil"%>	

<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="VersionIdUpdate" class="weaver.docs.docs.VersionIdUpdate" scope="page"/>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />		
<%!
 private String getFileExt(String file) {
        if (file == null || file.trim().equals("")) {
            return "";
        } else {
            int idx = file.lastIndexOf(".");
            if (idx == -1) {
                return "";
            } else {
                if (idx + 1 >= file.length()) {
                    return "";
                } else {
                    return file.substring(idx + 1);
                }
            }
        }
    }
    
	private String getFileType(String fileext){
		String docfiletype="2";
		if (fileext.equalsIgnoreCase("doc")) {
			docfiletype="3";
		} else if (fileext.equalsIgnoreCase("xls")) {
			docfiletype="4";
		} else if (fileext.equalsIgnoreCase("ppt")) {
			docfiletype="5";
		} else if (fileext.equalsIgnoreCase("wps")) {
			docfiletype="6";
		} else if (fileext.equalsIgnoreCase("docx")) {
			docfiletype="7";
		} else if (fileext.equalsIgnoreCase("xlsx")) {
			docfiletype="8";
		} else if (fileext.equalsIgnoreCase("pptx")) {
			docfiletype="9";
		}
		return docfiletype;
	}
	
	private String getFileType2(String docfiletype){
		if("7".equals(docfiletype)){
			docfiletype="3";
		}
		if("8".equals(docfiletype)){
			docfiletype="4";
		}
		if("9".equals(docfiletype)){
			docfiletype="5";
		}
		return docfiletype;
	}    
%>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	User user = HrmUserVarify.getUser (request , response) ;
	
	FileUpload fu = new FileUpload(request,"utf-8");
	String operation=Util.null2String(fu.getParameter("operation"));
	int oldVersionId=Util.getIntValue(fu.getParameter("versionId"));
	int oldImagefileId=Util.getIntValue(fu.getParameter("imagefileId"));
	
	int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
	int docid=Util.getIntValue(fu.getParameter("docid"));
	
	int newVersionId=VersionIdUpdate.getVersionNewId();
	
	if("replacefile".equals(operation)){
		if(imagefileid<=0){
			out.println("empty,0,0,0,0");
			return;
		}
	
		String oldimagefilename="";
		rs.executeSql("select imagefilename from DocImageFile where docid="+docid+" and versionId="+oldVersionId+" and isextfile=1 order by id desc");
		if(rs.next()){
			oldimagefilename=Util.null2String(rs.getString("imagefilename"));	
		}
		String oldfileext=getFileExt(oldimagefilename);
		boolean oldisExt=Util.isExt(oldfileext);
		String olddocfiletype=getFileType(oldfileext);
		String olddocfiletype2=getFileType2(olddocfiletype);
		
		String imagefilename="";
		rs.executeSql("select imagefilename from imagefile where imagefileid="+imagefileid);
		if(rs.next()){
			imagefilename=Util.null2String(rs.getString(1));
		}
		String fileext=getFileExt(imagefilename);
		boolean isExt=Util.isExt(fileext);
		String docfiletype=getFileType(fileext);
		String docfiletype2=getFileType2(docfiletype);
		
		if(docfiletype2.equals(olddocfiletype2)){
			rs.executeSql("insert into DocImageFile(id,docid,imagefileid,imagefilename,imagefiledesc,imagefilewidth,imagefileheight,imagefielsize,docfiletype,versionId,versionDetail,isextfile,hasUsedTemplet) select id,docid,"+imagefileid+",'"+imagefilename+"','',imagefilewidth,imagefileheight,imagefielsize,"+docfiletype+","+newVersionId+",'"+Util.toHtml100(SystemEnv.getHtmlLabelName(33029, user.getLanguage()))+"',isextfile,hasUsedTemplet from DocImageFile where docid="+docid+" and versionId="+oldVersionId+" and isextfile=1");
			
			//更新文档修改时间和最后修改人
			Calendar today = Calendar.getInstance();
			String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
                + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
                + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
			String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
                + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
			rs.executeSql("update docdetail set doclastmoddate='"+formatdate+"',doclastmodtime='"+formattime+"',doclastmoduserid='"+user.getUID()+"',docLastModUserType='"+user.getLogintype()+"' where id="+docid);
			
			DocManager.resetParameter();
			DocManager.setId(docid);
			DocManager.getDocInfoById();
			
			String docCreaterType = DocManager.getDocCreaterType();
			int doccreaterid=DocManager.getDoccreaterid();
		
			 docDetailLog.resetParameter();
			 docDetailLog.setDocId(docid);
			 docDetailLog.setDocSubject(imagefilename);
			 docDetailLog.setOperateType("2");
			 docDetailLog.setOperateUserid(user.getUID());
			 docDetailLog.setUsertype(user.getLogintype());
			 docDetailLog.setClientAddress(request.getRemoteAddr());
			 docDetailLog.setDocCreater(doccreaterid);
			 docDetailLog.setCreatertype(docCreaterType);
			 docDetailLog.setDocLogInfo();
			
			out.println("success,"+docid+","+isExt+","+newVersionId+","+imagefileid);
		} else {
			out.println("error,"+docid+","+oldisExt+","+oldVersionId+","+oldImagefileId);
		}
		
		return;
	}
	
	boolean hasRight = false;
	DesUtil desUtil = new DesUtil();
	String userid = Util.null2String(fu.getParameter("userid"));
	if(!userid.equals("")){
		if(Util.getIntValue(desUtil.decrypt(userid))>0){
			hasRight = true;
		}
	}
	
	if(!hasRight)  return ;
	

	
	//String mode=Util.null2String(fu.getParameter("mode"));

	//System.out.println("imagefileid:"+imagefileid);
	//System.out.println("docid:"+docid);

	 String imgFilename="";
	 rs.executeSql("select imagefilename from imagefile where imagefileid="+imagefileid);
	 if(rs.next()){
		imgFilename=rs.getString(1);
	 }

	

	imgManger.resetParameter();
	imgManger.setDocid(docid);
	imgManger.setImagefileid(imagefileid);
	imgManger.setImagefilename(imgFilename);
	imgManger.setIsextfile("1");
	String ext = getFileExt(imgFilename);
	if (ext.equalsIgnoreCase("doc")) {
		imgManger.setDocfiletype("3");
	} else if (ext.equalsIgnoreCase("xls")) {
		imgManger.setDocfiletype("4");
	} else if (ext.equalsIgnoreCase("ppt")) {
		imgManger.setDocfiletype("5");
	} else if (ext.equalsIgnoreCase("wps")) {
		imgManger.setDocfiletype("6");
	} else if (ext.equalsIgnoreCase("docx")) {
		imgManger.setDocfiletype("7");
	} else if (ext.equalsIgnoreCase("xlsx")) {
		imgManger.setDocfiletype("8");
	} else if (ext.equalsIgnoreCase("pptx")) {
		imgManger.setDocfiletype("9");
	} else if (ext.equalsIgnoreCase("et")) {
		imgManger.setDocfiletype("10");
	} else {
		imgManger.setDocfiletype("2");
	}
	imgManger.AddDocImageInfo();
	
	String sql="select count(distinct id) from docimagefile where isextfile = '1' and docid="+docid;
	rs.executeSql(sql);
	int countImg=0;
	while(rs.next()){
		countImg=rs.getInt(1);	
	}	
	
	Calendar today = Calendar.getInstance();
	String formatdate = Util.add0(today.get(Calendar.YEAR), 4) + "-"
			+ Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-"
			+ Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String formattime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":"
			+ Util.add0(today.get(Calendar.MINUTE), 2) + ":"
			+ Util.add0(today.get(Calendar.SECOND), 2);
	
	sql = "update  docdetail set accessorycount="+countImg+",doclastmoddate='"+formatdate+"',doclastmodtime='"+formattime+"',doclastmoduserid='"+user.getUID()+"',docLastModUserType='"+user.getLogintype()+"' where id="+docid;
	//System.out.println(sql);
	rs.executeSql(sql);
	//if("view".equals(mode))
	//{
	String docsubject = "";
	String creatertype = "";
	int doccreater = 0;
	String selSql = "select docsubject,creatertype, doccreater from DocDetailLog where docid="+ docid + " order by id desc";
	//System.out.println("selSql : "+selSql);
	rs.executeSql(selSql); 
	if (rs.next()) {
		docsubject = rs.getString(1);
		creatertype = rs.getString(2);
		doccreater = Util.getIntValue(rs.getString(3));
	}
	String clientip = request.getRemoteAddr();
	String usertype = Util.null2String(fu.getParameter("usertype"));
	;
	docDetailLog.resetParameter();
	docDetailLog.setDocId(docid);
	docDetailLog.setDocSubject(docsubject);
	docDetailLog.setOperateType("2");
	docDetailLog.setOperateUserid( Util.getIntValue(desUtil.decrypt(userid)));
	docDetailLog.setUsertype(usertype);
	docDetailLog.setClientAddress(clientip);
	docDetailLog.setDocCreater(doccreater);
	docDetailLog.setCreatertype(creatertype);
	docDetailLog.setDocLogInfo();
	//}
%>





