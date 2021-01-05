
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader" %>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="oDocManager" class="weaver.docs.docs.DocManager" scope="page"/>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>


<%
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页
 
		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		valuecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>
<%
//图片大小
int imgWidth=120;
int imgHeight = 108;

ArrayList magazineList=new ArrayList();
if(!"".equals(strsqlwhere))	magazineList=Util.TokenizerString(strsqlwhere,"^,^");
if(magazineList.size()<=0) return;

boolean hasImg=false;
boolean hasTitle=false;
boolean hasBrief=false;
boolean hasList=false;

if(fieldColumnList.contains("img")) hasImg=true;
if(fieldColumnList.contains("docsubject")) hasTitle=true;
if(fieldColumnList.contains("summary")) hasBrief=true;
if(fieldColumnList.contains("list")) hasList=true;


int index = fieldColumnList.indexOf("img");

if(index!=-1){
	String imgfieldId = (String)fieldIdList.get(index);
	String sql = "";
	
	if(hpc.getIsLocked(hpid).equals("1")) {
		sql="select imgsize from hpFieldLength where eid="+ eid + " and efieldid=" + imgfieldId+"" +" and userid="+hpc.getCreatorid(hpid)+" and usertype="+hpc.getCreatortype(hpid);
	}else{
    	sql="select imgsize from hpFieldLength where eid="+ eid + " and efieldid=" + imgfieldId+"" +" and userid="+hpu.getHpUserId(hpid,""+subCompanyId,user)+" and usertype="+hpu.getHpUserType(hpid,""+subCompanyId,user);
	}

    rs.execute(sql);
    if (rs.next()){
			String imgSize = Util.null2String(rs.getString("imgsize"));
			
			if(!"".equals(imgSize)){
				ArrayList imgSizeAry = Util.TokenizerString(imgSize,"*");
				imgWidth = Util.getIntValue((String)imgSizeAry.get(0),imgWidth);
				imgHeight = Util.getIntValue((String)imgSizeAry.get(1),imgHeight);
			}
    }
    
}
List firDocIdlist=new ArrayList();
%>
<TABLE id="_contenttable_<%=eid%>" class=Econtent  width="100%" cellPadding='0' cellSpacing='0' <%if(magazineList.size()>0) out.println(" height='120px' ");%> >
   <TR>	
	<TD width=1px></TD>
	 <TD width='*' valign="top">
		<table  width="100%"  cellPadding='0' cellSpacing='0'>
		<%

		for(int i=0;i<magazineList.size();i++){
			String magzineType=(String)magazineList.get(i);
			String strList="";
			String typeName="";
			rs.executeSql("select name from WebMagazinetype where id="+magzineType);
			if(rs.next()) typeName=Util.null2String(rs.getString("name"));

			rs.executeSql("select id,name,releaseYear,docid from WebMagazine where typeID = " + magzineType+" order by id desc");
			
			strList+="<select style='width:70%' id=\"selectMagazine_"+i+"_"+eid+"\">";
			String firstMagazineId="";
			String firsDocId="";
			String firstReleaseYear="";
			String url="";
			String url2="";
			int row=1;
			String selected="";
			while(rs.next())	{
				String id=Util.null2String(rs.getString("id"));
				String name=Util.null2String(rs.getString("name"));
				String docid=Util.null2String(rs.getString("docid"));
				
				if(docid.startsWith(",")){
					docid = docid.replaceFirst(",","");
				}
				
				if(!"".equals(docid)) {
					int tempLoc=docid.indexOf(",");
					if(tempLoc!=-1) docid=docid.substring(0,tempLoc);
				}
				
				
				String releaseYear=Util.null2String(rs.getString("releaseYear"));
				if(row==1){
					firstMagazineId=id;
					firsDocId=docid;
					firstReleaseYear=releaseYear;
					url="/tom_magazine.jsp?typeID="+magzineType+"&id="+id+"";
					url2="/tom_magazine.jsp?typeID="+magzineType+"&id=";
					selected=" selected ";
					row++;
					firDocIdlist.add(firsDocId);
				}
			
				strList+="<option value=\""+id+"\" "+selected+">"+"<font class=font>"+releaseYear+SystemEnv.getHtmlLabelName(445,user.getLanguage())+name+"</font>"+"</option>";
				selected="";
			}

			strList+="</select>&nbsp;&nbsp;<img src='/images/go_wev8.gif' align=\"absmiddle\" border=0 style='cursor:hand' onmousemove='return false;' onclick=\"openMaginze(selectMagazine_"+i+"_"+eid+",'"+url2+"','"+linkmode+"')\">";
			
			String strImg="";
			String strTitle="";
			String strBrief="";
			String strContent="";
			String strDocSubject="";
			if("2".equals(linkmode)) url="javascript:openFullWindowForXtable('"+url+"')";	
			if(!"".equals(firsDocId)){
			    firsDocId=oDocManager.getNewDocid(firsDocId);
				ConnStatement statement=new ConnStatement();  
                String tempSql="";
                try{
                if((statement.getDBType()).equals("oracle")){
                     tempSql="select d1.docsubject,d2.doccontent from docdetail d1, DocDetailcontent d2  where d1.id=d2.docid and d1.id="+firsDocId;                    
                } else {
                    tempSql="select docsubject,doccontent from docdetail where id="+firsDocId;
                }
                statement.setStatementSql(tempSql) ;	
                statement.executeQuery();			
				
				
				if(statement.next()) {
					strDocSubject= statement.getString("docsubject");
				    if((statement.getDBType()).equals("oracle")){
                         CLOB theclob = statement.getClob("doccontent");
                         String readline = "";
                         StringBuffer clobStrBuff = new StringBuffer("");
                         BufferedReader clobin = new BufferedReader(theclob.getCharacterStream());
                         while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
                         clobin.close() ;
                         strContent = clobStrBuff.toString();
                     }else{
                         strContent=Util.null2String(statement.getString("doccontent"));
                     }
						
								
					int tmppos = strContent.indexOf("!@#$%^&*");		
					if (tmppos != -1) strBrief = strContent.substring(0, tmppos);
					
					strImg = hpes.getImgPlay(request,firsDocId,strContent,imgWidth,imgHeight,hpc.getStyleid(hpid),eid);			
					

					if(hasTitle){
						strTitle=Util.null2String(strDocSubject);
						String titleFiledid=(String)fieldIdList.get(fieldColumnList.indexOf("docsubject"));
						strTitle="<a class='ellipsis' href=\""+url+"\" >"+"<font class=font>"+strTitle+"</font>"+"</a>";
					}

					if(hasBrief){						
						String brifFiledid=(String)fieldIdList.get(fieldColumnList.indexOf("summary"));	
						strBrief="<a class='ellipsis' href=\""+url+"\" >"+"<font class=font>"+strBrief+"</font>"+"</a>";
					}
					
					
				}
                }finally{
                	statement.close();
                }
			}


			String imgSymbol="";
			if (!"".equals(esc.getIconEsymbol(hpec.getStyleid(eid)))) imgSymbol="<img name='esymbol' src='"+esc.getIconEsymbol(hpec.getStyleid(eid))+"'>";
		%>


		<tr>
			<td>
				<table width="100%" valign="top" style="table-layout:fixed" >
				<tr>
					<td  valign="top" width="<%=imgWidth+5%>">
					<%if(hasImg) out.println(strImg);%>
					</td>
					<td  width="*" valign="top">
						<table width="100%" class="magzine" style="table-layout:fixed">
						<tr>
							<td><b><%=imgSymbol%><%=strTitle%></b></td>
						</tr>

						<tr class='sparator' style="height:1px"><td style='padding:0px'></td></tr>

						<tr>
							<td><%if(hasBrief) out.println(strBrief);%></td>
						</tr>						

						</table>						

						<table  width="100%" cellPadding='0' cellSpacing='0' style="table-layout:fixed">
						<tr>
							<td><%if(hasList) out.println(strList);%></td>
						</tr>
						</table>					
					</td>
				</tr>				
				</table>
			</td>
		</tr>
		<%if(i+1<magazineList.size()){%>
				<TR class='sparator' style="height:1px" height=1px><td style='padding:0px'></td></TR>
		<%}%>
		<%
		}
		%>
		</table>

	</TD>    
	<TD width=1px></TD>
  </TR>
