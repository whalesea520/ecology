
<%@ page language="java" contentType="text/html; charset=UTF-8 "%> 
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.Time"%>
<%@page import="weaver.email.domain.MailLabel"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />




<%
	
	
	String mailtype = Util.null2String(request.getParameter("mailtype"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String subject = Util.null2String(request.getParameter("subject"));
	String star = Util.null2String(request.getParameter("star"));
	int index = Util.getIntValue(request.getParameter("index"),1);
	int perpage = Util.getIntValue(request.getParameter("perpage"),10);
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
	String menuid=Util.null2String(request.getParameter("menuid"));	
	 
	//加载数据的方式，0默认加载，1更多加载
	String loadtype=Util.null2String(request.getParameter("loadtype"));
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
		
	//统一处理，防止有些参数误传过来
	if ("0".equals(menuid)){//收件箱
				star="";
				labelid="";
				isInternal=-1;
	}else  if ("1".equals(menuid)){//已发件箱
				star="";
				labelid="";
				isInternal=-1;
	}else  if ("2".equals(menuid)){//草稿
				star="";
				labelid="";
				isInternal=-1;
	}else  if ("3".equals(menuid)){//已删除邮件
				star="";
				labelid="";
				isInternal=-1;
	}else  if ("4".equals(menuid)){//内部邮件
				star="";
				labelid="";
	}else  if ("5".equals(menuid)){//标星邮件
				labelid="";
				isInternal=-1;
	}
	else  if ("6".equals(menuid)){
				star="";
				isInternal=-1;
	}
	
	
	//设置参数过滤数据
	mrs.setResourceid(user.getUID()+"");
	mrs.setFolderid(folderid+"");
	mrs.setLabelid(labelid);
	mrs.setStarred(star);
	mrs.setSubject(subject);
	mrs.setSendfrom(from);
	mrs.setSendto(to);
	mrs.setStatus(status);
	mrs.setAttachmentnumber(attachmentnumber);
	mrs.setMailaccountid(mailaccountid);
	mrs.setIsInternal(isInternal);
	
	//查询邮件列表分页信息
	mrs.selectMailResourceSplitePage(perpage,index);
	
	
	   
	int currentWeek = TimeUtil.getWeekOfYear(new Date());
	String currentDate = TimeUtil.getCurrentDateString();
	int currentWeekDate =TimeUtil.dateWeekday(currentDate);
	
	//记录sql语句，需保证顺序
	List listWhereSession= new ArrayList();
	listWhereSession.add(user.getUID()+"");
	listWhereSession.add(folderid+"");
	listWhereSession.add(labelid);
	listWhereSession.add(star);
	listWhereSession.add(subject.trim());
	listWhereSession.add(from);
	listWhereSession.add(to);
	listWhereSession.add(status);
	listWhereSession.add(attachmentnumber);
	listWhereSession.add(mailaccountid);
	listWhereSession.add(isInternal);
	session.setAttribute("listWhereSession",listWhereSession);

	int lastWeekCount=0;
	int beforLastWeekCount = 0;
	StringBuffer day0Table = new StringBuffer();
	while(mrs.next()){
				day0Table.append(getTableString(mrs,user));	
	}
	if("0".equals(loadtype)){
				//默认加载的时候，才输出这个
				day0Table.append("<input type='hidden' name='TotalPage'  id='TotalPage'  value='"+mrs.getTotalPage()+"'>");	
	}
	

	
	
	
	out.clear();
%>
		<%=day0Table.toString() %>

		<%!
		
		
			public String getTableString(MailResourceService mrs ,User user){
				
				String sendDate =  mrs.getSenddate();
				SptmForMail sm=new SptmForMail();
				String sendtime=Util.getMoreStr(sendDate, 5, "");
				String statime=TimeUtil.getDateString(TimeUtil.getFirstDayOfWeek(new Date()));//取得当前日期所在周的第一天
				String endtime=TimeUtil.getDateString(TimeUtil.getLastDayOfWeek(new Date()));//取得当前日期所在周的最后一天
				int theDay = TimeUtil.dateWeekday(sendDate);
				String msg="";
				switch(theDay){
					case 1: msg=SystemEnv.getHtmlLabelName(392,user.getLanguage()); break;
					case 2: msg=SystemEnv.getHtmlLabelName(393,user.getLanguage()); break;
					case 3: msg=SystemEnv.getHtmlLabelName(394,user.getLanguage()); break;
					case 4: msg=SystemEnv.getHtmlLabelName(395,user.getLanguage()); break;
					case 5: msg=SystemEnv.getHtmlLabelName(396,user.getLanguage()); break;
					case 6: msg=SystemEnv.getHtmlLabelName(397,user.getLanguage()); break;
					case 0: msg=SystemEnv.getHtmlLabelName(398,user.getLanguage()); break;
				}
				
				//不在本周范围内,就显示日期
				if(TimeUtil.dateInterval(statime,sendtime)<0||TimeUtil.dateInterval(endtime,sendtime)>0){
						msg=sendtime;
				}
				String str="";
					 str+="<div class='listitem'  >";
					 str+="<table   id='tbl_"+mrs.getId()+"'  style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>";
					 str+="<tbody>";
					 str+="	<tr><td class='itempreview'><input name='mailcheck' value='"+mrs.getId()+"' type='checkbox'/>";
					 str+="	</td>";
					 str+="	<td width='18px'><div class='cir "+(mrs.getStatus().equals("1")?"Rr":"Ru")+"'></div></td>";
					 str+="	<td class='itemcontent  trclick'  _id='"+mrs.getId()+"' _folderid='"+mrs.getFolderid()+"' _star='"+mrs.getStarred()+"'  _isInternal='"+mrs.getIsInternal()+"'>";
					 str+="	<div class='itemcontenttitle'>";
					 str+="	<table style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>";
					 str+="	<tbody>";
					 str+="	<tr><td class='ictwz'>"+mrs.getSubject()+"</td>";
					 str+="	<td class='ictnew ' ><div class='itemcontentitdt' > "+msg+"</div></td>";
					 if(mrs.getStarred().equals("1")){
					 	str+="	<td  style='width:14px'><div class='fivestarcheck' _id="+mrs.getId()+"  _name='star'></div></td>";
					 }else{
					 	str+="	<td  style='width:14px'><div class='fivestar' _id="+mrs.getId()+"  _name='star'></div></td>";
					 }
					 str+="	</tr></tbody>";
					 str+="	</table>";
					 str+="	</div>";
					 if("1".equals(mrs.getIsInternal()+"")){
						 try{
					 		 ResourceComInfo hrm=new ResourceComInfo();
					 		 str+="	<div class='itemcontentitdt'>    "+SystemEnv.getHtmlLabelName(2034,user.getLanguage())+":"+hrm.getResourcename(mrs.getSendfrom()+"")+"&nbsp;&nbsp;"+sendDate+"</div>";
					 	 }catch(Exception e){
					 	 	e.printStackTrace();
					 	 }
					 }else{
					 	String jieshou=sm.getNameByEmailNoHref(mrs.getSendfrom(),user.getUID()+"");
						if(null!=jieshou&&!"".equals(jieshou)){
							jieshou.replace("&gt;", ">").replace("&lt;", "<");
						}
					 	 str+="	<div class='itemcontentitdt'>    "+SystemEnv.getHtmlLabelName(2034,user.getLanguage())+":"+jieshou+"&nbsp;&nbsp;"+sendDate+"</div>";
					 }
					 str+="</td>";
					 str+="<td class='itemnavpoint'   _id='"+mrs.getId()+"' _folderid='"+mrs.getFolderid()+"' _star='"+mrs.getStarred()+"' _isInternal='"+mrs.getIsInternal()+"'>";
					 str+="<img src='/images/icon-right.png'  >";
					 str+="</td></tr></tbody>";
					 str+="</table></div>";
				return str;
			}		
		
		%>