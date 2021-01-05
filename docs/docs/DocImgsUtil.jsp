
<%@ page language="java" contentType="text/xml;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="imgManger" class="weaver.docs.docs.DocImageManager" scope="page"/>
<jsp:useBean id="docDetailLog" class="weaver.docs.DocDetailLog" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	int docid = Util.getIntValue(request.getParameter("docid"),-1);
	String delImgIds = Util.null2String(request.getParameter("delImgIds"));
    String  method=Util.null2String(request.getParameter("method"));
	String  delcurrentversion=Util.null2String(request.getParameter("delcurrentversion"));
	//int userLanguage = user.getLanguage();

	if(method.equals("delPics")){  
		String[] arrayImgsId=Util.TokenizerString2(delImgIds,",");
		if(arrayImgsId!=null) {
			for(int i=0;i<arrayImgsId.length;i++){
				int tempImgId=Util.getIntValue(arrayImgsId[i],-1);
				
				if(tempImgId==-1) continue;

				
                String sql = "delete from docimagefile where imagefileid=" + tempImgId + " and docid = " + docid;

				//System.out.println(sql);

                rs.executeSql(sql);

                imgManger.resetParameter();
                imgManger.setImagefileid(tempImgId);
                imgManger.setDocid(docid);
                imgManger.DeleteSingleDocImageInfo();
                
                rs.executeSql("update docdetail set accessorycount = (select count(0) from DocImageFile where isextfile = '1' and docid = " +docid + " and docfiletype <> '1' ) where id = " + docid);
				
			}			
		}
		return;
	}  else if(method.equals("delImgsOnly")){
		String tempFlag=delImgIds.substring(delImgIds.length()-1);
		if(tempFlag.equals(",")) delImgIds=delImgIds.substring(0,delImgIds.length()-1);
		//System.out.println("delImgIds:"+delImgIds);
		
        ArrayList delImageids=Util.TokenizerString(delImgIds,",");
        for (int i = 0; i < delImageids.size(); i++) {
        	if (Util.getIntValue((String)delImageids.get(i), 0) == 0) continue;
        	if("1".equals(delcurrentversion)){
        	imgManger.resetParameter();
        	imgManger.setDocid(docid);
        	imgManger.setImagefileid(Util.getIntValue((String)delImageids.get(i), 0));
        	imgManger.DeleteSingleDocImageInfo();
        	}else{
        		rs.executeSql("select imagefileid from DocImageFile where id = (select id from DocImageFile where docid="+docid +" and imagefileid="+Util.getIntValue((String)delImageids.get(i), 0)+" and isextfile=1) ");
        		while(rs.next()){
        			imgManger.resetParameter();
		        	imgManger.setDocid(docid);
		        	imgManger.setImagefileid(Util.getIntValue(rs.getString("imagefileid"), 0));
		        	imgManger.DeleteSingleDocImageInfo();
        		}
        	}
        }
		
		String sql ="select count(distinct id) from docimagefile where isextfile = '1' and docid="+docid;
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
		String usertype = user.getLogintype();
		int userid = user.getUID();
		docDetailLog.resetParameter();
		docDetailLog.setDocId(docid);
		docDetailLog.setDocSubject(docsubject);
		docDetailLog.setOperateType("2");
		docDetailLog.setOperateUserid(userid);
		docDetailLog.setUsertype(usertype);
		docDetailLog.setClientAddress(clientip);
		docDetailLog.setDocCreater(doccreater);
		docDetailLog.setCreatertype(creatertype);
		docDetailLog.setDocLogInfo();
		return;
	}
%>