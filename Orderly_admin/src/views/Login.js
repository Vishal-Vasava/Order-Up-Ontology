import { useSkin } from "@hooks/useSkin";
import { Link, useNavigate } from "react-router-dom";
import { Facebook, Twitter, Mail, GitHub } from "react-feather";
import InputPasswordToggle from "@components/input-password-toggle";
import axios from "axios";

import {
  Row,
  Col,
  CardTitle,
  CardText,
  Form,
  Label,
  Input,
  Button,
} from "reactstrap";
import "@styles/react/pages/page-authentication.scss";
import React, { useState } from "react";
import { userData } from "../redux/navbar";
import { useDispatch, useSelector } from "react-redux";
import toast from "react-hot-toast";
import { clearDashboardData } from "../redux/statisticSlice";
import exploredark from "../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import explorelight from "../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
import logodark1 from "../assets/images/ico/authentication.svg";
import orderlyDark from "../assets/images/Ordely-Ecommerce Logo/Ordely-Ecommerce_Blue BG Logo.jpg";
import ordelyLight from "../assets/images/Ordely-Ecommerce Logo/Ordely-Ecommerce_Blue Logo.jpg";

import logodark from "../assets/images/ico/Ordely-Ecommerce_Green Icon.png";
const Login = () => {
  const skin1 = useSelector((state) => state.layout.skin);
  const { skin } = useSkin();
  const [email, setEmail] = useState(" ");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();
  const dispatch = useDispatch();

  const illustration = skin === "dark" ? "login-v2-dark.svg" : "login-v2.svg",
    source = require(`@src/assets/images/pages/${illustration}`).default;

  const log = () => {
    let emailParam = email.trim().toLowerCase();
    emailParam = email;
    axios
      .post("/admin/login", {
        email: emailParam,
        password: password,
      })
      .then((response) => {
        // console.log("res", response);
        // console.log(response.data.token);
        console.log("response", response.data.data.data.user);
        let userinfo = response.data.data.data.user;
        let userdata = {
          role: userinfo.user_type,
          name: userinfo.first_name,
        };
        // showSuccess(response.data.data)
        dispatch(clearDashboardData());
        if (userdata.role === "staff") {
          navigate(`${process.env.REACT_APP_FOLDER}/scanqrcode`);
        } else {
          navigate(`${process.env.REACT_APP_FOLDER}/home`);
        }
        console.log("loginobj", response.data.data.logo);
        dispatch({ type: "ON_SET_USER", payload: userdata });
        dispatch({
          type: "ON_SET_LOGO",
          payload:
            "https://st4.depositphotos.com/20435048/23412/v/1600/depositphotos_234121624-stock-illustration-online-shop-logo-design-vector.jpg",
        });

        localStorage.setItem(
          "token",
          response.data.data.data.tokens.access_token
        );
        // localStorage.setItem('login', JSON.stringify(response.data.data))
        localStorage.setItem("userData", JSON.stringify(response.data.data));
        toast.success("Login successfully");
      })
      .catch((err) => {
        // console.log(err.response.data.message);
        console.log(err);
        if (
          err &&
          err.response &&
          err.response.data &&
          err.response.data.message
        ) {
          toast.error(err.response.data.message);
        } else {
          toast.error("Something is wrong! Please try again later.");
        }

        // alert(err.response.data.message);
      });
  };

  return (
    <div className="auth-wrapper auth-cover">
      <Row className="auth-inner m-0">
        <Link
          className="brand-logo"
          to={`${process.env.REACT_APP_FOLDER}/`}
          // onClick={(e) => e.preventDefault()}
        >
          {/* <svg viewBox="0 0 139 95" version="1.1" height="28">
            <defs>
              <linearGradient
                x1="100%"
                y1="10.5120544%"
                x2="50%"
                y2="89.4879456%"
                id="linearGradient-1"
              >
                <stop stopColor="#000000" offset="0%"></stop>
                <stop stopColor="#FFFFFF" offset="100%"></stop>
              </linearGradient>
              <linearGradient
                x1="64.0437835%"
                y1="46.3276743%"
                x2="37.373316%"
                y2="100%"
                id="linearGradient-2"
              >
                <stop stopColor="#EEEEEE" stopOpacity="0" offset="0%"></stop>
                <stop stopColor="#FFFFFF" offset="100%"></stop>
              </linearGradient>
            </defs>
            <g
              id="Page-1"
              stroke="none"
              strokeWidth="1"
              fill="none"
              fillRule="evenodd"
            >
              <g id="Artboard" transform="translate(-400.000000, -178.000000)">
                <g id="Group" transform="translate(400.000000, 178.000000)">
                  <path
                    d="M-5.68434189e-14,2.84217094e-14 L39.1816085,2.84217094e-14 L69.3453773,32.2519224 L101.428699,2.84217094e-14 L138.784583,2.84217094e-14 L138.784199,29.8015838 C137.958931,37.3510206 135.784352,42.5567762 132.260463,45.4188507 C128.736573,48.2809251 112.33867,64.5239941 83.0667527,94.1480575 L56.2750821,94.1480575 L6.71554594,44.4188507 C2.46876683,39.9813776 0.345377275,35.1089553 0.345377275,29.8015838 C0.345377275,24.4942122 0.230251516,14.560351 -5.68434189e-14,2.84217094e-14 Z"
                    id="Path"
                    className="text-primary"
                    style={{ fill: "currentColor" }}
                  ></path>
                  <path
                    d="M69.3453773,32.2519224 L101.428699,1.42108547e-14 L138.784583,1.42108547e-14 L138.784199,29.8015838 C137.958931,37.3510206 135.784352,42.5567762 132.260463,45.4188507 C128.736573,48.2809251 112.33867,64.5239941 83.0667527,94.1480575 L56.2750821,94.1480575 L32.8435758,70.5039241 L69.3453773,32.2519224 Z"
                    id="Path"
                    fill="url(#linearGradient-1)"
                    opacity="0.2"
                  ></path>
                  <polygon
                    id="Path-2"
                    fill="#000000"
                    opacity="0.049999997"
                    points="69.3922914 32.4202615 32.8435758 70.5039241 54.0490008 16.1851325"
                  ></polygon>
                  <polygon
                    id="Path-2"
                    fill="#000000"
                    opacity="0.099999994"
                    points="69.3922914 32.4202615 32.8435758 70.5039241 58.3683556 20.7402338"
                  ></polygon>
                  <polygon
                    id="Path-3"
                    fill="url(#linearGradient-2)"
                    opacity="0.099999994"
                    points="101.428699 0 83.0667527 94.1480575 130.378721 47.0740288"
                  ></polygon>
                </g>
              </g>
            </g>
          </svg> */}
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
            {/* <img
              alt=""
              src={skin1 === "light" ? exploredark : explorelight}
              style={{ objectFit: "contain" }}
              width="92"
              // height="58"
              className="d-inline-block align-top mr-2"
            /> */}
            {/* <p
              style={{
                height: 65,
                width: 2,
                marginLeft: 3,
                backgroundColor: "black",
              }}
            />
            <img
              alt=""
              src={logodark}
              width="140"
              style={{ objectFit: "contain" }}
              // height="156"
              className="d-inline-block align-top mr-2"
            /> */}
          </div>
          <h2 className="brand-text text-primary ms-1"></h2>
        </Link>
        <Col className="d-none d-lg-flex " lg="8" sm="12">
          <div className="w-100 d-lg-flex  justify-content-center">
            <img
              // className="img-fluid"
              style={{ objectFit: "cover", height: "100vh", width: "100%" }}
              src={orderlyDark}
              alt="Login Cover"
            />
          </div>
        </Col>
        <Col
          className="d-flex align-items-center auth-bg px-2 p-lg-5"
          lg="4"
          sm="12"
        >
          <Col className="px-xl-2 mx-auto" sm="8" md="6" lg="12">
            <CardTitle tag="h2" className="fw-bold mb-1">
              Admin Sign in
            </CardTitle>
            {/* <CardText className="mb-2">
              Please sign-in to your account and start the adventure
            </CardText> */}
            <Form
              className="auth-login-form mt-2"
              onSubmit={(e) => e.preventDefault()}
            >
              <div className="mb-1">
                <Label className="form-label" for="login-email">
                  Email
                </Label>
                <Input
                  type="email"
                  id="login-email"
                  placeholder="john@example.com"
                  autoFocus
                  onChange={(e) => setEmail(e.target.value)}
                />
              </div>
              <div className="mb-1">
                <div className="d-flex justify-content-between">
                  <Label className="form-label" for="login-password">
                    Password
                  </Label>
                  <Link to={`${process.env.REACT_APP_FOLDER}/forgot-password`}>
                    <small>Forgot Password?</small>
                  </Link>
                </div>
                <InputPasswordToggle
                  className="input-group-merge"
                  id="login-password"
                  onChange={(e) => setPassword(e.target.value)}
                />
              </div>
              <div className="form-check mb-1">
                <Input type="checkbox" id="remember-me" />
                <Label className="form-check-label" for="remember-me">
                  Remember Me
                </Label>
              </div>
              <Button to="/" color="primary" block onClick={log}>
                Sign in
              </Button>
            </Form>
            {/* <p className="text-center mt-2">
              <span className="me-25">New on our platform?</span>
              <Link to={`${process.env.REACT_APP_FOLDER}/register`}>
                <span>Create an account</span>
              </Link>
            </p>
            <div className="divider my-2">
              <div className="divider-text">or</div>
            </div>
            <div className="auth-footer-btn d-flex justify-content-center">
              <Button color="facebook">
                <Facebook size={14} />
              </Button>
              <Button color="twitter">
                <Twitter size={14} />
              </Button>
              <Button color="google">
                <Mail size={14} />
              </Button>
              <Button className="me-0" color="github">
                <GitHub size={14} />
              </Button>
            </div> */}
          </Col>
        </Col>
      </Row>
    </div>
  );
};

export default Login;
