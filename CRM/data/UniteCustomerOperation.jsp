
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="HrmOutInterface" class="weaver.hrm.outinterface.HrmOutInterface" scope="page" />
<%
String CustomerID = Util.fromScreen(request.getParameter("CustomerID"),user.getLanguage());
String crmids = Util.fromScreen(request.getParameter("crmids"),user.getLanguage());

String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();

String SubmiterType = ""+user.getLogintype();
String ClientIP = request.getRemoteAddr();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;

char flag = 2;
String ProcPara = "";
String UniteCustomerName = "";
ArrayList crmidArray=Util.TokenizerString(crmids,",");


ArrayList Customer=new ArrayList();
ArrayList Name=new ArrayList();
ArrayList Language=new ArrayList();
ArrayList Abbrev=new ArrayList();
ArrayList Address1=new ArrayList();
ArrayList Address2=new ArrayList();
ArrayList Address3=new ArrayList();
ArrayList Zipcode=new ArrayList();
ArrayList City=new ArrayList();
ArrayList Country=new ArrayList();
ArrayList Province=new ArrayList();
ArrayList County=new ArrayList();
ArrayList Phone=new ArrayList();
ArrayList Fax=new ArrayList();
ArrayList Email=new ArrayList();
ArrayList Website=new ArrayList();
ArrayList Source=new ArrayList();
ArrayList Sector=new ArrayList();
ArrayList Size=new ArrayList();
ArrayList Manager=new ArrayList();
ArrayList Agent=new ArrayList();
ArrayList Parent=new ArrayList();
ArrayList Department=new ArrayList();
ArrayList Subcompanyid1=new ArrayList();
ArrayList Fincode=new ArrayList();
ArrayList Currency=new ArrayList();
ArrayList ContractLevel=new ArrayList();
ArrayList CreditLevel=new ArrayList();
ArrayList CreditOffset=new ArrayList();
ArrayList Discount=new ArrayList();
ArrayList TaxNumber=new ArrayList();
ArrayList BankAccount=new ArrayList();
ArrayList InvoiceAcount=new ArrayList();
ArrayList DeliveryType=new ArrayList();
ArrayList PaymentTerm=new ArrayList();
ArrayList PaymentWay=new ArrayList();
ArrayList SaleConfirm=new ArrayList();
ArrayList Credit=new ArrayList();
ArrayList CreditExpire=new ArrayList();
ArrayList Document=new ArrayList();
ArrayList Seclevel=new ArrayList();
ArrayList Photo=new ArrayList();
ArrayList Type=new ArrayList();
ArrayList TypeFrom=new ArrayList();
ArrayList Description=new ArrayList();
ArrayList Status=new ArrayList();
ArrayList Rating=new ArrayList();
ArrayList introductionDocid=new ArrayList();
ArrayList dff01=new ArrayList();
ArrayList dff02=new ArrayList();
ArrayList dff03=new ArrayList();
ArrayList dff04=new ArrayList();
ArrayList dff05=new ArrayList();
ArrayList nff01=new ArrayList();
ArrayList nff02=new ArrayList();
ArrayList nff03=new ArrayList();
ArrayList nff04=new ArrayList();
ArrayList nff05=new ArrayList();
ArrayList tff01=new ArrayList();
ArrayList tff02=new ArrayList();
ArrayList tff03=new ArrayList();
ArrayList tff04=new ArrayList();
ArrayList tff05=new ArrayList();
ArrayList bff01=new ArrayList();
ArrayList bff02=new ArrayList();
ArrayList bff03=new ArrayList();
ArrayList bff04=new ArrayList();
ArrayList bff05=new ArrayList();
ArrayList CreditAmount=new ArrayList();
ArrayList CreditTime=new ArrayList();
ArrayList bankName=new ArrayList();
ArrayList accountName=new ArrayList();
ArrayList accounts=new ArrayList();
ArrayList crmCode=new ArrayList();

