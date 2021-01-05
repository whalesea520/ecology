<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@page import="java.util.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="weaver.general.Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.general.Util" %>
<%@page import="java.sql.Timestamp" %>
<%@page import="weaver.conn.ConnStatement" %>
<%@page import="weaver.conn.RecordSet" %>
<%@page import="weaver.cowork.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.hrm.resource.ResourceComInfo" %>
<%@page import="weaver.hrm.job.JobTitlesComInfo" %>
<%@page import="weaver.hrm.company.DepartmentComInfo" %>
<%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService" %>

<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.AppDao"%>
<%@page import="weaver.blog.webservices.BlogServiceImpl"%>

<jsp:useBean id="blogDao" class="weaver.blog.BlogDao"></jsp:useBean> 
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />

<%
out.clearBuffer();
request.setCharacterEncoding("UTF-8");
FileUpload fu=new FileUpload(request);
HrmResourceService hrs = new HrmResourceService();
String userid = Util.null2String(fu.getParameter("userid"));
User user = hrs.getUserById(Util.getIntValue(userid));
if(user==null) {
	Map result = new HashMap();
	//未登录或登录超时
	result.put("error", "200001");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}

String blogid=Util.null2String(fu.getParameter("blogid"));  //微博id
String fromPage=Util.null2String(fu.getParameter("page"));
String startDate=Util.null2String(fu.getParameter("startDate"));
String endDate=Util.null2String(fu.getParameter("endDate"));
String operation=Util.null2String(fu.getParameter("operation")); //请求类型
String ac=Util.null2String(fu.getParameter("ac"));                   //查询来自页面
String content=Util.null2String(fu.getParameter("content")).replace("'","''");         //搜索内容
String submitdate=Util.null2String(fu.getParameter("submitdate"));  //提交时间分割线，最后显示时间
String attentionWorkDate=Util.null2String(fu.getParameter("workDate"));//我的关注，指定工作日

int currentpage=Util.getIntValue(fu.getParameter("currentpage"),1);  //页数
int pagesize=Util.getIntValue(fu.getParameter("pagesize"),20);       //每页显示条数
int total=Util.getIntValue(fu.getParameter("total"),0);              //总数

int minUpdateid=Util.getIntValue(request.getParameter("minUpdateid"),0);  //存贮已经取出来的更新提醒最小id

String isFirstPage=Util.null2String(request.getParameter("isFirstPage")); //我的微博页面判断是否为第一页，第一页才返回编辑器

String groupid=Util.null2String(request.getParameter("groupid"));  //微博分组id
groupid=groupid.equals("")?"all":groupid;

BlogManager blogManager=new BlogManager(user);

if("".equals(blogid)){
	blogid=""+user.getUID();
}else{
	BlogShareManager shareManager=new BlogShareManager();
	int status=shareManager.viewRight(blogid,userid); //微博查看权限
	if(status<=0){
	  return ;	
	}
}

SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("M月dd日");
SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");
SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");

Date today=new Date();
String todaydate=dateFormat1.format(today);
String curDate=dateFormat1.format(today);
//submitdate=submitdate.equals("")?curDate:submitdate;  //提交日期

int isNeedSubmit=0;
int todayIsReplayed=0; //今天是否被评论过，如果被评论过就显示今天内容

//检查当前用户 当天是否需要提交
if(!isFirstPage.equals("false")&&userid.equals(blogid)&&operation.equals("myblog")){
   isNeedSubmit=blogDao.isNeedSubmit(user,curDate);
   if(blogDao.getReplyList(userid,curDate,userid).size()>0)
		todayIsReplayed=1;
}

String isManagerScore=blogDao.getSysSetting("isManagerScore");  //启用上级评分

