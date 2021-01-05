
<jsp:useBean id="styleUtil" class="weaver.page.style.StyleUtil" scope="page"/>
<%

	hpsb=styleUtil.getHpsb(menuStyleid);
	String backgroundImg = hpsb.getBackgroundImg();
	String backgroudColor = hpsb.getBackgroundColor();
	String navcolor=hpsb.getNavcolor();
	String navbgcolor=hpsb.getNavbgcolor();
	String navselectedbgcolor=hpsb.getNavselectedbgcolor();
	String navselectedcolor=hpsb.getNavselectedcolor();
	String navbordercolor=hpsb.getNavbordercolor();
	String navbackgroudimg=hpsb.getNavbackgroudimg();
	String navselectedbackgroudimg=hpsb.getNavselectedbackgroudimg();
	
	String subnavcolor = hpsb.getSubnavcolor();
	String subnavbgcolor=hpsb.getSubnavbgcolor();
	String subnavselectedbgcolor=hpsb.getSubnavselectedbgcolor();
	String subnavselectedcolor=hpsb.getSubnavselectedcolor();
	String subnavbordercolor=hpsb.getSubnavbordercolor();
	String subnavbackgroudimg =hpsb.getSubnavbackgroudimg();
	String subnavselectedbackgroudimg=hpsb.getSubnavselectedbackgroudimg();
	
	String navfont=hpsb.getNavfont();
	String navfontsize=hpsb.getNavfontsize();
	String navselectfont=hpsb.getNavselectfont();
	String navselectfontsize=hpsb.getNavselectfontsize();
	String subnavfont=hpsb.getSubnavfont();
	String subnavfontsize=hpsb.getSubnavfontsize();
	String subnavselectfont=hpsb.getSubnavselectfont();
	String subnavselectfontsize=hpsb.getSubnavselectfontsize();
	String borderwidth=hpsb.getBorderwidth();
	String bordertype=hpsb.getBordertype();
	String mainImg = hpsb.getIconMainDown();
	String subImg = hpsb.getIconSubDown();
	String navfontstyle="";
	String navfontweight="";
	String subnavfontstyle="";
	String subnavfontweight="";
	
	String cornerTop = hpsb.getCornerTop();
	String cornerBottom = hpsb.getCornerBottom();
	String cornerTopRadian = hpsb.getCornerTopRadian();
	String cornerBottomRadian = hpsb.getCornerBottomRadian();
%>
<style type="text/css" id="styleMenu">
		.navigate{
			color:<%=navcolor%>;/*前景色*/
			<%
			if("".equals(backgroundImg)){
				out.println("background:"+backgroudColor+";       /*背景色*/");
			} else {
				out.println("background:url('"+backgroundImg+"');");
				//out.println("background:"+navbgcolor+";       /*背景色*/");
			}				
			%>
			
			
            <%if(!"".equals(navselectedbgcolor)) {
                //out.println("border-bottom:3px solid "+navselectedbgcolor+";");
            }%>
            padding-left:'5px';
          	font-style:<%=navfontstyle%>;
			font-weight:<%=navfontweight%>;
			font-size:		<%=navfontsize%>;
			FONT-FAMILY: "<%=navfont%>";
			border-left:0;    
			
		}
		.divMenu {   		
			float:			left;
			padding:		6px 6px 6px 6px;
			z-index:		1;
			top:			0;
			border-right-width:<%=borderwidth%>;
			border-right-style:<%=bordertype%>;
			border-right-color:<%=navbordercolor%>;/*边框颜色*/
			position:		relative;
			height:16;
			_height:28;
			<%
			if("".equals(navbackgroudimg)){
				out.println("background:"+navbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navbackgroudimg+"');");
				//out.println("background:"+navbgcolor+";       /*背景色*/");
			}				
			%>
			
		}
		.divMenuSelected {
			<%
			if("".equals(navselectedbackgroudimg)){
				out.println("background:"+navselectedbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+navselectedbackgroudimg+"');");
			}				
			%>			
			color:<%=navselectedcolor%>;   
			font-style:<%=navfontstyle%>;
			font-weight:<%=navfontweight%>;
		   	font-size:		<%=navselectfontsize%>;
			FONT-FAMILY: "<%=navselectfont%>";
			float:			left;
			padding:		6px 6px 6px 6px;
			
			border-right-width:<%=borderwidth%>;
			border-right-style:<%=bordertype%>;
			border-right-color:<%=navbordercolor%>;/*边框颜色*/
			z-index:		1;
			top:			0;
			position:		relative;
			height:16;
			_height:28;
		}

		.subNavigate{
            z-index:		2;
            color:<%=subnavcolor%>;/*前景色*/
			border-right-width:<%=borderwidth%>;
			border-right-style:<%=bordertype%>;
			border-right-color:<%=navbordercolor%>;/*边框颜色*/
			font-style:<%=subnavfontstyle%>;
			font-weight:<%=subnavfontweight%>;
			font-size:		<%=subnavfontsize%>;
			FONT-FAMILY: "<%=subnavfont%>";
			border-bottom:0;  
			
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=100);
		}
		.divSubMenu {   
            <%
			if("".equals(subnavbackgroudimg)){
				out.println("background:"+subnavbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+subnavbackgroudimg+"');");
			}				
			%>
			cursor:pointer;
			float:none;
	
			padding:3px 1px 1px 1px;
			border-bottom:	1px solid <%=subnavbordercolor%>;
			
		}
		.divSubMenuSelected {
			<%
			if("".equals(subnavselectedbackgroudimg)){
				out.println("background:"+subnavselectedbgcolor+";       /*背景色*/");
			} else {
				out.println("background:url('"+subnavselectedbackgroudimg+"');");
			}				
			%>	
			color:<%=subnavselectedcolor%>;  		
			font-style:normal;&#13;
			font-weight:bold;&#13;
			font-size:		<%=subnavselectfontsize%>;
			FONT-FAMILY: "<%=subnavselectfont%>"; 
			font-style:<%=subnavfontstyle%>;
			font-weight:<%=subnavfontweight%>;  
			cursor:pointer;
			float:none;
			
			padding:3px 1px 1px 1px;
			border-bottom:	1px solid <%=subnavbordercolor%>;
			filter:progid:DXImageTransform.Microsoft.Alpha(opacity=100);
		}
		
	</style>