import { Row, Col, Card, Tooltip } from 'antd';

import WeaDBTop from '../../plugin/wea-DB-top';

class Portal extends React.Component {

    componentDidMount() {
        this.init();
    }

    init = () => {
    }

    handleClick = (e) => {
        console.log('click ', e);
        this.setState({
            current: e.key
        });
    }

    openList = (category) => {
        window.top.onUrl("projectList" + category.id, category.objname, "/#/formmode/governor?cid=" + category.id);
    }

    getCards = (index, height) => {
        const categorys = this.props.categorys;
        const countMap = this.props.countMap;
        let obj = {};
        if (index < 6) {
            obj = categorys[index];
        } else if (index == 6) {
            let count = countMap["0"] ? countMap["0"] : 0;
            obj = { type: "", objname: "主办任务", dealtype: "0", count: count, color: "#7cc5e9", background: "url(/govern/image/zhuban.png)" }
        } else if (index == 7) {
            let count = countMap["1"] ? countMap["1"] : 0;
            obj = { type: "", objname: "协办任务", dealtype: "1", count: count, color: "#7cc5e9", background: "url(/govern/image/xieban.png)" }
        }
        if (obj) {
            return (
                <Card onClick={this.openList.bind(this, obj)} className="Dblist" style={{ marginBottom: 24 }} bordered={false}>
                    <div className="container" style={{ height: height, background: obj.color || "#62d7d3" }}>
                        <div className="icon" style={{ backgroundImage: obj.background || "url(/govern/image/zhishi.png)" }}></div>
                        <div className="dot">{obj.count}</div>
                        &nbsp; &nbsp;
                                    <div className="name">
                            {obj.objname}
                        </div>
                    </div>
                </Card>
            )
        }
    }

    render() {
        let winWidth = document.body.offsetWidth;
        let winHeight = document.body.offsetHeight;
        let pad = winWidth * 0.17;
        let height = winWidth * 0.085;
        let lHeight = height * 2 + 24;
        //let cardCol0 = this.getCards(0);
        return (
            <div>
                <div style={{ padding: "50px " + pad + "px", background: "#f0f2f5" }}>
                    <Row gutter={24}>
                        <Col xl={14} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: 24 }}>
                            <Card className="Dblist" style={{ marginBottom: 24 }} bordered={false}>
                                <iframe src="/homepage/Homepage.jsp?hpid=18&isfromportal=2" frameborder="0" style={{ border: 0, width: "100%", height: lHeight }} />
                            </Card>
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24}>
                            {this.getCards(0, height)}
                            {this.getCards(2, height)}
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24}>
                            {this.getCards(1, height)}
                            {this.getCards(3, height)}
                        </Col>
                    </Row>

                    <Row gutter={24}>
                        <Col xl={7} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: 24 }}>
                            <Card className="Dblist" style={{ marginBottom: 24 }} bordered={false}>
                                <div style={{ width: "100%", background: "#f97e81", height: lHeight }} />
                            </Card>
                        </Col>
                        <Col xl={7} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: 24 }}>
                            <Card className="Dblist" style={{ marginBottom: 24 }} bordered={false}>
                                <div style={{ width: "100%", background: "#5283d1", height: lHeight }} />
                            </Card>
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24}>
                            {this.getCards(4, height)}
                            {this.getCards(6, height)}
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24}>
                            {this.getCards(5, height)}
                            {this.getCards(7, height)}
                        </Col>
                    </Row>
                </div>
            </div >
        )
    }
}

export default Portal