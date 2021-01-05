
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.sql.Timestamp"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<%
  String method=  Util.null2String(request.getParameter("method"));
  String codemainid=  Util.null2String(request.getParameter("codemainid"));
  String id=  Util.null2String(request.getParameter("id"));
  String postValue=  Util.null2String(request.getParameter("postValue"));

  String postValue2=  Util.null2String(request.getParameter("postValue2"));
  int useSecCodeRule=  Util.getIntValue(request.getParameter("useSecCodeRule"),0);//是否启用子目录编码规则，1：启用，0：不启用
  int secDocCodeAlone=  Util.getIntValue(request.getParameter("secDocCodeAlone"),0);//是否子文档单独编码，1：是，0：不是
  int secCategorySeqAlone=  Util.getIntValue(request.getParameter("secCategorySeqAlone"),0);//是否子目录单独流水，1：是，0：不是
  int dateSeqAlone=  Util.getIntValue(request.getParameter("dateSeqAlone"),0);//是否日期单独流水，1：是，0：不是
  int dateSeqSelect=  Util.getIntValue(request.getParameter("dateSeqSelect"),0);//如果日期单独流水，选择单独流水的方式，1：年，2：月，3：日
  if ("update".equals(method)) {
    rs.executeSql("update codemain set isuse="+useSecCodeRule+",secDocCodeAlone="+secDocCodeAlone+",secCategorySeqAlone="+secCategorySeqAlone+",dateSeqAlone="+dateSeqAlone+",dateSeqSelect="+dateSeqSelect+" where id="+codemainid);
    rs.executeSql("delete from codedetail where codemainid="+codemainid);
    String[] members = Util.TokenizerString2(postValue,"\u0007");
    for (int i=0;i<members.length;i++){
      String member = members[i];

      String memberAttibutes[] = Util.TokenizerString2(member,"\u001b");
      String text = memberAttibutes[0];
      String value = memberAttibutes[1];
      if ("[(*_*)]".equals(value)){value="";}
      String type = memberAttibutes[2];

      String insertStr = "insert into codedetail (codemainid,showname,showtype,value,codeorder) values ("+codemainid+",'"+text+"','"+type+"','"+value+"',"+i+")";   
      rs.executeSql(insertStr);
    }
    if(secDocCodeAlone==1){//子文档单独编码
	    String[] members2 = Util.TokenizerString2(postValue2,"\u0007");
	    for (int i=0;i<members2.length;i++){
	      String member2 = members2[i];
	      String member2Attibutes[] = Util.TokenizerString2(member2,"\u001b");
	      String text = member2Attibutes[0];
	      String value = member2Attibutes[1];
	      if ("[(*_*)]".equals(value)){value="";}
	      String type = member2Attibutes[2];
	
	      String insertStr = "insert into codedetail (codemainid,showname,showtype,value,codeorder,issecdoc) values ("+codemainid+",'"+text+"','"+type+"','"+value+"',"+i+",'1')";
	      rs.executeSql(insertStr);
	    }
    }
	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String year = (timestamp.toString()).substring(0,4);
	String month = (timestamp.toString()).substring(5,7);
	String day = (timestamp.toString()).substring(8,10);
	
    if(secCategorySeqAlone==1){
	    int seqId = 0;
    	rs.executeSql("select id from DocSecCategoryCoderSeq where secCategoryId="+id);
    	if(rs.next()){
    		rs1.executeSql("update DocSecCategoryCoderSeq set isUse='1' where secCategoryId="+id);
    	}else{
    		rs1.executeSql("insert into DocSecCategoryCoderSeq(sequence,yearSeq,monthSeq,daySeq,secCategoryId,isUse) values(0,"+year+","+month+","+day+","+id+",'1')");
    	}
    }else{
    	rs.executeSql("select id from DocSecCategoryCoderSeq where secCategoryId="+id);
    	if(rs.next()){
    		rs1.executeSql("update DocSecCategoryCoderSeq set isUse='0' where secCategoryId="+id);
    	}else{
    		rs1.executeSql("select id from DocSecCategoryCoderSeq where secCategoryId=-1");
    		if(!rs1.next()){
    			rs2.executeSql("insert into DocSecCategoryCoderSeq(sequence,yearSeq,monthSeq,daySeq,secCategoryId,isUse) values(0,"+year+","+month+","+day+",-1,'1')");
    		}
    	}
    }
    response.sendRedirect("DocSecCategoryCodeRuleEdit.jsp?id="+id);
  }
%>