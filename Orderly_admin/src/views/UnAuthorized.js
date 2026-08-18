// ** React Imports
import { Link } from "react-router-dom";

// ** Reactstrap Imports
import { Button } from "reactstrap";

// ** Custom Hooks
import { useSkin } from "@hooks/useSkin";

// ** Utils
import {} from "@utils";

// ** Styles
import "@styles/base/pages/page-misc.scss";
import logo from "../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import React from "react";

const NotAuthorized = () => {
  // ** Hooks
  const { skin } = useSkin();

  const illustration =
      skin === "dark" ? "not-authorized-dark.svg" : "not-authorized.svg",
    source = require(`@src/assets/images/pages/${illustration}`).default;
  return (
    <div className="misc-wrapper">
      <Link className="brand-logo" to={`${process.env.REACT_APP_FOLDER}/`}>
        <img src={logo} style={{ height: "50px" }} />
      </Link>
      <div className="misc-inner p-2 p-sm-3">
        <div className="w-100 text-center">
          <h2 className="mb-1">Invalid link 🔐</h2>
          <p className="mb-2">
            This is invalid link to reset password. please request again for
            reset password
          </p>
          <Button
            tag={Link}
            color="primary"
            className="btn-sm-block mb-1"
            to={"/"}
          >
            Back to Home
          </Button>
          <img
            className="img-fluid"
            src="https://pixinvent.com/demo/vuexy-react-admin-dashboard-template/demo-1/assets/error.b1bdbbbe.svg"
            alt="Not authorized page"
          />
        </div>
      </div>
    </div>
  );
};
export default NotAuthorized;
