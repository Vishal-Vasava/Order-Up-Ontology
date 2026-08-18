// ** React Imports
import React from "react";

import { Link, useNavigate } from "react-router-dom";

// ** Custom Components
import Avatar from "@components/avatar";

// ** Third Party Components
import {
  User,
  Mail,
  CheckSquare,
  MessageSquare,
  Settings,
  CreditCard,
  HelpCircle,
  Power,
} from "react-feather";

// ** Reactstrap Imports
import {
  UncontrolledDropdown,
  DropdownMenu,
  DropdownToggle,
  DropdownItem,
} from "reactstrap";

// ** Default Avatar Image
import defaultAvatar from "@src/assets/images/portrait/small/avatar-s-11.jpg";
import { useSelector } from "react-redux";
import { useDispatch } from "react-redux";

const UserDropdown = () => {
  const user = useSelector((state) => state.user.userData);
  const logoImage = useSelector((state) => state.user.logo);
  const rootFolder = "/admin";

  console.log("userDataRedux", user);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  return (
    <UncontrolledDropdown tag="li" className="dropdown-user nav-item">
      <DropdownToggle
        href="/"
        tag="a"
        className="nav-link dropdown-user-link"
        onClick={(e) => e.preventDefault()}
      >
        <div className="user-nav d-sm-flex d-none">
          <span className="user-name fw-bold">
            {user
              ? user.first_name
                ? user.first_name + " " + user.last_name
                : user.name
              : "John Doe"}
          </span>
          <span className="user-status">{user ? user.role : ""}</span>
        </div>
        {console.log("logoImage", logoImage)}

        <Avatar
          img={logoImage && logoImage ? logoImage : defaultAvatar}
          imgHeight="40"
          imgWidth="40"
          status="online"
        />
      </DropdownToggle>
      <DropdownMenu end>
        {user.role === "supplier" && (
          <DropdownItem
            tag={Link}
            to={`${rootFolder}/supplier-detail/${user.id}`}
          >
            <User size={14} className="me-75" />
            <span className="align-middle">Profile</span>
          </DropdownItem>
        )}
        {/* <DropdownItem tag={Link} to="/" onClick={(e) => e.preventDefault()}>
          <Mail size={14} className="me-75" />
          <span className="align-middle">Inbox</span>
        </DropdownItem>
        <DropdownItem tag={Link} to="/" onClick={(e) => e.preventDefault()}>
          <CheckSquare size={14} className="me-75" />
          <span className="align-middle">Tasks</span>
        </DropdownItem>
        <DropdownItem tag={Link} to="/" onClick={(e) => e.preventDefault()}>
          <MessageSquare size={14} className="me-75" />
          <span className="align-middle">Chats</span>
        </DropdownItem>
        <DropdownItem divider /> */}
        {/* <DropdownItem
          tag={Link}
          to="/pages/"
          onClick={(e) => e.preventDefault()}
        >
          <Settings size={14} className="me-75" />
          <span className="align-middle">Settings</span>
        </DropdownItem> */}
        {/* <DropdownItem tag={Link} to="/" onClick={(e) => e.preventDefault()}>
          <CreditCard size={14} className="me-75" />
          <span className="align-middle">Pricing</span>
        </DropdownItem> */}
        {/* <DropdownItem tag={Link} to="/" onClick={(e) => e.preventDefault()}>
          <HelpCircle size={14} className="me-75" />
          <span className="align-middle">FAQ</span>
        </DropdownItem> */}
        <DropdownItem
          tag={Link}
          to="/"
          onClick={(e) => {
            e.preventDefault();
            dispatch({ type: "ON_SET_USER", payload: undefined });
            dispatch({ type: "ON_SET_TOKEN", payload: undefined });
            localStorage.setItem("token", undefined);
            localStorage.setItem("userData", undefined);

            navigate(`${process.env.REACT_APP_FOLDER}/login`);
          }}
        >
          <Power size={14} className="me-75" />
          <span className="align-middle">Logout</span>
        </DropdownItem>
      </DropdownMenu>
    </UncontrolledDropdown>
  );
};

export default UserDropdown;
