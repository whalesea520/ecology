
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="farecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ttSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sysFavouriteInfo" class="weaver.favourite.SysFavouriteInfo" scope="page" />
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page"/>
<%
Set favouriteKeys = null;
Map favouriteMap = null;
User user = HrmUserVarify.getUser (request , response) ;
int userid = user.getUID();
String uploadPath = "/TemplateFile/";
%>
<link rel="stylesheet" href="/wui/common/js/MenuMatic/css/MenuMatic_wev8.css" type="text/css" media="screen" charset=UTF-8 />
<script src="/wui/common/jquery/jquery_wev8.js"></script>
<script src="/wui/common/js/MenuMatic/js/mootools-yui-compressed_wev8.js"></script>
<script src="/wui/common/js/MenuMatic/js/MenuMatic_0.68.3-source_wev8.js" type="text/javascript"></script>

 <ul id="navFav">
 <li id="favLi"> 
	<a href="#" ><%=SystemEnv.getHtmlLabelName(2081,user.getLanguage()) %></a>
  	<ul id="contentUl">
  		<li><a href="/favourite/ManageFavourite.jsp" target="mainFrame"><img alt="" src="/images_face/ecologyFace_2/LeftMenuIcon/favs_wev8.gif">&nbsp;<%=SystemEnv.getHtmlLabelName(22248,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
  	<%
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
		//pagename = pagename.replaceAll("&nbsp;", "");
		if(length<=25)
		{
			int addspace = 25-length;
			for(int j=0;j<addspace;j++)
			{
				//pagename+="&nbsp;";
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
	
	<li><a href="javascript:void(0)" onclick="openFullWindowForLong('<%=url%>');"><img alt="" src="<%=favouritetype %>">&nbsp;<%=pagename %></a></li>
<%
}
%>
<%
	String ttsql = " select * from favourite where resourceid="+userid+" order by displayorder,adddate desc ";
	ttSet.executeSql(ttsql);
	
	while (ttSet.next())
	{
		String favouriteid = Util.null2String(ttSet.getString("id"));
		String favouritename = Util.null2String(ttSet.getString("favouritename"));
		int tlength = favouritename.length();
		favouritename = favouritename.replaceAll("&nbsp", "");
		if(tlength<=25)
		{
			int addspace = 25-tlength;
			for(int j=0;j<addspace;j++)
			{
				//favouritename+="&nbsp;";
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
 		<li>
 			<a href="#"><img alt="" src="/images/folder.small_wev8.png">&nbsp;<%=favouritename %></a>
 			<ul>
 			<%
 				String tsql = "select b.* from sysfavourite_favourite a,sysfavourite b"
			+ " where a.favouriteid="
			+ favouriteid
			+ " and a.sysfavouriteid=b.id and a.resourceid=b.resourceid and a.resourceid="
			+ userid
			+ " order by importlevel desc,adddate desc,b.id desc";
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
						//temppagename+="&nbsp;";
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

				 <li><a href="javascript:void(0)" onclick="openFullWindowForLong('<%=url%>');"><img alt="" src="<%=favouritetype %>">&nbsp;<%=temppagename %></a></li>
<%
			}
		}
		else
		{
			String temppagename = SystemEnv.getHtmlLabelName(22249,user.getLanguage())+"";
		%>
	
			  <li><a href="#"><%=temppagename %></a></li>
		<%		
		}
		%>
 			</ul>
 		</li>
<%
	}
%>
	</ul>
   </li>
</ul>
<li id="moreLi" style='display:none'><a href="/favourite/ManageFavourite.jsp" target="mainFrame"><img alt="" src="/images_face/ecologyFace_2/LeftMenuIcon/more_wev8.png">&nbsp;<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage()) %></a></li>
<style type="text/css" media="all">
	a img
	{ 
		border:none;
	}
</style>
<SCRIPT LANGUAGE="JavaScript">
jQuery(document).ready(function(){
	var myMenu = new MenuMatic();
})

</SCRIPT>
