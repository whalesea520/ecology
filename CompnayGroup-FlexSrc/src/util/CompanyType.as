package util
{
	public class CompanyType
	{
		/*全部公司*/
		public var All:String="all"; 
		/*开发公司*/
		public var Develop:String="develop";
		/*商业公司*/
		public var Business:String="business";
		/*物业公司*/
		public var Tenement:String="tenement";
		/*咨询公司*/
		public var Consult:String="consult";
		/*基金公司*/
		public var Fund:String="fund";
		
		/*集团内架构内*/
		public var InAndIn:String ="inandin";
		/*集团内架构外*/
		public var InAndOut:String ="inandout";
		/*集团外境内*/
		public var OutAndOut:String ="outandin";
		/*集团外境外*/
		public var OutAndIn:String ="outandout";
		
		private static var one:CompanyType;
		
		public static function getOne():CompanyType
		{
			if (one == null)one = new CompanyType();
			return one;
		}
		
		public function CompanyType()
		{
			
		}
	}
}