Date startdateTemp=new Date();
String enableDate="";
String startTmep="";
String endTemp="";
Map conditions=new HashMap();
List updateList=new ArrayList();   //获得更新提醒id list
List discussList=new ArrayList();  //微博记录list
Map  discussMap=null;
Map result = new HashMap();
AppDao appDao=new AppDao();
boolean moodIsActive=appDao.getAppVoByType("mood").isActive();
//周日 周一 周二 周三 周四 周五 周六 
String []week={SystemEnv.getHtmlLabelName(16106,user.getLanguage()),SystemEnv.getHtmlLabelName(16100,user.getLanguage()),SystemEnv.getHtmlLabelName(16101,user.getLanguage()),SystemEnv.getHtmlLabelName(16102,user.getLanguage()),SystemEnv.getHtmlLabelName(16103,user.getLanguage()),SystemEnv.getHtmlLabelName(16104,user.getLanguage()),SystemEnv.getHtmlLabelName(16105,user.getLanguage())};
if(operation.equals("homepage")){      //微博主页
	Map<String, Object> detail = new HashMap<String, Object>();
	List datas = new ArrayList();
	try{
		ResourceComInfo resourceComInfo=new ResourceComInfo();
		JobTitlesComInfo jobTitlesComInfo=new JobTitlesComInfo();
			
		List attentionList=blogManager.getMyAttention(userid,groupid);
		String attentionids="";                                 //所有我关注的人集合,包含自身
		for(int i=0;i<attentionList.size();i++){
			attentionids=attentionids+","+attentionList.get(i);
		}
		if(groupid.equals("all"))
			attentionids+=","+userid;
		attentionids=attentionids.length()>0?attentionids.substring(1):attentionids;
		conditions.put("attentionids",attentionids);
		if(total==0){
			total=blogDao.getBlogDiscussCount(conditions);
		}
		updateList=blogDao.getUpdateDiscussidList(userid);
		discussList=blogManager.getBlogDiscussVOList(userid,currentpage, pagesize,total,conditions);
		
		
		if(discussList.size()>0){
			for(int i=0;i<discussList.size();i++){
				Map map = new HashMap();
				BlogDiscessVo discessVo=(BlogDiscessVo)discussList.get(i);
				if(discessVo==null)
					continue;
				String discussid=discessVo.getId();
				map.put("discussid", Util.null2String(discussid));
				String workdate=discessVo.getWorkdate();
				String showdate=workdate;
				long   todaytime=today.getTime(); 
				long   worktime=dateFormat1.parse(workdate).getTime(); 
				//获取某个工作日到今天已经几天了
				long daysFromWorkDate=(todaytime-worktime)/(24*60*60*1000);
				
				String managerstr=resourceComInfo.getManagersIDs(discessVo.getUserid());
				String createdate="";
				if(discussid!=null)
					createdate=discessVo.getCreatedate();
				else
					createdate=attentionWorkDate;
					
				////提交时间分割线
				boolean isShowDate=false;
				String subline = "";
				if(!createdate.equals(submitdate)){
					submitdate=createdate;
					Date dateTemp=new Date();
					dateTemp.setDate(dateTemp.getDate()-1);
					String yesterday=dateFormat1.format(dateTemp);      //昨天
					dateTemp.setDate(dateTemp.getDate()-1);
					String beforeyesterday=dateFormat1.format(dateTemp);//前天
					String weekday=week[dateFormat1.parse(submitdate).getDay()];
					
					if(submitdate.equals(yesterday))
						weekday="昨天";
					else if(submitdate.equals(beforeyesterday))
						weekday="前天";
					isShowDate=true;
					showdate=submitdate;
					subline = "以下是"+dateFormat2.format(dateFormat1.parse(submitdate))+"/"+weekday+"&nbsp;&nbsp;提交内容";
				}
				String divsubline = "<div class=\"seprator\"><div class=\"bg_1\" align=\"center\"><div class=\"bg_2\">"+subline+"</div></div></div>";
				map.put("divsubline", divsubline);
				String comefrom=discessVo.getComefrom();
				String comefromTemp="";
				if(comefrom.equals("1"))  
					comefromTemp="(来自Iphone)";
				else if(comefrom.equals("2"))  
					comefromTemp="(来自Ipad)";
				else if(comefrom.equals("3"))  
					comefromTemp="(来自Android)";          
				else if(comefrom.equals("4"))  
					comefromTemp="(来自Web手机版)";
			    else
			    	comefromTemp="";       	
				AppItemVo  appItemVo=null;
				if(moodIsActive)
				  appItemVo=appDao.getappItemByDiscussId(discussid); 
				String faceimg = "";
				if(appItemVo!=null){
					faceimg = "<div class=\"rowWrap\" style=\"float:right;\"><img  width=\"16px\" src=\""+appItemVo.getFaceImg()+"\" /></div>" ;
				}
		
				//地理位置
				List locationList=blogDao.getLocationList(discussid);
				
				String discussuserid=discessVo.getUserid();            //发表人id
				String isnew=updateList.contains(discussid)?"0":"1";  // 0未读  1 已读
				
				String commentstr ="";
				int repnum1 = 0;
				int repnum2 = 0;
				List replyList=blogDao.getReplyList(discussuserid, discessVo.getWorkdate(), userid);
				//BlogReplyVo replyArray[]=new BlogReplyVo[replyList.size()];
				if(replyList.size()>0){
					commentstr ="<div class='commentReply'><ul class='reply'>";
					for(int j=0;j<replyList.size();j++){
						BlogReplyVo replyVo=(BlogReplyVo)replyList.get(j);
						String replyid = Util.null2String(replyVo.getId());
						String replyUserid=replyVo.getUserid();
						String replyUsername=resourceComInfo.getLastname(replyUserid);
						String commentType = Util.null2String(replyVo.getCommentType());//私评1
						if("1".equals(commentType)){
							repnum2++;
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"(私评)<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','homepage');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','homepage');\"></div><br>";
						}else{
							repnum1++;
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','homepage');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','homepage');\"></div><br>";
						}
						//commentstr+="<li>"+Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
						commentstr+=Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
					}
					commentstr+="</ul></div>";
				}
				map.put("workdate", workdate);
				map.put("replycomments", commentstr);
				map.put("discussuserid", discussuserid);
				map.put("username", resourceComInfo.getLastname(discussuserid));
				map.put("userimg", resourceComInfo.getMessagerUrls(discussuserid));
				map.put("createdate",Util.null2String(discessVo.getCreatedate()));
				map.put("createtime", Util.null2String(discessVo.getCreatetime()));
				map.put("moodIcon",faceimg);
				map.put("isnew", isnew);
				if("0".equals(isnew)){
					map.put("noreadimg","<img src=\"/mobilemode/apps/images/noread_wev8.png\" class=\"noreadimg\" userid=\""+userid+"\" discussid=\""+discussid+"\" discussuserid=\""+discussuserid+"\">");
				}else{
					map.put("noreadimg","");
				}
				map.put("jbotitle", jobTitlesComInfo.getJobTitlesname(resourceComInfo.getJobTitle(discussuserid)));//岗位名称
				map.put("managerid", resourceComInfo.getManagerID(discussuserid));
				map.put("ishaslocation",blogDao.isHasLocation(discussid)?"1":"0");
				String contents = Util.null2String(discessVo.getContent());//微博内容
				map.put("contents",Util.StringReplace(contents.trim(),"\r\n",""));
				if(repnum1!=0){
					map.put("repnum1","("+repnum1+")");
				}else{
					map.put("repnum1","");
				}
				if(repnum2!=0){
					map.put("repnum2","("+repnum2+")");
				}else{
					map.put("repnum2","");
				}
				//map.put("submitdate",submitdate);
				datas.add(map);
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}

	detail.put("datas",datas);
	detail.put("totalSize",total+"");
	if(total == 0){
		out.print("{\"totalSize\":0, \"datas\":[]}");
		return;
	}
	JSONObject json = JSONObject.fromObject(detail);
	out.print(json.toString());
}else if(operation.equals("myblog")){//我的微博
	ResourceComInfo resourceComInfo=new ResourceComInfo();
	JobTitlesComInfo jobTitlesComInfo=new JobTitlesComInfo();
	enableDate=blogDao.getSysSetting("enableDate");//微博启用时间
	
	Date dateTemp=new Date();
	String todaystr = dateFormat1.format(dateTemp);
	dateTemp.setDate(dateTemp.getDate()-1);
	String yesterday=dateFormat1.format(dateTemp);      //昨天
	dateTemp.setDate(dateTemp.getDate()-1);
	String beforeyesterday=dateFormat1.format(dateTemp);//前天
	String weekday="";
	
	//totalsize
	List tolist = blogManager.getDiscussListAll(blogid,enableDate,dateFormat1.format(today));
	total = tolist.size();
	Map<String, Object> detail = new HashMap<String, Object>();
	List datas = new ArrayList();
	try{
		if("".equals(endDate)){
			Date endDateTmp=new Date();
			if(isNeedSubmit!=0||!userid.equals(blogid)||todayIsReplayed==1)  //访问其他用户的微博不显示今天
				endDateTmp.setDate(endDateTmp.getDate());
			else
				endDateTmp.setDate(endDateTmp.getDate());
			endDate=dateFormat1.format(endDateTmp);
			
			startdateTemp=endDateTmp;
			startdateTemp.setDate(endDateTmp.getDate()-pagesize);
			startDate=dateFormat1.format(startdateTemp);
		}else{
			startdateTemp=dateFormat1.parse(endDate);
			startdateTemp.setDate(startdateTemp.getDate()-pagesize);
		}
		if(dateFormat1.parse(enableDate).getTime()>startdateTemp.getTime()){
			startDate=enableDate;
		}else{
			startDate=dateFormat1.format(startdateTemp);
		}
		
		discussList=blogManager.getDiscussListAll(blogid,startDate,endDate);
		
		if(discussList.size()>0){
			for(int i=0;i<discussList.size();i++){
				Map map = new HashMap();
				BlogDiscessVo discessVo=(BlogDiscessVo)discussList.get(i);
				if(discessVo==null)
					continue;
				String discussid=discessVo.getId();
				map.put("discussid", Util.null2String(discussid));
				String workdate=Util.null2String(discessVo.getWorkdate());
				if(workdate.equals(todaystr)){
					continue;
				}
				String showdate=workdate;
				long   todaytime=today.getTime(); 
				long   worktime=dateFormat1.parse(workdate).getTime(); 
				//获取某个工作日到今天已经几天了
				long daysFromWorkDate=(todaytime-worktime)/(24*60*60*1000);
				
				String managerstr=resourceComInfo.getManagersIDs(discessVo.getUserid());
				String createdate="";
				if(discussid!=null)
					createdate=discessVo.getCreatedate();
				else
					createdate=attentionWorkDate;
				
				String contents = Util.null2String(discessVo.getContent());//微博内容
					
				String comefrom=Util.null2String(discessVo.getComefrom());
				String comefromTemp="";
				if(comefrom.equals("1"))  
					comefromTemp="(来自Iphone)";
				else if(comefrom.equals("2"))  
					comefromTemp="(来自Ipad)";
				else if(comefrom.equals("3"))  
					comefromTemp="(来自Android)";          
				else if(comefrom.equals("4"))  
					comefromTemp="(来自Web手机版)";
			    else
			    	comefromTemp="";       	
				AppItemVo  appItemVo=null;
				if(moodIsActive)
				  appItemVo=appDao.getappItemByDiscussId(discussid); 
				String faceimg = "<div class=\"rowWrap\" style=\"float:right;display:inline;\">";
				
				if(appItemVo!=null){
					faceimg = faceimg+"<img  width=\"16px\" src=\""+appItemVo.getFaceImg()+"\" />" ;
				}
				if(userid.equals(discessVo.getUserid())&&daysFromWorkDate<=7){
					faceimg += "<img  width=\"20px\" src=\"/mobilemode/apps/images/bujiao_wev8.png\" onclick=\"javascript:subblog('"+Util.null2String(discussid)+"','"+workdate+"','"+Util.delHtml(contents)+"');\">" ;
				}
				if("<div class=\"rowWrap\" style=\"float:right;display:inline;\">".equals(faceimg)){
					faceimg = "";
				}else{
					faceimg += "</div>";
				}
				//地理位置
				List locationList=blogDao.getLocationList(discussid);
				
				String discussuserid=discessVo.getUserid();            //发表人id
				String isnew=updateList.contains(discussid)?"0":"1";  // 0未读  1 已读
				
				String commentstr ="";
				int repnum1 = 0;
				int repnum2 = 0;
				List replyList=blogDao.getReplyList(discussuserid, discessVo.getWorkdate(), userid);
				//BlogReplyVo replyArray[]=new BlogReplyVo[replyList.size()];
				if(replyList.size()>0){
					commentstr ="<div class='commentReply'><ul class='reply'>";
					for(int j=0;j<replyList.size();j++){
						BlogReplyVo replyVo=(BlogReplyVo)replyList.get(j);
						String replyid = Util.null2String(replyVo.getId());
						String replyUserid=replyVo.getUserid();
						String replyUsername=resourceComInfo.getLastname(replyUserid);
						String commentType = Util.null2String(replyVo.getCommentType());//私评1
						if("1".equals(commentType)){
							repnum2++;
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"(私评)<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','myblog');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','myblog');\"></div><br>";
						}else{
							repnum1++;
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','myblog');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','myblog');\"></div><br>";
						}
						//commentstr+="<li>"+Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
						commentstr+=Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
					}
					commentstr+="</ul></div>";
				}
				map.put("workdate", workdate);
				weekday=week[dateFormat1.parse(workdate).getDay()];
				if(workdate.equals(yesterday))
					weekday="昨天";
				else if(workdate.equals(beforeyesterday))
					weekday="前天";
				map.put("weekday", weekday);
				map.put("worddateMD",dateFormat2.format(dateFormat1.parse(workdate)));
				map.put("replycomments", commentstr);
				map.put("discussuserid", discussuserid);
				map.put("username", resourceComInfo.getLastname(discussuserid));
				map.put("userimg", resourceComInfo.getMessagerUrls(discussuserid));
				map.put("createdate",Util.null2String(discessVo.getCreatedate()));
				map.put("createtime", Util.null2String(discessVo.getCreatetime()));
				map.put("moodIcon",faceimg);
				map.put("isnew", isnew);
				map.put("jbotitle", jobTitlesComInfo.getJobTitlesname(resourceComInfo.getJobTitle(discussuserid)));//岗位名称
				map.put("managerid", resourceComInfo.getManagerID(discussuserid));
				map.put("ishaslocation",blogDao.isHasLocation(discussid)?"1":"0");
				if("".equals(contents)){
					contents = "<div class=\"reportContent\"><div style=\"margin-left:30%;margin-bottom:10px;padding-left:28px;height:24px;line-height:24px;background:url('/blog/images/blog_unsubmit_wev8.png') no-repeat left center;\">未提交微博</div></div>";
				}
				map.put("contents",Util.StringReplace(contents.trim(),"\r\n",""));
				Date _endDateTmp=new Date();
				_endDateTmp.setDate((dateFormat1.parse(startDate).getDate())-1);
				map.put("_endDate", dateFormat1.format(_endDateTmp));
				String repstr = "";
				//评分、评论、私评
				/* if(discussid!=null&&!"".equals(discussid)){
					repstr = "<div class=\"replyoperations\"><div class=\"sortInfoRightBar\">"+
						"<span  style='width: 100px' score='2' readOnly='true' discussid='"+discussid+"' target='blog_raty_keep_discussid' class='blog_raty' id='blog_raty_"+discussid+"'></span>"+
						"</div><div>";
				} */
				map.put("replyoperations", repstr);	
				if(repnum1!=0){
					map.put("repnum1","("+repnum1+")");
				}else{
					map.put("repnum1","");
				}
				if(repnum2!=0){
					map.put("repnum2","("+repnum2+")");
				}else{
					map.put("repnum2","");
				}
				datas.add(map);
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	detail.put("datas",datas);
	detail.put("totalSize",total+"");
	
	detail.put("endDate", startDate);
	if(total == 0){
		out.print("{\"totalSize\":0, \"datas\":[]}");
		return;
	}
	JSONObject json = JSONObject.fromObject(detail);
	out.print(json.toString());
}else if(operation.equals("commentOnMe")){    //评论我的
	ResourceComInfo resourceComInfo=new ResourceComInfo();
	JobTitlesComInfo jobTitlesComInfo=new JobTitlesComInfo();
	enableDate=blogDao.getSysSetting("enableDate");//微博启用时间
	//totalsize
	if(total==0){
		total=blogDao.getCommentTotal(userid);
	}
	BlogServiceImpl bs = new BlogServiceImpl();
	bs.removeCommentRemind(userid);//清除评论数
	
	Map<String, Object> detail = new HashMap<String, Object>();
	List datas = new ArrayList();
	try{
		discussList=blogDao.getCommentDiscussVOList(userid,currentpage,pagesize,total);
		if(discussList.size()>0){
			for(int i=0;i<discussList.size();i++){
				Map map = new HashMap();
				BlogDiscessVo discessVo=(BlogDiscessVo)discussList.get(i);
				if(discessVo==null)
					continue;
				String discussid=discessVo.getId();
				map.put("discussid", Util.null2String(discussid));
				String workdate=discessVo.getWorkdate();
				String showdate=workdate;
				long   todaytime=today.getTime(); 
				long   worktime=dateFormat1.parse(workdate).getTime(); 
				//获取某个工作日到今天已经几天了
				long daysFromWorkDate=(todaytime-worktime)/(24*60*60*1000);
				
				String managerstr=resourceComInfo.getManagersIDs(discessVo.getUserid());
				String createdate="";
				if(discussid!=null)
					createdate=discessVo.getCreatedate();
				else
					createdate=attentionWorkDate;
					
				String comefrom=Util.null2String(discessVo.getComefrom());
				String comefromTemp="";
				if(comefrom.equals("1"))  
					comefromTemp="(来自Iphone)";
				else if(comefrom.equals("2"))  
					comefromTemp="(来自Ipad)";
				else if(comefrom.equals("3"))  
					comefromTemp="(来自Android)";          
				else if(comefrom.equals("4"))  
					comefromTemp="(来自Web手机版)";
			    else
			    	comefromTemp="";       	
				AppItemVo  appItemVo=null;
				if(moodIsActive)
				  appItemVo=appDao.getappItemByDiscussId(discussid); 
				String faceimg = "";
				
				if(appItemVo!=null){
					faceimg = "<div class=\"rowWrap\" style=\"float:right;\"><img  width=\"16px\" src=\""+appItemVo.getFaceImg()+"\" /></div>" ;
				}
				//地理位置
				List locationList=blogDao.getLocationList(discussid);
				
				String discussuserid=discessVo.getUserid();            //发表人id
				String isnew=updateList.contains(discussid)?"0":"1";  // 0未读  1 已读
				
				String commentstr ="";
				int repnum1 = 0;
				int repnum2 = 0;
				List replyList=blogDao.getReplyList(discussuserid, discessVo.getWorkdate(), userid);
				//BlogReplyVo replyArray[]=new BlogReplyVo[replyList.size()];
				if(replyList.size()>0){
					commentstr ="<div class='commentReply'><ul class='reply'>";
					for(int j=0;j<replyList.size();j++){
						BlogReplyVo replyVo=(BlogReplyVo)replyList.get(j);
						String replyid = Util.null2String(replyVo.getId());
						String replyUserid=replyVo.getUserid();
						String replyUsername=resourceComInfo.getLastname(replyUserid);
						String commentType = Util.null2String(replyVo.getCommentType());//私评1
						if("1".equals(commentType)){
							repnum2++;	
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"(私评)<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','reply');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','reply');\"></div><br>";
						}else{
							repnum1++;
							commentstr+="<li>"+replyUsername+"&nbsp;&nbsp;"+CoworkTransMethod.getFormateDate(replyVo.getCreatedate(),replyVo.getCreatetime())+"<div style=\"float:right;display:inline;margin:0 0 0 10px;\"><img src=\"/mobilemode/apps/images/blog_sipin_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+1+"','"+discussuserid+"','@"+replyUsername+"','reply');\"></div><div style=\"float:right;display:inline;\"><img src=\"/mobilemode/apps/images/blog_pinlun_wev8.png\" onclick=\"javascript:subreply('"+Util.null2String(discussid)+"','"+workdate+"','"+replyid+"','"+replyUserid+"','"+0+"','"+discussuserid+"','@"+replyUsername+"','reply');\"></div><br>";
						}
						//commentstr+="<li>"+Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
						commentstr+=Util.StringReplace(Util.null2String(replyVo.getContent()),"\r\n","")+"</li>";
					}
					commentstr+="</ul></div>";
				}
				map.put("workdate", discessVo.getWorkdate());
				map.put("replycomments", commentstr);
				map.put("discussuserid", discussuserid);
				map.put("username", resourceComInfo.getLastname(discussuserid));
				map.put("userimg", resourceComInfo.getMessagerUrls(discussuserid));
				map.put("createdate",Util.null2String(discessVo.getCreatedate()));
				map.put("createtime", Util.null2String(discessVo.getCreatetime()));
				map.put("moodIcon",faceimg);
				map.put("isnew", isnew);
				map.put("jbotitle", jobTitlesComInfo.getJobTitlesname(resourceComInfo.getJobTitle(discussuserid)));//岗位名称
				map.put("managerid", resourceComInfo.getManagerID(discussuserid));
				map.put("ishaslocation",blogDao.isHasLocation(discussid)?"1":"0");
				String contents = Util.null2String(discessVo.getContent());//微博内容
				map.put("contents",Util.StringReplace(contents.trim(),"\r\n",""));
				if(repnum1!=0){
					map.put("repnum1","("+repnum1+")");
				}else{
					map.put("repnum1","");
				}
				if(repnum2!=0){
					map.put("repnum2","("+repnum2+")");
				}else{
					map.put("repnum2","");
				}
				datas.add(map);
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	detail.put("datas",datas);
	detail.put("totalSize",total+"");
	if(total == 0){
		out.print("{\"totalSize\":0, \"datas\":[]}");
		return;
	}
	JSONObject json = JSONObject.fromObject(detail);
	out.print(json.toString());
}else if(operation.equals("markRead")){
	String discussuserid=Util.null2String(fu.getParameter("discussuserid"));
	String discussid=Util.null2String(fu.getParameter("discussid")); 
	BlogServiceImpl bs = new BlogServiceImpl();
	bs.writeBlogReadFlag(userid, discussuserid, discussid);
	result.put("flag", 1);
	JSONObject json = JSONObject.fromObject(result);
	out.print(json.toString());	
}
%>