</TABLE>
<script>
    function initDocPicSlide(eid) {
        var n = 0;
        var count = $('#banner_'+eid+' a').length;
        $('#banner_'+eid+' a').css('z-index','100')
        $('#banner_'+eid).css('border','1px solid #707070')
        $('#banner_'+eid+' .slidebox_list a:not(:first-child)').hide();
        
        $('#banner_'+eid+' .navitem').eq(0).toggleClass('on1');
        
        $('#banner_'+eid+' .navitem').click(function() {
            var i = $(this).attr('_index') - 1; 
            n = i;
            if (i >= count) return;
            $('#banner_'+eid+' a').filter(':visible').fadeOut(500).parent().children().eq(i).fadeIn(500);
            
            $('#banner_'+eid+' .navitem').eq(i).toggleClass('on1');
            $(this).siblings().removeClass('on1');
        });
    }

    function showAuto(eid) {
        if($('#banner_'+eid+' a').length == 1){
            return;
        }
        var n = $('#banner_'+eid+' .navitem.on1').attr('_index') - 1; 
        if(!n){
            n = 0;
        }
        n = n >= ($('#banner_'+eid+' a').length - 1) ? 0 : ++n;
        $('#banner_'+eid+' .navitem').eq(n).trigger('click');
    }
    $(document).ready(function() {
          <%for (int i=0;i<firDocIdlist.size();i++) {
              String outEid = eid+"_"+Util.null2String(firDocIdlist.get(i));
          %>
          try {
              clearInterval(t_<%=outEid%>);
              t_<%=outEid%>=null;
          }
          catch (e) {
              t_<%=outEid%>=null;
          }
          initDocPicSlide('<%=outEid%>');
          t_<%=outEid%>=setInterval(function(){showAuto('<%=outEid%>')}, 2000);
          $("#banner_<%=outEid%>").hover(function() {
              clearInterval(t_<%=outEid%>)
          }, function() {
              t_<%=outEid%> = setInterval(function(){showAuto('<%=outEid%>')}, 2000);
          });
         <%}%>
    });
</script>





