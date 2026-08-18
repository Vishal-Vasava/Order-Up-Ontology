// ** React Imports
import React, { useEffect, useState } from "react";

// ** Third Party Components
import axios from "axios";

// ** Custom Components
import TinyChartStats from "@components/widgets/stats/TinyChartStats";

const OrdersBarChart = ({ warning }) => {
  // ** State
  const [data, setData] = useState();
  const token = localStorage.getItem("token");

  let tempData = {
    title: "Orders",
    stats: "0",
    series: [
      {
        data: [],
      },
    ],
  };

  useEffect(() => {
    axios
      .get("/supplier/oneweekorederdetailscount", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        tempData.series[0].data = response.data.orderCount;
        tempData.stats = response.data.totalOrder;
        setData(tempData);
      })
      .catch((err) => {
        console.log(err);
      });
    console.log("tempData", tempData);
    console.log("Data", data);
  }, []);

  const options = {
    chart: {
      stacked: true,
      toolbar: {
        show: false,
      },
    },
    grid: {
      show: false,
      padding: {
        left: 0,
        right: 0,
        top: -15,
        bottom: -15,
      },
    },
    plotOptions: {
      bar: {
        horizontal: false,
        columnWidth: "20%",
        borderRadius: [0, 5],
        colors: {
          backgroundBarColors: [
            "#f3f3f3",
            "#f3f3f3",
            "#f3f3f3",
            "#f3f3f3",
            "#f3f3f3",
          ],
          backgroundBarRadius: 5,
        },
      },
    },
    legend: {
      show: false,
    },
    dataLabels: {
      enabled: false,
    },
    colors: [warning],
    xaxis: {
      labels: {
        show: false,
      },
      axisBorder: {
        show: false,
      },
      axisTicks: {
        show: false,
      },
    },
    yaxis: {
      show: false,
    },
    tooltip: {
      x: {
        show: false,
      },
    },
  };

  return data ? (
    <TinyChartStats
      height={70}
      type="bar"
      options={options}
      title={data.title}
      stats={data.stats}
      series={data.series}
    />
  ) : null;
};

export default OrdersBarChart;
