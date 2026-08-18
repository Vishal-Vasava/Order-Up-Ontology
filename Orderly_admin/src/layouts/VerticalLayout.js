// ** React Imports
import React, { Component } from "react";

import { Outlet } from "react-router-dom";

// ** Core Layout Import
// !Do not remove the Layout import
import Layout from "@layouts/VerticalLayout";

// ** Menu Items Array
import navigation from "@src/navigation/vertical";
import {
  Home,
  Mail,
  Activity,
  UserPlus,
  Calendar,
  MapPin,
  Users,
  User,
  Flag,
  Send,
  ShoppingBag,
  Image,
  HelpCircle,
  Bell,
  Package,
  Menu,
  List,
} from "react-feather";
import { useSelector } from "react-redux";
import CollectionsIcon from "@mui/icons-material/Collections";
import { FileText, Circle, Square, UserCheck } from "react-feather";

const VerticalLayout = (props) => {
  const user = useSelector((state) => state.user.userData) || {};
  let rootFolder = "/admin";
  const touradminOptions = [
    {
      id: "home",
      title: "Home",
      icon: <Home size={20} />,
      navLink: `${rootFolder}/home`,
    },
    // {
    //   id: "order-listing",
    //   title: "Reservations",
    //   icon: <Calendar size={20} />,
    //   navLink: `${rootFolder}/order-listing`,
    // },
    // {
    //   id: "product-listing",
    //   title: "Tours",
    //   icon: <MapPin size={20} />,
    //   navLink: `${rootFolder}/product-listing`,
    // },

    {
      id: "create-guide",
      title: "Create Tour Guide",
      icon: <User size={20} />,
      navLink: `${rootFolder}/create-guide`,
    },
    // {
    //   id: "calendar",
    //   title: "Calendar",
    //   icon: <Calendar size={20} />,
    //   navLink: "/apps/calendar",
    // },
    {
      id: "scanqrcode",
      title: "Scan QR",
      icon: <Calendar size={20} />,
      navLink: `${rootFolder}/scanqrcode`,
    },
  ];

  const supplierOptions = [
    {
      id: "home",
      title: "Home",
      icon: <Home size={20} />,
      navLink: `${rootFolder}/home`,
    },

    {
      id: "scanqrcode",
      title: "Scan QR",
      icon: <Calendar size={20} />,
      navLink: "/admin/scanqrcode",
    },
    {
      id: "scan-data",
      title: "Scanned Customers",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/scan-data`,
    },

    {
      id: "staff",
      title: "Staff Management",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/staff`,
    },
    {
      id: "logo",
      title: "Logos",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/logo`,
    },
  ];

  const staffOptions = [
    {
      id: "scanqrcode",
      title: "Scan QR",
      icon: <Calendar size={20} />,
      navLink: "/admin/scanqrcode",
    },
    {
      id: "scan-data",
      title: "Scanned Customers",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/scan-data`,
    },
  ];

  const superadminOptions = [
    {
      id: "home",
      title: "Home",
      icon: <Home size={20} />,
      navLink: `${rootFolder}/home`,
    },
    // {
    //   id: "supplier-list",
    //   title: "Suppliers",
    //   icon: <ShoppingBag size={20} />,
    //   navLink: `${rootFolder}/supplier-list`,
    // },

    // {
    //   id: "product-listing",
    //   title: "Tours",
    //   icon: <MapPin size={20} />,
    //   navLink: `${rootFolder}/product-listing`,
    // },
    // {
    //   id: "activity-listing",
    //   title: "Activities",
    //   icon: <Activity size={20} />,
    //   navLink: `${rootFolder}/activity-listing`,
    // },
    {
      id: "supplier-listing",
      title: "Store Management",
      icon: <List size={20} />,
      navLink: `${rootFolder}/supplier-listing`,
    },
    {
      id: "products",
      title: "Products & Inventory",
      icon: <ShoppingBag size={20} />,
      navLink: `${rootFolder}/products`,
    },
    {
      id: "delivery-agents",
      title: "Delivery Agents",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/delivery-agents`,
    },
    {
      id: "orders",
      title: "Orders",
      icon: <Package size={20} />,
      navLink: `${rootFolder}/orders`,
    },
    {
      id: "gallery",
      title: "SKU Gallery",
      icon: <Image size={20} />,
      navLink: `${rootFolder}/gallery`,
    },
    {
      id: "Banners",
      title: "Banners",
      icon: <Image size={20} />,
      navLink: `${rootFolder}/banners`,
    },
    // {
    //   id: "calendar",
    //   title: "Calendar",
    //   icon: <Calendar size={20} />,
    //   navLink: "/apps/calendar",
    // },
    {
      id: "customers-listing",
      title: "Customers",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/customers-listing`,
    },
    // {
    //   id: "agent-listing",
    //   title: "Agents",
    //   icon: <Users size={20} />,
    //   navLink: `${rootFolder}/agent-listing`,
    // },
    // {
    //   id: "countries",
    //   title: "Countries",
    //   icon: <Flag size={20} />,
    //   navLink: `${rootFolder}/countries`,
    // },
    // {
    //   id: "flights",
    //   title: "Flights",
    //   icon: <Send size={20} />,
    //   navLink: `${rootFolder}/flights`,
    // },
    {
      id: "faq-listing",
      title: "FAQ",
      icon: <HelpCircle size={20} />,
      navLink: `${rootFolder}/faq-listing`,
    },
    {
      id: "notifications",
      title: "Notifications",
      icon: <Bell size={20} />,
      navLink: `${rootFolder}/notifications`,
    },
    // {
    //   id: "order-listing",
    //   title: "Reservations",
    //   icon: <Calendar size={20} />,
    //   navLink: `${rootFolder}/order-listing`,
    // },
  ];

  const guideOptions = [
    {
      id: "home",
      title: "Home",
      icon: <Home size={20} />,
      navLink: `${rootFolder}/home`,
    },
    {
      id: "order-listing",
      title: "Reservations",
      icon: <Calendar size={20} />,
      navLink: `${rootFolder}/order-listing`,
    },
    // {
    //   id: "product-listing",
    //   title: "Tours",
    //   icon: <MapPin size={20} />,
    //   navLink: `${rootFolder}/product-listing`,
    // },
    // {
    //   id: "calendar",
    //   title: "Calendar",
    //   icon: <Calendar size={20} />,
    //   navLink: "/apps/calendar",
    // },
  ];

  const agentOptions = [
    {
      id: "home",
      title: "Home",
      icon: <Home size={20} />,
      navLink: `${rootFolder}/home`,
    },
    // {
    //   id: 'order-listing',
    //   title: 'Reservations',
    //   icon: <Calendar size={20} />,
    //   navLink: `${rootFolder}/order-listing`,
    // },
    // {
    //   id: 'product-listing',
    //   title: 'Tours',
    //   icon: <MapPin size={20} />,
    //   navLink: `${rootFolder}/product-listing`,
    // },
    // {
    //   id: 'activity-listing',
    //   title: 'Activities',
    //   icon: <Activity size={20} />,
    //   navLink: `${rootFolder}/activity-listing`,
    // },
    // {
    //   id: 'calendar',
    //   title: 'Calendar',
    //   icon: <Calendar size={20} />,
    //   navLink: '/apps/calendar',
    // },
    {
      id: "customers-listing",
      title: "Customers",
      icon: <Users size={20} />,
      navLink: `${rootFolder}/customers-listing`,
    },
  ];

  // ** Icons Import

  return (
    <Layout
      menuData={
        user && (user.role === "admin" || user.role === "superadmin" || user.role === "3" || user.role === 3)
          ? superadminOptions
          : user.role === "touradmin"
          ? touradminOptions
          : user.role === "supplier"
          ? supplierOptions
          : user.role === "staff"
          ? staffOptions
          : user.role === "agent"
          ? agentOptions
          : guideOptions
      }
      {...props}
    >
      {/* <Layout menuData={abc}> */}

      <Outlet />
    </Layout>
  );
};

export default VerticalLayout;
