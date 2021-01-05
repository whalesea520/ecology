
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,weaver.systeminfo.SystemEnv" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@page import="net.sf.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocMouldComInfo" class="weaver.docs.mouldfile.DocMouldComInfo" scope="page" />
<jsp:useBean id="MouldManager" class="weaver.docs.mouldfile.MouldManager" scope="page" />
<%@ page import="weaver.file.ImageFileManager" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
String secid = Util.null2String(request.getParameter("secid"));
int mouldid = Util.getIntValue(request.getParameter("mouldid"),-1);
String __DocAddExtPage = Util.null2String(request.getParameter("__DocAddExtPage"));
boolean isTemporaryDoc = false;
String invalidationdate = Util.null2String(request.getParameter("invalidationdate"));
if(invalidationdate!=null&&!"".equals(invalidationdate))
    isTemporaryDoc = true;
String docType = ".htm";
if(__DocAddExtPage.equalsIgnoreCase("true")){
	docType = ".doc";
}
int selectMouldType = 0;
if(mouldid==-1||mouldid==0){
	if(docType.equals(".htm")){
		RecordSet.executeSql("select * from DocSecCategoryMould where secCategoryId = "+secid+" and mouldType=2 order by id ");
		while(RecordSet.next()){
			String moduleid=RecordSet.getString("mouldId");
			String mType = DocMouldComInfo.getDocMouldType(moduleid);
			String modulebind = RecordSet.getString("mouldBind");
			int isDefault = Util.getIntValue(RecordSet.getString("isDefault"),0);

			if(isTemporaryDoc){
			    
				if(Util.getIntValue(modulebind,1)==3){
				    selectMouldType = 3;
				    mouldid = Util.getIntValue(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
			        if(selectMouldType==0){
			        	selectMouldType = 1;
			        	mouldid = Util.getIntValue(moduleid);
			        }
			    }

			} else {

				if(Util.getIntValue(modulebind,1)==2){
				    selectMouldType = 2;
				    mouldid = Util.getIntValue(moduleid);
			    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
				    if(selectMouldType==0){
				        selectMouldType = 1;
				        mouldid = Util.getIntValue(moduleid);
				    }
			    }
			}
		}
	}else{
		if(docType.equals(".doc")||docType.equals(".xls")||docType.equals(".wps")||docType.equals(".et")){
			int  tempMouldType=4;//4：WORD编辑模版
			if(docType.equals(".xls")){
				tempMouldType=6;//6：EXCEL编辑模版
			}else if(docType.equals(".wps")){
				tempMouldType=8;//8：WPS文字编辑模版
			}else if(docType.equals(".et")){
				tempMouldType=10;//8：WPS表格编辑模版
			}
			while(RecordSet.next()){
				String moduleid=RecordSet.getString("mouldId");
				String mType = DocMouldComInfo.getDocMouldType(moduleid);
				String modulebind = RecordSet.getString("mouldBind");
				int isDefault = Util.getIntValue(RecordSet.getString("isDefault"),0);

				if(isTemporaryDoc){
				    
					if(Util.getIntValue(modulebind,1)==3){
					    selectMouldType = 3;
					    mouldid = Util.getIntValue(moduleid);
				    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
				        if(selectMouldType==0){
					        selectMouldType = 1;
					        mouldid = Util.getIntValue(moduleid);
				        }
				    } 

				} else {
				
					if(Util.getIntValue(modulebind,1)==2){
					    selectMouldType = 2;
					    mouldid = Util.getIntValue(moduleid);
				    } else if(Util.getIntValue(modulebind,1)==1&&isDefault==1){
					    if(selectMouldType==0){
					        selectMouldType = 1;
					        mouldid = Util.getIntValue(moduleid);
					    }
				    } 
				}
			}
		}
	}
}
if(__DocAddExtPage.equalsIgnoreCase("true")){
	JSONObject json = new JSONObject();
	json.put("mouldid",mouldid);
	out.print(json.toString());
}else{
	MouldManager.setId(mouldid);
	MouldManager.getMouldInfoById();
	String mouldtext=MouldManager.getMouldText();
	MouldManager.closeStatement();
	
	if(mouldtext != null && mouldtext.indexOf("/weaver/weaver.file.FileDownload?fileid=") > -1){
		
		Map<Integer,String> idMap = new HashMap<Integer,String>();
        int pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload?fileid=");
        while (pos != -1) {
        	int imagefileidbeginpos=pos+"/weaver/weaver.file.FileDownload?fileid=".length();       	
        	int imagefileidendpos1=mouldtext.indexOf("\"",pos);
        	int imagefileidendpos=imagefileidendpos1;
        	int imagefileid = 0;
        	if(imagefileidendpos>imagefileidbeginpos){
            	imagefileid=Util.getIntValue(mouldtext.substring(imagefileidbeginpos,imagefileidendpos));
				if(imagefileid>0){
					idMap.put(imagefileid,"1");
            	}
        	}
        	pos = mouldtext.indexOf("/weaver/weaver.file.FileDownload?fileid=", pos + 1);
        } 
		
        for(Integer k : idMap.keySet()){
    		int imageid = ImageFileManager.copyImageFile(k);
    		mouldtext = mouldtext.replace("/weaver/weaver.file.FileDownload?fileid=" + k,"/weaver/weaver.file.FileDownload?fileid=" + imageid);
        }
	}
	
	out.println(mouldtext);
}
%>
