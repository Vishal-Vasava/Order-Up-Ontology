// ** React Imports
import { Navigate, useNavigate } from "react-router-dom";
import React, { Fragment, lazy, useEffect } from "react";
// ** Layouts
import BlankLayout from "@layouts/BlankLayout";
import VerticalLayout from "@src/layouts/VerticalLayout";
import HorizontalLayout from "@src/layouts/HorizontalLayout";
import LayoutWrapper from "@src/@core/layouts/components/layout-wrapper";

// ** Route Components
import PublicRoute from "@components/routes/PublicRoute";

// ** Utils
import { isObjEmpty } from "@utils";

import Calendar from "../../views/components/calendar";
import UserView from "../../views/touradmin/user/view";
import ComponentSpinner from "../../@core/components/spinner/Loading-spinner";
import ViewOrders from "../../views/store/supplier/ViewOrders";
const getLayout = {
  blank: <BlankLayout />,
  vertical: <VerticalLayout />,
  horizontal: <HorizontalLayout />,
};

// ** Document title
const TemplateTitle = "%s - Vuexy React Admin Template";

// ** Default Route
const DefaultRoute = "/admin/home";

const OrderListing = lazy(() => import("../../views/store/order/OrderListing"));

const CustomerListing = lazy(() =>
  import("../../views/store/Customers/CustomerListing")
);

const Login = lazy(() => import("../../views/Login"));

const Error = lazy(() => import("../../views/Error"));
const UnAuthorized = lazy(() => import("../../views/UnAuthorized"));
const DashboardEcommerce = lazy(() => import("../../views/ecommerce"));

const SupplierListing = lazy(() =>
  import("../../views/store/supplier/Listing")
);
const FAQ = lazy(() => import("../../views/store/FAQ/Listing"));
const Notification = lazy(() =>
  import("../../views/store/Notification/Listing")
);

const ProductListing = lazy(() => import("../../views/store/products/Listing"));
const PlatformStores = lazy(() => import("../../views/platform/PlatformManagement").then(module => ({ default: module.Stores })));
const PlatformDeliveryAgents = lazy(() => import("../../views/platform/PlatformManagement").then(module => ({ default: module.DeliveryAgents })));
const PlatformProducts = lazy(() => import("../../views/platform/PlatformManagement").then(module => ({ default: module.Products })));
const GalleryListing = lazy(() => import("../../views/store/gallery/Listing"));
const BannerListing = lazy(() => import("../../views/store/banner/Listing"));

let rootFolder = "/admin";
// ** Merge Routes
const Routes = [
  {
    path: `${rootFolder}/`,
    index: true,
    element: <Navigate replace to={DefaultRoute} />,
  },
  {
    path: `${rootFolder}/home`,
    element: <DashboardEcommerce />,
  },

  {
    path: `${rootFolder}/customers-listing`,
    element: <CustomerListing />,
  },

  {
    element: <Calendar />,
    path: "/apps/calendar",
  },

  {
    element: <UserView />,

    path: `${rootFolder}/apps/user/view/:id`,
  },
  ,
  {
    path: `${rootFolder}/supplier-listing`,
    element: <PlatformStores />,
  },
  {
    path: `${rootFolder}/delivery-agents`,
    element: <PlatformDeliveryAgents />,
  },
  {
    path: `${rootFolder}/faq-listing`,
    element: <FAQ />,
  },
  {
    path: `${rootFolder}/notifications`,
    element: <Notification />,
  },
  {
    path: `${rootFolder}/products`,
    element: <PlatformProducts />,
  },
  {
    path: `${rootFolder}/view-orders/:id`,
    element: <ViewOrders />,
  },
  {
    path: `${rootFolder}/orders`,
    element: <OrderListing />,
  },
  {
    path: `${rootFolder}/gallery`,
    element: <GalleryListing />,
  },
  {
    path: `${rootFolder}/banners`,
    element: <BannerListing />,
  },

  {
    path: `${rootFolder}/login`,
    element: <Login />,
    // jeta:{
    // }
    meta: {
      layout: "blank",
    },
  },

  {
    path: `${rootFolder}/spinner`,
    element: <ComponentSpinner />,
    meta: {
      layout: "blank",
    },
  },
  {
    path: `${rootFolder}/error`,
    element: <Error />,
    meta: {
      layout: "blank",
    },
  },
  {
    path: `${rootFolder}/unauthorize`,
    element: <UnAuthorized />,
    meta: {
      layout: "blank",
    },
  },
];

const getRouteMeta = (route) => {
  if (isObjEmpty(route.element.props)) {
    if (route.meta) {
      return { routeMeta: route.meta };
    } else {
      return {};
    }
  }
};

// ** Return Filtered Array of Routes & Paths
const MergeLayoutRoutes = (layout, defaultLayout) => {
  const LayoutRoutes = [];

  if (Routes) {
    Routes.filter((route) => {
      let isBlank = false;
      // ** Checks if Route layout or Default layout matches current layout
      if (
        (route.meta && route.meta.layout && route.meta.layout === layout) ||
        ((route.meta === undefined || route.meta.layout === undefined) &&
          defaultLayout === layout)
      ) {
        const RouteTag = PublicRoute;

        // ** Check for public or private route
        if (route.meta) {
          route.meta.layout === "blank" ? (isBlank = true) : (isBlank = false);
        }
        if (route.element) {
          const Wrapper =
            // eslint-disable-next-line multiline-ternary
            isObjEmpty(route.element.props) && isBlank === false
              ? // eslint-disable-next-line multiline-ternary
                LayoutWrapper
              : Fragment;

          route.element = (
            <Wrapper {...(isBlank === false ? getRouteMeta(route) : {})}>
              <RouteTag route={route}>{route.element}</RouteTag>
            </Wrapper>
          );
        }

        // Push route to LayoutRoutes
        LayoutRoutes.push(route);
      }
      return LayoutRoutes;
    });
  }
  return LayoutRoutes;
};

const getRoutes = (layout) => {
  const defaultLayout = layout || "vertical";
  const layouts = ["vertical", "horizontal", "blank"];

  const AllRoutes = [];

  layouts.forEach((layoutItem) => {
    const LayoutRoutes = MergeLayoutRoutes(layoutItem, defaultLayout);

    AllRoutes.push({
      path: "/",
      element: getLayout[layoutItem] || getLayout[defaultLayout],
      children: LayoutRoutes,
    });
  });
  return AllRoutes;
};

export { DefaultRoute, TemplateTitle, Routes, getRoutes };
