
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="farecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ttSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sysFavouriteInfo" class="weaver.favourite.SysFavouriteInfo" scope="page" />
<%
Set favouriteKeys = null;
Map favouriteMap = null;
%>
<SCRIPT language=javascript src="/FCKEditor/swfobject_wev8.js" type=text/javascript></SCRIPT>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<SCRIPT src="/favourite/js/menu4/js/poslib_wev8.js" type=text/javascript></SCRIPT>
<SCRIPT src="/favourite/js/menu4/js/scrollbutton_wev8.js" type=text/javascript></SCRIPT>
<SCRIPT src="/favourite/js/menu4/js/menu4_wev8.js" type=text/javascript></SCRIPT>
<script type="text/javascript" src="/favourite/js/menu4/skins/winxp.css_wev8.js"></script>
<STYLE>
.menu-bar .menu-button {
	<%if(UsrTemplate.getToolbarBgImage().equals("")){%>
		background-image:url(/images/StyleGray/toolbarBg_wev8.jpg);
	<%}else if(!UsrTemplate.getToolbarBgImage().equals("0")){%>
		background-image:url(<%=uploadPath+UsrTemplate.getToolbarBgImage()%>);
	<%}%>
	background-color:<%=UsrTemplate.getToolbarBgColor()%>;
	
	color:		black;	
	padding:	7px 0px 6px 0px;
	border:		0;
	margin:		0;
	display:	;
	white-space:	nowrap;
}
</STYLE>
<SCRIPT type=text/javascript><!--
//<![CDATA[
Menu.prototype.cssFile = "/favourite/js/menu4/skins/officexp/officexp_wev8.css";
Menu.prototype.mouseHoverDisabled = false;
var tmp;
var mb = new MenuBar();
var menu = new Menu();