RecordSet.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if (RecordSet.next()){
Customer.add(Util.toScreen(RecordSet.getString("id"),user.getLanguage()));
Name.add(Util.toScreen(RecordSet.getString("name"),user.getLanguage()));
Language.add(Util.toScreen(RecordSet.getString("language"),user.getLanguage()));
Abbrev.add(Util.toScreen(RecordSet.getString("engname"),user.getLanguage()));
Address1.add(Util.toScreen(RecordSet.getString("address1"),user.getLanguage()));
Address2.add(Util.toScreen(RecordSet.getString("address2"),user.getLanguage()));
Address3.add(Util.toScreen(RecordSet.getString("address3"),user.getLanguage()));
Zipcode.add(Util.toScreen(RecordSet.getString("zipcode"),user.getLanguage()));
City.add(Util.toScreen(RecordSet.getString("city"),user.getLanguage()));
Country.add(Util.toScreen(RecordSet.getString("country"),user.getLanguage()));
Province.add(Util.toScreen(RecordSet.getString("province"),user.getLanguage()));
County.add(Util.toScreen(RecordSet.getString("county"),user.getLanguage()));
Phone.add(Util.toScreen(RecordSet.getString("phone"),user.getLanguage()));
Fax.add(Util.toScreen(RecordSet.getString("fax"),user.getLanguage()));
Email.add(Util.toScreen(RecordSet.getString("email"),user.getLanguage()));
Website.add(Util.toScreen(RecordSet.getString("website"),user.getLanguage()));
Source.add(Util.toScreen(RecordSet.getString("source"),user.getLanguage()));
Sector.add(Util.toScreen(RecordSet.getString("sector"),user.getLanguage()));
Size.add(Util.toScreen(RecordSet.getString("size_n"),user.getLanguage()));
Manager.add(Util.toScreen(RecordSet.getString("manager"),user.getLanguage()));
Agent.add(Util.toScreen(RecordSet.getString("agent"),user.getLanguage()));
Parent.add(Util.toScreen(RecordSet.getString("parentid"),user.getLanguage()));
Department.add(Util.toScreen(RecordSet.getString("department"),user.getLanguage()));
Subcompanyid1.add(DepartmentComInfo.getSubcompanyid1(RecordSet.getString("department")));
Fincode.add(Util.toScreen(RecordSet.getString("fincode"),user.getLanguage()));
Currency.add(Util.toScreen(RecordSet.getString("currency"),user.getLanguage()));
ContractLevel.add(Util.toScreen(RecordSet.getString("contractlevel"),user.getLanguage()));
CreditLevel.add(Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage()));
CreditOffset.add(Util.toScreen(RecordSet.getString("creditoffset"),user.getLanguage()));
Discount.add(Util.toScreen(RecordSet.getString("discount"),user.getLanguage()));
TaxNumber.add(Util.toScreen(RecordSet.getString("taxnumber"),user.getLanguage()));
BankAccount.add(Util.toScreen(RecordSet.getString("bankacount"),user.getLanguage()));
InvoiceAcount.add(Util.toScreen(RecordSet.getString("invoiceacount"),user.getLanguage()));
DeliveryType.add(Util.toScreen(RecordSet.getString("deliverytype"),user.getLanguage()));
PaymentTerm.add(Util.toScreen(RecordSet.getString("paymentterm"),user.getLanguage()));
PaymentWay.add(Util.toScreen(RecordSet.getString("paymentway"),user.getLanguage()));
SaleConfirm.add(Util.toScreen(RecordSet.getString("saleconfirm"),user.getLanguage()));
Credit.add(Util.toScreen(RecordSet.getString("creditcard"),user.getLanguage()));
CreditExpire.add(Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage()));
Document.add(Util.toScreen(RecordSet.getString("documentid"),user.getLanguage()));
Seclevel.add(Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()));
Photo.add(Util.toScreen(RecordSet.getString("picid"),user.getLanguage()));
Type.add(Util.toScreen(RecordSet.getString("type"),user.getLanguage()));
TypeFrom.add(Util.toScreen(RecordSet.getString("typebegin"),user.getLanguage()));
Description.add(Util.toScreen(RecordSet.getString("description"),user.getLanguage()));
Status.add(Util.toScreen(RecordSet.getString("status"),user.getLanguage()));
Rating.add(Util.toScreen(RecordSet.getString("rating"),user.getLanguage()));
introductionDocid.add(Util.toScreen(RecordSet.getString("introductionDocid"),user.getLanguage()));
dff01.add(Util.toScreen(RecordSet.getString("datefield1"),user.getLanguage()));
dff02.add(Util.toScreen(RecordSet.getString("datefield2"),user.getLanguage()));
dff03.add(Util.toScreen(RecordSet.getString("datefield3"),user.getLanguage()));
dff04.add(Util.toScreen(RecordSet.getString("datefield4"),user.getLanguage()));
dff05.add(Util.toScreen(RecordSet.getString("datefield5"),user.getLanguage()));

