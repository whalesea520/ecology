<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.*"%>

<%
		
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	
	
	User user = HrmUserVarify.getUser(request, response);
	MenuMaint mm = new MenuMaint("left", 3, user.getUID(), user.getLanguage());
	List topMenus = mm.getAllMenus(user, 0);

	for (int i = 0; i < topMenus.size(); i++) {
		Map mky = (Map) topMenus.get(i);

		String levelId = (String) mky.get("levelid");
		List childMenus = (List) mky.get("child");
		String strmhtms = "";
		String id =  (String) mky.get("id");
		if (mky.get("extra") == null) {

			int level = Integer.parseInt(levelId);
			String linkName = "";
			String linkAddr = "";
			strmhtms = grtlftMenu(childMenus, user);
			if (!"".equals(linkName) && !"".equals(linkAddr)) {
				String tmpLi = "<li>";
				tmpLi += "<a id="+id+" class='lfMenuItem' href='";
				tmpLi += linkAddr;
				tmpLi += "' _bgPosition='0 -28'";
				tmpLi += " target=\"mainFrame\" >";
				tmpLi += "<div class=\"leftMenuItemLeft\" style=\"background-position:0 -28;\"></div>";
				tmpLi += "<div class=\"leftMenuItemCenter\"; style=\"\">";
				tmpLi += linkName;
				tmpLi += "</div>";
				tmpLi += "<div class=\"leftMenuItemRight\" style=\"\"></div>";
				
				tmpLi += "<div style='width:4px;'></div></a>";
				tmpLi += "</li>";

				strmhtms = strmhtms.substring(0, 4) + tmpLi
						+ strmhtms.substring(4);
			}
		}
		out.write("menuMap.put('" + levelId + "', \""
				+ strmhtms.replaceAll("\"", "####") + "\");");
	}
%>

<%!
	public String grtlftMenu(List elements, User user) {

		if (elements == null) {
			return "<ul></ul>";
		}

		//左侧菜单HTML
		StringBuffer sfcm = new StringBuffer();
		//---------------------------
		// 菜单项背景图片随机显示
		// bgcnt   : 左侧菜单背景图片个数
		// bgindex : 左侧菜单背景图片随机用下标
		// abgs    : 左侧菜单背景图片数组
		//---------------------------
		int bgcnt = 4;
		int bgindex = 4;

		String[] sbgPostions = new String[] { "0 -28", "0 -84", "0 0", "0 -56" };

		sfcm.append("<ul>");
		for (int licnter = 0; licnter < elements.size(); licnter++) {
			Map map = (Map) elements.get(licnter);

			bgindex++;

			sfcm.append(getChildMenu(map, sbgPostions[bgindex % 4]));

			String extra = Util.null2String((String) map.get("extra"));

			if (extra != null && !"".equals(extra)) {

			} else {
				List chilList = (List) map.get("child");

				if (chilList != null && !chilList.isEmpty()) {
					String shtm = grtlftMenu(chilList, user);
					sfcm.append(shtm);
				}
			}

			sfcm.append("</li>");
		}
		sfcm.append("</ul>");

		return sfcm.toString();

	}

	public String getChildMenu(Object obj, String sbgPosition) {
		StringBuffer sfcm = new StringBuffer();
		
		if (!(obj instanceof Map)) {
			return sfcm.toString();	
		}
		
		Map map = (Map) obj;

		//sfcm.append("<li><div style='width:100%;'> ");
		sfcm.append("<li><div> ");
		sfcm.append("<a id="+map.get("id")+" class='lfMenuItem' href='");
		if (map.get("url") == null || map.get("url").toString().equals("")
				|| map.get("url").toString().equals("#")) {
			sfcm.append("javascript:void(0);");
		} else {
			sfcm.append(((String) map.get("url")).replaceAll("&#38;", "&"));
		}
        String menuname=map.get("name").toString();
		//sfcm.append("' style='background:url(").append(abg).append(") no-repeat;' ");
		sfcm.append("' _bgPosition='" + sbgPosition + "'");
		sfcm.append(" target='" + map.get("target") + "' title='" + menuname + "'>");
		sfcm.append("<div class='leftMenuItemLeft' style='background-position:" + sbgPosition + ";'></div>");
		sfcm.append("<div class='leftMenuItemCenter' style=''><span class='e8text'>");
		sfcm.append(menuname);
		sfcm.append("</span><span style='display:none;' class='iconImage'>")
				 	.append(map.get("icon")).append("</span>");
		sfcm.append("<span class='e8_number' id='num_"+map.get("levelid").toString()+"'></span>");
		sfcm.append("</div>");
		sfcm.append("<div class='leftMenuItemRight' style=''></div><div style='width:4px;display:none;'></div></a></div>");


		return sfcm.toString();
	}
	%>