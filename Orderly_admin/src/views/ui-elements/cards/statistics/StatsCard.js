// ** Third Party Components
import classnames from "classnames";
import { TrendingUp, User, Box, DollarSign, ShoppingBag } from "react-feather";
import { useSelector, useDispatch } from "react-redux";

// ** Custom Components
import Avatar from "@components/avatar";

// ** Reactstrap Imports
import {
  Card,
  CardHeader,
  CardTitle,
  CardBody,
  CardText,
  Row,
  Col,
} from "reactstrap";
import { nFormatter } from "./StatsCardStore";
import React from "react";

const StatsCard = ({ cols }) => {
  const stateCnt = useSelector((state) => state.statistic.stististicsCounts);

  const data = [
    {
      title: nFormatter(
        stateCnt && stateCnt.scan_user_cnt ? stateCnt.scan_user_cnt : 0
      ),
      subtitle: "Travelers",
      color: "light-primary",
      icon: <TrendingUp size={24} />,
    },
    {
      title: nFormatter(
        stateCnt && stateCnt.customer_cnt ? stateCnt.customer_cnt : 0
      ),
      subtitle: "Customers",
      color: "light-info",
      icon: <User size={24} />,
    },
    {
      title: nFormatter(
        stateCnt && stateCnt.supplier_cnt ? stateCnt.supplier_cnt : 0
      ),
      subtitle: "Suppliers",
      color: "light-danger",
      icon: <ShoppingBag size={24} />,
    },
    {
      title: nFormatter(
        stateCnt && stateCnt.discounted_amt ? stateCnt.discounted_amt : 0
      ),
      subtitle: "Discount",
      color: "light-success",
      icon: <DollarSign size={24} />,
    },
  ];

  const renderData = () => {
    return data.map((item, index) => {
      const colMargin = Object.keys(cols);
      const margin = index === 2 ? "sm" : colMargin[0];
      return (
        <Col
          key={index}
          {...cols}
          className={classnames({
            [`mb-2 mb-${margin}-0`]: index !== data.length - 1,
          })}
        >
          <div className="d-flex align-items-center">
            <Avatar color={item.color} icon={item.icon} className="me-2" />
            <div className="my-auto">
              <h4 className="fw-bolder mb-0">{item.title}</h4>
              <CardText className="font-small-3 mb-0">{item.subtitle}</CardText>
            </div>
          </div>
        </Col>
      );
    });
  };

  return (
    <Card className="card-statistics">
      <CardHeader>
        <CardTitle tag="h4">Statistics</CardTitle>
        <CardText className="card-text font-small-2 me-25 mb-0"></CardText>
      </CardHeader>
      <CardBody className="statistics-body">
        <Row>{renderData()}</Row>
      </CardBody>
    </Card>
  );
};

export default StatsCard;