nff01.add(Util.toScreen(RecordSet.getString("numberfield1"),user.getLanguage()));
nff02.add(Util.toScreen(RecordSet.getString("numberfield2"),user.getLanguage()));
nff03.add(Util.toScreen(RecordSet.getString("numberfield3"),user.getLanguage()));
nff04.add(Util.toScreen(RecordSet.getString("numberfield4"),user.getLanguage()));
nff05.add(Util.toScreen(RecordSet.getString("numberfield5"),user.getLanguage()));

tff01.add(Util.toScreen(RecordSet.getString("textfield1"),user.getLanguage()));
tff02.add(Util.toScreen(RecordSet.getString("textfield2"),user.getLanguage()));
tff03.add(Util.toScreen(RecordSet.getString("textfield3"),user.getLanguage()));
tff04.add(Util.toScreen(RecordSet.getString("textfield4"),user.getLanguage()));
tff05.add(Util.toScreen(RecordSet.getString("textfield5"),user.getLanguage()));

bff01.add(Util.toScreen(RecordSet.getString("tinyintfield1"),user.getLanguage()));
bff02.add(Util.toScreen(RecordSet.getString("tinyintfield2"),user.getLanguage()));
bff03.add(Util.toScreen(RecordSet.getString("tinyintfield3"),user.getLanguage()));
bff04.add(Util.toScreen(RecordSet.getString("tinyintfield4"),user.getLanguage()));
bff05.add(Util.toScreen(RecordSet.getString("tinyintfield5"),user.getLanguage()));

