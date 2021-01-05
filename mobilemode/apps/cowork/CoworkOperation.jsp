<%@page language="java" contentType="text/html;charset=UTF-8" %>
<%@page import="java.util.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="weaver.conn.ConnStatement" %>
<%@page import="weaver.conn.RecordSet" %>
<%@page import="weaver.cowork.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo" %>
<%@page import="weaver.hrm.company.DepartmentComInfo" %>
<%@page import="weaver.docs.docs.DocImageManager" %>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService" %>

<jsp:useBean id="CoworkItemMarkOperation" class="weaver.cowork.CoworkItemMarkOperation" scope="page" />
<jsp:useBean id="CoworkService" class="weaver.mobile.plugin.ecology.service.CoworkService" scope="page" />
<jsp:useBean id="CoworkShareManager" class="weaver.cowork.CoworkShareManager" scope="page" />
<jsp:useBean id="CoTypeComInfo" class="weaver.cowork.CoTypeComInfo" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />

<%!
public String showRelatedaccList(ArrayList relatedaccList,User user,int coworkid) throws Exception{
	    RecordSet recordSet=new RecordSet();
	    DocImageManager docImageManager=new DocImageManager(); 
	    String accStr="";
		for(int i=0;i<relatedaccList.size();i++){  
			recordSet.executeSql("select id,docsubject,accessorycount from docdetail where id="+relatedaccList.get(i));
            int linknum=-1;
          	if(recordSet.next()){
          		linknum++;
          		String showid = Util.null2String(recordSet.getString(1)) ;
              String tempshowname= Util.toScreen(recordSet.getString(2),user.getLanguage()) ;
              int accessoryCount=recordSet.getInt(3);

              docImageManager.resetParameter();
              docImageManager.setDocid(Integer.parseInt(showid));
              docImageManager.selectDocImageInfo();

              String docImagefileid = "";
              long docImagefileSize = 0;
              String docImagefilename = "";
              String fileExtendName = "";
              int versionId = 0;

              if(docImageManager.next()){
                //DocImageManager会得到doc第一个附件的最新版本
                docImagefileid = docImageManager.getImagefileid();
                docImagefileSize = docImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
                docImagefilename = docImageManager.getImagefilename();
                fileExtendName = docImagefilename.substring(docImagefilename.lastIndexOf(".")+1).toLowerCase();
                versionId = docImageManager.getVersionId();
              }
              if(accessoryCount>1){
                fileExtendName ="htm"; 
              }

             //String imgSrc=AttachFileUtil.getImgStrbyExtendName(fileExtendName,20);
             //accStr=accStr+imgSrc;
             if(accessoryCount==1 && (fileExtendName.equalsIgnoreCase("ppt")||fileExtendName.equalsIgnoreCase("pptx")||fileExtendName.equalsIgnoreCase("xls")||fileExtendName.equalsIgnoreCase("doc")||fileExtendName.equalsIgnoreCase("xlsx")||fileExtendName.equalsIgnoreCase("docx")))
            	 accStr=accStr+"<a href='javascript:void(0)'     onclick=\"opendoc('"+showid+"','"+versionId+"','"+docImagefileid+"','"+coworkid+"');return false;\" class='relatedLink'>"+docImagefilename+"</a>";
             else
				 accStr=accStr+"<a href='javascript:void(0)' onclick=\"opendoc1('"+showid+"','"+coworkid+"');return false;\" class='relatedLink'>"+docImagefilename+"</a>";
             if(accessoryCount==1){
            	 accStr=accStr+"&nbsp;<a href='javascript:void(0)'  onclick=\"downloads('"+docImagefileid+"',"+coworkid+",'"+docImagefilename+"');return false;\" class='relatedLink'>"+SystemEnv.getHtmlLabelName(258,user.getLanguage())+"("+(docImagefileSize/1000.0)+"K)</a><br>";
             }
		}
		}
		return accStr;
	}	
 %>
<%
out.clearBuffer();

request.setCharacterEncoding("UTF-8");

FileUpload fu=new FileUpload(request);
HrmResourceService hrs = new HrmResourceService();
int userid = Util.getIntValue(fu.getParameter("userid"));
User user = hrs.getUserById(userid);
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	
	return;
}
int coworkid = Util.getIntValue(fu.getParameter("coworkid"));
String operation = Util.null2String(fu.getParameter("operation"));
int replayid = Util.getIntValue(fu.getParameter("replayid"), 0);
int pageIndex = Util.getIntValue(fu.getParameter("pageindex"), 1);
int pageSize = Util.getIntValue(fu.getParameter("pagesize"), 10);
String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String remark = Util.null2String(fu.getParameter("remark"));
remark = URLDecoder.decode(remark,"utf-8");

