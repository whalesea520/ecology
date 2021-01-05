<%@ page language="java" contentType="json; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.StaticObj,
                 weaver.general.Util" %>
<%@ page import="net.sf.json.*,com.sap.mw.jco.JCO" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="rspop" class="weaver.conn.RecordSet" scope="page"/> 
<jsp:useBean id="rspopuser" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<%
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
%>

<% 
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
User user = HrmUserVarify.getUser (request , response) ;

String tables=ShareManager.getShareDetailTableByUserNew("doc",user);

String docsid = "";
String pop_width = "";
String pop_hight = "";
String is_popnum = "";
String pop_type = "";
String popupsql ="";
String pop_num ="";

String docsids = "";
String is_popnums = "";
String pop_widths = "";
String pop_hights = "";

String checktype="select distinct docid,pop_type,pop_hight,pop_width,is_popnum, pop_num from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and t1.docstatus in ('1','2','5') and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') ";
rspop.executeSql(checktype);
while(rspop.next()){
	pop_type=Util.null2String(rspop.getString("pop_type"));
	docsid = Util.null2String(rspop.getString("docid"));
    pop_hight =Util.null2String(rspop.getString("pop_hight"));
    pop_width = Util.null2String(rspop.getString("pop_width"));
    is_popnum = Util.null2String(rspop.getString("is_popnum"));
	pop_num = Util.null2String(rspop.getString("pop_num"));
	if("".equals(pop_hight)) pop_hight = "500";
    if("".equals(pop_width)) pop_width = "600";
	if(pop_type.equals("1")||pop_type.equals("")){

	  popupsql = "select 1 from DocDetail  t1, "+tables+"  t2,DocPopUpInfo t3 where t1.id=t2.sourceid and t1.id = t3.docid and (t1.ishistory is null or t1.ishistory = 0) and (t3.pop_startdate <= '"+CurrentDate+"' and t3.pop_enddate >= '"+CurrentDate+"') and pop_num > is_popnum and docid="+docsid;
	  RecordSet.executeSql(popupsql); 
	  if(RecordSet.next()){
		 RecordSet.executeSql("update DocPopUpInfo set is_popnum = "+(Util.getIntValue(is_popnum,0)+1)+" where docid = "+docsid);
		 if(docsids.equals("")){
		 is_popnums=is_popnum;
		 docsids=docsid;
		 pop_hights=pop_hight;
		 pop_widths=pop_width;
         }else{
		 is_popnums=is_popnums+","+is_popnum;
		 docsids=docsids+","+docsid;
		 pop_hights=pop_hights+","+pop_hight;
		 pop_widths=pop_widths+","+pop_width;
		 
		 }
	  }
	} else {
      rspopuser.executeSql("select * from DocPopUpUser where userid="+user.getUID()+" and docid="+docsid);

	  if(rspopuser.next()){
	  is_popnum = Util.null2String(rspopuser.getString("haspopnum"));
	  if(Util.getIntValue(is_popnum,0) <Util.getIntValue(pop_num,0)){
		 RecordSet.executeSql("update DocPopUpUser set haspopnum = "+(Util.getIntValue(is_popnum,0)+1)+" where docid = "+docsid+" and userid="+user.getUID());
		 if(docsids.equals("")){
		 is_popnums=is_popnum;
		 docsids=docsid;
		 pop_hights=pop_hight;
		 pop_widths=pop_width;
         }else{
		 is_popnums=is_popnums+","+is_popnum;
		 docsids=docsids+","+docsid;
		 pop_hights=pop_hights+","+pop_hight;
		 pop_widths=pop_widths+","+pop_width;
		 
		 }
        
	   }
	
	  }else{
		  if(Util.getIntValue(pop_num,0)>0){
		   RecordSet.executeSql("insert into DocPopUpUser(userid,docid,haspopnum) values ("+user.getUID()+","+docsid+",1 )");	
		 if(docsids.equals("")){
		 is_popnums=is_popnum;
		 docsids=docsid;
		 pop_hights=pop_hight;
		 pop_widths=pop_width;
         }else{
		 is_popnums=is_popnums+","+is_popnum;
		 docsids=docsids+","+docsid;
		 pop_hights=pop_hights+","+pop_hight;
		 pop_widths=pop_widths+","+pop_width;
		 
		 }

		  }
	  
	  }
	}

}

    JSONObject jsa = new JSONObject();
	jsa.put("docsids", docsids);	
	jsa.put("is_popnums", is_popnums);
	jsa.put("pop_hights", pop_hights);
	jsa.put("pop_widths", pop_widths);
	out.print(jsa.toString());

%>
