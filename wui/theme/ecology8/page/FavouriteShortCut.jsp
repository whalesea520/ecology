
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.*" %>
<jsp:useBean id="farecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ttSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="favSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="favSet2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sysFavouriteInfo" class="weaver.favourite.SysFavouriteInfo" scope="page" />
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page"/>
<%


%>
<%
Set favouriteKeys = null;
Map favouriteMap = null;
User user = HrmUserVarify.getUser (request , response) ;
int userid = user.getUID();
String uploadPath = "/TemplateFile/";
%>
  <li id="favLi"> 
	<a href="#"  style="background-position:-250 0;display:block;" class="tbItm"></a>
  	<ul id="contentUl">
  		<li><a style="background-color:#ebebeb" href="/favourite/ManageFavourite.jsp" target="mainFrame"><img alt="" src="/images_face/ecologyFace_2/LeftMenuIcon/favs_wev8.png">&nbsp;<%=SystemEnv.getHtmlLabelName(22248,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</a></li>
  	<%
  	/**用于动态调整收藏文件和文件夹显示数量 start*/
  	int total = 20;   //显示的最大数量
  	int total1 = 10;  //默认文件数量最大
  	int total2 = 10;  //默认文件夹最大数量
  	int count1 = 0;
  	int count2 = 0;
  	boolean showMore = false;  //是否显示更多按钮
  	//查询文件的数量
  	String csql1 = " select count(a.id) as resultCount"
  			     + " from sysfavourite a, sysfavourite_favourite b "
  			     + " where a.resourceid = " + userid
  			     + " and a.id = b.sysfavouriteid and b.favouriteid=-1";
  	//查询文件夹的数量
  	String csql2 = " select count(*) as resultCount from favourite where resourceid = "+userid;
  	favSet1.executeSql(csql1);
  	if(favSet1.next())
  	{
		count1 = favSet1.getInt(1);  		
  	}
  	favSet2.executeSql(csql2);
  	if(favSet2.next())
  	{
  		count2 = favSet2.getInt(1);
  	}
  	if((count1 > total1 && count2 > total2) || (count1 + count2) > total)   //表示快捷菜单不能显示所有要显示的数据，需要显示更多按钮
  	{
  		showMore = true;
  	}
  	
  	if(count1 < total1)  //文件数量小于最大显示数量，动态调整文件夹的显示数量
  	{
  		total1 = count1;
  		total2 = total - count1;
  	}else if(count2 < total2){   //文件夹数量小于最大显示数量，动态调整文件的显示数量
  		total2 = count2;
  		total1 = total - count2;
  	}
  	/**用于动态调整收藏文件和文件夹显示数量 end*/
	String tesql = "";
	tesql = "select top " + total1 + " a.* "
			+ " from sysfavourite a, sysfavourite_favourite b "
			+ " where a.resourceid =" + userid
			+ " and a.id = b.sysfavouriteid and b.favouriteid=-1 order by importlevel desc,adddate desc,a.id desc";
	
	String dbtype = farecordSet.getDBType();
	if(dbtype.equals("oracle"))
	{
		tesql = "select t.* from (select a.* "
			+ " from sysfavourite a, sysfavourite_favourite b "
			+ " where a.resourceid =" + userid
			+ " and a.id = b.sysfavouriteid and b.favouriteid =-1 order by importlevel desc,adddate desc,a.id desc) t where rownum <= " + total1;
	}
	
	farecordSet.execute(tesql);
	int favCount = 0;
	int len = 25;
	while (farecordSet.next())
	{
		String pagename = farecordSet.getString("Pagename");
		String url = farecordSet.getString("URL");
		String favouritetype = farecordSet.getString("favouritetype");
		favouritetype = sysFavouriteInfo.getFavouriteTypeImage(favouritetype);
		//int length = pagename.length();
		pagename = pagename.replaceAll("&nbsp;", "");
		int length = sysFavouriteInfo.getLength(pagename);
		String tempName = pagename;  //备份未截取前的名称，作为tip显示
		if(length<=len)
		{
			int addspace = len-length;
			for(int j=0;j<addspace;j++)
			{
				//pagename+="&nbsp;";
			}
			pagename = Util.toHtml5(pagename);
		}
		else
		{
			//pagename = pagename.substring(0, 18);
			pagename = sysFavouriteInfo.substring(pagename,len);
			pagename = Util.toHtml5(pagename);
			pagename+="...";
		}
%>
	
	<li><a href="javascript:void(0)" onclick="openFullWindowForLong('<%=url%>');" title="<%=tempName%>"><img alt="" src="<%=favouritetype %>">&nbsp;<%=pagename %></a></li>
<%
}
%>
<%
	String ttsql = " select top " + total2 + " * from favourite where resourceid="+userid+" order by displayorder,adddate desc ";
	if(dbtype.equals("oracle"))
	{
		ttsql = " select *   from (SELECT *   FROM (SELECT A.*, ROWNUM RN  FROM (select * from favourite where resourceid="+userid+" order by displayorder,adddate desc)A   WHERE ROWNUM <= " + total2 + ") WHERE RN >= 0)";
	}
	ttSet.executeSql(ttsql);
	
	while (ttSet.next())
	{
		String favouriteid = Util.null2String(ttSet.getString("id"));
		String favouritename = Util.null2String(ttSet.getString("favouritename"));
		//int tlength = favouritename.length();
		favouritename = favouritename.replaceAll("&nbsp", "");
		int tlength = sysFavouriteInfo.getLength(favouritename);
		String tempName = favouritename;  //备份未截取前的名称，作为tip显示
		if(tlength<=len)
		{
			int addspace = len-tlength;
			for(int j=0;j<addspace;j++)
			{
				//favouritename+="&nbsp;";
			}
			favouritename = Util.toHtml5(favouritename);
		}
		else
		{
			//favouritename = favouritename.substring(0, 18);
			favouritename = sysFavouriteInfo.substring(favouritename,len);
			favouritename = Util.toHtml5(favouritename);
			favouritename+="...";
		}
%>
 		<li>
 			<a href="#" title="<%=tempName%>"><img alt="" src="/images/folder.fav_wev8.png">&nbsp;<%=favouritename %></a>
 			<ul>
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
				//int length = temppagename.length();
				temppagename = temppagename.replaceAll("&nbsp", "＆nbsp");
				int length = sysFavouriteInfo.getLength(temppagename);
				if(length<=len)
				{
					int addspace = len-length;
					for(int j=0;j<addspace;j++)
					{
						//temppagename+="&nbsp;";
					}
					temppagename = Util.toHtml5(temppagename);
				}
				else
				{
					//temppagename = pagename.substring(0, 18);
					temppagename = sysFavouriteInfo.substring(pagename,len);
					temppagename = Util.toHtml5(temppagename);
					temppagename+="...";
				}
%>

				 <li><a href="javascript:void(0)" onclick="openFullWindowForLong('<%=url%>');" title="<%=pagename%>"><img alt="" src="<%=favouritetype %>">&nbsp;<%=temppagename %></a></li>
<%
			}
		}
		else
		{
			String temppagename = SystemEnv.getHtmlLabelName(22249,user.getLanguage());
		%>
	
			  <li><a href="#"><span style="width:11px;height:16px;display:inline-block;">&nbsp;</span><%=temppagename %><span style="width:12px;height:16px;display:inline-block;">&nbsp;</span></a></li>
		<%		
		}
		%>
 			</ul>
 		</li>
