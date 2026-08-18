// ** React Imports
import React, {  } from "react";

// ** Reactstrap Imports
 
// ** Context
  

// ** Styles
import "@styles/react/libs/charts/apex-charts.scss";
import "@styles/base/pages/dashboard-ecommerce.scss";
import { useSelector } from "react-redux";
import SuperAdminDashboard from "./SuperAdminDashboard";
import StoreAdminDashboard from "./StoreAdminDashboard";

const EcommerceDashboard = () => {
  // ** Context
  const userData = useSelector((state) => state.user.userData);  
  return (userData && (userData.role === "superadmin" || userData.role === "admin" || userData.role === "3" || userData.role === 3) ? <SuperAdminDashboard/> :  <StoreAdminDashboard/>); 
};

export default EcommerceDashboard;
