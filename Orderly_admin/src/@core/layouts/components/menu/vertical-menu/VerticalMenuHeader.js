// ** React Imports
import React, { useEffect } from "react";
import { NavLink } from "react-router-dom";

// ** Icons Imports
import { Disc, X, Circle } from "react-feather";

// ** Config
import themeConfig from "@configs/themeConfig";

// ** Utils
import { getUserData, getHomeRouteForLoggedInUser } from "@utils";
import exploredark from "../../../../../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import explorelight from "../../../../../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import orderlylight from "../../../../../assets/images/Ordely-Ecommerce Logo/Ordely-Ecommerce_Blue Logo.jpg";
import orderlyDark from "../../../../../assets/images/Ordely-Ecommerce Logo/Ordely-Ecommerce_Blue BG Logo.jpg";


import logodark from "../../../../../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import { useSelector } from "react-redux";
const VerticalMenuHeader = (props) => {
  // ** Props
  const {
    menuCollapsed,
    setMenuCollapsed,
    setMenuVisibility,
    setGroupOpen,
    menuHover,
  } = props;

  // ** Vars
  const user = getUserData();
  const skin = useSelector((state) => state.layout.skin);
  // ** Reset open group
  useEffect(() => {
    if (!menuHover && menuCollapsed) setGroupOpen([]);
  }, [menuHover, menuCollapsed]);

  // ** Menu toggler component
  const Toggler = () => {
    if (!menuCollapsed) {
      return (
        <Disc
          size={20}
          data-tour="toggle-icon"
          className="text-primary toggle-icon d-none d-xl-block"
          onClick={() => setMenuCollapsed(true)}
        />
      );
    } else {
      return (
        <Circle
          size={20}
          data-tour="toggle-icon"
          className="text-primary toggle-icon d-none d-xl-block"
          onClick={() => setMenuCollapsed(false)}
        />
      );
    }
  };

  return (
    <div className="navbar-header pl-1">
      <ul className="nav navbar-nav flex-row">
        <li className="nav-item me-auto">
          <NavLink
            to={user ? getHomeRouteForLoggedInUser(user.role) : "/"}
            className="navbar-brand"
          >
            <div
              style={{
                flexDirection: "row",
                display: "flex",
                marginTop: "2px",
                justifyContent: "center",
                alignItems: "center",
                height: "25px",
              }}
            >
              <img
                alt=""
                src={skin !== "light" ? orderlyDark : orderlylight}
                style={{  objectFit:"cover", height:"30px", width:"150px"}}
                width="90"
                // height="58"
                className="d-inline-block  mr-2"
              />
              {/* <p
                style={{
                  height: 43,
                  width: 2,
                  marginLeft: 3,
                  marginRight:2,
                  backgroundColor: "black",
                }}
              /> */}
              {/* <img
                alt=""
                src={logodark}
                width="138"
                style={{ objectFit: "contain" }}
                // height="156"
                className="d-inline-block  mr-2"
              /> */}
            </div>
            {/* <span className="brand-logo1" style={{ height: "100px", fontSize: "29px", color: "#343434", fontFamily: "Courgette" }}>
              <img
                alt=""
                src={logo}
                width="38"
                height="38"
                className="d-inline-block align-top mr-2"
              />{" "}
              
            </span> */}

            {/* <h2 className="brand-text mb-0"></h2> */}
          </NavLink>
        </li>
        <li className="nav-item nav-toggle">
          <div className="nav-link modern-nav-toggle cursor-pointer">
            <Toggler />
            <X
              onClick={() => setMenuVisibility(false)}
              className="toggle-icon icon-x d-block d-xl-none"
              size={20}
            />
          </div>
        </li>
      </ul>
    </div>
  );
};

export default VerticalMenuHeader;
