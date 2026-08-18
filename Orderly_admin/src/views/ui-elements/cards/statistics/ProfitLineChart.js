// ** React Imports
import React, { useEffect, useState } from "react";
import { useSelector } from "react-redux";

// ** Third Party Components
import axios from "axios";

// ** Custom Components
import TinyChartStats from "@components/widgets/stats/TinyChartStats";
import { nFormatter } from "./StatsCardStore";

const ProfitLineChart = ({ info }) => {
  // ** State
  const stateCnt = useSelector((state) => state.statistic.stististicsCounts);

  const [data, setData] = useState({
    title: "Last 7 Days Travelers",
    statistics: "0",
    series: [{ data: [] }],
  });

  const token = localStorage.getItem("token");

  const options = {
    chart: {
      toolbar: {
        show: false,
      },
      zoom: {
        enabled: false,
      },
    },
    grid: {
      borderColor: "#EBEBEB",
      strokeDashArray: 5,
      xaxis: {
        lines: {
          show: true,
        },
      },
      yaxis: {
        lines: {
          show: false,
        },
      },
      padding: {
        top: -30,
        bottom: -10,
      },
    },
    stroke: {
      width: 3,
    },
    colors: [info],
    series: [
      {
        data:
          stateCnt &&
          stateCnt.last7DayVisitor &&
          stateCnt.last7DayVisitor.visitorCount
            ? stateCnt.last7DayVisitor.visitorCount
            : [0, 0, 0, 0, 0, 0],
      },
    ],
    markers: {
      size: 2,
      colors: info,
      strokeColors: info,
      strokeWidth: 2,
      strokeOpacity: 1,
      strokeDashArray: 0,
      fillOpacity: 1,
      discrete: [
        {
          seriesIndex: 0,
          dataPointIndex: 5,
          fillColor: "#ffffff",
          strokeColor: info,
          size: 5,
        },
      ],
      shape: "circle",
      radius: 2,
      hover: {
        size: 3,
      },
    },
    xaxis: {
      labels: {
        show: true,
        style: {
          fontSize: "0px",
        },
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

  return data !== null ? (
    <TinyChartStats
      height={70}
      type="line"
      options={options}
      title={data.title}
      stats={nFormatter(
        stateCnt &&
          stateCnt.last7DayVisitor &&
          stateCnt.last7DayVisitor.totalVisitor
          ? stateCnt.last7DayVisitor.totalVisitor
          : "0"
      )}
      series={[
        {
          data:
            stateCnt &&
            stateCnt.last7DayVisitor &&
            stateCnt.last7DayVisitor.visitorCount
              ? stateCnt.last7DayVisitor.visitorCount
              : [0, 0, 0, 0, 0, 0],
        },
      ]}
    />
  ) : null;
};

export default ProfitLineChart;
