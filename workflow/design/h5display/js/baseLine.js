var BaseLine = function() {
	this.startNode = null;
	this.endNode = null;

	this.startRotation = -1;
	this.endRotation = -1;
	//默认偏移量
	this.defaultDistance = 15;
	this.xFrom = 0;
	this.xTo = 0;
	this.yFrom = 0;
	this.yTo = 0;
	this.interval = 10;
	this.interval4Node = 15;

	this.oldPoints = '';
	this.isreject = false;
	this.callRotation = function() {
		if (this.startRotation == -1 || this.endRotation == -1) {


			if (this.oldPoints != "") {
				var points = this.oldPoints.split(",");
				/** 起始节点方向 **/
				if (points.length >= 2) {
					var p = new Point(points[0] - 60, points[1] - 40);

					/**  **/
					if (p.x < this.startNode.x + 12) {
						this.startRotation = 90;
					} else if (p.x > this.startNode.x + 110) {
						this.startRotation = -90;
					} else if (p.y < this.startNode.y + 12) {
						this.startRotation = 180;
					} else if (p.y > this.startNode.y + 70) {
						this.startRotation = 0;
					} else {
						this.startRotation = 90;
					}
					/*
					else if (p.y < this.startNode.y + 12) {
						this.startRotation = 180;
					} else if (p.y > this.startNode.y + this.startNode.height) {
						this.startRotation = 0;
					}
					*/
				}
				/** 结束节点方向 **/
				if (points.length >= 4) {
					var p = new Point(points[points.length - 2] - 60, points[points.length - 1] - 40);
					if (p.x < this.endNode.x + 12) {
						this.endRotation = 90;
					} else if (p.x > this.endNode.x + 110) {
						this.endRotation = -90;
					} else if (p.y < this.endNode.y + 12) {
						this.endRotation = 180;
					} else if (p.y > this.endNode.y + 70) {
						this.endRotation = 0;
					} else {
						this.endRotation = -90;
					}
					/*else if (p.y < this.endNode.y + 12) {
						this.endRotation = 180;
					} else if (p.y > this.endNode.y + this.endNode.height) {
						this.endRotation = 0;
					}
					*/
				}
				//					trace("出口名称：" + nodelink.text + ", targetPostion=" + targetPostion + ", " + (this.startNode.x - this.endNode.x - this.endNode.width));
				/** 针对自动生成的出口 **/
				if (points.length == 4) {
					if (targetPostion == 4 || ((targetPostion == 1 || targetPostion == 7) && Math.abs(this.startNode.y - this.endNode.y) < 20)) {
						if (Math.abs(this.startNode.x - this.endNode.x - this.endNode.width) <= 100) {
							this.startRotation = 90;
							this.endRotation = -90;
						}
					} else if (targetPostion == 6 || ((targetPostion == 3 || targetPostion == 9) && Math.abs(this.startNode.x - this.endNode.x) < 20)) {
						if (Math.abs(this.endNode.x - this.startNode.x - this.startNode.width) <= 100) {
							this.startRotation = -90;
							this.endRotation = 90;
						}
					}
				}

				if (this.startNode == this.endNode) {
					this.endRotation = this.startRotation - 90;
					var rotation = this.startRotation;
					if (rotation == 0) {
						this.endRotation = -90;
					} else if (rotation == 90) {
						this.endRotation = 0;
					} else if (rotation == 180) {
						this.endRotation = 90;
					} else if (rotation == -90) {
						this.endRotation = 180;
					} else {
						this.endRotation = 0;
					}
				}
			} else {


				var targetPostion = this.getTargetNodePosition();
				//自由流程没有point
				if (targetPostion == 4 || ((targetPostion == 1 || targetPostion == 7) && Math.abs(this.startNode.y - this.endNode.y) < 20)) {
					if (Math.abs(this.startNode.x - this.endNode.x - this.endNode.width) <= 100) {
						this.startRotation = 90;
						this.endRotation = -90;
					}
				} else if (targetPostion == 6 || ((targetPostion == 3 || targetPostion == 9) && Math.abs(this.startNode.x - this.endNode.x) < 20)) {
					if (Math.abs(this.endNode.x - this.startNode.x - this.startNode.width) <= 100) {
						this.startRotation = -90;
						this.endRotation = 90;
					}
				}
			}
		}
	};

	/**
	 * 变换点,重新计算的起点和终点,画线;
	 */
	this.changePoint = function() {
		var startposition = this.getStartNodeClickPosition();
		var endposition = this.getEndNodeClickPosition();

		if (startposition == 1) {
			this.xFrom = this.startNode.leftPoint(this.startNode).x;
			this.yFrom = this.startNode.leftPoint(this.startNode).y;
		} else if (startposition == 2) {
			this.xFrom = this.startNode.topPoint(this.startNode).x;
			this.yFrom = this.startNode.topPoint(this.startNode).y;
		} else if (startposition == 3) {
			this.xFrom = this.startNode.rightPoint(this.startNode).x;
			this.yFrom = this.startNode.rightPoint(this.startNode).y;
		} else if (startposition == 4) {
			this.xFrom = this.startNode.bottomPoint(this.startNode).x;
			this.yFrom = this.startNode.bottomPoint(this.startNode).y;
		}

		if (endposition == 1) {
			this.xTo = this.endNode.leftPoint(this.endNode).x;
			this.yTo = this.endNode.leftPoint(this.endNode).y;
		} else if (endposition == 2) {
			this.xTo = this.endNode.topPoint(this.endNode).x;
			this.yTo = this.endNode.topPoint(this.endNode).y;
		} else if (endposition == 3) {
			this.xTo = this.endNode.rightPoint(this.endNode).x;
			this.yTo = this.endNode.rightPoint(this.endNode).y;
		} else if (endposition == 4) {
			this.xTo = this.endNode.bottomPoint(this.endNode).x;
			this.yTo = this.endNode.bottomPoint(this.endNode).y;
		}
	}

	/**
	 * 根据起始节点、结束节点计算折线点
	 * @return 坐标数组
	 */
	this.calPoints = function() {

		if (this.startNode == null || this.endNode == null) {
			return null;
		}

		this.startNode.getWHPoint();
		this.endNode.getWHPoint();
		//获取起始和结束节点信息

		this.callRotation();


		var aPoint = null;
		var bPoint = null;
		var cPoint = null;
		var dPoint = null;


		if (this.startNode === this.endNode) {
			this.startRotation = 0;
			this.endRotation = -90;
		} else if (Math.abs(this.startNode.y - this.endNode.y) < 30) {
			if (Math.abs(this.startNode.x - this.endNode.x) <= 210) {
				if (this.startNode.x < this.endNode.x) {
					this.startRotation = -90;
					this.endRotation = 90;

					aPoint = {
						x: this.startNode.rightPoint().x,
						y: this.endNode.leftPoint().y
					};
					bPoint = {
						x: this.endNode.leftPoint().x,
						y: this.endNode.leftPoint().y
					};
					return [aPoint, bPoint];
				} else {
					this.startRotation = 90;
					this.endRotation = -90;
					aPoint = {
						x: this.startNode.leftPoint().x,
						y: this.endNode.rightPoint().y
					};
					bPoint = {
						x: this.endNode.rightPoint().x,
						y: this.endNode.rightPoint().y
					};
					return [aPoint, bPoint];
				}
			} else {
				this.startRotation = 180;
				this.endRotation = 180;

			}
		} else if (Math.abs(this.startNode.x - this.endNode.x) < 18) {
			if (Math.abs(this.startNode.y - this.endNode.y) <= 170) {
				if (this.startNode.y < this.endNode.y) {
					this.startRotation = 0;
					this.endRotation = 180;

					aPoint = {
						x: this.endNode.topPoint().x,
						y: this.startNode.bottomPoint().y
					};
					bPoint = {
						x: this.endNode.topPoint().x,
						y: this.endNode.topPoint().y
					};
					return [aPoint, bPoint];
				} else {
					this.startRotation = 180;
					this.endRotation = 0;
					aPoint = {
						x: this.endNode.topPoint().x,
						y: this.startNode.topPoint().y
					};
					bPoint = {
						x: this.endNode.bottomPoint().x,
						y: this.endNode.bottomPoint().y
					};
					return [aPoint, bPoint];
				}
			} else {

				this.startRotation = 90;
				this.endRotation = 90;

			}
		}

		this.changePoint();
		var targetNodePosition = this.getTargetNodePosition();
		var startClickPosition = this.getStartNodeClickPosition(); //this.getClickPosition(this.startNode);

		var endClickPosition = this.getEndNodeClickPosition(); //this.getClickPosition(this.endNode);

		var startPoint = new Point(this.xFrom, this.yFrom);
		var endPoint = new Point(this.xTo, this.yTo);



		//			if (targetNodePosition == 5) {
		//				if (startClickPosition == 1) {
		//					
		//				}
		//			}
		//线的起始点为节点的左侧
		if (startClickPosition == 1) {
			if (targetNodePosition == 2 || targetNodePosition == 4) {
				targetNodePosition = 1;
			} else if (targetNodePosition == 6 || targetNodePosition == 8) {
				targetNodePosition = 9;
			}
			if (this.getTargetNodePosition() == 5) {
				targetNodePosition = 3;
			}
			if ((targetNodePosition == 1 && endClickPosition == 1) || (targetNodePosition == 7 && endClickPosition == 1)) { //左上方&&左 || 左下&&左 这点数：2
				bPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				aPoint = new Point(bPoint.x, startPoint.y);
			} else if ((targetNodePosition == 1 && endClickPosition == 2) || (targetNodePosition == 7 && endClickPosition == 4)) { //左上&&上|| 左下&&下  折点数：3
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.startNode.width + this.defaultDistance * 2);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 1 && endClickPosition == 3) || (targetNodePosition == 7 && endClickPosition == 3)) {
				if (startPoint.x - endPoint.x >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);

					var centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);

					bPoint = new Point(aPoint.x, centerPoint.y);
					cPoint = new Point(dPoint.x, centerPoint.y);
				}
			} else if ((targetNodePosition == 1 && endClickPosition == 4) || (targetNodePosition == 7 && endClickPosition == 2)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (aPoint.x >= cPoint.x && ((aPoint.y >= cPoint.y && targetNodePosition == 1) || (aPoint.y <= cPoint.y && targetNodePosition == 7))) {
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 3 && endClickPosition == 1) || (targetNodePosition == 9 && endClickPosition == 1)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(aPoint.x, cPoint.y);
			} else if ((targetNodePosition == 3 && endClickPosition == 2) || (targetNodePosition == 9 && endClickPosition == 4)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(aPoint.x, cPoint.y);
			} else if ((targetNodePosition == 3 && endClickPosition == 3) || (targetNodePosition == 9 && endClickPosition == 3)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);
					bPoint = new Point(aPoint.x, centerPoint.y);
					cPoint = new Point(dPoint.x, centerPoint.y);
				} else {
					if (targetNodePosition == 3) {
						cPoint = this.getLineFirstPoint(2, dPoint, this.defaultDistance * 2);
					} else {
						cPoint = this.getLineFirstPoint(4, dPoint, this.defaultDistance * 2);
					}
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 3 && endClickPosition == 4) || (targetNodePosition == 9 && endClickPosition == 2)) {
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance * 2 + this.endNode.height);
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			}
		} else if (startClickPosition == 2) {
			if (targetNodePosition == 2 || targetNodePosition == 4) {
				targetNodePosition = 1;
			} else if (targetNodePosition == 6 || targetNodePosition == 8) {
				targetNodePosition = 7;
			}

			if (this.getTargetNodePosition() == 5) {
				targetNodePosition = 9;
			}
			if ((targetNodePosition == 3 && endClickPosition == 2) || (targetNodePosition == 1 && endClickPosition == 2)) { //左上方&&左 || 左下&&左 这点数：2
				bPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				aPoint = new Point(startPoint.x, bPoint.y);
			} else if ((targetNodePosition == 3 && endClickPosition == 3) || (targetNodePosition == 1 && endClickPosition == 1)) { //左上&&上|| 左下&&下  折点数：3
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.startNode.height + this.defaultDistance * 2);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 3 && endClickPosition == 4) || (targetNodePosition == 1 && endClickPosition == 4)) {
				if (startPoint.y - endPoint.y >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);

					var centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);

					bPoint = new Point(centerPoint.x, aPoint.y);
					cPoint = new Point(centerPoint.x, dPoint.y);
				}
			} else if ((targetNodePosition == 3 && endClickPosition == 1) || (targetNodePosition == 1 && endClickPosition == 3)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (aPoint.y >= cPoint.y && ((targetNodePosition == 1 && aPoint.x >= cPoint.x) || (targetNodePosition == 3 && aPoint.x <= cPoint.x))) {
					if (Math.abs(aPoint.x - cPoint.x) < this.defaultDistance) {
						bPoint = new Point(cPoint.x, aPoint.y);
					} else {
						bPoint = new Point(aPoint.x, cPoint.y);
					}
				} else {
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 9 && endClickPosition == 2) || (targetNodePosition == 7 && endClickPosition == 2)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(cPoint.x, aPoint.y);
				//					if (targetNodePosition == 7 && endClickPosition == 2) {
				//						if (cPoint.y - aPoint.y < 5) {
				//							aPoint = bPoint;
				//							bPoint = cPoint;
				//							cPoint = null;
				//						}
				//					}
			} else if ((targetNodePosition == 9 && endClickPosition == 3) || (targetNodePosition == 7 && endClickPosition == 1)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(cPoint.x, aPoint.y);
			} else if ((targetNodePosition == 9 && endClickPosition == 4) || (targetNodePosition == 7 && endClickPosition == 4)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);
					bPoint = new Point(centerPoint.x, aPoint.y);
					cPoint = new Point(centerPoint.x, dPoint.y);
				} else {
					if (targetNodePosition == 7) {
						cPoint = this.getLineFirstPoint(1, dPoint, this.defaultDistance * 2);
					} else {
						cPoint = this.getLineFirstPoint(3, dPoint, this.defaultDistance * 2);
					}
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 9 && endClickPosition == 1) || (targetNodePosition == 7 && endClickPosition == 3)) {
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance * 2 + this.endNode.height);
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			}

		} else if (startClickPosition == 3) {
			if (targetNodePosition == 2 || targetNodePosition == 4) {
				targetNodePosition = 1;
			} else if (targetNodePosition == 6 || targetNodePosition == 8) {
				targetNodePosition = 9;
			}

			if (this.getTargetNodePosition() == 5) {
				targetNodePosition = 7;
			}

			if ((targetNodePosition == 9 && endClickPosition == 3) || (targetNodePosition == 3 && endClickPosition == 3)) { //左上方&&左 || 左下&&左 这点数：2
				bPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				aPoint = new Point(bPoint.x, startPoint.y);
			} else if ((targetNodePosition == 9 && endClickPosition == 4) || (targetNodePosition == 3 && endClickPosition == 2)) { //左上&&上|| 左下&&下  折点数：3
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.startNode.width + this.defaultDistance * 2);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 9 && endClickPosition == 1) || (targetNodePosition == 3 && endClickPosition == 1)) {
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2 && endPoint.x > startPoint.x) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);

					var centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);

					bPoint = new Point(aPoint.x, centerPoint.y);
					cPoint = new Point(dPoint.x, centerPoint.y);
				}
			} else if ((targetNodePosition == 9 && endClickPosition == 2) || (targetNodePosition == 3 && endClickPosition == 4)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (aPoint.x <= cPoint.x && ((aPoint.y >= cPoint.y && targetNodePosition == 3) || (aPoint.y <= cPoint.y && targetNodePosition == 9))) {
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 7 && endClickPosition == 3) || (targetNodePosition == 1 && endClickPosition == 3)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(aPoint.x, cPoint.y);
			} else if ((targetNodePosition == 7 && endClickPosition == 4) || (targetNodePosition == 1 && endClickPosition == 2)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(aPoint.x, cPoint.y);
			} else if ((targetNodePosition == 7 && endClickPosition == 1) || (targetNodePosition == 1 && endClickPosition == 1)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);
					bPoint = new Point(aPoint.x, centerPoint.y);
					cPoint = new Point(dPoint.x, centerPoint.y);
				} else {
					if (targetNodePosition == 3) {
						cPoint = this.getLineFirstPoint(2, dPoint, this.defaultDistance * 2);
					} else {
						cPoint = this.getLineFirstPoint(4, dPoint, this.defaultDistance * 2);
					}
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			} else if ((targetNodePosition == 7 && endClickPosition == 2) || (targetNodePosition == 1 && endClickPosition == 4)) {
				//当两个节点之间的距离过短时，则从左方绕过
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance * 2 + this.endNode.height);
					bPoint = new Point(aPoint.x, cPoint.y);
				}
			}

		} else if (startClickPosition == 4) {
			if (targetNodePosition == 8 || targetNodePosition == 4) {
				targetNodePosition = 7;
			} else if (targetNodePosition == 6 || targetNodePosition == 2) {
				targetNodePosition = 3;
			}

			if (this.getTargetNodePosition() == 5) {
				targetNodePosition = 1;
			}
			if ((targetNodePosition == 7 && endClickPosition == 4) || (targetNodePosition == 9 && endClickPosition == 4)) { //左上方&&左 || 左下&&左 这点数：2
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);

				if (aPoint.y > cPoint.y) {
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					bPoint = new Point(aPoint.x, cPoint.y);
				}

			} else if ((targetNodePosition == 7 && endClickPosition == 1) || (targetNodePosition == 9 && endClickPosition == 3)) { //左上&&上|| 左下&&下  折点数：3
				if (Math.abs(startPoint.y - endPoint.y) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.startNode.height + this.defaultDistance * 2);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 7 && endClickPosition == 2) || (targetNodePosition == 9 && endClickPosition == 2)) {
				if (endPoint.y - startPoint.y >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);

					var centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);

					bPoint = new Point(centerPoint.x, aPoint.y);
					cPoint = new Point(centerPoint.x, dPoint.y);
				}
			} else if ((targetNodePosition == 7 && endClickPosition == 3) || (targetNodePosition == 9 && endClickPosition == 1)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (aPoint.y <= cPoint.y && ((targetNodePosition == 7 && aPoint.x >= cPoint.x) || (targetNodePosition == 9 && aPoint.x <= cPoint.x))) {
					//if (cPoint.y <= aPoint.y && ((targetNodePosition == 7 && cPoint.x))) {
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 1 && endClickPosition == 4) || (targetNodePosition == 3 && endClickPosition == 4)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(startClickPosition, endPoint, this.defaultDistance);

				if (cPoint.y > aPoint.y) {
					bPoint = new Point(aPoint.x, cPoint.y);
				} else {
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 1 && endClickPosition == 1) || (targetNodePosition == 3 && endClickPosition == 3)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				bPoint = new Point(cPoint.x, aPoint.y);
			} else if ((targetNodePosition == 1 && endClickPosition == 2) || (targetNodePosition == 3 && endClickPosition == 2)) {
				aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
				dPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					centerPoint = this.cal2PointMiddPoint(aPoint, dPoint);
					bPoint = new Point(centerPoint.x, aPoint.y);
					cPoint = new Point(centerPoint.x, dPoint.y);
				} else {
					if (targetNodePosition == 7) {
						cPoint = this.getLineFirstPoint(1, dPoint, this.defaultDistance * 2);
					} else {
						cPoint = this.getLineFirstPoint(3, dPoint, this.defaultDistance * 2);
					}
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			} else if ((targetNodePosition == 1 && endClickPosition == 3) || (targetNodePosition == 3 && endClickPosition == 1)) {
				if (Math.abs(startPoint.x - endPoint.x) >= this.defaultDistance * 2) {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance);
					bPoint = new Point(cPoint.x, aPoint.y);
				} else {
					aPoint = this.getLineFirstPoint(startClickPosition, startPoint, this.defaultDistance);
					cPoint = this.getLineFirstPoint(endClickPosition, endPoint, this.defaultDistance * 2 + this.endNode.height);
					bPoint = new Point(cPoint.x, aPoint.y);
				}
			}

		}
		/** 点重合的情况，删除重合点，只保留一个 **/
		if (dPoint != null && cPoint != null) {
			if (dPoint.x == cPoint.x && dPoint.y == cPoint.y) {
				dPoint = null;
			}
		}

		if (cPoint != null && bPoint != null) {
			if (cPoint.x == bPoint.x && cPoint.y == bPoint.y) {
				cPoint = dPoint;
				dPoint = null;
			}
		}

		if (bPoint != null && aPoint != null) {
			if (bPoint.x == aPoint.x && bPoint.y == aPoint.y) {
				bPoint = cPoint;
				cPoint = dPoint;
				dPoint = null;
			}
		}

		if (dPoint == null && cPoint != null) {
			if ((aPoint.x == bPoint.x || cPoint.x == bPoint.x) && ((startClickPosition == 1 && endClickPosition == 3) || (startClickPosition == 3 && endClickPosition == 1))) {
				var xCenter = Math.abs(cPoint.x - aPoint.x) / 2;
				if (cPoint.x > aPoint.x) {
					aPoint.x += xCenter;
				} else {
					aPoint.x -= xCenter;
				}

				if (cPoint.x == bPoint.x) {
					bPoint.y = cPoint.y;
				}

				bPoint.x = aPoint.x;
				cPoint = null;
			} else if ((aPoint.y == bPoint.y || cPoint.y == bPoint.y) && ((startClickPosition == 2 && endClickPosition == 4) || (startClickPosition == 4 && endClickPosition == 2))) {
				var yCenter = Math.abs(cPoint.y - aPoint.y) / 2;

				if (cPoint.y > aPoint.y) {
					aPoint.y += yCenter;
				} else {
					aPoint.y -= yCenter;
				}

				if (cPoint.y == bPoint.y) {
					bPoint.x = cPoint.x;
				}
				bPoint.y = aPoint.y;
				cPoint = null;
			}
		}

		var points = [];
		//points.addItem(new Point(_xFrom, _yFrom));
		points.push({
			x: this.xFrom,
			y: this.yFrom
		});

		if (aPoint != null) {
			points.push({
				x: aPoint.x,
				y: aPoint.y
			});
		}

		if (bPoint != null) {
			//points.push(bPoint);
			points.push({
				x: bPoint.x,
				y: bPoint.y
			});
		}

		if (cPoint != null) {
			//points.push(cPoint);
			points.push({
				x: cPoint.x,
				y: cPoint.y
			});
		}

		if (dPoint != null) {
			//points.push(dPoint);
			points.push({
				x: dPoint.x,
				y: dPoint.y
			});
		}
		//points.push(new Point(_xTo, _yTo));
		points.push({
			x: this.xTo,
			y: this.yTo
		});
		//			this.points = points;
		return points;
	}


	/**
	 * 获取第一个折点
	 */
	this.getLineFirstPoint = function(position, _point, defltDist) {
		var rtnPoint = new Point();
		if (position == 1) { // 左
			rtnPoint.x = _point.x - defltDist;
			rtnPoint.y = _point.y;
		} else if (position == 2) { //上
			rtnPoint.x = _point.x;
			rtnPoint.y = _point.y - defltDist;
		} else if (position == 3) { //右
			rtnPoint.x = _point.x + defltDist;
			rtnPoint.y = _point.y;
		} else if (position == 4) { //下
			rtnPoint.x = _point.x;
			rtnPoint.y = _point.y + defltDist;
		}
		return rtnPoint;
	}



	/**
	 * 计算目标节点的位置
	 * 1    2    3
	 * 4    5    6
	 * 7    8    9 
	 */
	this.getTargetNodePosition = function() {
		var rtnPosition = -1;
		/** 起始节点与结束节点为同一节点或者为层叠节点 **/
		if (this.startNode == this.endNode || (this.startNode.x == this.endNode.x && this.startNode.y == this.endNode.y)) {
			return 5;
		}

		/** 同一垂直线上 **/
		if (this.startNode.x == this.endNode.x) {
			/** 目标节点在起始节点上方 **/
			if (this.startNode.y > this.endNode.y) {
				return 2;
			}
			/** 目标节点在起始节点下方 **/
			if (this.startNode.y < this.endNode.y) {
				return 8;
			}
		}

		/** 同一水平线上 **/
		if (this.startNode.y == this.endNode.y) {
			/**目标节点在起始节点左方**/
			if (this.startNode.x > this.endNode.x) {
				return 4;
			}
			/**目标节点在起始节点右方**/
			if (this.startNode.x < this.endNode.x) {
				return 6;
			}
		}
		/** 目标节点在起始节点的左上方 **/
		if (this.startNode.x > this.endNode.x && this.startNode.y > this.endNode.y) {
			return 1;
		}

		/** 目标节点在起始节点的右上方 **/
		if (this.startNode.x < this.endNode.x && this.startNode.y > this.endNode.y) {
			return 3;
		}

		/** 目标节点在起始节点的左下方 **/
		if (this.startNode.x > this.endNode.x && this.startNode.y < this.endNode.y) {
			return 7;
		}

		/** 目标节点在起始节点的右下方 **/
		if (this.startNode.x < this.endNode.x && this.startNode.y < this.endNode.y) {
			return 9;
		}

		return rtnPosition;
	}

	/**
	 * 获取起始节点点击的方向
	 *     2(180)
	 * 1(90)   3(270) -90
	 *     4(360) 0
	 */
	this.getStartNodeClickPosition = function() {
		if (this.startNode == null) {
			return -1;
		}
		var rotation = this.startRotation;

		if (rotation == 0) {
			return 4;
		} else if (rotation == 90) {
			return 1;
		} else if (rotation == 180) {
			return 2;
		} else if (rotation == -90) {
			return 3;
		} else if (rotation == 0) {
			return 4;
		}
		return -1;
	}

	/**
	 * 获取结束节点点击的方向
	 *     2(180)
	 * 1(90)   3(270)
	 *     4(360)
	 */
	this.getEndNodeClickPosition = function() {
		if (this.startNode == null) {
			return -1;
		}
		var rotation = this.endRotation;

		if (rotation == 0) {
			return 4;
		} else if (rotation == 90) {
			return 1;
		} else if (rotation == 180) {
			return 2;
		} else if (rotation == -90) {
			return 3;
		} else if (rotation == 0) {
			return 4;
		}
		return -1;
	}

	this.cal2PointMiddPoint = function(p1, p2) {
		var middPoint = new Point();

		var x = Math.abs(p1.x - p2.x) / 2;
		var y = Math.abs(p1.y - p2.y) / 2

		if (p1.x < p2.x) {
			x += p1.x;
		} else {
			x += p2.x;
		}

		if (p1.y < p2.y) {
			y += p1.y;
		} else {
			y += p2.y;
		}
		middPoint.x = x;
		middPoint.y = y;

		return middPoint;
	}

	this.leftPoint = function(nodebase) {
		var point = new Point(nodebase.x - this.interval4Node, nodebase.y + nodebase.height / 2);
		return point;
	}

	this.topPoint = function(nodebase) {
		var point = new Point(nodebase.x + nodebase.width / 2, nodebase.y - this.interval4Node);
		return point;
	}

	this.rightPoint = function(nodebase) {
		var point = new Point(nodebase.x + nodebase.width + this.interval4Node, nodebase.y + nodebase.height / 2);
		return point;
	}
	this.bottomPoint = function(nodebase) {
		var point = new Point(nodebase.x + nodebase.width / 2, nodebase.y + nodebase.height + this.interval4Node);
		return point;
	}
}