// ** React Imports
import { Navigate } from "react-router-dom";
import React, { useContext, Suspense } from "react";

// ** Context Imports
import { AbilityContext } from "@src/utility/context/Can";
import { useSelector } from "react-redux";
// import { User } from "react-feather";

const PrivateRoute = ({ children, route }) => {
  // ** Hooks & Vars
  const ability = useContext(AbilityContext);
  const user = JSON.parse(localStorage.getItem("userData"));
  const userData = useSelector((state) => state.user.userData);

  if (route) {
    let action = null;
    let resource = null;
    let restrictedRoute = false;

    if (route.meta) {
      action = route.meta.action;
      resource = route.meta.resource;
      restrictedRoute = route.meta.restricted;
    }

    if (!userData || !user) {
      return <Navigate to="/login" />;
    }
    if (userData && user && restrictedRoute) {
      return <Navigate to="admin/" />;
    }
    if (userData && user && restrictedRoute && user.role === "client") {
      return <Navigate to="/access-control" />;
    }
    if (userData && user && !ability.can(action || "read", resource)) {
      return <Navigate to="/misc/not-authorized" replace />;
    }
  }

  return <Suspense fallback={null}>{children}</Suspense>;
};

export default PrivateRoute;
