<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="LabelUtil" class="weaver.proj.util.LabelUtil" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page" />
<jsp:useBean id="MeetingFieldComInfo" class="weaver.meeting.defined.MeetingFieldComInfo" scope="page"/>
<%

	int currentLanguageid=user.getLanguage();	
	int current_langId=7;
    String method = Util.null2String(request.getParameter("method"));
    String grouptype = Util.null2String(request.getParameter("grouptype"));
    if("save".equals(method)){
    	String changefieldids = Util.null2String(request.getParameter("changefieldids"));
    	String changefieldnames = Util.null2String(request.getParameter("changefieldnames"));
    	String changefieldlabels = Util.null2String(request.getParameter("changefieldlabels"));

   		ArrayList changefieldidsArray = Util.TokenizerString(changefieldids,",");
   		ArrayList changefieldnamesArray = Util.TokenizerString(changefieldnames,",");
   		ArrayList changefieldlabelsArray = Util.TokenizerString(changefieldlabels,",");
   		for(int i=0;i<changefieldidsArray.size();i++){
   			String fieldid = (String)changefieldidsArray.get(i);
   			String fieldname = (String)changefieldnamesArray.get(i);
   			int fieldlabel = Util.getIntValue((String)changefieldlabelsArray.get(i),0);
   			String labelname=Util.StringReplace(Util.null2String(request.getParameter("field_"+fieldid+"_"+currentLanguageid)), "\"", "");
   			int lableid= LabelUtil.getLabelId(labelname,current_langId);
   		  	if(lableid<=-1){//更新标签库
   			  	RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
   			  	RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
   			  	RecordSet.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+labelname+"')");
    		  	LanguageComInfo.setTofirstRow();
			    while(LanguageComInfo.next()){
				   current_langId=Util.getIntValue(LanguageComInfo.getLanguageid());
				   RecordSet.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+Util.StringReplace(Util.null2String(request.getParameter("field_"+fieldid+"_"+current_langId)), "\"", "")+"',"+current_langId+")");//中文
			    }
	   			LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
   			}
   		  	RecordSet.executeSql("update meeting_formfield set fieldlabel="+lableid+" where fieldname='"+fieldname+"'");
   		}
   		MeetingFieldComInfo.removeFieldCache();
  	  response.sendRedirect("FieldLabel.jsp?grouptype="+grouptype);
    }else if("refreshLabel".equals(method)){
    	String fieldid = Util.null2String(request.getParameter("changefieldids"));
    	RecordSet.execute("select fieldlabel from meeting_formfield where sysfieldlabel is not null and sysfieldlabel<>'' and fieldid='"+fieldid+"'");
    	if(RecordSet.next()){
    		RecordSet.executeSql("update meeting_formfield set fieldlabel=sysfieldlabel where sysfieldlabel is not null and sysfieldlabel<>'' and fieldid='"+fieldid+"'");
    		int lableid=Util.getIntValue(RecordSet.getString("fieldlabel"));
    		if(lableid<-1){
    			LabelComInfo.removeLabeInfoCache(""+lableid);//更新缓存
    			RecordSet.executeSql("delete from HtmlLabelIndex where id="+lableid);
   			  	RecordSet.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
    		}
    	}
    	MeetingFieldComInfo.removeFieldCache();
    	response.sendRedirect("FieldLabel.jsp?grouptype="+grouptype);
    }
%>