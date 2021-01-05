
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.authority.domain.*,weaver.hrm.authority.manager.*"%>
<%@ include file="/hrm/header.jsp" %>
<!-- Added by wcd 2014-11-06 -->
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
	String fromid = Tools.vString(request.getParameter("fromid"));
	String transferType = Tools.vString(request.getParameter("transferType"),"resource");
	String authorityTag = Tools.vString(request.getParameter("authorityTag"),"transfer");
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	MJson mjson = new MJson(jsonSql,true);
	HrmRightTransferManager transferManager = new HrmRightTransferManager(authorityTag, mjson, request).loadData();
	String[] codeNames = null;
	String[] lNames = null;
	String[] wTitles = null;
	String[] mTitles = null;
	String[] all = null;
	String[] idStr = null;
	int[] allNums = null;
	int[] num = null;
	int codeLength = 0;
	Map addressLinkMap = null;
%>
<wea:layout type="2col">
<%
	if(authorityTag.equals("transfer")){
		HrmRightTransfer bean = (HrmRightTransfer)transferManager.getBean();
		addressLinkMap = bean.getAddressMap();
		if(transferType.equals("resource")){
			codeNames = new String[] {
				"T101","T111","T112","T113","T121","T122","T123","T124","T125","T131",
				"T132","T133","T134","T141","T142","T143","T144","T145","T146","T147",
				"T148","T149","T151","T152","T161","T171","T181","T182","T183","T191","Temail001","Temail002"};
			allNums = new int[] {
				bean.getT101AllNum(),bean.getT111AllNum(),bean.getT112AllNum(),bean.getT113AllNum(),bean.getT121AllNum(),
				bean.getT122AllNum(),bean.getT123AllNum(),bean.getT124AllNum(),bean.getT125AllNum(),bean.getT131AllNum(),
				bean.getT132AllNum(),bean.getT133AllNum(),bean.getT134AllNum(),bean.getT141AllNum(),bean.getT142AllNum(),
				bean.getT143AllNum(),bean.getT144AllNum(),bean.getT145AllNum(),bean.getT146AllNum(),bean.getT147AllNum(),
				bean.getT148AllNum(),bean.getT149AllNum(),bean.getT151AllNum(),bean.getT152AllNum(),bean.getT161AllNum(),
				bean.getT171AllNum(),bean.getT181AllNum(),bean.getT182AllNum(),bean.getT183AllNum(),bean.getT191AllNum(),
				bean.getTemail001AllNum(),bean.getTemail002AllNum()};
			lNames = new String[] {
				"21313","33929,101","430,101","101,1332","442","122","22671","33646","33645","18015,15586,99",
				"15060,665,18015","1207","17991","58,21945","58,77,385","58,78,385","58,15059","20482,633,385","15060,60,25236","15060,60,25237",
				"58,79","20306,58","33929,2103","430,2103","2211","535","18831","17855,21945","17855,633,385","15060,60,33677"
				,"131756","131757"};
			mTitles = new String[] {
				"33372","33373","34001","34002","33374","34003","34004","34005","34006","34007",
				"34008","34009","34010","34011","34012","34013","34014","34015","34016","34017",
				"33375","34041","34018","34019","34020","34021","33377","34022","34023","34024",
				"131758","131759"};
			wTitles = new String[] {
				"367,21313","367,101","367,101","367,101,1332","367,442","367,122","367,124","367,33646","367,33645","367,18015,15586,15072",
				"367,665,18015","367,1207","367,17991","367,58,92","367,58,92","367,58,92","367,58,92","367,20482","367,65","367,66",
				"367,58","367,58","367,2103","367,2103","367,2211","367,535","367,18831","367,17855,34242","367,17855,34242","367,33677"
				,"367","367"};
			all = new String[] {
				bean.getT101All(),bean.getT111All(),bean.getT112All(),bean.getT113All(),bean.getT121All(),
				bean.getT122All(),bean.getT123All(),bean.getT124All(),bean.getT125All(),bean.getT131All(),
				bean.getT132All(),bean.getT133All(),bean.getT134All(),bean.getT141All(),bean.getT142All(),
				bean.getT143All(),bean.getT144All(),bean.getT145All(),bean.getT146All(),bean.getT147All(),
				bean.getT148All(),bean.getT149All(),bean.getT151All(),bean.getT152All(),bean.getT161All(),
				bean.getT171All(),bean.getT181All(),bean.getT182All(),bean.getT183All(),bean.getT191All(),
				bean.getTemail001All(),bean.getTemail002All()};
			num = new int[] {
				bean.getT101Num(),bean.getT111Num(),bean.getT112Num(),bean.getT113Num(),bean.getT121Num(),
				bean.getT122Num(),bean.getT123Num(),bean.getT124Num(),bean.getT125Num(),bean.getT131Num(),
				bean.getT132Num(),bean.getT133Num(),bean.getT134Num(),bean.getT141Num(),bean.getT142Num(),
				bean.getT143Num(),bean.getT144Num(),bean.getT145Num(),bean.getT146Num(),bean.getT147Num(),
				bean.getT148Num(),bean.getT149Num(),bean.getT151Num(),bean.getT152Num(),bean.getT161Num(),
				bean.getT171Num(),bean.getT181Num(),bean.getT182Num(),bean.getT183Num(),bean.getT191Num(),
				bean.getTemail001Num(),bean.getTemail002Num()};
			idStr = new String[] {
				bean.getT101IdStr(),bean.getT111IdStr(),bean.getT112IdStr(),bean.getT113IdStr(),bean.getT121IdStr(),
				bean.getT122IdStr(),bean.getT123IdStr(),bean.getT124IdStr(),bean.getT125IdStr(),bean.getT131IdStr(),
				bean.getT132IdStr(),bean.getT133IdStr(),bean.getT134IdStr(),bean.getT141IdStr(),bean.getT142IdStr(),
				bean.getT143IdStr(),bean.getT144IdStr(),bean.getT145IdStr(),bean.getT146IdStr(),bean.getT147IdStr(),
				bean.getT148IdStr(),bean.getT149IdStr(),bean.getT151IdStr(),bean.getT152IdStr(),bean.getT161IdStr(),
				bean.getT171IdStr(),bean.getT181IdStr(),bean.getT182IdStr(),bean.getT183IdStr(),bean.getT191IdStr(),
				bean.getTemail001IdStr(),bean.getTemail002IdStr()};
		} else if(transferType.equals("department")){
			codeNames = new String[] {
				"T201","T202","T203","T204","T211","T221","T222","T223","T224","T225",
				"T226","T231","T232","T241"};
			allNums = new int[] {
				bean.getT201AllNum(),bean.getT202AllNum(),bean.getT203AllNum(),bean.getT204AllNum(),bean.getT211AllNum(),
				bean.getT221AllNum(),bean.getT222AllNum(),bean.getT223AllNum(),bean.getT224AllNum(),bean.getT225AllNum(),
				bean.getT226AllNum(),bean.getT231AllNum(),bean.getT232AllNum(),bean.getT241AllNum()};
			lNames = new String[] {
				"17587","6086","179","24002","18015,15586,99","58,21945","58,77,385","58,78,385","58,15059","15060,60,25236",
				"15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
			mTitles = new String[] {
				"34025","34026","34027","34028","34007","34011","34012","34013","34014","34016",
				"34017","34022","34023","34024"};
			wTitles = new String[] {
				"367,124","367,6086","367,179","367,24002","367,18015,15586,15072","367,58,92","367,58,92","367,58,92","367,58,92","34016 367,65",
				"34017 367,66","367,17855,34242","367,17855,34242","367,33677"};
			all = new String[] {
				bean.getT201All(),bean.getT202All(),bean.getT203All(),bean.getT204All(),bean.getT211All(),
				bean.getT221All(),bean.getT222All(),bean.getT223All(),bean.getT224All(),bean.getT225All(),
				bean.getT226All(),bean.getT231All(),bean.getT232All(),bean.getT241All()};
			num = new int[] {
				bean.getT201Num(),bean.getT202Num(),bean.getT203Num(),bean.getT204Num(),bean.getT211Num(),
				bean.getT221Num(),bean.getT222Num(),bean.getT223Num(),bean.getT224Num(),bean.getT225Num(),
				bean.getT226Num(),bean.getT231Num(),bean.getT232Num(),bean.getT241Num()};
			idStr = new String[] {
				bean.getT201IdStr(),bean.getT202IdStr(),bean.getT203IdStr(),bean.getT204IdStr(),bean.getT211IdStr(),
				bean.getT221IdStr(),bean.getT222IdStr(),bean.getT223IdStr(),bean.getT224IdStr(),bean.getT225IdStr(),
				bean.getT226IdStr(),bean.getT231IdStr(),bean.getT232IdStr(),bean.getT241IdStr()};
		} else if(transferType.equals("subcompany")){
			codeNames = new String[] {
				"T301","T302","T303","T311","T321","T322",
				"T323","T324","T325","T326","T331","T332","T341"};
			allNums = new int[] {
				bean.getT301AllNum(),bean.getT302AllNum(),bean.getT303AllNum(),bean.getT311AllNum(),bean.getT321AllNum(),
				bean.getT322AllNum(),bean.getT323AllNum(),bean.getT324AllNum(),bean.getT325AllNum(),bean.getT326AllNum(),
				bean.getT331AllNum(),bean.getT332AllNum(),bean.getT341AllNum()};
			lNames = new String[] {
				"17898","124","24002","18015,15586,99","58,21945","58,77,385",
				"58,78,385","58,15059","15060,60,25236","15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
			mTitles = new String[] {
				"34029","34030","34028","34007","34011","34012",
				"34013","34014","34016","34017","34022","34023","34024"};
			wTitles = new String[] {
				"367,141","367,124","367,24002","367,18015,15586,15072","367,58,92","367,58,92",
				"367,58,92","367,58,92","34016 367,65","34017 367,66","367,17855,34242","367,17855,34242","367,33677"};
			all = new String[] {
				bean.getT301All(),bean.getT302All(),bean.getT303All(),bean.getT311All(),bean.getT321All(),
				bean.getT322All(),bean.getT323All(),bean.getT324All(),bean.getT325All(),bean.getT326All(),
				bean.getT331All(),bean.getT332All(),bean.getT341All()};
			num = new int[] {
				bean.getT301Num(),bean.getT302Num(),bean.getT303Num(),bean.getT311Num(),bean.getT321Num(),
				bean.getT322Num(),bean.getT323Num(),bean.getT324Num(),bean.getT325Num(),bean.getT326Num(),
				bean.getT331Num(),bean.getT332Num(),bean.getT341Num()};
			idStr = new String[] {
				bean.getT301IdStr(),bean.getT302IdStr(),bean.getT303IdStr(),bean.getT311IdStr(),bean.getT321IdStr(),
				bean.getT322IdStr(),bean.getT323IdStr(),bean.getT324IdStr(),bean.getT325IdStr(),bean.getT326IdStr(),
				bean.getT331IdStr(),bean.getT332IdStr(),bean.getT341IdStr()};
		} else if(transferType.equals("role")){
			codeNames = new String[] {
				"T401","T411","T412",
				"T413","T414","T415","T416","T421","T422","T431"};
			allNums = new int[] {
				bean.getT401AllNum(),bean.getT411AllNum(),bean.getT412AllNum(),bean.getT413AllNum(),
				bean.getT414AllNum(),bean.getT415AllNum(),bean.getT416AllNum(),bean.getT421AllNum(),
				bean.getT422AllNum(),bean.getT431AllNum()};
			lNames = new String[] {
				"18015,15586,99","58,21945","58,77,385",
				"58,78,385","58,15059","15060,60,25236","15060,60,25237","17855,21945","17855,633,385","15060,60,33677"};
			mTitles = new String[] {
				"34007","34011","34012",
				"34013","34014","34016","34017","34022","34023","34024"};
			wTitles = new String[] {
				"367,18015,15586,15072","367,58,92","367,58,92",
				"367,58,92","367,58,92","34016 367,65","34017 367,66","367,17855,34242","367,17855,34242","367,33677"};
			all = new String[] {
				bean.getT401All(),bean.getT411All(),bean.getT412All(),bean.getT413All(),
				bean.getT414All(),bean.getT415All(),bean.getT416All(),bean.getT421All(),
				bean.getT422All(),bean.getT431All()};
			num = new int[] {
				bean.getT401Num(),bean.getT411Num(),bean.getT412Num(),bean.getT413Num(),
				bean.getT414Num(),bean.getT415Num(),bean.getT416Num(),bean.getT421Num(),
				bean.getT422Num(),bean.getT431Num()};
			idStr = new String[] {
				bean.getT401IdStr(),bean.getT411IdStr(),bean.getT412IdStr(),bean.getT413IdStr(),
				bean.getT414IdStr(),bean.getT415IdStr(),bean.getT416IdStr(),bean.getT421IdStr(),
				bean.getT422IdStr(),bean.getT431IdStr()};
		} else if(transferType.equals("jobtitle")){
				codeNames = new String[] {
					"T501","T511","T521","T522","T523","T524","T525","T531","T532","T541"};
				allNums = new int[] {
					bean.getT501AllNum(),bean.getT511AllNum(),bean.getT522AllNum(),bean.getT523AllNum(),
					bean.getT524AllNum(),bean.getT524AllNum(),bean.getT525AllNum(),bean.getT531AllNum(),
					bean.getT532AllNum(),bean.getT541AllNum()};
				lNames = new String[] {
					"179","18015,15586,99","58,21945","58,77,385",
					"58,78,385","58,15059","15060,60,16398","17855,21945","17855,633,385","15060,60,33677"};
				mTitles = new String[] {
					"34027","34007","34011","34012",
					"34013","34014","34016","34022","34023","34024"};
				wTitles = new String[] {
					"172,179","172,18015,15586,15072","172,58,92","172,58,92",
					"172,58,92","172,58,92","34016,172,65","172,17855,34242","172,17855,34242","172,33677"};
				all = new String[] {
					bean.getT501All(),bean.getT511All(),bean.getT521All(),bean.getT522All(),
					bean.getT523All(),bean.getT524All(),bean.getT525All(),bean.getT531All(),
					bean.getT532All(),bean.getT541All()};
				num = new int[] {
					bean.getT501Num(),bean.getT511Num(),bean.getT521Num(),bean.getT522Num(),
					bean.getT523Num(),bean.getT524Num(),bean.getT525Num(),bean.getT531Num(),
					bean.getT532Num(),bean.getT541Num()};
				idStr = new String[] {
					bean.getT501IdStr(),bean.getT511IdStr(),bean.getT521IdStr(),bean.getT522IdStr(),
					bean.getT523IdStr(),bean.getT524IdStr(),bean.getT525IdStr(),bean.getT531IdStr(),
					bean.getT532IdStr(),bean.getT541IdStr()};
			}
		
		codeLength = allNums == null ? 0 : allNums.length;
%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'3','cws':'30%,30%,40%'}">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("385,63",user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16851,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></wea:item>
<%
					if(addressLinkMap == null) addressLinkMap = new HashMap();
					String addressLink = "";
					String onClick = "";
					String[] delCodes = {"T202"};
					for(int i=0; i<codeLength; i++){
						if(allNums[i] <= 0) continue;
						boolean isContinue = false;
						for(int j=0; j<delCodes.length; j++){
							if(codeNames[i].equals(delCodes[j])){
								isContinue = true;
								break;
							}
						}
						if(isContinue) continue;
						addressLink = Tools.vString(addressLinkMap.get(codeNames[i]));
						if(addressLink.length() > 0){
							addressLink += (addressLink.indexOf("?") == -1 ? "?" : "&") + "fromid=" + fromid + "&type="+codeNames[i]+"IdStr&isHidden=true";
						}
						onClick = "doOpen(\""+addressLink+"\",\""+SystemEnv.getHtmlLabelNames(wTitles[i],user.getLanguage())+"\");";
%>
						<wea:item><%=SystemEnv.getHtmlLabelNames(lNames[i],user.getLanguage())%></wea:item>
						<wea:item><%=allNums[i]%></wea:item>
						<wea:item><a href='javascript:void("0");' onclick='<%=onClick%>'><%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%></a></wea:item>
<%
					}
%>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
<%
	}
%>
</wea:layout>
