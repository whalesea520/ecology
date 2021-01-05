
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*,java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*"%>
<jsp:useBean id="userinputrs" class="weaver.conn.RecordSet" scope="page" />
<%
   User useritem = HrmUserVarify.getUser (request , response) ;
   votingid= Util.null2String(request.getParameter("votingid"));
  // votingid="34";
   sql="select questiontype,isother,ismulti as type,questionid,value,remark   from ( "+
	   " select questionid,optionid as value,'' as remark  from VotingResource where votingid='"+votingid+"' and resourceid='"+useritem.getUID()+"' "+
	   " union all "+
	   " select questionid,'-100' as value,otherinput as remark from VotingResourceRemark where votingid='"+votingid+"' and resourceid='"+useritem.getUID()+"' "+
	   " )a inner join (select id,ismulti,isother,questiontype  from VotingQuestion) b  on a.questionid=b.id";
   userinputrs.execute(sql);
   List<Map<String,String>>  userinputs=new ArrayList<Map<String,String>>();
   Map<String,String> userinput;
   String qtype;
   String qother;
   String qdtype;
   String qid;
   String qvalue;
   String qremark;
   while(userinputrs.next()){
	   userinput=new HashMap<String,String>();
	   qtype=userinputrs.getString("questiontype");
	   userinput.put("qtype",qtype);
	   qother=userinputrs.getString("isother");
	   userinput.put("qother",qother);
	   qdtype=userinputrs.getString("type");
	   userinput.put("qdtype",qdtype);
	   qid=userinputrs.getString("questionid");
	   userinput.put("qid",qid);
	   qvalue=userinputrs.getString("value");
	   userinput.put("qvalue",qvalue);
	   qremark = userinputrs.getString("remark");
	   userinput.put("qremark",qremark);
	   userinputs.add(userinput);
   }
   JSONArray userinutobj=new JSONArray(userinputs);
   String userinputitems=userinutobj.toString();
%>



