import React from "react";
import { Mail, Home, Users, User } from "react-feather";

export default [
  {
    id: "home",
    title: "Home",

    icon: <Home size={20} />,
    navLink: "/home",
  },
  {
    id: "order-listing",
    title: "Reservations Listing",
    icon: <Mail size={20} />,
    navLink: "/order-listing",
  },
  {
    id: "create-guide",
    title: "Create Tour Guide",
    icon: <User size={20} />,
    navLink: `/create-guide`,
  },
  {
    id: "Product-listing",
    title: "Product-listing",
    icon: <Mail size={20} />,
    navLink: "/product-listing",
  },

  {
    id: "menuItem-management",
    title: "Menu",
    icon: <Mail size={20} />,
    navLink: "/menu-item-manage",
  },
  {
    id: "my-store",
    title: "My Store",
    icon: <Mail size={20} />,
    navLink: "/my-store",
  },
  {
    id: "customers-listing",
    title: "Customers Listing",
    icon: <Users size={20} />,
    navLink: "/customers-listing",
  },

  {
    id: "vendors",
    title: "Vendors",
    icon: <Mail size={20} />,
    navLink: "/vendors",
  },
];
