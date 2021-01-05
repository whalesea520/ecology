
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.*,java.util.*"%>
<%@ page import="weaver.hrm.*,weaver.conn.*,org.json.*,java.math.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="showOrderRs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsrecoverqu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsrecoverop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetTrans" class="weaver.conn.RecordSetTrans" scope="page" />
<%
   String votingid= Util.null2String(request.getParameter("votingid"));
   //兼容以前的调查表
   String tempsql="select distinct(pagenum) as pnums from VotingQuestion where votingid='"+votingid+"'";
   rs.execute(tempsql);
   if(rs.next()){
	  List<String> recoverSqls=new ArrayList<String>();
      int pnum=rs.getInt("pnums");
	  if(pnum==-1){
		  //处理问题兼容
		  tempsql="select id  from VotingQuestion where votingid='"+votingid+"'";
		  rsrecoverqu.execute(tempsql);
		  int questioncount=1;
		  while(rsrecoverqu.next()){
			  tempsql="update VotingQuestion set showorder='"+questioncount+"',pagenum='1',questiontype='0',ismustinput='0',limit='-1',max='-1',perrowcols='1',israndomsort='0' where id='"+rsrecoverqu.getInt("id")+"'";
			  questioncount++;
			  recoverSqls.add(tempsql);
			  //处理选项兼容
			  tempsql="select id  from VotingOption where questionid='"+rsrecoverqu.getInt("id")+"'";
			  rsrecoverop.execute(tempsql);
			  int oporder=0;
			  while(rsrecoverop.next()){
				  tempsql="update VotingOption set showorder='"+oporder+"',roworcolumn='-1' where id='"+rsrecoverop.getInt("id")+"'";
			      recoverSqls.add(tempsql);
			      oporder++;
			  }
		  }
		  //执行兼容sql
		  RecordSetTrans.setAutoCommit(false);
		  for(String recoverSql:recoverSqls){
			  RecordSetTrans.execute(recoverSql);  
		  }
		  //提交事务
		  RecordSetTrans.commit();
	  }
   }

	 //解决排序错乱问题
  rs.executeSql("select id,pagenum,showorder  from VotingQuestion where votingid="+votingid+" order by pagenum,showorder,id "); 
  int _i = 1;
  int _p = 1;
  while(rs.next()){
	  if(_p != rs.getInt("pagenum")){
		  _p = rs.getInt("pagenum");
		  _i = 1;
	  }
	  if(rs.getInt("showorder") != _i){
		  showOrderRs.executeSql("update VotingQuestion set showorder=" + _i + " where id=" + rs.getInt("id"));
	  }
	  _i++;
  } 


  //兼容以前调查表填空题(只执行一次)
  tempsql="select a.id,a.subject from votingquestion a where not exists(select 1 from votingoption b where b.questionid=a.id ) and a.isother=1 and a.votingid="+votingid;
  rs.execute(tempsql);
  String oid;
  String osub;
  List<String> restoreblanks=new ArrayList<String>();
  while(rs.next()){
	  oid=rs.getString("id");
	  osub=rs.getString("subject");
	  //变成设计器填空题
	  tempsql="update votingquestion set isother='0',questiontype='3' where id='"+oid+"'";
	  restoreblanks.add(tempsql);
	  //添加默认选项
	  tempsql="insert into VotingOption(votingid,questionid,description,optioncount,showorder,roworcolumn)values('"+votingid+"','"+oid+"','"+osub+"','1','0','-1')";  
	  restoreblanks.add(tempsql);
  }
  if(restoreblanks.size()>0){
	//执行兼容sql
	  RecordSetTrans.setAutoCommit(false);
	  for(String recoverSql:restoreblanks){
		  RecordSetTrans.execute(recoverSql);  
	  }
	  //提交事务
	  RecordSetTrans.commit();
  }
  
  // votingid="34";
   String sql="select a.isother as isother,c.subject as surveyname,a.pagenum as pagenum,a.subject as name,a.showorder as questionorder,a.questiontype as questiontype "+
	  " ,a.ismulti as type,a.ismustinput as ismustinput,a.israndomsort as israndomsort, "+
	  " a.limit as limit,a.max as maxitem,a.perrowcols as perrowcols,b.description as oplabel,b.innershow oinner,b.remarkorder, "+
	  " b.questionid as quesionid,b.id as opid,b.roworcolumn as roworcolumn,b.showorder as optionorder, "+
	  " a.imagewidth,a.imageheight,b.remark,p.id pathid,p.type pathtype,p.imagefileid,p.title pathtitle,p.innershow iinner,f.filesize " +
	  " from VotingQuestion a inner join VotingOption b inner join Voting c on b.votingid=c.id "+
	  " on a.id=b.questionid  "+
	  " left join votingpath p on p.optionid=b.id " +
	  " left join ImageFile f on f.imagefileid=p.imagefileid " +
	  " where a.votingid='"+votingid+"' order by pagenum,a.showorder,b.showorder,b.innershow,p.innershow,p.id ";
   rs.execute(sql);
   Map<Integer,Map<Integer,Map<String,Object>>> pages=new TreeMap<Integer,Map<Integer,Map<String,Object>>>();
   int pagenum=0;
   int questionorder;
   int optionorder;
   Map<Integer,Map<String,Object>>   pageinfo;
   Map<String,Object>  questioninfo;
   Map<Integer,Map<String,Object>> optioninfo;
   
   //调查名称
   String surveyname;

   //问题名称
   String quesname;
   //问题类型
   String questiontype;
   //单选还是多选
   String type;
   //是否必需
   String ismustinput;
   //是否随机显示
   String israndomsort;
   //最小显示选项
   String limit;
   //最多显示选项
   String max;
   //每行多少列
   String perrowcols;
   //是否包含其它输入
   String isother;
   
   String aid; //附件、图片id
   String fid; //附件、图片 imagefileid
   String imageWidth; //图片宽
   String imageHeight;//图片高
   String remark;//说明
   String remarkorder;
   String pathType;//类型：1-图片，2-附件
   String pathtitle;
   String defaultWidth = "100";//图片默认宽
   String defaultHeight = "80";//图片默认高
   String iinner = "";
   String filesize = "";
   

   //选项信息
   Map<String,Object> opinfo;
   //选项名称
   String oplabel;
   //问题id
   String quesionid;
   //选项id
   String opid;
   //行选项or列选项
   String roworcolumn;
   //选项内部排序
   String oinner;
      
   while(rs.next()){
	   //获取页码
	   pagenum=rs.getInt("pagenum");
	   questionorder=rs.getInt("questionorder");
	   optionorder=rs.getInt("optionorder");
	   
	   //存放页信息
	   if(!pages.containsKey(pagenum)){
		   pageinfo=new TreeMap<Integer,Map<String,Object>>();
		   pages.put(pagenum,pageinfo);
	   }else{
		   pageinfo=pages.get(pagenum);
	   }
	   //存放问题信息
	   if(!pageinfo.containsKey(questionorder)){
		   questioninfo=new TreeMap<String,Object>();
		   pageinfo.put(questionorder,questioninfo);
		   surveyname=rs.getString("surveyname");
           questioninfo.put("surveyname",surveyname);
		   quesname=rs.getString("name");
		   questioninfo.put("name",quesname);
		   questiontype=rs.getString("questiontype"); 
		   questioninfo.put("questiontype",questiontype);
		   isother=rs.getString("isother"); 
           questioninfo.put("isother",isother);
		   quesionid=rs.getString("quesionid"); 
           questioninfo.put("quesionid",quesionid);
		   type=rs.getString("type"); 
		   questioninfo.put("type",type);
		   questioninfo.put("showorder",rs.getString("questionorder"));
		   ismustinput=Util.null2String(rs.getString("ismustinput")); 
		   ismustinput = ismustinput.isEmpty() ? "" : ismustinput;
		   questioninfo.put("ismustinput",ismustinput);
		   israndomsort=Util.null2String(rs.getString("israndomsort"));
		   israndomsort = israndomsort.isEmpty() ? "-1" : israndomsort;
		   questioninfo.put("israndomsort",israndomsort);
		   limit=Util.null2String(rs.getString("limit")); 
		   limit = limit.isEmpty() ? "-1" : limit;
		   questioninfo.put("limit",limit);
		   max=Util.null2String(rs.getString("maxitem"));
		   max = max.isEmpty() ? "-1" : max;
		   questioninfo.put("max",max);
		   imageWidth = Util.null2String(rs.getString("imagewidth"));
		   imageWidth = Integer.valueOf("".equals(imageWidth) ? defaultWidth : imageWidth) + "";  //
		   questioninfo.put("imageWidth","".equals(imageWidth) ? defaultWidth : imageWidth);
		   imageHeight = Util.null2String(rs.getString("imageheight"));
		   imageHeight = Integer.valueOf("".equals(imageHeight) ? defaultHeight : imageHeight) + "";  //
		   questioninfo.put("imageHeight","".equals(imageHeight) ? defaultHeight : imageHeight);
		   perrowcols=rs.getString("perrowcols"); 
		   questioninfo.put("perrowcols",perrowcols);
		   optioninfo=new TreeMap<Integer,Map<String,Object>>();
		   questioninfo.put("options",optioninfo);
	   }else{
		   questioninfo=pageinfo.get(questionorder);
		   optioninfo=(TreeMap<Integer,Map<String,Object>>)questioninfo.get("options");
	   }
	   //选项信息
	   if(optioninfo.get(optionorder) == null || optioninfo.get(optionorder).isEmpty()){
		   opinfo=new HashMap<String,Object>();
		   oplabel=rs.getString("oplabel");
		   opinfo.put("oplabel",oplabel);
		   quesionid=rs.getString("quesionid");
		   opinfo.put("quesionid",quesionid);
		   opid=rs.getString("opid");
		   opinfo.put("opid",opid);
		   roworcolumn=rs.getString("roworcolumn");
		   opinfo.put("roworcolumn",roworcolumn);
		   optioninfo.put(optionorder,opinfo); 
		   remark = Util.null2String(rs.getString("remark"));
		   remarkorder = Util.null2String(rs.getString("remarkorder"));
		   if(!remark.isEmpty()){
		   		opinfo.put("remark",remark);
		   		opinfo.put("remarkorder",remarkorder);
		   }
		   oinner = Util.null2String(rs.getString("oinner"));
		   oinner = oinner.isEmpty() ? "0" : oinner;
		   opinfo.put("oinner",oinner);
	   }else{
	       opinfo = optioninfo.get(optionorder);
	   }
	   

	   aid = Util.null2String(rs.getString("pathid"));
	   fid = Util.null2String(rs.getString("imagefileid"));
	   pathType = Util.null2String(rs.getString("pathType"));
	   pathtitle = Util.null2String(rs.getString("pathtitle"));
	   iinner = Util.null2String(rs.getString("iinner"));
	   iinner = iinner.isEmpty() ? "0" : iinner;
	   filesize = Util.null2String(rs.getString("filesize"));
	   
	   
	   if(!aid.isEmpty()){
	       List<Map<String,String>> lists;
		   if("0".equals(pathType)){
		       if(opinfo.get("images") == null){
		           lists = new ArrayList<Map<String,String>>();
		           opinfo.put("images",lists);
		       }else{
		           lists = (List<Map<String,String>>)opinfo.get("images");
		       }
		       Map<String,String> m = new HashMap<String,String>();
		       m.put("aid",aid);
		       m.put("fid",fid);
		       m.put("iinner",iinner);
		       lists.add(m);
		   }else if("1".equals(pathType)){
		       if(opinfo.get("attrs") == null){
		           lists = new ArrayList<Map<String,String>>();
		           opinfo.put("attrs",lists);
		       }else{
		           lists = (List<Map<String,String>>)opinfo.get("attrs");
		       }
		       Map<String,String> m = new HashMap<String,String>();
		       m.put("aid",aid);
		       m.put("fid",fid);
		       m.put("title",pathtitle);
		       m.put("iinner",iinner);
		       m.put("size",filesize);
		       lists.add(m);
		   }
	   
	   }
   }
   
   String getTempData = request.getAttribute("getTempData") == null ? "" : request.getAttribute("getTempData").toString();
   if("1".equals(getTempData)){
       request.removeAttribute("getTempData");
       User currentUser = HrmUserVarify.getUser(request,response);
       rs.executeSql("select *from VotingResourceTemp where votingid=" + votingid + " and resourceid=" + currentUser.getUID());
       while(rs.next()){
           boolean b = false;
           for(int key : pages.keySet()){
              Map<Integer,Map<String,Object>> questions = pages.get(key); 
              for(int key2 : questions.keySet()){
                  Map question = (Map)questions.get(key2);
                  if(question.get("quesionid").toString().equals(rs.getString("questionid"))){
                      if(!Util.null2String(rs.getString("optionid")).isEmpty()){
                          Map checked = (Map)question.get("toBeChecked");
                          if(checked == null){
                              checked = new HashMap();
                              question.put("toBeChecked",checked);
                          }
                          checked.put(rs.getString("optionid"),"1");
                      }
                      if(!Util.null2String(rs.getString("remark")).isEmpty()){
                          question.put("toBeRemark",rs.getString("remark"));
                      }
                      b = true;
                      break;
                  }
              }
              if(b) break;
           }
       }
   }
   
   
   
   JSONObject obj=new JSONObject(pages);
   String viewset="''";
   String surveysubject="";
   sql="select *  from votingviewset where votingid='"+votingid+"'";
   rs.execute(sql);
   if(rs.next()){
	   viewset=rs.getString("viewjson");
   }
   String pageitems=obj.toString();
   sql="select subject  from Voting where id='"+votingid+"'";
   rs.execute(sql);
   if(rs.next()){
	   surveysubject=rs.getString("subject");
   }



surveysubject=surveysubject.replaceAll("\"","&quot;");


   Map<String,String> votingconfig=new HashMap<String,String>();
   sql="select *  from votingconfig";
   rs.execute(sql);
   if(rs.next()){
	   votingconfig.put("doc",rs.getString("doc"));
	   votingconfig.put("flow",rs.getString("flow"));
	   votingconfig.put("customer",rs.getString("customer"));
	   votingconfig.put("project",rs.getString("project"));
	  // votingconfig.put("annex",rs.getString("annex"));
	  // votingconfig.put("mainid",rs.getString("mainid"));
	  // votingconfig.put("subid",rs.getString("subid"));
	  // votingconfig.put("seccateid",rs.getString("seccateid"));
	   votingconfig.put("annex","on");  //统一开启附件上传
	   votingconfig.put("mainid","");
	   votingconfig.put("subid","");
	   votingconfig.put("seccateid","");
   }
   surveysubject=surveysubject.replaceAll("\"","&quot;");
   String votingconfigstr=(new JSONObject(votingconfig)).toString();
   String surveytitle=surveysubject;

%>



