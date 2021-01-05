import { DatePicker, Card, Table, Icon, Divider, Steps, Menu } from 'antd';

const Step = Steps.Step;

class List extends React.Component {

    render() {

        const columns = [{
            title: '督办事项',
            dataIndex: 'name',
            key: 'name',
            render: text => <a href="#">{text}</a>,
        }, {
            title: '类型',
            dataIndex: 'type',
            key: 'type',
        }, {
            title: '状态',
            dataIndex: 'statu',
            key: 'statu',
        }, {
            title: '阶段',
            dataIndex: 'state',
            key: 'state',
            render: (text, record) => (
                <span>
                    <Steps size="small" current={1}>
                        <Step title="" />
                        <Step title="" />
                        <Step title="" />
                    </Steps>
                </span>
            ),
        }, {
            title: '结束时间',
            dataIndex: 'endtime',
            key: 'endtime',
        }, {
            title: '拟文单位',
            dataIndex: 'unit',
            key: 'unit',
        }, {
            title: '拟文人',
            dataIndex: 'creater',
            key: 'creater',
        }];

        const data = [{
            key: '1',
            name: '2018年度从严治党政策文件制定',
            type: "政府工作报告",
            statu: '立项',
            endtime: "2017-12-31",
            unit: "办公室",
            creater: "张三"
        }, {
            key: '2',
            name: '第九次办公会决议',
            type: "政府工作报告",
            statu: '立项',
            endtime: "2017-12-31",
            unit: "办公室",
            creater: "李四"
        }, {
            key: '3',
            name: '2018年度从严治党政策文件制定',
            type: "政府工作报告",
            statu: '立项',
            endtime: "2017-12-31",
            unit: "办公室",
            creater: "王小明"
        }, {
            key: '4',
            name: '第九次办公会决议执行事项',
            type: "重点工程",
            statu: '立项',
            endtime: "2017-12-31",
            unit: "办公室",
            creater: "张三"
        }];

        const rowSelection = {
            onChange: (selectedRowKeys, selectedRows) => {
                console.log(`selectedRowKeys: ${selectedRowKeys}`, 'selectedRows: ', selectedRows);
            },
            getCheckboxProps: record => ({
                disabled: record.name === 'Disabled User', // Column configuration not to be checked
            }),
        };

        return (
            <Card extra={<a href="#">More</a>} className="Dblist" title="督办任务列表" style={{ width: '100%' }}>
                <Table columns={columns} dataSource={data} pagination={false} loading={false} />
            </Card>
        )
    }
}

export default List