// ** React Imports
import { Outlet, useNavigate } from "react-router-dom";
import { useEffect, useState } from "react";

// ** Custom Hooks
import { useSkin } from "@hooks/useSkin";

// ** Third Party Components
import classnames from "classnames";
import { useSelector } from "react-redux";

const BlankLayout = () => {
  // ** States
  const [isMounted, setIsMounted] = useState(false);

  // ** Hooks
  const { skin } = useSkin();

  const userData = useSelector((state) => state.user.userData);
  const navigate = useNavigate();

  useEffect(() => {
    if (!userData && !window.location.href.endsWith("/login")) {
      // navigate(`${process.env.REACT_APP_FOLDER}/login`);
    }

    setIsMounted(true);
    return () => setIsMounted(false);
  }, []);

  if (!isMounted) {
    return null;
  }

  return (
    <div
      className={classnames("blank-page", {
        "dark-layout": skin === "dark",
      })}
    >
      <div className="app-content content">
        <div className="content-wrapper">
          <div className="content-body">
            <Outlet />
          </div>
        </div>
      </div>
    </div>
  );
};

export default BlankLayout;
