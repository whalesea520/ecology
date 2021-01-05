<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="sysFavourite" class="weaver.favourite.SysFavourite" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
		User user = HrmUserVarify.getUser(request, response);
		if (user == null) return;
		sysFavourite.setUser(user);
		sysFavourite.setRequest(request);
		String isshowrepeat = Util.null2String(request.getParameter("isshowrepeat"));    //转发的临时处理方式
		
		Map result = sysFavourite.searchSysFavourite();
		int total = Util.getIntValue(Util.null2String(result.get("total")),-1);
		int count = Util.getIntValue(Util.null2String(result.get("count")),0);
		int maxId = Util.getIntValue(Util.null2String(result.get("maxId")),-1);
		int current = Util.getIntValue(Util.null2String(result.get("current")),-1);
		String favids = "";
		if(result.containsKey("data")){
			List<Map> data = (List<Map>)result.get("data");
			int dataSize = data.size();
			for(int i = 0; i < dataSize; i++){
			Map bean = data.get(i);
			String favid = Util.null2String(bean.get("favid"));
			String dirid = Util.null2String(bean.get("dirid"));
			String resourceid = Util.null2String(bean.get("resourceid"));
			String adddate = Util.null2String(bean.get("adddate"));
			String favname = Util.null2String(bean.get("favname"));
			String favouriteObjid = Util.null2String(bean.get("favouriteObjid"));
			String favouritetype = Util.null2String(bean.get("favouritetype"));
			String url = Util.null2String(bean.get("url"));
			String importantLevel = Util.null2String(bean.get("importantLevel"));
			
			String msgobjname = Util.null2String(bean.get("msgobjname"));
			String content = Util.null2String(bean.get("content"));
			String senderid = Util.null2String(bean.get("senderid"));
			String senddate = Util.null2String(bean.get("senddate"));
			String sendtime = Util.null2String(bean.get("sendtime"));
			String contentHtml = Util.null2String(bean.get("contentHtml"));
			String extra = Util.null2String(bean.get("extra"));
			if(!"".equals(adddate)){
				int index = adddate.indexOf(" ");
				if(index > 0){
					adddate = adddate.substring(0,index);
				}
			}
			
			String icon = "";
			String iconTitle = "";
			
			/**收藏为消息类型才有的一些信息***/
			String msgtype = "";    //消息类型
			String filesize = "";   //附件类型时，附件的大小
			String filetype = "";   //附件类型时，附件类型
			if("1".equals(favouritetype)){    //文档
				icon = "/favourite/images2/doc_wev8.png";
				iconTitle = SystemEnv.getHtmlLabelName(58,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}else if("2".equals(favouritetype)){  //流程
				icon = "/favourite/images2/workflow_wev8.png";	
				iconTitle = SystemEnv.getHtmlLabelName(18015,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}else if("3".equals(favouritetype)){  //项目
				icon = "/favourite/images2/project_wev8.png";	
				iconTitle = SystemEnv.getHtmlLabelName(101,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}else if("4".equals(favouritetype)){   //客户
				icon = "/favourite/images2/customer_wev8.png";
				iconTitle = SystemEnv.getHtmlLabelName(136,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}else if("5".equals(favouritetype)){   //其他
				icon = "/favourite/images2/others_wev8.png";
				iconTitle = SystemEnv.getHtmlLabelName(375,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}else if("6".equals(favouritetype)){   //消息
				resourceid = senderid;
				icon = "/favourite/images2/message_wev8.png";
				iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage());
				Map<String,String> msgInfo = sysFavourite.getMsgInfo(bean);
				String msgurl = msgInfo.get("url");
				String msgname = msgInfo.get("msgname");
				msgtype = msgInfo.get("msgtype");
				if("1".equals(msgtype) || "3".equals(msgtype)){  //纯文本、公告
					favname = msgname;
					favname = favname.replaceAll("\r", "").replaceAll("\n", "<br>");
					// 解决手机端收藏表情显示乱码的问题
					favname = java.net.URLDecoder.decode(favname, "UTF-8");
				}else if("2".equals(msgtype)){  //图片
					favname = "<img title=\"" + favname +"\" src=\"data:image/jpg;base64," + msgname + "\" onclick=\"openFullWindowHaveBar('" + msgurl + "');\" />";
				}else if("4".equals(msgtype) || "6".equals(msgtype) || "7".equals(msgtype) || "8".equals(msgtype) || "9".equals(msgtype)){
					//附件、流程、文档、任务、客户
					favname = "<a href=\"javascript:openFullWindowForLong('" + msgurl + "')\">" + msgname + "</a>";
				}
				if("4".equals(msgtype)){   //附件
					icon = "/favourite/images2/attachment_wev8.png";	
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(156,user.getLanguage());
					//附件的信息
					filesize = Util.null2String(msgInfo.get("filesize"));
					filesize = Util.null2String(msgInfo.get("filetype"));
				}else if("5".equals(msgtype)){  //名片
					icon = "/favourite/images2/hrmcard_wev8.png";	
					//iconTitle = "消息:名片";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(126356,user.getLanguage());
				}else if("6".equals(msgtype)){  //流程
					icon = "/favourite/images2/workflow_wev8.png";	
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(18015,user.getLanguage());
				}else if("7".equals(msgtype)){  //文档
					icon = "/favourite/images2/doc_wev8.png";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(58,user.getLanguage());
				}else if("8".equals(msgtype)){   //任务
					icon = "/favourite/images2/favtask_wev8.png";	
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(1332,user.getLanguage());
				}else if("9".equals(msgtype)){   //客户
					icon = "/favourite/images2/customer_wev8.png";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(136,user.getLanguage());
				}else if("10".equals(msgtype)){   //图文
					icon = "/favourite/images2/message_wev8.png";
					//iconTitle = "消息:图文";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(81638,user.getLanguage());
				}else if("11".equals(msgtype)){   //位置
					icon = "/favourite/images2/message_wev8.png";
					//iconTitle = "消息:位置";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(22981,user.getLanguage());
				}else if("12".equals(msgtype)){   //语音
					icon = "/favourite/images2/message_wev8.png";
					//iconTitle = "消息:语音";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(126357,user.getLanguage());
				}else if("13".equals(msgtype)){   //必达
					icon = "/favourite/images2/bing_wev8.png";
					//iconTitle = "消息:必达";
					iconTitle = SystemEnv.getHtmlLabelName(24532,user.getLanguage()) + " : " + SystemEnv.getHtmlLabelName(126359,user.getLanguage());
				}
				
			}else{    //有些数据竟然没有类型，将都放入其他中吧
				icon = "/favourite/images2/others_wev8.png";
				iconTitle = SystemEnv.getHtmlLabelName(375,user.getLanguage());
				if(!"".equals(url)){
					favname = "<a href=\"javascript:openFullWindowForLong('" + url + "')\">" + favname + "</a>";
				}
			}
			
			String importtext = "";
			String importcss = "";
			if("3".equals(importantLevel)){
				importtext = SystemEnv.getHtmlLabelName(15533,user.getLanguage());
				importcss = "important";
			}else if("2".equals(importantLevel)){
				importtext = SystemEnv.getHtmlLabelName(25436,user.getLanguage());
				importcss = "middle";
			}else{
				importtext = SystemEnv.getHtmlLabelName(154,user.getLanguage());
				importcss = "normal";
			}
			
			favids += "," + favid;
%>
	<div class="favitem" id="fav<%=favid%>" data-options="id:'<%=favid%>',dirid:'<%=dirid%>',level:'<%=importantLevel%>',isclick:'false'">
		<input type="hidden" id="content_<%=favid%>" value="<%=content%>">
		<input type="hidden" id="msgobjname_<%=favid%>" value="<%=msgobjname%>">
		<input type="hidden" id="filesize_<%=favid%>" value="<%=filesize%>">
		<input type="hidden" id="filetype_<%=favid%>" value="<%=filetype%>">
		<input type="hidden" id="favouriteObjid_<%=favid%>" value="<%=favouriteObjid%>">
		
		<div class="favinfo">
			<div><input type="checkbox" name="favcheck"></div>
			<div class="fav_user">
			<a href="javaScript:openhrm(<%=resourceid%>);" onclick="pointerXY(event);"><%=resourceComInfo.getResourcename(resourceid)%></a>
			</div>
			<div class="fav_time"><%=adddate%></div>
			<%--普通级别的，不显示，但是要占位 --%>
			<div class="fav_level" id="level<%=favid%>" <%if("1".equals(importantLevel)){%>style="visibility: hidden;"<%}%>>
				<div class="text <%=importcss%>">
					<span title="<%=importtext%>"><%=importtext%></span>
				</div>
			</div>
			<div class="favop hideop" id="favop<%=favid%>">
			   <%if("6".equals(favouritetype) && "1".equals(isshowrepeat)){%>	
				<span class="repeat" title="<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%>"><a href="javascript:void(0);"></a></span>   <%--转发 --%>
				<%}%>
				<%if(!"6".equals(favouritetype)){%>
				<span class="edit" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"><a href="javascript:void(0)"></a></span>   <%--编辑 --%>
				<%}%>
				<span class="move" title="<%=SystemEnv.getHtmlLabelName(126355,user.getLanguage())%>"><a href="javascript:void(0)"></a></span>   <%--移动 --%>
				<span class="delete" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"><a href="javascript:void(0)"></a></span>   <%--删除 --%>
			</div>
		</div>
		<div class="favcontent">
			<div class="icon" title="<%=iconTitle%>">
				<img src="<%=icon%>">
			</div>
			<div class="text">
				<%if(msgtype.equals("5") || msgtype.equals("10") || msgtype.equals("11") || msgtype.equals("12") || msgtype.equals("13")){ %>
				<jsp:include page="/social/im/SocialIMFavouriteOp.jsp">
					<jsp:param name="msgobjname" value="<%=msgobjname %>"/>
					<jsp:param name="content" value="<%=content %>"/>
					<jsp:param name="contentHtml" value="<%=contentHtml %>"/>
					<jsp:param name="extra" value="<%=extra %>"/>
					<jsp:param name="favid" value="<%=favouriteObjid %>"/>
				</jsp:include>
				<%}else{%>
					<%=favname %>
				<%} %>
			</div>
		</div>
		<div style="clear: both;"></div>
	</div>
	<%--这是分隔线，因为它的背景色跟每一条记录的背景色不同，因此产生了分隔线的效果 --%>
	<div class="line"></div>   
<%			
			}	
			
			if(favids.length() > 0){
				favids = favids.substring(1);
			}		 
		}
%>
<input type="hidden" name="total" id="total" value="<%=total%>"/>
<input type="hidden" name="count" id="count" value="<%=count%>"/>
<input type="hidden" name="current" id="current" value="<%=current%>"/>
<input type="hidden" name="maxId" id="maxId" value="<%=maxId%>"/>
<input type="hidden" name="favids" id="favids" value="<%=favids%>"/>