// ** Third Party Components
import classnames from "classnames";
import {
  TrendingUp,
  User,
  Box,
  DollarSign,
  ShoppingBag,
  Star,
} from "react-feather";

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
import React, { useEffect, useState } from "react";
import axios from "axios";

const nFormatter = (num) => {
  if (num == 0) {
    return num;
  }
  const lookup = [
    { value: 1, symbol: "" },
    { value: 1e3, symbol: "k" },
    { value: 1e6, symbol: "M" },
    { value: 1e9, symbol: "G" },
    { value: 1e12, symbol: "T" },
    { value: 1e15, symbol: "P" },
    { value: 1e18, symbol: "E" },
  ];
  const rx = /\.0+$|(\.[0-9]*[1-9])0+$/;
  var item = lookup
    .slice()
    .reverse()
    .find(function (item) {
      return num >= item.value;
    });
  return item
    ? (num / item.value).toFixed(1).replace(rx, "$1") + item.symbol
    : "0";
};

const StatsCardStore = ({ cols }) => {
  const token = localStorage.getItem("token");

  const [data, setData] = useState();

  useEffect(() => {
    axios
      .get("/supplier/statistics", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        setData(response.data);
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

  const data1 = [
    {
      title: data ? nFormatter(data.totalrevenue) : 0,
      subtitle: "Sales",
      color: "light-primary",
      icon: <TrendingUp size={24} />,
    },
    {
      title: data ? nFormatter(data.totalOrder) : 0,
      subtitle: "Orders",
      color: "light-info",
      icon: <ShoppingBag size={24} />,
    },
    {
      title: data ? nFormatter(data.totalReview) : 0,
      subtitle: "Reviews",
      color: "light-danger",
      icon: <Star size={24} />,
    },
    {
      title: data ? nFormatter(data.totalProduct) : 0,
      subtitle: "Products",
      color: "light-success",
      icon: <Box size={24} />,
    },
  ];

  const renderData = () => {
    return data1.map((item, index) => {
      const colMargin = Object.keys(cols);
      const margin = index === 2 ? "sm" : colMargin[0];
      return (
        <Col
          key={index}
          {...cols}
          className={classnames({
            [`mb-2 mb-${margin}-0`]: index !== data1.length - 1,
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
        <CardText className="card-text font-small-2 me-25 mb-0">
          Statistics till now.
        </CardText>
      </CardHeader>
      <CardBody className="statistics-body">
        <Row>{renderData()}</Row>
      </CardBody>
    </Card>
  );
};

export default StatsCardStore;

export { nFormatter };
