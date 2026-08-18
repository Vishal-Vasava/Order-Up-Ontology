// ** React Imports
import React, { Suspense, lazy } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Route, Routes } from "react-router-dom";

// ** Redux Imports
import { store } from "./redux/store";
import { Provider } from "react-redux";

// ** ThemeColors Context

import { ThemeContext } from "./utility/context/ThemeColors";

// ** ThemeConfig
import themeConfig from "./configs/themeConfig";

// ** Toast
import { Toaster } from "react-hot-toast";

// ** Spinner (Splash Screen)
import Spinner from "./@core/components/spinner/Fallback-spinner";

// ** Ripple Button
import "./@core/components/ripple-button";

// ** PrismJS
import "prismjs";
import "prismjs/themes/prism-tomorrow.css";
import "prismjs/components/prism-jsx.min";

// ** React Perfect Scrollbar
import "react-perfect-scrollbar/dist/css/styles.css";

// ** React Hot Toast Styles
import "@styles/react/libs/react-hot-toasts/react-hot-toasts.scss";

// ** Core styles
import "./@core/assets/fonts/feather/iconfont.css";
import "./@core/scss/core.scss";
import "./assets/scss/style.scss";

// ** Service Worker
import * as serviceWorker from "./serviceWorker";
import { Home } from "react-feather";
import { PersistGate } from "redux-persist/integration/react";
import { persistStore } from "redux-persist";
import axios from "axios";

let persistor = persistStore(store);

// ** Lazy load app
const LazyApp = lazy(() => import("./App"));

const container = document.getElementById("root");
const root = createRoot(container);

axios.defaults.baseURL = process.env.REACT_APP_API_URL;

root.render(
  <BrowserRouter>
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <Suspense fallback={<Spinner />}>
          <ThemeContext>
            <LazyApp />
            {/* <Toaster
              position={themeConfig.layout.toastPosition}
              toastOptions={{ className: "react-hot-toast" }}
            /> */}
            <Routes>
              <Route
                element={<Home />}
                path={`${process.env.REACT_APP_FOLDER}/home`}
              />
            </Routes>
          </ThemeContext>
        </Suspense>
      </PersistGate>
    </Provider>
  </BrowserRouter>
);

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();
