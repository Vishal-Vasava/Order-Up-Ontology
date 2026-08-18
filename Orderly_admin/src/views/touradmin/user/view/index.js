// ** React Imports
import React, { useEffect, useState } from "react";
import { useParams, Link, useLocation } from "react-router-dom";

// ** Store & Actions
import { getUser } from "../store";
import { useSelector, useDispatch } from "react-redux";

// ** Reactstrap Imports
import { Row, Col, Alert } from "reactstrap";

// ** User View Components
import UserTabs from "./Tabs";
import PlanCard from "./PlanCard";
import UserInfoCard from "./UserInfoCard";
import UserInfoCardDetails from "./UserInfoCardDetails";

// ** Styles
import "@styles/react/apps/app-users.scss";
import UsersList from "../list";
import UserTimeline from "./UserTimeline";
import UpdateUserDiscount from "./UpdateUserDiscount";

const UserView = (props) => {
  // ** Store Vars
  // const store = useSelector(state => state.users)
  const dispatch = useDispatch();
  const user = useSelector((state) => state.user.userData);

  console.log("user ", user);
  // ** Hooks
  const { id } = useParams();
  const location = useLocation();

  const [scanResponse, setScanResponse] = useState();
  const [isFromScan, setIsFromScan] = useState(false);
  const [salesDescription, setSalesDescription] = useState("");

  const [sales, setSales] = useState("");
  const [transactionID, setTransactionID] = useState("");
  const [amount, setAmount] = useState("");

  // ** Get suer on mount
  useEffect(() => {
    dispatch(getUser(parseInt(id)));
  }, [dispatch]);
  console.log("isFromScan", isFromScan);
  useEffect(() => {
    setScanResponse(location.state.resultData);
    setIsFromScan(location.state.isFromScan);
    if (location.state && location.state.amount) {
      setAmount(location.state.amount);

      // alert("amount found " + location.state.amount);
    }

    if (location.state && location.state.sales) {
      setSales(location.state.sales);
    }
    if (location.state && location.state.sales_description) {
      setSalesDescription(location.state.sales_description);
    }
    if (location.state && location.state.transaction_id) {
      setTransactionID(location.state.transaction_id);
    }
  }, [location.state.resultData]);

  const [active, setActive] = useState("1");

  const toggleTab = (tab) => {
    if (active !== tab) {
      setActive(tab);
    }
  };

  return (
    <div className="app-user-view">
      <Row>
        <Col xl="6" lg="6" xs={{ order: 1 }} md={{ order: 0, size: 6 }}>
          {scanResponse && <UserInfoCard selectedUser={scanResponse} />}

          {/* {scanResponse && <PlanCard selectedUser={scanResponse} />} */}
        </Col>
        <Col xl="6" lg="6" xs={{ order: 0 }} md={{ order: 1, size: 6 }}>
          {/* <UsersList selectedUser={scanResponse} /> */}

          {/* <p>is From Scanned screen ? : {isFromScan ? "Yes " : "NO bhai"} </p> */}
          {scanResponse && (
            <UpdateUserDiscount
              selectedUser={scanResponse}
              isFromScan={isFromScan}
              amount={amount}
              sales_description={salesDescription}
              sales={sales}
              transaction_id={transactionID}
            />
          )}

          {/* {scanResponse && <UserInfoCardDetails selectedUser={scanResponse} />} */}
        </Col>
      </Row>
      <Row>
        {user.role === "superadmin" ? (
          <UserTimeline selectedUser={scanResponse} />
        ) : (
          <div />
        )}
      </Row>
    </div>
  );
};
export default UserView;
