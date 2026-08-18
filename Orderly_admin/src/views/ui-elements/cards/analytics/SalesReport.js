// ** React Imports
import React, { useEffect, useState } from "react";

// ** Third Party Components
import axios from "axios";
import Chart from "react-apexcharts";

// ** Reactstrap Imports
import {
  Row,
  Col,
  Card,
  Button,
  CardTitle,
  DropdownMenu,
  DropdownItem,
  DropdownToggle,
  UncontrolledButtonDropdown,
} from "reactstrap";
import { nFormatter } from "../statistics/StatsCardStore";
import { useSelector } from "react-redux";

const SalesReport = (props) => {
  const stateCnt = useSelector((state) => state.statistic.stististicsCounts);
  const [data, setData] = useState({
    month:
      stateCnt && stateCnt.last7DaySales ? stateCnt.last7DaySales.month : [],
    revenue:
      stateCnt && stateCnt.last7DaySales ? stateCnt.last7DaySales.revenue : [],
    totalRevenu:
      stateCnt && stateCnt.last7DaySales
        ? stateCnt.last7DaySales.totalRevenu
        : 0,
    totalOrder:
      stateCnt && stateCnt.last7DaySales
        ? stateCnt.last7DaySales.totalOrder
        : 0,
  });

  useEffect(() => {
    setData({
      month:
        stateCnt && stateCnt.last7DaySales ? stateCnt.last7DaySales.month : [],
      revenue:
        stateCnt && stateCnt.last7DaySales
          ? stateCnt.last7DaySales.revenue
          : [],
      totalRevenu:
        stateCnt && stateCnt.last7DaySales
          ? stateCnt.last7DaySales.totalRevenu
          : 0,
      totalOrder:
        stateCnt && stateCnt.last7DaySales
          ? stateCnt.last7DaySales.totalOrder
          : 0,
    });
  }, [stateCnt]);
  const token = localStorage.getItem("token");

  const [selectedYear, setSelectedYear] = useState();
  // useEffect(() => {
  //   axios
  //     .post(
  //       "/supplier/revenuereportdetailsbyyear",
  //       { year: 2022 },
  //       {
  //         headers: { Authorization: `Bearer ${token}` },
  //       }
  //     )
  //     .then((response) => {
  //       setData({
  //         ...data,
  //         month: response.data.month,
  //         revenue: response.data.revenue,
  //         totalRevenu: nFormatter(response.data.totalRevenu),
  //         totalOrder: nFormatter(response.data.totalOrder),
  //       });
  //       console.log("jshkfjgsgfs", data);
  //     })
  //     .catch((err) => {
  //       console.log(err);
  //     });
  // }, []);

  const revenueOptions = {
      chart: {
        stacked: true,
        type: "bar",
        toolbar: { show: false },
      },
      grid: {
        padding: {
          top: -20,
          bottom: -10,
        },
        yaxis: {
          lines: { show: false },
        },
      },
      xaxis: {
        categories: data.month,
        labels: {
          style: {
            colors: "#b9b9c3",
            fontSize: "0.86rem",
          },
        },
        axisTicks: {
          show: false,
        },
        axisBorder: {
          show: false,
        },
      },
      legend: {
        show: false,
      },
      dataLabels: {
        enabled: false,
      },
      colors: [props.primary, props.warning],
      plotOptions: {
        bar: {
          columnWidth: "17%",
          borderRadius: [5],
        },
        distributed: true,
      },
      yaxis: {
        labels: {
          style: {
            colors: "#b9b9c3",
            fontSize: "0.86rem",
          },
        },
      },
    },
    revenueSeries = [
      {
        name: "Discount",
        data: data.revenue,
      },
      {
        name: "Expense",
        // data: [-145, -80, -60, -180, -100, -60, -85, -75, -100]
        data: [0, 0, 0, 0, 0, 0, 0, 0, 0],
      },
    ];

  const budgetSeries = [
      {
        data: [61, 48, 69, 52, 60, 40, 79, 60, 59, 43, 62],
      },
      {
        data: [20, 10, 30, 15, 23, 0, 25, 15, 20, 5, 27],
      },
    ],
    budgetOptions = {
      chart: {
        toolbar: { show: false },
        zoom: { enabled: false },
        type: "line",
        sparkline: { enabled: true },
      },
      stroke: {
        curve: "smooth",
        dashArray: [0, 5],
        width: [2],
      },
      colors: [props.primary, "#dcdae3"],
      tooltip: {
        enabled: false,
      },
    };

  return data !== null ? (
    <Card className="card-revenue-budget">
      <Row className="mx-0">
        <Col className="revenue-report-wrapper" md="8" xs="12">
          <div className="d-sm-flex justify-content-between align-items-center mb-3">
            <CardTitle className="mb-50 mb-sm-0">Sales Report</CardTitle>
            <div className="d-flex align-items-center">
              <div className="d-flex align-items-center me-2">
                <span className="bullet bullet-primary me-50 cursor-pointer"></span>
                <span>sales</span>
              </div>
              {/* <div className='d-flex align-items-center'>
                <span className='bullet bullet-warning me-50 cursor-pointer'></span>
                <span>Expense</span>
              </div> */}
            </div>
          </div>
          <Chart
            id="revenue-report-chart"
            type="bar"
            height="230"
            options={revenueOptions}
            series={revenueSeries}
          />
        </Col>
        <Col className="budget-wrapper" md="4" xs="12">
          <UncontrolledButtonDropdown>
            <DropdownToggle
              className="budget-dropdown"
              outline
              color="primary"
              size="sm"
            >
              {2022}
            </DropdownToggle>
            <DropdownMenu>
              {/* {data.map((item) => ( */}
              <DropdownItem
                className="w-100"
                // key={item.years}
                key={2022}
                onClick={() => {
                  // setSelectedYear(item);
                }}
              >
                {/* {item.years} */}
                2022
              </DropdownItem>
              {/* ))} */}
            </DropdownMenu>
          </UncontrolledButtonDropdown>
          <h2 className="mb-25">${data.totalRevenu}</h2>
          <div className="d-flex justify-content-center">
            <span className="fw-bolder me-25">Travelers:</span>
            <span>{data.totalOrder}</span>
          </div>

          {/* <Chart
            id="budget-chart"
            type="line"
            height="80"
            options={budgetOptions}
            series={budgetSeries}
          /> */}
          {/* <Button color="primary">Check Finance</Button> */}
        </Col>
      </Row>
    </Card>
  ) : null;
};

export default SalesReport;
