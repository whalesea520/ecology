<%@ page import="weaver.general.Util,
                 weaver.conn.RecordSetTrans,
                 java.util.List,
                 java.util.ArrayList"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page" />
<jsp:useBean id="LabelComInfo" class="weaver.systeminfo.label.LabelComInfo" scope="page" />	
<%
    String method = Util.null2String(request.getParameter("method"));
    String grouptype = Util.null2String(request.getParameter("grouptype"));
    if(method.equals("save")){
    	
    	String changefieldids = Util.null2String(request.getParameter("changefieldids"));
    	String changefieldnames = Util.null2String(request.getParameter("changefieldnames"));
    	try{
    		ArrayList changefieldidsArray = Util.TokenizerString(changefieldids,",");
    		ArrayList changefieldnamesArray = Util.TokenizerString(changefieldnames,",");
    		for(int i=0;i<changefieldidsArray.size();i++){
    			String fieldid = (String)changefieldidsArray.get(i);
    			String fieldname = (String)changefieldnamesArray.get(i);
    			String fieldnameCN = Util.null2String(request.getParameter("field_"+fieldid+"_CN"));
    			String fieldnameEn = Util.null2String(request.getParameter("field_"+fieldid+"_En"));
    			String fieldnameTW = Util.null2String(request.getParameter("field_"+fieldid+"_TW"));
    			fieldnameCN = Util.StringReplace(fieldnameCN, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
    			fieldnameEn = Util.StringReplace(fieldnameEn, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
    			fieldnameTW = Util.StringReplace(fieldnameTW, "\"", "");//TD10108 表单字段显示名不可以含有半角双引号“"”
    			int lableid = 0;
    			boolean newlabel=false;
    			RecordSetTrans RecordSetTrans = new RecordSetTrans();
    			RecordSetTrans.setAutoCommit(false);
  				String mysql=""+
  						" select distinct t2.indexid from HtmlLabelInfo t2 where "+
  						" exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+fieldnameCN+"' and t1.languageid=7) "+
  						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+fieldnameEn+"' and t1.languageid=8) "+ 
  						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+fieldnameTW+"' and t1.languageid=9) " ;
  				RecordSetTrans.executeSql(mysql);
  				if(newlabel=(!RecordSetTrans.next())){
  				  	lableid = CptFieldManager.getNewIndexId(RecordSetTrans);
  					  RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
  					  RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+fieldnameCN+"')");
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameCN+"',7)");//中文
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameEn+"',8)");//英文
  					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+fieldnameTW+"',9)");//繁体
  					  
  				  }else{
  				  	lableid=RecordSetTrans.getInt("indexid");
  				  }

      		if(fieldname.indexOf("datefield")>-1||fieldname.indexOf("numberfield")>-1
       			 ||fieldname.indexOf("textfield")>-1||fieldname.indexOf("tinyintfield")>-1){
      			RecordSetTrans.executeSql("update hrm_formfield set fieldlabel="+lableid+" where fieldname='"+fieldname+"'");
    		  }else{
    		  	RecordSetTrans.executeSql("update cus_formfield set fieldlable="+lableid+" where fieldid="+fieldid);
    		  }
 				  RecordSetTrans.commit();
 				  if(newlabel)LabelComInfo.addLabeInfoCache(""+lableid);//更新缓存
    		}
    	}catch(Exception exception){
    	}
  	  response.sendRedirect("HrmFieldLabel.jsp?grouptype="+grouptype);
    }
%>