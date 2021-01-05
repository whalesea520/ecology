CREATE TABLE workflow_TabStyle(
	 styleid   int  IDENTITY(1,1) NOT NULL,
	 stylename   varchar (500) NULL,
	 image_bg   varchar (500) NULL,
	 image_sep   varchar (500) NULL,
	 image_sepwidth   int  NULL,
	 sel_bgleft   varchar (500) NULL,
	 sel_bgleftwidth   int  NULL,
	 sel_bgmiddle   varchar (500) NULL,
	 sel_bgright   varchar (500) NULL,
	 sel_bgrightwidth   int  NULL,
	 sel_color   varchar (50) NULL,
	 sel_fontsize   int  NULL,
	 sel_family   varchar (50) NULL,
	 sel_bold   int  NULL,
	 sel_italic   int  NULL,
	 unsel_bgleft   varchar (500) NULL,
	 unsel_bgleftwidth   int  NULL,
	 unsel_bgmiddle   varchar (500) NULL,
	 unsel_bgright   varchar (500) NULL,
	 unsel_bgrightwidth   int  NULL,
	 unsel_color   varchar (50) NULL,
	 unsel_fontsize   int  NULL,
	 unsel_family   varchar (50) NULL,
	 unsel_bold   int  NULL,
	 unsel_italic   int  NULL
)
GO