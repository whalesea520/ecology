<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="org.apache.commons.httpclient.util.DateUtil"%>
<%@page import="weaver.general.Time"%>
<%@page import="weaver.email.domain.MailLabel"%>
<%@page import="weaver.email.service.MailResourceService"%>
<%@page import="weaver.email.service.LabelManagerService"%>
<%@page import="weaver.email.service.MailSettingService"%>
<%@ page import="weaver.splitepage.transform.SptmForMail" %>
<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@page import="weaver.email.WeavermailUtil"%> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%
	String mailtype = Util.null2String(request.getParameter("mailtype"));
	String folderid = Util.null2String(request.getParameter("folderid"));
	String labelid = Util.null2String(request.getParameter("labelid"));
	String subject = Util.null2String(request.getParameter("subject"));
	String star = Util.null2String(request.getParameter("star"));
	int index = Util.getIntValue(request.getParameter("index"),1);
	int perpage = Util.getIntValue(request.getParameter("perpage"),20);
	int isInternal = Util.getIntValue(request.getParameter("isInternal"),-1);
	
	String mailaccountid = Util.null2String(request.getParameter("mailaccountid"));
	String status = Util.null2String(request.getParameter("status"));
	String from = Util.null2String(request.getParameter("from"));
	String to = Util.null2String(request.getParameter("to"));
	String tohrmid = Util.null2String(request.getParameter("tohrmid"));
	String fromhrmid = Util.null2String(request.getParameter("fromhrmid"));
	String attachmentnumber = Util.null2String(request.getParameter("attachmentnumber"));
	String datetype = Util.null2String(request.getParameter("datetype"));
	String startdate = Util.null2String(request.getParameter("startdate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String sortColumn = Util.null2String(request.getParameter("sortColumn"));
	String sortType = Util.null2String(request.getParameter("sortType"));
	String waitdeal = Util.null2String(request.getParameter("waitdeal"));
	mrs.setResourceid(user.getUID()+"");
	mrs.setFolderid(folderid+"");
	mrs.setLabelid(labelid);
	mrs.setStarred(star);
	mrs.setWaitdealid(waitdeal);
	mrs.setSubject(subject.trim());
	mrs.setSendfrom(from);
	mrs.setSendto(to);
	mrs.setFromhrmid(fromhrmid);
	mrs.setTohrmid(tohrmid);
	mrs.setStatus(status);
	mrs.setAttachmentnumber(attachmentnumber);
	mrs.setMailaccountid(mailaccountid);
	mrs.setIsInternal(isInternal);
	mrs.setDatetype(datetype);
	mrs.setStartdate(startdate);
	mrs.setEnddate(enddate);
	mrs.setSortColumn(sortColumn);
	mrs.setSortType(sortType);
	mrs.selectMailResourceSplitePage(perpage,index);
	
	mrs.setLanguageid(user.getLanguage()); 
	
	int currentYear = new Date().getYear();
	int currentMonth = new Date().getMonth();
	int currentWeek = this.getWeekOfYear(new Date());
	String currentDate = TimeUtil.getCurrentDateString();
	int currentWeekDate =TimeUtil.dateWeekday(currentDate);
	
	int day7Count=0;
	int day1Count=0;
	int day2Count=0;
	int day3Count=0;
	int day4Count=0;
	int day5Count=0;
	int day6Count=0;
	int lastWeekCount=0;
	int beforLastWeekCount = 0;
	int dayOtherCount = 0;
	int waitdealCount = 0;
	
	StringBuffer day7Table = new StringBuffer();
	StringBuffer day1Table = new StringBuffer();
	StringBuffer day2Table = new StringBuffer();
	StringBuffer day3Table = new StringBuffer();
	StringBuffer day4Table = new StringBuffer();
	StringBuffer day5Table = new StringBuffer();
	StringBuffer day6Table = new StringBuffer();
	StringBuffer dayOtherTable = new StringBuffer();
	StringBuffer lastWeekTable =new StringBuffer();
	StringBuffer beforLastWeekTable = new StringBuffer();
	StringBuffer waitdealTable = new StringBuffer();
	
	int maxWeek = 55;
	if(currentMonth !=0 && currentWeek == 1){
		currentWeek = maxWeek;
	}
	while(mrs.next()){
		String sendDate =  mrs.getOnlySenddate();
		if(sendDate==null||sendDate.equals("")){ //如果发送日期无效就默认采用当前时间
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			sendDate=df.format(new Date());
		}		
		int theWeek = this.getWeekOfYear(TimeUtil.getString2Date(sendDate,"yyyy'-'MM'-'dd"));
		
		//out.println(currentWeek+"=="+theWeek+"<br>");
		int theDay = TimeUtil.dateWeekday(sendDate);
		
		Calendar cl =  TimeUtil.getCalendar(sendDate,"yyyy'-'MM'-'dd");
		
		int theYear = TimeUtil.getString2Date(sendDate,"yyyy'-'MM'-'dd").getYear();
		int theMonth = TimeUtil.getString2Date(sendDate,"yyyy'-'MM'-'dd").getMonth();
		if(theMonth !=0 && theWeek == 1){
			theWeek = maxWeek;
		}
		
		if(!"".equals(sortColumn) && !"senddate".equals(sortColumn)){
			day1Table.append(getTableString(mrs,user,isInternal,folderid));	
			continue;
		}
		
		//out.println(sendDate+"%"+theMonth+"=="+theMonth+"theWeek"+theWeek+"<br>");
		if(waitdeal.equals("1")){
			waitdealCount++;
			waitdealTable.append(getTableString(mrs,user,isInternal,folderid));	
		}else{
			if((theYear==currentYear&&theWeek==currentWeek) || (theYear==currentYear-1&&theWeek==maxWeek&&currentWeek==1) || (theYear==currentYear + 1 && theWeek==1 && currentWeek==maxWeek)){ // 
				//out.println(theDay);
				
				
				if(theDay==1){
					day1Count++;
					day1Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==2){
					day2Count++;
					day2Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==3){
					day3Count++;
					day3Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==4){
					day4Count++;
					day4Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==5){
					day5Count++;
					day5Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==6){
					day6Count++;
					day6Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				if(theDay==0){
					day7Count++;
					day7Table.append(getTableString(mrs,user,isInternal,folderid));	
					continue;
				}
				
			}
			
			//上周
			if(theYear==currentYear&&theWeek==currentWeek-1){
				lastWeekCount++;
				lastWeekTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
				
			}else if(theYear==currentYear-1&&theWeek==TimeUtil.getMaxWeekNumOfYear(theYear)&&currentWeek==1){
				lastWeekCount++;
				lastWeekTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
			}else if(theYear==currentYear-1&&theWeek==maxWeek&&currentWeek==2){
				lastWeekCount++;
				lastWeekTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
			}else if(theYear==currentYear && currentWeek == maxWeek && theWeek==TimeUtil.getMaxWeekNumOfYear(theYear)){
				lastWeekCount++;
				lastWeekTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
			}
			
			//更早
			if(theYear<currentYear||(theYear==currentYear&&theWeek<currentWeek-1)){
				beforLastWeekCount++;
				beforLastWeekTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
				
			}else{
				dayOtherCount++;
				dayOtherTable.append(getTableString(mrs,user,isInternal,folderid));
				continue;
			}
		}
	}
	

	if(day1Count>0){
		if(currentWeekDate==1){
			day1Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day1Count+")--></div>");
		}else{
			day1Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(392,user.getLanguage())+"</font> <!--("+day1Count+")--></div>");
		}
		day1Count=0;
	}
	if(day2Count>0){
		if(currentWeekDate==2){
			day2Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day2Count+")--></div>");
		}else{
			day2Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(393,user.getLanguage())+"</font> <!--("+day2Count+")--></div>");
		}
		day2Count=2;
	}
	if(day3Count>0){
		if(currentWeekDate==3){
			day3Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day3Count+")--></div>");
		}else{
			day3Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(394,user.getLanguage())+"</font> <!--("+day3Count+")--></div>");
		}
		day3Count=0;
	}
	if(day4Count>0){
		if(currentWeekDate==4){
			day4Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day4Count+")--></div>");
		}else{
			day4Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(395,user.getLanguage())+"</font> <!--("+day4Count+")--></div>");
		}
		day4Count=0;
	}
	if(day5Count>0){
		if(currentWeekDate==5){
			day5Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day5Count+")--></div>");
		}else{
			day5Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(396,user.getLanguage())+"</font> <!--("+day5Count+")--></div>");
		}
		day5Count=0;
	}
	if(day6Count>0){
		if(currentWeekDate==6){
			day6Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day6Count+")--></div>");
		}else{
			day6Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(397,user.getLanguage())+"</font> <!--("+day6Count+")--></div>");
		}
		day6Count=0;
	}
	
	if(day7Count>0){
		if(currentWeekDate==0){
			day7Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(15537,user.getLanguage())+"</font> <!--("+day7Count+")--></div>");
		}else{
			day7Table.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(398,user.getLanguage())+"</font> <!--("+day7Count+")--></div>");
		}
		day7Count=0;
	}
	
	if(lastWeekCount>0){
		lastWeekTable.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(26789,user.getLanguage())+"</font> <!--("+lastWeekCount+")--></div>");
		lastWeekCount=0;
	}
	if(beforLastWeekCount>0){
		beforLastWeekTable.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(81336,user.getLanguage())+"</font> <!--("+beforLastWeekCount+")--></div>");
		beforLastWeekCount = 0;
	}
	
	if(dayOtherCount>0){
		dayOtherTable.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(375,user.getLanguage())+"</font> <!--("+beforLastWeekCount+")--></div>");
		dayOtherCount = 0;
	}
	
	if(waitdealCount>0){
		waitdealTable.insert(0,"<div style='color:#0084fd' class='font12 p-t-5 b-b-1 p-l-5'> <font class='font14 bold'>"+SystemEnv.getHtmlLabelName(83090,user.getLanguage())+"</font> <!--("+beforLastWeekCount+")--></div>");
		waitdealCount = 0;
	}
