package common
{
	import model.CompanyInfo;

	/*常用类对象池*/
	public class StaticObj
	{
		//公司信息
		public var companyinfo:CompanyInfo;
		
		//集团ID
		public var groupid:String="";
		
		public function StaticObj()
		{
			companyinfo = new CompanyInfo;
		}
	}
}