<%
	}
	if(showMore){
%>
   <li id="moreLiLink"><a href="/favourite/ManageFavourite.jsp" target="mainFrame"><img alt="" src="/images_face/ecologyFace_2/LeftMenuIcon/more_wev8.png">&nbsp;<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage()) %></a></li>		
<%		
	}
%>
	</ul>
   </li>
<li id="moreLi" style='display:none'><a href="/favourite/ManageFavourite.jsp" target="mainFrame"><img alt="" src="/images_face/ecologyFace_2/LeftMenuIcon/more_wev8.png">&nbsp;<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage()) %></a></li>
<style type="text/css" media="all">
	a img
	{ 
		border:none;
	}
	.smOW li{
		width:100%;
	}
</style>
<SCRIPT LANGUAGE="JavaScript">
	var x = -166;
	if(jQuery.browser.webkit){
		x = -180;
	}

	var myMenu = new MenuMatic({tweakSubsequent:{x:-6,y:0},tweakInitial:{x:x,y:15},direction:{	x: 'left',	y: 'down' },onInit_complete:function(){
		
		},
		opacity:100,
		onHideSubMenu_complete:function(){
			jQuery("#"+this.id).closest("td").removeClass("favBtnSel");
			//console.log(this.childMenu);
		},
		onShowSubMenu_begin:function(){
			if(!jQuery("#"+this.id).closest("td").hasClass("favBtnSel")){	
				jQuery("#"+this.id).closest("td").addClass("favBtnSel");
			}
		}
		});
	
	


</SCRIPT>

