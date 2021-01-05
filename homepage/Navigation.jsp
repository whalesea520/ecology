<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page"/>
<%
//得到页数，如果只有一个首页将不显示此状态栏
String sqlCount="select count(*) from hpinfo h where subcompanyid>0 and pid=0 and isuse=1 and id in ("+hpu.getShareHomapage(user)+")";

if(user.getUID()==1) {
	sqlCount="select count(*) from hpinfo h where subcompanyid>0  and pid=0 and isuse=1";
}
int hpcount=0;
rs.executeSql(sqlCount);
if(rs.next()) hpcount=rs.getInt(1);
//System.out.println("sqlCount:"+sqlCount);
if(hpcount>1){

	
%>
<table width=100% border="0" cellspacing="0" cellpadding="0"  valign="top">
<tr> 
    <td width="10px" id="tdNav1"><td>
    <td valign="top">
	<div id="navigation" cornerTop='<%=cornerTop%>' cornerBotto='<%=cornerBottom%>' cornerTopRadian='<%=cornerTopRadian%>' cornerBottomRadian='<%=cornerBottomRadian%>'>

        <table   width="100%" align=center  cellspacing="0" cellpadding="0" class="navigate" >
        <tr>
             <td width="100%"  valign="top">
             <NOBR>
            <%
                String sql="select id,infoname,subcompanyid from hpinfo h where subcompanyid>0 and pid=0 and isuse=1 and id in ("+hpu.getShareHomapage(user)+") order by ordernum1,id";

				if(user.getUID()==1) {
					sql="select id,infoname,subcompanyid from hpinfo h where pid=0 and subcompanyid>0  and isuse=1 order by ordernum1,id";
				}
                
                //out.println(sql);
                rs.executeSql(sql);
                while (rs.next()){
                    String tempHpid=Util.null2String(rs.getString("id"));
                    String tempHpName=Util.null2String(rs.getString("infoname"));
                    String tempHpSubcompanyid=Util.null2String(rs.getString("subcompanyid"));

                    String tempDivStyle="class=\"divMenu\" onmouseover=\"this.className='divMenuSelected'\"  onmouseout=\"this.className='divMenu'\" ";
                    if(hpid.equals(tempHpid)) {				
                        tempDivStyle="class=\"divMenuSelected\" ";
                    }
            %>
                <div   <%=tempDivStyle%>   style="cursor:pointer;"  onclick="onMenuDivClick('<%=tempHpid%>','<%=tempHpSubcompanyid%>')"><b><%=tempHpName%></b>		
                </div> 
                <%if("".equals(mainImg)){ %>                         
                <%=hpu.getSubMenu(hpid,tempHpid,user)%>
                <%}else{ %>
                 <%=hpu.getSubMenu(hpid,tempHpid,user,mainImg,subImg)%>
                <%} %>
            <%}%>
            </NOBR>
            </td>             
        </tr>  
        </table> 
		</div>
     </td>
     <td width="10px"  id="tdNav2"><td>
</tr>
</table>
<script type="text/javascript">
	if("<%=cornerTop%>"=="Round"){
			$("#navigation").corner("Round top <%=cornerTopRadian%>"); 
		}
	if("<%=cornerBottom%>"=="Round"){
		$("#navigation").corner("Round bottom <%=cornerBottomRadian%>"); 
	}

	jQuery(document).ready(function () {
		jQuery(".divSubMenu").hover(
			function(){
				this.className='divSubMenuSelected';
			},
			function(){
				this.className='divSubMenu';
			}
			
		);
	});

</script>
<%}%>