mItem = new MenuItem("<%=SystemEnv.getHtmlLabelName(22248,user.getLanguage())%>","/favourite/ManageFavourite.jsp");
mItem.target = "mainFrame";
menu.add(mItem);
menu.add( new MenuSeparator() );
<%
	//farecordSet.executeProc("SysFavourite_SelectByUserID", userid + "");
	String tesql = "";
	tesql = "select top 20 a.* "
			+ " from sysfavourite a, sysfavourite_favourite b "
			+ " where a.resourceid =" + userid
			+ " and a.id = b.sysfavouriteid and b.favouriteid=-1 order by importlevel desc,adddate desc,a.id desc";
	
	String dbtype = farecordSet.getDBType();
	if(dbtype.equals("oracle"))
	{
						 tesql = " select *   from (SELECT *   FROM (SELECT A.*, ROWNUM RN  FROM (select a.id, rownum   from sysfavourite a  "
  + " left join sysfavourite_favourite b on a.id =   b.sysfavouriteid   where a.resourceid = "+userid
   + " and b.favouriteid = -1   order by a.importlevel desc,    a.adddate "
    + " desc,    a.id          desc) A   WHERE ROWNUM < 20)   WHERE RN >= 0) c   left join sysfavourite_favourite d on "
     + " c.id = d.sysfavouriteid left join sysfavourite e on c.id=e.id order by importlevel desc,adddate desc,c.id desc ";


	}
	farecordSet.execute(tesql);
	int favCount = 0;
	while (farecordSet.next())
	{
		String pagename = farecordSet.getString("Pagename");
		String url = farecordSet.getString("URL");
		String favouritetype = farecordSet.getString("favouritetype");
		favouritetype = sysFavouriteInfo.getFavouriteTypeImage(favouritetype);
		int length = pagename.length();
		pagename = pagename.replaceAll("&nbsp", "＆nbsp");
		if(length<=25)
		{
			int addspace = 25-length;
			for(int j=0;j<addspace;j++)
			{
				pagename+="&nbsp;";
			}
			pagename = Util.toHtml5(pagename);
		}
		else
		{
			pagename = pagename.substring(0, 25);
			pagename = Util.toHtml5(pagename);
			pagename+="...";
		}
%>
mItem = new MenuItem("<%=pagename %>","<%=url%>","<%=favouritetype %>",null);
mItem.target = "";
menu.add(mItem);
<%
}
%>
<%
	String ttsql = " select top 10 * from favourite where resourceid="+userid+" order by displayorder,adddate desc ";
	if(dbtype.equals("oracle"))
	{
		ttsql = " select *   from (SELECT *   FROM (SELECT A.*, ROWNUM RN  FROM (select * from favourite where resourceid="+userid+" order by displayorder,adddate desc)A   WHERE ROWNUM < 10) WHERE RN >= 0)";
	}
	ttSet.executeSql(ttsql);
	while (ttSet.next())
	{
		String favouriteid = Util.null2String(ttSet.getString("id"));
		String favouritename = Util.null2String(ttSet.getString("favouritename"));
		int tlength = favouritename.length();
		favouritename = favouritename.replaceAll("&nbsp", "＆nbsp");
		if(tlength<=25)
		{
			int addspace = 25-tlength;
			for(int j=0;j<addspace;j++)
			{
				favouritename+="&nbsp;";
			}
			favouritename = Util.toHtml5(favouritename);
		}
		else
		{
			favouritename = favouritename.substring(0, 25);
			favouritename = Util.toHtml5(favouritename);
			favouritename+="...";
		}
%>
menu_<%=favouriteid %> = new Menu();
mItem = new MenuItem("<%=favouritename %>","","/images/folder.small_wev8.png",menu_<%=favouriteid %>);
mItem.target = "mainFrame";
menu.add(mItem);
<%
		String tsql = "select top 10 b.* from sysfavourite_favourite a,sysfavourite b"
			+ " where a.favouriteid="
			+ favouriteid
			+ " and a.sysfavouriteid=b.id and a.resourceid=b.resourceid and a.resourceid="
			+ userid
			+ " order by importlevel desc,adddate desc,b.id desc";
		if(dbtype.equals("oracle"))
		{
			tsql = " select *   from (SELECT *   FROM (SELECT A.*, ROWNUM RN  FROM (select b.* from sysfavourite_favourite a,sysfavourite b"
			+ " where a.favouriteid="
			+ favouriteid
			+ " and a.sysfavouriteid=b.id and a.resourceid=b.resourceid and a.resourceid="
			+ userid
			+ " order by importlevel desc,adddate desc,b.id desc)A   WHERE ROWNUM < 10) WHERE RN >= 0)";
		}
		farecordSet.executeSql(tsql);
		if (farecordSet.first())
		{
			farecordSet.beforFirst();
			while (farecordSet.next())
			{
				String url = farecordSet.getString("url");
				String temppagename = farecordSet.getString("pagename");
				String pagename = farecordSet.getString("pagename");
				String favouritetype = farecordSet.getString("favouritetype");
				favouritetype = sysFavouriteInfo.getFavouriteTypeImage(favouritetype);
				int length = temppagename.length();
				temppagename = temppagename.replaceAll("&nbsp", "＆nbsp");
				if(length<=25)
				{
					int addspace = 25-length;
					for(int j=0;j<addspace;j++)
					{
						temppagename+="&nbsp;";
					}
					temppagename = Util.toHtml5(temppagename);
				}
				else
				{
					temppagename = pagename.substring(0, 25);
					temppagename = Util.toHtml5(temppagename);
					temppagename+="...";
				}
%>
				mItem = new MenuItem("<%=temppagename %>","<%=url%>","<%=favouritetype %>",null);
				mItem.target = "";
				menu_<%=favouriteid %>.add(mItem);
<%
			}
		}
		else
		{
			String temppagename = SystemEnv.getHtmlLabelName(22249,user.getLanguage());
		%>
		mItem = new MenuItem("<%=temppagename %>","","",null);
		mItem.target = "mainFrame";
		menu_<%=favouriteid %>.add(mItem);
		<%		
		}
	}
%>
mb.add(tmp = new MenuButton("<span style='cursor:hand;width:50px;color:#172971'><%=SystemEnv.getHtmlLabelName(2081,user.getLanguage())%>▼</span>",menu,"","mainFrame"));
tmp.mnemonic = 's';
//]]>
--></SCRIPT>