package control
{
	import mx.controls.Button;
	
	public class LabelDescriptor extends Button
	{
		public function LabelDescriptor (value:String)
		{
			width=50;
			height=20;
			label=value+"%";
			styleName="labelText";
			this.buttonMode=false
			this.toolTip = this.label;
			
		}
	}
}