CreditAmount.add(Util.toScreen(RecordSet.getString("CreditAmount"),user.getLanguage()));
CreditTime.add(Util.toScreen(RecordSet.getString("CreditTime"),user.getLanguage()));
bankName.add(Util.toScreen(RecordSet.getString("bankName"),user.getLanguage()));
accountName.add(Util.toScreen(RecordSet.getString("accountName"),user.getLanguage()));
accounts.add(Util.toScreen(RecordSet.getString("accounts"),user.getLanguage()));
crmCode.add(Util.toScreen(RecordSet.getString("crmCode"),user.getLanguage()));
}

	try{
		//合并客户外部数据处理 合并人员数据、删除被合并数据的应用分权、矩阵、组织结构
		String crmidfrom = null;
		String crmidto = CustomerID; 
		for(int i=0;i<crmidArray.size();i++){
			crmidfrom = (String)crmidArray.get(i);
			HrmOutInterface.uniteCustomer(crmidfrom,crmidto);
		}
	}catch(Exception e){
		new BaseBean().writeLog(e);
	}
	
	for(int i=0;i<crmidArray.size();i++)
		{			
			RecordSet.executeProc("CRM_CustomerInfo_SelectByID",(String)crmidArray.get(i));
			if (RecordSet.next()){
			Customer.add(Util.toScreen(RecordSet.getString("id"),user.getLanguage()));
			Name.add(Util.toScreen(RecordSet.getString("name"),user.getLanguage()));
			Language.add(Util.toScreen(RecordSet.getString("language"),user.getLanguage()));
			Abbrev.add(Util.toScreen(RecordSet.getString("engname"),user.getLanguage()));
			Address1.add(Util.toScreen(RecordSet.getString("address1"),user.getLanguage()));
			Address2.add(Util.toScreen(RecordSet.getString("address2"),user.getLanguage()));
			Address3.add(Util.toScreen(RecordSet.getString("address3"),user.getLanguage()));
			Zipcode.add(Util.toScreen(RecordSet.getString("zipcode"),user.getLanguage()));
			City.add(Util.toScreen(RecordSet.getString("city"),user.getLanguage()));
			Country.add(Util.toScreen(RecordSet.getString("country"),user.getLanguage()));
			Province.add(Util.toScreen(RecordSet.getString("province"),user.getLanguage()));
			County.add(Util.toScreen(RecordSet.getString("county"),user.getLanguage()));
			Phone.add(Util.toScreen(RecordSet.getString("phone"),user.getLanguage()));
			Fax.add(Util.toScreen(RecordSet.getString("fax"),user.getLanguage()));
			Email.add(Util.toScreen(RecordSet.getString("email"),user.getLanguage()));
			Website.add(Util.toScreen(RecordSet.getString("website"),user.getLanguage()));
			Source.add(Util.toScreen(RecordSet.getString("source"),user.getLanguage()));
			Sector.add(Util.toScreen(RecordSet.getString("sector"),user.getLanguage()));
			Size.add(Util.toScreen(RecordSet.getString("size_n"),user.getLanguage()));
			Manager.add(Util.toScreen(RecordSet.getString("manager"),user.getLanguage()));
			Agent.add(Util.toScreen(RecordSet.getString("agent"),user.getLanguage()));
			Parent.add(Util.toScreen(RecordSet.getString("parentid"),user.getLanguage()));
			Department.add(Util.toScreen(RecordSet.getString("department"),user.getLanguage()));
			Subcompanyid1.add(DepartmentComInfo.getSubcompanyid1(RecordSet.getString("department")));
			Fincode.add(Util.toScreen(RecordSet.getString("fincode"),user.getLanguage()));
			Currency.add(Util.toScreen(RecordSet.getString("currency"),user.getLanguage()));
			ContractLevel.add(Util.toScreen(RecordSet.getString("contractlevel"),user.getLanguage()));
			CreditLevel.add(Util.toScreen(RecordSet.getString("creditlevel"),user.getLanguage()));
			CreditOffset.add(Util.toScreen(RecordSet.getString("creditoffset"),user.getLanguage()));
			Discount.add(Util.toScreen(RecordSet.getString("discount"),user.getLanguage()));
			TaxNumber.add(Util.toScreen(RecordSet.getString("taxnumber"),user.getLanguage()));
			BankAccount.add(Util.toScreen(RecordSet.getString("bankacount"),user.getLanguage()));
			InvoiceAcount.add(Util.toScreen(RecordSet.getString("invoiceacount"),user.getLanguage()));
			DeliveryType.add(Util.toScreen(RecordSet.getString("deliverytype"),user.getLanguage()));
			PaymentTerm.add(Util.toScreen(RecordSet.getString("paymentterm"),user.getLanguage()));
			PaymentWay.add(Util.toScreen(RecordSet.getString("paymentway"),user.getLanguage()));
			SaleConfirm.add(Util.toScreen(RecordSet.getString("saleconfirm"),user.getLanguage()));
			Credit.add(Util.toScreen(RecordSet.getString("creditcard"),user.getLanguage()));
			CreditExpire.add(Util.toScreen(RecordSet.getString("creditexpire"),user.getLanguage()));
			Document.add(Util.toScreen(RecordSet.getString("documentid"),user.getLanguage()));
			Seclevel.add(Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()));
			Photo.add(Util.toScreen(RecordSet.getString("picid"),user.getLanguage()));
			Type.add(Util.toScreen(RecordSet.getString("type"),user.getLanguage()));
			TypeFrom.add(Util.toScreen(RecordSet.getString("typebegin"),user.getLanguage()));
			Description.add(Util.toScreen(RecordSet.getString("description"),user.getLanguage()));
			Status.add(Util.toScreen(RecordSet.getString("status"),user.getLanguage()));
			Rating.add(Util.toScreen(RecordSet.getString("rating"),user.getLanguage()));
			introductionDocid.add(Util.toScreen(RecordSet.getString("introductionDocid"),user.getLanguage()));
			dff01.add(Util.toScreen(RecordSet.getString("datefield1"),user.getLanguage()));
			dff02.add(Util.toScreen(RecordSet.getString("datefield2"),user.getLanguage()));
			dff03.add(Util.toScreen(RecordSet.getString("datefield3"),user.getLanguage()));
			dff04.add(Util.toScreen(RecordSet.getString("datefield4"),user.getLanguage()));
			dff05.add(Util.toScreen(RecordSet.getString("datefield5"),user.getLanguage()));

			nff01.add(Util.toScreen(RecordSet.getString("numberfield1"),user.getLanguage()));
			nff02.add(Util.toScreen(RecordSet.getString("numberfield2"),user.getLanguage()));
			nff03.add(Util.toScreen(RecordSet.getString("numberfield3"),user.getLanguage()));
			nff04.add(Util.toScreen(RecordSet.getString("numberfield4"),user.getLanguage()));
			nff05.add(Util.toScreen(RecordSet.getString("numberfield5"),user.getLanguage()));

			tff01.add(Util.toScreen(RecordSet.getString("textfield1"),user.getLanguage()));
			tff02.add(Util.toScreen(RecordSet.getString("textfield2"),user.getLanguage()));
			tff03.add(Util.toScreen(RecordSet.getString("textfield3"),user.getLanguage()));
			tff04.add(Util.toScreen(RecordSet.getString("textfield4"),user.getLanguage()));
			tff05.add(Util.toScreen(RecordSet.getString("textfield5"),user.getLanguage()));

			bff01.add(Util.toScreen(RecordSet.getString("tinyintfield1"),user.getLanguage()));
			bff02.add(Util.toScreen(RecordSet.getString("tinyintfield2"),user.getLanguage()));
			bff03.add(Util.toScreen(RecordSet.getString("tinyintfield3"),user.getLanguage()));
			bff04.add(Util.toScreen(RecordSet.getString("tinyintfield4"),user.getLanguage()));
			bff05.add(Util.toScreen(RecordSet.getString("tinyintfield5"),user.getLanguage()));
			
			CreditAmount.add(Util.toScreen(RecordSet.getString("CreditAmount"),user.getLanguage()));
			CreditTime.add(Util.toScreen(RecordSet.getString("CreditTime"),user.getLanguage()));
			bankName.add(Util.toScreen(RecordSet.getString("bankName"),user.getLanguage()));
			accountName.add(Util.toScreen(RecordSet.getString("accountName"),user.getLanguage()));
			accounts.add(Util.toScreen(RecordSet.getString("accounts"),user.getLanguage()));
			crmCode.add(Util.toScreen(RecordSet.getString("crmCode"),user.getLanguage()));
			}

		}
	
		// Language,Abbrev,Address2,Address3,Zipcode,City,Country,Province,County,Phone,Fax,Website,Agent
		// Parent,Fincode,Currency,ContractLevel,CreditLevel,CreditOffset,Discount,TaxNumber,BankAccount,InvoiceAcount
		// DeliveryType,PaymentTerm,PaymentWay,SaleConfirm,Credit,CreditExpire,Document,Photo,Description,introductionDocid
		
		for (int j = 0 ;j<Language.size();j++)		
		{	String FieldStr = (String)Language.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Language.size()>1))  Language.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Abbrev.size();j++)		
		{	String FieldStr = (String)Abbrev.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Abbrev.size()>1))  Abbrev.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Address2.size();j++)		
		{	String FieldStr = (String)Address2.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Address2.size()>1))  Address2.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Address3.size();j++)		
		{	String FieldStr = (String)Address3.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Address3.size()>1))  Address3.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Zipcode.size();j++)		
		{	String FieldStr = (String)Zipcode.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Zipcode.size()>1))  Zipcode.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<City.size();j++)		
		{	String FieldStr = (String)City.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(City.size()>1))  City.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Country.size();j++)		
		{	String FieldStr = (String)Country.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Country.size()>1))  Country.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Province.size();j++)		
		{	String FieldStr = (String)Province.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Province.size()>1))  Province.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<County.size();j++)		
		{	String FieldStr = (String)County.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(County.size()>1))  County.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Phone.size();j++)		
		{	String FieldStr = (String)Phone.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Phone.size()>1))  Phone.remove(0);
			else
				break;	
		}
		
		for (int j = 0 ;j<Fax.size();j++)		
		{	String FieldStr = (String)Fax.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Fax.size()>1))  Fax.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Website.size();j++)		
		{	String FieldStr = (String)Website.get(0);
			if ((FieldStr.equals("")||FieldStr.equals("0"))&&(Website.size()>1))  Website.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Agent.size();j++)		
		{	String FieldStr = (String)Agent.get(0);
			if (FieldStr.equals("")&&(Agent.size()>1))  Agent.remove(0);
			else
				break;	
		}
		
		for (int j = 0 ;j<Parent.size();j++)		
		{	String FieldStr = (String)Parent.get(0);
			if (FieldStr.equals("")&&(Parent.size()>1))  Parent.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Fincode.size();j++)		
		{	String FieldStr = (String)Fincode.get(0);
			if (FieldStr.equals("")&&(Fincode.size()>1))  Fincode.remove(0);
			else
				break;	
		}
		
		for (int j = 0 ;j<Currency.size();j++)		
		{	String FieldStr = (String)Currency.get(0);
			if (FieldStr.equals("")&&(Currency.size()>1))  Currency.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<ContractLevel.size();j++)		
		{	String FieldStr = (String)ContractLevel.get(0);
			if (FieldStr.equals("")&&(ContractLevel.size()>1))  ContractLevel.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<CreditLevel.size();j++)		
		{	String FieldStr = (String)CreditLevel.get(0);
			if (FieldStr.equals("")&&(CreditLevel.size()>1))  CreditLevel.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<CreditOffset.size();j++)		
		{	String FieldStr = (String)CreditOffset.get(0);
			if (FieldStr.equals("")&&(CreditOffset.size()>1))  CreditOffset.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Discount.size();j++)		
		{	String FieldStr = (String)Discount.get(0);
			if (FieldStr.equals("")&&(Discount.size()>1))  Discount.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<TaxNumber.size();j++)		
		{	String FieldStr = (String)TaxNumber.get(0);
			if (FieldStr.equals("")&&(TaxNumber.size()>1))  TaxNumber.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<BankAccount.size();j++)		
		{	String FieldStr = (String)BankAccount.get(0);
			if (FieldStr.equals("")&&(BankAccount.size()>1))  BankAccount.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<InvoiceAcount.size();j++)		
		{	String FieldStr = (String)InvoiceAcount.get(0);
			if (FieldStr.equals("")&&(InvoiceAcount.size()>1))  InvoiceAcount.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<DeliveryType.size();j++)		
		{	String FieldStr = (String)DeliveryType.get(0);
			if (FieldStr.equals("")&&(DeliveryType.size()>1))  DeliveryType.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<PaymentTerm.size();j++)		
		{	String FieldStr = (String)PaymentTerm.get(0);
			if (FieldStr.equals("")&&(PaymentTerm.size()>1))  PaymentTerm.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<PaymentWay.size();j++)		
		{	String FieldStr = (String)PaymentWay.get(0);
			if (FieldStr.equals("")&&(PaymentWay.size()>1))  PaymentWay.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<SaleConfirm.size();j++)		
		{	String FieldStr = (String)SaleConfirm.get(0);
			if (FieldStr.equals("")&&(SaleConfirm.size()>1))  SaleConfirm.remove(0);
			else
				break;	
		}
		
		for (int j = 0 ;j<Credit.size();j++)		
		{	String FieldStr = (String)Credit.get(0);
			if (FieldStr.equals("")&&(Credit.size()>1))  Credit.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<CreditExpire.size();j++)		
		{	String FieldStr = (String)CreditExpire.get(0);
			if (FieldStr.equals("")&&(CreditExpire.size()>1))  CreditExpire.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Document.size();j++)		
		{	String FieldStr = (String)Document.get(0);
			if (FieldStr.equals("")&&(Document.size()>1))  Document.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<Photo.size();j++)		
		{	String FieldStr = (String)Photo.get(0);
			if (FieldStr.equals("")&&(Photo.size()>1))  Photo.remove(0);
			else
				break;	
		}
		
		for (int j = 0 ;j<Description.size();j++)		
		{	String FieldStr = (String)Description.get(0);
			if (FieldStr.equals("")&&(Description.size()>1))  Description.remove(0);
			else
				break;	
		}

		for (int j = 0 ;j<introductionDocid.size();j++)		
		{	String FieldStr = (String)introductionDocid.get(0);
			if (FieldStr.equals("")&&(introductionDocid.size()>1))  introductionDocid.remove(0);
			else
				break;	
		}
			

		ProcPara = (String)Customer.get(0);
		ProcPara += flag+(String)Name.get(0);
		ProcPara += flag+(String)Language.get(0);
		ProcPara += flag+(String)Abbrev.get(0);
		ProcPara += flag+(String)Address1.get(0);
		ProcPara += flag+(String)Address2.get(0);
		ProcPara += flag+(String)Address3.get(0);
		ProcPara += flag+(String)Zipcode.get(0);
		ProcPara += flag+(String)City.get(0);
		ProcPara += flag+(String)Country.get(0);
		ProcPara += flag+(String)Province.get(0);
		ProcPara += flag+(String)County.get(0);
		ProcPara += flag+(String)Phone.get(0);
		ProcPara += flag+(String)Fax.get(0);
		ProcPara += flag+(String)Email.get(0);
		ProcPara += flag+(String)Website.get(0);
		ProcPara += flag+(String)Source.get(0);
		ProcPara += flag+(String)Sector.get(0);
		ProcPara += flag+(String)Size.get(0);
		ProcPara += flag+(String)Manager.get(0);
		ProcPara += flag+(String)Agent.get(0);
		ProcPara += flag+(String)Parent.get(0);
		ProcPara += flag+(String)Department.get(0);
		ProcPara += flag+(String)Subcompanyid1.get(0);
		ProcPara += flag+(String)Fincode.get(0);
		ProcPara += flag+(String)Currency.get(0);
		ProcPara += flag+(String)ContractLevel.get(0);
		ProcPara += flag+(String)CreditLevel.get(0);
		ProcPara += flag+(String)CreditOffset.get(0);
		ProcPara += flag+(String)Discount.get(0);
		ProcPara += flag+(String)TaxNumber.get(0);
		ProcPara += flag+(String)BankAccount.get(0);
		ProcPara += flag+(String)InvoiceAcount.get(0);
		ProcPara += flag+(String)DeliveryType.get(0);
		ProcPara += flag+(String)PaymentTerm.get(0);
		ProcPara += flag+(String)PaymentWay.get(0);
		ProcPara += flag+(String)SaleConfirm.get(0);
		ProcPara += flag+(String)Credit.get(0);
		ProcPara += flag+(String)CreditExpire.get(0);
		ProcPara += flag+(String)Document.get(0);
		ProcPara += flag+(String)Seclevel.get(0);
		ProcPara += flag+(String)Photo.get(0);
		ProcPara += flag+(String)Type.get(0);
		ProcPara += flag+(String)TypeFrom.get(0);
		ProcPara += flag+(String)Description.get(0);
		ProcPara += flag+(String)Status.get(0);
		ProcPara += flag+(String)Rating.get(0);
		ProcPara += flag+(String)introductionDocid.get(0);
		ProcPara += flag+(String)CreditAmount.get(0);
		ProcPara += flag+(String)CreditTime.get(0);
		ProcPara += flag+(String)dff01.get(0);
		ProcPara += flag+(String)dff02.get(0);
		ProcPara += flag+(String)dff03.get(0);
		ProcPara += flag+(String)dff04.get(0);
		ProcPara += flag+(String)dff05.get(0);
		ProcPara += flag+(String)nff01.get(0);
		ProcPara += flag+(String)nff02.get(0);
		ProcPara += flag+(String)nff03.get(0);
		ProcPara += flag+(String)nff04.get(0);
		ProcPara += flag+(String)nff05.get(0);
		ProcPara += flag+(String)tff01.get(0);
		ProcPara += flag+(String)tff02.get(0);
		ProcPara += flag+(String)tff03.get(0);
		ProcPara += flag+(String)tff04.get(0);
		ProcPara += flag+(String)tff05.get(0);
		ProcPara += flag+(String)bff01.get(0);
		ProcPara += flag+(String)bff02.get(0);
		ProcPara += flag+(String)bff03.get(0);
		ProcPara += flag+(String)bff04.get(0);
		ProcPara += flag+(String)bff05.get(0);
			
		ProcPara += flag+(String)bankName.get(0);
		ProcPara += flag+(String)accountName.get(0);
		ProcPara += flag+(String)accounts.get(0);
		ProcPara += flag+(String)crmCode.get(0);
		RecordSet.executeProc("CRM_CustomerInfo_Update",ProcPara);
		

		for(int i=0;i<crmidArray.size();i++)
		{
			ProcPara = CustomerID;
			ProcPara += flag+(String)crmidArray.get(i);
			RecordSet.executeProc("CRM_ContactLog_Unite_Update",ProcPara);
			RecordSet.executeProc("CRM_Contacter_Unite_Update",ProcPara);
			
			
			ProcPara = (String)crmidArray.get(i);
			ProcPara += flag+"1";
			RecordSet.executeProc("CRM_CustomerInfo_Delete",ProcPara);
			
			/**客户合并是把客户联系记录也合并到主客户**/
			String congcrmid = (String)crmidArray.get(i);
			RecordSet.execute("update WorkPlan set crmid = '"+CustomerID+"' where type_n = 3 and crmid='"+congcrmid+"'");

			ProcPara = (String)crmidArray.get(i);
			ProcPara += flag+"d";
			ProcPara += flag+"0";
			ProcPara += flag+"";
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentUser;
			ProcPara += flag+SubmiterType;
			ProcPara += flag+ClientIP;
			RecordSet.executeProc("CRM_Log_Insert",ProcPara);
			UniteCustomerName += CustomerInfoComInfo.getCustomerInfoname((String)crmidArray.get(i)) + " , ";
		}
			rs.executeSql("update CRM_ShareInfo SET deleted = 1 WHERE relateditemid in ( "+crmids+" )");//共享信息设置为删除状态
		
			ProcPara = CustomerID;
			ProcPara += flag+"u";
			ProcPara += flag+"0";
			ProcPara += flag+SystemEnv.getHtmlLabelName(216,user.getLanguage())+SystemEnv.getHtmlLabelName(783,user.getLanguage())+":  "+UniteCustomerName;
			ProcPara += flag+CurrentDate;
			ProcPara += flag+CurrentTime;
			ProcPara += flag+CurrentUser;
			ProcPara += flag+SubmiterType;
			ProcPara += flag+ClientIP;
			RecordSet.executeProc("CRM_Log_Insert",ProcPara);

		CustomerInfoComInfo.removeCustomerInfoCache();
/*		
if(!isfromtab){
	response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
}else{
	response.sendRedirect("/CRM/data/UniteCustomer.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
}
*/
out.print("<script>parent.getParentWindow(window).UniteCallback("+CustomerID+");</script>");
%>