%>
	
		<%=dayOtherTable.toString() %>
		<%=day7Table.toString() %>
		<%=day6Table.toString() %>
		<%=day5Table.toString() %>
		<%=day4Table.toString() %>
		<%=day3Table.toString() %>
		<%=day2Table.toString() %>
		<%=day1Table.toString() %>
		
		<%=lastWeekTable.toString() %>
		<%=beforLastWeekTable.toString() %>
		
		<%=waitdealTable.toString() %>
		
		<%!
		
			public String getTableString(MailResourceService mrs ,User user,int isInternal,String folderid) throws Exception{
				MailSettingService mailSettingService = new MailSettingService();
				mailSettingService.selectMailSetting(user.getUID());
				int userLayout = Util.getIntValue(mailSettingService.getLayout(),0);
				ResourceComInfo resourceComInfo=new ResourceComInfo();
				String userid=user.getUID()+"";
				String str="";
				str ="<table id='tbl_"+mrs.getId()+"' cellspacing='0' class='mailitem i M h-25'>"+

				"<tr>"+
					"<td class='cx'>"+
						"<input  type='checkbox' status="+mrs.getStatus()+"  sendfrom='"+mrs.getSendfrom()+"' name='mailid' value="+mrs.getId()+"  starred='"+mrs.getStarred()+"' >"+
					"</td>"+
					"<td class='ci'>"+
						"<div class='ciz left'>&nbsp;</div>";
					if("1".equals(mrs.getPrioority())) {
						str+="<div class='cir left ' style='width: 7px;height:15px; background: transparent url(/images/BacoError_wev8.gif) no-repeat 0 2.1px ;' title='"+SystemEnv.getHtmlLabelName(2087,user.getLanguage())+"'>&nbsp;</div>";
					}else {
						str+="<div class='cir left ' style='width: 7px;height:15px;' >&nbsp;</div>";
					}
					if("-2".equals(mrs.getFolderid()) && !"".equals(mrs.getTimingdate()) && 0 == mrs.getTimingdatestate()){
						str+="<div class='cir left' style =' background:url(/email/images/timingdate_wev8.png) no-repeat' title='"+SystemEnv.getHtmlLabelName(32028,user.getLanguage())+"'>&nbsp;</div>";
					}else if("-2".equals(mrs.getFolderid()) && !"".equals(mrs.getTimingdate()) && -1 == mrs.getTimingdatestate()){
						str+="<div class='cir left' style =' background:url(/email/images/edit_wev8.gif) no-repeat' title='"+SystemEnv.getHtmlLabelName(22397,user.getLanguage())+"'>&nbsp;</div>";
					}else if(mrs.getFlag() > 0){
						str += this.getMailFlagLogo(mrs.getFlag(),user.getLanguage());
					}else if(mrs.getStatus().equals("1")){
						str+="<div class='cir left Rr' title='"+SystemEnv.getHtmlLabelName(25425,user.getLanguage())+"'>&nbsp;</div>";
					}else{
						str+="<div class='cir left Ru' title='"+SystemEnv.getHtmlLabelName(25426,user.getLanguage())+"'>&nbsp;</div>";
					}
					if(mrs.getAttachmentnumber().equals("0")){
						str+="<div class='cij left ' >&nbsp;</div>";
					}else{
						str+="<div class='cij left Ju' title='"+SystemEnv.getHtmlLabelName(156,user.getLanguage())+"'>&nbsp;</div>";
					}
					SptmForMail spm = new SptmForMail();	
					String realName=folderid.equals("-1")||folderid.equals("-2")?spm.getMailSendToRealName(mrs,userid):spm.getMailSendFromRealName(mrs.getSendfrom(),userid,mrs.getIsInternal());
					String title = folderid.equals("-1")||folderid.equals("-2")?realName:(mrs.getIsInternal()==1?resourceComInfo.getLastname(mrs.getSendfrom()):mrs.getSendfrom());
					
					if(1 == isInternal && !folderid.equals("-1") && !folderid.equals("-2")){
						realName = spm.getMailSendFromRealName(mrs.getSendfrom(),userid,mrs.getIsInternal());
						title = resourceComInfo.getLastname(mrs.getSendfrom());
					}
					String titleclass = "";
					String re1l = "";
					WeavermailUtil weavermailUtil = new WeavermailUtil();
					if(mrs.getIsInternal() != 1) {
						re1l = (folderid.equals("-1")||folderid.equals("-2")) ? mrs.getSendto() : weavermailUtil.getEmailRealName(mrs.getSendfrom(),userid,true);
                        if(folderid.equals("-1") || folderid.equals("-2")) {
    						title = re1l;
                        }
						titleclass = "mailaddresstitle";
					}
					
						
					str +="</td>"
					   +"<td>"
					   +	"<table cellspacing='0' class='i'>"
							
					   +		"<tr class='mailtr'>"
						+			"<td class='tl tf '  style='width:20%;' >"
						+				"<span style='height:30px;line-height:30px;' class='"+titleclass+"' re1l='"+re1l+"' isInternal='"+mrs.getIsInternal()+"' rel='"+title+"'>"+realName+"&nbsp;</span>"
						+			"</td>";
						if(userLayout == 2) {
							
						} else {
						str +=		"<td class='fg_n '>"
						    +			"<div></div>"
						    +		"</td>";
						}
						str +=		"<td class='gt tf'><div style='position:relative'>";
						if(mrs.getFolderid().equals("-2")) {
							str +=		"<div class='title hand ' id='draft'  onclick='ctwMail("+mrs.getId()+",this);' title='"+mrs.getSubject()+"'>"+getSubject(mrs.getSubject(),user)+"</div>";
						} else {
							str +=		"<div class='title hand "+(mrs.getStatus().equals("1")?"":"bold")+"'  onclick='viewMail("+mrs.getId()+",this)' style='text-overflow:ellipsis;overflow:hidden' title='"+mrs.getSubject()+"'>"+getSubject(mrs.getSubject(),user)+"</div>";
						}
						
						LabelManagerService lms = new LabelManagerService();
						int mailId = Util.getIntValue(mrs.getId());
						ArrayList mailLabels = lms.getMailLabels(mailId);
						
						String labelStr = "";
						for(int i=0;i<mailLabels.size();i++){
							MailLabel ml = (MailLabel)mailLabels.get(i);
							labelStr+="<div class='label hand' style='  background:"+ml.getColor()+"' _conmenu='1'>"
									+	"<div class='left lbName'>"+ml.getName()+"</div>"
									+     "<input type='hidden' name='lableId' value='"+ml.getId()+"' />"
									+     "<input type='hidden' name='mailId' value='"+mailId+"' />"
									+	"<div class='left closeLb hand hide ' title='"+SystemEnv.getHtmlLabelName(81338,user.getLanguage())+"' name='nb'></div>"
									+ "<div class='cleaer'></div>"	
									+"</div>";
						}
						
						if(!labelStr.equals("")){
							str +="<div class='absolute' style='right:5px;top:0px'>"+labelStr+"</div>";
						}
						String style = "";
						if(mrs.getWaitdeal() != 1)
							style = "none"; 
						str+=			"</div></td>"
							+       "<td class='hand' style='width: 50px;'>"
						//	+       "<div style='width: 15px;height:15px; background: transparent url(/images/mail_wait_deal.png) no-repeat 0 2.1px ;' title='"+SystemEnv.getHtmlLabelName(2087,user.getLanguage())+"'>&nbsp;</div>"
						//	+       "<div style='background:url(/email/images/mail_wait_deal.png) no-repeat;'></div>"
							+		"<div class='setwaitdealdiv' id ='waitdeal"+mailId+"' title='"+SystemEnv.getHtmlLabelName(83115,user.getLanguage())+"' onclick='showWaitDeal("+mailId+")' style='padding-left:12px; display: none' ><img src='/email/images/mail_set_waitdeal_wev8.png'  /></div>"
							+		"<div class='nameInfo' id ='nameInfo"+mailId+"' title='"+SystemEnv.getHtmlLabelName(83115,user.getLanguage())+"' rel='/email/new/MailWaitDealWin.jsp?mailId="+mailId+"&waitdealtime="+mrs.getWaitdealtime()+"&waitdealway="+mrs.getWaitdealway()+"&waitdealnote="+mrs.getWaitdealnote()+"&wdremindtime="+mrs.getWdremindtime()+"&tenmp="+new Date().getTime()+"' style='padding-left:12px; display: "+style+"' ><img src='/email/images/mail_wait_deal_wev8.png'     /></div>"
							+       "</td>"
							+		"<td class='dt'>"
							+			"<div>"+mrs.getFormateSenddate()+"</div>"
							+		"</td>";
							
						if(mrs.getStarred().equals("1")){
							str+=		"<td class='fg fs1 hand' title='"+SystemEnv.getHtmlLabelName(81297,user.getLanguage())+"'><div><input type='hidden' name='mailId' value='"+mailId+"' /></div></td>";
						}else{
							str+=		"<td class='fg hand' title='"+SystemEnv.getHtmlLabelName(81337,user.getLanguage())+"'><div><input type='hidden' name='mailId' value='"+mailId+"' /></div></td>";
							
						}
						str+=		"</tr>"
							
						+"				</table>"
						+			"</td>"
						+		"</tr>"
						
						+"</table>";
				return str;
			}		
			
			public String getSubject(String subject ,User user){
				subject=subject.replaceAll("(\r\n|\r|\n|\n\r)",""); //替换换行符
				if(subject.equals("")){
					return "("+SystemEnv.getHtmlLabelName(31240,user.getLanguage())+")";
				}else{
					return subject;
				}
			}
			
			public static int getWeekOfYear(Date date, int firstDay) {
			     Calendar c = new GregorianCalendar();
			     c.setFirstDayOfWeek(firstDay);
			     c.setTime (date);
			
			     return c.get(Calendar.WEEK_OF_YEAR);
     		}
			
			// 获取当前时间所在年的周数
		    public static int getWeekOfYear(Date date) {
		        Calendar c = new GregorianCalendar();
		        c.setFirstDayOfWeek(Calendar.MONDAY);
		        c.setMinimalDaysInFirstWeek(7);
		        c.setTime(date);

		        return c.get(Calendar.WEEK_OF_YEAR);
		    }
			
			public static String getMailFlagLogo(int flag, int language) {
				String classname = "";
				int labelid = 0;
				if(flag == 1) {
					classname = "Rp";
					labelid = 125056;
				}else if (flag == 3){
					classname = "Fw";
					labelid = 125055;
				}else if (flag == 4) {
					classname = "Rf";
					labelid = 125057;
				}
				
				return "<div class='cir left "+classname+"' title='"+SystemEnv.getHtmlLabelName(labelid,language)+"'>&nbsp;</div>";
			}
		%>