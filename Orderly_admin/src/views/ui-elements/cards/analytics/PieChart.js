// ** Third Party Components
import axios from "axios";
import { useEffect, useState } from "react";
import ReactApexChart from "react-apexcharts";
import { useSelector, useDispatch } from "react-redux";

// ** Reactstrap Imports
import {
  Card,
  CardTitle,
  CardText,
  CardBody,
  Row,
  Col,
  CardHeader,
} from "reactstrap";

const token = localStorage.getItem("token");

const PieChart = ({ success }) => {
  const stateCnt = useSelector((state) => state.statistic.stististicsCounts);

  const getValueInfo = (type) => {
    if (type == "label") {
      return stateCnt && stateCnt.total_supplier_group
        ? stateCnt.total_supplier_group.map((i) => {
            return i.supplier_type;
          })
        : [];
    }
    if (type == "cnt") {
      return stateCnt && stateCnt.total_supplier_group
        ? stateCnt.total_supplier_group.map((i) => {
            return parseFloat(i.cnt);
          })
        : [];
    }
  };
  const options = {
    series: getValueInfo("cnt"),
    options: {
      scales: {
        xAxes: [
          {
            ticks: {
              display: false,
            },
          },
        ],
      },

      chart: {
        // width: 380,
        // height:300,
        type: "pie",
      },
      labels: getValueInfo("label"),
      legend: {
        position: "bottom",
      },
      responsive: [
        {
          breakpoint: 480,
          options: {
            chart: {
              // width: 200,
              // height:300,
            },
            legend: {
              position: "bottom",
            },
          },
        },
      ],
    },
  };

  return (
    <Card className="earnings-card">
      <CardHeader>
        <CardTitle tag="h4">Suppliers</CardTitle>
      </CardHeader>
      <CardBody>
        <Row>
          <Col xs="12">
            <ReactApexChart
              options={options.options}
              series={options.series}
              type="pie"
            />
          </Col>
        </Row>
      </CardBody>
    </Card>
  );
};

export default PieChart;