String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
//System.out.println("module:"+module+"  scope:"+scope);
String keyword = Util.null2String(fu.getParameter("keyword"));
keyword = URLDecoder.decode(keyword, "utf-8");

String ctype = Util.null2String(fu.getParameter("ctype"));
if("".equals(ctype)){
	ctype = "all";
}
String labelid = Util.null2String(fu.getParameter("labelid"));
String important = Util.null2String(fu.getParameter("important"));
Map result = new HashMap();

if("getCoworkDetail".equals(operation)) {
	String join = "success_jsonpCallback(";
	JSONObject jsonobj = new JSONObject();
	boolean canView=CoworkShareManager.isCanView(""+coworkid,""+userid,"all");
	if (coworkid > 0 && canView) {
		CoworkDAO dao = new CoworkDAO(coworkid);
		CoworkItemsVO vo = dao.getCoworkItemsVO();
		String cname = Util.null2String(vo.getName());                 //协作名称
		String ccreater = Util.null2String(vo.getCreater());           //协作创建人
		String cprincipal=Util.null2String(vo.getPrincipal());         //协作负责人
		String ctypeid=Util.null2String(vo.getTypeid());               //所属协作区
		String cbegindate = Util.null2String(vo.getBegindate());       //开始日期
		String cbeingtime = Util.null2String(vo.getBeingtime());       //开始时间      
		String cenddate = Util.null2String(vo.getEnddate());           //结束日期
		String cendtime = Util.null2String(vo.getEndtime());           //结束时间
		String cremark = Util.null2String(vo.getRemark()).trim();	   //详细描述
		String capprovalAtatus=vo.getApprovalAtatus();                 //审批状态，待审批
		//添加查看者记录
		String sql="select id from cowork_read where coworkid="+coworkid+" and userid="+userid;
		RecordSet rs = new RecordSet();
		rs.execute(sql);  
		if(!rs.next()){
			sql="insert into cowork_read(coworkid,userid) values("+coworkid+","+userid+")";
			rs.execute(sql);
		}
	
		//添加查看日志
		dao.addCoworkLog(coworkid,2,userid,fu);
		
		ResourceComInfo rci = new ResourceComInfo();
/* 		join += "name:\""+ cname+"\",creater:\""+rci.getResourcename(ccreater)+"\",principal:\""+rci.getResourcename(cprincipal)+"\",typeid:\""+ctypeid+"\",begindate:\""+cbegindate+
			"\",beingtime:\""+cbeingtime+"\",enddate:\""+cenddate+"\",endtime:\""+cendtime+"\",remark:\""+cremark+"\",approvalAtatus:\""+capprovalAtatus+"\"";
 */		
 		jsonobj.put("name", cname);
 		jsonobj.put("creater", rci.getResourcename(ccreater));
 		jsonobj.put("principal", rci.getResourcename(cprincipal));
 		jsonobj.put("typeid", ctypeid);
 		jsonobj.put("begindate", cbegindate);
 		jsonobj.put("beingtime", cbeingtime);
 		jsonobj.put("enddate", cenddate);
 		jsonobj.put("endtime", cendtime);
 		jsonobj.put("remark", cremark);
 		jsonobj.put("approvalAtatus", capprovalAtatus);
	}
	join +=jsonobj.toString()+")";
	out.println(join);
} else if("saveCowork".equals(operation))	{
	//result = CoworkService.submitCowork(user, remark, coworkid, replayid);
	//JSONObject json = JSONObject.fromObject(result);
	//out.print(json.toString());
} else if("getCoworkList".equals(operation)) {
	String condition = "";
	if(keyword!=null && !"".equals(keyword)) {
		condition = (" (name like '%"+keyword+"%') ");
	}
	
		RecordSet recordSet = new RecordSet();
		List list = new ArrayList();
		int count = 0;
		int pageCount = 0;
		int isHavePre = 0;
		int isHaveNext = 0;
		
		if(user != null) {

			int departmentid=user.getUserDepartment();   //用户所属部门
			int subCompanyid=user.getUserSubCompany1();  //用户所属分部
			String seclevel=user.getSeclevel();          //用于安全等级
			
			
			
			weaver.cowork.CoworkService coworkService=new weaver.cowork.CoworkService();
			String baseSql="("+
				" select t1.id,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.replyNum,t1.readNum,t1.lastdiscussant,t1.lastupdatedate,t1.lastupdatetime,t1.isApproval,t1.approvalAtatus,t1.isTop,t2.cotypeid,"+
				" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
				" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
				" case when  t5.coworkid is not null then 1 else 0 end as important,"+
				" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
				(ctype.equals("label")?" ,case when  t7.coworkid is not null then 1 else 0 end as islabel":"")+
				" from cowork_items  t1 left join "+
				//关注的协作
				" ( "+coworkService.getManagerShareSql(userid+"")+" )  t2 on t1.typeid=t2.cotypeid left join "+ 
		        //直接参与的协作
				" ("+coworkService.getPartnerShareSql(userid+"")+")  t3 on t3.sourceid=t1.id"+
		        //阅读|重要|隐藏
				" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
				" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
				" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
				(ctype.equals("label")?" left join (select distinct coworkid from cowork_item_label where labelid="+labelid+") t7 on t1.id=t7.coworkid":"")+ 
				" ) t ";
			
			//暂时只能查看已经审批过的协作
			baseSql=baseSql+" where status =1 and (approvalAtatus=0 or (approvalAtatus=1 and (creater="+userid+" or principal="+userid+" or cotypeid is not null))) and jointype is not null ";
			
			if(!"".equals(condition)) {
					baseSql += " and " + condition + " ";
			}
			
			/* if(labelid == -1){
				baseSql += " and isnew=1 and ishidden<>1 ";
			}else if(labelid == -2){
				baseSql += " and important=1 and ishidden<>1 ";
			}else if(labelid == -3){
				baseSql += " and ishidden=1 ";
			}else if(labelid > 0){
	        	baseSql = baseSql+" and typeid = (select name from cowork_label where id = "+labelid+")";
	        }else {
	        	baseSql += " and ishidden<>1 ";
	        } */
			
			if("unread".equals(ctype)){
				baseSql=baseSql+" and isnew=1 and ishidden<>1";
			}else if("important".equals(ctype)){
				baseSql=baseSql+" and important=1 and ishidden<>1";
			}else if("hidden".equals(ctype)){
				baseSql=baseSql+" and ishidden=1";
			}else if("all".equals(ctype)){
				baseSql=baseSql+" and ishidden<>1";
			}else if("label".equals(ctype)){
	        	baseSql=baseSql+" and ishidden<>1 and islabel=1";
	        }else if("typePlate".equals(ctype)){
	        	baseSql = baseSql+" and typeid = (select name from cowork_label where id = "+labelid+")";
	        }
			String countSql = " select count(*) as c from " + baseSql;
			RecordSet rs = new RecordSet();
			rs.executeSql(countSql);
			if(rs.next())
				count = rs.getInt("c");
			
			if(pageIndex <=0 ) pageIndex = 1;
			if(pageSize <=0 ) pageSize = 10;
			
			if (count <= 0) pageCount = 0;
			pageCount = count / pageSize + ((count % pageSize > 0)?1:0);
			
			isHaveNext = (pageIndex + 1 <= pageCount)?1:0;

			isHavePre = (pageIndex - 1 >= 1)?1:0;
			
			String splitSql = "";
			if(recordSet.getDBType().equals("oracle")){
				splitSql = "select *  from "+baseSql+" order by jointype desc,isnew desc,important desc,id desc";
				
				splitSql = "select t1.*,rownum rn from (" + splitSql + ") t1 where rownum <= " + (pageIndex * pageSize);
				splitSql = "select t2.* from (" + splitSql + ") t2 where rn > " + ((pageIndex-1) * pageSize);
			}else{
				if(pageIndex>1) {
					int topSize = pageSize;
					if(pageSize * pageIndex > count) {
						topSize = count - (pageSize * (pageIndex - 1));
					}
					splitSql = "select top "+(pageIndex * pageSize)+" *  from "+baseSql+" order by jointype desc,isnew desc,important desc,id desc";
					
					splitSql = "select top " + topSize +" t1.* from (" + splitSql + ") t1 order by t1.jointype asc,t1.isnew asc,t1.important asc,t1.id asc";
					splitSql = "select top " + topSize +" t2.* from (" + splitSql + ") t2 order by t2.jointype desc,t2.isnew desc,t2.important desc,t2.id desc";
				} else {
					splitSql = "select top "+pageSize+" *  from "+baseSql+" order by jointype desc,isnew desc,important desc,id desc";
				}
			}
			ConnStatement statement=new ConnStatement();
			try {
				if(pageIndex <= pageCount) {
					ResourceComInfo rci = new ResourceComInfo();
					statement.setStatementSql(splitSql);
					statement.executeQuery();
					
					while(statement.next()){
						int cid=statement.getInt("id");
						Map map = new HashMap();
						
						map.put("id", ""+cid);
						map.put("isnew", Util.null2o(statement.getString("isnew")));
						map.put("subject", Util.null2String(statement.getString("name")));
						map.put("important", Util.null2o(statement.getString("important")));
						map.put("approvalAtatus", Util.null2o(statement.getString("approvalAtatus")));
						
						List label = new ArrayList();
						rs.execute("select t2.id,t2.name,t2.labelColor,t2.textColor from cowork_item_label t1,cowork_label t2 where t2.userid='"+userid+"' and t1.coworkid='"+cid+"' and t1.Labelid=t2.id");
				    	while(rs.next()){
				    		Map lab = new HashMap();
				    		
				    		lab.put("id", rs.getString("id"));
				    		lab.put("name", rs.getString("name"));
				    		lab.put("labelColor", rs.getString("labelColor"));
				    		lab.put("textColor", rs.getString("textColor"));
				    		
				    		label.add(lab);
				    	}
				    	
				    	//最新评论
				    	String lastdisstr="无";
				    	rs.execute("select * from cowork_discuss where coworkid="+cid+" order by id desc");
				    	if(rs.next()){
				    		String discussant = Util.null2String(rs.getString("discussant"));
							String dimg = rci.getMessagerUrls(discussant);//照片
							String dname = rci.getResourcename(discussant);//姓名
							String createdate = Util.null2String(rs.getString("createdate"));  //最新回复日期
							String createtime = Util.null2String(rs.getString("createtime"));  //最新回复时间
							String posttime = createdate+"&nbsp;"+createtime;//最新发表时间
				    		//lastdisstr = dname+"<img src='"+dimg+"'>于"+posttime+"回复";
				    		lastdisstr = dname+"于"+posttime+"回复";
				    	}
				    	map.put("lastdisstr", lastdisstr);
						
						list.add(map);
				    }
				}
				result.put("datas",list);
				result.put("totalSize",count+"");
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				statement.close();
			}
		} else {
			result.put("error", "200001");
		}
		if(count == 0){
			out.print("{\"totalSize\":0, \"datas\":[]}");
			return;
		}
		JSONObject json = JSONObject.fromObject(result);
		out.print(json.toString());
}else if("getDetalilCoworkList".equals(operation)){
		Map<String, Object> detail = new HashMap<String, Object>();
		int count = 0;
		int pageCount = 0;
		int isHavePre = 0;
		int isHaveNext = 0;
		
		List coworks = new ArrayList();
		
		if(pageSize <= 0) {
			pageSize = 20;
		}
		if(pageIndex <= 0) pageIndex = 1;
		
		try {
			if(user != null) {
				CoworkShareManager csm = new CoworkShareManager();
				boolean canView = csm.isCanView(""+coworkid,""+userid,"all");
				if(canView) {
					detail.put("status", "1");
					
					ResourceComInfo rci = new ResourceComInfo();
					DepartmentComInfo dci = new DepartmentComInfo();
					CoworkDAO dao = new CoworkDAO(coworkid);
					count =dao.getDiscussVOListCount("");
					
					pageCount = count / pageSize;
					if(count - pageCount * pageSize > 0) pageCount = pageCount + 1;
					
					isHaveNext = (pageIndex + 1 <= pageCount)?1:0;
					isHavePre = (pageIndex - 1 >= 1)?1:0;
					
					if(pageIndex <= pageCount) {
						List list = dao.getDiscussVOList(pageIndex, pageSize, "");
						
						if(list != null && list.size() > 0) {
							for(int k=0;k<list.size();k++){
								CoworkDiscussVO vo = (CoworkDiscussVO)list.get(k);
								
								Map<String, Object> cowork = new HashMap<String, Object>();
								cowork.put("id", vo.getId());
								cowork.put("coworkid", vo.getCoworkid());
								String discussant = Util.null2String(vo.getDiscussant());
								cowork.put("image", rci.getMessagerUrls(discussant));//照片
								cowork.put("floorNum", vo.getFloorNum());//楼号
								cowork.put("name", rci.getResourcename(discussant));//姓名
								cowork.put("deptname", dci.getDeptnames(rci.getDepartmentID(discussant)));//部门
								String createdate = Util.null2String(vo.getCreatedate());  //创建日期
								String createtime = Util.null2String(vo.getCreatetime());  //创建时间
								cowork.put("posttime", CoworkTransMethod.getFormateDate(createdate,createtime));//发表时间
								String remark2 = Util.null2String(vo.getRemark());//回复内容
								remark2 = remark2.replaceAll("src=", "src-lazy=");
								cowork.put("remark2html", Util.StringReplace(remark2.trim(),"\r\n",""));
								cowork.put("relatedacc", showRelatedaccList(vo.getRelatedaccList(),user,Util.getIntValue(vo.getId())));
								StringBuffer replaystr = new StringBuffer("");
								String rid=Util.null2String(vo.getReplayid());
								if(!"".equals(rid) && !"0".equals(rid)) {
									CoworkDiscussVO discussvo=dao.getCoworkDiscussVO(rid);
									if(discussvo!=null){
										replaystr.append("<div class='commentReply'>");
										replaystr.append("引用 ").append(discussvo.getFloorNum()).append("# ").append(rci.getResourcename(discussvo.getDiscussant())).append(" ").append(discussvo.getCreatedate()).append(" ").append(discussvo.getCreatetime()).append("");
										String str1 = discussvo.getRemark().trim();
										str1 = str1.replaceAll("src=", "src-lazy=");
										replaystr.append("<div class='commentReplyContent'>").append(Util.StringReplace(str1,"\n","<br>")).append("</div>");
										replaystr.append("<div class='commentReplyRelate'>").append(showRelatedaccList(discussvo.getRelatedaccList(),user,Util.getIntValue(discussvo.getId()))).append("</div>");
										replaystr.append("</div>");
									}
								}
								cowork.put("replay", replaystr.toString());
								//评论
								List commentList=dao.getCommentList(vo.getId());
								StringBuffer commentstr = new StringBuffer("");
								if(commentList.size()>0){
									commentstr.append("<div class='commentReply2'><ul class='reply'>");
									for(int j=0;j<commentList.size();j++){
										CoworkDiscussVO commentvo=(CoworkDiscussVO)commentList.get(j);
					       		     	String commentdiscussant=commentvo.getDiscussant();
					       		     	String commentdiscussid=commentvo.getId();
					       		     	String commentuserid=commentvo.getCommentuserid();
					       		     	String comemntremark=commentvo.getRemark();
					       		     	comemntremark = comemntremark.replaceAll("src=", "src-lazy=");
					       		     	commentstr.append("<li>").append(rci.getResourcename(commentdiscussant)).append(" ").append(CoworkTransMethod.getFormateDate(commentvo.getCreatedate(),commentvo.getCreatetime())).append("<br/>").append(comemntremark).append("</li>");
									}
									commentstr.append("</ul></div>");
								}
								cowork.put("commentstr", commentstr.toString());
								coworks.add(cowork);
							}
						}
					}
				} else {
					detail.put("status", "0");
				}
			} else {
				detail.put("error", "no data");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		detail.put("datas",coworks);
		detail.put("totalSize",count+"");
			
		if(count == 0){
			out.print("{\"totalSize\":0, \"datas\":[]}");
			return;
		}
		JSONObject json = JSONObject.fromObject(detail);
		out.print(json.toString());
}else if("getrelatedmeCoworkList".equals(operation)){
		Map<String, Object> detail = new HashMap<String, Object>();
		int count = 0;
		int pageCount = 0;
		int isHavePre = 0;
		int isHaveNext = 0;
		
		List coworks = new ArrayList();
		
		if(pageSize <= 0) {
			pageSize = 20;
		}
		if(pageIndex <= 0) pageIndex = 1;
		
		try {
			if(user != null) {
				CoworkShareManager csm = new CoworkShareManager();
				boolean canView = csm.isCanView(""+coworkid,""+userid,"all");
				if(canView) {
					detail.put("status", "1");
					
					ResourceComInfo rci = new ResourceComInfo();
					DepartmentComInfo dci = new DepartmentComInfo();
					CoworkDAO dao = new CoworkDAO(coworkid);
					//count =dao.getDiscussVOListCount("");
					count =dao.getDiscussReplayListCount(""+userid,""+coworkid,"");
					
					pageCount = count / pageSize;
					if(count - pageCount * pageSize > 0) pageCount = pageCount + 1;
					
					isHaveNext = (pageIndex + 1 <= pageCount)?1:0;
					isHavePre = (pageIndex - 1 >= 1)?1:0;
					
					if(pageIndex <= pageCount) {
						List list = dao.getDiscussReplayList(pageIndex, pageSize, ""+userid,""+coworkid,"");
						if(list != null && list.size() > 0) {
							for(int k=0;k<list.size();k++){
							
								CoworkDiscussVO vo = (CoworkDiscussVO)list.get(k);
								
								Map<String, Object> cowork = new HashMap<String, Object>();
								cowork.put("id", vo.getId());
								cowork.put("coworkid", vo.getCoworkid());
								String discussant = Util.null2String(vo.getDiscussant());
								cowork.put("image", rci.getMessagerUrls(discussant));//照片
								cowork.put("floorNum", vo.getFloorNum());//楼号
								cowork.put("name", rci.getResourcename(discussant));//姓名
								cowork.put("deptname", dci.getDeptnames(rci.getDepartmentID(discussant)));//部门
								String createdate = Util.null2String(vo.getCreatedate());  //创建日期
								String createtime = Util.null2String(vo.getCreatetime());  //创建时间
								cowork.put("posttime", CoworkTransMethod.getFormateDate(createdate,createtime));//发表时间
								String remark2 = Util.null2String(vo.getRemark());//回复内容
								remark2 = remark2.replaceAll("src=", "src-lazy=");
								cowork.put("remark2html", Util.StringReplace(remark2.trim(),"\r\n",""));
								cowork.put("relatedacc", showRelatedaccList(vo.getRelatedaccList(),user,Util.getIntValue(vo.getId())));
								StringBuffer replaystr = new StringBuffer();
								String rid=Util.null2String(vo.getReplayid());
								if(!"".equals(rid) && !"0".equals(rid)) {
									CoworkDiscussVO discussvo=dao.getCoworkDiscussVO(rid);
									if(discussvo!=null){
										replaystr.append("<div class='commentReply'>");
										replaystr.append("引用 ").append(discussvo.getFloorNum()).append("#").append(rci.getResourcename(discussvo.getDiscussant())).append(" ").append(discussvo.getCreatedate()).append(" ").append(discussvo.getCreatetime()).append("");
										String str1 = discussvo.getRemark().trim();
										str1 = str1.replaceAll("src=", "src-lazy=");
										replaystr.append("<div class='commentReplyContent'>").append(Util.StringReplace(str1,"\n","<br>")).append("</div>");
										replaystr.append("<div class='commentReplyRelate'>").append(showRelatedaccList(discussvo.getRelatedaccList(),user,Util.getIntValue(discussvo.getId()))).append("</div>");
										replaystr.append("</div>");
									}
								}
								cowork.put("replay", replaystr.toString());
								//评论
								List commentList=dao.getCommentList(vo.getId());
								StringBuffer commentstr = new StringBuffer("");
								if(commentList.size()>0){
									commentstr.append("<div class='commentReply2'><ul class='reply'>");
									for(int j=0;j<commentList.size();j++){
										CoworkDiscussVO commentvo=(CoworkDiscussVO)commentList.get(j);
					       		     	String commentdiscussant=commentvo.getDiscussant();
					       		     	String commentdiscussid=commentvo.getId();
					       		     	String commentuserid=commentvo.getCommentuserid();
					       		     	String comemntremark=commentvo.getRemark();
					       		     	comemntremark = comemntremark.replaceAll("src=", "src-lazy=");
					       		     	commentstr.append("<li>").append(rci.getResourcename(commentdiscussant)).append("  ").append(CoworkTransMethod.getFormateDate(commentvo.getCreatedate(),commentvo.getCreatetime())).append("<br>").append("</li>");
									}
									commentstr.append("</ul></div>");
								}
								cowork.put("commentstr", commentstr.toString());
								coworks.add(cowork);
							}
						}
					}
				} else {
					detail.put("status", "0");
				}
			} else {
				detail.put("error", "no data");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		detail.put("datas",coworks);
		detail.put("totalSize",count+"");
			
		if(count == 0){
			out.print("{\"totalSize\":0, \"datas\":[]}");
			return;
		}
		JSONObject json = JSONObject.fromObject(detail);
		out.print(json.toString());
}else if("getjoinCowork".equals(operation)){
		JSONObject jsonobj = new JSONObject();
		CoworkShareManager csm = new CoworkShareManager();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		
		StringBuffer aliststr = new StringBuffer("");
		List alist=csm.getShareConditionStrList(""+coworkid);
		for(int i=0;i<alist.size();i++){
 			HashMap hm=(HashMap)alist.get(i);
			String type=Util.null2String(hm.get("type"));
			int typelabel=Util.getIntValue((String)hm.get("typeName"));	
			aliststr.append("<li>").append(SystemEnv.getHtmlLabelName(typelabel, user.getLanguage())).append(Util.null2String(hm.get("contentName")));
			if(!type.equals("1")){
				aliststr.append("&nbsp;&nbsp;&nbsp;").append(hm.get("seclevel")).append("-").append(hm.get("seclevelMax"));
			}  	   
			aliststr.append("</li>") ;
		}
		String stralin = "";
		if(!"".equals(aliststr)){
			stralin = "<ul class='ajoin'><li>参与条件</li>"+aliststr.toString()+"</ul>";
		}
		jsonobj.put("ajoin", stralin);
		
		String parteridsstr = "";
		List parterids=csm.getShareList("parter",""+coworkid);
		StringBuffer pstr = new StringBuffer("");
		for(int i=0;i<parterids.size()&&i<10;i++){
 			String resourceid=(String)parterids.get(i);       
			pstr.append(Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())).append("&nbsp;");
		}
		if(parterids.size()>10){
			pstr.append("<a href=\"javascript:void(0);\"; ontap=\"showall('"+userid+"','"+coworkid+"',1)\" >全部</a>");
		}
		List  typemanagerids=csm.getShareList("typemanager",""+coworkid);
		StringBuffer tstr = new StringBuffer("");
		for(int i=0;i<typemanagerids.size()&&i<10;i++){
 			String resourceid=(String)typemanagerids.get(i);       
			tstr.append(Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())).append("&nbsp;");
		}
		if(typemanagerids.size()>10){
			tstr.append("<a href=\"javascript:void(0);\"; ontap=\"showall('"+userid+"','"+coworkid+"',2)\" >全部</a>");
		}
		parteridsstr+="<ul class='parterul'><li>参与人员</li><li>"+SystemEnv.getHtmlLabelName(17689, user.getLanguage())+"&nbsp;&nbsp;&nbsp;<div id='showall1' style='display:inline;'>"+pstr.toString()+"</div></li><li>"+SystemEnv.getHtmlLabelName(25472, user.getLanguage())+"&nbsp;&nbsp;&nbsp;<div id='showall1' style='display:inline;'>"+tstr.toString()+"</div></li></ul>";		
		jsonobj.put("parteridsstr", parteridsstr);
		
		String noReadidsstr = "";
		StringBuffer nstr= new StringBuffer("");
		List noReadids=csm.getNoreadUseridList(""+coworkid);
		for(int i=0;i<noReadids.size()&&i<10;i++){
			String resourceid=(String)noReadids.get(i);
			nstr.append(Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())).append("&nbsp;");
		}
		if(noReadids.size()>10){
			nstr.append("<a href=\"javascript:void(0);\"; ontap=\"showall('"+userid+"','"+coworkid+"',3)\" >全部</a>");
		}
		noReadidsstr+="<ul class='noReadidsstrul'><li>未查看者</li><li>未查看者&nbsp;&nbsp;&nbsp;<div id='showall3' style='display:inline;'>"+nstr.toString()+"</div></li></ul>";
		jsonobj.put("noReadidsstr", noReadidsstr);
		
		out.print(jsonobj.toString());
}else if("alljoinCowork".equals(operation)){
		String showtype= Util.null2String(fu.getParameter("showtype"));
		JSONObject jsonobj = new JSONObject();
		CoworkShareManager csm = new CoworkShareManager();
		ResourceComInfo resourceComInfo = new ResourceComInfo();
		if("1".equals(showtype)){
			List parterids=csm.getShareList("parter",""+coworkid);
			String pstr = "";
			for(int i=0;i<parterids.size();i++){
	 			String resourceid=(String)parterids.get(i);       
				pstr += Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())+"&nbsp;";
			}
			jsonobj.put("showall1", pstr);
		}else if("2".equals(showtype)){
			String tstr = "";
			List  typemanagerids=csm.getShareList("typemanager",""+coworkid);
			for(int i=0;i<typemanagerids.size();i++){
	 			String resourceid=(String)typemanagerids.get(i);       
				tstr += Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())+"&nbsp;";
			}
			jsonobj.put("showall2", tstr);
		}else{
			String nstr="";
			List noReadids=csm.getNoreadUseridList(""+coworkid);
			for(int i=0;i<noReadids.size();i++){
				String resourceid=(String)noReadids.get(i);
				nstr += Util.toScreen(resourceComInfo.getResourcename((String)resourceid),user.getLanguage())+"&nbsp;";
			}
			jsonobj.put("showall3", nstr);
		}
		out.print(jsonobj.toString());
}else if("getlabellist".equals(operation)) {
	String json = "{";
	String labelstr = "[";
	List labelList=CoworkItemMarkOperation.getLabelList(userid+"","all");          //标签列表
	for(int i=0;i<labelList.size();i++){ 
         CoworkLabelVO labelVO=(CoworkLabelVO)labelList.get(i);
         String isUsed=labelVO.getIsUsed();
         if(isUsed.equals("0")) continue;
         String id=labelVO.getId();
         String labelType=labelVO.getLabelType();
         String labelName=labelVO.getName();
         if(labelName.equals("17694"))  continue;//过滤掉协作区标签
         
         if(labelType.equals("label")){
      	   labelName=labelVO.getName();
         }else if(labelType.equals("typePlate")){
        	   labelName = CoTypeComInfo.getCoTypename(labelVO.getName());
         }else{
      	   labelName=SystemEnv.getHtmlLabelName(Util.getIntValue(labelVO.getName()),user.getLanguage());
         }
         //labelstr +="<label ontap='openDetail(\"mobilemode:refreshList:687::ctype="+labelType+"&label="+id+":listStatusChanged\",null,{\"refreshedCallbackParamData\":"+labelName+"});'>"+labelName+"</label>";
  	  	labelstr+="{\"id\":\""+id+"\",\"labelType\":\""+labelType+"\",\"labelName\":\""+labelName+"\"},";
    }
    if(labelstr.length()>1){
    	labelstr = labelstr.substring(0, labelstr.length()-1);  
    }   
    labelstr = labelstr+"]";
    json += "\"labelstr\":"+labelstr+"}";
	out.print(json);
}else if("markimportant".equals(operation)) {
	ArrayList coworkidList = Util.TokenizerString(""+coworkid,",");
	CoworkDAO dao=new CoworkDAO();
	String flag="";
	for(int i=0;i < coworkidList.size(); i++){
			String cid = (String)coworkidList.get(i);
			flag+= CoworkItemMarkOperation.markItemAsType(user.getUID()+"",cid,important)+",";
			//添加已读记录
			if(important.equals("read"))
				dao.addCoworkLog(coworkid,2,user.getUID(),fu);
		}	
	result.put("flag", flag);
	JSONObject json = JSONObject.fromObject(result);
	out.print(json.toString());	
}else if("showReplay".equals(operation)) {
	JSONObject json = new JSONObject();
	try{
		String extendField=Util.null2String(fu.getParameter("extendField"));
		String content=Util.null2String(fu.getParameter("content"));
		json.put("extendField", extendField);
		json.put("content", content);
		json.put("status", "1");
	}catch(Exception ex){
		ex.printStackTrace();
		result.put("status", "0");
		String errMsg = Util.null2String(ex.getMessage());
		errMsg = URLEncoder.encode(errMsg, "UTF-8");
		errMsg = errMsg.replaceAll("\\+","%20");
		json.put("errMsg", errMsg);
	}
	out.print("<script type=\"text/javascript\">parent.Mobile_NS.operationResponse("+json.toString()+");</script>");

}
else if("important".equals(operation)) {
	result = CoworkService.markCoworkItemAsType(coworkid, "important", user);
	JSONObject json = JSONObject.fromObject(result);
	out.print(json.toString());
} else if("normal".equals(operation)) {
	result = CoworkService.markCoworkItemAsType(coworkid, "normal", user);
	JSONObject json = JSONObject.fromObject(result);
	out.print(json.toString());
}
%>