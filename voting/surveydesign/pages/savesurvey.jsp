
<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*,java.text.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager,
                 weaver.docs.docs.FieldParam" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsBelong" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	
<%
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");

//调查id
String votingid=request.getParameter("votingid");

SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
//操作日期
String opdate=format.format(new Date());
format=new SimpleDateFormat("HH:mm:ss");
//操作时间
String optime=format.format(new Date());
String sql="";
List<String>  sqls=new ArrayList<String>();

//是否匿名操作
String annony=Util.null2String(request.getParameter("useranony"));
if("".equals(annony)){
	annony="0";	
}
    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(userid+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();

//防止同账号并发操作,先删除操作
sql = "select * from VotingRemark where resourceid = '"+user.getUID()+"' and votingid='"+votingid+"'";
rs.execute(sql);
if(!(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals(""))){
if(rs.next()){
   //该用户已参与过投票
   out.println("{\"success\":\"-1\"}");
   return;
}
}


rs.executeSql("select r.*,q.questiontype from VotingResourceTemp r,VotingQuestion q where r.questionid=q.id and r.votingid=" + votingid + " and r.resourceid=" + user.getUID());
Map<String,List<Map<String,String>>> dataMap = new HashMap<String,List<Map<String,String>>>();
while(rs.next()){
	int questiontype = rs.getInt("questiontype");
	
	List<Map<String,String>> q_options = null;
	if(dataMap.get(rs.getString("questionid")) == null){
		q_options = new ArrayList<Map<String,String>>();
		dataMap.put(rs.getString("questionid"),q_options);
	}else{
		q_options = dataMap.get(rs.getString("questionid"));
	}
	
	Map<String,String> q_option = new HashMap<String,String>();
	q_options.add(q_option);
	if(questiontype == 0){
		q_option.put("optionid",Util.getIntValue(rs.getString("optionid"),-100) + "");
	}else if(questiontype == 1){
		q_option.put("optionid",rs.getString("optionid"));
	}else{
		q_option.put("optionid","-100");
	}
	
}

Enumeration  paramnames=request.getParameterNames();
String paramname;
String paramitems[];
String questionid;
String questionchild;
String[] questionvalues;
String othername;
String othervalue;
boolean hasDataSub = false;  
while(paramnames.hasMoreElements()){
	paramname=(String)paramnames.nextElement();
	if(paramname.indexOf("q_")==0){
		hasDataSub = true;
    	paramitems=paramname.split("_");
	    //选择题
    	if(paramitems.length==2){	 
    		//问题id
    		questionid=paramitems[1]; 	
    		//如果是多选
    		if(questionid.indexOf("[]")>=0){
    			questionid=questionid.substring(0,questionid.indexOf("[]"));
    		}
    		questionvalues=request.getParameterValues(paramname);
    		for(String optionid:questionvalues){
   				if(dataMap.get(questionid) != null){
   					boolean exist = false;
   					for(Map<String,String> data : dataMap.get(questionid)){
   						if(optionid.equals(data.get("optionid"))){
   							data.put("flag","1");
   							exist = true;
   							break;
   						}
   					}
   					if(exist)
   						continue;
   				}
   				
    			 //其它选项
    			 if("-100".equals(optionid)){
    				 othername="qother_"+questionid;
    				 othervalue=request.getParameter(othername);
    				 sql="insert into VotingResourceRemark(votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+userid+"','"+annony+"','"+othervalue+"','"+opdate+"','"+optime+"')";
    	    	 }else{
    	    		 sql="insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+optionid+"','"+userid+"','"+opdate+"','"+optime+"')";
    			 }
	    		 sqls.add(sql);
    		}
    	//组合选择	
	    }else if(paramitems.length==3){
	    	questionid=paramitems[1];
	    	questionchild=paramitems[2];
	    	//如果是多选
    		if(questionchild.indexOf("[]")>=0){
    			questionchild=questionchild.substring(0,questionchild.indexOf("[]"));
    		}
	    	questionvalues=request.getParameterValues(paramname);
    		for(String optionid:questionvalues){
    			
    			if(dataMap.get(questionid) != null){
   					boolean exist = false;
   					for(Map<String,String> data : dataMap.get(questionid)){
   						if((questionchild+"_"+optionid).equals(data.get("optionid"))){
   							data.put("flag","1");
   							exist = true;
   							break;
   						}
   					}
   					if(exist)
   						continue;
   				}
    			
	    		 sql="insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) values('"+votingid+"','"+questionid+"','"+questionchild+"_"+optionid+"','"+userid+"','"+opdate+"','"+optime+"')";
	    		 sqls.add(sql);
    		}
	    }
	}
}

if(hasDataSub){
	RecordSet delRs = new RecordSet();
	boolean needDel = false;
	for(String key : dataMap.keySet()){
		for(Map<String,String> data : dataMap.get(key)){
			if(data.get("flag") == null){
				needDel = true;
				delRs.execute("delete from VotingResourceTemp where votingid=" + votingid + 
						" and resourceid=" + user.getUID() + 
						" and questionid=" + key + 
						("-100".equals(data.get("optionid")) ? " and (optionid is null or optionid='-100')" : (" and optionid=" + data.get("optionid"))));
			}
		}
	}
	if(needDel)
		Thread.sleep(1000l);
}

sql="insert into VotingRemark(votingid,resourceid,useranony,operatedate,operatetime) values('"+votingid+"','"+user.getUID()+"','"+annony+"','"+opdate+"','"+optime+"')";
sqls.add(sql);

sql = "insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) " +
	" select votingid,questionid,optionid,resourceid,operatedate,operatetime from VotingResourceTemp " +
	" where votingid=" + votingid + " and resourceid=" + user.getUID() + " and optionid is not null and optionid!='-100'";
sqls.add(sql);

sql = "insert into VotingResourceRemark(votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime) " +
	" select votingid,questionid,resourceid,'" + annony + "',remark,operatedate,operatetime from VotingResourceTemp " +
	" where votingid=" + votingid + " and resourceid=" + user.getUID() + " and (optionid is null or optionid='-100')";
sqls.add(sql);

try{
	//RecordSetTrans.setAutoCommit(false);
	for(String sqlitem:sqls){
		rs2.executeSql(sqlitem);
	}	
	
	rs.executeSql("select count(1) num from VotingResourceTemp where votingid=" + votingid + " and resourceid=" + user.getUID());
	rs.next();
	int totalNum = rs.getInt(1);
	
	if(totalNum > 0){
		Thread.sleep(500l);
		for(int i = 0 ;i < 5;i++){
			rs.executeSql("select sum(num) num from(" +
					"select count(1) from VotingResource where votingid=" + votingid + " and resourceid=" + user.getUID() +
					"select count(1) from VotingResourceRemark where votingid=" + votingid + " and resourceid=" + user.getUID() +
					") t");
			int totalNum2 = 0;
			if(rs.next()){
				totalNum2 = rs.getInt(1);
			}
			if(totalNum2 > 0){
				break;	
			}
			Thread.sleep(1000l);
		}
	}
	
	//sql = "delete VotingResourceTemp where votingid=" + votingid + " and resourceid=" + user.getUID();
	//rs.executeSql(sql);
	//提交事务
	//RecordSetTrans.commit();
   
	if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
		Set undoUserSet=VotingManager.getUndoUserSet(votingid);
		Set hasPollRightUserSet=VotingManager.getHasPollRightUserSet(votingid);
		String[] belongtoidarr=belongtoids.split(",");
		for(int i=0;i<belongtoidarr.length;i++){
			if(undoUserSet.contains(belongtoidarr[i])){
				rsBelong.executeSql(" insert into VotingRemark(votingid,resourceid,useranony,remark,operatedate,operatetime) select      votingid,"+belongtoidarr[i]+",useranony,remark,operatedate,operatetime from VotingRemark where resourceid="+userid+" and votingid="+votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
		    rsBelong.executeSql(" insert into VotingResource(votingid,questionid,optionid,resourceid,operatedate,operatetime) select   votingid,questionid,optionid,'"+belongtoidarr[i]+"',operatedate,operatetime from VotingResource where resourceid="+userid+" and votingid="+votingid);
		    rsBelong.executeSql("  insert into VotingResourceRemark (votingid,questionid,resourceid,useranony,otherinput,operatedate,operatetime) select votingid,questionid,'"+belongtoidarr[i]+"',useranony,otherinput,operatedate,operatetime from VotingResourceRemark where resourceid="+userid+" and votingid="+votingid);
			}
		}
			
		 if(!hasPollRightUserSet.contains(String.valueOf(userid))){
		   rsBelong.executeSql("delete from VotingRemark where resourceid ="+userid+" and votingid=" + votingid);
			 rsBelong.executeSql("delete from VotingResource where resourceid ="+userid+" and votingid=" + votingid);
			 rsBelong.executeSql("delete from VotingResourceRemark where resourceid ="+userid+" and votingid=" + votingid);
		 }else{
				//rsBelong.executeSql("select count(resourceid) as hanum from VotingRemark where resourceid ="+userid+" and votingid=" + votingid);
			 	//if(rsBelong.next()){
			 // int hanum=rsBelong.getInt("hanum");
			
			//  if(hanum==2){
			   //  rsBelong.executeSql("delete from VotingRemark where resourceid ="+userid+" and votingid=" + votingid+" and operatetime ='"+optime+"' and operatedate='"+opdate+"'");
			    // rsBelong.executeSql("delete from VotingResource where resourceid ="+userid+" and votingid=" + votingid);
			   //  rsBelong.executeSql("delete from VotingResourceRemark where resourceid ="+userid+" and votingid=" + votingid);
			 // }
			 
			 }
		   
		  }
	
	
	out.println("{\"success\":\"1\"}");
}catch(Exception e){
    
	out.println("{\"success\":\"0\"}");
}



%>