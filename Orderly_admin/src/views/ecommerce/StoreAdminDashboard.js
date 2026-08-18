// ** React Imports
import React, { useContext, useEffect } from "react";
// ** Reactstrap Imports
import { Row, Col } from "reactstrap";

// ** Context
import { ThemeColors } from "@src/utility/context/ThemeColors";

// ** Demo Components
import CompanyTable from "./CompanyTable";
import Earnings from "@src/views/ui-elements/cards/analytics/Earnings";
import CardMedal from "@src/views/ui-elements/cards/advance/CardMedal";
import SupplyStatsCard from "@src/views/ui-elements/cards/statistics/SupplyStatsCard";

import CardMeetup from "@src/views/ui-elements/cards/advance/CardMeetup";
import StatsCardStore from "@src/views/ui-elements/cards/statistics/StatsCardStore";
import GoalOverview from "@src/views/ui-elements/cards/analytics/GoalOverview";
import RevenueReport from "@src/views/ui-elements/cards/analytics/RevenueReport";
import SalesReport from "@src/views/ui-elements/cards/analytics/SalesReport";
import OrdersBarChart from "@src/views/ui-elements/cards/statistics/OrdersBarChart";
import CardTransactions from "@src/views/ui-elements/cards/advance/CardTransactions";
import ProfitLineChart from "@src/views/ui-elements/cards/statistics/ProfitLineChart";
import CardBrowserStates from "@src/views/ui-elements/cards/advance/CardBrowserState";

// ** Styles
import "@styles/react/libs/charts/apex-charts.scss";
import "@styles/base/pages/dashboard-ecommerce.scss";
import { useSelector, useDispatch } from "react-redux";
import { fetchDashboardData } from "../../redux/statisticSlice";
import { useNavigate } from "react-router-dom";
const StoreAdminDashboard = () => {
  // ** Context
  const userData = useSelector((state) => state.user.userData);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const { colors } = useContext(ThemeColors);
  useEffect(() => {
    dispatch(fetchDashboardData())
      .unwrap()
      .then((e) => {
        if (e.error === 401) {
          navigate("/admin/login");
          dispatch({ type: "ON_SET_USER", payload: undefined });
          dispatch({ type: "ON_SET_TOKEN", payload: undefined });
          localStorage.setItem("token", undefined);
          localStorage.setItem("userData", undefined);
        }
      });
  }, []);

  // ** vars
  const trackBgColor = "#e9ecef";

  return (
    <div id="dashboard-ecommerce">
      <Row className="match-height">
        <Col xl="4" md="6" xs="12">
          <CardMedal />
        </Col>
        <Col xl="8" md="6" xs="12">
          <SupplyStatsCard cols={{ xl: "3", sm: "6" }} />
        </Col>
      </Row>
      <Row className="match-height">
        <Col lg="4" md="12">
          <Row className="match-height">
            <Col lg="12" md="6" xs="12">
              <ProfitLineChart info={colors.info.main} />
            </Col>
          </Row>
        </Col>
        <Col lg="8" md="12">
          <RevenueReport
            primary={colors.primary.main}
            warning={colors.warning.main}
          />
        </Col>
        <Col lg="12" md="12">
          <SalesReport
            primary={colors.primary.main}
            warning={colors.warning.main}
          />
        </Col>
      </Row>
      <Row className="match-height">
        {/* <Col lg="12" xs="12">
      <CompanyTable />
    </Col> */}
        {/* <Col lg="4" md="6" xs="12">
      <CardMeetup />
    </Col> */}
        {/* <Col lg="4" md="6" xs="12">
      <CardBrowserStates colors={colors} trackBgColor={trackBgColor} />
    </Col> */}
        {/* <Col lg="4" md="6" xs="12">
      <GoalOverview success={colors.success.main} />
    </Col>
    <Col lg="4" md="6" xs="12">
      <CardTransactions />
    </Col> */}
      </Row>
    </div>
  );
};

export default StoreAdminDashboard;
